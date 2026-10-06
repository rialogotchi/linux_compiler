#!/bin/bash
# Ubuntu runner uzerinde root olarak calisir. Girdi: out/rootfs  Cikti: out/atum.iso, out/atum-disk.img
set -euo pipefail
: "${IMAGE_SIZE_MB:=2048}"
OUT=$(pwd)/out
ROOT=$OUT/rootfs
CMDLINE="rw console=ttyS0,115200 console=tty0 net.ifnames=0"
[ -d "$ROOT/boot" ] || { echo "rootfs yok" >&2; exit 1; }
KERNEL=$ROOT/boot/vmlinuz-lts
[ -e "$KERNEL" ] || { echo "kernel yok: $KERNEL" >&2; exit 1; }

GRUB_COMMON='set timeout=3
serial --unit=0 --speed=115200
terminal_input console serial
terminal_output console serial'

############ ISO (canli, RAM'den; kok dosya sistemi initramfs) ############
echo "=== ISO"
ISO=$OUT/iso
rm -rf "$ISO"; mkdir -p "$ISO/boot/grub"
cp -L "$KERNEL" "$ISO/boot/vmlinuz"
( cd "$ROOT" && find . -path ./boot -prune -o -print0 | cpio --null -o -H newc -R 0:0 --quiet ) | gzip -6 > "$ISO/boot/initramfs.gz"
cat > "$ISO/boot/grub/grub.cfg" <<EOT
$GRUB_COMMON
menuentry "atum (canli, RAM)" {
  linux /boot/vmlinuz rdinit=/sbin/init $CMDLINE
  initrd /boot/initramfs.gz
}
menuentry "atum (canli, nomodeset)" {
  linux /boot/vmlinuz rdinit=/sbin/init nomodeset $CMDLINE
  initrd /boot/initramfs.gz
}
EOT
grub-mkrescue -o "$OUT/atum.iso" "$ISO" -- -volid ATUM >/dev/null
ls -lh "$OUT/atum.iso"

############ Disk imaji (GPT, BIOS + UEFI, ext4) ############
echo "=== DISK IMG"
IMG=$OUT/atum-disk.img
rm -f "$IMG"; truncate -s "${IMAGE_SIZE_MB}M" "$IMG"
sgdisk --zap-all "$IMG" >/dev/null
sgdisk -n 1:2048:+1M -t 1:ef02 -c 1:bios \
       -n 2:0:+128M  -t 2:ef00 -c 2:ESP \
       -n 3:0:0      -t 3:8300 -c 3:ATUMROOT "$IMG" >/dev/null

MNT=$OUT/mnt; LOOP=""
cleanup() {
  set +e
  mountpoint -q "$MNT/esp" && umount "$MNT/esp"
  mountpoint -q "$MNT/root" && umount "$MNT/root"
  [ -n "$LOOP" ] && losetup -d "$LOOP"
}
trap cleanup EXIT
mkdir -p "$MNT/root" "$MNT/esp"
LOOP=$(losetup --find --show --partscan "$IMG")
for _ in $(seq 1 20); do [ -b "${LOOP}p3" ] && break; partprobe "$LOOP" 2>/dev/null || true; sleep 0.5; done
[ -b "${LOOP}p3" ] || { echo "bolum aygitlari olusmadi" >&2; exit 1; }

ROOT_UUID=$(cat /proc/sys/kernel/random/uuid)
mkfs.vfat -F32 -n ATUMEFI "${LOOP}p2" >/dev/null
mkfs.ext4 -q -F -L ATUMROOT -U "$ROOT_UUID" -O ^orphan_file "${LOOP}p3"
mount "${LOOP}p3" "$MNT/root"
mount "${LOOP}p2" "$MNT/esp"
tar -C "$ROOT" -cf - . | tar -C "$MNT/root" -xpf -
mkdir -p "$MNT/root/boot/grub"
cat > "$MNT/root/boot/grub/grub.cfg" <<EOT
$GRUB_COMMON
insmod part_gpt
insmod ext2
search --no-floppy --fs-uuid --set=root $ROOT_UUID
menuentry "atum" {
  linux /boot/vmlinuz-lts root=UUID=$ROOT_UUID rootfstype=ext4 $CMDLINE
  initrd /boot/initramfs-lts
}
menuentry "atum (nomodeset)" {
  linux /boot/vmlinuz-lts root=UUID=$ROOT_UUID rootfstype=ext4 nomodeset $CMDLINE
  initrd /boot/initramfs-lts
}
EOT
grub-install --target=i386-pc --recheck --boot-directory="$MNT/root/boot" \
  --modules="part_gpt ext2" "$LOOP"
grub-install --target=x86_64-efi --recheck --removable --no-nvram --no-uefi-secure-boot \
  --efi-directory="$MNT/esp" --boot-directory="$MNT/root/boot" --modules="part_gpt ext2"
sync
cleanup; trap - EXIT; LOOP=""
ls -lh "$IMG"
echo "bitti"
