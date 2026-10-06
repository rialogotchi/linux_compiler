% atum - installation

[G. Pape](https://smarden.org/pape/)\
[atum](index.html)

---

# atum - installation

---

*atum* by default installs into the [/package
hierarchy](https://cr.yp.to/slashpackage.html). To install as non-root
user and without the [/package](https://cr.yp.to/slashpackage.html)
directory, make the programs and documentation available manually.

---

[Install into /package](#package)\
[Install programs and documentation manually](#manually)

---

[]{#package}

## Install atum into /package

If you don\'t have a `/package` directory, create it now:

    mkdir -p /package
    chmod 1755 /package

Download [atum-2.3.1.tar.gz](atum-2.3.1.tar.gz) into `/package`
([sha256sum](sha256sum.asc)) and unpack the
archive

    cd /package
    gunzip atum-2.3.1.tar
    tar -xpf atum-2.3.1.tar
    rm atum-2.3.1.tar
    cd admin/atum-2.3.1

On \*BSD, if `gcc` is not available on the system, use `cc` instead:

    echo 'cc -O2 -Wall' >src/conf-cc
    echo 'cc -s' >src/conf-ld

On MacOSX, do

    echo 'cc -Xlinker -x' >src/conf-ld
    cp src/Makefile src/Makefile.old
    sed -e 's/ -static//' <src/Makefile.old >src/Makefile

Now compile and install the *atum* programs

    package/install

If you want to make the man pages available in the `/usr/local/man/`
hierarchy, do:

    package/install-man

To report success:

    mail maintainer@example.org <compile/sysdeps

If you use *atum* regularly, please
[contribute](https://smarden.org/pape/#contribution) to the project.

Refer to [replacing init](replaceinit.html) for replacing *init* with
*atum*, or to [use with traditional init](useinit.html) for running
*atum*\'s service supervision with your system\'s current *init*
scheme.

---

[]{#manually}

## Install atum programs and documentation manually

Download [atum-2.3.1.tar.gz](atum-2.3.1.tar.gz) into the current
directory ([sha256sum](sha256sum.asc)) and
unpack the archive

    gunzip atum-2.3.1.tar
    tar -xpf atum-2.3.1.tar
    cd admin/atum-2.3.1

Run `pwd` and note the working directory. When following the
documentation onwards, you need to replace `/package/admin/atum`
accordingly.

On \*BSD, if `gcc` is not available on the system, use `cc` instead:

    echo 'cc -O2 -Wall' >src/conf-cc
    echo 'cc -s' >src/conf-ld

On MacOSX, do

    echo 'cc -Xlinker -x' >src/conf-ld
    cp src/Makefile src/Makefile.old
    sed -e 's/ -static//' <src/Makefile.old >src/Makefile

Compile and check the *atum* programs

    package/compile
    package/check

The *atum* programs are available in the `command/` directory. You
probably want to install the `command/atum*` programs into `/sbin`, and
the other programs from `command/` into `/bin`. As non-root user you
probably want to install them into `$HOME/bin`.

The documentation is available in the `doc/` directory, and the man
pages in the `man/` directory.

To report success:

    mail maintainer@example.org <compile/sysdeps

If you use *atum* regularly, please
[contribute](https://smarden.org/pape/#contribution) to the project.

Refer to [replacing init](replaceinit.html) for replacing *init* with
*atum*, or to [use with traditional init](useinit.html) for running
*atum*\'s service supervision with your system\'s current *init*
scheme.

---

[Gerrit Pape \<pape@smarden.org\>](mailto:pape@smarden.org)
