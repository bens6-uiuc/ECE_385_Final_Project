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
    
    logic accumulator_input_valid, accumulator_last, accumulator_last_valid;
    logic [15:0] accumulator_data, accumulator_result;
    logic multiply_input_valid, multiply_result_valid;
    logic [15:0] multiply_a_data, multiply_b_data, multiply_result;
    
    //ascii_to_token (
        //.input_ascii(input_ascii),
        //.output_token(token)
    //);
    
    assign token = 0;
    
    assign execute = SW[15];
        
    inference_fsm FSM(
    .clk(ui_clk),
    .reset(reset),
    .execute(execute),
    .read_data_valid(read_data_valid),
    .SW(SW),
    .token(token),
    .ram_data_out(ram_data_out),
    
    .LED(LED),
    .output_token(output_token),
    .read_address(read_address)
    );
    
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
  .aclk(ui_clk),                                  
  .s_axis_a_tvalid(accumulator_input_valid),            // input wire s_axis_a_tvalid
  .s_axis_a_tdata(accumulator_data),              // input wire [15 : 0] s_axis_a_tdata
  .s_axis_a_tlast(accumulator_last),              // input wire s_axis_a_tlast
  .m_axis_result_tdata(accumulator_result),    // output wire [15 : 0] m_axis_result_tdata
  .m_axis_result_tlast(accumulator_last_valid)    // output wire m_axis_result_tlast
    );
    
    multiply multiply (
  .aclk(ui_clk),                                 
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
    
endmodule
