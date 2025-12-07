module newbackground (
    input [7:0] x_input,    // 7 bits (0-79)
    input [6:0] y_input,    // 6 bits (0-59)
    output logic [5:0] data
);

    logic [13:0] address;   // 14 bits total
    assign address = {y_input, x_input};

    always_comb begin
        case(address)

    default: data = 6'b000000;
        endcase
    end

endmodule
