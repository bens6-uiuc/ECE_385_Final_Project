`timescale 1ns / 1ps

module test_ascii_generate(
    input logic clk,
    input logic execute, 
   
    output logic [7:0] generated_ascii,
    output logic [11:0] generate_count
    );
    
    always_ff @ (posedge clk)
    begin
        if(execute && (generate_count < 27))
        begin
            generated_ascii = generated_ascii + 1;
            generate_count = generate_count + 1;
        end
        else 
        begin
            if(generate_count > 25)
            begin
                generated_ascii = generated_ascii;
                generate_count = generate_count;  
            end
            else 
            begin
                generated_ascii = 96;
                generate_count = 0;  
            end      
        end
    
    end  
    
endmodule
