`timescale 1ns / 1ps

module inference(
    input logic clk,
    input logic [7:0] input_ascii,
    //input logic execute,
    
    output logic [7:0] generated_ascii,
    output logic [11:0] generate_count,
    output logic generate_complete,
    
    //DDR3
    input logic [15:0]  SW,
    output logic        ram_init_error,
    output logic        ram_init_done,
    output logic[15:0]  LED,
    
    //SD Card
    output logic        sd_sclk,
    output logic        sd_mosi,
    output logic        sd_cs,
    input logic         sd_miso,
    
    //HEX displays
    output logic [7:0] hex_segA,
    output logic [3:0] hex_gridA,
    output logic [7:0] hex_segB,
    output logic [3:0] hex_gridB,
    
    //DDR3
    input  logic sys_clk_n, //differential system clock input
    input  logic sys_clk_p, //note that this is different than previous designs
    output logic [12:0] ddr3_addr,
    output logic [2:0] ddr3_ba,
    output logic ddr3_cas_n,
    output logic ddr3_ck_n, //differential DDR3 clock, typically between 300-333MHz
    output logic ddr3_ck_p,
    output logic ddr3_cke,
    output logic [1:0] ddr3_dm,
    inout wire [15:0] ddr3_dq, //bidirectional signals need to be of type wire
    inout wire [1:0] ddr3_dqs_n,
    inout wire [1:0] ddr3_dqs_p,
    output logic ddr3_odt,   
    output logic ddr3_ras_n,
    output logic ddr3_reset_n,
    output logic ddr3_we_n,
    input logic reset
    );
    
    localparam ADDR_WIDTH = 27;
    localparam APP_DATA_WIDTH = 64;
    localparam APP_MASK_WIDTH = 8;
    
    //internal signals
    logic [ADDR_WIDTH-1:0]                 app_wr_addr, app_rd_addr, app_addr; //shared signals between writing and reading sides
    logic [2:0]                            app_wr_cmd, app_rd_cmd, app_cmd;    //ram_init_done used to arbitrate between in this
    logic                                  app_wr_en, app_rd_en, app_en;       //example. All writes from SDCard happen first.
    logic                                  app_rdy;
    logic [APP_DATA_WIDTH-1:0]             app_rd_data;
    logic                                  app_rd_data_end;
    logic                                  app_rd_data_valid;
    logic [APP_DATA_WIDTH-1:0]             app_wdf_data;
    logic                                  app_wdf_end;
    logic [APP_MASK_WIDTH-1:0]             app_wdf_mask;
    logic                                  app_wdf_rdy;
    logic                                  app_sr_active;
    logic                                  app_ref_ack;
    logic                                  app_zq_ack;
    logic                                  app_wdf_wren;
    
    logic                                  ui_clk, ui_sync_rst;

    logic                                  init_calib_complete;
    
    logic[15:0]                            ram_data_out;
  
    logic [6:0] token;
    
    logic [26:0] read_address;
    logic read_data_valid;
    
    logic accumulator_input_valid, accumulator_last, accumulator_last_valid;
    logic [15:0] accumulator_data, accumulator_result;
    logic multiply_input_valid, multiply_result_valid;
    logic [15:0] multiply_a_data, multiply_b_data, multiply_result;
    
    //Internal signals
    logic reset_inference;
    logic [15:0] new_hidden_layer[LINEAR_SIZE];
    logic [15:0] old_hidden_layer[LINEAR_SIZE];
    logic [15:0] embedding_layer[EMBEDDING_SIZE];
    logic [15:0] logits[VOCAB_SIZE];

    logic get_weight_hidden_to_hidden;
    logic get_bias_hidden_to_hidden;
    logic get_weight_input_to_hidden;
    logic get_bias_input_to_hidden;
    
    logic multiply_hidden_to_hidden_weight;
    logic multiply_input_to_hidden_weight;
    
    logic get_weight_linear_layer;
    logic get_bias_linear_layer;
     
    logic inference_hidden; 
    logic load_embedding;
    logic neuron_done;
    logic accumulator_loaded; //Track when accumulator has all the values it needs and should compute sum
    logic hidden_done;
    logic done;
    
    integer i;
    logic [1:0] embedding_counter;
    logic [2:0] hidden_counter; //Keep track of what hidden neuron is being computed
    logic [2:0] hidden_neuron_counter; //Keep track of what hidden neuron is being used to compute
    logic [6:0] logit_counter; //Keep track of what logic is being computed
        
    localparam VOCAB_SIZE = 76;
    localparam EMBEDDING_SIZE = 4;
    localparam LINEAR_SIZE = 8;
    
    //ascii_to_token (
        //.input_ascii(input_ascii),
        //.output_token(token)
    //);
    
    assign token = 0;
    
    assign execute = SW[15];
        
    always_ff @ (posedge clk) 
    begin
        if(reset)
            begin
                for(i = 0; i < LINEAR_SIZE; i++)
                    begin
                        old_hidden_layer[i] <= 0;
                        new_hidden_layer[i] <= 0;
                    end
                for(i = 0; i < EMBEDDING_SIZE; i++)
                    begin
                        embedding_layer[i] <= 0;
                    end
                for(i = 0; i < VOCAB_SIZE; i++)
                    begin
                        logits[i] <= 0;
                    end   
                embedding_counter <= 0;
                hidden_counter <= 0;
                hidden_neuron_counter <= 0;
                get_weight_hidden_to_hidden <= 0;
                get_bias_hidden_to_hidden <= 0;
                get_weight_input_to_hidden <= 0;
                get_bias_input_to_hidden <= 0;
                multiply_hidden_to_hidden_weight <= 0;
                multiply_input_to_hidden_weight <= 0;
                neuron_done <= 0;
                accumulator_loaded <= 0;
                multiply_input_valid <= 0;
                done <= 0;
                accumulator_last <= 0;
                load_embedding <= 1;
                inference_hidden <= 0;
            end
            
        if(execute && load_embedding) //Load embedding layer and reset inference counters
                begin
                    if(read_data_valid)
                        begin
                            if(embedding_counter == (EMBEDDING_SIZE-1))
                                begin
                                    inference_hidden <= 1;
                                    get_weight_hidden_to_hidden <= 1;
                                    load_embedding <= 0;
                                end
                            embedding_layer[embedding_counter] <= ram_data_out;
                            embedding_counter <= embedding_counter + 1;   
                            hidden_counter <= 0; 
                            hidden_neuron_counter <= 0; 
                            logit_counter <= 0;  
                            if(embedding_counter > (EMBEDDING_SIZE-1))
                                begin
                                    embedding_counter <= 0;
                                end                                 
                        end
                end            
             
        if(inference_hidden) //Inference next hidden state of RNN
            begin
            
                if(accumulator_last)
                    begin
                        accumulator_input_valid <= 0;
                        neuron_done <= 1;
                        accumulator_last <= 0;
                    end
                    
                if(accumulator_loaded)
                    begin
                        accumulator_last <= 1;
                        accumulator_loaded <= 0;
                    end
                           
                if(multiply_input_valid)
                    begin       
                        multiply_input_valid <= 0;
                    end
                        
                if(accumulator_data != 0) //Prevent values from being added more than once?? Might need fix
                    begin
                        accumulator_data <= 0;
                    end
                
                if(read_data_valid && get_weight_hidden_to_hidden) //Get weights and multiply by each prev hidden 
                    begin
                        multiply_a_data <= ram_data_out; //Weight
                        multiply_b_data <= old_hidden_layer[hidden_neuron_counter];
                        multiply_input_valid <= 1;
                        multiply_hidden_to_hidden_weight <= 1;
                        get_weight_hidden_to_hidden <= 0;
                    end
                    
                if(multiply_result_valid && multiply_hidden_to_hidden_weight)
                    begin
                        if(hidden_neuron_counter == (LINEAR_SIZE-1))
                            begin
                                get_bias_hidden_to_hidden <= 1;
                                get_weight_hidden_to_hidden <= 0;
                            end
                        else 
                            begin
                                get_weight_hidden_to_hidden <= 1; //If haven't gotten all prev hidden weights get next
                            end
                        accumulator_input_valid <= 1;
                        accumulator_data <= multiply_result;
                        multiply_hidden_to_hidden_weight <= 0;
                        hidden_neuron_counter <= hidden_neuron_counter + 1; //Get weight for next prev hidden neuron 
                        if(hidden_neuron_counter == (LINEAR_SIZE-1))
                            begin
                                hidden_neuron_counter <= 0;
                            end
                    end   
                    
                if(read_data_valid && get_bias_hidden_to_hidden)
                    begin
                        accumulator_data <= ram_data_out; 
                        get_weight_input_to_hidden <= 1; 
                        get_bias_hidden_to_hidden <= 0;
                    end
                    
                if(get_weight_input_to_hidden)  
                    begin
                        multiply_a_data <= ram_data_out; //Weight
                        multiply_b_data <= embedding_layer[embedding_counter];
                        multiply_input_valid <= 1;
                        multiply_input_to_hidden_weight <= 1;
                        get_weight_input_to_hidden <= 0;
                    end  
                    
                if(multiply_result_valid && multiply_input_to_hidden_weight)
                    begin
                        if(embedding_counter == (EMBEDDING_SIZE-1))
                            begin
                                get_bias_input_to_hidden <= 1;
                                get_weight_input_to_hidden <= 0;
                            end
                        else 
                            begin
                                get_weight_input_to_hidden <= 1; //If haven't gotten all input weights get next
                                
                            end
                        embedding_counter <= embedding_counter + 1;
                        accumulator_input_valid <= 1;
                        accumulator_data <= multiply_result;
                        multiply_input_to_hidden_weight <= 0;
                        if(embedding_counter == (EMBEDDING_SIZE-1))
                            begin
                                embedding_counter <= 0;
                            end
                    end                    
                    
                if(get_bias_input_to_hidden)
                    begin
                        accumulator_data <= ram_data_out; 
                        accumulator_loaded <= 1; 
                        get_bias_input_to_hidden <= 0;  
                    end
              
                if(accumulator_last_valid && neuron_done)
                    begin
                        if(hidden_counter == (LINEAR_SIZE -1))
                            begin
                                hidden_done <= 1;
                                inference_hidden <= 0;
                            end
                        //if(accumulator_result[15] == 1)
                           // begin
                               // new_hidden_layer[hidden_counter] <= 0;
                           // end
                       // else 
                           // begin
                               // new_hidden_layer[hidden_counter] <= accumulator_result;
                           // end
                        new_hidden_layer[hidden_counter] <= accumulator_result;
                        neuron_done <= 0;
                        hidden_counter <= hidden_counter + 1;
                        get_weight_hidden_to_hidden <= 1;
                        if(hidden_counter == (LINEAR_SIZE -1))
                            begin
                                hidden_counter <= 0;
                            end
                    end
            end  
            
        if(hidden_done) // inference linear layer
            begin
                for(i = 0; i < LINEAR_SIZE; i++)
                    begin
                        old_hidden_layer[i] <= new_hidden_layer[i];
                    end         
            end
            
        if(done)
            begin
                for(i = 0; i < LINEAR_SIZE; i++)
                    begin
                        old_hidden_layer[i] <= new_hidden_layer[i];
                    end
            end
                    
    end
    
    always_comb //Pretty sure addresses need to be combinational
        begin
            if(load_embedding)
                begin
                    read_address = (token * EMBEDDING_SIZE) + embedding_counter;
                end
            else if(get_weight_hidden_to_hidden)
                begin
                    read_address = (VOCAB_SIZE * EMBEDDING_SIZE) + (EMBEDDING_SIZE * LINEAR_SIZE) + (hidden_counter * LINEAR_SIZE) + (hidden_neuron_counter);
                end
            else if(get_bias_hidden_to_hidden)
                begin
                    read_address = (VOCAB_SIZE * EMBEDDING_SIZE) + (EMBEDDING_SIZE * LINEAR_SIZE) + (LINEAR_SIZE * LINEAR_SIZE) + LINEAR_SIZE + hidden_counter;
                end
            else if(get_weight_input_to_hidden)
                begin
                    read_address = (VOCAB_SIZE * EMBEDDING_SIZE) + (hidden_counter * EMBEDDING_SIZE) + (embedding_counter); //DONE
                end
            else if(get_bias_input_to_hidden)
                begin
                    read_address = (VOCAB_SIZE * EMBEDDING_SIZE) + (EMBEDDING_SIZE * LINEAR_SIZE) + (LINEAR_SIZE * LINEAR_SIZE) + (hidden_counter);
                end
            else if(get_weight_linear_layer)
                begin
                    read_address = (VOCAB_SIZE * EMBEDDING_SIZE) + (EMBEDDING_SIZE * LINEAR_SIZE) + (LINEAR_SIZE * LINEAR_SIZE) + (LINEAR_SIZE * 2) + (logit_counter * 8) + hidden_neuron_counter;
                end    
            else if(get_bias_linear_layer)
                begin
                    read_address = (VOCAB_SIZE * EMBEDDING_SIZE) + (EMBEDDING_SIZE * LINEAR_SIZE) + (LINEAR_SIZE * LINEAR_SIZE) + (LINEAR_SIZE * 2) + (VOCAB_SIZE * LINEAR_SIZE) + logit_counter;
                end    
            else
                begin
                    read_address = 0;
                end
        end
    
    ram_reader ram_reader_0(
       .clk(ui_clk),
	   .reset(~ram_init_done),     //start reading when RAM init is finished
       .ram_address (app_rd_addr),  //the following 4 signals control the command FIFO
       .ram_cmd (app_rd_cmd),       
       .ram_en (app_rd_en),             
       .ram_rdy(app_rdy),
       .ram_rd_valid(app_rd_data_valid),
       .ram_rd_data_end (app_rd_data_end),
       .ram_rd_data(app_rd_data),
       .read_address (read_address),
       .read_data_out (ram_data_out),  //16-bit output word
       .read_data_valid (read_data_valid)
    );
    
    accumulator accumulator (
  .aclk(clk),                                  
  .s_axis_a_tvalid(accumulator_input_valid),            // input wire s_axis_a_tvalid
  .s_axis_a_tdata(accumulator_data),              // input wire [15 : 0] s_axis_a_tdata
  .s_axis_a_tlast(accumulator_last),              // input wire s_axis_a_tlast
  .m_axis_result_tdata(accumulator_result),    // output wire [15 : 0] m_axis_result_tdata
  .m_axis_result_tlast(accumulator_last_valid)    // output wire m_axis_result_tlast
    );
    
    multiply multiply (
  .aclk(clk),                                 
  .s_axis_a_tvalid(multiply_input_valid),            // input wire s_axis_a_tvalid
  .s_axis_a_tdata(multiply_a_data),              // input wire [15 : 0] s_axis_a_tdata
  .s_axis_b_tvalid(multiply_input_valid),            // input wire s_axis_b_tvalid
  .s_axis_b_tdata(multiply_b_data),              // input wire [15 : 0] s_axis_b_tdata
  .m_axis_result_tvalid(multiply_result_valid),  // output wire m_axis_result_tvalid
  .m_axis_result_tdata(multiply_result)    // output wire [15 : 0] m_axis_result_tdata
);
    
        mig_7series_0 u_mig_7series_0
    (
       // External memory interface ports
       .ddr3_addr                      (ddr3_addr),
       .ddr3_ba                        (ddr3_ba),
       .ddr3_cas_n                     (ddr3_cas_n),
       .ddr3_ck_n                      (ddr3_ck_n),
       .ddr3_ck_p                      (ddr3_ck_p),
       .ddr3_cke                       (ddr3_cke),
       .ddr3_ras_n                     (ddr3_ras_n),
       .ddr3_we_n                      (ddr3_we_n),
       .ddr3_dq                        (ddr3_dq),
       .ddr3_dqs_n                     (ddr3_dqs_n),
       .ddr3_dqs_p                     (ddr3_dqs_p),
       .ddr3_reset_n                   (ddr3_reset_n),
       .init_calib_complete            (init_calib_complete),
       .ddr3_dm                        (ddr3_dm),
       .ddr3_odt                       (ddr3_odt),

        // Application interface ports
       .app_addr                       (app_addr),
       .app_cmd                        (app_cmd),
       .app_en                         (app_en),
       .app_wdf_data                   (app_wdf_data),
       .app_wdf_end                    (app_wdf_end),
       .app_wdf_wren                   (app_wdf_wren),
       .app_rd_data                    (app_rd_data),
       .app_rd_data_end                (app_rd_data_end),
       .app_rd_data_valid              (app_rd_data_valid),
       .app_rdy                        (app_rdy),
       .app_wdf_rdy                    (app_wdf_rdy),
       .app_sr_req                     (1'b0),
       .app_ref_req                    (1'b0),
       .app_zq_req                     (1'b0),
       .app_sr_active                  (app_sr_active),
       .app_ref_ack                    (app_ref_ack),
       .app_zq_ack                     (app_zq_ack),
       .ui_clk                         (ui_clk),
       .ui_clk_sync_rst                (ui_sync_rst),
       .app_wdf_mask                   (app_wdf_mask),

        // System Clock Ports
       .sys_clk_p                      (sys_clk_p),
       .sys_clk_n                      (sys_clk_n),

        // Reference Clock Ports
       .clk_ref_i                      (clk),
       .device_temp                    (),
       .sys_rst                        (reset)
   );
   
    sdcard_init #(.MAX_RAM_ADDRESS(27'h03FFFF),//copy 256KBytes to SDRAM
                  .SDHC(1'b1))
    sdcard_init_0(
    .clk(ui_clk),
    .reset(~init_calib_complete),     //starts after calibration has been completed
    .ram_cmd(app_wr_cmd),
    .ram_en(app_wr_en),
    .ram_rdy(app_rdy),
    .ram_address(app_wr_addr),
    .ram_wdf_data(app_wdf_data),
    .ram_wdf_wren(app_wdf_wren),     //RAM interface pins
    .ram_wdf_rdy(app_wdf_rdy),       //acknowledge from RAM to move to next word
    .ram_wdf_end(app_wdf_end),       //toggle every other word
    .ram_init_error(ram_init_error), //error initializing
    .ram_init_done(ram_init_done),   //done with reading all MAX_RAM_ADDRESS words
    .cs_bo (sd_cs), 
    .sclk_o (sd_sclk),
    .mosi_o (sd_mosi),
    .miso_i (sd_miso)
    );

    
    assign app_wdf_mask = 'h00; //for use when writing smaller than 64-bit words (not here)
    assign app_addr = ram_init_done ? app_rd_addr:app_wr_addr; //MUX shared RAM control signals 
    assign app_en   = ram_init_done ? app_rd_en:app_wr_en;     //between write logic and read
    assign app_cmd  = ram_init_done ? app_rd_cmd:app_wr_cmd;   //logic
        
    logic [4:0] index;
    assign index = SW[4:0];    
    
    assign LED[15] = hidden_done;
    assign LED[14] = multiply_input_valid;
    assign LED[13] = accumulator_last;
    assign LED[12] = inference_hidden;
    assign LED[11] = load_embedding;
    assign LED[10] = read_data_valid;
    assign LED[9] =  get_weight_hidden_to_hidden;
    assign LED[8] = get_bias_hidden_to_hidden;
    assign LED[7] = get_weight_input_to_hidden;
    assign LED[6] = get_bias_input_to_hidden;
    assign LED[1:0] = embedding_counter;
    
    hex_driver hexA   (.clk(ui_clk), 
                      .reset(ui_sync_rst),
                      .in({SW[15:12], SW[11:8], SW[7:4], SW[3:0]}),
                      .hex_seg(hex_segA),
                      .hex_grid(hex_gridA));
 
    hex_driver hexB   (.clk(ui_clk), 
                      .reset(ui_sync_rst),
                      .in({old_hidden_layer[index][15:12], old_hidden_layer[index][11:8], old_hidden_layer[index][7:4], old_hidden_layer[index][3:0]}),
                      .hex_seg(hex_segB),
                      .hex_grid(hex_gridB));
    
endmodule
