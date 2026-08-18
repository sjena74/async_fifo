// ----------READ_POINTER_controller------
//
// Parameters: ADDR_SIZE


module read_controller #(
    parameter int ADDR_SIZE = 4
)(
    output logic                rempty,
    output logic [ADDR_SIZE-1:0] raddr,
    output logic [ADDR_SIZE:0] rptr,
    input  logic [ADDR_SIZE:0] rq2_wptr,
    input  logic               rinc, rclk, rrst_n
);

    logic [ADDR_SIZE:0] rbin;
    logic [ADDR_SIZE:0] rbin_next;
    logic [ADDR_SIZE:0] rgray_next;
    logic               rempty_val;


    // Sequential State Update (Binary & Gray Pointers)
    always_ff @(posedge rclk or negedge rrst_n) begin
        if (!rrst_n) begin
            rbin <= '0;
            rptr <= '0;
        end else begin
            rbin <= rbin_next;
            rptr <= rgray_next;

        end
    end


    // Combinational Logic
    assign raddr = rbin[ADDR_SIZE-1:0];

    assign rbin_next = rbin + (rinc & ~rempty); // incrememnt if read_en AND not empty

    assign rgray_next = (rbin_next >> 1) ^ rbin_next; // gray code calculation


    // Empty Flag Generation
    assign rempty_val = (rgray_next == rq2_wptr);
    
    always_ff @(posedge rclk or negedge rrst_n) begin
        if (!rrst_n) begin
            rempty <= 1'b1; // empty on reset
        end else begin
            rempty <= rempty_val;
        end
    end

endmodule






