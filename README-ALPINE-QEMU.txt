Alpine 3.20.3 (virt) + atum init - saf QEMU

1) Bu klasoru (.github/workflows/alpine-atum.yml) atum kaynak reposunun kokune koyun
   (package/ ve src/ klasorlerinin yaninda).
2) GitHub -> Actions -> "Alpine 3.20 + atum (QEMU image)" -> Run workflow.
3) Cikan artifact: alpine-atum-qemu.zip (vmlinuz-virt, initramfs-atum.gz, run.sh, run.bat)
4) Calistirma:  ./run.sh   (cikis: Ctrl-A, X)   -  RAM: MEM=1024 ./run.sh
