`timescale 1ns / 1ps

module accumulator_sim();



timeunit 10ns;
timeprecision 1ns;

logic clk;
logic [15:0] accumulator_data, accumulator_result;
logic accumulator_input_valid, accumulator_last, accumulator_output_valid, accumulator_last_valid;


    accumulator accumulator (
  .aclk(clk),                                  
  .s_axis_a_tvalid(accumulator_input_valid),            // input wire s_axis_a_tvalid
  .s_axis_a_tdata(accumulator_data),              // input wire [15 : 0] s_axis_a_tdata
  .s_axis_a_tlast(accumulator_last),              // input wire s_axis_a_tlast
  .m_axis_result_tvalid(accumulator_output_valid),  // output wire m_axis_result_tvalid
  .m_axis_result_tdata(accumulator_result),    // output wire [15 : 0] m_axis_result_tdata
  .m_axis_result_tlast(accumulator_last_valid)    // output wire m_axis_result_tlast
    );

initial begin: CLOCK_INITIALIZATION
    clk = 1'b1;
end 

always begin : CLOCK_GENERATION
    #1 clk = ~clk;
end

initial begin: TEST_ASCII

    accumulator_data = 0;
    accumulator_input_valid = 0;
    accumulator_last = 0;
    
    repeat (20) @(posedge clk);
    
    accumulator_input_valid = 1;  
    accumulator_last = 1;  
    
    repeat (1) @(posedge clk);
    
    accumulator_input_valid = 0;  
    accumulator_last = 0;  
    
    repeat (30) @(posedge clk);
    
    accumulator_data = 'h3c00;
    accumulator_input_valid = 1;   
    
    
    repeat (2) @(posedge clk);
    
    accumulator_input_valid = 0;
    
    repeat (2) @(posedge clk);
          
    accumulator_data = 'h4000;
    accumulator_input_valid = 1;      
    
    repeat (1) @(posedge clk);
        
    accumulator_input_valid = 0;    

    repeat (2) @(posedge clk);
          
    accumulator_data = 'h4200;
    accumulator_input_valid = 1;  
    accumulator_last = 1;    
    
    repeat (1) @(posedge clk);
        
    accumulator_input_valid = 0;  
    accumulator_last = 0;
    
    repeat (1) @(posedge clk);
    
    accumulator_data = 0;

    @(posedge accumulator_output_valid);
    
    repeat (20) @(posedge clk);
    
    $finish();
end  

endmodule