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
        RESET, //0
        IDLE, //Wait for next execute
        INCREMENT_EMBEDDING_LOAD, //2
        WAIT_INCREMENT_EMBEDDING_LOAD, 
        SET_EMBEDDING_ADDRESS, //4
        WAIT_SET_EMBEDDING_ADDRESS, 
        GET_EMBEDDING, //6
        LOAD_EMBEDDING, //CONFIRMED EVERYTHING WORKS UNTIL HERE
        INCREMENT_HH_HIDDEN_COUNTER, //8
        INCREMENT_HIDDEN_NEURON, 
        WAIT_INCREMENT_HIDDEN_NEURON, //10
        SET_HH_WEIGHT_ADDRESS, 
        WAIT_SET_HH_WEIGHT_ADDRESS, //12
        GET_HH_WEIGHT, 
        LOAD_HH_MULTIPLY, //14
        WAIT_HH_MULTIPLY, 
        LOAD_HH_WEIGHT_ACCUMULATOR, //16
        SET_HH_BIAS_ADDRESS, 
        WAIT_SET_HH_BIAS_ADDRESS, //18
        GET_HH_BIAS, 
        LOAD_HH_BIAS_ACCUMULATOR, //20
        INCREMENT_IH_EMBEDDING, 
        WAIT_INCREMENT_IH_EMBEDDING, //22
        SET_IH_WEIGHT_ADDRESS, 
        WAIT_SET_IH_WEIGHT_ADDRESS, //24
        GET_IH_WEIGHT,
        LOAD_IH_MULTIPLY, //26
        WAIT_IH_MULTIPLY,
        LOAD_IH_WEIGHT_ACCUMULATOR, //28
        SET_IH_BIAS_ADDRESS,
        WAIT_SET_IH_BIAS_ADDRESS, //30
        GET_IH_BIAS,
        LOAD_IH_BIAS_ACCUMULATOR, //32
        ACCUMULATOR_LAST_HIDDEN,
        ACCUMULATOR_WAIT_HIDDEN, //34
        LOAD_NEURON, 

        INCREMENT_LOGIT_LOAD_COUNTER, //36
        INCREMENT_LOGIT_COUNTER,
        WAIT_INCREMENT_LOGIT_COUNTER, //40
        SET_LINEAR_WEIGHT_ADDRESS,
        WAIT_SET_LINEAR_WEIGHT_ADDRESS, //42
        GET_LINEAR_WEIGHT,
        LOAD_LINEAR_MULTIPLY, //44
        WAIT_LINEAR_MULTIPLY,
        LOAD_LINEAR_WEIGHT_ACCUMULATOR, //46
        SET_LINEAR_BIAS_ADDRESS,
        WAIT_SET_LINEAR_BIAS_ADDRESS, //48
        GET_LINEAR_BIAS,
        LOAD_LINEAR_BIAS_ACCUMULATOR, //50
        ACCUMULATOR_LAST_LINEAR,
        ACCUMULATOR_WAIT_LINEAR, //52
        LOAD_LOGIT,

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

    logic [7:0] logit_load_counter; //Keep track of what logic is being computed
    logic [7:0] next_logit_load_counter;
    
    logic [7:0] logit_counter; //Keep track of what logic is being used to computed
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
                    logit_load_counter <= -1;
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
                    logit_load_counter <= next_logit_load_counter;
                    read_address <= next_read_address; 
                end

            unique case(current_state)
                IDLE:
                    begin
                        hidden_counter <= -1;
                        hidden_neuron_counter <= -1;
                        logit_counter <= -1; 
                        logit_load_counter <= -1;
                        accumulator_last <= 1;
                        accumulator_input_valid <= 1;
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

                ACCUMULATOR_LAST_HIDDEN:
                    begin
                        accumulator_input_valid <= 1;
                        accumulator_last <= 1;
                    end

                ACCUMULATOR_WAIT_HIDDEN:
                    begin
                        accumulator_input_valid <= 0;
                        accumulator_last <= 0;
                        stored_accumulator_result <= accumulator_result;
                    end

                LOAD_NEURON:
                    begin
                        new_hidden_layer[hidden_counter] <= stored_accumulator_result;
                    end

                INCREMENT_LOGIT_LOAD_COUNTER:
                    begin
                        accumulator_data <= 0;
                        accumulator_input_valid <= 0;
                    end

                LOAD_LINEAR_MULTIPLY:
                    begin
                        multiply_a_data <= ram_data_out;
                        multiply_b_data <= new_hidden_layer[logit_counter];
                        multiply_input_valid <= 1;
                    end

                WAIT_LINEAR_MULTIPLY:
                    begin
                        multiply_a_data <= 0;
                        multiply_b_data <= 0;
                        multiply_input_valid <= 0;
                    end

                LOAD_LINEAR_WEIGHT_ACCUMULATOR:
                    begin
                        accumulator_data <= multiply_result;
                        accumulator_input_valid <= 1;
                    end

                SET_LINEAR_BIAS_ADDRESS:
                    begin
                        accumulator_data <= 0;
                        accumulator_input_valid <= 0;
                    end

                LOAD_LINEAR_BIAS_ACCUMULATOR:
                    begin
                        accumulator_data <= ram_data_out;
                        accumulator_input_valid <= 1;
                    end

                ACCUMULATOR_LAST_LINEAR:
                    begin
                        accumulator_input_valid <= 1;
                        accumulator_last <= 1;
                    end

                ACCUMULATOR_WAIT_LINEAR:
                    begin
                        accumulator_input_valid <= 0;
                        accumulator_last <= 0;
                        stored_accumulator_result <= accumulator_result;
                    end

                LOAD_LOGIT:
                    begin
                        logits[logit_load_counter] <= stored_accumulator_result;
                    end

                DONE: //MIGHT HAVE TO DELAY THIS TRANSFER A LITTLE
                    begin
                        for(i = 0; i < LINEAR_SIZE; i++)
                            begin
                                old_hidden_layer[i] <= new_hidden_layer[i];
                            end
                    end

                default: 
                    begin
                        accumulator_data <= 0;
                        accumulator_input_valid <= 0;
                        accumulator_last <= 0;
                        multiply_input_valid <= 0;
                        multiply_a_data <= 0;
                        multiply_b_data <= 0;
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
            next_logit_load_counter = logit_load_counter;
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
                        if(!read_data_valid)
                            begin
                                next_state = GET_EMBEDDING;
                            end
                        else
                            begin
                                next_state = WAIT_SET_EMBEDDING_ADDRESS;
                            end
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
                        if(!read_data_valid)
                            begin
                                next_state = GET_HH_WEIGHT;
                            end
                        else
                            begin
                                next_state = WAIT_SET_HH_WEIGHT_ADDRESS;
                            end
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
                        if(!read_data_valid)
                            begin
                                next_state = GET_HH_BIAS;
                            end
                        else
                            begin
                                next_state = WAIT_SET_HH_BIAS_ADDRESS;
                            end
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
                        next_state = WAIT_INCREMENT_IH_EMBEDDING;
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
                        if(!read_data_valid)
                            begin
                                next_state = GET_IH_WEIGHT;
                            end
                        else
                            begin
                                next_state = WAIT_SET_IH_WEIGHT_ADDRESS;
                            end
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
                        if(!read_data_valid)
                            begin
                                next_state = GET_IH_BIAS;
                            end
                        else
                            begin
                                next_state = WAIT_SET_IH_BIAS_ADDRESS;
                            end
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
                        next_state = ACCUMULATOR_LAST_HIDDEN;
                    end

                ACCUMULATOR_LAST_HIDDEN:
                    begin 
                        next_state = ACCUMULATOR_WAIT_HIDDEN;
                    end

                ACCUMULATOR_WAIT_HIDDEN:
                    begin
                        if(accumulator_last_valid)
                            begin
                                next_state = LOAD_NEURON;
                            end
                        else
                            begin
                                next_state = ACCUMULATOR_WAIT_HIDDEN;
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

                INCREMENT_LOGIT_LOAD_COUNTER:
                    begin
                        next_logit_load_counter <= logit_load_counter + 1;
                        next_state = INCREMENT_LOGIT_COUNTER;
                    end

                INCREMENT_LOGIT_COUNTER:
                    begin
                        next_logit_counter <= logit_counter + 1;
                        next_state = WAIT_INCREMENT_LOGIT_COUNTER;
                    end

                WAIT_INCREMENT_LOGIT_COUNTER:
                    begin
                        next_state = SET_LINEAR_WEIGHT_ADDRESS;
                    end

                SET_LINEAR_WEIGHT_ADDRESS:
                    begin
                        next_read_address = (VOCAB_SIZE * EMBEDDING_SIZE) + (EMBEDDING_SIZE * LINEAR_SIZE) + (LINEAR_SIZE * LINEAR_SIZE) + (LINEAR_SIZE * 2) + (logit_counter * 8); //NEED TO FIGURE OUT

                        next_state = WAIT_SET_LINEAR_WEIGHT_ADDRESS;
                    end

                WAIT_SET_LINEAR_WEIGHT_ADDRESS:
                    begin
                        if(!read_data_valid)
                            begin
                                next_state = GET_LINEAR_WEIGHT;
                            end
                        else
                            begin
                                next_state = WAIT_SET_LINEAR_WEIGHT_ADDRESS;
                            end
                    end

                GET_LINEAR_WEIGHT:
                    begin
                        if(read_data_valid)
                            begin
                                next_state = LOAD_LINEAR_MULTIPLY;
                            end
                        else
                            begin
                                next_state = GET_LINEAR_WEIGHT;
                            end
                    end

                LOAD_LINEAR_MULTIPLY:
                    begin
                        next_state = WAIT_LINEAR_MULTIPLY;
                    end

                WAIT_LINEAR_MULTIPLY:
                    begin
                        if(multiply_result_valid)
                            begin
                                next_state = LOAD_LINEAR_WEIGHT_ACCUMULATOR;
                            end
                        else
                            begin
                                next_state = WAIT_LINEAR_MULTIPLY;
                            end
                    end

                LOAD_LINEAR_WEIGHT_ACCUMULATOR:
                    begin
                        if(logit_counter == (VOCAB_SIZE - 1))
                            begin
                                next_state = SET_LINEAR_BIAS_ADDRESS;
                            end
                        else
                            begin
                                next_state = INCREMENT_LOGIT_COUNTER;
                            end
                    end

                SET_LINEAR_BIAS_ADDRESS:
                    begin
                        next_read_address = 0; //NEED TO FIGURE OUT
                    
                        next_state = WAIT_SET_LINEAR_BIAS_ADDRESS;
                    end

                WAIT_SET_LINEAR_BIAS_ADDRESS:
                    begin
                        if(!read_data_valid)
                            begin
                                next_state = GET_LINEAR_BIAS;
                            end
                        else
                            begin
                                next_state = WAIT_SET_LINEAR_BIAS_ADDRESS;
                            end
                    end

                GET_LINEAR_BIAS:
                    begin
                        if(read_data_valid)
                            begin
                                next_state = LOAD_LINEAR_BIAS_ACCUMULATOR;
                            end
                        else
                            begin
                                next_state = GET_LINEAR_BIAS;
                            end
                    end

                LOAD_LINEAR_BIAS_ACCUMULATOR:
                    begin
                        next_state = ACCUMULATOR_LAST_LINEAR;
                    end

                ACCUMULATOR_LAST_LINEAR:
                    begin
                        next_state = ACCUMULATOR_WAIT_LINEAR;
                    end

                ACCUMULATOR_WAIT_LINEAR:
                    begin
                        if(accumulator_last_valid)
                            begin
                                next_state = LOAD_LOGIT;
                            end
                        else
                            begin
                                next_state = ACCUMULATOR_WAIT_LINEAR;
                            end
                    end

                LOAD_LOGIT:
                    begin
                        if(logit_load_counter == (VOCAB_SIZE - 1))
                            begin
                                next_state = DONE;
                            end
                        else
                            begin
                                next_state = INCREMENT_LOGIT_LOAD_COUNTER;
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
