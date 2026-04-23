# create_project devel-base /storage/github-repos/arty-z8/proj/devel-base -part xc7z020clg400-1
#
# create_project devel-base /storage/github-repos/arty-z7/proj/devel-base -part 

set part "xc7z020clg400-1"

create_project \
    -part "${part}" \

# start_gui
# Sourcing tcl script '/home/castillo/.Xilinx/Vivado/Vivado_init.tcl'
# Available board repository paths:
#   /home/castillo/git-local-repos/Avnet/bdf
#   /home/castillo/git-local-repos/Digilent/vivado-boards/new/board_files
# create_project devel-base /storage/github-repos/arty-z7/proj/devel-base -part xc7z020clg400-1
# INFO: [IP_Flow 19-234] Refreshing IP repositories
# INFO: [IP_Flow 19-1704] No user IP repositories specified
# INFO: [IP_Flow 19-2313] Loaded Vivado IP repository '/tools/Xilinx/Vivado/2024.2/data/ip'.
# create_project: Time (s): cpu = 00:00:13 ; elapsed = 00:00:16 . Memory (MB): peak = 7965.547 ; gain = 172.188 ; free physical = 19724 ; free virtual = 22373
# set_property board_part digilentinc.com:arty-z7-20:part0:1.1 [current_project]
# close_project
# INFO: [IP_Flow 19-234] Refreshing IP repositories
# INFO: [IP_Flow 19-1704] No user IP repositories specified
# INFO: [IP_Flow 19-2313] Loaded Vivado IP repository '/tools/Xilinx/Vivado/2024.2/data/ip'.
# create_project: Time (s): cpu = 00:00:07 ; elapsed = 00:00:08 . Memory (MB): peak = 8090.613 ; gain = 17.949 ; free physical = 19627 ; free virtual = 22300
# create_ip -name processing_system7 -vendor xilinx.com -library ip -version 5.5 -module_name processing_system7_0
# generate_target {instantiation_template} [get_files /storage/github-repos/arty-z7/proj/devel-base/devel-base.srcs/sources_1/ip/processing_system7_0/processing_system7_0.xci]
# INFO: [IP_Flow 19-1686] Generating 'Instantiation Template' target for IP 'processing_system7_0'...
# update_compile_order -fileset sources_1
create_bd_design "design_1"


