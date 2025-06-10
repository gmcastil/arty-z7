QEMU Development
================
To run the kernel in the staging directory under QEMU emulation, run
`./scripts/run_kernel_qemu`. This will run the kernel and attached
serial port in the current console, with the monitor running on
`localhost`.
```bash
# To use the QEMU monitor application
telnet 127.0.0.1 55555

# To see the kernel dmesg output
socat UDP-LISTEN:6667,fork -

# or, to optionally log to a text file
socat UDP-LISTEN:6667,fork - | tee console.log
```

