`timescale 1 ns / 1 ps

module final_project(
    input logic Clk,
    input logic reset_rtl_0,
    
    input logic [15:0]  SW,
    output logic        ram_init_error,
    output logic        ram_init_done,
    output logic[15:0]  LED,
    
    //SD Card
    output logic        sd_sclk,
    output logic        sd_mosi,
    output logic        sd_cs,
    input logic         sd_miso,
    
    //USB signals
    input logic [0:0] gpio_usb_int_tri_i,
    output logic gpio_usb_rst_tri_o,
    input logic usb_spi_miso,
    output logic usb_spi_mosi,
    output logic usb_spi_sclk,
    output logic usb_spi_ss,
    
    //UART
    input logic uart_rtl_0_rxd,
    output logic uart_rtl_0_txd,
    
    //HDMI
    output logic hdmi_tmds_clk_n,
    output logic hdmi_tmds_clk_p,
    output logic [2:0]hdmi_tmds_data_n,
    output logic [2:0]hdmi_tmds_data_p,
    
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
    input logic sys_rst
    );
    
    assign reset_ah = reset_rtl_0;
    
    mb_block_wrapper lab_7_1_mb_(
        .clk_100MHz(Clk),
        .reset_rtl_0(~reset_ah),
        .uart_rtl_0_rxd(uart_rtl_0_rxd), 
        .uart_rtl_0_txd(uart_rtl_0_txd),
        .HDMI_0_tmds_clk_n(hdmi_tmds_clk_n),
        .HDMI_0_tmds_clk_p(hdmi_tmds_clk_p),
        .HDMI_0_tmds_data_n(hdmi_tmds_data_n),
        .HDMI_0_tmds_data_p(hdmi_tmds_data_p),
        
        .gpio_usb_int_tri_i(gpio_usb_int_tri_i),
        .gpio_usb_keycode_0_tri_o(keycode0_gpio),
        .gpio_usb_keycode_1_tri_o(keycode1_gpio),
        .gpio_usb_rst_tri_o(gpio_usb_rst_tri_o),
        .usb_spi_miso(usb_spi_miso),
        .usb_spi_mosi(usb_spi_mosi),
        .usb_spi_sclk(usb_spi_sclk),
        .usb_spi_ss(usb_spi_ss),
        .gpio_execute_tri_o(execute),
        .gpio_generated_ascii_tri_i(generated_ascii),
        .gpio_generate_count_tri_i(generate_count)
    );

    logic [31:0] keycode0_gpio, keycode1_gpio;

    logic reset_ah;
    logic execute;
    logic [7:0] generated_ascii;
    logic [11:0] generate_count;
    assign reset_ah = reset_rtl_0;
    
    
   
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
    
    logic[31:0]                            read_data_display;
    
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
       .clk_ref_i                      (Clk),
       .device_temp                    (),
       .sys_rst                        (sys_rst)
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
    .cs_bo (), 
    .sclk_o (),
    .mosi_o (),
    .miso_i ()
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
       .read_address ({11'b00000000000,SW}),
       .read_data_out (read_data_display),  //16-bit output word
       .read_data_valid (LED[0])
    );
    
    assign app_wdf_mask = 'h00; //for use when writing smaller than 64-bit words (not here)
    assign app_addr = ram_init_done ? app_rd_addr:app_wr_addr; //MUX shared RAM control signals 
    assign app_en   = ram_init_done ? app_rd_en:app_wr_en;     //between write logic and read
    assign app_cmd  = ram_init_done ? app_rd_cmd:app_wr_cmd;   //logic
        
    
    hex_driver hexA   (.clk(ui_clk), 
                      .reset(ui_sync_rst),
                      .in({SW[15:12], SW[11:8], SW[7:4], SW[3:0]}),
                      .hex_seg(hex_segA),
                      .hex_grid(hex_gridA));
 
    hex_driver hexB   (.clk(ui_clk), 
                      .reset(ui_sync_rst),
                      .in({read_data_display[15:12], read_data_display[11:8], read_data_display[7:4], read_data_display[3:0]}),
                      .hex_seg(hex_segB),
                      .hex_grid(hex_gridB));
    
endmodule