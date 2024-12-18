
`timescale 1 ns / 1 ps

module axi_at86rf215_iq_rx #
(
    parameter integer SYNC_THRESHOLD = 5,
    
    parameter integer DESYNC_THRESHOLD = 4,

    parameter integer C_M00_AXIS_TDATA_WIDTH = 32,
    
    parameter integer FIFO_DEPTH = 5
)
(
    // Users to add ports here
    input logic aclk,
    input logic aresetn,
    input logic [1:0] iq_data_in,
    input logic [3:0] sample_rate,
    output logic in_sync,
    

    // Ports of Axi Master Bus Interface M00_AXIS_I
    output logic m00_axis_tvalid,
    output logic [C_M00_AXIS_TDATA_WIDTH - 1 : 0] m00_axis_tdata,
    output logic m00_axis_tlast,
    input logic m00_axis_tready
);

    always_comb begin
        m00_axis_tvalid = !empty && in_sync;
        m00_axis_tlast = desync && in_sync;
    end
    
    
    logic [C_M00_AXIS_TDATA_WIDTH - 1 : 0] synced_data;
    at86rf215_iq_rx_sync # (
        .SYNC_THRESHOLD(SYNC_THRESHOLD),
        .DESYNC_THRESHOLD(DESYNC_THRESHOLD),
        .C_M00_AXIS_TDATA_WIDTH(C_M00_AXIS_TDATA_WIDTH)
    ) at86rf215_iq_rx_sync_inst(
        .aclk(aclk),
        .aresetn(aresetn),
        .iq_data_in(iq_data_in),
        .sample_rate(sample_rate),
        .synced_data(synced_data),
        .write_en(write_en),
        .in_sync(in_sync),
        .desync(desync),
        .sync_cond(sync_cond)
    );
    
    at86rf215_rx_fifo # (
        .DATA_WIDTH(C_M00_AXIS_TDATA_WIDTH),
        .DEPTH(FIFO_DEPTH)
    ) fifo_inst (
        .aclk(aclk),
        .aresetn(aresetn),
        .write_en(write_en),
        .write_data(synced_data),
        .read_en(m00_axis_tvalid && m00_axis_tready),
        .read_data(m00_axis_tdata),
        .empty(empty)
    );

endmodule
