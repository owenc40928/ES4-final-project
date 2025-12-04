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


logic [4:0] img_xseven, img_yseven;
logic [5:0] img_pixelseven;
logic [9:0] digitxseven;
logic [9:0] digityseven;

logic [5:0] img_pixeldiamond;
logic [4:0] img_xdia, img_ydia;
logic [9:0] digitxdia;
logic [9:0] digitysdia;

logic [5:0] img_pixelbar;
logic [4:0] img_xbar, img_ybar;
logic [9:0] digitxbar;
logic [9:0] digitybar;

logic [5:0] img_pixelcher;
logic [4:0] img_xcher, img_ycher;
logic [9:0] digitxcher;
logic [9:0] digitycher;

logic [5:0] img_pixelbackgounrd;
logic [7:0] img_xbackground, img_ybackground;
logic [9:0] digitxbackground;
logic [9:0] digitybackground;

seven inst_sev (
    .x_input(img_xseven),
    .y_input(img_yseven),
    .data(img_pixelseven)
);

newbackground inst_background (
    .x_input(img_xbackground),
    .y_input(img_ybackground),
    .data(img_pixelbackgounrd)
);

dmd inst_dmd (
    .x_input(img_xdia),
    .y_input(img_ydia),
    .data(img_pixeldiamond)
);

bar inst_bar (
    .x_input(img_xbar),
    .y_input(img_ybar),
    .data(img_pixelbar)
);

cherry inst_cher (
    .x_input(img_xcher),
    .y_input(img_ycher),
    .data(img_pixelcher)
);


logic signed [9:0] y_moving0 = 9'd240;
logic signed [9:0] y_moving1 = 9'd120;
logic signed[9:0] y_moving2 = 9'd0;
logic signed [9:0] y_moving3 = 9'd360;

logic signed [9:0] y_moving4 = 9'd360;
logic signed [9:0] y_moving5 = 9'd240;
logic signed [9:0] y_moving6= 9'd120;
logic signed [9:0] y_moving7 = 9'd0;


logic signed [9:0] y_moving8 = 9'd120;
logic signed [9:0] y_moving9 = 9'd0;
logic signed[9:0] y_moving10 = 9'd360;
logic signed [9:0] y_moving11 = 9'd240;

