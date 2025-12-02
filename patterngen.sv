// Patterngen module for ES4 lab 7 in SystemVerilog 
// 27 August 2025
// Isaac Medina  | TA

// This is a simple half blue, half white screen. Student may choose to do more
// technically challenge patterngen implimentations during the lab.

module patterngen(
    input  logic CLK,
    input  logic [9:0] Row,
    input  logic [9:0] Col,
    input  logic display_on,
    output logic [5:0] rgb_patterngen
);

logic [9:0] y_moving0;
logic [9:0] y_moving1;
logic [9:0] y_moving2;
logic [9:0] y_moving3;




logic sixtyHz;
assign sixtyHz = (Row == 486) ? 1'b1 : 1'b0;

always_ff @(posedge sixtyHz) begin
    if (Row == 0) y_moving0 <= 0 ;

    if (y_moving0 == 480) 
        y_moving0 <= 0;
    else
        y_moving0 <= y_moving0 + 1;
end

always_ff @(posedge sixtyHz) begin
    if (Row == 125) y_moving1 <= 125 ;
    if (y_moving1 == 480) 
        y_moving1 <= 0;
    else
        y_moving1 <= y_moving1 + 1;
end

always_ff @(posedge sixtyHz) begin
    if (Row == 250) y_moving2 <= 250 ;
    if (y_moving2 == 480) 
        y_moving2 <= 0;
    else
        y_moving2 <= y_moving2 + 1;
end

always_ff @(posedge sixtyHz) begin
    if (Row == 375) y_moving3 <= 375 ;
    if (y_moving3 == 480) 
        y_moving3 <= 0;
    else
        y_moving3 <= y_moving3 + 1;
end

logic draw_box_1;
assign draw_box_1 = (Col < 163 && Col > 50) && (Row > y_moving0 && Row < y_moving0 + 50);

logic draw_box_2;
assign draw_box_2 = (Col < 163 && Col > 50) && (Row > y_moving1 && Row < y_moving1 + 50);

logic draw_box_3;
assign draw_box_3 =  (Col < 163 && Col > 50) && (Row > y_moving2 && Row < y_moving2 + 50);

logic draw_box_4;
assign draw_box_4 = (Col < 163 && Col > 50) && (Row > y_moving3 && Row < y_moving3 + 50);

    // Split the screen vertically in half
    always_comb begin
        if (!display_on)
            rgb_patterngen = 6'b000000; // black when display off
        else if (draw_box_1 == 1'b1)
            rgb_patterngen = 6'b110100; // left half:  first box
        else if (draw_box_2)
            rgb_patterngen =  6'b000100; //left half second box
        else if (draw_box_3)
            rgb_patterngen = 6'b101101; //left half third box
        else if (draw_box_4)
            rgb_patterngen = 6'b100101;
        else if (Col >= 213   && Col < 426)
            rgb_patterngen = 6'b000011; // right half: blue
        else 
            rgb_patterngen = 6'b110001;
    end

endmodule