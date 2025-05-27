# Tool versions and tags all need to be consistent (this is unlikely to be
# rock-solid and Xilinx naming conventions are often broken)
XILINX_VERSION	?= 2024.2
# Github URLS and tags to build from
DTG_SRC_URL	?= https://github.com/Xilinx/device-tree-xlnx.git
# Note the underscore here in the tag name!!
DTG_SRC_TAG	?= xilinx_v$(XILINX_VERSION)

UBOOT_SRC_URL	?= https://github.com/Xilinx/u-boot-xlnx.git
UBOOT_SRC_TAG	?= xilinx-v$(XILINX_VERSION)

KERNEL_SRC_URL	?= https://github.com/Xilinx/linux-xlnx.git
KERNEL_SRC_TAG	?= xilinx-v$(XILINX_VERSION)

