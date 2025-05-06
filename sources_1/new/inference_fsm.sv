`timescale 1ns / 1ps

module inference_fsm(
    input logic clk,
    input logic reset,
    input logic execute,
    input logic read_data_valid,
    input logic [15:0] SW,
    //input logic [6:0] token,
    input logic [15:0] ram_data_out,
    
    output logic [15:0] LED,
    output logic [6:0] output_token,
    output logic [26:0] read_address,
    
    output logic [7:0] hex_segA,
    output logic [3:0] hex_gridA,
    output logic [7:0] hex_segB,
    output logic [3:0] hex_gridB

    );
    logic [6:0] token; //TEMP 
    assign token = 1;
    
    typedef enum logic [2:0] {
        RESET,
        IDLE, //Wait for next execute
        INCREMENT_EMBEDDING_LOAD,
        SET_EMBEDDING_ADDRESS,
        GET_EMBEDDING,
        LOAD_EMBEDDING,
        INCREMENT_HIDDEN_COUNTER,
        INCREMENT_HIDDEN_NEURON
        
    } state_t;
    state_t current_state, next_state;
    
    //Internal signals
    logic [15:0] new_hidden_layer[LINEAR_SIZE];
    logic [15:0] old_hidden_layer[LINEAR_SIZE];
    logic [15:0] embedding_layer[EMBEDDING_SIZE];
    logic [15:0] logits[VOCAB_SIZE];

    integer i;
    logic [5:0] embedding_counter;
    logic [3:0] next_embedding_counter;
    
    logic [2:0] hidden_counter; //Keep track of what hidden neuron is being computed
    logic [2:0] hidden_neuron_counter; //Keep track of what hidden neuron is being used to compute
    logic [6:0] logit_counter; //Keep track of what logic is being computed
        
    localparam VOCAB_SIZE = 76;
    localparam EMBEDDING_SIZE = 4;
    localparam LINEAR_SIZE = 8;
    
    always_ff @ (posedge clk)
        begin
            if(reset)
                begin
                    current_state <= RESET;
                    
                    for (i = 0; i < LINEAR_SIZE; i++) begin
                        new_hidden_layer[i] <= 0;
                        old_hidden_layer[i] <= 0;
                    end
                    
                    for(i = 0; i < EMBEDDING_SIZE; i++) begin
                        embedding_layer[i] <= 0;
                    end
                    
                    for(i = 0; i < VOCAB_SIZE; i++) begin
                        logits[i] <= 0;     
                    end
                    
                    embedding_counter <= -1;
                    hidden_counter <= 0;
                    hidden_neuron_counter <= 0;
                    logit_counter <= 0;
                    
                end
            else
                begin
                    current_state <= next_state;
                    embedding_counter <= next_embedding_counter;
                end
            
            unique case(current_state)
                IDLE:
                    begin
                        hidden_counter <= 0;
                        hidden_neuron_counter <= 0;
                        logit_counter <= 0; 
                    end
                    
                LOAD_EMBEDDING:
                    begin
                        embedding_layer[embedding_counter] <= ram_data_out;
                    end    
                    
            endcase
        end
    
    always_comb 
        begin
            next_state = current_state;
            next_embedding_counter = embedding_counter;
            read_address = 0;
            
            unique case(current_state)
                RESET:
                    begin                         
                        if(execute)
                            begin
                                next_state = IDLE;
                            end
                        else
                            begin
                                next_state = RESET;
                            end    
                    end
                
                IDLE:
                    begin 
                        if(execute)
                            begin
                                next_state = INCREMENT_EMBEDDING_LOAD;
                            end
                        else 
                            begin
                                next_state = IDLE;
                            end
                            
                    end
                    
                INCREMENT_EMBEDDING_LOAD:
                    begin
                        next_embedding_counter = embedding_counter + 1;
                        next_state = SET_EMBEDDING_ADDRESS;
                    end
                    
                SET_EMBEDDING_ADDRESS:
                    begin
                        read_address = (token * EMBEDDING_SIZE) + embedding_counter;
          
                        if(!read_data_valid)
                            begin
                                next_state = GET_EMBEDDING;
                            end
                        else
                            begin
                                next_state = SET_EMBEDDING_ADDRESS;
                            end    
                    end
                
                GET_EMBEDDING:
                    begin
                        read_address = (token * EMBEDDING_SIZE) + embedding_counter;
                        
                        if(read_data_valid)
                            begin
                                next_state = LOAD_EMBEDDING;
                            end
                        else
                            begin
                                next_state = GET_EMBEDDING;
                            end
                    end
                
                LOAD_EMBEDDING:
                    begin
                        read_address = (token * EMBEDDING_SIZE) + embedding_counter;
                    
                        if(embedding_counter == (EMBEDDING_SIZE - 1))
                            begin
                                next_state = INCREMENT_HIDDEN_COUNTER;
                                next_embedding_counter = 0;
                            end
                         else
                            begin
                                next_state = INCREMENT_EMBEDDING_LOAD;
                            end 
                    end
                
                INCREMENT_HIDDEN_COUNTER:
                    begin
                        read_address = (VOCAB_SIZE * EMBEDDING_SIZE) + (EMBEDDING_SIZE * LINEAR_SIZE) + (hidden_counter * LINEAR_SIZE) + (hidden_neuron_counter);
                    end
                
                INCREMENT_HIDDEN_NEURON:
                    begin
                         read_address = (VOCAB_SIZE * EMBEDDING_SIZE) + (EMBEDDING_SIZE * LINEAR_SIZE) + (hidden_counter * LINEAR_SIZE) + (hidden_neuron_counter); 
                    end
            endcase    
        
        end
    
    
    logic [4:0] index = SW[4:0];
    
    assign LED[2:0] = current_state; 
    assign LED[4:3] = embedding_counter;
    assign LED[15:5] = read_address[10:0];
    
    hex_driver hexA   (.clk(clk), 
                      .reset(reset),
                      .in({SW[15:12], SW[11:8], SW[7:4], SW[3:0]}),
                      .hex_seg(hex_segA),
                      .hex_grid(hex_gridA));
 
    hex_driver hexB   (.clk(clk), 
                      .reset(reset),
                      .in({embedding_layer[index][15:12], embedding_layer[index][11:8], embedding_layer[index][7:4], embedding_layer[index][3:0]}),
                      .hex_seg(hex_segB),
                      .hex_grid(hex_gridB));
    
endmodule
