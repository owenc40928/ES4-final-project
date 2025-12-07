// Patterngen module for ES4 lab 7 in SystemVerilog 
// Optimized to fix ICESTORM_LCs expansion error via shared arithmetic
// 27 August 2025

module patterngen(
    input  logic CLK,
    input logic instart,
    input logic reset,
    input logic donato,
    input  logic [9:0] Row,
    input  logic [9:0] Col,
    input  logic display_on,
    output logic [5:0] rgb_patterngen
);

    // ------------------------------------------------------------------------
    // Sprite Input Wires
    // ------------------------------------------------------------------------
    // We will drive these using shared arithmetic to save Logic Cells
    logic [4:0] img_xseven, img_yseven;
    logic [5:0] img_pixelseven;

    logic [5:0] img_pixeldiamond;
    logic [4:0] img_xdia, img_ydia;

    logic [5:0] img_pixelbar;
    logic [4:0] img_xbar, img_ybar;

    logic [5:0] img_pixelcher;
    logic [4:0] img_xcher, img_ycher;

    logic [5:0] img_pixelbackgounrd;
    logic [7:0] img_xbackground;
    logic [6:0] img_ybackground;

    logic [5:0] img_pixeljack;
    logic [7:0] img_xjack;
    logic [6:0] img_yjack;

    logic [5:0] img_pixelloser;
    logic [7:0] img_xloser;
    logic [6:0] img_yloser;


    logic [5:0] img_pixelw;
    logic [4:0] img_xw, img_yw;

    logic [5:0] img_pixeli;
    logic [4:0] img_xi, img_yi;

    logic [5:0] img_pixeln;
    logic [4:0] img_xn, img_yn;
    
    // Win background dummy logic (detected from instantiation but definition missing in original snippet)
    // Assuming standard behavior or removing if unused. 
    // Kept placeholders to match your instantiation list if they existed in your full file.
    // Note: 'winscreen' was instantiated in your snippet but wires img_xwinbackground weren't defined.
    // I will focus on the main logic provided.

    // ------------------------------------------------------------------------
    // Module Instantiations
    // ------------------------------------------------------------------------

    jackpot inst_jack (
        .x_input(img_xjack),
        .y_input(img_yjack),
        .data(img_pixeljack)
    );

       loser inst_loser (
        .x_input(img_xloser),
        .y_input(img_yloser),
        .data(img_pixelloser)
    );


    nicon inst_n (
        .x_input(img_xn),
        .y_input(img_yn),
        .data(img_pixeln)
    );

    iicon inst_i (
        .x_input(img_xi),
        .y_input(img_yi),
        .data(img_pixeli)
    );

    wicon inst_w (
        .x_input(img_xw),
        .y_input(img_yw),
        .data(img_pixelw)
    );

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

    // ------------------------------------------------------------------------
    // Movement Logic
    // ------------------------------------------------------------------------

    logic signed [9:0] y_moving0 = 9'd240;
    logic signed [9:0] y_moving1 = 9'd120;
    logic signed [9:0] y_moving2 = 9'd0;
    logic signed [9:0] y_moving3 = 9'd360;

    logic signed [9:0] y_moving4 = 9'd360;
    logic signed [9:0] y_moving5 = 9'd240;
    logic signed [9:0] y_moving6 = 9'd120;
    logic signed [9:0] y_moving7 = 9'd0;

    logic signed [9:0] y_moving8 = 9'd120;
    logic signed [9:0] y_moving9 = 9'd0;
    logic signed [9:0] y_moving10 = 9'd360;
    logic signed [9:0] y_moving11 = 9'd240;

    logic [1:0] SYM_BAR  = 2'd0;
    logic [1:0] SYM_DIA  = 2'd1;
    logic [1:0] SYM_CHER = 2'd2;
    logic [1:0] SYM_SEV  = 2'd3;

    logic clk;
    logic [25:0] count;
    
    SB_HFOSC #(
        .CLKHF_DIV("0b01")
    ) osc (
        .CLKHFPU(1'b1), // Power up
        .CLKHFEN(1'b1), // Enable
        .CLKHF(clk)     // Clock output
    );

    logic [1:0] random_value;

    lfsr1to4 RNG (
        .clk(clk),
        .rand_out(random_value)
    );

    always_ff @(posedge clk) begin
        if(count == 26'b11111111111111111111111111)
            count <= 26'b0;
        else 
            count <= count + 1;
    end

    // ------------------------------------------------------------------------
    // Timing and Speed Control
    // ------------------------------------------------------------------------

    logic oneHz;
    assign oneHz = (count == 26'd0);

    logic [5:0] seconds;
    
    // Forward declaration of state for use in seconds counter
    typedef enum logic [1:0] {S0, S1, S2} statetype;
    statetype state, nextstate;

    always_ff @(posedge clk) begin
        if (oneHz) begin
            if (seconds < 30 && state == S1)
                seconds <= seconds + 1;
            else if (state != S1 && nextstate == S1) // Reset on entry to S1
                seconds <= 5'b0;
            else if (state != S1)
                seconds <= 5'b0;
        end
    end

    logic sixtyHz0, sixtyHz1, sixtyHz2;
    logic flag1, flag2, flag3;

    always_comb begin
        if (seconds < 1) begin
            sixtyHz0 = (Row % 8 == 0);
            flag1 = 1;   
        end else if (seconds < 2) begin
            flag1 = 1;
            sixtyHz0 = (Row == 486);
        end else begin
            sixtyHz0 = 0;
            flag1 = 0;
        end
    end

    always_comb begin
        if (seconds < 3) begin
            flag2 = 1;
            sixtyHz1 = (Row % 8 == 0);
        end else if (seconds < 4) begin
            flag2 = 1;
            sixtyHz1 = (Row == 486);
        end else begin
            sixtyHz1 = 0;
            flag2 = 0;
        end
    end

    always_comb begin
        if (seconds < 5) begin
            flag3 = 1;
            sixtyHz2 = (Row % 8 == 0);
        end else if (seconds < 6) begin
            flag3 = 1;
            sixtyHz2 = (Row == 486);
        end else begin
            sixtyHz2 = 0;
            flag3 = 0;
        end
    end

    // ------------------------------------------------------------------------
    // Synchronize pushbuttons
    // ------------------------------------------------------------------------
    logic instart_sync0, instart_sync1;
    logic start_pulse;

    logic reset_sync0, reset_sync1;
    logic reset_pulse;

    always_ff @(posedge CLK) begin
        instart_sync0 <= instart;      
        instart_sync1 <= instart_sync0; 
    end

    always_ff @(posedge CLK) begin
        reset_sync0 <= reset;
        reset_sync1 <= reset_sync0;
    end

    assign start_pulse = instart_sync1 & ~instart_sync0;
    assign reset_pulse = reset_sync1 & ~reset_sync0;

    // ------------------------------------------------------------------------
    // FSM
    // ------------------------------------------------------------------------

    always_ff @(posedge CLK) begin
        if (reset_pulse)
            state <= S0;
        else
            state <= nextstate;
    end

    logic donatodetector;
    assign donatodetector = ~donato;

    always_comb begin
        nextstate = state;
        case(state)
            S0: if (start_pulse) nextstate = S1;
            S1: if (seconds == 7) nextstate = S2;
            S2: if (reset_pulse) nextstate = S0;
            default: nextstate = S0;
        endcase
    end

    // ------------------------------------------------------------------------
    // Moving Y Update
    // ------------------------------------------------------------------------

    always_ff @(posedge sixtyHz0) begin
        if (y_moving0 == 480) y_moving0 <= 0; else y_moving0 <= y_moving0 + 1;
        if (y_moving1 == 480) y_moving1 <= 0; else y_moving1 <= y_moving1 + 1;
        if (y_moving2 == 480) y_moving2 <= 0; else y_moving2 <= y_moving2 + 1;
        if (y_moving3 == 480) y_moving3 <= 0; else y_moving3 <= y_moving3 + 1;
    end

    always_ff @(posedge sixtyHz1) begin
        if (y_moving4 == 480) y_moving4 <= 0; else y_moving4 <= y_moving4 + 1;
        if (y_moving5 == 480) y_moving5 <= 0; else y_moving5 <= y_moving5 + 1;
        if (y_moving6 == 480) y_moving6 <= 0; else y_moving6 <= y_moving6 + 1;
        if (y_moving7 == 480) y_moving7 <= 0; else y_moving7 <= y_moving7 + 1;
    end

    always_ff @(posedge sixtyHz2) begin
        if (y_moving8 == 480) y_moving8 <= 0; else y_moving8 <= y_moving8 + 1;
        if (y_moving9 == 480) y_moving9 <= 0; else y_moving9 <= y_moving9 + 1;
        if (y_moving10 == 480) y_moving10 <= 0; else y_moving10 <= y_moving10 + 1;
        if (y_moving11 == 480) y_moving11 <= 0; else y_moving11 <= y_moving11 + 1;
    end

    // ------------------------------------------------------------------------
    // Box Region Logic
    // ------------------------------------------------------------------------
    // These define the bounds, but we will optimize how we use them.

    logic draw_box_1; assign draw_box_1 = (Col < 170 && Col > 50) && (Row > y_moving0 && Row < y_moving0 + 120);
    logic draw_box_2; assign draw_box_2 = (Col < 170 && Col > 50) && (Row > y_moving1 && Row < y_moving1 + 120);
    logic draw_box_3; assign draw_box_3 = (Col < 170 && Col > 50) && (Row > y_moving2 && Row < y_moving2 + 120);
    logic draw_box_4; assign draw_box_4 = (Col < 170 && Col > 50) && (Row > y_moving3 && Row < y_moving3 + 120);

    logic draw_box_5; assign draw_box_5 = (Col < 383 && Col > 263) && (Row > y_moving4 && Row < y_moving4 + 120);
    logic draw_box_6; assign draw_box_6 = (Col < 383 && Col > 263) && (Row > y_moving5 && Row < y_moving5 + 120);
    logic draw_box_7; assign draw_box_7 = (Col < 383 && Col > 263) && (Row > y_moving6 && Row < y_moving6 + 120);
    logic draw_box_8; assign draw_box_8 = (Col < 383 && Col > 263) && (Row > y_moving7 && Row < y_moving7 + 120);

    logic draw_box_9; assign draw_box_9  = (Col < 596 && Col > 476) && (Row > y_moving8 && Row < y_moving8 + 120);
    logic draw_box_10; assign draw_box_10 = (Col < 596 && Col > 476) && (Row > y_moving9 && Row < y_moving9 + 120);
    logic draw_box_11; assign draw_box_11 = (Col < 596 && Col > 476) && (Row > y_moving10 && Row < y_moving10 + 120);
    logic draw_box_12; assign draw_box_12 = (Col < 596 && Col > 476) && (Row > y_moving11 && Row < y_moving11 + 120);

    logic draw_boxleft;   assign draw_boxleft   = (Col < 170 && Col > 50) && (Row > 160 && Row < 280);
    logic draw_boxmiddle; assign draw_boxmiddle = (Col < 383 && Col > 263) && (Row > 160 && Row < 280);
    logic draw_boxright;  assign draw_boxright  = (Col < 596 && Col > 476) && (Row > 160 && Row < 280);

    // ------------------------------------------------------------------------
    // Random Result Logic
    // ------------------------------------------------------------------------

    logic [1:0] final_random_left;
    logic [1:0] final_random_middle;
    logic [1:0] final_random_right;

    always_ff @(posedge sixtyHz0) begin
        if(donatodetector) final_random_left <= 2'b00;
        else final_random_left <= random_value;
    end

    always_ff @(posedge sixtyHz1) begin
        if(donatodetector) final_random_middle <= 2'b00;
        else final_random_middle <= random_value;
    end

    always_ff @(posedge sixtyHz2) begin
        if(donatodetector) final_random_right <= 2'b00;
        else final_random_right <= random_value;
    end

    logic [1:0] sym_left;
    logic [1:0] sym_mid;
    logic [1:0] sym_right;

    // ------------------------------------------------------------------------
    // OPTIMIZED DRAWING LOGIC (Address Consolidation)
    // ------------------------------------------------------------------------

    // 1. Common X Calculation
    // Instead of calculating (Col - 51) multiple times, we do it once.
    logic [9:0] base_x_sub;
    always_comb begin
        if (Col < 170 && Col > 50)      base_x_sub = 51;
        else if (Col < 383 && Col > 263) base_x_sub = 263;
        else if (Col < 596 && Col > 476) base_x_sub = 476;
        else                             base_x_sub = 0;
    end
    
    // Shared X coordinate for all standard icons
    logic [9:0] shared_raw_x;
    assign shared_raw_x = Col - base_x_sub;

    // 2. Target Selector and Y Offset
    // We determine WHICH sprite is active and WHAT its Y-offset is.
    
    typedef enum logic [3:0] {
        ID_BG=0, ID_SEVEN=1, ID_DIA=2, ID_BAR=3, ID_CHER=4, 
        ID_JACK=5, ID_W=6, ID_I=7, ID_N=8, ID_LOSE=9
    } sprite_id_t;

    sprite_id_t target_sprite;
    logic [9:0] target_y_sub;

    always_comb begin
        // Default values
        target_sprite = ID_BG;
        target_y_sub = 0;
        
        // Symbol determination logic for Jackpot check
        sym_left = SYM_BAR;
        sym_mid = SYM_BAR;
        sym_right = SYM_BAR;

        case(state)
            S0: begin
                target_sprite = ID_BG;
            end

            S1: begin
                // Turn off if display off
                if (!display_on && flag1 && flag2 && flag3) begin
                    // Handled at RGB output stage usually, but following logic:
                    // If display_on is low, we output black.
                end
                
                // --- Column 1 Logic ---
                if (flag1) begin 
                   // Moving Phase
                   if (draw_box_1) begin target_sprite = ID_SEVEN; target_y_sub = y_moving0 + 1; end
                   else if (draw_box_2) begin target_sprite = ID_DIA; target_y_sub = y_moving1 + 1; end
                   else if (draw_box_3) begin target_sprite = ID_BAR; target_y_sub = y_moving2 + 1; end
                   else if (draw_box_4) begin target_sprite = ID_CHER; target_y_sub = y_moving3 + 1; end
                end else begin
                   // Static Phase
                   if (draw_boxleft) begin
                        target_y_sub = 161;
                        case(final_random_left)
                            2'b00: target_sprite = ID_BAR;
                            2'b01: target_sprite = ID_DIA;
                            2'b10: target_sprite = ID_CHER;
                            2'b11: target_sprite = ID_SEVEN;
                        endcase
                   end
                end

                // --- Column 2 Logic ---
                if (flag2) begin
                    if (draw_box_5) begin target_sprite = ID_SEVEN; target_y_sub = y_moving4 + 1; end
                    else if (draw_box_6) begin target_sprite = ID_BAR; target_y_sub = y_moving5 + 1; end
                    else if (draw_box_7) begin target_sprite = ID_DIA; target_y_sub = y_moving6 + 1; end
                    else if (draw_box_8) begin target_sprite = ID_CHER; target_y_sub = y_moving7 + 1; end
                end else begin
                    if (draw_boxmiddle) begin
                        target_y_sub = 161;
                        case(final_random_middle)
                            2'b00: target_sprite = ID_BAR;
                            2'b01: target_sprite = ID_CHER; // Note: specific mapping from your code
                            2'b11: target_sprite = ID_DIA;
                            2'b10: target_sprite = ID_SEVEN;
                        endcase
                    end
                end

                // --- Column 3 Logic ---
                if (flag3) begin
                    if (draw_box_9) begin target_sprite = ID_SEVEN; target_y_sub = y_moving8 + 1; end
                    else if (draw_box_10) begin target_sprite = ID_BAR; target_y_sub = y_moving9 + 1; end
                    else if (draw_box_11) begin target_sprite = ID_DIA; target_y_sub = y_moving10 + 1; end
                    else if (draw_box_12) begin target_sprite = ID_CHER; target_y_sub = y_moving11 + 1; end
                end else begin
                    if (draw_boxright) begin
                        target_y_sub = 161;
                        case(final_random_right)
                            2'b00: target_sprite = ID_BAR;
                            2'b01: target_sprite = ID_CHER;
                            2'b11: target_sprite = ID_DIA;
                            2'b10: target_sprite = ID_SEVEN;
                        endcase
                    end
                end
            end // End S1

            S2: begin
                // Resolve Symbols based on random values
                case (final_random_left)
                    2'b00: sym_left = SYM_BAR; 2'b01: sym_left = SYM_DIA; 2'b10: sym_left = SYM_CHER; 2'b11: sym_left = SYM_SEV;
                endcase
                case (final_random_middle)
                    2'b00: sym_mid = SYM_BAR; 2'b01: sym_mid = SYM_CHER; 2'b11: sym_mid = SYM_DIA; 2'b10: sym_mid = SYM_SEV;
                endcase
                case (final_random_right)
                    2'b00: sym_right = SYM_BAR; 2'b01: sym_right = SYM_CHER; 2'b11: sym_right = SYM_DIA; 2'b10: sym_right = SYM_SEV;
                endcase

                // Determine Win Condition
                if ((sym_left == sym_mid) && (sym_mid == sym_right)) begin
                    // JACKPOT
                    target_sprite = ID_JACK; 
                    // Jackpot uses raw Col/Row in your code, so target_y_sub is irrelevant for math but set to 0
                    target_y_sub = 0; 
                end else if ((sym_left == sym_mid) ^ (sym_left == sym_right) ^ (sym_mid == sym_right)) begin
                    // WIN (Match 2)
                    target_y_sub = 161;
                    if (draw_boxleft) target_sprite = ID_W;
                    else if (draw_boxmiddle) target_sprite = ID_I;
                    else if (draw_boxright) target_sprite = ID_N;
                end else begin
                    // LOSE
                     target_y_sub = 161;
                    if (draw_boxleft) target_sprite = ID_LOSE;
                    else if (draw_boxmiddle) target_sprite = ID_LOSE;
                    else if (draw_boxright) target_sprite = ID_LOSE;
                end
            end // End S2
        endcase
    end

    // 3. Shared Y Calculation
    logic [9:0] shared_raw_y;
    assign shared_raw_y = Row - target_y_sub;

    // 4. Drive Module Inputs (Scaling)
    // We drive ALL standard sprite modules with the same calculated coordinates.
    // The inactive ones will output garbage, but we won't select their output in the RGB mux.
    // This saves massive amounts of muxing logic on the inputs.
    
    assign img_xseven = shared_raw_x[6:2];
    assign img_yseven = shared_raw_y[6:2];

    assign img_xdia   = shared_raw_x[6:2];
    assign img_ydia   = shared_raw_y[6:2];

    assign img_xbar   = shared_raw_x[6:2];
    assign img_ybar   = shared_raw_y[6:2];

    assign img_xcher  = shared_raw_x[6:2];
    assign img_ycher  = shared_raw_y[6:2];

    assign img_xw     = shared_raw_x[6:2];
    assign img_yw     = shared_raw_y[6:2];

    assign img_xi     = shared_raw_x[6:2];
    assign img_yi     = shared_raw_y[6:2];

    assign img_xn     = shared_raw_x[6:2];
    assign img_yn     = shared_raw_y[6:2];

    // Background and Jackpot scale differently or use raw coords
    assign img_xbackground = Col[9:2];
    assign img_ybackground = Row[9:2];

    assign img_xjack = Col[9:3];
    assign img_yjack = Row[9:3];

    assign img_xloser = shared_raw_x[6:2];
    assign img_yloser = shared_raw_y[6:2];

    // 5. Final Output Mux
    always_comb begin
        // Global blanking checks from original logic
        if (state == S1 && !display_on) begin
             rgb_patterngen = 6'b000000;
        end else begin
            case(target_sprite)
                ID_SEVEN: rgb_patterngen = img_pixelseven;
                ID_DIA:   rgb_patterngen = img_pixeldiamond;
                ID_BAR:   rgb_patterngen = img_pixelbar;
                ID_CHER:  rgb_patterngen = img_pixelcher;
                ID_JACK:  rgb_patterngen = img_pixeljack;
                ID_W:     rgb_patterngen = img_pixelw;
                ID_I:     rgb_patterngen = img_pixeli;
                ID_N:     rgb_patterngen = img_pixeln;
                ID_LOSE:  rgb_patterngen = img_pixelloser;
                default:  rgb_patterngen = img_pixelbackgounrd;
            endcase
        end
    end

endmodule