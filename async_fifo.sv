// ----------AYSNC_FIFO------
//
// Parameters: DSIZE (data bus), ASIZE (address bus)

module async_fifo #(
    parameter int DSIZE = 8,
    parameter int ASIZE = 4

)(
    output logic [DSIZE-1:0] rdata, // read data
    output logic             wfull, // flags
    output logic             rempty,
    input  logic [DSIZE-1:0] wdata,
    input  logic             winc, // write request
    input  logic             wclk, // write clock
    input  logic             wrst_n, // write active-low reset
    input  logic             rinc, // read request
    input  logic             rclk, // read clock
    input  logic             rrst_n // read active-low reset
);
    // Internal connections
    logic [ASIZE-1:0] waddr;
    logic [ASIZE-1:0] raddr;
    logic [ASIZE:0]   wptr;
    logic [ASIZE:0]   rptr;
    logic [ASIZE:0]   wq2_rptr;
    logic [ASIZE:0]   rq2_wptr;


    // 1. Read-to-Write Clock Domain Synchronizer

    two_ff_sync #(
        .SIZE(ASIZE + 1)
    ) sync_readToWrite (
        .q2(wq2_rptr),
        .D_in(rptr),
        .clk(wclk),
        .rst_n(wrst_n)
    );

    //2. Write-to-Read Clock Domain Synchronizer

    two_ff_sync #(
        .SIZE(ASIZE + 1)
    ) sync_writeToRead (
        .q2 (rq2_wptr),
        .D_in (wptr),
        .clk (rclk),
        .rst_n (rrst_n)
    );

    // 3. Dual-Port Memory Block

    FIFO_memory #(
        .DATA_SIZE(DSIZE),
        .ADDR_SIZE(ASIZE)
    ) fifomem (
        .rdata (rdata),
        .wdata (wdata),
        .waddr (waddr),
        .raddr (raddr),
        .w_en (winc),
        .wfull (wfull),
        .wclk (wclk)
    );

    // 4. Read Controller

    read_controller #(
        .ADDR_SIZE(ASIZE)
    ) read_controller_inst (
        .rempty   (rempty),
        .raddr    (raddr),
        .rptr     (rptr), 
        .rq2_wptr (rq2_wptr),
        .rinc     (rinc), 
        .rclk     (rclk),
        .rrst_n   (rrst_n)
    );

    // 5. Write Controller
    write_controller #(
        .ADDR_SIZE (ASIZE)
    ) write_controller_inst (
        .wfull    (wfull), 
        .waddr    (waddr),
        .wptr     (wptr), 
        .wq2_rptr (wq2_rptr),
        .winc     (winc), 
        .wclk     (wclk),
        .wrst_n   (wrst_n)
    );

endmodule