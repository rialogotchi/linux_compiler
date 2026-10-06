#!/bin/sh
set -eu
IMG=${1:-dist/atum-musl-busybox-atum-opkg-x86_64.img}
exec qemu-system-x86_64 \
  -machine pc \
  -m 512M \
  -nographic \
  -serial mon:stdio \
  -drive file="$IMG",format=raw,if=virtio \
  -netdev user,id=n0 \
  -device virtio-net-pci,netdev=n0
