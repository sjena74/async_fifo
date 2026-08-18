// ----------Two Flip-Flop Synchronizer-----

// Parameters: Size

module two_ff_sync #(
    parameter int SIZE = 4
)(
    output logic [SIZE-1:0] q2,
    input  logic [SIZE-1:0] D_in,
    input  logic            clk,
    input  logic            rst_n
);

    logic [SIZE-1:0] q1; // Internal signal: output of the first flip-flop
    
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            q1 <= '0;
            q2 <= '0;
        end else begin
            q1 <= D_in;
            q2 <= q1;
        end
    end
endmodule