startgroup
create_bd_cell -type ip -vlnv xilinx.com:ip:processing_system7:5.5 processing_system7_0
endgroup
apply_bd_automation -rule xilinx.com:bd_rule:processing_system7 -config {make_external "FIXED_IO, DDR" Master "Disable" Slave "Disable" }  [get_bd_cells processing_system7_0]
startgroup
# set_property -dict [list \
#   CONFIG.PCW_ACT_APU_PERIPHERAL_FREQMHZ {650.000000} \
#   CONFIG.PCW_ACT_CAN0_PERIPHERAL_FREQMHZ {23.8095} \
#   CONFIG.PCW_ACT_CAN1_PERIPHERAL_FREQMHZ {23.8095} \
#   CONFIG.PCW_ACT_CAN_PERIPHERAL_FREQMHZ {10.000000} \
#   CONFIG.PCW_ACT_DCI_PERIPHERAL_FREQMHZ {10.096154} \
#   CONFIG.PCW_ACT_ENET0_PERIPHERAL_FREQMHZ {125.000000} \
#   CONFIG.PCW_ACT_ENET1_PERIPHERAL_FREQMHZ {10.000000} \
#   CONFIG.PCW_ACT_FPGA0_PERIPHERAL_FREQMHZ {100.000000} \
#   CONFIG.PCW_ACT_FPGA1_PERIPHERAL_FREQMHZ {10.000000} \
#   CONFIG.PCW_ACT_FPGA2_PERIPHERAL_FREQMHZ {10.000000} \
#   CONFIG.PCW_ACT_FPGA3_PERIPHERAL_FREQMHZ {10.000000} \
#   CONFIG.PCW_ACT_I2C_PERIPHERAL_FREQMHZ {50} \
#   CONFIG.PCW_ACT_PCAP_PERIPHERAL_FREQMHZ {200.000000} \
#   CONFIG.PCW_ACT_QSPI_PERIPHERAL_FREQMHZ {200.000000} \
#   CONFIG.PCW_ACT_SDIO_PERIPHERAL_FREQMHZ {50.000000} \
#   CONFIG.PCW_ACT_SMC_PERIPHERAL_FREQMHZ {10.000000} \
#   CONFIG.PCW_ACT_SPI_PERIPHERAL_FREQMHZ {10.000000} \
#   CONFIG.PCW_ACT_TPIU_PERIPHERAL_FREQMHZ {200.000000} \
#   CONFIG.PCW_ACT_TTC0_CLK0_PERIPHERAL_FREQMHZ {108.333336} \
#   CONFIG.PCW_ACT_TTC0_CLK1_PERIPHERAL_FREQMHZ {108.333336} \
#   CONFIG.PCW_ACT_TTC0_CLK2_PERIPHERAL_FREQMHZ {108.333336} \
#   CONFIG.PCW_ACT_TTC1_CLK0_PERIPHERAL_FREQMHZ {108.333336} \
#   CONFIG.PCW_ACT_TTC1_CLK1_PERIPHERAL_FREQMHZ {108.333336} \
#   CONFIG.PCW_ACT_TTC1_CLK2_PERIPHERAL_FREQMHZ {108.333336} \
#   CONFIG.PCW_ACT_TTC_PERIPHERAL_FREQMHZ {50} \
#   CONFIG.PCW_ACT_UART_PERIPHERAL_FREQMHZ {100.000000} \
#   CONFIG.PCW_ACT_USB0_PERIPHERAL_FREQMHZ {60} \
#   CONFIG.PCW_ACT_USB1_PERIPHERAL_FREQMHZ {60} \
#   CONFIG.PCW_ACT_WDT_PERIPHERAL_FREQMHZ {108.333336} \
#   CONFIG.PCW_APU_CLK_RATIO_ENABLE {6:2:1} \
#   CONFIG.PCW_APU_PERIPHERAL_FREQMHZ {650} \
#   CONFIG.PCW_ARMPLL_CTRL_FBDIV {26} \
#   CONFIG.PCW_CAN0_PERIPHERAL_CLKSRC {External} \
#   CONFIG.PCW_CAN1_PERIPHERAL_CLKSRC {External} \
#   CONFIG.PCW_CAN_PERIPHERAL_CLKSRC {IO PLL} \
#   CONFIG.PCW_CAN_PERIPHERAL_VALID {0} \
#   CONFIG.PCW_CLK0_FREQ {100000000} \
#   CONFIG.PCW_CLK1_FREQ {10000000} \
#   CONFIG.PCW_CLK2_FREQ {10000000} \
#   CONFIG.PCW_CLK3_FREQ {10000000} \
#   CONFIG.PCW_CPU_CPU_6X4X_MAX_RANGE {667} \
#   CONFIG.PCW_CPU_CPU_PLL_FREQMHZ {1300.000} \
#   CONFIG.PCW_CPU_PERIPHERAL_CLKSRC {ARM PLL} \
#   CONFIG.PCW_CRYSTAL_PERIPHERAL_FREQMHZ {50} \
#   CONFIG.PCW_DCI_PERIPHERAL_CLKSRC {DDR PLL} \
#   CONFIG.PCW_DCI_PERIPHERAL_DIVISOR0 {52} \
#   CONFIG.PCW_DCI_PERIPHERAL_DIVISOR1 {2} \
#   CONFIG.PCW_DCI_PERIPHERAL_FREQMHZ {10.159} \
#   CONFIG.PCW_DDRPLL_CTRL_FBDIV {21} \
#   CONFIG.PCW_DDR_DDR_PLL_FREQMHZ {1050.000} \
#   CONFIG.PCW_DDR_PERIPHERAL_CLKSRC {DDR PLL} \
#   CONFIG.PCW_DDR_RAM_BASEADDR {0x00100000} \
#   CONFIG.PCW_DDR_RAM_HIGHADDR {0x1FFFFFFF} \
#   CONFIG.PCW_DM_WIDTH {4} \
#   CONFIG.PCW_DQS_WIDTH {4} \
#   CONFIG.PCW_DQ_WIDTH {32} \
#   CONFIG.PCW_ENET0_BASEADDR {0xE000B000} \
#   CONFIG.PCW_ENET0_ENET0_IO {MIO 16 .. 27} \
#   CONFIG.PCW_ENET0_GRP_MDIO_ENABLE {1} \
#   CONFIG.PCW_ENET0_GRP_MDIO_IO {MIO 52 .. 53} \
#   CONFIG.PCW_ENET0_HIGHADDR {0xE000BFFF} \
#   CONFIG.PCW_ENET0_PERIPHERAL_CLKSRC {IO PLL} \
#   CONFIG.PCW_ENET0_PERIPHERAL_DIVISOR0 {8} \
#   CONFIG.PCW_ENET0_PERIPHERAL_ENABLE {1} \
#   CONFIG.PCW_ENET0_PERIPHERAL_FREQMHZ {1000 Mbps} \
#   CONFIG.PCW_ENET0_RESET_ENABLE {1} \
#   CONFIG.PCW_ENET0_RESET_IO {MIO 9} \
#   CONFIG.PCW_ENET1_PERIPHERAL_CLKSRC {IO PLL} \
#   CONFIG.PCW_ENET1_PERIPHERAL_ENABLE {0} \
#   CONFIG.PCW_ENET_RESET_ENABLE {1} \
#   CONFIG.PCW_ENET_RESET_POLARITY {Active Low} \
#   CONFIG.PCW_ENET_RESET_SELECT {Share reset pin} \
#   CONFIG.PCW_EN_4K_TIMER {0} \
#   CONFIG.PCW_EN_CAN0 {0} \
#   CONFIG.PCW_EN_CAN1 {0} \
#   CONFIG.PCW_EN_CLK0_PORT {1} \
#   CONFIG.PCW_EN_CLK1_PORT {0} \
#   CONFIG.PCW_EN_CLK2_PORT {0} \
#   CONFIG.PCW_EN_CLK3_PORT {0} \
#   CONFIG.PCW_EN_CLKTRIG0_PORT {0} \
#   CONFIG.PCW_EN_CLKTRIG1_PORT {0} \
#   CONFIG.PCW_EN_CLKTRIG2_PORT {0} \
#   CONFIG.PCW_EN_CLKTRIG3_PORT {0} \
#   CONFIG.PCW_EN_DDR {1} \
#   CONFIG.PCW_EN_EMIO_CAN0 {0} \
#   CONFIG.PCW_EN_EMIO_CAN1 {0} \
#   CONFIG.PCW_EN_EMIO_CD_SDIO0 {0} \
#   CONFIG.PCW_EN_EMIO_CD_SDIO1 {0} \
#   CONFIG.PCW_EN_EMIO_ENET0 {0} \
#   CONFIG.PCW_EN_EMIO_ENET1 {0} \
#   CONFIG.PCW_EN_EMIO_GPIO {0} \
#   CONFIG.PCW_EN_EMIO_I2C0 {0} \
#   CONFIG.PCW_EN_EMIO_I2C1 {0} \
#   CONFIG.PCW_EN_EMIO_MODEM_UART0 {0} \
#   CONFIG.PCW_EN_EMIO_MODEM_UART1 {0} \
#   CONFIG.PCW_EN_EMIO_PJTAG {0} \
#   CONFIG.PCW_EN_EMIO_SDIO0 {0} \
#   CONFIG.PCW_EN_EMIO_SDIO1 {0} \
#   CONFIG.PCW_EN_EMIO_SPI0 {0} \
#   CONFIG.PCW_EN_EMIO_SPI1 {0} \
#   CONFIG.PCW_EN_EMIO_SRAM_INT {0} \
#   CONFIG.PCW_EN_EMIO_TRACE {0} \
#   CONFIG.PCW_EN_EMIO_TTC0 {0} \
#   CONFIG.PCW_EN_EMIO_TTC1 {0} \
#   CONFIG.PCW_EN_EMIO_UART0 {0} \
#   CONFIG.PCW_EN_EMIO_UART1 {0} \
#   CONFIG.PCW_EN_EMIO_WDT {0} \
#   CONFIG.PCW_EN_EMIO_WP_SDIO0 {0} \
#   CONFIG.PCW_EN_EMIO_WP_SDIO1 {0} \
#   CONFIG.PCW_EN_ENET0 {1} \
#   CONFIG.PCW_EN_ENET1 {0} \
#   CONFIG.PCW_EN_GPIO {1} \
#   CONFIG.PCW_EN_I2C0 {0} \
#   CONFIG.PCW_EN_I2C1 {0} \
#   CONFIG.PCW_EN_MODEM_UART0 {0} \
#   CONFIG.PCW_EN_MODEM_UART1 {0} \
#   CONFIG.PCW_EN_PJTAG {0} \
#   CONFIG.PCW_EN_PTP_ENET0 {0} \
#   CONFIG.PCW_EN_PTP_ENET1 {0} \
#   CONFIG.PCW_EN_QSPI {1} \
#   CONFIG.PCW_EN_RST0_PORT {1} \
#   CONFIG.PCW_EN_RST1_PORT {0} \
#   CONFIG.PCW_EN_RST2_PORT {0} \
#   CONFIG.PCW_EN_RST3_PORT {0} \
#   CONFIG.PCW_EN_SDIO0 {1} \
#   CONFIG.PCW_EN_SDIO1 {0} \
#   CONFIG.PCW_EN_SMC {0} \
#   CONFIG.PCW_EN_SPI0 {0} \
#   CONFIG.PCW_EN_SPI1 {0} \
#   CONFIG.PCW_EN_TRACE {0} \
#   CONFIG.PCW_EN_TTC0 {0} \
#   CONFIG.PCW_EN_TTC1 {0} \
#   CONFIG.PCW_EN_UART0 {1} \
#   CONFIG.PCW_EN_UART1 {0} \
#   CONFIG.PCW_EN_USB0 {1} \
#   CONFIG.PCW_EN_USB1 {0} \
#   CONFIG.PCW_EN_WDT {0} \
#   CONFIG.PCW_FCLK0_PERIPHERAL_CLKSRC {IO PLL} \
#   CONFIG.PCW_FCLK0_PERIPHERAL_DIVISOR0 {5} \
#   CONFIG.PCW_FCLK0_PERIPHERAL_DIVISOR1 {2} \
#   CONFIG.PCW_FCLK1_PERIPHERAL_CLKSRC {IO PLL} \
#   CONFIG.PCW_FCLK2_PERIPHERAL_CLKSRC {IO PLL} \
#   CONFIG.PCW_FCLK3_PERIPHERAL_CLKSRC {IO PLL} \
#   CONFIG.PCW_FCLK_CLK0_BUF {TRUE} \
#   CONFIG.PCW_FPGA0_PERIPHERAL_FREQMHZ {100} \
#   CONFIG.PCW_FPGA1_PERIPHERAL_FREQMHZ {50} \
#   CONFIG.PCW_FPGA2_PERIPHERAL_FREQMHZ {50} \
#   CONFIG.PCW_FPGA3_PERIPHERAL_FREQMHZ {50} \
#   CONFIG.PCW_FPGA_FCLK0_ENABLE {1} \
#   CONFIG.PCW_FTM_CTI_IN0 {<Select>} \
#   CONFIG.PCW_FTM_CTI_IN1 {<Select>} \
#   CONFIG.PCW_FTM_CTI_IN2 {<Select>} \
#   CONFIG.PCW_FTM_CTI_IN3 {<Select>} \
#   CONFIG.PCW_FTM_CTI_OUT0 {<Select>} \
#   CONFIG.PCW_FTM_CTI_OUT1 {<Select>} \
#   CONFIG.PCW_FTM_CTI_OUT2 {<Select>} \
#   CONFIG.PCW_FTM_CTI_OUT3 {<Select>} \
#   CONFIG.PCW_GPIO_BASEADDR {0xE000A000} \
#   CONFIG.PCW_GPIO_EMIO_GPIO_ENABLE {0} \
#   CONFIG.PCW_GPIO_HIGHADDR {0xE000AFFF} \
#   CONFIG.PCW_GPIO_MIO_GPIO_ENABLE {1} \
#   CONFIG.PCW_GPIO_MIO_GPIO_IO {MIO} \
#   CONFIG.PCW_GPIO_PERIPHERAL_ENABLE {0} \
#   CONFIG.PCW_I2C_RESET_ENABLE {0} \
#   CONFIG.PCW_I2C_RESET_POLARITY {Active Low} \
#   CONFIG.PCW_IMPORT_BOARD_PRESET {None} \
#   CONFIG.PCW_INCLUDE_ACP_TRANS_CHECK {0} \
#   CONFIG.PCW_IOPLL_CTRL_FBDIV {20} \
#   CONFIG.PCW_IO_IO_PLL_FREQMHZ {1000.000} \
#   CONFIG.PCW_MIO_0_DIRECTION {inout} \
#   CONFIG.PCW_MIO_0_IOTYPE {LVCMOS 3.3V} \
#   CONFIG.PCW_MIO_0_PULLUP {enabled} \
#   CONFIG.PCW_MIO_0_SLEW {slow} \
#   CONFIG.PCW_MIO_10_DIRECTION {inout} \
#   CONFIG.PCW_MIO_10_IOTYPE {LVCMOS 3.3V} \
#   CONFIG.PCW_MIO_10_PULLUP {enabled} \
#   CONFIG.PCW_MIO_10_SLEW {slow} \
#   CONFIG.PCW_MIO_11_DIRECTION {inout} \
#   CONFIG.PCW_MIO_11_IOTYPE {LVCMOS 3.3V} \
#   CONFIG.PCW_MIO_11_PULLUP {enabled} \
#   CONFIG.PCW_MIO_11_SLEW {slow} \
#   CONFIG.PCW_MIO_12_DIRECTION {inout} \
#   CONFIG.PCW_MIO_12_IOTYPE {LVCMOS 3.3V} \
#   CONFIG.PCW_MIO_12_PULLUP {enabled} \
#   CONFIG.PCW_MIO_12_SLEW {slow} \
#   CONFIG.PCW_MIO_13_DIRECTION {inout} \
#   CONFIG.PCW_MIO_13_IOTYPE {LVCMOS 3.3V} \
#   CONFIG.PCW_MIO_13_PULLUP {enabled} \
#   CONFIG.PCW_MIO_13_SLEW {slow} \
#   CONFIG.PCW_MIO_14_DIRECTION {in} \
#   CONFIG.PCW_MIO_14_IOTYPE {LVCMOS 3.3V} \
#   CONFIG.PCW_MIO_14_PULLUP {enabled} \
#   CONFIG.PCW_MIO_14_SLEW {slow} \
#   CONFIG.PCW_MIO_15_DIRECTION {out} \
#   CONFIG.PCW_MIO_15_IOTYPE {LVCMOS 3.3V} \
#   CONFIG.PCW_MIO_15_PULLUP {enabled} \
#   CONFIG.PCW_MIO_15_SLEW {slow} \
#   CONFIG.PCW_MIO_16_DIRECTION {out} \
#   CONFIG.PCW_MIO_16_IOTYPE {LVCMOS 1.8V} \
#   CONFIG.PCW_MIO_16_PULLUP {enabled} \
#   CONFIG.PCW_MIO_16_SLEW {slow} \
#   CONFIG.PCW_MIO_17_DIRECTION {out} \
#   CONFIG.PCW_MIO_17_IOTYPE {LVCMOS 1.8V} \
#   CONFIG.PCW_MIO_17_PULLUP {enabled} \
#   CONFIG.PCW_MIO_17_SLEW {slow} \
#   CONFIG.PCW_MIO_18_DIRECTION {out} \
#   CONFIG.PCW_MIO_18_IOTYPE {LVCMOS 1.8V} \
#   CONFIG.PCW_MIO_18_PULLUP {enabled} \
#   CONFIG.PCW_MIO_18_SLEW {slow} \
#   CONFIG.PCW_MIO_19_DIRECTION {out} \
#   CONFIG.PCW_MIO_19_IOTYPE {LVCMOS 1.8V} \
#   CONFIG.PCW_MIO_19_PULLUP {enabled} \
#   CONFIG.PCW_MIO_19_SLEW {slow} \
#   CONFIG.PCW_MIO_1_DIRECTION {out} \
#   CONFIG.PCW_MIO_1_IOTYPE {LVCMOS 3.3V} \
#   CONFIG.PCW_MIO_1_PULLUP {enabled} \
#   CONFIG.PCW_MIO_1_SLEW {slow} \
#   CONFIG.PCW_MIO_20_DIRECTION {out} \
#   CONFIG.PCW_MIO_20_IOTYPE {LVCMOS 1.8V} \
#   CONFIG.PCW_MIO_20_PULLUP {enabled} \
#   CONFIG.PCW_MIO_20_SLEW {slow} \
#   CONFIG.PCW_MIO_21_DIRECTION {out} \
#   CONFIG.PCW_MIO_21_IOTYPE {LVCMOS 1.8V} \
#   CONFIG.PCW_MIO_21_PULLUP {enabled} \
#   CONFIG.PCW_MIO_21_SLEW {slow} \
#   CONFIG.PCW_MIO_22_DIRECTION {in} \
#   CONFIG.PCW_MIO_22_IOTYPE {LVCMOS 1.8V} \
#   CONFIG.PCW_MIO_22_PULLUP {enabled} \
#   CONFIG.PCW_MIO_22_SLEW {slow} \
#   CONFIG.PCW_MIO_23_DIRECTION {in} \
#   CONFIG.PCW_MIO_23_IOTYPE {LVCMOS 1.8V} \
#   CONFIG.PCW_MIO_23_PULLUP {enabled} \
#   CONFIG.PCW_MIO_23_SLEW {slow} \
#   CONFIG.PCW_MIO_24_DIRECTION {in} \
#   CONFIG.PCW_MIO_24_IOTYPE {LVCMOS 1.8V} \
#   CONFIG.PCW_MIO_24_PULLUP {enabled} \
#   CONFIG.PCW_MIO_24_SLEW {slow} \
#   CONFIG.PCW_MIO_25_DIRECTION {in} \
#   CONFIG.PCW_MIO_25_IOTYPE {LVCMOS 1.8V} \
#   CONFIG.PCW_MIO_25_PULLUP {enabled} \
#   CONFIG.PCW_MIO_25_SLEW {slow} \
#   CONFIG.PCW_MIO_26_DIRECTION {in} \
#   CONFIG.PCW_MIO_26_IOTYPE {LVCMOS 1.8V} \
#   CONFIG.PCW_MIO_26_PULLUP {enabled} \
#   CONFIG.PCW_MIO_26_SLEW {slow} \
#   CONFIG.PCW_MIO_27_DIRECTION {in} \
#   CONFIG.PCW_MIO_27_IOTYPE {LVCMOS 1.8V} \
#   CONFIG.PCW_MIO_27_PULLUP {enabled} \
#   CONFIG.PCW_MIO_27_SLEW {slow} \
#   CONFIG.PCW_MIO_28_DIRECTION {inout} \
#   CONFIG.PCW_MIO_28_IOTYPE {LVCMOS 1.8V} \
#   CONFIG.PCW_MIO_28_PULLUP {enabled} \
#   CONFIG.PCW_MIO_28_SLEW {slow} \
#   CONFIG.PCW_MIO_29_DIRECTION {in} \
#   CONFIG.PCW_MIO_29_IOTYPE {LVCMOS 1.8V} \
#   CONFIG.PCW_MIO_29_PULLUP {enabled} \
#   CONFIG.PCW_MIO_29_SLEW {slow} \
#   CONFIG.PCW_MIO_2_DIRECTION {inout} \
#   CONFIG.PCW_MIO_2_IOTYPE {LVCMOS 3.3V} \
#   CONFIG.PCW_MIO_2_PULLUP {disabled} \
#   CONFIG.PCW_MIO_2_SLEW {slow} \
#   CONFIG.PCW_MIO_30_DIRECTION {out} \
#   CONFIG.PCW_MIO_30_IOTYPE {LVCMOS 1.8V} \
#   CONFIG.PCW_MIO_30_PULLUP {enabled} \
#   CONFIG.PCW_MIO_30_SLEW {slow} \
#   CONFIG.PCW_MIO_31_DIRECTION {in} \
#   CONFIG.PCW_MIO_31_IOTYPE {LVCMOS 1.8V} \
#   CONFIG.PCW_MIO_31_PULLUP {enabled} \
#   CONFIG.PCW_MIO_31_SLEW {slow} \
#   CONFIG.PCW_MIO_32_DIRECTION {inout} \
#   CONFIG.PCW_MIO_32_IOTYPE {LVCMOS 1.8V} \
#   CONFIG.PCW_MIO_32_PULLUP {enabled} \
#   CONFIG.PCW_MIO_32_SLEW {slow} \
#   CONFIG.PCW_MIO_33_DIRECTION {inout} \
#   CONFIG.PCW_MIO_33_IOTYPE {LVCMOS 1.8V} \
#   CONFIG.PCW_MIO_33_PULLUP {enabled} \
#   CONFIG.PCW_MIO_33_SLEW {slow} \
#   CONFIG.PCW_MIO_34_DIRECTION {inout} \
#   CONFIG.PCW_MIO_34_IOTYPE {LVCMOS 1.8V} \
#   CONFIG.PCW_MIO_34_PULLUP {enabled} \
#   CONFIG.PCW_MIO_34_SLEW {slow} \
#   CONFIG.PCW_MIO_35_DIRECTION {inout} \
#   CONFIG.PCW_MIO_35_IOTYPE {LVCMOS 1.8V} \
#   CONFIG.PCW_MIO_35_PULLUP {enabled} \
#   CONFIG.PCW_MIO_35_SLEW {slow} \
#   CONFIG.PCW_MIO_36_DIRECTION {in} \
#   CONFIG.PCW_MIO_36_IOTYPE {LVCMOS 1.8V} \
#   CONFIG.PCW_MIO_36_PULLUP {enabled} \
#   CONFIG.PCW_MIO_36_SLEW {slow} \
#   CONFIG.PCW_MIO_37_DIRECTION {inout} \
#   CONFIG.PCW_MIO_37_IOTYPE {LVCMOS 1.8V} \
#   CONFIG.PCW_MIO_37_PULLUP {enabled} \
#   CONFIG.PCW_MIO_37_SLEW {slow} \
#   CONFIG.PCW_MIO_38_DIRECTION {inout} \
#   CONFIG.PCW_MIO_38_IOTYPE {LVCMOS 1.8V} \
#   CONFIG.PCW_MIO_38_PULLUP {enabled} \
#   CONFIG.PCW_MIO_38_SLEW {slow} \
#   CONFIG.PCW_MIO_39_DIRECTION {inout} \
#   CONFIG.PCW_MIO_39_IOTYPE {LVCMOS 1.8V} \
#   CONFIG.PCW_MIO_39_PULLUP {enabled} \
#   CONFIG.PCW_MIO_39_SLEW {slow} \
#   CONFIG.PCW_MIO_3_DIRECTION {inout} \
#   CONFIG.PCW_MIO_3_IOTYPE {LVCMOS 3.3V} \
#   CONFIG.PCW_MIO_3_PULLUP {disabled} \
#   CONFIG.PCW_MIO_3_SLEW {slow} \
#   CONFIG.PCW_MIO_40_DIRECTION {inout} \
#   CONFIG.PCW_MIO_40_IOTYPE {LVCMOS 1.8V} \
#   CONFIG.PCW_MIO_40_PULLUP {enabled} \
#   CONFIG.PCW_MIO_40_SLEW {slow} \
#   CONFIG.PCW_MIO_41_DIRECTION {inout} \
#   CONFIG.PCW_MIO_41_IOTYPE {LVCMOS 1.8V} \
#   CONFIG.PCW_MIO_41_PULLUP {enabled} \
#   CONFIG.PCW_MIO_41_SLEW {slow} \
#   CONFIG.PCW_MIO_42_DIRECTION {inout} \
#   CONFIG.PCW_MIO_42_IOTYPE {LVCMOS 1.8V} \
#   CONFIG.PCW_MIO_42_PULLUP {enabled} \
#   CONFIG.PCW_MIO_42_SLEW {slow} \
#   CONFIG.PCW_MIO_43_DIRECTION {inout} \
#   CONFIG.PCW_MIO_43_IOTYPE {LVCMOS 1.8V} \
#   CONFIG.PCW_MIO_43_PULLUP {enabled} \
#   CONFIG.PCW_MIO_43_SLEW {slow} \
#   CONFIG.PCW_MIO_44_DIRECTION {inout} \
#   CONFIG.PCW_MIO_44_IOTYPE {LVCMOS 1.8V} \
#   CONFIG.PCW_MIO_44_PULLUP {enabled} \
#   CONFIG.PCW_MIO_44_SLEW {slow} \
#   CONFIG.PCW_MIO_45_DIRECTION {inout} \
#   CONFIG.PCW_MIO_45_IOTYPE {LVCMOS 1.8V} \
#   CONFIG.PCW_MIO_45_PULLUP {enabled} \
#   CONFIG.PCW_MIO_45_SLEW {slow} \
#   CONFIG.PCW_MIO_46_DIRECTION {out} \
#   CONFIG.PCW_MIO_46_IOTYPE {LVCMOS 1.8V} \
#   CONFIG.PCW_MIO_46_PULLUP {enabled} \
#   CONFIG.PCW_MIO_46_SLEW {slow} \
#   CONFIG.PCW_MIO_47_DIRECTION {in} \
#   CONFIG.PCW_MIO_47_IOTYPE {LVCMOS 1.8V} \
#   CONFIG.PCW_MIO_47_PULLUP {enabled} \
#   CONFIG.PCW_MIO_47_SLEW {slow} \
#   CONFIG.PCW_MIO_48_DIRECTION {inout} \
#   CONFIG.PCW_MIO_48_IOTYPE {LVCMOS 1.8V} \
#   CONFIG.PCW_MIO_48_PULLUP {enabled} \
#   CONFIG.PCW_MIO_48_SLEW {slow} \
#   CONFIG.PCW_MIO_49_DIRECTION {inout} \
#   CONFIG.PCW_MIO_49_IOTYPE {LVCMOS 1.8V} \
#   CONFIG.PCW_MIO_49_PULLUP {enabled} \
#   CONFIG.PCW_MIO_49_SLEW {slow} \
#   CONFIG.PCW_MIO_4_DIRECTION {inout} \
#   CONFIG.PCW_MIO_4_IOTYPE {LVCMOS 3.3V} \
#   CONFIG.PCW_MIO_4_PULLUP {disabled} \
#   CONFIG.PCW_MIO_4_SLEW {slow} \
#   CONFIG.PCW_MIO_50_DIRECTION {inout} \
#   CONFIG.PCW_MIO_50_IOTYPE {LVCMOS 1.8V} \
#   CONFIG.PCW_MIO_50_PULLUP {enabled} \
#   CONFIG.PCW_MIO_50_SLEW {slow} \
#   CONFIG.PCW_MIO_51_DIRECTION {inout} \
#   CONFIG.PCW_MIO_51_IOTYPE {LVCMOS 1.8V} \
#   CONFIG.PCW_MIO_51_PULLUP {enabled} \
#   CONFIG.PCW_MIO_51_SLEW {slow} \
#   CONFIG.PCW_MIO_52_DIRECTION {out} \
#   CONFIG.PCW_MIO_52_IOTYPE {LVCMOS 1.8V} \
#   CONFIG.PCW_MIO_52_PULLUP {enabled} \
#   CONFIG.PCW_MIO_52_SLEW {slow} \
#   CONFIG.PCW_MIO_53_DIRECTION {inout} \
#   CONFIG.PCW_MIO_53_IOTYPE {LVCMOS 1.8V} \
#   CONFIG.PCW_MIO_53_PULLUP {enabled} \
#   CONFIG.PCW_MIO_53_SLEW {slow} \
#   CONFIG.PCW_MIO_5_DIRECTION {inout} \
#   CONFIG.PCW_MIO_5_IOTYPE {LVCMOS 3.3V} \
#   CONFIG.PCW_MIO_5_PULLUP {disabled} \
#   CONFIG.PCW_MIO_5_SLEW {slow} \
#   CONFIG.PCW_MIO_6_DIRECTION {out} \
#   CONFIG.PCW_MIO_6_IOTYPE {LVCMOS 3.3V} \
#   CONFIG.PCW_MIO_6_PULLUP {disabled} \
#   CONFIG.PCW_MIO_6_SLEW {slow} \
#   CONFIG.PCW_MIO_7_DIRECTION {out} \
#   CONFIG.PCW_MIO_7_IOTYPE {LVCMOS 3.3V} \
#   CONFIG.PCW_MIO_7_PULLUP {disabled} \
#   CONFIG.PCW_MIO_7_SLEW {slow} \
#   CONFIG.PCW_MIO_8_DIRECTION {out} \
#   CONFIG.PCW_MIO_8_IOTYPE {LVCMOS 3.3V} \
#   CONFIG.PCW_MIO_8_PULLUP {disabled} \
#   CONFIG.PCW_MIO_8_SLEW {slow} \
#   CONFIG.PCW_MIO_9_DIRECTION {out} \
#   CONFIG.PCW_MIO_9_IOTYPE {LVCMOS 3.3V} \
#   CONFIG.PCW_MIO_9_PULLUP {enabled} \
#   CONFIG.PCW_MIO_9_SLEW {slow} \
#   CONFIG.PCW_MIO_PRIMITIVE {54} \
#   CONFIG.PCW_MIO_TREE_PERIPHERALS {GPIO#Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#GPIO#Quad SPI Flash#ENET Reset#GPIO#GPIO#GPIO#GPIO#UART 0#UART 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#SD 0#SD 0#SD 0#SD 0#SD 0#SD 0#USB Reset#SD 0#GPIO#GPIO#GPIO#GPIO#Enet 0#Enet 0} \
#   CONFIG.PCW_MIO_TREE_SIGNALS {gpio[0]#qspi0_ss_b#qspi0_io[0]#qspi0_io[1]#qspi0_io[2]#qspi0_io[3]/HOLD_B#qspi0_sclk#gpio[7]#qspi_fbclk#reset#gpio[10]#gpio[11]#gpio[12]#gpio[13]#rx#tx#tx_clk#txd[0]#txd[1]#txd[2]#txd[3]#tx_ctl#rx_clk#rxd[0]#rxd[1]#rxd[2]#rxd[3]#rx_ctl#data[4]#dir#stp#nxt#data[0]#data[1]#data[2]#data[3]#clk#data[5]#data[6]#data[7]#clk#cmd#data[0]#data[1]#data[2]#data[3]#reset#cd#gpio[48]#gpio[49]#gpio[50]#gpio[51]#mdc#mdio} \
#   CONFIG.PCW_NAND_CYCLES_T_AR {1} \
#   CONFIG.PCW_NAND_CYCLES_T_CLR {1} \
#   CONFIG.PCW_NAND_CYCLES_T_RC {11} \
#   CONFIG.PCW_NAND_CYCLES_T_REA {1} \
#   CONFIG.PCW_NAND_CYCLES_T_RR {1} \
#   CONFIG.PCW_NAND_CYCLES_T_WC {11} \
#   CONFIG.PCW_NAND_CYCLES_T_WP {1} \
#   CONFIG.PCW_NOR_CS0_T_CEOE {1} \
#   CONFIG.PCW_NOR_CS0_T_PC {1} \
#   CONFIG.PCW_NOR_CS0_T_RC {11} \
#   CONFIG.PCW_NOR_CS0_T_TR {1} \
#   CONFIG.PCW_NOR_CS0_T_WC {11} \
#   CONFIG.PCW_NOR_CS0_T_WP {1} \
#   CONFIG.PCW_NOR_CS0_WE_TIME {0} \
#   CONFIG.PCW_NOR_CS1_T_CEOE {1} \
#   CONFIG.PCW_NOR_CS1_T_PC {1} \
#   CONFIG.PCW_NOR_CS1_T_RC {11} \
#   CONFIG.PCW_NOR_CS1_T_TR {1} \
#   CONFIG.PCW_NOR_CS1_T_WC {11} \
#   CONFIG.PCW_NOR_CS1_T_WP {1} \
#   CONFIG.PCW_NOR_CS1_WE_TIME {0} \
#   CONFIG.PCW_NOR_SRAM_CS0_T_CEOE {1} \
#   CONFIG.PCW_NOR_SRAM_CS0_T_PC {1} \
#   CONFIG.PCW_NOR_SRAM_CS0_T_RC {11} \
#   CONFIG.PCW_NOR_SRAM_CS0_T_TR {1} \
#   CONFIG.PCW_NOR_SRAM_CS0_T_WC {11} \
#   CONFIG.PCW_NOR_SRAM_CS0_T_WP {1} \
#   CONFIG.PCW_NOR_SRAM_CS0_WE_TIME {0} \
#   CONFIG.PCW_NOR_SRAM_CS1_T_CEOE {1} \
#   CONFIG.PCW_NOR_SRAM_CS1_T_PC {1} \
#   CONFIG.PCW_NOR_SRAM_CS1_T_RC {11} \
#   CONFIG.PCW_NOR_SRAM_CS1_T_TR {1} \
#   CONFIG.PCW_NOR_SRAM_CS1_T_WC {11} \
#   CONFIG.PCW_NOR_SRAM_CS1_T_WP {1} \
#   CONFIG.PCW_NOR_SRAM_CS1_WE_TIME {0} \
#   CONFIG.PCW_OVERRIDE_BASIC_CLOCK {0} \
#   CONFIG.PCW_PACKAGE_DDR_BOARD_DELAY0 {0.223} \
#   CONFIG.PCW_PACKAGE_DDR_BOARD_DELAY1 {0.212} \
#   CONFIG.PCW_PACKAGE_DDR_BOARD_DELAY2 {0.085} \
#   CONFIG.PCW_PACKAGE_DDR_BOARD_DELAY3 {0.092} \
#   CONFIG.PCW_PACKAGE_DDR_DQS_TO_CLK_DELAY_0 {0.040} \
#   CONFIG.PCW_PACKAGE_DDR_DQS_TO_CLK_DELAY_1 {0.058} \
#   CONFIG.PCW_PACKAGE_DDR_DQS_TO_CLK_DELAY_2 {-0.009} \
#   CONFIG.PCW_PACKAGE_DDR_DQS_TO_CLK_DELAY_3 {-0.033} \
#   CONFIG.PCW_PACKAGE_NAME {clg400} \
#   CONFIG.PCW_PCAP_PERIPHERAL_CLKSRC {IO PLL} \
#   CONFIG.PCW_PCAP_PERIPHERAL_DIVISOR0 {5} \
#   CONFIG.PCW_PCAP_PERIPHERAL_FREQMHZ {200} \
#   CONFIG.PCW_PERIPHERAL_BOARD_PRESET {part0} \
#   CONFIG.PCW_PLL_BYPASSMODE_ENABLE {0} \
#   CONFIG.PCW_PRESET_BANK0_VOLTAGE {LVCMOS 3.3V} \
#   CONFIG.PCW_PRESET_BANK1_VOLTAGE {LVCMOS 1.8V} \
#   CONFIG.PCW_PS7_SI_REV {PRODUCTION} \
#   CONFIG.PCW_QSPI_GRP_FBCLK_ENABLE {1} \
#   CONFIG.PCW_QSPI_GRP_FBCLK_IO {MIO 8} \
#   CONFIG.PCW_QSPI_GRP_IO1_ENABLE {0} \
#   CONFIG.PCW_QSPI_GRP_SINGLE_SS_ENABLE {1} \
#   CONFIG.PCW_QSPI_GRP_SINGLE_SS_IO {MIO 1 .. 6} \
#   CONFIG.PCW_QSPI_GRP_SS1_ENABLE {0} \
#   CONFIG.PCW_QSPI_INTERNAL_HIGHADDRESS {0xFCFFFFFF} \
#   CONFIG.PCW_QSPI_PERIPHERAL_CLKSRC {IO PLL} \
#   CONFIG.PCW_QSPI_PERIPHERAL_DIVISOR0 {5} \
#   CONFIG.PCW_QSPI_PERIPHERAL_ENABLE {1} \
#   CONFIG.PCW_QSPI_PERIPHERAL_FREQMHZ {200} \
#   CONFIG.PCW_QSPI_QSPI_IO {MIO 1 .. 6} \
#   CONFIG.PCW_SD0_GRP_CD_ENABLE {1} \
#   CONFIG.PCW_SD0_GRP_CD_IO {MIO 47} \
#   CONFIG.PCW_SD0_GRP_POW_ENABLE {0} \
#   CONFIG.PCW_SD0_GRP_WP_ENABLE {0} \
#   CONFIG.PCW_SD0_PERIPHERAL_ENABLE {1} \
#   CONFIG.PCW_SD0_SD0_IO {MIO 40 .. 45} \
#   CONFIG.PCW_SD1_PERIPHERAL_ENABLE {0} \
#   CONFIG.PCW_SDIO0_BASEADDR {0xE0100000} \
#   CONFIG.PCW_SDIO0_HIGHADDR {0xE0100FFF} \
#   CONFIG.PCW_SDIO_PERIPHERAL_CLKSRC {IO PLL} \
#   CONFIG.PCW_SDIO_PERIPHERAL_DIVISOR0 {20} \
#   CONFIG.PCW_SDIO_PERIPHERAL_FREQMHZ {50} \
#   CONFIG.PCW_SDIO_PERIPHERAL_VALID {1} \
#   CONFIG.PCW_SINGLE_QSPI_DATA_MODE {x4} \
#   CONFIG.PCW_SMC_CYCLE_T0 {NA} \
#   CONFIG.PCW_SMC_CYCLE_T1 {NA} \
#   CONFIG.PCW_SMC_CYCLE_T2 {NA} \
#   CONFIG.PCW_SMC_CYCLE_T3 {NA} \
#   CONFIG.PCW_SMC_CYCLE_T4 {NA} \
#   CONFIG.PCW_SMC_CYCLE_T5 {NA} \
#   CONFIG.PCW_SMC_CYCLE_T6 {NA} \
#   CONFIG.PCW_SMC_PERIPHERAL_CLKSRC {IO PLL} \
#   CONFIG.PCW_SMC_PERIPHERAL_VALID {0} \
#   CONFIG.PCW_SPI0_PERIPHERAL_ENABLE {0} \
#   CONFIG.PCW_SPI1_PERIPHERAL_ENABLE {0} \
#   CONFIG.PCW_SPI_PERIPHERAL_CLKSRC {IO PLL} \
#   CONFIG.PCW_SPI_PERIPHERAL_VALID {0} \
#   CONFIG.PCW_TPIU_PERIPHERAL_CLKSRC {External} \
#   CONFIG.PCW_TTC0_CLK0_PERIPHERAL_CLKSRC {CPU_1X} \
#   CONFIG.PCW_TTC0_CLK0_PERIPHERAL_DIVISOR0 {1} \
#   CONFIG.PCW_TTC0_CLK1_PERIPHERAL_CLKSRC {CPU_1X} \
#   CONFIG.PCW_TTC0_CLK1_PERIPHERAL_DIVISOR0 {1} \
#   CONFIG.PCW_TTC0_CLK2_PERIPHERAL_CLKSRC {CPU_1X} \
#   CONFIG.PCW_TTC0_CLK2_PERIPHERAL_DIVISOR0 {1} \
#   CONFIG.PCW_TTC1_CLK0_PERIPHERAL_CLKSRC {CPU_1X} \
#   CONFIG.PCW_TTC1_CLK0_PERIPHERAL_DIVISOR0 {1} \
#   CONFIG.PCW_TTC1_CLK1_PERIPHERAL_CLKSRC {CPU_1X} \
#   CONFIG.PCW_TTC1_CLK1_PERIPHERAL_DIVISOR0 {1} \
#   CONFIG.PCW_TTC1_CLK2_PERIPHERAL_CLKSRC {CPU_1X} \
#   CONFIG.PCW_TTC1_CLK2_PERIPHERAL_DIVISOR0 {1} \
#   CONFIG.PCW_UART0_BASEADDR {0xE0000000} \
#   CONFIG.PCW_UART0_BAUD_RATE {115200} \
#   CONFIG.PCW_UART0_GRP_FULL_ENABLE {0} \
#   CONFIG.PCW_UART0_HIGHADDR {0xE0000FFF} \
#   CONFIG.PCW_UART0_PERIPHERAL_ENABLE {1} \
#   CONFIG.PCW_UART0_UART0_IO {MIO 14 .. 15} \
#   CONFIG.PCW_UART1_PERIPHERAL_ENABLE {0} \
#   CONFIG.PCW_UART_PERIPHERAL_CLKSRC {IO PLL} \
#   CONFIG.PCW_UART_PERIPHERAL_DIVISOR0 {10} \
#   CONFIG.PCW_UART_PERIPHERAL_FREQMHZ {100} \
#   CONFIG.PCW_UART_PERIPHERAL_VALID {1} \
#   CONFIG.PCW_UIPARAM_ACT_DDR_FREQ_MHZ {525.000000} \
#   CONFIG.PCW_UIPARAM_DDR_ADV_ENABLE {0} \
#   CONFIG.PCW_UIPARAM_DDR_AL {0} \
#   CONFIG.PCW_UIPARAM_DDR_BL {8} \
#   CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY0 {0.223} \
#   CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY1 {0.212} \
#   CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY2 {0.085} \
#   CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY3 {0.092} \
#   CONFIG.PCW_UIPARAM_DDR_BUS_WIDTH {16 Bit} \
#   CONFIG.PCW_UIPARAM_DDR_CLOCK_0_LENGTH_MM {25.8} \
#   CONFIG.PCW_UIPARAM_DDR_CLOCK_0_PACKAGE_LENGTH {80.4535} \
#   CONFIG.PCW_UIPARAM_DDR_CLOCK_0_PROPOGATION_DELAY {160} \
#   CONFIG.PCW_UIPARAM_DDR_CLOCK_1_LENGTH_MM {25.8} \
#   CONFIG.PCW_UIPARAM_DDR_CLOCK_1_PACKAGE_LENGTH {80.4535} \
#   CONFIG.PCW_UIPARAM_DDR_CLOCK_1_PROPOGATION_DELAY {160} \
#   CONFIG.PCW_UIPARAM_DDR_CLOCK_2_LENGTH_MM {0} \
#   CONFIG.PCW_UIPARAM_DDR_CLOCK_2_PACKAGE_LENGTH {80.4535} \
#   CONFIG.PCW_UIPARAM_DDR_CLOCK_2_PROPOGATION_DELAY {160} \
#   CONFIG.PCW_UIPARAM_DDR_CLOCK_3_LENGTH_MM {0} \
#   CONFIG.PCW_UIPARAM_DDR_CLOCK_3_PACKAGE_LENGTH {80.4535} \
#   CONFIG.PCW_UIPARAM_DDR_CLOCK_3_PROPOGATION_DELAY {160} \
#   CONFIG.PCW_UIPARAM_DDR_CLOCK_STOP_EN {0} \
#   CONFIG.PCW_UIPARAM_DDR_DEVICE_CAPACITY {4096 MBits} \
#   CONFIG.PCW_UIPARAM_DDR_DQS_0_LENGTH_MM {15.6} \
#   CONFIG.PCW_UIPARAM_DDR_DQS_0_PACKAGE_LENGTH {105.056} \
#   CONFIG.PCW_UIPARAM_DDR_DQS_0_PROPOGATION_DELAY {160} \
#   CONFIG.PCW_UIPARAM_DDR_DQS_1_LENGTH_MM {18.8} \
#   CONFIG.PCW_UIPARAM_DDR_DQS_1_PACKAGE_LENGTH {66.904} \
#   CONFIG.PCW_UIPARAM_DDR_DQS_1_PROPOGATION_DELAY {160} \
#   CONFIG.PCW_UIPARAM_DDR_DQS_2_LENGTH_MM {0} \
#   CONFIG.PCW_UIPARAM_DDR_DQS_2_PACKAGE_LENGTH {89.1715} \
#   CONFIG.PCW_UIPARAM_DDR_DQS_2_PROPOGATION_DELAY {160} \
#   CONFIG.PCW_UIPARAM_DDR_DQS_3_LENGTH_MM {0} \
#   CONFIG.PCW_UIPARAM_DDR_DQS_3_PACKAGE_LENGTH {113.63} \
#   CONFIG.PCW_UIPARAM_DDR_DQS_3_PROPOGATION_DELAY {160} \
#   CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_0 {0.040} \
#   CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_1 {0.058} \
#   CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_2 {-0.009} \
#   CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_3 {-0.033} \
#   CONFIG.PCW_UIPARAM_DDR_DQ_0_LENGTH_MM {16.5} \
#   CONFIG.PCW_UIPARAM_DDR_DQ_0_PACKAGE_LENGTH {98.503} \
#   CONFIG.PCW_UIPARAM_DDR_DQ_0_PROPOGATION_DELAY {160} \
#   CONFIG.PCW_UIPARAM_DDR_DQ_1_LENGTH_MM {18} \
#   CONFIG.PCW_UIPARAM_DDR_DQ_1_PACKAGE_LENGTH {68.5855} \
#   CONFIG.PCW_UIPARAM_DDR_DQ_1_PROPOGATION_DELAY {160} \
#   CONFIG.PCW_UIPARAM_DDR_DQ_2_LENGTH_MM {0} \
#   CONFIG.PCW_UIPARAM_DDR_DQ_2_PACKAGE_LENGTH {90.295} \
#   CONFIG.PCW_UIPARAM_DDR_DQ_2_PROPOGATION_DELAY {160} \
#   CONFIG.PCW_UIPARAM_DDR_DQ_3_LENGTH_MM {0} \
#   CONFIG.PCW_UIPARAM_DDR_DQ_3_PACKAGE_LENGTH {103.977} \
#   CONFIG.PCW_UIPARAM_DDR_DQ_3_PROPOGATION_DELAY {160} \
#   CONFIG.PCW_UIPARAM_DDR_DRAM_WIDTH {16 Bits} \
#   CONFIG.PCW_UIPARAM_DDR_ECC {Disabled} \
#   CONFIG.PCW_UIPARAM_DDR_ENABLE {1} \
#   CONFIG.PCW_UIPARAM_DDR_FREQ_MHZ {525} \
#   CONFIG.PCW_UIPARAM_DDR_HIGH_TEMP {Normal (0-85)} \
#   CONFIG.PCW_UIPARAM_DDR_MEMORY_TYPE {DDR 3} \
#   CONFIG.PCW_UIPARAM_DDR_PARTNO {MT41J256M16 RE-125} \
#   CONFIG.PCW_UIPARAM_DDR_ROW_ADDR_COUNT {15} \
#   CONFIG.PCW_UIPARAM_DDR_TRAIN_DATA_EYE {1} \
#   CONFIG.PCW_UIPARAM_DDR_TRAIN_READ_GATE {1} \
#   CONFIG.PCW_UIPARAM_DDR_TRAIN_WRITE_LEVEL {1} \
#   CONFIG.PCW_UIPARAM_DDR_T_FAW {40.0} \
#   CONFIG.PCW_UIPARAM_DDR_T_RC {48.91} \
#   CONFIG.PCW_UIPARAM_DDR_USE_INTERNAL_VREF {0} \
#   CONFIG.PCW_UIPARAM_GENERATE_SUMMARY {NA} \
#   CONFIG.PCW_USB0_BASEADDR {0xE0102000} \
#   CONFIG.PCW_USB0_HIGHADDR {0xE0102fff} \
#   CONFIG.PCW_USB0_PERIPHERAL_ENABLE {1} \
#   CONFIG.PCW_USB0_RESET_ENABLE {1} \
#   CONFIG.PCW_USB0_RESET_IO {MIO 46} \
#   CONFIG.PCW_USB0_USB0_IO {MIO 28 .. 39} \
#   CONFIG.PCW_USB1_PERIPHERAL_ENABLE {0} \
#   CONFIG.PCW_USB_RESET_ENABLE {1} \
#   CONFIG.PCW_USB_RESET_POLARITY {Active Low} \
#   CONFIG.PCW_USB_RESET_SELECT {Share reset pin} \
#   CONFIG.PCW_USE_AXI_FABRIC_IDLE {0} \
#   CONFIG.PCW_USE_AXI_NONSECURE {0} \
#   CONFIG.PCW_USE_CORESIGHT {0} \
#   CONFIG.PCW_USE_CROSS_TRIGGER {0} \
#   CONFIG.PCW_USE_CR_FABRIC {1} \
#   CONFIG.PCW_USE_DDR_BYPASS {0} \
#   CONFIG.PCW_USE_DEBUG {0} \
#   CONFIG.PCW_USE_DMA0 {0} \
#   CONFIG.PCW_USE_DMA1 {0} \
#   CONFIG.PCW_USE_DMA2 {0} \
#   CONFIG.PCW_USE_DMA3 {0} \
#   CONFIG.PCW_USE_EXPANDED_IOP {0} \
#   CONFIG.PCW_USE_FABRIC_INTERRUPT {0} \
#   CONFIG.PCW_USE_HIGH_OCM {0} \
#   CONFIG.PCW_USE_M_AXI_GP0 {0} \
#   CONFIG.PCW_USE_M_AXI_GP1 {0} \
#   CONFIG.PCW_USE_PROC_EVENT_BUS {0} \
#   CONFIG.PCW_USE_PS_SLCR_REGISTERS {0} \
#   CONFIG.PCW_USE_S_AXI_ACP {0} \
#   CONFIG.PCW_USE_S_AXI_GP0 {0} \
#   CONFIG.PCW_USE_S_AXI_GP1 {0} \
#   CONFIG.PCW_USE_S_AXI_HP0 {0} \
#   CONFIG.PCW_USE_S_AXI_HP1 {0} \
#   CONFIG.PCW_USE_S_AXI_HP2 {0} \
#   CONFIG.PCW_USE_S_AXI_HP3 {0} \
#   CONFIG.PCW_USE_TRACE {0} \
#   CONFIG.PCW_VALUE_SILVERSION {3} \
#   CONFIG.PCW_WDT_PERIPHERAL_CLKSRC {CPU_1X} \
#   CONFIG.PCW_WDT_PERIPHERAL_DIVISOR0 {1} \
# ] [get_bd_cells processing_system7_0]
# CRITICAL WARNING: [PSU-1]  Parameter : PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_2 has negative value -0.009 . PS DDR interfaces might fail when entering negative DQS skew values. 
# CRITICAL WARNING: [PSU-2]  Parameter : PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_3 has negative value -0.033 . PS DDR interfaces might fail when entering negative DQS skew values. 
# CRITICAL WARNING: [PSU-1]  Parameter : PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_2 has negative value -0.009 . PS DDR interfaces might fail when entering negative DQS skew values. 
# CRITICAL WARNING: [PSU-2]  Parameter : PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_3 has negative value -0.033 . PS DDR interfaces might fail when entering negative DQS skew values. 
# CRITICAL WARNING: [PSU-1]  Parameter : PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_2 has negative value -0.009 . PS DDR interfaces might fail when entering negative DQS skew values. 
# CRITICAL WARNING: [PSU-2]  Parameter : PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_3 has negative value -0.033 . PS DDR interfaces might fail when entering negative DQS skew values. 
# CRITICAL WARNING: [PSU-1]  Parameter : PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_2 has negative value -0.009 . PS DDR interfaces might fail when entering negative DQS skew values. 
# CRITICAL WARNING: [PSU-2]  Parameter : PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_3 has negative value -0.033 . PS DDR interfaces might fail when entering negative DQS skew values. 
# endgroup
# remove_files  /storage/github-repos/arty-z7/proj/devel-base/devel-base.srcs/sources_1/ip/processing_system7_0/processing_system7_0.xci
# file delete -force /storage/github-repos/arty-z7/proj/devel-base/devel-base.srcs/sources_1/ip/processing_system7_0
# file delete -force /storage/github-repos/arty-z7/proj/devel-base/devel-base.gen/sources_1/ip/processing_system7_0
# make_wrapper -files [get_files /storage/github-repos/arty-z7/proj/devel-base/devel-base.srcs/sources_1/bd/design_1/design_1.bd] -top
# WARNING: [BD 5-700] No address spaces matched 'get_bd_addr_spaces -of_objects /processing_system7_0 -filter {path == /processing_system7_0/Data}'
# WARNING: [BD 5-699] No address segments matched 'get_bd_addr_segs -of_objects {}'
# Wrote  : </storage/github-repos/arty-z7/proj/devel-base/devel-base.srcs/sources_1/bd/design_1/design_1.bd> 
# Wrote  : </storage/github-repos/arty-z7/proj/devel-base/devel-base.srcs/sources_1/bd/design_1/ui/bd_1f5defd0.ui> 
# Verilog Output written to : /storage/github-repos/arty-z7/proj/devel-base/devel-base.gen/sources_1/bd/design_1/synth/design_1.v
# Verilog Output written to : /storage/github-repos/arty-z7/proj/devel-base/devel-base.gen/sources_1/bd/design_1/sim/design_1.v
# Verilog Output written to : /storage/github-repos/arty-z7/proj/devel-base/devel-base.gen/sources_1/bd/design_1/hdl/design_1_wrapper.v
# make_wrapper: Time (s): cpu = 00:00:03 ; elapsed = 00:00:15 . Memory (MB): peak = 8400.215 ; gain = 0.000 ; free physical = 19498 ; free virtual = 22196
# add_files -norecurse /storage/github-repos/arty-z7/proj/devel-base/devel-base.gen/sources_1/bd/design_1/hdl/design_1_wrapper.v
# launch_runs synth_1 -jobs 2
# INFO: [BD 41-1662] The design 'design_1.bd' is already validated. Therefore parameter propagation will not be re-run.
# Verilog Output written to : /storage/github-repos/arty-z7/proj/devel-base/devel-base.gen/sources_1/bd/design_1/synth/design_1.v
# Verilog Output written to : /storage/github-repos/arty-z7/proj/devel-base/devel-base.gen/sources_1/bd/design_1/sim/design_1.v
# Verilog Output written to : /storage/github-repos/arty-z7/proj/devel-base/devel-base.gen/sources_1/bd/design_1/hdl/design_1_wrapper.v
# INFO: [BD 41-1029] Generation completed for the IP Integrator block processing_system7_0 .
# Exporting to file /storage/github-repos/arty-z7/proj/devel-base/devel-base.gen/sources_1/bd/design_1/hw_handoff/design_1.hwh
# Generated Hardware Definition File /storage/github-repos/arty-z7/proj/devel-base/devel-base.gen/sources_1/bd/design_1/synth/design_1.hwdef
# WARNING: [Vivado 12-7122] Auto Incremental Compile:: No reference checkpoint was found in run synth_1. Auto-incremental flow will not be run, the standard flow will be run instead.
# [Thu Apr 23 15:40:57 2026] Launched design_1_processing_system7_0_0_synth_1...
# Run output will be captured here: /storage/github-repos/arty-z7/proj/devel-base/devel-base.runs/design_1_processing_system7_0_0_synth_1/runme.log
# [Thu Apr 23 15:40:57 2026] Launched synth_1...
# Run output will be captured here: /storage/github-repos/arty-z7/proj/devel-base/devel-base.runs/synth_1/runme.log
# launch_runs: Time (s): cpu = 00:00:22 ; elapsed = 00:00:25 . Memory (MB): peak = 8463.148 ; gain = 61.043 ; free physical = 19294 ; free virtual = 22019
# reset_run synth_1
# launch_runs synth_1 -jobs 2
# WARNING: [Vivado 12-7122] Auto Incremental Compile:: No reference checkpoint was found in run synth_1. Auto-incremental flow will not be run, the standard flow will be run instead.
# [Thu Apr 23 15:45:33 2026] Launched synth_1...
# Run output will be captured here: /storage/github-repos/arty-z7/proj/devel-base/devel-base.runs/synth_1/runme.log
# launch_runs impl_1 -jobs 2
# [Thu Apr 23 15:48:25 2026] Launched impl_1...
# Run output will be captured here: /storage/github-repos/arty-z7/proj/devel-base/devel-base.runs/impl_1/runme.log
# launch_runs impl_1 -to_step write_bitstream -jobs 2
# [Thu Apr 23 15:51:53 2026] Launched impl_1...
# Run output will be captured here: /storage/github-repos/arty-z7/proj/devel-base/devel-base.runs/impl_1/runme.log
# write_hw_platform -fixed -include_bit -force -file /storage/github-repos/arty-z7/proj/devel-base/design_1_wrapper.xsa
# INFO: [Project 1-1918] Creating Hardware Platform: /storage/github-repos/arty-z7/proj/devel-base/design_1_wrapper.xsa ...
# INFO: [Project 1-1943] The Hardware Platform can be used for Hardware
# INFO: [Project 1-1941] Successfully created Hardware Platform: /storage/github-repos/arty-z7/proj/devel-base/design_1_wrapper.xsa
# INFO: [Hsi 55-2053] elapsed time for repository (/tools/Xilinx/Vivado/2024.2/data/embeddedsw) loading 5 seconds
# write_hw_platform: Time (s): cpu = 00:00:03 ; elapsed = 00:00:08 . Memory (MB): peak = 8720.887 ; gain = 122.648 ; free physical = 19005 ; free virtual = 21832

