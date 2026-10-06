Alpine 3.20.3 (virt) + atum init (OpenRC yok) - QEMU disk imaji

1) Bu repoyu GitHub'a push edin (atum kaynagi + .github/workflows/alpine-atum-img.yml).
2) Actions -> "Alpine 3.20 + atum (QEMU disk image, no OpenRC)" -> Run workflow
3) Artifact: alpine-atum-qemu.zip  (alpine-atum.img, run.sh, run.bat)
4) ./run.sh   (cikis: Ctrl-A, X)   RAM: MEM=1024 ./run.sh   Kaydetmeden: SNAP=-snapshot ./run.sh
   Giris: root (parola yok)
