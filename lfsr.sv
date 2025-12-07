module lfsr1to4 (
    input  logic       clk,
    output logic [1:0] rand_out
);

    logic [15:0] lfsr_reg;
    logic        feedback;

    // XOR feedback taps for 16-bit
    assign feedback = lfsr_reg[15] ^ lfsr_reg[13] ^ lfsr_reg[12] ^ lfsr_reg[10];

    // FPGA Specific: Initialize register value at power-up
    initial begin
        lfsr_reg = 16'hACE1; // Non-zero seed
    end

    always_ff @(posedge clk) begin
        // No reset logic here, just shifting
        lfsr_reg <= {lfsr_reg[14:0], feedback};
    end

    assign rand_out = lfsr_reg[15:14];

endmodule