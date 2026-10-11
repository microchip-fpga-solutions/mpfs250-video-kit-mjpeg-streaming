--=======================================================================================
-- Copyright 2021-2026 Microchip FPGA Embedded Systems Solutions.
--
-- SPDX-License-Identifier: MIT
--
-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to
-- deal in the Software without restriction, including without limitation the
-- rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
-- sell copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:
--
-- The above copyright notice and this permission notice shall be included in
-- all copies or substantial portions of the Software.
--
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
-- FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
-- IN THE SOFTWARE.
--=======================================================================================
-- File Name        : data_packer_mjpeg.vhd
-- Targeted device  : Microchip PolarFire SoC
-- Author           : Microchip FPGA Solutions Team
--=======================================================================================

--=================================================================================================
-- Libraries
--=================================================================================================
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.math_real."ceil";
use IEEE.math_real."log2";
--=================================================================================================
-- data_packer_mjpeg entity declaration
--=================================================================================================
entity data_packer_mjpeg is
  generic(
-- Generic list
    g_IP_DW          : integer := 64; -- input data width should be powers of 2
    g_OP_DW          : integer := 64   -- output data width 
    );
  port(
-- Port list
    -- System reset
    reset_i : in std_logic;

    -- System clock
    sys_clk_i : in std_logic;

    -- enable
    data_valid_i : in std_logic;

    --Frame end input
    frame_end_i : in std_logic;

    -- Data Input
    data_i : in std_logic_vector(g_IP_DW-1 downto 0);

    -- Data Enable
    data_valid_o : out std_logic;

    -- Start DDR write
    start_ddr_w_o : out std_logic;

    --burst length
    s_wlen_o : out std_logic_vector(7 downto 0);

    -- Data output
    data_o : out std_logic_vector(g_OP_DW-1 downto 0)

    );
end data_packer_mjpeg;

--=================================================================================================
-- data_packer_mjpeg architecture body
--=================================================================================================

architecture data_packer_mjpeg of data_packer_mjpeg is

--=================================================================================================
-- Component declarations
--=================================================================================================
--NA--
--=================================================================================================
-- Synthesis Attributes
--=================================================================================================
--NA--
--=================================================================================================
-- Signal declarations
--=================================================================================================
  --CONSTANT C_MC             : INTEGER := g_OP_DW / g_IP_DW;--max count
  --CONSTANT C_CW             : INTEGER := integer(ceil(log2(real(C_MC))));--counter width
  CONSTANT C_MAX_WLEN       : INTEGER := 32;--max burst length/ number of data valids
  --TYPE DATA_ARRAY IS ARRAY (0 to C_MC-1) OF STD_LOGIC_VECTOR(g_IP_DW-1 DOWNTO 0);
  --signal s_data_arr	        : DATA_ARRAY;
  --signal s_counter          : std_logic_vector(C_CW-1 downto 0); -- input data count
  --signal s_data_pack        : std_logic_vector(g_OP_DW-1 downto 0);  
  signal s_h_count          : std_logic_vector(7 downto 0); -- outpt data count
  signal s_wlen             : std_logic_vector(7 downto 0);
  signal s_frame_end_sr     : std_logic_vector(5 downto 0);  
  signal s_frame_end_re     : std_logic;
  signal s_frame_end_re_dly : std_logic;
  --signal s_buf_wr_done_dly1 : std_logic;
  --signal s_buf_wr_done_dly2 : std_logic;  
  signal s_wstrt            : std_logic;
  signal s_wstrt_ctr_en     : std_logic;
  signal s_wstrt_ctr        : std_logic_vector(2 downto 0);
  signal s_ddr_start        : std_logic;
  --signal s_ones             : std_logic_vector(C_CW-1 downto 0);

begin