logic clk;
logic [25:0] count;
SB_HFOSC #(
.CLKHF_DIV("0b00")
) osc (
.CLKHFPU(1'b1), // Power up
.CLKHFEN(1'b1), // Enable
.CLKHF(clk) // Clock output
);

always_ff @(posedge clk) begin
    if(count == 26'b11111111111111111111111111)
        count <= 26'b0;
    else 
    count <= count + 1;
end

// ---------------------------------------------------------
//  120 Hz for 10 seconds, then 60 Hz for 10 seconds
// ---------------------------------------------------------

// Make a 1 Hz pulse from your 26-bit counter (approx 1 second)
// ---------------------------------------------------------
//  600 Hz for the first 30 seconds, then 60 Hz permanently
// ---------------------------------------------------------

// 1 Hz pulse from your 26-bit counter (≈1 second)
logic oneHz;
assign oneHz = (count == 26'd0);

// Seconds counter: counts 0 → 30, then stops
logic [5:0] seconds;
always_ff @(posedge clk) begin
    if (oneHz) begin
        if (seconds < 30)
            seconds <= seconds + 1;
    end
end

// Speed selector
logic sixtyHz0;
logic sixtyHz1;
logic sixtyHz2;

// FAST MODE (600 Hz) for first 30 seconds
// NORMAL MODE (60 Hz) afterward
always_comb begin
    if (seconds < 10)
        sixtyHz0 = (Row % 8 == 0);   // 480 rows → ~600 triggers/s
    else
        sixtyHz0 = (Row == 486);     // your original 60 Hz pulse
end

always_comb begin
    if (seconds < 12)
        sixtyHz1 = (Row % 8 == 0);   // 480 rows → ~600 triggers/s
    else
        sixtyHz1 = (Row == 486);     // your original 60 Hz pulse
end

always_comb begin
    if (seconds < 14)
        sixtyHz2 = (Row % 8 == 0);   // 480 rows → ~600 triggers/s
    else
        sixtyHz2 = (Row == 486);     // your original 60 Hz pulse
end

always_ff @(posedge sixtyHz0) begin
    if (y_moving0 == 480) 
        y_moving0 <= 0;
    else
        y_moving0 <= y_moving0 + 1;
end

always_ff @(posedge sixtyHz0) begin
    if (y_moving1 == 480) 
        y_moving1 <= 0;
    else
        y_moving1 <= y_moving1 + 1;
end

always_ff @(posedge sixtyHz0) begin
    if (y_moving2 == 480) 
        y_moving2 <= 0;
    else
        y_moving2 <= y_moving2 + 1;
end

always_ff @(posedge sixtyHz0) begin
    if (y_moving3 == 480) 
        y_moving3 <= 0;
    else
        y_moving3 <= y_moving3 + 1;
end


always_ff @(posedge sixtyHz1) begin
    if (y_moving4 == 480) 
        y_moving4 <= 0;
    else
        y_moving4 <= y_moving4 + 1;
end

always_ff @(posedge sixtyHz1) begin
    if (y_moving5 == 480) 
        y_moving5 <= 0;
    else
        y_moving5 <= y_moving5 + 1;
end

always_ff @(posedge sixtyHz1) begin
    if (y_moving6 == 480) 
        y_moving6 <= 0;
    else
        y_moving6 <= y_moving6 + 1;
end

always_ff @(posedge sixtyHz1) begin
    if (y_moving7 == 480) 
        y_moving7 <= 0;
    else
        y_moving7 <= y_moving7 + 1;
end

always_ff @(posedge sixtyHz2) begin
    if (y_moving8 == 480) 
        y_moving8 <= 0;
    else
        y_moving8 <= y_moving8 + 1;
end

always_ff @(posedge sixtyHz2) begin
    if (y_moving9 == 480) 
        y_moving9 <= 0;
    else
        y_moving9 <= y_moving9 + 1;
end

always_ff @(posedge sixtyHz2) begin
    if (y_moving10 == 480) 
        y_moving10 <= 0;
    else
        y_moving10 <= y_moving10 + 1;
end

always_ff @(posedge sixtyHz2) begin
    if (y_moving11 == 480) 
        y_moving11 <= 0;
    else
        y_moving11 <= y_moving11 + 1;
end

logic draw_box_1;
assign draw_box_1 = (Col < 170 && Col > 50) && (Row > y_moving0 && Row < y_moving0 + 120);

logic draw_box_2;
assign draw_box_2 = (Col < 170 && Col > 50) && (Row > y_moving1 && Row < y_moving1 + 120);

logic draw_box_3;
assign draw_box_3 =  (Col < 170 && Col > 50) && (Row > y_moving2  && Row < y_moving2 + 120 );

logic draw_box_4;
assign draw_box_4 = (Col < 170 && Col > 50) && (Row > y_moving3 && Row < y_moving3 + 120 );

logic draw_box_5;
assign draw_box_5 = (Col < 383 && Col > 263) && (Row > y_moving4 && Row < y_moving4 + 120);

logic draw_box_6;
assign draw_box_6 = (Col < 383 && Col > 263) && (Row > y_moving5 && Row < y_moving5 + 120);

logic draw_box_7;
assign draw_box_7 =  (Col < 383 && Col > 263) && (Row > y_moving6  && Row < y_moving6 + 120 );

logic draw_box_8;
assign draw_box_8 = (Col < 383 && Col > 263) && (Row > y_moving7 && Row < y_moving7 + 120 );

logic draw_box_9;
assign draw_box_9 = (Col < 596 && Col > 476) && (Row > y_moving8 && Row < y_moving8 + 120);

logic draw_box_10;
assign draw_box_10 = (Col < 596 && Col > 476) && (Row > y_moving9 && Row < y_moving9 + 120);

logic draw_box_11;
assign draw_box_11 =  (Col < 596 && Col > 476) && (Row > y_moving10  && Row < y_moving10 + 120 );

logic draw_box_12;
assign draw_box_12 = (Col < 596 && Col > 476) && (Row > y_moving11 && Row < y_moving11 + 120 );

    // Split the screen vertically in half
always_comb begin
    img_xseven = 0;
    img_yseven = 0;
    digitxseven = 0;
    digityseven = 0;

    img_xdia = 0;
    img_ydia = 0;
    digitxdia = 0;
    digitysdia = 0;

    img_xbar = 0;
    img_ybar = 0;
    digitxbar = 0;
    digitybar = 0;

    img_xcher = 0;
    img_ycher = 0;
    digitxcher = 0;
    digitycher = 0;

    img_xbackground = 0;
    img_ybackground = 0;
    digitxbackground = 0;
    digitybackground = 0;

    if (!display_on) begin
        rgb_patterngen = 6'b000000;
    end
    else if (draw_box_1) begin
        digitxseven = Col - 51;
        digityseven = Row -  (y_moving0 + 1);

        img_xseven = digitxseven[6:2];   // scale 4x
        img_yseven = digityseven[6:2];

        rgb_patterngen = img_pixelseven;
    end
    else if (draw_box_2) begin
        digitxdia = Col - 51;
        digitysdia = Row -  (y_moving1 + 1);

        img_xdia = digitxdia[6:2];   // scale 4x
        img_ydia = digitysdia[6:2];

        rgb_patterngen = img_pixeldiamond;
    end
    else if (draw_box_3) begin
        digitxbar = Col - 51;
        digitybar = Row -  (y_moving2 + 1);

        img_xbar = digitxbar[6:2];   // scale 4x
        img_ybar = digitybar[6:2];

        rgb_patterngen = img_pixelbar;
    end
    else if (draw_box_4) begin
        digitxcher = Col - 51;
        digitycher = Row -  (y_moving3 + 1);

        img_xcher = digitxcher[6:2];   // scale 4x
        img_ycher = digitycher[6:2];

        rgb_patterngen = img_pixelcher;
    end
    else if (draw_box_5) begin
        digitxseven = Col - 263;
        digityseven = Row -  (y_moving4 + 1);

        img_xseven = digitxseven[6:2];   // scale 4x
        img_yseven = digityseven[6:2];

        rgb_patterngen = img_pixelseven;
    end
    else if (draw_box_6) begin
        
         digitxbar = Col - 263;
        digitybar = Row -  (y_moving5 + 1);

        img_xbar = digitxbar[6:2];   // scale 4x
        img_ybar = digitybar[6:2];

        rgb_patterngen = img_pixelbar;
    end
    else if (draw_box_7) begin
        digitxdia = Col - 263;
        digitysdia = Row -  (y_moving6 + 1);

        img_xdia = digitxdia[6:2];   // scale 4x
        img_ydia = digitysdia[6:2];

        rgb_patterngen = img_pixeldiamond;
    end
    else if (draw_box_8) begin
        digitxcher = Col - 263;
        digitycher = Row -  (y_moving7 + 1);

        img_xcher = digitxcher[6:2];   // scale 4x
        img_ycher = digitycher[6:2];

        rgb_patterngen = img_pixelcher;
    end
    else if (draw_box_9) begin
        digitxseven = Col - 476;
        digityseven = Row -  (y_moving8 + 1);

        img_xseven = digitxseven[6:2];   // scale 4x
        img_yseven = digityseven[6:2];

        rgb_patterngen = img_pixelseven;
    end
        else if (draw_box_10) begin
        
         digitxbar = Col - 476;
        digitybar = Row -  (y_moving9 + 1);

        img_xbar = digitxbar[6:2];   // scale 4x
        img_ybar = digitybar[6:2];

        rgb_patterngen = img_pixelbar;
    end
    else if (draw_box_11) begin
        digitxdia = Col - 476;
        digitysdia = Row -  (y_moving10 + 1);

        img_xdia = digitxdia[6:2];   // scale 4x
        img_ydia = digitysdia[6:2];

        rgb_patterngen = img_pixeldiamond;
    end
    else if (draw_box_12) begin
        digitxcher = Col - 476;
        digitycher = Row -  (y_moving11 + 1);

        img_xcher = digitxcher[6:2];   // scale 4x
        img_ycher = digitycher[6:2];

        rgb_patterngen = img_pixelcher;
    end
    else begin
        digitxbackground = Col ;
        digitybackground = Row ;

        img_xbackground = digitxbackground[9:3];   
        img_ybackground = digitybackground[9:3];
        rgb_patterngen = img_pixelbackgounrd;
    end
end


endmodule
