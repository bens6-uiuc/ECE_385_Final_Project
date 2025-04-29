`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/27/2025 07:17:00 PM
// Design Name: 
// Module Name: inference
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module inference(
    input logic clk,
    input logic [7:0] input_ascii,
    input logic execute,
    
    output logic [7:0] generated_ascii,
    output logic [11:0] generate_count,
    output logic generate_complete
    );
    
    logic [7:0] generated_ascii;
    logic [11:0] generate_count;
    logic [6:0]token;
    logic [26:0] embedding_address;
    logic [3:0] embedding_counter;
    
    logic [31:0] hidden_layer[16];
    
    ascii_to_token (
        .input_ascii(input_ascii),
        .output_token(token)
    );
    
    always_ff @ (posedge clk) //Maybe make this based on the ram read valid signal???
    begin
        if(execute)
        begin
            embedding_address <= (token * 16) + embedding_counter; 
            embedding_counter <= embedding_counter + 1;
        end
        else
        begin
            embedding_counter <= 0;
        end
    end
    
    
    
    floating_point_adder adder1 (
  .aclk(clk),                                  // input wire aclk
  .s_axis_a_tvalid(s_axis_a_tvalid),            // input wire s_axis_a_tvalid
  .s_axis_a_tready(s_axis_a_tready),            // output wire s_axis_a_tready
  .s_axis_a_tdata(s_axis_a_tdata),              // input wire [31 : 0] s_axis_a_tdata
  .s_axis_b_tvalid(s_axis_b_tvalid),            // input wire s_axis_b_tvalid
  .s_axis_b_tready(s_axis_b_tready),            // output wire s_axis_b_tready
  .s_axis_b_tdata(s_axis_b_tdata),              // input wire [31 : 0] s_axis_b_tdata
  .m_axis_result_tvalid(m_axis_result_tvalid),  // output wire m_axis_result_tvalid
  .m_axis_result_tready(m_axis_result_tready),  // input wire m_axis_result_tready
  .m_axis_result_tdata(m_axis_result_tdata)    // output wire [31 : 0] m_axis_result_tdata
);

    floating_point_multiply multiply1 (
  .aclk(clk),                                  // input wire aclk
  .s_axis_a_tvalid(s_axis_a_tvalid),            // input wire s_axis_a_tvalid
  .s_axis_a_tready(s_axis_a_tready),            // output wire s_axis_a_tready
  .s_axis_a_tdata(s_axis_a_tdata),              // input wire [31 : 0] s_axis_a_tdata
  .s_axis_b_tvalid(s_axis_b_tvalid),            // input wire s_axis_b_tvalid
  .s_axis_b_tready(s_axis_b_tready),            // output wire s_axis_b_tready
  .s_axis_b_tdata(s_axis_b_tdata),              // input wire [31 : 0] s_axis_b_tdata
  .m_axis_result_tvalid(m_axis_result_tvalid),  // output wire m_axis_result_tvalid
  .m_axis_result_tready(m_axis_result_tready),  // input wire m_axis_result_tready
  .m_axis_result_tdata(m_axis_result_tdata)    // output wire [31 : 0] m_axis_result_tdata
);

    
endmodule
