`timescale 1ns / 1ps

module multiply_sim();

timeunit 10ns;
timeprecision 1ns;

logic clk;
logic [15:0] a_data, b_data, result_data;
logic a_valid, b_valid, result_valid, a_ready, b_ready, result_ready;


  multiply multiply (
  .aclk(clk),                                  // input wire aclk
  .s_axis_a_tvalid(a_valid),            // input wire s_axis_a_tvalid
  .s_axis_a_tdata(a_data),              // input wire [15 : 0] s_axis_a_tdata
  .s_axis_b_tvalid(b_valid),            // input wire s_axis_b_tvalid
  .s_axis_b_tdata(b_data),              // input wire [15 : 0] s_axis_b_tdata
  .m_axis_result_tvalid(result_valid),  // output wire m_axis_result_tvalid
  .m_axis_result_tdata(result_data)    // output wire [15 : 0] m_axis_result_tdata
);

initial begin: CLOCK_INITIALIZATION
    clk = 1'b1;
end 

always begin : CLOCK_GENERATION
    #1 clk = ~clk;
end

initial begin: TEST_ASCII

    a_data = 0;
    b_data = 0;
    result_data = 0;
    a_valid = 0;
    a_ready = 0;
    b_valid = 0;
    b_ready = 0;
    result_valid = 0;
    result_ready = 1;
        
    repeat (10) @(posedge clk);
    
    a_ready <= 1;
    b_ready <= 1;
    
    repeat (10) @(posedge clk);
    a_data <= 'hb600;
    b_data <= 'h7451;
    
    repeat (10) @(posedge clk);
    
    a_valid <= 1;
    b_valid <= 1;

    repeat (100000) @(posedge clk);

            
    $finish();
end  

endmodule