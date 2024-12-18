`timescale 1ns / 1ps

module at86rf215_rx_tb;

    parameter integer SYNC_THRESHOLD = 5;
    parameter integer C_M00_AXIS_TDATA_WIDTH = 32;
    parameter integer FIFO_DEPTH = 4;
    localparam integer NUM_OF_WORDS = 30;
    parameter integer MAX_SAMPLE_RATE = 10;

    logic aclk;
    logic aresetn;

    // DUT Ports
    logic [1:0] iq_data_in;
    logic [3:0] sample_rate;
    logic in_sync;
    logic overflow;
    logic m00_axis_tvalid;
    logic [C_M00_AXIS_TDATA_WIDTH-1:0] m00_axis_tdata;
    logic m00_axis_tlast;
    logic m00_axis_tready;

    // Clock generation
    initial aclk = 0;
    always #5 aclk = ~aclk; // 100 MHz clock

    // DUT instantiation
    axi_at86rf215_iq_rx #(
        .SYNC_THRESHOLD(SYNC_THRESHOLD),
        .C_M00_AXIS_TDATA_WIDTH(C_M00_AXIS_TDATA_WIDTH),
        .FIFO_DEPTH(FIFO_DEPTH),
        .DATA_WIDTH(C_M00_AXIS_TDATA_WIDTH)
    ) dut (
        .aclk(aclk),
        .aresetn(aresetn),
        .iq_data_in(iq_data_in),
        .sample_rate(sample_rate),
        .in_sync(in_sync),
        .m00_axis_tvalid(m00_axis_tvalid),
        .m00_axis_tdata(m00_axis_tdata),
        .m00_axis_tlast(m00_axis_tlast),
        .m00_axis_tready(m00_axis_tready)
    );
    
    logic [C_M00_AXIS_TDATA_WIDTH - 1 : 0] sync_value [NUM_OF_WORDS*MAX_SAMPLE_RATE - 1 : 0];
    logic [11:0] next = 12'h000;
    initial begin
        sample_rate = 4;
        for (int i = 0; i < NUM_OF_WORDS*MAX_SAMPLE_RATE; i++) begin
            if (i % sample_rate == 0) begin
                sync_value[i] = {2'b10, 2'b11, next, 2'b01, 2'b11, next};
                next += 12'h001;
            end
            else begin
                sync_value[i] = 32'h00000000;
                next += 12'h000;
            end
        end                                              
    end
    logic [C_M00_AXIS_TDATA_WIDTH - 1 : 0] curre_val = 0;
    logic [$clog2(MAX_SAMPLE_RATE) - 1 : 0] sample_counter = 0;
    initial begin
        iq_data_in = 0;
        m00_axis_tready = 0;
        
        aresetn = 1;
        #15;
        aresetn = 0;
        #23;
        aresetn = 1;
        #10;
        
        
        
        iq_data_in = 2'b11;
        m00_axis_tready = 1;
        
        @(posedge aclk);
        for (int j = 0; j < NUM_OF_WORDS*MAX_SAMPLE_RATE; j++) begin
            for (int i = 0; i < C_M00_AXIS_TDATA_WIDTH / 2; i++) begin
                curre_val = sync_value[j] << 2*i;
                iq_data_in = curre_val[31:30];
                @(posedge aclk);
            end
        end
        
        
        /* De-symc trigger */
        for (int i = 0; i < C_M00_AXIS_TDATA_WIDTH / 2; i++) begin
            curre_val = 32'h00000000 << 2*i;
            iq_data_in = curre_val[31:30];
            @(posedge aclk);
        end
        // Simulate overflow scenario
        m00_axis_tready = 0; // Stop accepting data
        repeat (10) #10;

        // Resume normal operation
        m00_axis_tready = 1;
        repeat (20) #10;

        // End simulation
        $finish;
    end
endmodule

