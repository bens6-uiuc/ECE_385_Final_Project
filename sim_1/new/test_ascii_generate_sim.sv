`timescale 1ns / 1ps

module test_ascii_generate_sim();

timeunit 10ns;
timeprecision 1ns;

	logic  clk, execute;
	logic [7:0] generated_ascii;
	logic [11:0] generate_count;
   
    
    test_ascii_generate TEST_GENERATE(
        .clk(clk),
        .execute(execute),
        .generated_ascii(generated_ascii),
        .generate_count(generate_count)
    );
    
initial begin: CLOCK_INITIALIZATION
    clk = 1'b1;
end 

always begin : CLOCK_GENERATION
    #1 clk = ~clk;
end
    

initial begin: TEST_ASCII

    execute = 'b0;
    generated_ascii = 1;
    generate_count = 0;
        
    repeat (10) @(posedge clk);

    execute <= 'b1; 

    repeat (1000) @(posedge clk);

            
    $finish();
end  

endmodule
