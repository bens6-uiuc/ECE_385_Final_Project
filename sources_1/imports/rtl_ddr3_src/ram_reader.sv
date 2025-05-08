`timescale 1ns / 1ps
//Zuofu Cheng (2024) for ECE 385, wrapper for VHDL XESS SDCard driver
//
//
//Module reads out of DDR3 MIG and outputs 16 bit values on 'read_data_out'.
//Understand carefully this module to adapt it to your own designs

module ram_reader(
	input  logic clk,
	input  logic reset,               //starts as soon reset is deasserted
	output logic [26:0] ram_address,  //the following 4 signals control the command FIFO
    output logic [2:0] ram_cmd,       
    output logic ram_en,             
    input  logic ram_rdy,
    input  logic ram_rd_valid,
    input  logic ram_rd_data_end,
    input  logic [63:0] ram_rd_data,
    input  logic [26:0] read_address,
    output logic [15:0] read_data_out,  //16-bit output word
    output logic read_data_valid        //16-bit output is valid
    );
    
    logic [26:0] old_ram_address;
    logic [127:0] data_burst;
    logic [2:0] old_word_sel;
    logic [2:0] word_sel;
    
    assign word_sel = read_address[2:0];
    
    //combinationally assign displayed output based on correct address field;
    assign read_data_out = data_burst [word_sel*16 +: 16]; //select 16 bit word from burst
    
    always_ff @(posedge clk) begin
    if (reset) begin
        ram_cmd <= 3'b000;
        ram_en <= 1'b0;
        old_ram_address <= 27'h7FFFFFF; 
        old_word_sel <= 3'b111;
        data_burst <= 128'h0;
        read_data_valid <= 1'b0;
    end else begin
        if (old_ram_address != read_address && ram_rdy) begin
            read_data_valid <= 1'b0;
        end else if (old_word_sel != word_sel && !ram_rd_valid) begin 
            read_data_valid <= 1'b0; 
        end else if (ram_rd_valid && ram_rd_data_end) begin
            read_data_valid <= 1'b1;
        end

        if (old_ram_address != read_address && ram_rdy) begin
            ram_cmd <= 3'b001;
            ram_en <= 1'b1;
            ram_address <= (read_address & 27'h7FFFFF8); 
            old_ram_address <= read_address; 
        end else if (ram_rd_valid) begin
            ram_en <= 1'b0; 
        end

        if (ram_rd_valid) begin
            if (ram_rd_data_end) begin
                data_burst[63:0] <= ram_rd_data; // Assign lower words
            end else begin
                data_burst[127:64] <= ram_rd_data; // Assign upper words
            end
        end

        if (old_word_sel != word_sel) begin
            old_word_sel <= word_sel;
        end
    end
end  
endmodule
