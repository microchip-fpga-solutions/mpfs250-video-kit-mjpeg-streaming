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
-- File Name        : apb_wrapper.vhd
-- Targeted device  : Microchip PolarFire SoC
-- Author           : Microchip FPGA Solutions Team
--=======================================================================================

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

--=================================================================================================
-- apb3_if entity declaration
--=================================================================================================
entity apb3_if is
  generic (
    g_APB3_IF_DATA_WIDTH : integer := 32;
    g_CONST_WIDTH        : integer := 12
    );
  port (
    -- APB reset
    preset_i  : in std_logic;
    -- APB clock
    pclk_i    : in std_logic;

    -- APB slave interface
    psel_i    : in  std_logic;
    pwrite_i  : in  std_logic;
    penable_i : in  std_logic;
    paddr_i   : in  std_logic_vector(g_APB3_IF_DATA_WIDTH-1 downto 0);
    pwdata_i  : in  std_logic_vector(g_APB3_IF_DATA_WIDTH-1 downto 0);
    pready_o  : out std_logic;
    pslverr_o : out std_logic;
    prdata_o  : out std_logic_vector(g_APB3_IF_DATA_WIDTH-1 downto 0);
    
    -- Frame valid from camera
    frame_valid_i : in std_logic;

    -- Status inputs
    r_gain_i      : in std_logic_vector(7 downto 0);
    g_gain_i      : in std_logic_vector(7 downto 0);
    b_gain_i      : in std_logic_vector(7 downto 0);
    brightness_i  : in std_logic_vector(7 downto 0);
    contrast_i    : in std_logic_vector(7 downto 0);
    quality_i     : in std_logic_vector(7 downto 0);
    RGB_SUM_i     : in std_logic_vector(31 downto 0);
    frame_index_i : in std_logic_vector(1 downto 0);
    frame_bytes_i : in std_logic_vector(31 downto 0);

    -- Configuration outputs
    mode_o         : out std_logic;
    alpha_o        : out std_logic_vector(7 downto 0);
    step_o         : out std_logic_vector(7 downto 0);
    rconst_o       : out std_logic_vector(9 downto 0);
    gconst_o       : out std_logic_vector(9 downto 0);
    bconst_o       : out std_logic_vector(9 downto 0);
    second_const_o : out std_logic_vector(19 downto 0);
    horiz_resl_o   : out std_logic_vector(15 downto 0);
    vert_resl_o    : out std_logic_vector(15 downto 0);
    quality_o      : out std_logic_vector(7 downto 0);
    frame_tcount_o : out std_logic_vector(3 downto 0);
    
    -- JPEG encoder control
    JPEG_en_o          : out std_logic;
    JPEG_ddrlsb_addr_o : out std_logic_vector(31 downto 0);
    JPEG_clr_intr_o    : out std_logic;
    
    -- CCM Coefficients (3x3 matrix) - 16-bit signed
    ccm_coef_m11_o : out std_logic_vector(15 downto 0);
    ccm_coef_m12_o : out std_logic_vector(15 downto 0);
    ccm_coef_m13_o : out std_logic_vector(15 downto 0);
    ccm_coef_m21_o : out std_logic_vector(15 downto 0);
    ccm_coef_m22_o : out std_logic_vector(15 downto 0);
    ccm_coef_m23_o : out std_logic_vector(15 downto 0);
    ccm_coef_m31_o : out std_logic_vector(15 downto 0);
    ccm_coef_m32_o : out std_logic_vector(15 downto 0);
    ccm_coef_m33_o : out std_logic_vector(15 downto 0);
    
    -- CCM Offsets - 16-bit signed
    ccm_coef_o1_o  : out std_logic_vector(15 downto 0);
    ccm_coef_o2_o  : out std_logic_vector(15 downto 0);
    ccm_coef_o3_o  : out std_logic_vector(15 downto 0)
    );
end apb3_if;

