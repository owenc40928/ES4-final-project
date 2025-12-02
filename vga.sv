// VGA module for ES4 lab 7 in SystemVerilog
// 27 August 2025
// Isaac Medina  | TA

module vga(
    input  logic pixel_clk,
    output logic hsync,
    output logic vsync,
    output logic display_enable,
    output logic [9:0] row,
    output logic [9:0] column
);

    // VGA timing parameters
    localparam int H_VISIBLE_AREA = 640;
    localparam int H_FRONT_PORCH  = 16;
    localparam int H_SYNC_PULSE   = 96;
    localparam int H_BACK_PORCH   = 48;
    localparam int H_WHOLE_LINE   = 800;

    localparam int V_VISIBLE_AREA = 480;
    localparam int V_FRONT_PORCH  = 10;
    localparam int V_SYNC_PULSE   = 2;
    localparam int V_BACK_PORCH   = 33;
    localparam int V_WHOLE_FRAME  = 525;

    int column_count = 0;
    int row_count    = 0;

    always_ff @(posedge pixel_clk) begin
        if (column_count == H_WHOLE_LINE - 1) begin
            column_count <= 0;
            if (row_count == V_WHOLE_FRAME - 1)
                row_count <= 0;
            else
                row_count <= row_count + 1;
        end else begin
            column_count <= column_count + 1;
        end
    end

    // HSYNC and VSYNC
    assign hsync = (column_count >= H_VISIBLE_AREA + H_FRONT_PORCH &&
                    column_count < H_VISIBLE_AREA + H_FRONT_PORCH + H_SYNC_PULSE) ? 1'b0 : 1'b1;

    assign vsync = (row_count >= V_VISIBLE_AREA + V_FRONT_PORCH &&
                    row_count < V_VISIBLE_AREA + V_FRONT_PORCH + V_SYNC_PULSE) ? 1'b0 : 1'b1;

    assign display_enable = (column_count < H_VISIBLE_AREA && row_count < V_VISIBLE_AREA) ? 1'b1 : 1'b0;

    assign column = column_count;
    assign row    = row_count;

endmodule