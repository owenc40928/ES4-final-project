module donlfsr1to4 (
    input  logic       clk,       // clock input
    output logic [1:0] rand_num   // random number 1..4
);

    // 3-bit LFSR state (seed must be non-zero)
    logic [2:0] lfsr = 3'b001;

    always_ff @(posedge clk) begin
        // LFSR taps for polynomial x^3 + x + 1
        lfsr <= {lfsr[1], lfsr[0], lfsr[2] ^ lfsr[0]};

        // Map 3-bit LFSR (1..7) into 1..4
        rand_num <= (lfsr % 4) + 1;
    end

endmodule
