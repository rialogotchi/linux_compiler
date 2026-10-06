#!/bin/sh
# Alpine (musl + busybox) konteyneri icinde calisir. Cikti: /work/out/rootfs
set -eu

: "${ALPINE_VERSION:=3.22}" "${HOSTNAME_:=atum}" "${FIRMWARE:=common}" "${WIFI:=true}"
: "${AUTOLOGIN:=true}" "${ROOT_PASSWORD:=}" "${EXTRA_PACKAGES:=}"

OUT=/work/out
ROOT=$OUT/rootfs
rm -rf "$OUT"; mkdir -p "$ROOT"

if [ "$AUTOLOGIN" != "true" ] && [ -z "$ROOT_PASSWORD" ]; then
  echo "autologin=false iken root_password bos olamaz" >&2; exit 1
fi

echo "=== [1/7] derleme araclari"
apk add --no-cache build-base linux-headers kmod mkinitfs

echo "=== [2/7] atum derleniyor (musl, statik)"
rm -rf /tmp/atum && mkdir /tmp/atum
cp -a /work/package /work/src /tmp/atum/
# zip/git yuzunden kaybolan calistirma izinlerini geri ver
chmod +x /tmp/atum/package/* 2>/dev/null || true
for f in /tmp/atum/src/*; do
  case $f in *.c|*.h|*.h1|*.h2|*.dist|*.o|*.a|*.lib|Makefile|TARGETS|conf-*) ;; *) chmod +x "$f" ;; esac
done
( cd /tmp/atum && sh package/compile && sh package/check )
for b in $(cat /tmp/atum/package/commands); do
  [ -x "/tmp/atum/command/$b" ] || { echo "eksik ikili: $b" >&2; exit 1; }
done

echo "=== [3/7] rootfs paketleri (Alpine $ALPINE_VERSION)"
REPO=https://dl-cdn.alpinelinux.org/alpine/v$ALPINE_VERSION
mkdir -p "$ROOT/etc/apk" "$ROOT/dev" "$ROOT/proc" "$ROOT/sys"
cp -a /etc/apk/keys "$ROOT/etc/apk/keys"
printf '%s\n' "$REPO/main" "$REPO/community" > "$ROOT/etc/apk/repositories"
mknod -m 666 "$ROOT/dev/null" c 1 3 2>/dev/null || true
APK="apk --root $ROOT --keys-dir /etc/apk/keys --no-cache"

PKGS="alpine-baselayout alpine-keys apk-tools busybox busybox-binsh musl musl-utils
      ca-certificates-bundle ssl_client curl kmod eudev e2fsprogs tzdata"
[ "$WIFI" = "true" ] && PKGS="$PKGS wpa_supplicant wireless-regdb iw"
# shellcheck disable=SC2086
$APK --initdb add $PKGS $EXTRA_PACKAGES

echo "=== [4/7] kernel + firmware"
$APK add --no-scripts linux-lts
KVER=$(ls "$ROOT/lib/modules" | head -n1)
echo "kernel: $KVER"

try_fw() {
  for p in "$@"; do
    if apk --root "$ROOT" --keys-dir /etc/apk/keys --no-cache search -e "$p" | grep -q .; then
      $APK add --no-scripts "$p" || echo "uyari: $p kurulamadi"
    else
      echo "bilgi: $p bu surumde yok, atlandi"
    fi
  done
}
case "$FIRMWARE" in
  none)   ;;
  common) try_fw linux-firmware-rtl_nic linux-firmware-intel linux-firmware-iwlwifi \
                 linux-firmware-rtlwifi linux-firmware-rtw88 linux-firmware-rtw89 \
                 linux-firmware-ath9k_htc linux-firmware-ath10k linux-firmware-ath11k \
                 linux-firmware-mediatek linux-firmware-brcm linux-firmware-bnx2 \
                 linux-firmware-bnx2x linux-firmware-tigon linux-firmware-other ;;
  all)    try_fw linux-firmware ;;
  *) echo "gecersiz firmware: $FIRMWARE" >&2; exit 1 ;;
esac

echo "=== [5/7] atum kurulumu ve yapilandirma"
[ -e "$ROOT/bin/sh" ] || chroot "$ROOT" /bin/busybox --install -s
install -m 0755 /tmp/atum/command/* "$ROOT/sbin/"
ln -sfn sbin "$ROOT/command"
ln -sf khepri "$ROOT/sbin/init"
# reboot/poweroff/halt -> khepri (busybox'in sinyalleri atum ile uyumlu degil)
for c in reboot:6 poweroff:0 halt:0; do
  n=${c%%:*}; a=${c##*:}
  rm -f "$ROOT/sbin/$n" "$ROOT/bin/$n" "$ROOT/usr/sbin/$n"
  printf '#!/bin/sh\nexec /sbin/khepri %s\n' "$a" > "$ROOT/sbin/$n"
  chmod 755 "$ROOT/sbin/$n"
done
# modul araclari kmod olsun (.ko.gz/.zst destegi)
[ -e "$ROOT/bin/kmod" ] || { echo "kmod yok" >&2; exit 1; }
for t in modprobe depmod insmod lsmod rmmod modinfo; do
  rm -f "$ROOT/sbin/$t" "$ROOT/bin/$t"; ln -s /bin/kmod "$ROOT/sbin/$t"
done

cp -a /work/image/overlay/. "$ROOT/"
chmod 755 "$ROOT"/etc/atum/1 "$ROOT"/etc/atum/2 "$ROOT"/etc/atum/3 "$ROOT"/etc/atum/ctrlaltdel \
  "$ROOT"/usr/libexec/atum-* "$ROOT"/usr/share/udhcpc/atum.script "$ROOT"/usr/sbin/wifi-connect
echo "$HOSTNAME_" > "$ROOT/etc/hostname"
printf '127.0.0.1\tlocalhost %s\n::1\t\tlocalhost\n' "$HOSTNAME_" > "$ROOT/etc/hosts"
mkdir -p "$ROOT/service" "$ROOT/etc/atum" "$ROOT/run" "$ROOT/tmp" "$ROOT/var/log" "$ROOT/root" "$ROOT/boot"
chmod 1777 "$ROOT/tmp"

# getty servisleri
mk_getty() { # ad  tty  extra-args
  mkdir -p "$ROOT/etc/sv/getty-$1"
  if [ "$AUTOLOGIN" = "true" ]; then L="-n -l /usr/libexec/atum-autologin"; else L=""; fi
  case $1 in
    ttyS0) printf '#!/bin/sh\nexec 2>&1\nstty -F /dev/ttyS0 >/dev/null 2>&1 || exec sleep 3600\nexec getty %s -L 115200 ttyS0 vt100\n' "$L" ;;
    *)     printf '#!/bin/sh\nexec 2>&1\nexec getty %s 38400 %s linux\n' "$L" "$1" ;;
  esac > "$ROOT/etc/sv/getty-$1/run"
  chmod 755 "$ROOT/etc/sv/getty-$1/run"
}
mk_getty tty1; mk_getty tty2; mk_getty ttyS0

for s in "$ROOT"/etc/sv/*; do
  chmod 755 "$s/run"
  ln -sfn "/etc/sv/$(basename "$s")" "$ROOT/service/$(basename "$s")"
done

if [ -n "$ROOT_PASSWORD" ]; then
  PW="$ROOT_PASSWORD" chroot "$ROOT" /bin/sh -c 'echo "root:$PW" | chpasswd -c sha512'
fi

echo "=== [6/7] depmod + initramfs (disk imaji icin)"
depmod -b "$ROOT" "$KVER"
# ISO'da gereksiz olan buyuk modul gruplari (ses/medya/infiniband)
rm -rf "$ROOT/lib/modules/$KVER/kernel/sound" "$ROOT/lib/modules/$KVER/kernel/drivers/media" \
       "$ROOT/lib/modules/$KVER/kernel/drivers/infiniband"
depmod -b "$ROOT" "$KVER"

feats=""
for f in base ata ide scsi usb virtio ext4 nvme mmc cdrom; do
  if [ -e "$ROOT/etc/mkinitfs/features.d/$f.modules" ] || [ -e "$ROOT/etc/mkinitfs/features.d/$f.files" ]; then
    feats="$feats $f"
  fi
done
mkdir -p "$ROOT/etc/mkinitfs"
echo "features=\"${feats# }\"" > "$ROOT/etc/mkinitfs/mkinitfs.conf"
ls "$ROOT"/boot/
KIMG=$(ls "$ROOT"/boot/vmlinuz-* | head -n1)
ln -sf "$(basename "$KIMG")" "$ROOT/boot/vmlinuz-lts" 2>/dev/null || true
mknod -m 600 "$ROOT/dev/console" c 5 1 2>/dev/null || true
if ! mkinitfs -b "$ROOT" -c "$ROOT/etc/mkinitfs/mkinitfs.conf" -o "$ROOT/boot/initramfs-lts" "$KVER"; then
  echo "mkinitfs -b basarisiz, chroot ile deneniyor"
  chroot "$ROOT" /sbin/mkinitfs -o /boot/initramfs-lts "$KVER"
fi
[ -s "$ROOT/boot/initramfs-lts" ] || { echo "initramfs olusmadi" >&2; exit 1; }

echo "=== [7/7] temizlik"
rm -rf "$ROOT"/usr/share/man "$ROOT"/usr/share/doc "$ROOT"/usr/share/info "$ROOT"/var/cache/apk/*
echo "$KVER" > "$OUT/kver"
du -sh "$ROOT"
echo "rootfs hazir"
