`timescale 1ns / 1ps

module inference_fsm(
    input logic clk,
    input logic reset, //Might have to use a different signal to clear hidden state
    input logic execute,
    input logic [15:0] SW,
    //input logic [6:0] token,
    
    input logic [15:0] ram_data_out,
    input logic read_data_valid,
    input logic [15:0] accumulator_result,
    input logic accumulator_last_valid,
    input logic [15:0] multiply_result,
    input logic multiply_result_valid,

    output logic [15:0] accumulator_data,
    output logic accumulator_input_valid,
    output logic accumulator_last,
    output logic [15:0] multiply_a_data,
    output logic [15:0] multiply_b_data,
    output logic multiply_input_valid,
    
    output logic [15:0] LED,
    output logic [6:0] output_token,
    output logic [26:0] read_address,
    
    output logic [7:0] hex_segA,
    output logic [3:0] hex_gridA,
    output logic [7:0] hex_segB,
    output logic [3:0] hex_gridB

    );
    logic [6:0] token; //TEMP 
    assign token = SW[14:8];
    
    typedef enum logic [5:0] {
        RESET,
        IDLE, //Wait for next execute
        INCREMENT_EMBEDDING_LOAD,
        WAIT_INCREMENT_EMBEDDING_LOAD,
        SET_EMBEDDING_ADDRESS,
        WAIT_SET_EMBEDDING_ADDRESS,
        GET_EMBEDDING,
        LOAD_EMBEDDING, //CONFIRMED EVERYTHING WORKS UNTIL HERE
        INCREMENT_HH_HIDDEN_COUNTER,
        INCREMENT_HIDDEN_NEURON,
        WAIT_INCREMENT_HIDDEN_NEURON,
        SET_HH_WEIGHT_ADDRESS,
        WAIT_SET_HH_WEIGHT_ADDRESS,
        GET_HH_WEIGHT,
        LOAD_HH_MULTIPLY,
        WAIT_HH_MULTIPLY,
        LOAD_HH_WEIGHT_ACCUMULATOR,
        SET_HH_BIAS_ADDRESS,
        WAIT_SET_HH_BIAS_ADDRESS,
        GET_HH_BIAS,
        LOAD_HH_BIAS_ACCUMULATOR,
        INCREMENT_IH_EMBEDDING,
        WAIT_INCREMENT_IH_EMBEDDING,
        SET_IH_WEIGHT_ADDRESS,
        WAIT_SET_IH_WEIGHT_ADDRESS,
        GET_IH_WEIGHT,
        LOAD_IH_MULTIPLY,
        WAIT_IH_MULTIPLY,
        LOAD_IH_WEIGHT_ACCUMULATOR,
        SET_IH_BIAS_ADDRESS,
        WAIT_SET_IH_BIAS_ADDRESS,
        GET_IH_BIAS,
        LOAD_IH_BIAS_ACCUMULATOR,
        ACCUMULATOR_LAST,
        ACCUMULATOR_WAIT,
        LOAD_NEURON, //MAYBE NEED A STATE BEFORE TO GET ACCUMULATOR RESULT?
        DONE
    } state_t;
    state_t current_state, next_state;
    
    //Internal signals
    logic [15:0] new_hidden_layer[LINEAR_SIZE];
    logic [15:0] old_hidden_layer[LINEAR_SIZE];
    logic [15:0] embedding_layer[EMBEDDING_SIZE];
    logic [15:0] logits[VOCAB_SIZE];

    //ALL of these counters need to be 1 bit larger than you would think so they can be initialized at -1 I think
    integer i;
    logic [2:0] embedding_counter; 
    logic [2:0] next_embedding_counter;
    
    logic [3:0] hidden_counter; //Keep track of what hidden neuron is being computed
    logic [3:0] next_hidden_counter;
    
    logic [3:0] hidden_neuron_counter; //Keep track of what hidden neuron is being used to compute
    logic [3:0] next_hidden_neuron_counter;
    
    logic [7:0] logit_counter; //Keep track of what logic is being computed
    logic [7:0] next_logit_counter;
        
    logic [26:0] next_read_address;
    logic [15:0] stored_accumulator_result;

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
                    hidden_counter <= -1;
                    hidden_neuron_counter <= -1;
                    logit_counter <= -1;
                    read_address <= (VOCAB_SIZE * EMBEDDING_SIZE) + 10; //Set this beyond embedding layer
                    stored_accumulator_result <= 0;
                end
            else
                begin
                    current_state <= next_state;
                    
                    embedding_counter <= next_embedding_counter;
                    hidden_counter <= next_hidden_counter;
                    hidden_neuron_counter <= next_hidden_neuron_counter;
                    logit_counter <= next_logit_counter;
                    read_address <= next_read_address; 
                end

            accumulator_input_valid <= 0;
            multiply_input_valid <= 0;
            multiply_a_data <= 0;
            multiply_b_data <= 0;

            unique case(current_state)
                IDLE:
                    begin
                        hidden_counter <= -1;
                        hidden_neuron_counter <= -1;
                        logit_counter <= -1; 
                    end
                    
                LOAD_EMBEDDING:
                    begin
                        embedding_layer[embedding_counter] <= ram_data_out;
                    end    

                INCREMENT_HIDDEN_NEURON:
                    begin
                        accumulator_data <= 0;
                        accumulator_input_valid <= 0;
                    end

                LOAD_HH_MULTIPLY:
                    begin
                        multiply_a_data <= ram_data_out;
                        multiply_b_data <= old_hidden_layer[hidden_neuron_counter];
                        multiply_input_valid <= 1;
                    end
                
                WAIT_HH_MULTIPLY:
                    begin
                        multiply_a_data <= 0;
                        multiply_b_data <= 0;
                        multiply_input_valid <= 0;
                    end

                LOAD_HH_WEIGHT_ACCUMULATOR:
                    begin
                        accumulator_data <= multiply_result;
                        accumulator_input_valid <= 1;
                    end
                
                SET_HH_BIAS_ADDRESS, GET_HH_BIAS:
                    begin
                        accumulator_data <= 0;
                        accumulator_input_valid <= 0;
                    end

                LOAD_HH_BIAS_ACCUMULATOR:
                    begin
                        accumulator_data <= ram_data_out;
                        accumulator_input_valid <= 1;
                    end

                INCREMENT_IH_EMBEDDING:
                    begin
                        accumulator_data <= 0;
                        accumulator_input_valid <= 0;
                    end    

                LOAD_IH_MULTIPLY:
                    begin
                        multiply_a_data <= ram_data_out;
                        multiply_b_data <= embedding_layer[embedding_counter];
                        multiply_input_valid <= 1;
                    end

                WAIT_IH_MULTIPLY:
                    begin
                        multiply_a_data <= 0;
                        multiply_b_data <= 0;
                        multiply_input_valid <= 0;
                    end
                    
                LOAD_IH_WEIGHT_ACCUMULATOR:
                    begin
                        accumulator_data <= multiply_result;
                        accumulator_input_valid <= 1;
                    end

                SET_IH_BIAS_ADDRESS:
                    begin
                        accumulator_data <= 0;
                        accumulator_input_valid <= 0;
                    end

                LOAD_IH_BIAS_ACCUMULATOR:
                    begin
                        accumulator_data <= ram_data_out;
                        accumulator_input_valid <= 1;
                    end

                ACCUMULATOR_LAST:
                    begin
                        accumulator_input_valid <= 1;
                        accumulator_last <= 1;
                    end

                ACCUMULATOR_WAIT:
                    begin
                        accumulator_input_valid <= 0;
                        accumulator_last <= 0;
                        stored_accumulator_result <= accumulator_result;
                    end

                LOAD_NEURON:
                    begin
                        new_hidden_layer[hidden_counter] <= stored_accumulator_result;
                    end

                DONE: //MIGHT HAVE TO DELAY THIS TRANSFER A LITTLE
                    begin
                        for(i = 0; i < LINEAR_SIZE; i++)
                            begin
                                old_hidden_layer[i] <= new_hidden_layer[i];
                            end
                    end
            endcase
        end
    
    always_comb 
        begin
            next_state = current_state;
            next_embedding_counter = embedding_counter;
            next_hidden_counter = hidden_counter;
            next_hidden_neuron_counter = hidden_neuron_counter;
            next_logit_counter = logit_counter;
            next_read_address = read_address;
            
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
                        next_embedding_counter = -1;
                        next_hidden_counter = -1;
                        next_hidden_neuron_counter = -1;
                        next_logit_counter = -1;
                        next_read_address = (VOCAB_SIZE * EMBEDDING_SIZE) + 10; //Set this above where the embedding could be

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
                        next_state = WAIT_INCREMENT_EMBEDDING_LOAD;
                    end

                WAIT_INCREMENT_EMBEDDING_LOAD:
                    begin
                        next_state = SET_EMBEDDING_ADDRESS;
                    end
                    
                SET_EMBEDDING_ADDRESS:
                    begin
                        next_read_address = (token * EMBEDDING_SIZE) + embedding_counter;
                        next_state = WAIT_SET_EMBEDDING_ADDRESS;
                    end
                
                WAIT_SET_EMBEDDING_ADDRESS:
                    begin
                        next_state = GET_EMBEDDING;
                    end
                
                GET_EMBEDDING:
                    begin        
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
                        if(embedding_counter == (EMBEDDING_SIZE - 1))
                            begin
                                next_state = INCREMENT_HH_HIDDEN_COUNTER;
                            end
                         else
                            begin
                                next_state = INCREMENT_EMBEDDING_LOAD;
                            end 
                    end
                
                INCREMENT_HH_HIDDEN_COUNTER:
                    begin
                        next_embedding_counter = -1;
                        next_hidden_neuron_counter = -1;
                        next_hidden_counter <= hidden_counter + 1;
                        next_state = INCREMENT_HIDDEN_NEURON;
                    end
                
                INCREMENT_HIDDEN_NEURON:
                    begin
                         next_hidden_neuron_counter <= hidden_neuron_counter + 1;
                         next_state = WAIT_INCREMENT_HIDDEN_NEURON;
                    end

                WAIT_INCREMENT_HIDDEN_NEURON:
                    begin
                        next_state = SET_HH_WEIGHT_ADDRESS;
                    end

                SET_HH_WEIGHT_ADDRESS:
                    begin
                        next_read_address = (VOCAB_SIZE * EMBEDDING_SIZE) + (EMBEDDING_SIZE * LINEAR_SIZE) + (hidden_counter * LINEAR_SIZE) + (hidden_neuron_counter); 

                        next_state = WAIT_SET_HH_WEIGHT_ADDRESS;
                    end

                WAIT_SET_HH_WEIGHT_ADDRESS:
                    begin
                        next_state = GET_HH_WEIGHT;
                    end

                GET_HH_WEIGHT:
                    begin
                        if(read_data_valid)
                            begin
                                next_state = LOAD_HH_MULTIPLY;
                            end
                        else
                            begin
                                next_state = GET_HH_WEIGHT;
                            end
                    end
                
                LOAD_HH_MULTIPLY:
                    begin
                        next_state = WAIT_HH_MULTIPLY;
                    end

                WAIT_HH_MULTIPLY:
                    begin 
                        if(multiply_result_valid)
                            begin
                                next_state = LOAD_HH_WEIGHT_ACCUMULATOR;
                            end
                        else
                            begin
                                next_state = WAIT_HH_MULTIPLY;
                            end
                    end

                LOAD_HH_WEIGHT_ACCUMULATOR:
                    begin
                        if(hidden_neuron_counter == (LINEAR_SIZE - 1))
                            begin
                                next_state = SET_HH_BIAS_ADDRESS;
                            end
                        else
                            begin
                                next_state = INCREMENT_HIDDEN_NEURON;
                            end
                    end

                SET_HH_BIAS_ADDRESS:
                    begin
                        next_read_address = (VOCAB_SIZE * EMBEDDING_SIZE) + (EMBEDDING_SIZE * LINEAR_SIZE) + (LINEAR_SIZE * LINEAR_SIZE) + LINEAR_SIZE + hidden_counter; 

                        next_state = WAIT_SET_HH_BIAS_ADDRESS;
                        
                    end

                WAIT_SET_HH_BIAS_ADDRESS:
                    begin
                        next_state = GET_HH_BIAS;
                    end

                GET_HH_BIAS:
                    begin
                        if(read_data_valid)
                            begin
                                next_state = LOAD_HH_BIAS_ACCUMULATOR;
                            end
                        else
                            begin
                                next_state = GET_HH_BIAS;
                            end
                    end

                LOAD_HH_BIAS_ACCUMULATOR:
                    begin
                        next_state = INCREMENT_IH_EMBEDDING;
                    end

                INCREMENT_IH_EMBEDDING:
                    begin
                        next_embedding_counter = embedding_counter + 1;
                        next_state = SET_IH_WEIGHT_ADDRESS;
                    end

                WAIT_INCREMENT_IH_EMBEDDING:
                    begin
                        next_state = SET_IH_WEIGHT_ADDRESS;
                    end

                SET_IH_WEIGHT_ADDRESS:
                    begin
                        next_read_address = (VOCAB_SIZE * EMBEDDING_SIZE) + (hidden_counter * EMBEDDING_SIZE) + (embedding_counter);
                        
                        next_state = WAIT_SET_IH_WEIGHT_ADDRESS;
                    end

                WAIT_SET_IH_WEIGHT_ADDRESS:
                    begin
                        next_state = GET_IH_WEIGHT;
                    end

                GET_IH_WEIGHT:
                    begin
                        if(read_data_valid)
                            begin
                                next_state = LOAD_IH_MULTIPLY;
                            end
                        else
                            begin
                                next_state = GET_IH_WEIGHT;
                            end
                    end

                LOAD_IH_MULTIPLY:
                    begin
                        next_state = WAIT_IH_MULTIPLY;
                    end

                WAIT_IH_MULTIPLY:
                    begin
                        if(multiply_result_valid)
                            begin
                                next_state = LOAD_IH_WEIGHT_ACCUMULATOR;
                            end
                        else
                            begin
                                next_state = WAIT_IH_MULTIPLY;
                            end
                    end

                LOAD_IH_WEIGHT_ACCUMULATOR:
                    begin
                        if(embedding_counter == (EMBEDDING_SIZE - 1))
                            begin
                                next_state = SET_IH_BIAS_ADDRESS;
                            end
                        else
                            begin
                                next_state = INCREMENT_IH_EMBEDDING;
                            end
                    end
                
                SET_IH_BIAS_ADDRESS:
                    begin
                        next_read_address = (VOCAB_SIZE * EMBEDDING_SIZE) + (EMBEDDING_SIZE * LINEAR_SIZE) + (LINEAR_SIZE * LINEAR_SIZE) + (hidden_counter); 

                        next_state = WAIT_SET_IH_BIAS_ADDRESS;
                    end

                WAIT_SET_IH_BIAS_ADDRESS:
                    begin
                        next_state = GET_IH_BIAS;
                    end

                GET_IH_BIAS:
                    begin
                        if(read_data_valid)
                            begin
                                next_state = LOAD_IH_BIAS_ACCUMULATOR;
                            end
                        else
                            begin
                                next_state = GET_IH_BIAS;
                            end
                    end

                LOAD_IH_BIAS_ACCUMULATOR:
                    begin
                        next_state = ACCUMULATOR_LAST;
                    end

                ACCUMULATOR_LAST:
                    begin 
                        next_state = ACCUMULATOR_WAIT;
                    end

                ACCUMULATOR_WAIT:
                    begin
                        if(accumulator_last_valid)
                            begin
                                next_state = LOAD_NEURON;
                            end
                        else
                            begin
                                next_state = ACCUMULATOR_WAIT;
                            end
                    end

                LOAD_NEURON:
                    begin
                        if(hidden_counter == (LINEAR_SIZE - 1))
                            begin
                                next_state = DONE;
                            end
                        else
                            begin
                                next_state = INCREMENT_HH_HIDDEN_COUNTER;
                            end
                    end

                DONE:
                    begin

                    end

            endcase    
        
        end
    
    
    logic [2:0] index = SW[2:0];
    
    assign LED[4:0] = current_state; 
    assign LED[6:5] = embedding_counter;
    assign LED[11:7] = hidden_counter;
    assign LED [15:12] = hidden_neuron_counter;
    
    hex_driver hexA   (.clk(clk), 
                      .reset(reset),
                      .in({SW[15:12], SW[11:8], SW[7:4], SW[3:0]}),
                      .hex_seg(hex_segA),
                      .hex_grid(hex_gridA));
 
    hex_driver hexB   (.clk(clk), 
                      .reset(reset),
                      .in({new_hidden_layer[index][15:12], new_hidden_layer[index][11:8], new_hidden_layer[index][7:4], new_hidden_layer[index][3:0]}),
                      .hex_seg(hex_segB),
                      .hex_grid(hex_gridB));
    
endmodule
