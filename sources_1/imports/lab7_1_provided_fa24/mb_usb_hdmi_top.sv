`timescale 1 ns / 1 ps

module final_project(
    input logic Clk,
    input logic reset_rtl_0,
    
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
    output logic [3:0] hex_gridB
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
    
    
   //Keycode HEX drivers
    
    test_ascii_generate test (
        .clk(Clk),
        .execute(execute),
        .generated_ascii(generated_ascii),
        .generate_count(generate_count)
    );
    
    rtl_ddr3_top ddr3(
        .sys_clk_n, //differential system clock input
        .sys_clk_p, //note that this is different than previous designs
        .ddr3_addr,
        .ddr3_ba,
        .ddr3_cas_n,
        .ddr3_ck_n, //differential DDR3 clock, typically between 300-333MHz
        .ddr3_ck_p,
        .ddr3_cke,
        .ddr3_dm,
        .ddr3_dq, //bidirectional signals need to be of type wire
        .ddr3_dqs_n,
        .ddr3_dqs_p,
        .ddr3_odt,   
        .ddr3_ras_n,
        .ddr3_reset_n,
        .ddr3_we_n,
        .clk_ref_i,
        .sys_rst,
    
        .sd_sclk,
        .sd_mosi,
        .sd_cs,
        .sd_miso,
    
        .hex_segA,
        .hex_segB,
        .hex_gridA,
        .hex_gridB,
    
        .SW,
        .ram_init_error,
        .ram_init_done,
        .LED
    );
    
endmodule