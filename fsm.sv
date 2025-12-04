module fsm (
    input logic start, //lever
    input logic clk,
    input logic c1, c2, c3 // each slot machine column to check
    input logic reset
);

typedef enum logic [1:0] {
    S0,
    S1,
    S2,
    S3,
    S4,
    S5
} statetype;

statetype state, nextstate;

always_comb begin
    nextstate = state; // keep same state if nothing changes
    case (state)
        S0: if (start) nextstate = S1;
        S1: // goes to next state on a clock
        S2: if (c1 == c2 && c2 == c3)
                nextstate = S3; // check win 
            else
                nextstate = S4;
        S3: if (reset) nextstate = S0;
        S4: if (reset) nextstate = S0;
    endcase
end

always_ff @(posedge clk) begin
    if (reset) state <= S0;
    else state <= nextstate;
    // need to make another clock to go from S1 to S2
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


