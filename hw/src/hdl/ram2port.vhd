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
-- File Name        : ram2port.vhd
-- Targeted device  : Microchip PolarFire SoC
-- Author           : Microchip FPGA Solutions Team
-- Description      : Dual-port RAM module
--=======================================================================================

library ieee;
use ieee.STD_logic_1164.all;
use ieee.NUMERIc_std.all;
use IEEE.std_logic_unsigned.all;

entity ram2PORT is
generic (G_BUFF_AWIDTH: INTEGER := 10;
G_DWIDTH: integer := 64); port (WCLOck_i: in std_logic;
rclock_i: in STD_LOGIC;
WE_i: in STD_LOGIC;
rd_addr_i: in std_logic_vector(G_BUFF_AWIDTH-1 downto 0);
WR_ADDR_I: in std_loGIC_VECTOR(G_BUFF_AWIDTH-1 downto 0);
wr_data_i: in STD_logic_vector(G_DWIDTH-1 downto 0);
RD_DATA_O: out STD_LOGIC_VECtor(G_DWIDTH-1 downto 0));
end RAM2port;

architecture RAM2PORT of ram2port is

type O0II is array ((2**g_buff_awidth)-1 downto 0) of sTD_LOGIC_VECTOR(g_dwidth-1 downto 0);

signal l0ii: std_logiC_VECTOR(g_buff_awidth-1 downto 0);

signal IO1L: o0ii;

attribute SYN_RAMSTYLE: STRING;

attribute syn_raMSTYLE of IO1L: signal is "lsram";

begin
rd_daTA_O <= IO1L(to_integer(UNSIGNED(l0ii)));
i0ii:
process (WCLock_i)
begin
if (RISING_EDGE(wclock_i)) then
if (WE_i = '1') then
IO1L(To_integer(UNSIGNED(wr_addr_i))) <= wr_data_i;
end if;
end if;
end process;
O1ii:
process (RCLOCK_I)
begin
if (rising_edge(RCLOCK_I)) then
L0II <= RD_addr_i;
end if;
end process;
end RAM2PORT;
