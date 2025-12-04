module fsm (
    input logic start, //lever
    input logic clk,
    input logic c1, c2, c3 // each slot machine column to check
    input logic reset
);

logic [26:0] slowCount;

typedef enum logic [1:0] {
    S0,
    S1,
    S2,
    S3,
    S4
} statetype;

statetype state, nextstate;

always_comb begin
    nextstate = state; // keep same state if nothing changes
    case (state)
        S0: if (start) nextstate = S1;
        S1: if (slowCount == 26'b11111111111111111111111111) nextstate = S2
        S2: if (c1 == c2 && c2 == c3)
                nextstate = S3; // check win 
            else
                nextstate = S4;
        S3: if (reset) nextstate = S0; //win
        S4: if (reset) nextstate = S0; // lose
    endcase
end

always_ff @(posedge clk) begin
    if (reset) state <= S0;
    else state <= nextstate;
        if (state == S1) slowCount <= slowCount + 1;
        else slowCount == 0;
end



// S0: start game 
    // click button to make slot machine move -> go to state 1
// S1: slot machine moving -> then after some time, go to S2 and slow down     
// S2: slot machine slowing, then comes to stop
    // check result, if all symbols equal, display win (S3), else display lose (S4)
// S3: result win
    // -> click reset button to restart game (S0)
// S4: result lose
    // -> clock reset button to restart game (S0)


