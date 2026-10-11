/*=======================================================================================
 Copyright 2021-2026 Microchip FPGA Embedded Systems Solutions.

 SPDX-License-Identifier: MIT

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to
 deal in the Software without restriction, including without limitation the
 rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
 sell copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
 IN THE SOFTWARE.
========================================================================================
 File Name        : ddr_write_controller_mjpeg.v
 Targeted device  : Microchip PolarFire SoC
 Author           : Microchip FPGA Solutions Team
 Description      : DDR write controller with 8-cycle EOF stretch for safe CDC
=======================================================================================*/
module ddr_write_controller_mjpeg #(
    parameter g_DDR_AXI_AWIDTH = 32
) (
    input              reset_i,
    input              sys_clk_i,
    input              wrclk_reset_i,
    input              wrclk_i,
    input      [11:0]  fifo_count_i,
    input              eof_i,
    input              encoder_en_i,
    input              clr_intr_i,
    input              write_ackn_i,
    input              write_done_i,
    input      [9:0]   frame_ddr_addr_i,
    output             fifo_reset_o,
    output reg         wr_done_o,
    output wire        write_req_o,
    output wire        read_fifo_o,
    output wire [1:0]  frame_idx_o,
    output wire [31:0] frame_size_o,
    output wire [g_DDR_AXI_AWIDTH-1:0] write_start_addr_o,
    output wire [7:0]  write_length_o,
    output wire        frm_interrupt_o
);

  //==========================================================================
  // State Machine Parameters
  //==========================================================================
  localparam IDLE             = 2'b00,
             WRITE_REQUESTING = 2'b01,
             WRITING          = 2'b10;

  //==========================================================================
  // Signal Declarations
  //==========================================================================
  reg  [1:0]   s_state;
  reg  [7:0]   s_eof_stretch;      // 8-bit shift register to stretch EOF in wrclk domain
  reg          s_eof_wrclk;        // Stretched EOF signal (OR of all 8 bits)
  reg  [9:0]   s_eof_sync_reg;
  reg          s_eof_reg;
  wire         s_set_eof_reg;
  reg          s_clr_eof_reg;
  reg          s_write_req;
  reg          s_read_fifo;
  wire [g_DDR_AXI_AWIDTH-1:0] s_write_start_addr;
  reg  [8:0]   s_counter;
  reg  [8:0]   s_count_max;
  reg  [19:0]  s_line_counter;
  reg  [1:0]   s_frame_index;
  reg          s_last_data_in_frame;
  reg  [31:0]  s_frame_size;
  reg  [31:0]  s_frame_size_out;
  reg          encoder_en_dly1;

  // Interrupt generation
  reg          s_frm_intr;
  reg  [1:0]   s_clr_intr_r;

  //==========================================================================
  // Output Assignments
  //==========================================================================
  assign write_req_o        = s_write_req;
  assign write_start_addr_o = s_write_start_addr;
  assign write_length_o     = s_count_max - 1'b1;
  assign read_fifo_o        = s_read_fifo;
  assign frame_size_o       = s_frame_size_out;
  assign frame_idx_o        = s_frame_index - 1'b1;
  assign fifo_reset_o       = ~(encoder_en_i & (~encoder_en_dly1));
  assign frm_interrupt_o    = s_frm_intr;
  assign s_write_start_addr = {frame_ddr_addr_i[9:0], s_frame_index, s_line_counter};
  
  // Falling edge detection
  assign s_set_eof_reg      = s_eof_sync_reg[9] & (~s_eof_sync_reg[8]);

  /*------------------------------------------------------------------------
  -- Name       : EOF_SYNC
  -- Description: Stretch EOF to 8 wrclk cycles for safe CDC
  --              Step 1: Shift eof_i through 8-bit register
  --              Step 2: OR all bits to create stretched pulse
  --              This ensures s_eof_wrclk stays HIGH for 8 wrclk cycles
  --              making it safe for sys_clk synchronizer to capture
  ------------------------------------------------------------------------*/
  always @(posedge wrclk_i or negedge wrclk_reset_i) begin
    if (!wrclk_reset_i) begin
      s_eof_stretch <= 8'd0;
      s_eof_wrclk   <= 1'b0;
    end else begin
      s_eof_stretch <= {s_eof_stretch[6:0], eof_i};
      s_eof_wrclk   <= |s_eof_stretch | eof_i;
    end
  end

  /*------------------------------------------------------------------------
  -- Name       : INTR_GEN
  -- Description: Generate/clear frame interrupt
  ------------------------------------------------------------------------*/
  always @(posedge sys_clk_i or negedge reset_i) begin
    if (!reset_i) begin
      s_frm_intr <= 1'b0;
    end else begin
      if (s_clr_eof_reg && encoder_en_i) begin
        if (s_frame_size != 0)
          s_frm_intr <= 1'b1;
      end else if (s_clr_intr_r[1]) begin
        s_frm_intr <= 1'b0;
      end
    end
  end

  /*------------------------------------------------------------------------
  -- Name       : SIGNAL_DELAY
  -- Description: CDC sync for EOF (clean - no async OR)
  ------------------------------------------------------------------------*/
  always @(posedge sys_clk_i or negedge reset_i) begin
    if (!reset_i) begin
      s_eof_sync_reg  <= 10'd0;
      s_eof_reg       <= 1'b0;
      encoder_en_dly1 <= 1'b0;
      s_clr_intr_r    <= 2'b00;
    end else begin
      s_eof_sync_reg  <= {s_eof_sync_reg[8:0], s_eof_wrclk};
      encoder_en_dly1 <= encoder_en_i;
      s_clr_intr_r    <= {s_clr_intr_r[0], clr_intr_i};
      
      if (s_set_eof_reg)
        s_eof_reg <= 1'b1;
      else if (s_clr_eof_reg)
        s_eof_reg <= 1'b0;
    end
  end

  /*------------------------------------------------------------------------
  -- Name       : WRITE_FSM_PROC
  -- Description: FSM implements write operations to DDR
  ------------------------------------------------------------------------*/
  always @(posedge sys_clk_i or negedge reset_i) begin
    if (!reset_i) begin
      s_state              <= IDLE;
      s_write_req          <= 1'b0;
      s_read_fifo          <= 1'b0;
      s_count_max          <= 9'd0;
      s_counter            <= 9'd0;
      s_frame_index        <= 2'd0;
      s_line_counter       <= 20'd0;
      s_last_data_in_frame <= 1'b0;
      s_clr_eof_reg        <= 1'b0;
      s_frame_size         <= 32'd0;
      s_frame_size_out     <= 32'd0;
      wr_done_o            <= 1'b0;
    end else begin
      case (s_state)
        IDLE: begin
          s_write_req   <= 1'b0;
          s_read_fifo   <= 1'b0;
          s_counter     <= 9'd0;
          s_clr_eof_reg <= s_eof_reg && (fifo_count_i == 0) && !s_clr_eof_reg;
          
          if (s_clr_eof_reg && encoder_en_i) begin
            wr_done_o        <= 1'b1;
            s_frame_index    <= s_frame_index + 1'b1;
            s_frame_size_out <= s_frame_size;
            s_frame_size     <= 32'd0;
            s_line_counter   <= 20'd0;
          end else if (encoder_en_i == 1'b0) begin
            wr_done_o        <= 1'b0;
            s_frame_size     <= 32'd0;
            s_frame_size_out <= 32'd0;
            s_line_counter   <= 20'd0;
            s_frame_index    <= 2'd0;
          end
          
          if (!s_clr_eof_reg && ((s_eof_reg && (|fifo_count_i)) || (|fifo_count_i[11:4]))) begin
            if (fifo_count_i > 256)
              s_count_max <= 9'd256;
            else
              s_count_max <= fifo_count_i[8:0];
            s_state              <= WRITE_REQUESTING;
            s_last_data_in_frame <= s_eof_reg;
          end
        end

        WRITE_REQUESTING: begin
          if (write_ackn_i) begin
            s_write_req <= 1'b0;
            s_state     <= WRITING;
          end else begin
            s_write_req <= 1'b1;
          end
        end

        WRITING: begin
          if (write_done_i) begin
            s_read_fifo    <= 1'b0;
            s_state        <= IDLE;
            s_clr_eof_reg  <= s_last_data_in_frame;
            s_line_counter <= s_line_counter + {s_count_max, 3'b000};
            s_frame_size   <= s_frame_size + {s_count_max, 3'b000};
          end else if (s_counter >= s_count_max) begin
            s_read_fifo <= 1'b0;
          end else begin
            s_counter   <= s_counter + 1'b1;
            s_read_fifo <= 1'b1;
          end
        end

        default: s_state <= IDLE;
      endcase
    end
  end

endmodule
