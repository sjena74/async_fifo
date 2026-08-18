// ----------FIFO_MEMORY-----
//
// Parameters: DATA_SIZE, ADDR_SIZE 

module FIFO_memory #(
    parameter int DATA_SIZE = 8,
    parameter int ADDR_SIZE = 4
)(
    output [DATA_SIZE-1:0] rdata,
    input  [DATA_SIZE-1:0] wdata,
    input  [ADDR_SIZE-1:0] waddr, raddr,
    input w_en, wfull, wclk
);
    localparam int DEPTH = 1 << ADDR_SIZE; 

    // Memory array: [WIDTH] mem [DEPTH]
    logic [DATA_SIZE-1:0] mem [0:DEPTH-1];

    // Async read
    assign rdata = mem[raddr];

    // Sync write
    always_ff @(posedge wclk) begin
        if (w_en && !wfull) begin
            mem[waddr] <= wdata;
        end
    end
endmodule



