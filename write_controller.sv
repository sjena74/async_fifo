// ----------WRITE_POINTER_controller------
//
// Parameters: ADDR_SIZE

module write_controller #(
    parameter int ADDR_SIZE = 4
)(
    output logic wfull,
    output logic [ADDR_SIZE-1:0] waddr,
    output logic [ADDR_SIZE:0] wptr,
    input  logic [ADDR_SIZE:0] wq2_rptr,
    input  logic               winc,
    input  logic               wclk,
    input  logic               wrst_n
);

    logic [ADDR_SIZE:0] wbin;
    logic [ADDR_SIZE:0] wbin_next;
    logic [ADDR_SIZE:0] wgray_next;
    logic               wfull_val;


    // Sequential State Update (Binary and Gray Pointers)

    always_ff @(posedge wclk or negedge wrst_n) begin
        if (!wrst_n) begin
            wbin <= '0;
            wptr <= '0;
        end else begin
            wbin <= wbin_next;
            wptr <= wgray_next;
        end
    end

    // Combinational Logic
    assign waddr = wbin[ADDR_SIZE-1:0];

    assign wbin_next = wbin + (winc & ~wfull);

    assign wgray_next = (wbin_next >> 1) ^ wbin_next;


    // Full Flag Generation
    assign wfull_val = (wgray_next == {~wq2_rptr[ADDR_SIZE:ADDR_SIZE-1], wq2_rptr[ADDR_SIZE-2:0]});

    always_ff @(posedge wclk or negedge wrst_n) begin
        if (!wrst_n) begin
            wfull <= 1'b0; // default is NOT FULL on reset
        end else begin
            wfull <= wfull_val;
        end
    end
endmodule