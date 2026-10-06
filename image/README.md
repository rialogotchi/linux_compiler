# atum ISO + IMG (musl + busybox, SSH yok)

GitHub'da: **Actions → build-atum-image → Run workflow**. Bitince **Artifacts → atum-images**:

| Dosya | Ne |
|---|---|
| `atum.iso` | Canlı sistem (BIOS + UEFI hibrit), tamamen RAM'de çalışır, ≥1 GB RAM önerilir |
| `atum-disk.img.xz` | Kalıcı disk imajı (GPT, BIOS+UEFI GRUB, ext4). `xz -d` sonra `dd`/Etcher/Rufus ile yazın |
| `*.log`, `SHA256SUMS` | QEMU test kayıtları, sağlama toplamları |

## İçerik
- **musl + busybox**: Alpine paketlerinden (`alpine:<sürüm>` konteyneri), kernel `linux-lts`
- **init**: bu depodaki `atum` (musl ile statik derlenir); `/sbin/init → khepri → atum`
- Aşamalar: `image/overlay/etc/atum/{1,2,3}`; servisler `/etc/sv/*`, `/service/*` bağlantıları
- **İnternet**: eudev donanım algılama → her fiziksel ağ kartı için otomatik `udhcpc` servisi (DHCP + DNS),
  wifi için `wifi-connect SSID PAROLA`, NTP (`ntpd`), CA sertifikaları, `curl`, `wget` (HTTPS), `apk` (paket kurma)
- Açılışta konsola `atum-netcheck: ... ATUM-NET-OK` yazar (DHCP, ping, DNS, NTP, HTTPS testi)
- **SSH/uzak erişim servisi yok**; tty1, tty2 ve seri konsol (ttyS0, 115200) üzerinde getty

## Workflow girdileri
`alpine_version`, `image_size_mb`, `hostname`, `firmware` (common/none/all), `wifi`, `autologin`,
`root_password`, `extra_packages`, `smoke_test`. (`root_password` Actions arayüzünde görünür; gizli değildir.)

## Notlar
- İlk kez çalıştırıyorsanız `smoke_test` açık kalsın; hata olursa log artifact'ta olur.
- Disk imajında root bölümü imaj boyutu kadardır; daha büyük diske yazarsanız `resize2fs` ile büyütün (bölümü önce `parted` ile uzatın).
- Yönetim: `heka status /service/*`, `heka restart /service/net-eth0`, `reboot`, `poweroff`.
