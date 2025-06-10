QEMU Development
================
To run the kernel in the staging directory under QEMU emulation, run
`./scripts/run_kernel_qemu`. This will run the kernel and attached
serial port in the current console, with the monitor started on
`127.0.0.1` at port 55555. To watch it, perhaps in a split screen, use
`telnet 127.0.0.1 55555`. Also, the kernel `netconsole` is enabled and
set to log `dmesg` output to the IP address of the development machine.
This can be observed with something like `socat UDP-LISTEN:6667,fork -`
or logged to a file as well with
```bash
socat UDP-LISTEN:6667,fork - | tee console.log
```

