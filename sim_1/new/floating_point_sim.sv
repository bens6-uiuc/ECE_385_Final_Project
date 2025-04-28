`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/27/2025 09:23:28 PM
// Design Name: 
// Module Name: floating_point_sim
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


module floating_point_sim();

timeunit 10ns;
timeprecision 1ns;

	logic  clk;
	logic [31:0] a_data, b_data, result;
	logic a_valid, b_valid, a_add_ready, b_add_ready, a_multiply_ready, b_multiply_ready;
	logic multiply_valid, add_valid;
   
    
    floating_point_adder adder1 (
  .aclk(clk),                                  // input wire aclk
  .s_axis_a_tvalid(a_valid),            // input wire s_axis_a_tvalid
  .s_axis_a_tready(a_add_ready),            // output wire s_axis_a_tready
  .s_axis_a_tdata(a_data),              // input wire [31 : 0] s_axis_a_tdata
  .s_axis_b_tvalid(b_valid),            // input wire s_axis_b_tvalid
  .s_axis_b_tready(b_add_ready),            // output wire s_axis_b_tready
  .s_axis_b_tdata(b_data),              // input wire [31 : 0] s_axis_b_tdata
  .m_axis_result_tvalid(add_valid),  // output wire m_axis_result_tvalid
  .m_axis_result_tready(m_axis_result_tready),  // input wire m_axis_result_tready
  .m_axis_result_tdata(result)    // output wire [31 : 0] m_axis_result_tdata
);

    floating_point_multiply multiply1 (
  .aclk(clk),                                  // input wire aclk
  .s_axis_a_tvalid(a_valid),            // input wire s_axis_a_tvalid
  .s_axis_a_tready(a_multiply_ready),            // output wire s_axis_a_tready
  .s_axis_a_tdata(a_data),              // input wire [31 : 0] s_axis_a_tdata
  .s_axis_b_tvalid(b_valid),            // input wire s_axis_b_tvalid
  .s_axis_b_tready(b_multiply_ready),            // output wire s_axis_b_tready
  .s_axis_b_tdata(b_data),              // input wire [31 : 0] s_axis_b_tdata
  .m_axis_result_tvalid(multiply_valid),  // output wire m_axis_result_tvalid
  .m_axis_result_tready(m_axis_result_tready),  // input wire m_axis_result_tready
  .m_axis_result_tdata(result)    // output wire [31 : 0] m_axis_result_tdata
);
    
initial begin: CLOCK_INITIALIZATION
    clk = 1'b1;
end 

always begin : CLOCK_GENERATION
    #1 clk = ~clk;
end

initial begin: TEST_FLOATING

    a_data = 'h00000000;
    b_data = 'h00000000;
    a_valid = 'b0;
    b_valid = 'b0;  
        
    repeat (100) @(posedge clk);

     a_data = 'h45bf70fc;
     b_data = 'h40998b1a;

    repeat (1000) @(posedge clk);
    
    a_valid = 'b1;
    b_valid = 'b1;
    
    repeat (100) @(posedge clk);

    a_valid = 'b0;
    b_valid = 'b0;
    
    repeat (20000) @(posedge clk);
            
    $finish();
end  

endmodule