--=================================================================================================
-- apb3_if architecture body
--=================================================================================================
architecture apb3_if of apb3_if is

--=================================================================================================
-- Signal declarations
--=================================================================================================
  -- Existing Register Addresses
  constant C_ALPHA_REG_ADDR    : std_logic_vector(g_CONST_WIDTH-1 downto 0) := x"000";
  constant C_RCONST_REG_ADDR   : std_logic_vector(g_CONST_WIDTH-1 downto 0) := x"004";
  constant C_GCONST_REG_ADDR   : std_logic_vector(g_CONST_WIDTH-1 downto 0) := x"008";
  constant C_BCONST_REG_ADDR   : std_logic_vector(g_CONST_WIDTH-1 downto 0) := x"00C";
  constant C_SECOND_CONST_ADDR : std_logic_vector(g_CONST_WIDTH-1 downto 0) := x"010";
  constant C_RGAIN_ADDR        : std_logic_vector(g_CONST_WIDTH-1 downto 0) := x"020";
  constant C_GGAIN_ADDR        : std_logic_vector(g_CONST_WIDTH-1 downto 0) := x"024";
  constant C_BGAIN_ADDR        : std_logic_vector(g_CONST_WIDTH-1 downto 0) := x"028";
  constant C_CONTRAST_ADDR     : std_logic_vector(g_CONST_WIDTH-1 downto 0) := x"030";
  constant C_BRIGHTNESS_ADDR   : std_logic_vector(g_CONST_WIDTH-1 downto 0) := x"034";
  constant C_RGB_SUM_ADDR      : std_logic_vector(g_CONST_WIDTH-1 downto 0) := x"038";

  constant C_STEP_OUT_ADDR     : std_logic_vector(g_CONST_WIDTH-1 downto 0) := x"060";
  constant C_MODE_OUT_ADDR     : std_logic_vector(g_CONST_WIDTH-1 downto 0) := x"064";
  constant C_FRAME_TCOUNT_ADDR : std_logic_vector(g_CONST_WIDTH-1 downto 0) := x"070";
  constant C_QUALITY_ADDR      : std_logic_vector(g_CONST_WIDTH-1 downto 0) := x"074";
  constant C_HORIZ_RESL_ADDR   : std_logic_vector(g_CONST_WIDTH-1 downto 0) := x"078";
  constant C_VERT_RESL_ADDR    : std_logic_vector(g_CONST_WIDTH-1 downto 0) := x"07C";
  
  -- JPEG registers
  constant C_FRM_BYTES_ADDR    : std_logic_vector(g_CONST_WIDTH-1 downto 0) := x"080";
  constant C_JPEGSTART_ADDR    : std_logic_vector(g_CONST_WIDTH-1 downto 0) := x"084";
  constant C_JPEGDDRLSB_ADDR   : std_logic_vector(g_CONST_WIDTH-1 downto 0) := x"088";
  constant C_JPEGDDRMSB_ADDR   : std_logic_vector(g_CONST_WIDTH-1 downto 0) := x"08C";

  -- CCM Coefficient Addresses (0x100 - 0x12C)
  constant C_CCM_M11_ADDR      : std_logic_vector(g_CONST_WIDTH-1 downto 0) := x"100";
  constant C_CCM_M12_ADDR      : std_logic_vector(g_CONST_WIDTH-1 downto 0) := x"104";
  constant C_CCM_M13_ADDR      : std_logic_vector(g_CONST_WIDTH-1 downto 0) := x"108";
  constant C_CCM_M21_ADDR      : std_logic_vector(g_CONST_WIDTH-1 downto 0) := x"10C";
  constant C_CCM_M22_ADDR      : std_logic_vector(g_CONST_WIDTH-1 downto 0) := x"110";
  constant C_CCM_M23_ADDR      : std_logic_vector(g_CONST_WIDTH-1 downto 0) := x"114";
  constant C_CCM_M31_ADDR      : std_logic_vector(g_CONST_WIDTH-1 downto 0) := x"118";
  constant C_CCM_M32_ADDR      : std_logic_vector(g_CONST_WIDTH-1 downto 0) := x"11C";
  constant C_CCM_M33_ADDR      : std_logic_vector(g_CONST_WIDTH-1 downto 0) := x"120";
  
  -- CCM Offset Addresses (0x130 - 0x138)
  constant C_CCM_O1_ADDR       : std_logic_vector(g_CONST_WIDTH-1 downto 0) := x"130";
  constant C_CCM_O2_ADDR       : std_logic_vector(g_CONST_WIDTH-1 downto 0) := x"134";
  constant C_CCM_O3_ADDR       : std_logic_vector(g_CONST_WIDTH-1 downto 0) := x"138";

  constant C_ID_ROM_3_0_ADDR   : std_logic_vector(g_CONST_WIDTH-1 downto 0) := x"500";
  constant C_ID_ROM_7_4_ADDR   : std_logic_vector(g_CONST_WIDTH-1 downto 0) := x"504";
  
  signal s_frame_valid_dly1 : std_logic;
  signal s_frame_valid_re   : std_logic;
  signal s_horiz_resl       : std_logic_vector(15 downto 0);
  signal s_vert_resl        : std_logic_vector(15 downto 0);

  -- CCM coefficient registers
  signal s_ccm_m11 : std_logic_vector(15 downto 0);
  signal s_ccm_m12 : std_logic_vector(15 downto 0);
  signal s_ccm_m13 : std_logic_vector(15 downto 0);
  signal s_ccm_m21 : std_logic_vector(15 downto 0);
  signal s_ccm_m22 : std_logic_vector(15 downto 0);
  signal s_ccm_m23 : std_logic_vector(15 downto 0);
  signal s_ccm_m31 : std_logic_vector(15 downto 0);
  signal s_ccm_m32 : std_logic_vector(15 downto 0);
  signal s_ccm_m33 : std_logic_vector(15 downto 0);
  signal s_ccm_o1  : std_logic_vector(15 downto 0);
  signal s_ccm_o2  : std_logic_vector(15 downto 0);
  signal s_ccm_o3  : std_logic_vector(15 downto 0);

  -- Signature for MJPEG+CCM
  signal s_signature : std_logic_vector(63 downto 0) := x"4D_4A_50_47_43_43_4D_31";  -- "MJPGCCM1"
  
