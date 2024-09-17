module pc (input logic [31:0] add_in, input logic clk, reset, output logic [31:0]add_out);

    always_ff @(posedge clk)
    begin
        if (reset)
        begin
            add_out <= 0;
        end
        else
        begin
            add_out <= add_in;
        end
    end

endmodule