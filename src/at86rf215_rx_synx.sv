`timescale 1ns / 1ps


module at86rf215_iq_rx_sync # 
(
    parameter integer SYNC_THRESHOLD = 5,
    parameter integer DESYNC_THRESHOLD = 4,
    parameter integer C_M00_AXIS_TDATA_WIDTH = 32
)
(
    input logic aclk,
    input logic aresetn,
    input logic [1:0] iq_data_in,
    input logic [3:0] sample_rate,
    output logic [C_M00_AXIS_TDATA_WIDTH  - 1 : 0] synced_data, 
    output logic write_en,
    output logic in_sync,
    output logic desync,
    output logic last_word,
    output logic sync_cond
);
	localparam MAX_SAMPLE_RATE = 10;
	
	
    logic [31:0] input_word;
    always_ff @(posedge aclk or negedge aresetn) begin
        if (!aresetn) begin
            input_word <= 0;
        end
        else begin
            input_word <= {input_word[29:0], iq_data_in[1:0]};
        end
    end
    
    
    logic [$clog2(C_M00_AXIS_TDATA_WIDTH / 2) - 1 : 0] inputs_counter;
    always_ff @(posedge aclk or negedge aresetn) begin
        if (!aresetn) begin
            inputs_counter <= 0;
        end
        else begin
            inputs_counter <= first_sync && sync_cond ? 0 : inputs_counter + 1;
        end
    end
    
    always_comb begin
        synced_data = input_word;
    end
    
    logic [$clog2(MAX_SAMPLE_RATE + DESYNC_THRESHOLD + 1) - 1 : 0] word_counter;
    always_ff @(posedge aclk or negedge aresetn) begin
        if (!aresetn) begin
            word_counter <= 0;
        end
        else begin
            if (word_counter <= desync - 1) begin 
                if (sync_cond) begin
                    word_counter <= 0;
                end
                else begin
                    word_counter <= last_input_of_word ? word_counter + 1 : word_counter;
                end
            end
            else begin
                word_counter <= 0;
            end
        end
    end
    
    /*
     * It is necessary to distinguish first and other syncs. In the first sync there is no danger 
     * that the data can be confused for sync bits, since only zeros were being sent.
     * for the last and other syncs there could be words before that could be confused for sync bits.
     * To avoid this we check each time whether a whole 32-bit word has been received after the first one.
     */
    logic [$clog2(SYNC_THRESHOLD) - 1 : 0] syncs_counter;
    always_ff @(posedge aclk or negedge aresetn) begin
        if (!aresetn) begin
            syncs_counter <= 0;
        end
        else begin
            if (first_sync) begin
                syncs_counter <= sync_cond ? syncs_counter + 1 : syncs_counter;
            end
            else if (last_sync) begin
                syncs_counter <= desync ? 0 : syncs_counter;
            end
            else begin
                syncs_counter <= last_input_of_word && sync_cond ? syncs_counter + 1 : syncs_counter;
            end
        end
    end
    
    logic first_sync, last_input_of_word, last_sync;
    always_comb begin
        sync_cond = input_word[31:30] == 2'b10 && input_word[15:14] == 2'b01;
        write_en = sync_cond;
        in_sync = last_sync;
        first_sync = syncs_counter == 0;
        desync = word_counter == sample_rate + DESYNC_THRESHOLD + 1;
        last_input_of_word = inputs_counter == C_M00_AXIS_TDATA_WIDTH / 2 - 1; 
        last_sync = syncs_counter == SYNC_THRESHOLD;
    end
endmodule