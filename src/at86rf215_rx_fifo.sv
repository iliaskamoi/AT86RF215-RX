module at86rf215_rx_fifo #(
    parameter integer DATA_WIDTH = 32,
    parameter integer DEPTH = 4
) (
    input  logic aclk,
    input  logic aresetn,
    input  logic write_en,
    input  logic [DATA_WIDTH - 1 : 0] write_data,
    input  logic read_en,
    output logic [DATA_WIDTH - 1 : 0] read_data,
    output logic empty
);

    logic [DATA_WIDTH - 1 : 0] mem [0 : DEPTH - 1];

    // Read and write pointers
    logic [$clog2(DEPTH) - 1 : 0] read_ptr;
    logic [$clog2(DEPTH) - 1 :0] write_ptr;

    // Counter to keep track of the number of elements in the FIFO
    logic [$clog2(DEPTH) : 0] fifo_count;
    logic full;
    always_comb begin
        read_data = mem[read_ptr];
        empty = (fifo_count == 0);
        full  = (fifo_count == DEPTH);
    end

    always_ff @(posedge aclk or negedge aresetn) begin
        if (!aresetn) begin
            fifo_count <= 0;
        end
        else begin
            if (write_en && !full) begin
                fifo_count <= fifo_count + 1;
            end

            if (read_en && !empty) begin
                fifo_count <= fifo_count - 1;
            end
        end
    end
    
    always_ff @(posedge aclk or negedge aresetn) begin
        if (!aresetn) begin
            write_ptr  <= 0;
        end
        else begin
            write_ptr <= write_en && !full ? write_ptr + 1 : write_ptr;
        end
    end
    
    always_ff @(posedge aclk or negedge aresetn) begin
        if (!aresetn) begin
            read_ptr   <= 0;
        end
        else begin
            read_ptr <= read_en && !empty ? read_ptr + 1 : read_ptr;
        end
    end

    always_ff @(posedge aclk or negedge aresetn) begin
        if (!aresetn) begin
            for (int i = 0; i < DEPTH; i++) begin
                mem[i] <= 0;
            end
        end
        mem[write_ptr] <= write_en && !full ? write_data : mem[write_ptr];
    end

endmodule
