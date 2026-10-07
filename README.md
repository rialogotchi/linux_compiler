# ATUM Linux — musl + BusyBox + ATUM

This repository builds a small x86_64 QEMU Linux image from source.

Stack:

- Linux kernel
- musl libc
- static BusyBox
- **ATUM as PID 1 and service supervisor**
- Full networking: DHCP, DNS, wget (HTTPS), ping, nc, telnet, ntpd, httpd, ip/ifconfig/route and more
- ext4 + GRUB BIOS image
- QEMU virtio networking and common emulated NIC/storage drivers

ATUM is vendored in `vendor/atum/` from the supplied `atum-main.zip` source tree.

## Build

GitHub → Actions → **Build ATUM Linux (musl + BusyBox + ATUM)** → **Run workflow**.

The workflow produces a raw `.img`, compressed `.img.gz`, kernel, rootfs tarball, checksums and a QEMU smoke-test log.

## Local QEMU

```sh
./run-qemu.sh dist/atum-musl-busybox-atum-x86_64.img
```
