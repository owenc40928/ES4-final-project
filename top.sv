// Top-level module for ES4 lab 7 in SystemVerilog
// 27 August 2025
// Isaac Medina  | TA

/* PIN MAPPINGS for Upduino FPGA:
   
   Inputs:
    Connect the "12M" pin on the Upduino to pin 20
    clk_12M --> 20

   Outputs:
    HSYNC  --> 25
    VSYNC  --> 23
    RGB[0] --> 26
    RGB[1] --> 27
    RGB[2] --> 32
    RGB[3] --> 35
    RGB[4] --> 31
    RGB[5] --> 37


*/

module top (
    input  logic       clk_12M,
    input logic start,
    input logic reset,
    input logic donato,
    output logic       HSYNC,
    output logic       VSYNC,
    output logic [5:0] RGB
);

    // Intermediate signals
    logic       pll_clk;
    logic       DISPLAY_ENABLE;
    logic [9:0] ROW, COLUMN;

    // PLL instance
    mypll mypll_inst(
        .ref_clk_i(clk_12M),
        .rst_n_i(1'b1),
        .outcore_o(),       // not used
        .outglobal_o(pll_clk)
    );

    // VGA instance
    vga vga_inst(
        .pixel_clk(pll_clk),
        .hsync(HSYNC),
        .vsync(VSYNC),
        .display_enable(DISPLAY_ENABLE),
        .row(ROW),
        .column(COLUMN)
    );

    // Pattern generator instance
    patterngen patterngen_inst(
        .CLK(pll_clk),
        .Row(ROW),
        .Col(COLUMN),
        .display_on(DISPLAY_ENABLE),
        .rgb_patterngen(RGB),
        .instart(start),
        .reset(reset),
        .donato(donato)
    );

endmodule