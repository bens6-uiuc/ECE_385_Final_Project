`timescale 1ns / 1ps

module ddr3_sim();

timeunit 10ns;
timeprecision 1ns;
    
final_project FINAL_PROJECT(
    .*
    );
    
logic clk_ref_i;
logic reset_rtl_0;
    
logic [15:0]  SW;
logic        ram_init_error;
logic        ram_init_done;
logic[15:0]  LED;
    
    //SD Card
logic        sd_sclk;
logic        sd_mosi;
logic        sd_cs;
logic         sd_miso;
    
    //USB signals
logic [0:0] gpio_usb_int_tri_i;
logic gpio_usb_rst_tri_o;
logic usb_spi_miso;
logic usb_spi_mosi;
logic usb_spi_sclk;
logic usb_spi_ss;
    
    //UART
logic uart_rtl_0_rxd;
logic uart_rtl_0_txd;
    
    //HDMI
logic hdmi_tmds_clk_n;
logic hdmi_tmds_clk_p;
logic [2:0]hdmi_tmds_data_n;
logic [2:0]hdmi_tmds_data_p;
    
    //HEX displays
logic [7:0] hex_segA;
logic [3:0] hex_gridA;
logic [7:0] hex_segB;
logic [3:0] hex_gridB;
    
    //DDR3
logic sys_clk_n; //differential system clock input
logic sys_clk_p; //note that this is different than previous designs
logic [12:0] ddr3_addr;
logic [2:0] ddr3_ba;
logic ddr3_cas_n;
logic ddr3_ck_n; //differential DDR3 clock, typically between 300-333MHz
logic ddr3_ck_p;
logic ddr3_cke;
logic [1:0] ddr3_dm;
wire [15:0] ddr3_dq; //bidirectional signals need to be of type wire
wire [1:0] ddr3_dqs_n;
wire [1:0] ddr3_dqs_p;
logic ddr3_odt;   
logic ddr3_ras_n;
logic ddr3_reset_n;
logic ddr3_we_n;
logic sys_rst;
    
    
initial begin: CLOCK_INITIALIZATION
    clk_ref_i = 1'b1;
end 

always begin : CLOCK_GENERATION
    #1 clk_ref_i = ~clk_ref_i;
end



initial begin: TEST_FLOATING


        
    repeat (100) @(posedge clk_ref_i);



    repeat (1000) @(posedge clk_ref_i);

    
    repeat (100) @(posedge clk_ref_i);

    
    repeat (20000) @(posedge clk_ref_i);
            
    $finish();
end  

endmodule