begin

--=================================================================================================
-- Top level output port assignments
--=================================================================================================
  pready_o  <= '1';
  pslverr_o <= '0';
  
  -- CCM output assignments
  ccm_coef_m11_o <= s_ccm_m11;
  ccm_coef_m12_o <= s_ccm_m12;
  ccm_coef_m13_o <= s_ccm_m13;
  ccm_coef_m21_o <= s_ccm_m21;
  ccm_coef_m22_o <= s_ccm_m22;
  ccm_coef_m23_o <= s_ccm_m23;
  ccm_coef_m31_o <= s_ccm_m31;
  ccm_coef_m32_o <= s_ccm_m32;
  ccm_coef_m33_o <= s_ccm_m33;
  ccm_coef_o1_o  <= s_ccm_o1;
  ccm_coef_o2_o  <= s_ccm_o2;
  ccm_coef_o3_o  <= s_ccm_o3;

--=================================================================================================
-- Asynchronous blocks
--=================================================================================================
  s_frame_valid_re <= frame_valid_i AND (NOT s_frame_valid_dly1);

--------------------------------------------------------------------------
-- Name       : READ_DECODE_PROC
-- Description: Process implements the APB read operation
--------------------------------------------------------------------------
  READ_DECODE_PROC :
  process (paddr_i, r_gain_i, g_gain_i, b_gain_i, contrast_i, brightness_i, 
           quality_i, RGB_SUM_i, rconst_o, s_horiz_resl, s_vert_resl, 
           frame_index_i, frame_bytes_i, s_signature,
           s_ccm_m11, s_ccm_m12, s_ccm_m13, s_ccm_m21, s_ccm_m22, s_ccm_m23,
           s_ccm_m31, s_ccm_m32, s_ccm_m33, s_ccm_o1, s_ccm_o2, s_ccm_o3)
  begin
    case paddr_i(11 downto 0) is
      when C_RCONST_REG_ADDR =>
        prdata_o(9 downto 0) <= rconst_o;
        prdata_o(g_APB3_IF_DATA_WIDTH-1 downto 10) <= (others => '0');

      when C_RGAIN_ADDR =>
        prdata_o(7 downto 0) <= r_gain_i;
        prdata_o(g_APB3_IF_DATA_WIDTH-1 downto 8) <= (others => '0');

      when C_GGAIN_ADDR =>
        prdata_o(7 downto 0) <= g_gain_i;
        prdata_o(g_APB3_IF_DATA_WIDTH-1 downto 8) <= (others => '0');

      when C_BGAIN_ADDR =>
        prdata_o(7 downto 0) <= b_gain_i;
        prdata_o(g_APB3_IF_DATA_WIDTH-1 downto 8) <= (others => '0');

      when C_CONTRAST_ADDR =>
        prdata_o(7 downto 0) <= contrast_i;
        prdata_o(g_APB3_IF_DATA_WIDTH-1 downto 8) <= (others => '0');

      when C_BRIGHTNESS_ADDR =>
        prdata_o(7 downto 0) <= brightness_i;
        prdata_o(g_APB3_IF_DATA_WIDTH-1 downto 8) <= (others => '0');

      when C_RGB_SUM_ADDR =>
        prdata_o(31 downto 0) <= RGB_SUM_i;

      when C_QUALITY_ADDR =>
        prdata_o(7 downto 0) <= quality_i;
        prdata_o(g_APB3_IF_DATA_WIDTH-1 downto 8) <= (others => '0');
          
      when C_FRM_BYTES_ADDR =>
        prdata_o(g_APB3_IF_DATA_WIDTH-1 downto 0) <= "00" & frame_index_i & frame_bytes_i(27 downto 0);                  

      -- CCM Coefficient Read
      when C_CCM_M11_ADDR =>
        prdata_o(15 downto 0) <= s_ccm_m11;
        prdata_o(g_APB3_IF_DATA_WIDTH-1 downto 16) <= (others => '0');
      when C_CCM_M12_ADDR =>
        prdata_o(15 downto 0) <= s_ccm_m12;
        prdata_o(g_APB3_IF_DATA_WIDTH-1 downto 16) <= (others => '0');
      when C_CCM_M13_ADDR =>
        prdata_o(15 downto 0) <= s_ccm_m13;
        prdata_o(g_APB3_IF_DATA_WIDTH-1 downto 16) <= (others => '0');
      when C_CCM_M21_ADDR =>
        prdata_o(15 downto 0) <= s_ccm_m21;
        prdata_o(g_APB3_IF_DATA_WIDTH-1 downto 16) <= (others => '0');
      when C_CCM_M22_ADDR =>
        prdata_o(15 downto 0) <= s_ccm_m22;
        prdata_o(g_APB3_IF_DATA_WIDTH-1 downto 16) <= (others => '0');
      when C_CCM_M23_ADDR =>
        prdata_o(15 downto 0) <= s_ccm_m23;
        prdata_o(g_APB3_IF_DATA_WIDTH-1 downto 16) <= (others => '0');
      when C_CCM_M31_ADDR =>
        prdata_o(15 downto 0) <= s_ccm_m31;
        prdata_o(g_APB3_IF_DATA_WIDTH-1 downto 16) <= (others => '0');
      when C_CCM_M32_ADDR =>
        prdata_o(15 downto 0) <= s_ccm_m32;
        prdata_o(g_APB3_IF_DATA_WIDTH-1 downto 16) <= (others => '0');
      when C_CCM_M33_ADDR =>
        prdata_o(15 downto 0) <= s_ccm_m33;
        prdata_o(g_APB3_IF_DATA_WIDTH-1 downto 16) <= (others => '0');
        
      -- CCM Offset Read
      when C_CCM_O1_ADDR =>
        prdata_o(15 downto 0) <= s_ccm_o1;
        prdata_o(g_APB3_IF_DATA_WIDTH-1 downto 16) <= (others => '0');
      when C_CCM_O2_ADDR =>
        prdata_o(15 downto 0) <= s_ccm_o2;
        prdata_o(g_APB3_IF_DATA_WIDTH-1 downto 16) <= (others => '0');
      when C_CCM_O3_ADDR =>
        prdata_o(15 downto 0) <= s_ccm_o3;
        prdata_o(g_APB3_IF_DATA_WIDTH-1 downto 16) <= (others => '0');

      when C_ID_ROM_3_0_ADDR =>
        prdata_o(g_APB3_IF_DATA_WIDTH-1 downto 0) <= s_signature(63 downto 32);

      when C_ID_ROM_7_4_ADDR =>
        prdata_o(g_APB3_IF_DATA_WIDTH-1 downto 0) <= s_signature(31 downto 0);                         

      when others =>
        prdata_o <= (others => '0');
    end case;
  end process;

