# Building the Project

## Linux Kernel

The Xilinx fork of the Linux kernel is fetched automatically as a
prerequisite of the kernel Makefile. The Git URL and tag are defined in
the Makefile and can be overridden via variables. By default, only the
specified tag is cloned (shallow clone) to minimize download size.

Two utility targets support refreshing or removing the kernel source:
- `kernel-refresh`: Fully resets the kernel source to a clean state and re-checks out the configured tag.
- `kernel-distclean`: Deletes the entire kernel source tree.

### Configuration

Three targets support kernel configuration:

- `kernel-defconfig`: Generates the vendor’s default config for the selected architecture. Usually boots, but lacks necessary options for development.
- `kernel-config`: Copies a custom config from `config/` in the project root. The file can be overridden by setting `KERNEL_CONFIG=...`.
- `kernel-menuconfig`: Opens `menuconfig` based on the active `.config`. If no `.config` exists, it uses `KERNEL_DEFCONFIG` as a fallback.

### Build and Installation

Once configured, the kernel and modules can be built using:

- `kernel-build`: 
  - Captures `KERNEL_RELEASE` from the build system (`make kernelrelease`)
  - Computes a hash of the `.config` to detect future changes
  - Builds the kernel image, modules, and DTBs

- `kernel-install`: 
  - Installs the kernel image and DTB into `$(STAGING_DIR)/boot`
  - Installs modules and headers into `$(STAGING_DIR)/lib/modules/$(KERNEL_RELEASE_STR)`
  - Rewrites the `build` symlink to point to installed headers instead of the source tree (ensures correctness in deployed rootfs)
  - Generates `compile_commands.json` using `scripts/clang-tools/gen_compile_commands.py` from the kernel source repo. This enables LSP (e.g., `clangd`) to support navigation in the kernel source tree.

Subsequent kernel builds will regenerate `compile_commands.json` automatically.

## The Initramfs

### Emulation

An `initramfs` is used to boot the QEMU system. It includes a statically linked `busybox` binary, supporting symlinks, and a minimal `init` system that:

- Mounts virtual filesystems
- Brings up the network interface
- Obtains an IP address via DHCP
- Mounts an NFS share
- Starts the kernel’s `netconsole` service

The `initramfs/` directory acts as a staging area where `busybox`,
kernel modules, and configuration files are installed before packaging.
This directory can be modified manually and a new `initramfs.cpio.gz`
created using the `initramfs-refresh` utility target. Note that changes
to `busybox` are not automatically included in a refresh. To incorporate
them:

1. Run `make initramfs` once to install a new `busybox`
2. Apply any manual edits to `initramfs/`
3. Run `make initramfs-refresh` to regenerate `initramfs.cpio.gz`

The details of the NFS share and other configuration files may also require manual adjustment for other development environments.

### Hardware

It is expected that an `initramfs` will be developed later for use on
the actual hardware.

## Device Tree
There are two device tree top level source files - it's important to not
over-abstract here like Xilinx does. If I can't read the device tree
source in 30 seconds and have a clue what is on the board, it's too
complicated

# Development

## Emulated Development (QEMU)

To run the kernel and initramfs under QEMU, use the provided script:
```bash
./scripts/run_kernel_qemu
```

This launches the kernel with the serial console attached to the
terminal and the QEMU monitor accessible on `localhost` via `telnet`:
```bash
# Access the QEMU monitor application
telnet 127.0.0.1 55555
```

Kernel messages are broadcast using `netconsole` to UDP port 6667. To view them:
```bash
# To see the kernel dmesg output
socat UDP-LISTEN:6667,fork -

# or, to optionally log to a text file
socat UDP-LISTEN:6667,fork - | tee console.log
```

## Hardware Development (Arty Z7-20)
*TODO:* This sections will describe board bring-up, FSBL and U-Boto integration, kernel deployment, etc.

