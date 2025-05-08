create_clock -period 10.000 -name clk_100 -waveform {0.000 5.000} [get_ports Clk]

# PadFunction: IO_L12P_T1_MRCC_14 (SCHEMATIC CLK_100MHZ)
set_property IOSTANDARD LVCMOS33 [get_ports clk_ref_i]
set_property PACKAGE_PIN N15 [get_ports clk_ref_i]
create_clock -period 10.000 [get_ports clk_ref_i]

# PadFunction: IO_L12P_T1_MRCC_14 (SCHEMATIC CLK_100MHZ)

set_property IOSTANDARD LVCMOS33 [get_ports Clk]
set_property IOSTANDARD LVCMOS25 [get_ports reset_rtl_0]
set_property IOSTANDARD LVCMOS33 [get_ports uart_rtl_0_rxd]
set_property IOSTANDARD LVCMOS33 [get_ports uart_rtl_0_txd]
set_property PACKAGE_PIN N15 [get_ports Clk]
set_property PACKAGE_PIN J2 [get_ports reset_rtl_0]
set_property PACKAGE_PIN B16 [get_ports uart_rtl_0_rxd]
set_property PACKAGE_PIN A16 [get_ports uart_rtl_0_txd]


set_property IOSTANDARD LVCMOS33 [get_ports {gpio_usb_int_tri_i[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports usb_spi_miso]
set_property IOSTANDARD LVCMOS33 [get_ports usb_spi_mosi]
set_property IOSTANDARD LVCMOS33 [get_ports usb_spi_sclk]
set_property PACKAGE_PIN T13 [get_ports {gpio_usb_int_tri_i[0]}]
set_property PACKAGE_PIN V14 [get_ports usb_spi_sclk]
set_property PACKAGE_PIN V15 [get_ports usb_spi_mosi]
set_property PACKAGE_PIN U12 [get_ports usb_spi_miso]

set_property IOSTANDARD LVCMOS33 [get_ports gpio_usb_rst_tri_o]
set_property PACKAGE_PIN V13 [get_ports gpio_usb_rst_tri_o]
set_property PACKAGE_PIN T12 [get_ports usb_spi_ss]
set_property IOSTANDARD LVCMOS33 [get_ports usb_spi_ss]


set_property IOSTANDARD LVCMOS25 [get_ports {hex_gridA[3]}]
set_property IOSTANDARD LVCMOS25 [get_ports {hex_gridA[2]}]
set_property IOSTANDARD LVCMOS25 [get_ports {hex_gridA[1]}]
set_property IOSTANDARD LVCMOS25 [get_ports {hex_gridA[0]}]
set_property IOSTANDARD LVCMOS25 [get_ports {hex_gridB[3]}]
set_property IOSTANDARD LVCMOS25 [get_ports {hex_gridB[2]}]
set_property IOSTANDARD LVCMOS25 [get_ports {hex_gridB[1]}]
set_property IOSTANDARD LVCMOS25 [get_ports {hex_gridB[0]}]
set_property IOSTANDARD LVCMOS25 [get_ports {hex_segA[7]}]
set_property IOSTANDARD LVCMOS25 [get_ports {hex_segA[6]}]
set_property IOSTANDARD LVCMOS25 [get_ports {hex_segA[5]}]
set_property IOSTANDARD LVCMOS25 [get_ports {hex_segA[4]}]
set_property IOSTANDARD LVCMOS25 [get_ports {hex_segA[3]}]
set_property IOSTANDARD LVCMOS25 [get_ports {hex_segA[2]}]
set_property IOSTANDARD LVCMOS25 [get_ports {hex_segA[1]}]
set_property IOSTANDARD LVCMOS25 [get_ports {hex_segA[0]}]
set_property IOSTANDARD LVCMOS25 [get_ports {hex_segB[7]}]
set_property IOSTANDARD LVCMOS25 [get_ports {hex_segB[6]}]
set_property IOSTANDARD LVCMOS25 [get_ports {hex_segB[5]}]
set_property IOSTANDARD LVCMOS25 [get_ports {hex_segB[4]}]
set_property IOSTANDARD LVCMOS25 [get_ports {hex_segB[3]}]
set_property IOSTANDARD LVCMOS25 [get_ports {hex_segB[2]}]
set_property IOSTANDARD LVCMOS25 [get_ports {hex_segB[1]}]
set_property IOSTANDARD LVCMOS25 [get_ports {hex_segB[0]}]
set_property PACKAGE_PIN G6 [get_ports {hex_gridA[0]}]
set_property PACKAGE_PIN H6 [get_ports {hex_gridA[1]}]
set_property PACKAGE_PIN C3 [get_ports {hex_gridA[2]}]
set_property PACKAGE_PIN B3 [get_ports {hex_gridA[3]}]
set_property PACKAGE_PIN E6 [get_ports {hex_segA[0]}]
set_property PACKAGE_PIN B4 [get_ports {hex_segA[1]}]
set_property PACKAGE_PIN D5 [get_ports {hex_segA[2]}]
set_property PACKAGE_PIN C5 [get_ports {hex_segA[3]}]
set_property PACKAGE_PIN D7 [get_ports {hex_segA[4]}]
set_property PACKAGE_PIN D6 [get_ports {hex_segA[5]}]
set_property PACKAGE_PIN C4 [get_ports {hex_segA[6]}]
set_property PACKAGE_PIN B5 [get_ports {hex_segA[7]}]
set_property PACKAGE_PIN F3 [get_ports {hex_segB[0]}]
set_property PACKAGE_PIN G5 [get_ports {hex_segB[1]}]
set_property PACKAGE_PIN J3 [get_ports {hex_segB[2]}]
set_property PACKAGE_PIN H4 [get_ports {hex_segB[3]}]
set_property PACKAGE_PIN F4 [get_ports {hex_segB[4]}]
set_property PACKAGE_PIN H3 [get_ports {hex_segB[5]}]
set_property PACKAGE_PIN E5 [get_ports {hex_segB[6]}]
set_property PACKAGE_PIN J4 [get_ports {hex_segB[7]}]
set_property PACKAGE_PIN E4 [get_ports {hex_gridB[0]}]
set_property PACKAGE_PIN E3 [get_ports {hex_gridB[1]}]
set_property PACKAGE_PIN F5 [get_ports {hex_gridB[2]}]
set_property PACKAGE_PIN H5 [get_ports {hex_gridB[3]}]



#HDMI Signals
set_property -dict {PACKAGE_PIN V17 IOSTANDARD TMDS_33} [get_ports hdmi_tmds_clk_n]
set_property -dict {PACKAGE_PIN U16 IOSTANDARD TMDS_33} [get_ports hdmi_tmds_clk_p]

set_property -dict {PACKAGE_PIN U18 IOSTANDARD TMDS_33} [get_ports {hdmi_tmds_data_n[0]}]
set_property -dict {PACKAGE_PIN R17 IOSTANDARD TMDS_33} [get_ports {hdmi_tmds_data_n[1]}]
set_property -dict {PACKAGE_PIN T14 IOSTANDARD TMDS_33} [get_ports {hdmi_tmds_data_n[2]}]

set_property -dict {PACKAGE_PIN U17 IOSTANDARD TMDS_33} [get_ports {hdmi_tmds_data_p[0]}]
set_property -dict {PACKAGE_PIN R16 IOSTANDARD TMDS_33} [get_ports {hdmi_tmds_data_p[1]}]
set_property -dict {PACKAGE_PIN R14 IOSTANDARD TMDS_33} [get_ports {hdmi_tmds_data_p[2]}]

# On-board Slide Switches
set_property -dict {PACKAGE_PIN G1 IOSTANDARD LVCMOS25} [get_ports {SW[0]}]
set_property -dict {PACKAGE_PIN F2 IOSTANDARD LVCMOS25} [get_ports {SW[1]}]
set_property -dict {PACKAGE_PIN F1 IOSTANDARD LVCMOS25} [get_ports {SW[2]}]
set_property -dict {PACKAGE_PIN E2 IOSTANDARD LVCMOS25} [get_ports {SW[3]}]
set_property -dict {PACKAGE_PIN E1 IOSTANDARD LVCMOS25} [get_ports {SW[4]}]
set_property -dict {PACKAGE_PIN D2 IOSTANDARD LVCMOS25} [get_ports {SW[5]}]
set_property -dict {PACKAGE_PIN D1 IOSTANDARD LVCMOS25} [get_ports {SW[6]}]
set_property -dict {PACKAGE_PIN C2 IOSTANDARD LVCMOS25} [get_ports {SW[7]}]
set_property -dict {PACKAGE_PIN B2 IOSTANDARD LVCMOS25} [get_ports {SW[8]}]
set_property -dict {PACKAGE_PIN A4 IOSTANDARD LVCMOS25} [get_ports {SW[9]}]
set_property -dict {PACKAGE_PIN A5 IOSTANDARD LVCMOS25} [get_ports {SW[10]}]
set_property -dict {PACKAGE_PIN A6 IOSTANDARD LVCMOS25} [get_ports {SW[11]}]
set_property -dict {PACKAGE_PIN C7 IOSTANDARD LVCMOS25} [get_ports {SW[12]}]
set_property -dict {PACKAGE_PIN A7 IOSTANDARD LVCMOS25} [get_ports {SW[13]}]
set_property -dict {PACKAGE_PIN B7 IOSTANDARD LVCMOS25} [get_ports {SW[14]}]
set_property -dict {PACKAGE_PIN A8 IOSTANDARD LVCMOS25} [get_ports {SW[15]}]

# On-board LEDs
set_property -dict {PACKAGE_PIN C13 IOSTANDARD LVCMOS33} [get_ports {LED[0]}]
set_property -dict {PACKAGE_PIN C14 IOSTANDARD LVCMOS33} [get_ports {LED[1]}]
set_property -dict {PACKAGE_PIN D14 IOSTANDARD LVCMOS33} [get_ports {LED[2]}]
set_property -dict {PACKAGE_PIN D15 IOSTANDARD LVCMOS33} [get_ports {LED[3]}]
set_property -dict {PACKAGE_PIN D16 IOSTANDARD LVCMOS33} [get_ports {LED[4]}]
set_property -dict {PACKAGE_PIN F18 IOSTANDARD LVCMOS33} [get_ports {LED[5]}]
set_property -dict {PACKAGE_PIN E17 IOSTANDARD LVCMOS33} [get_ports {LED[6]}]
set_property -dict {PACKAGE_PIN D17 IOSTANDARD LVCMOS33} [get_ports {LED[7]}]
set_property -dict {PACKAGE_PIN C17 IOSTANDARD LVCMOS33} [get_ports {LED[8]}]
set_property -dict {PACKAGE_PIN B18 IOSTANDARD LVCMOS33} [get_ports {LED[9]}]
set_property -dict {PACKAGE_PIN A17 IOSTANDARD LVCMOS33} [get_ports {LED[10]}]
set_property -dict {PACKAGE_PIN B17 IOSTANDARD LVCMOS33} [get_ports {LED[11]}]
set_property -dict {PACKAGE_PIN C18 IOSTANDARD LVCMOS33} [get_ports {LED[12]}]
set_property -dict {PACKAGE_PIN D18 IOSTANDARD LVCMOS33} [get_ports {LED[13]}]
set_property -dict {PACKAGE_PIN E18 IOSTANDARD LVCMOS33} [get_ports {LED[14]}]
set_property -dict {PACKAGE_PIN G17 IOSTANDARD LVCMOS33} [get_ports {LED[15]}]


#SD card
# Set SPI buswidth
set_property BITSTREAM.CONFIG.SPI_BUSWIDTH 4 [current_design]

set_property -dict {PACKAGE_PIN M16 IOSTANDARD LVCMOS33} [get_ports sd_miso]
set_property -dict {PACKAGE_PIN N18 IOSTANDARD LVCMOS33} [get_ports sd_cs]
set_property -dict {PACKAGE_PIN P17 IOSTANDARD LVCMOS33} [get_ports sd_mosi]
set_property -dict {PACKAGE_PIN P18 IOSTANDARD LVCMOS33} [get_ports sd_sclk]

#DDR3
# PadFunction: IO_L1N_T0_34 (SCHEMATIC DDR_DQ0)
set_property SLEW FAST [get_ports {ddr3_dq[0]}]
set_property IN_TERM UNTUNED_SPLIT_50 [get_ports {ddr3_dq[0]}]
set_property IOSTANDARD SSTL135 [get_ports {ddr3_dq[0]}]
set_property PACKAGE_PIN K2 [get_ports {ddr3_dq[0]}]

# PadFunction: IO_L2P_T0_34 (SCHEMATIC DDR_DQ1)
set_property SLEW FAST [get_ports {ddr3_dq[1]}]
set_property IN_TERM UNTUNED_SPLIT_50 [get_ports {ddr3_dq[1]}]
set_property IOSTANDARD SSTL135 [get_ports {ddr3_dq[1]}]
set_property PACKAGE_PIN M4 [get_ports {ddr3_dq[1]}]

# PadFunction: IO_L2N_T0_34 (SCHEMATIC DDR_DQ2)
set_property SLEW FAST [get_ports {ddr3_dq[2]}]
set_property IN_TERM UNTUNED_SPLIT_50 [get_ports {ddr3_dq[2]}]
set_property IOSTANDARD SSTL135 [get_ports {ddr3_dq[2]}]
set_property PACKAGE_PIN K3 [get_ports {ddr3_dq[2]}]

# PadFunction: IO_L4P_T0_34 (SCHEMATIC DDR_DQ3)
set_property SLEW FAST [get_ports {ddr3_dq[3]}]
set_property IN_TERM UNTUNED_SPLIT_50 [get_ports {ddr3_dq[3]}]
set_property IOSTANDARD SSTL135 [get_ports {ddr3_dq[3]}]
set_property PACKAGE_PIN L5 [get_ports {ddr3_dq[3]}]

# PadFunction: IO_L4N_T0_34 (SCHEMATIC DDR_DQ4)
set_property SLEW FAST [get_ports {ddr3_dq[4]}]
set_property IN_TERM UNTUNED_SPLIT_50 [get_ports {ddr3_dq[4]}]
set_property IOSTANDARD SSTL135 [get_ports {ddr3_dq[4]}]
set_property PACKAGE_PIN L6 [get_ports {ddr3_dq[4]}]

# PadFunction: IO_L5P_T0_34 (SCHEMATIC DDR_DQ5)
set_property SLEW FAST [get_ports {ddr3_dq[5]}]
set_property IN_TERM UNTUNED_SPLIT_50 [get_ports {ddr3_dq[5]}]
set_property IOSTANDARD SSTL135 [get_ports {ddr3_dq[5]}]
set_property PACKAGE_PIN M6 [get_ports {ddr3_dq[5]}]

# PadFunction: IO_L5N_T0_34 (SCHEMATIC DDR_DQ6)
set_property SLEW FAST [get_ports {ddr3_dq[6]}]
set_property IN_TERM UNTUNED_SPLIT_50 [get_ports {ddr3_dq[6]}]
set_property IOSTANDARD SSTL135 [get_ports {ddr3_dq[6]}]
set_property PACKAGE_PIN L4 [get_ports {ddr3_dq[6]}]

# PadFunction: IO_L6P_T0_34 (SCHEMATIC DDR_DQ7)
set_property SLEW FAST [get_ports {ddr3_dq[7]}]
set_property IN_TERM UNTUNED_SPLIT_50 [get_ports {ddr3_dq[7]}]
set_property IOSTANDARD SSTL135 [get_ports {ddr3_dq[7]}]
set_property PACKAGE_PIN K6 [get_ports {ddr3_dq[7]}]

# PadFunction: IO_L7N_T1_34 (SCHEMATIC DDR_DQ8)
set_property SLEW FAST [get_ports {ddr3_dq[8]}]
set_property IN_TERM UNTUNED_SPLIT_50 [get_ports {ddr3_dq[8]}]
set_property IOSTANDARD SSTL135 [get_ports {ddr3_dq[8]}]
set_property PACKAGE_PIN N5 [get_ports {ddr3_dq[8]}]

# PadFunction: IO_L8P_T1_34 (SCHEMATIC DDR_DQ9)
set_property SLEW FAST [get_ports {ddr3_dq[9]}]
set_property IN_TERM UNTUNED_SPLIT_50 [get_ports {ddr3_dq[9]}]
set_property IOSTANDARD SSTL135 [get_ports {ddr3_dq[9]}]
set_property PACKAGE_PIN M1 [get_ports {ddr3_dq[9]}]

# PadFunction: IO_L8N_T1_34 (SCHEMATIC DDR_DQ10)
set_property SLEW FAST [get_ports {ddr3_dq[10]}]
set_property IN_TERM UNTUNED_SPLIT_50 [get_ports {ddr3_dq[10]}]
set_property IOSTANDARD SSTL135 [get_ports {ddr3_dq[10]}]
set_property PACKAGE_PIN P1 [get_ports {ddr3_dq[10]}]

# PadFunction: IO_L10P_T1_34 (SCHEMATIC DDR_DQ11)
set_property SLEW FAST [get_ports {ddr3_dq[11]}]
set_property IN_TERM UNTUNED_SPLIT_50 [get_ports {ddr3_dq[11]}]
set_property IOSTANDARD SSTL135 [get_ports {ddr3_dq[11]}]
set_property PACKAGE_PIN N1 [get_ports {ddr3_dq[11]}]

# PadFunction: IO_L10N_T1_34 (SCHEMATIC DDR_DQ12)
set_property SLEW FAST [get_ports {ddr3_dq[12]}]
set_property IN_TERM UNTUNED_SPLIT_50 [get_ports {ddr3_dq[12]}]
set_property IOSTANDARD SSTL135 [get_ports {ddr3_dq[12]}]
set_property PACKAGE_PIN R2 [get_ports {ddr3_dq[12]}]

# PadFunction: IO_L11P_T1_SRCC_34 (SCHEMATIC DDR_DQ13)
set_property SLEW FAST [get_ports {ddr3_dq[13]}]
set_property IN_TERM UNTUNED_SPLIT_50 [get_ports {ddr3_dq[13]}]
set_property IOSTANDARD SSTL135 [get_ports {ddr3_dq[13]}]
set_property PACKAGE_PIN N4 [get_ports {ddr3_dq[13]}]

# PadFunction: IO_L11N_T1_SRCC_34 (SCHEMATIC DDR_DQ14)
set_property SLEW FAST [get_ports {ddr3_dq[14]}]
set_property IN_TERM UNTUNED_SPLIT_50 [get_ports {ddr3_dq[14]}]
set_property IOSTANDARD SSTL135 [get_ports {ddr3_dq[14]}]
set_property PACKAGE_PIN P2 [get_ports {ddr3_dq[14]}]

# PadFunction: IO_L12P_T1_MRCC_34 (SCHEMATIC DDR_DQ15)
set_property SLEW FAST [get_ports {ddr3_dq[15]}]
set_property IN_TERM UNTUNED_SPLIT_50 [get_ports {ddr3_dq[15]}]
set_property IOSTANDARD SSTL135 [get_ports {ddr3_dq[15]}]
set_property PACKAGE_PIN M2 [get_ports {ddr3_dq[15]}]

# PadFunction: IO_L13P_T2_MRCC_34 (SCHEMATIC DDR_A14)
#set_property SLEW FAST [get_ports {ddr3_addr[14]}]
#set_property IOSTANDARD SSTL135 [get_ports {ddr3_addr[14]}]
#set_property PACKAGE_PIN R6 [get_ports {ddr3_addr[14]}]

# PadFunction: IO_L13N_T2_MRCC_34 (SCHEMATIC DDR_A13)
#set_property SLEW FAST [get_ports {ddr3_addr[13]}]
#set_property IOSTANDARD SSTL135 [get_ports {ddr3_addr[13]}]
#set_property PACKAGE_PIN V7 [get_ports {ddr3_addr[13]}]

# PadFunction: IO_L14P_T2_SRCC_34 (SCHEMATIC DDR_A12)
set_property SLEW FAST [get_ports {ddr3_addr[12]}]
set_property IOSTANDARD SSTL135 [get_ports {ddr3_addr[12]}]
set_property PACKAGE_PIN V6 [get_ports {ddr3_addr[12]}]

# PadFunction: IO_L14N_T2_SRCC_34 (SCHEMATIC DDR_A11)
set_property SLEW FAST [get_ports {ddr3_addr[11]}]
set_property IOSTANDARD SSTL135 [get_ports {ddr3_addr[11]}]
set_property PACKAGE_PIN P5 [get_ports {ddr3_addr[11]}]

# PadFunction: IO_L15P_T2_DQS_34 (SCHEMATIC DDR_A10)
set_property SLEW FAST [get_ports {ddr3_addr[10]}]
set_property IOSTANDARD SSTL135 [get_ports {ddr3_addr[10]}]
set_property PACKAGE_PIN U3 [get_ports {ddr3_addr[10]}]

# PadFunction: IO_L15N_T2_DQS_34 (SCHEMATIC DDR_A9)
set_property SLEW FAST [get_ports {ddr3_addr[9]}]
set_property IOSTANDARD SSTL135 [get_ports {ddr3_addr[9]}]
set_property PACKAGE_PIN U6 [get_ports {ddr3_addr[9]}]

# PadFunction: IO_L16P_T2_34 (SCHEMATIC DDR_A8)
set_property SLEW FAST [get_ports {ddr3_addr[8]}]
set_property IOSTANDARD SSTL135 [get_ports {ddr3_addr[8]}]
set_property PACKAGE_PIN R7 [get_ports {ddr3_addr[8]}]

# PadFunction: IO_L16N_T2_34 (SCHEMATIC DDR_A7)
set_property SLEW FAST [get_ports {ddr3_addr[7]}]
set_property IOSTANDARD SSTL135 [get_ports {ddr3_addr[7]}]
set_property PACKAGE_PIN U7 [get_ports {ddr3_addr[7]}]

# PadFunction: IO_L17P_T2_34 (SCHEMATIC DDR_A6)
set_property SLEW FAST [get_ports {ddr3_addr[6]}]
set_property IOSTANDARD SSTL135 [get_ports {ddr3_addr[6]}]
set_property PACKAGE_PIN V5 [get_ports {ddr3_addr[6]}]

# PadFunction: IO_L17N_T2_34 (SCHEMATIC DDR_A5)
set_property SLEW FAST [get_ports {ddr3_addr[5]}]
set_property IOSTANDARD SSTL135 [get_ports {ddr3_addr[5]}]
set_property PACKAGE_PIN T1 [get_ports {ddr3_addr[5]}]

# PadFunction: IO_L18P_T2_34 (SCHEMATIC DDR_A4)
set_property SLEW FAST [get_ports {ddr3_addr[4]}]
set_property IOSTANDARD SSTL135 [get_ports {ddr3_addr[4]}]
set_property PACKAGE_PIN T6 [get_ports {ddr3_addr[4]}]

# PadFunction: IO_L18N_T2_34 (SCHEMATIC DDR_A3)
set_property SLEW FAST [get_ports {ddr3_addr[3]}]
set_property IOSTANDARD SSTL135 [get_ports {ddr3_addr[3]}]
set_property PACKAGE_PIN T3 [get_ports {ddr3_addr[3]}]

# PadFunction: IO_L19P_T3_34 (SCHEMATIC DDR_A2)
set_property SLEW FAST [get_ports {ddr3_addr[2]}]
set_property IOSTANDARD SSTL135 [get_ports {ddr3_addr[2]}]
set_property PACKAGE_PIN P6 [get_ports {ddr3_addr[2]}]

# PadFunction: IO_L19N_T3_VREF_34 (SCHEMATIC DDR_A1)
set_property SLEW FAST [get_ports {ddr3_addr[1]}]
set_property IOSTANDARD SSTL135 [get_ports {ddr3_addr[1]}]
set_property PACKAGE_PIN R4 [get_ports {ddr3_addr[1]}]

# PadFunction: IO_L20P_T3_34 (SCHEMATIC DDR_A0)
set_property SLEW FAST [get_ports {ddr3_addr[0]}]
set_property IOSTANDARD SSTL135 [get_ports {ddr3_addr[0]}]
set_property PACKAGE_PIN V3 [get_ports {ddr3_addr[0]}]

# PadFunction: IO_L20N_T3_34 (SCHEMATIC DDR_BA2)
set_property SLEW FAST [get_ports {ddr3_ba[2]}]
set_property IOSTANDARD SSTL135 [get_ports {ddr3_ba[2]}]
set_property PACKAGE_PIN R3 [get_ports {ddr3_ba[2]}]

# PadFunction: IO_L22P_T3_34 (SCHEMATIC DDR_BA1)
set_property SLEW FAST [get_ports {ddr3_ba[1]}]
set_property IOSTANDARD SSTL135 [get_ports {ddr3_ba[1]}]
set_property PACKAGE_PIN V4 [get_ports {ddr3_ba[1]}]

# PadFunction: IO_L22N_T3_34 (SCHEMATIC DDR_BA0)
set_property SLEW FAST [get_ports {ddr3_ba[0]}]
set_property IOSTANDARD SSTL135 [get_ports {ddr3_ba[0]}]
set_property PACKAGE_PIN V2 [get_ports {ddr3_ba[0]}]

# PadFunction: IO_L23P_T3_34 (SCHEMATIC DDR_RAS_B
set_property SLEW FAST [get_ports ddr3_ras_n]
set_property IOSTANDARD SSTL135 [get_ports ddr3_ras_n]
set_property PACKAGE_PIN U2 [get_ports ddr3_ras_n]

# PadFunction: IO_L23N_T3_34 (SCHEMATIC DDR_CAS_B)
set_property SLEW FAST [get_ports ddr3_cas_n]
set_property IOSTANDARD SSTL135 [get_ports ddr3_cas_n]
set_property PACKAGE_PIN U1 [get_ports ddr3_cas_n]

# PadFunction: IO_L24P_T3_34 (SCHEMATIC DDR_WE_B)
set_property SLEW FAST [get_ports ddr3_we_n]
set_property IOSTANDARD SSTL135 [get_ports ddr3_we_n]
set_property PACKAGE_PIN T2 [get_ports ddr3_we_n]

# PadFunction: IO_L6N_T0_VREF_34 (SCHEMATIC DDR_RESET_B)
set_property SLEW FAST [get_ports ddr3_reset_n]
set_property IOSTANDARD SSTL135 [get_ports ddr3_reset_n]
set_property PACKAGE_PIN M5 [get_ports ddr3_reset_n]

# PadFunction: IO_L24N_T3_34 (SCHEMATIC DDR_CKE)

# PadFunction: IO_25_34 (SCHEMATIC DDR_ODT)

# PadFunction: IO_L1P_T0_34 (SCHEMATIC DDR_LDM)
set_property SLEW FAST [get_ports {ddr3_dm[0]}]
set_property IOSTANDARD SSTL135 [get_ports {ddr3_dm[0]}]
set_property PACKAGE_PIN K4 [get_ports {ddr3_dm[0]}]

# PadFunction: IO_L7P_T1_34 (SCHEMATIC DDR_UDM)
set_property SLEW FAST [get_ports {ddr3_dm[1]}]
set_property IOSTANDARD SSTL135 [get_ports {ddr3_dm[1]}]
set_property PACKAGE_PIN M3 [get_ports {ddr3_dm[1]}]

# PadFunction: IO_L12P_T1_MRCC_35 (SCHEMATIC DDR_REF_CLK_P)
set_property IOSTANDARD LVDS_25 [get_ports sys_clk_p]

# PadFunction: IO_L12N_T1_MRCC_35 (SCHEMATIC DDR_REF_CLK_N)
set_property IOSTANDARD LVDS_25 [get_ports sys_clk_n]
set_property PACKAGE_PIN C1 [get_ports sys_clk_p]
set_property PACKAGE_PIN B1 [get_ports sys_clk_n]

# PadFunction: IO_L3P_T0_DQS_34 (SCHEMATIC DDR_LDQS_P)
set_property SLEW FAST [get_ports {ddr3_dqs_p[0]}]
set_property IN_TERM UNTUNED_SPLIT_50 [get_ports {ddr3_dqs_p[0]}]
set_property IOSTANDARD DIFF_SSTL135 [get_ports {ddr3_dqs_p[0]}]

# PadFunction: IO_L3N_T0_DQS_34 (SCHEMATIC DDR_LDQS_N)
set_property SLEW FAST [get_ports {ddr3_dqs_n[0]}]
set_property IN_TERM UNTUNED_SPLIT_50 [get_ports {ddr3_dqs_n[0]}]
set_property IOSTANDARD DIFF_SSTL135 [get_ports {ddr3_dqs_n[0]}]
set_property PACKAGE_PIN K1 [get_ports {ddr3_dqs_p[0]}]
set_property PACKAGE_PIN L1 [get_ports {ddr3_dqs_n[0]}]

# PadFunction: IO_L9P_T1_DQS_34 (SCHEMATIC DDR_UDQS_P)
set_property SLEW FAST [get_ports {ddr3_dqs_p[1]}]
set_property IN_TERM UNTUNED_SPLIT_50 [get_ports {ddr3_dqs_p[1]}]
set_property IOSTANDARD DIFF_SSTL135 [get_ports {ddr3_dqs_p[1]}]

# PadFunction: IO_L9N_T1_DQS_34 (SCHEMATIC DDR_UDQS_N)
set_property SLEW FAST [get_ports {ddr3_dqs_n[1]}]
set_property IN_TERM UNTUNED_SPLIT_50 [get_ports {ddr3_dqs_n[1]}]
set_property IOSTANDARD DIFF_SSTL135 [get_ports {ddr3_dqs_n[1]}]
set_property PACKAGE_PIN N3 [get_ports {ddr3_dqs_p[1]}]
set_property PACKAGE_PIN N2 [get_ports {ddr3_dqs_n[1]}]

# PadFunction: IO_L21P_T3_DQS_34 (SCHEMATIC DDR_CLK_P)

# PadFunction: IO_L21N_T3_DQS_34 (SCHEMATIC DDR_CLK_N)

set_property INTERNAL_VREF 0.675 [get_iobanks 34]

# PadFunction: IO_L12N_T1_MRCC_16 (SCHEMATIC RGB0_G)
set_property IOSTANDARD LVCMOS33 [get_ports ram_init_done]
set_property PACKAGE_PIN A9 [get_ports ram_init_done]

# PadFunction: IO_L14N_T2_SRCC_16 (SCHEMATIC RGB1_R)
set_property IOSTANDARD LVCMOS33 [get_ports ram_init_error]
set_property PACKAGE_PIN A11 [get_ports ram_init_error]

set_property IOSTANDARD LVCMOS25 [get_ports sys_rst]
set_property PACKAGE_PIN J5 [get_ports sys_rst]


set_property MARK_DEBUG false [get_nets execute]
set_property MARK_DEBUG false [get_nets {hex_gridB_OBUF[0]}]
set_property MARK_DEBUG false [get_nets {hex_gridB_OBUF[1]}]
set_property MARK_DEBUG false [get_nets {hex_gridB_OBUF[2]}]
set_property MARK_DEBUG false [get_nets {hex_gridB_OBUF[3]}]

set_property MARK_DEBUG true [get_nets {inference_0/accumulator_data_reg_n_0_[13]}]
set_property MARK_DEBUG true [get_nets {inference_0/accumulator_data_reg_n_0_[12]}]
set_property MARK_DEBUG true [get_nets {inference_0/accumulator_data_reg_n_0_[8]}]
set_property MARK_DEBUG true [get_nets {inference_0/accumulator_data_reg_n_0_[7]}]
set_property MARK_DEBUG true [get_nets {inference_0/accumulator_data_reg_n_0_[15]}]
set_property MARK_DEBUG true [get_nets {inference_0/accumulator_data_reg_n_0_[14]}]
set_property MARK_DEBUG true [get_nets {inference_0/accumulator_data_reg_n_0_[4]}]
set_property MARK_DEBUG true [get_nets {inference_0/accumulator_data_reg_n_0_[11]}]
set_property MARK_DEBUG true [get_nets {inference_0/accumulator_data_reg_n_0_[10]}]
set_property MARK_DEBUG true [get_nets {inference_0/accumulator_data_reg_n_0_[6]}]
set_property MARK_DEBUG true [get_nets {inference_0/accumulator_data_reg_n_0_[3]}]
set_property MARK_DEBUG true [get_nets {inference_0/accumulator_data_reg_n_0_[0]}]
set_property MARK_DEBUG true [get_nets {inference_0/accumulator_data_reg_n_0_[9]}]
set_property MARK_DEBUG true [get_nets {inference_0/accumulator_data_reg_n_0_[5]}]
set_property MARK_DEBUG true [get_nets {inference_0/accumulator_data_reg_n_0_[2]}]
set_property MARK_DEBUG true [get_nets {inference_0/accumulator_data_reg_n_0_[1]}]
set_property MARK_DEBUG true [get_nets {SW_IBUF[15]}]
set_property MARK_DEBUG true [get_nets {inference_0/LED_OBUF[9]}]
set_property MARK_DEBUG true [get_nets inference_0/accumulator_input_valid_reg_n_0]
set_property MARK_DEBUG true [get_nets {inference_0/accumulator_result[1]}]
set_property MARK_DEBUG true [get_nets {inference_0/accumulator_result[8]}]
set_property MARK_DEBUG true [get_nets {inference_0/accumulator_result[10]}]
set_property MARK_DEBUG true [get_nets {inference_0/accumulator_result[14]}]
set_property MARK_DEBUG true [get_nets {inference_0/accumulator_result[7]}]
set_property MARK_DEBUG true [get_nets {inference_0/accumulator_result[9]}]
set_property MARK_DEBUG true [get_nets {inference_0/accumulator_result[12]}]
set_property MARK_DEBUG true [get_nets {inference_0/accumulator_result[0]}]
set_property MARK_DEBUG true [get_nets {inference_0/accumulator_result[4]}]
set_property MARK_DEBUG true [get_nets {inference_0/accumulator_result[5]}]
set_property MARK_DEBUG true [get_nets {inference_0/accumulator_result[6]}]
set_property MARK_DEBUG true [get_nets {inference_0/accumulator_result[13]}]
set_property MARK_DEBUG true [get_nets {inference_0/accumulator_result[2]}]
set_property MARK_DEBUG true [get_nets {inference_0/accumulator_result[3]}]
set_property MARK_DEBUG true [get_nets {inference_0/accumulator_result[11]}]
set_property MARK_DEBUG true [get_nets {inference_0/accumulator_result[15]}]
set_property MARK_DEBUG true [get_nets inference_0/accumulator_n_17]
set_property MARK_DEBUG true [get_nets {inference_0/ram_data_out[3]}]
set_property MARK_DEBUG true [get_nets {inference_0/ram_data_out[0]}]
set_property MARK_DEBUG true [get_nets {inference_0/ram_data_out[2]}]
set_property MARK_DEBUG true [get_nets {inference_0/ram_data_out[7]}]
set_property MARK_DEBUG true [get_nets {inference_0/ram_data_out[8]}]
set_property MARK_DEBUG true [get_nets {inference_0/ram_data_out[10]}]
set_property MARK_DEBUG true [get_nets {inference_0/ram_data_out[11]}]
set_property MARK_DEBUG true [get_nets {inference_0/ram_data_out[13]}]
set_property MARK_DEBUG true [get_nets {inference_0/ram_data_out[14]}]
set_property MARK_DEBUG true [get_nets {inference_0/ram_data_out[1]}]
set_property MARK_DEBUG true [get_nets {inference_0/ram_data_out[4]}]
set_property MARK_DEBUG true [get_nets {inference_0/ram_data_out[5]}]
set_property MARK_DEBUG true [get_nets {inference_0/ram_data_out[6]}]
set_property MARK_DEBUG true [get_nets {inference_0/ram_data_out[9]}]
set_property MARK_DEBUG true [get_nets {inference_0/ram_data_out[12]}]
set_property MARK_DEBUG true [get_nets {inference_0/ram_data_out[15]}]
set_property MARK_DEBUG true [get_nets {inference_0/multiply_result[2]}]
set_property MARK_DEBUG true [get_nets {inference_0/multiply_result[3]}]
set_property MARK_DEBUG true [get_nets {inference_0/multiply_result[4]}]
set_property MARK_DEBUG true [get_nets {inference_0/multiply_result[5]}]
set_property MARK_DEBUG true [get_nets {inference_0/multiply_result[9]}]
set_property MARK_DEBUG true [get_nets {inference_0/multiply_result[0]}]
set_property MARK_DEBUG true [get_nets {inference_0/multiply_result[1]}]
set_property MARK_DEBUG true [get_nets {inference_0/multiply_result[6]}]
set_property MARK_DEBUG true [get_nets {inference_0/multiply_result[7]}]
set_property MARK_DEBUG true [get_nets {inference_0/multiply_result[8]}]
set_property MARK_DEBUG true [get_nets {inference_0/multiply_result[10]}]
set_property MARK_DEBUG true [get_nets {inference_0/multiply_result[12]}]
set_property MARK_DEBUG true [get_nets {inference_0/multiply_result[13]}]
set_property MARK_DEBUG true [get_nets {inference_0/multiply_result[11]}]
set_property MARK_DEBUG true [get_nets {inference_0/multiply_result[14]}]
set_property MARK_DEBUG true [get_nets {inference_0/multiply_result[15]}]
set_property MARK_DEBUG true [get_nets {inference_0/multiply_a_data_reg_n_0_[14]}]
set_property MARK_DEBUG true [get_nets {inference_0/multiply_a_data_reg_n_0_[7]}]
set_property MARK_DEBUG true [get_nets {inference_0/multiply_a_data_reg_n_0_[6]}]
set_property MARK_DEBUG true [get_nets {inference_0/multiply_a_data_reg_n_0_[1]}]
set_property MARK_DEBUG true [get_nets {inference_0/multiply_a_data_reg_n_0_[15]}]
set_property MARK_DEBUG true [get_nets {inference_0/multiply_a_data_reg_n_0_[10]}]
set_property MARK_DEBUG true [get_nets {inference_0/multiply_a_data_reg_n_0_[9]}]
set_property MARK_DEBUG true [get_nets {inference_0/multiply_a_data_reg_n_0_[4]}]
set_property MARK_DEBUG true [get_nets {inference_0/multiply_a_data_reg_n_0_[13]}]
set_property MARK_DEBUG true [get_nets {inference_0/multiply_a_data_reg_n_0_[12]}]
set_property MARK_DEBUG true [get_nets {inference_0/multiply_a_data_reg_n_0_[3]}]
set_property MARK_DEBUG true [get_nets {inference_0/multiply_a_data_reg_n_0_[2]}]
set_property MARK_DEBUG true [get_nets {inference_0/multiply_a_data_reg_n_0_[0]}]
set_property MARK_DEBUG true [get_nets {inference_0/multiply_a_data_reg_n_0_[11]}]
set_property MARK_DEBUG true [get_nets {inference_0/multiply_a_data_reg_n_0_[8]}]
set_property MARK_DEBUG true [get_nets {inference_0/multiply_a_data_reg_n_0_[5]}]
set_property MARK_DEBUG true [get_nets {inference_0/multiply_b_data_reg_n_0_[15]}]
set_property MARK_DEBUG true [get_nets {inference_0/multiply_b_data_reg_n_0_[13]}]
set_property MARK_DEBUG true [get_nets {inference_0/multiply_b_data_reg_n_0_[11]}]
set_property MARK_DEBUG true [get_nets {inference_0/multiply_b_data_reg_n_0_[10]}]
set_property MARK_DEBUG true [get_nets {inference_0/multiply_b_data_reg_n_0_[8]}]
set_property MARK_DEBUG true [get_nets {inference_0/multiply_b_data_reg_n_0_[14]}]
set_property MARK_DEBUG true [get_nets {inference_0/multiply_b_data_reg_n_0_[12]}]
set_property MARK_DEBUG true [get_nets {inference_0/multiply_b_data_reg_n_0_[4]}]
set_property MARK_DEBUG true [get_nets {inference_0/multiply_b_data_reg_n_0_[3]}]
set_property MARK_DEBUG true [get_nets {inference_0/multiply_b_data_reg_n_0_[9]}]
set_property MARK_DEBUG true [get_nets {inference_0/multiply_b_data_reg_n_0_[6]}]
set_property MARK_DEBUG true [get_nets {inference_0/multiply_b_data_reg_n_0_[5]}]
set_property MARK_DEBUG true [get_nets {inference_0/multiply_b_data_reg_n_0_[2]}]
set_property MARK_DEBUG true [get_nets {inference_0/multiply_b_data_reg_n_0_[7]}]
set_property MARK_DEBUG true [get_nets {inference_0/multiply_b_data_reg_n_0_[1]}]
set_property MARK_DEBUG true [get_nets {inference_0/multiply_b_data_reg_n_0_[0]}]


connect_debug_port u_ila_0/probe0 [get_nets [list {inference_0/accumulator_result[0]} {inference_0/accumulator_result[1]} {inference_0/accumulator_result[2]} {inference_0/accumulator_result[3]} {inference_0/accumulator_result[4]} {inference_0/accumulator_result[5]} {inference_0/accumulator_result[6]} {inference_0/accumulator_result[7]} {inference_0/accumulator_result[8]} {inference_0/accumulator_result[9]} {inference_0/accumulator_result[10]} {inference_0/accumulator_result[11]} {inference_0/accumulator_result[12]} {inference_0/accumulator_result[13]} {inference_0/accumulator_result[14]} {inference_0/accumulator_result[15]}]]
connect_debug_port u_ila_0/probe1 [get_nets [list {inference_0/multiply_result[0]} {inference_0/multiply_result[1]} {inference_0/multiply_result[2]} {inference_0/multiply_result[3]} {inference_0/multiply_result[4]} {inference_0/multiply_result[5]} {inference_0/multiply_result[6]} {inference_0/multiply_result[7]} {inference_0/multiply_result[8]} {inference_0/multiply_result[9]} {inference_0/multiply_result[10]} {inference_0/multiply_result[11]} {inference_0/multiply_result[12]} {inference_0/multiply_result[13]} {inference_0/multiply_result[14]} {inference_0/multiply_result[15]}]]
connect_debug_port u_ila_0/probe7 [get_nets [list inference_0/accumulator_input_valid_reg_n_0]]
connect_debug_port u_ila_0/probe8 [get_nets [list inference_0/get_bias_hidden_to_hidden_reg_n_0]]
connect_debug_port u_ila_0/probe9 [get_nets [list inference_0/get_bias_input_to_hidden]]
connect_debug_port u_ila_0/probe10 [get_nets [list inference_0/get_weight_hidden_to_hidden]]
connect_debug_port u_ila_0/probe11 [get_nets [list inference_0/get_weight_input_to_hidden]]
connect_debug_port u_ila_0/probe12 [get_nets [list inference_0/load_embedding]]

set_property MARK_DEBUG false [get_nets inference_0/app_rd_data_valid]



connect_debug_port u_ila_0/probe1 [get_nets [list {inference_0/FSM/embedding_counter[0]} {inference_0/FSM/embedding_counter[1]}]]



connect_debug_port u_ila_0/probe3 [get_nets [list {inference_0/FSM/embedding_counter[0]_i_1_n_0}]]
connect_debug_port u_ila_0/probe4 [get_nets [list {inference_0/FSM/embedding_counter[1]_i_1_n_0}]]
connect_debug_port u_ila_0/probe6 [get_nets [list {inference_0/FSM/embedding_counter[2]_i_1_n_0}]]


connect_debug_port u_ila_0/probe6 [get_nets [list {inference_0/FSM/embedding_counter[1]_i_3_n_0}]]


set_property MARK_DEBUG true [get_nets {inference_0/FSM/LED[0]}]
set_property MARK_DEBUG true [get_nets {inference_0/FSM/LED[1]}]
set_property MARK_DEBUG true [get_nets {inference_0/FSM/LED[2]}]





connect_debug_port u_ila_0/probe1 [get_nets [list {inference_0/FSM/embedding_layer_reg[2][0]} {inference_0/FSM/embedding_layer_reg[2][1]} {inference_0/FSM/embedding_layer_reg[2][2]} {inference_0/FSM/embedding_layer_reg[2][3]} {inference_0/FSM/embedding_layer_reg[2][4]} {inference_0/FSM/embedding_layer_reg[2][5]} {inference_0/FSM/embedding_layer_reg[2][6]} {inference_0/FSM/embedding_layer_reg[2][7]} {inference_0/FSM/embedding_layer_reg[2][8]} {inference_0/FSM/embedding_layer_reg[2][9]} {inference_0/FSM/embedding_layer_reg[2][10]} {inference_0/FSM/embedding_layer_reg[2][11]} {inference_0/FSM/embedding_layer_reg[2][12]} {inference_0/FSM/embedding_layer_reg[2][13]} {inference_0/FSM/embedding_layer_reg[2][14]} {inference_0/FSM/embedding_layer_reg[2][15]}]]
connect_debug_port u_ila_0/probe2 [get_nets [list {inference_0/FSM/embedding_layer_reg[1][0]} {inference_0/FSM/embedding_layer_reg[1][1]} {inference_0/FSM/embedding_layer_reg[1][2]} {inference_0/FSM/embedding_layer_reg[1][3]} {inference_0/FSM/embedding_layer_reg[1][4]} {inference_0/FSM/embedding_layer_reg[1][5]} {inference_0/FSM/embedding_layer_reg[1][6]} {inference_0/FSM/embedding_layer_reg[1][7]} {inference_0/FSM/embedding_layer_reg[1][8]} {inference_0/FSM/embedding_layer_reg[1][9]} {inference_0/FSM/embedding_layer_reg[1][10]} {inference_0/FSM/embedding_layer_reg[1][11]} {inference_0/FSM/embedding_layer_reg[1][12]} {inference_0/FSM/embedding_layer_reg[1][13]} {inference_0/FSM/embedding_layer_reg[1][14]} {inference_0/FSM/embedding_layer_reg[1][15]}]]
connect_debug_port u_ila_0/probe3 [get_nets [list {inference_0/FSM/embedding_layer_reg[0][0]} {inference_0/FSM/embedding_layer_reg[0][1]} {inference_0/FSM/embedding_layer_reg[0][2]} {inference_0/FSM/embedding_layer_reg[0][3]} {inference_0/FSM/embedding_layer_reg[0][4]} {inference_0/FSM/embedding_layer_reg[0][5]} {inference_0/FSM/embedding_layer_reg[0][6]} {inference_0/FSM/embedding_layer_reg[0][7]} {inference_0/FSM/embedding_layer_reg[0][8]} {inference_0/FSM/embedding_layer_reg[0][9]} {inference_0/FSM/embedding_layer_reg[0][10]} {inference_0/FSM/embedding_layer_reg[0][11]} {inference_0/FSM/embedding_layer_reg[0][12]} {inference_0/FSM/embedding_layer_reg[0][13]} {inference_0/FSM/embedding_layer_reg[0][14]} {inference_0/FSM/embedding_layer_reg[0][15]}]]


create_debug_core u_ila_0 ila
set_property ALL_PROBE_SAME_MU true [get_debug_cores u_ila_0]
set_property ALL_PROBE_SAME_MU_CNT 1 [get_debug_cores u_ila_0]
set_property C_ADV_TRIGGER false [get_debug_cores u_ila_0]
set_property C_DATA_DEPTH 4096 [get_debug_cores u_ila_0]
set_property C_EN_STRG_QUAL false [get_debug_cores u_ila_0]
set_property C_INPUT_PIPE_STAGES 0 [get_debug_cores u_ila_0]
set_property C_TRIGIN_EN false [get_debug_cores u_ila_0]
set_property C_TRIGOUT_EN false [get_debug_cores u_ila_0]
set_property port_width 1 [get_debug_ports u_ila_0/clk]
connect_debug_port u_ila_0/clk [get_nets [list inference_0/u_mig_7series_0/u_mig_7series_0_mig/u_ddr3_infrastructure/CLK]]
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe0]
set_property port_width 1 [get_debug_ports u_ila_0/probe0]
connect_debug_port u_ila_0/probe0 [get_nets [list {inference_0/FSM/current_state[5]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe1]
set_property port_width 16 [get_debug_ports u_ila_0/probe1]
connect_debug_port u_ila_0/probe1 [get_nets [list {inference_0/FSM/embedding_layer_reg[0][0]} {inference_0/FSM/embedding_layer_reg[0][1]} {inference_0/FSM/embedding_layer_reg[0][2]} {inference_0/FSM/embedding_layer_reg[0][3]} {inference_0/FSM/embedding_layer_reg[0][4]} {inference_0/FSM/embedding_layer_reg[0][5]} {inference_0/FSM/embedding_layer_reg[0][6]} {inference_0/FSM/embedding_layer_reg[0][7]} {inference_0/FSM/embedding_layer_reg[0][8]} {inference_0/FSM/embedding_layer_reg[0][9]} {inference_0/FSM/embedding_layer_reg[0][10]} {inference_0/FSM/embedding_layer_reg[0][11]} {inference_0/FSM/embedding_layer_reg[0][12]} {inference_0/FSM/embedding_layer_reg[0][13]} {inference_0/FSM/embedding_layer_reg[0][14]} {inference_0/FSM/embedding_layer_reg[0][15]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe2]
set_property port_width 16 [get_debug_ports u_ila_0/probe2]
connect_debug_port u_ila_0/probe2 [get_nets [list {inference_0/FSM/embedding_layer_reg[1][0]} {inference_0/FSM/embedding_layer_reg[1][1]} {inference_0/FSM/embedding_layer_reg[1][2]} {inference_0/FSM/embedding_layer_reg[1][3]} {inference_0/FSM/embedding_layer_reg[1][4]} {inference_0/FSM/embedding_layer_reg[1][5]} {inference_0/FSM/embedding_layer_reg[1][6]} {inference_0/FSM/embedding_layer_reg[1][7]} {inference_0/FSM/embedding_layer_reg[1][8]} {inference_0/FSM/embedding_layer_reg[1][9]} {inference_0/FSM/embedding_layer_reg[1][10]} {inference_0/FSM/embedding_layer_reg[1][11]} {inference_0/FSM/embedding_layer_reg[1][12]} {inference_0/FSM/embedding_layer_reg[1][13]} {inference_0/FSM/embedding_layer_reg[1][14]} {inference_0/FSM/embedding_layer_reg[1][15]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe3]
set_property port_width 16 [get_debug_ports u_ila_0/probe3]
connect_debug_port u_ila_0/probe3 [get_nets [list {inference_0/accumulator_data[0]} {inference_0/accumulator_data[1]} {inference_0/accumulator_data[2]} {inference_0/accumulator_data[3]} {inference_0/accumulator_data[4]} {inference_0/accumulator_data[5]} {inference_0/accumulator_data[6]} {inference_0/accumulator_data[7]} {inference_0/accumulator_data[8]} {inference_0/accumulator_data[9]} {inference_0/accumulator_data[10]} {inference_0/accumulator_data[11]} {inference_0/accumulator_data[12]} {inference_0/accumulator_data[13]} {inference_0/accumulator_data[14]} {inference_0/accumulator_data[15]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe4]
set_property port_width 16 [get_debug_ports u_ila_0/probe4]
connect_debug_port u_ila_0/probe4 [get_nets [list {inference_0/accumulator_result[0]} {inference_0/accumulator_result[1]} {inference_0/accumulator_result[2]} {inference_0/accumulator_result[3]} {inference_0/accumulator_result[4]} {inference_0/accumulator_result[5]} {inference_0/accumulator_result[6]} {inference_0/accumulator_result[7]} {inference_0/accumulator_result[8]} {inference_0/accumulator_result[9]} {inference_0/accumulator_result[10]} {inference_0/accumulator_result[11]} {inference_0/accumulator_result[12]} {inference_0/accumulator_result[13]} {inference_0/accumulator_result[14]} {inference_0/accumulator_result[15]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe5]
set_property port_width 16 [get_debug_ports u_ila_0/probe5]
connect_debug_port u_ila_0/probe5 [get_nets [list {inference_0/multiply_result[0]} {inference_0/multiply_result[1]} {inference_0/multiply_result[2]} {inference_0/multiply_result[3]} {inference_0/multiply_result[4]} {inference_0/multiply_result[5]} {inference_0/multiply_result[6]} {inference_0/multiply_result[7]} {inference_0/multiply_result[8]} {inference_0/multiply_result[9]} {inference_0/multiply_result[10]} {inference_0/multiply_result[11]} {inference_0/multiply_result[12]} {inference_0/multiply_result[13]} {inference_0/multiply_result[14]} {inference_0/multiply_result[15]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe6]
set_property port_width 16 [get_debug_ports u_ila_0/probe6]
connect_debug_port u_ila_0/probe6 [get_nets [list {inference_0/multiply_b_data[0]} {inference_0/multiply_b_data[1]} {inference_0/multiply_b_data[2]} {inference_0/multiply_b_data[3]} {inference_0/multiply_b_data[4]} {inference_0/multiply_b_data[5]} {inference_0/multiply_b_data[6]} {inference_0/multiply_b_data[7]} {inference_0/multiply_b_data[8]} {inference_0/multiply_b_data[9]} {inference_0/multiply_b_data[10]} {inference_0/multiply_b_data[11]} {inference_0/multiply_b_data[12]} {inference_0/multiply_b_data[13]} {inference_0/multiply_b_data[14]} {inference_0/multiply_b_data[15]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe7]
set_property port_width 10 [get_debug_ports u_ila_0/probe7]
connect_debug_port u_ila_0/probe7 [get_nets [list {inference_0/read_address[0]} {inference_0/read_address[1]} {inference_0/read_address[2]} {inference_0/read_address[3]} {inference_0/read_address[4]} {inference_0/read_address[5]} {inference_0/read_address[6]} {inference_0/read_address[7]} {inference_0/read_address[8]} {inference_0/read_address[9]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe8]
set_property port_width 16 [get_debug_ports u_ila_0/probe8]
connect_debug_port u_ila_0/probe8 [get_nets [list {inference_0/ram_data_out[0]} {inference_0/ram_data_out[1]} {inference_0/ram_data_out[2]} {inference_0/ram_data_out[3]} {inference_0/ram_data_out[4]} {inference_0/ram_data_out[5]} {inference_0/ram_data_out[6]} {inference_0/ram_data_out[7]} {inference_0/ram_data_out[8]} {inference_0/ram_data_out[9]} {inference_0/ram_data_out[10]} {inference_0/ram_data_out[11]} {inference_0/ram_data_out[12]} {inference_0/ram_data_out[13]} {inference_0/ram_data_out[14]} {inference_0/ram_data_out[15]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe9]
set_property port_width 16 [get_debug_ports u_ila_0/probe9]
connect_debug_port u_ila_0/probe9 [get_nets [list {inference_0/multiply_a_data[0]} {inference_0/multiply_a_data[1]} {inference_0/multiply_a_data[2]} {inference_0/multiply_a_data[3]} {inference_0/multiply_a_data[4]} {inference_0/multiply_a_data[5]} {inference_0/multiply_a_data[6]} {inference_0/multiply_a_data[7]} {inference_0/multiply_a_data[8]} {inference_0/multiply_a_data[9]} {inference_0/multiply_a_data[10]} {inference_0/multiply_a_data[11]} {inference_0/multiply_a_data[12]} {inference_0/multiply_a_data[13]} {inference_0/multiply_a_data[14]} {inference_0/multiply_a_data[15]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe10]
set_property port_width 15 [get_debug_ports u_ila_0/probe10]
connect_debug_port u_ila_0/probe10 [get_nets [list {LED_OBUF[0]} {LED_OBUF[1]} {LED_OBUF[2]} {LED_OBUF[3]} {LED_OBUF[4]} {LED_OBUF[5]} {LED_OBUF[6]} {LED_OBUF[7]} {LED_OBUF[8]} {LED_OBUF[9]} {LED_OBUF[10]} {LED_OBUF[12]} {LED_OBUF[13]} {LED_OBUF[14]} {LED_OBUF[15]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe11]
set_property port_width 1 [get_debug_ports u_ila_0/probe11]
connect_debug_port u_ila_0/probe11 [get_nets [list {SW_IBUF[15]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe12]
set_property port_width 1 [get_debug_ports u_ila_0/probe12]
connect_debug_port u_ila_0/probe12 [get_nets [list inference_0/accumulator_input_valid]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe13]
set_property port_width 1 [get_debug_ports u_ila_0/probe13]
connect_debug_port u_ila_0/probe13 [get_nets [list inference_0/accumulator_last]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe14]
set_property port_width 1 [get_debug_ports u_ila_0/probe14]
connect_debug_port u_ila_0/probe14 [get_nets [list inference_0/accumulator_last_valid]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe15]
set_property port_width 1 [get_debug_ports u_ila_0/probe15]
connect_debug_port u_ila_0/probe15 [get_nets [list inference_0/multiply_input_valid]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe16]
set_property port_width 1 [get_debug_ports u_ila_0/probe16]
connect_debug_port u_ila_0/probe16 [get_nets [list inference_0/multiply_result_valid]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe17]
set_property port_width 1 [get_debug_ports u_ila_0/probe17]
connect_debug_port u_ila_0/probe17 [get_nets [list inference_0/read_data_valid]]
set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets u_ila_0_CLK]
