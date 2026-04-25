# Arty Z7-20 Development Roadmap

## Overview

Development platform for the Digilent Arty Z7-20 (XC7Z020 SoC).  Long-term
engineering platform.  Near-term goals: mainline u-boot and Linux kernel support
for the board.  Subsequent: verified custom UART IP with Linux driver.

Reference board for porting: Zybo Z7-20 (same XC7Z020 die, already has mainline
support in both u-boot and kernel).

---

## Stage 1 - Vivado Base Project

Goal: automated Tcl script to generate a minimal Arty Z7-20 block design
suitable for deriving a DTS.

- [x] Write Tcl script to create block design with PS7 instance
- [x] Integrate existing PS7 configuration presets
- [x] Validate block design generates a clean XSA export
- [x] Commit script to repo under scripts/

Notes:
- Block design is required (PS7 configuration presets live there)
- Minimal hardware only - just enough for u-boot and kernel DTS development
- XSA output feeds the FSBL build in Stage 2
- Full flow: project creation -> block design -> PS7 + preset -> synthesis ->
  implementation -> bitstream -> XSA export
- Build orchestrated by Makefile; Vivado invoked in batch mode with tclargs
  passing project dir, XSA output path, and preset Tcl path
- All generated artifacts (Vivado project, XSA) land in build/, gitignored
- XSA is not revision controlled

Status: COMPLETE

---

## Stage 2 - FSBL

Goal: automated FSBL build from Xilinx embeddedsw source with a hand-written
linker script.

- [x] Check out FSBL source from embeddedsw (github.com/Xilinx/embeddedsw)
- [x] Write custom linker script for OCM placement (256KB, pre-DDR init)
- [x] Learn ELF structure and linker script mechanics (deliberate diversion)
- [x] Automate build, output FSBL ELF
- [x] Commit build scripts and linker script to repo

Notes:
- Linker script is new territory - the point is to understand it, not steal
  one from Vitis
- FSBL runs from OCM before DDR is trained; placement constraints are the
  key constraint driving the linker script
- embeddedsw path preferred over Vitis-generated source for cleaner version
  control

Status: COMPLETE

---

## Stage 3 - U-Boot

Goal: build u-boot for Arty Z7-20 and develop a working DTS.

- [x] Build u-boot using Zybo Z7-20 as reference starting point
- [x] Develop Arty Z7-20 DTS (UART, clock, memory, Ethernet, QSPI, MMC, USB)
- [x] Validate boot flow under QEMU
- [x] Iterate DTS until u-boot boots cleanly
- [ ] Add ps7_init_gpl.c to board/xilinx/zynq/ and stage from XSA

Notes:
- Use QEMU as primary development target until hardware bring-up stage
- Zybo Z7-20 DTS: arch/arm/dts/zynq-zybo-z7.dts - use as template for Arty DTS
- DTS filename: zynq-arty-z7.dts
- ps-clk-frequency: Arty uses 125MHz, Zybo Z7 uses 33MHz
- DDR size: Arty Z7 has 512MB (0x20000000), Zybo Z7 has 1GB (0x40000000)
- No Kconfig entry needed - Arty hangs off existing CONFIG_ARCH_ZYNQ block
- xilinx_zynq_virt_defconfig is the base - no separate Arty defconfig needed
- ps7_init_gpl.c goes in board/xilinx/zynq/ - extract from XSA in vivado.mk staging step
- Patch series: zynq-arty-z7.dts, arch/arm/dts/Makefile entry, ps7_init_gpl.c
- u-boot cloned from Denx at v2026.04 tag, branched to arty-z7-dts in extern/u-boot/
- Build system: uboot.mk wired up, builds ELF + DTB separately (OF_SEPARATE=y)
- Upstream bugs found: zynq-zybo-z7.dts PHY reg may be wrong (addr 0 vs 1), zynq-dlc20 dr_mode "device" should be "peripheral"

Status: IN PROGRESS

---

## Stage 4 - Linux Kernel

Goal: build Linux kernel for Arty Z7-20 and develop a working DTS.

- [ ] Build kernel using Zybo Z7-20 as reference starting point
- [ ] Develop Arty Z7-20 DTS (arch/arm/dts/zynq-arty-z7-20.dts)
- [ ] Validate boot under QEMU with u-boot from Stage 3
- [ ] Iterate DTS until kernel boots cleanly

Notes:
- QEMU development target, same as Stage 3
- Zybo Z7-20 kernel DTS: arch/arm/dts/zynq-zybo-z7.dts

Status: NOT STARTED

---

## Stage 5 - Mainline Patch Submissions

Goal: submit Arty Z7-20 support to mainline u-boot and Linux kernel.

- [ ] Prepare u-boot patch series (board files + DTS)
- [ ] Prepare kernel patch series (DTS + defconfig entry)
- [ ] Submit to respective mailing lists per project contribution guidelines
- [ ] Respond to review cycles

Notes:
- This runs in parallel with Stages 6-8 since upstreaming takes time
- u-boot patches go to the u-boot mailing list; kernel patches to
  linux-arm-kernel and devicetree mailing lists

Status: NOT STARTED

---

## Stage 6 - Verification Suite

Goal: build a lightweight hardware verification framework for the custom UART.

- [ ] Define scope and architecture (simpler than UVM, fit for purpose)
- [ ] Implement framework
- [ ] Validate framework is ready to receive UART under test

Notes:
- Separate project work feeds into this stage (framework partially exists
  elsewhere)
- Runs concurrently with patch submission process (Stage 5)

Status: NOT STARTED

---

## Stage 7 - Custom UART IP

Goal: integrate and verify the hardware UART.

- [ ] Integrate UART RTL into Vivado project (RTL exists in separate project)
- [ ] Run verification suite against UART
- [ ] Iterate until verification passes

Notes:
- RTL and verification suite are developed in separate projects first
- This stage integrates them against the Arty Z7-20 platform

Status: NOT STARTED

---

## Stage 8 - UART Driver and DTS

Goal: Linux driver and device tree entry for the custom UART, validated under
QEMU and hardware.

- [ ] Write device tree entry for the custom UART
- [ ] Write Linux driver
- [ ] Validate under QEMU
- [ ] Validate on hardware

Status: NOT STARTED

---

## Final Deliverables

- Mainline u-boot support for Arty Z7-20
- Mainline Linux kernel support for Arty Z7-20
- Fully verified custom UART IP
- UART Linux driver and DTS, validated under QEMU and on hardware

---

## Current Focus

Stage 3 - U-Boot