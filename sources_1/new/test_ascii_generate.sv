`timescale 1ns / 1ps

module test_ascii_generate(
    input logic clk,
    input logic execute, 
   
    output logic [7:0] generated_ascii,
    output logic [11:0] generate_count
    );
    
    logic [19:0] clk_div_counter = 0;
    logic slow_clk_en = 0;
    
    // Generate enable pulse every 100 clock cycles
    always_ff @(posedge clk) begin
        if (clk_div_counter == 1000000) begin
            clk_div_counter <= 0;
            slow_clk_en <= 1;
        end else begin
            clk_div_counter <= clk_div_counter + 1;
            slow_clk_en <= 0;
        end
    end
    
    always_ff @ (posedge clk)
    begin
        if(slow_clk_en) 
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
    end  
    
endmodule