--=================================================================================================
-- Synchronous blocks
--=================================================================================================

--------------------------------------------------------------------------
-- Name       : JPEG_CLR_INTR_PROC
-- Description: Process to clear JPEG interrupt
--------------------------------------------------------------------------
  JPEG_CLR_INTR_PROC :
  process (preset_i, pclk_i)
  begin
    if (preset_i = '0') then
      JPEG_clr_intr_o <= '0';
    elsif (pclk_i'event and pclk_i = '1') then
      if ((psel_i = '1') and (penable_i = '1') and (pwrite_i = '0')) then  
        if (paddr_i(11 downto 0) = C_FRM_BYTES_ADDR) then
          JPEG_clr_intr_o <= '1';
        end if;
      else
        JPEG_clr_intr_o <= '0';
      end if;  
    end if;
  end process;

--------------------------------------------------------------------------
-- Name       : WRITE_DECODE_PROC
-- Description: Process implements the APB write operation
--------------------------------------------------------------------------
  WRITE_DECODE_PROC :
  process (preset_i, pclk_i)
  begin
    if (preset_i = '0') then
      alpha_o            <= x"FF";
      rconst_o           <= "00" & x"7A";
      gconst_o           <= "00" & x"66";
      bconst_o           <= "00" & x"8A";
      step_o             <= x"01";
      mode_o             <= '1';
      second_const_o     <= (others => '0');
      s_horiz_resl       <= x"0780";
      s_vert_resl        <= x"0438";
      quality_o          <= x"1E";
      JPEG_ddrlsb_addr_o <= x"88000000";
      JPEG_en_o          <= '0';
      -- CCM Default: Identity (pass-through for debugging)
      -- Format: 8.8 fixed point (256 = 1.0), signed 16-bit
      s_ccm_m11          <= x"0100";  -- 1.0 (R pass-through)
      s_ccm_m12          <= x"0000";  -- 0
      s_ccm_m13          <= x"0000";  -- 0
      s_ccm_m21          <= x"0000";  -- 0
      s_ccm_m22          <= x"0100";  -- 1.0 (G pass-through)
      s_ccm_m23          <= x"0000";  -- 0
      s_ccm_m31          <= x"0000";  -- 0
      s_ccm_m32          <= x"0000";  -- 0
      s_ccm_m33          <= x"0100";  -- 1.0 (B pass-through)
      s_ccm_o1           <= x"FFF6";  -- 0
      s_ccm_o2           <= x"0000";  -- 0
      s_ccm_o3           <= x"0000";  -- 0


    elsif (pclk_i'event and pclk_i = '1') then
      if ((psel_i = '1') and (pwrite_i = '1') and (penable_i = '1')) then
        case paddr_i(11 downto 0) is
          when C_RCONST_REG_ADDR =>
            rconst_o <= pwdata_i(9 downto 0);

          when C_ALPHA_REG_ADDR =>
            alpha_o <= pwdata_i(7 downto 0);

          when C_GCONST_REG_ADDR =>
            gconst_o <= pwdata_i(9 downto 0);

          when C_BCONST_REG_ADDR =>
            bconst_o <= pwdata_i(9 downto 0);

          when C_SECOND_CONST_ADDR =>
            second_const_o <= pwdata_i(19 downto 0);

          when C_STEP_OUT_ADDR =>
            step_o <= pwdata_i(7 downto 0);

          when C_MODE_OUT_ADDR =>
            mode_o <= pwdata_i(0);

          when C_FRAME_TCOUNT_ADDR =>
            frame_tcount_o <= pwdata_i(3 downto 0);

          when C_QUALITY_ADDR =>
            quality_o <= pwdata_i(7 downto 0);

          when C_HORIZ_RESL_ADDR =>
            s_horiz_resl <= pwdata_i(15 downto 0);

          when C_VERT_RESL_ADDR =>
            s_vert_resl <= pwdata_i(15 downto 0);

          when C_JPEGSTART_ADDR =>
            JPEG_en_o <= pwdata_i(0);

          when C_JPEGDDRLSB_ADDR =>
            JPEG_ddrlsb_addr_o <= pwdata_i;

          -- CCM Coefficient Write
          when C_CCM_M11_ADDR =>
            s_ccm_m11 <= pwdata_i(15 downto 0);
          when C_CCM_M12_ADDR =>
            s_ccm_m12 <= pwdata_i(15 downto 0);
          when C_CCM_M13_ADDR =>
            s_ccm_m13 <= pwdata_i(15 downto 0);
          when C_CCM_M21_ADDR =>
            s_ccm_m21 <= pwdata_i(15 downto 0);
          when C_CCM_M22_ADDR =>
            s_ccm_m22 <= pwdata_i(15 downto 0);
          when C_CCM_M23_ADDR =>
            s_ccm_m23 <= pwdata_i(15 downto 0);
          when C_CCM_M31_ADDR =>
            s_ccm_m31 <= pwdata_i(15 downto 0);
          when C_CCM_M32_ADDR =>
            s_ccm_m32 <= pwdata_i(15 downto 0);
          when C_CCM_M33_ADDR =>
            s_ccm_m33 <= pwdata_i(15 downto 0);
            
          -- CCM Offset Write
          when C_CCM_O1_ADDR =>
            s_ccm_o1 <= pwdata_i(15 downto 0);
          when C_CCM_O2_ADDR =>
            s_ccm_o2 <= pwdata_i(15 downto 0);
          when C_CCM_O3_ADDR =>
            s_ccm_o3 <= pwdata_i(15 downto 0);

          when others =>
            null;
        end case;
      end if;
    end if;
  end process;

--------------------------------------------------------------------------
-- Name       : DLY_PROC
-- Description: Process to delay the signals
--------------------------------------------------------------------------
  DLY_PROC :
  process (preset_i, pclk_i)
  begin
    if (preset_i = '0') then
      s_frame_valid_dly1 <= '0';
      horiz_resl_o       <= x"0780";
      vert_resl_o        <= x"0438";
    elsif (pclk_i'event and pclk_i = '1') then
      s_frame_valid_dly1 <= frame_valid_i;
      if (s_frame_valid_re = '1') then
        horiz_resl_o <= s_horiz_resl;
        vert_resl_o  <= s_vert_resl;
      end if;  
    end if;
  end process;  

end architecture apb3_if;