--=================================================================================================
-- Top level output port assignments
--=================================================================================================  
  --data_o        <= s_data_pack;
  data_o        <= data_i(7  downto 0) &
                   data_i(15 downto 8) &
                   data_i(23 downto 16)&
                   data_i(31 downto 24)&
                   data_i(39 downto 32)&
                   data_i(47 downto 40)&
                   data_i(55 downto 48)&
                   data_i(63 downto 56) ;
  data_valid_o  <= data_valid_i;
  s_wlen_o      <= s_wlen;
  start_ddr_w_o <= s_ddr_start;
--=================================================================================================
-- Generate blocks
--=================================================================================================

--=================================================================================================
-- Asynchronous blocks
--=================================================================================================
  s_frame_end_re <= s_frame_end_sr(4) and not(s_frame_end_sr(5));
  --s_ones         <= (others => '1');
--=================================================================================================
-- Synchronous blocks
--=================================================================================================

--------------------------------------------------------------------------
-- Name       : DELAY
-- Description: Process delays input signals
--------------------------------------------------------------------------
  DELAY :
  process(SYS_CLK_I, RESET_I)
  begin
    if RESET_I = '0' then
      s_frame_end_sr <= (others => '0');
      s_frame_end_re_dly <= '0';
    elsif rising_edge(SYS_CLK_I) then
      s_frame_end_sr     <= s_frame_end_sr(4 downto 0) & frame_end_i;
      s_frame_end_re_dly <= s_frame_end_re;
    end if;
  end process;

--------------------------------------------------------------------------
-- Name       : H_COUNTER
-- Description: Counter to count horizontal pixels
--------------------------------------------------------------------------
  H_COUNTER :
  process(SYS_CLK_I, RESET_I)
  begin
    if RESET_I = '0' then
      s_h_count <= (others => '0');
    elsif rising_edge(SYS_CLK_I) then      
      if(s_h_count = C_MAX_WLEN OR s_frame_end_re_dly = '1') then
        if (data_valid_i = '1') then
          s_h_count <= x"01";
        else  
          s_h_count <= (others => '0');
        end if;  
      elsif(data_valid_i = '1')then 
        s_h_count <= s_h_count + '1';  
      end if;
    end if;
  end process;

--------------------------------------------------------------------------
-- Name       : WLEN_PROC
-- Description: Process latches s_h_count
--------------------------------------------------------------------------
  WLEN_PROC :
  process(SYS_CLK_I, RESET_I)
  begin
    if RESET_I = '0' then
      s_wlen  <= (others => '0');
      s_wstrt <= '0';
    elsif rising_edge(SYS_CLK_I) then
      if (s_frame_end_re = '1' AND s_h_count /= 0) then
        s_wlen    <= s_h_count;
        s_wstrt   <= '1';      
      elsif(s_h_count = C_MAX_WLEN)then
        s_wlen    <= std_logic_vector(to_unsigned(C_MAX_WLEN,8)); 
        s_wstrt   <= '1'; 
      else
        s_wstrt   <= '0';  
      end if;
    end if;
  end process;

--------------------------------------------------------------------------
-- Name       : DATA_VALID_FE_COUNTER
-- Description: PROCESS to extend data_valid falling edge signal to 4 clock cycles
--------------------------------------------------------------------------
  DATA_VALID_FE_COUNTER :
  process(SYS_CLK_I, RESET_I)
  begin
    if RESET_I = '0' then
      s_wstrt_ctr      <= (others => '0');
      s_wstrt_ctr_en   <= '0';
      s_ddr_start <= '0';
    elsif rising_edge(SYS_CLK_I) then
      if(s_wstrt = '1')then
        s_wstrt_ctr_en   <= '1';
        s_ddr_start <= '1';
      elsif(s_wstrt_ctr = x"4")then
        s_wstrt_ctr_en   <= '0';
        s_ddr_start <= '0';
      end if;
      
      if(s_wstrt_ctr_en = '1')then
        s_wstrt_ctr <= s_wstrt_ctr + '1';
      else
        s_wstrt_ctr <= (others => '0');
      end if;

    end if;
  end process;
 
--=================================================================================================
-- Component Instantiations
--=================================================================================================
--NA--
end data_packer_mjpeg;
