% khepri(8)

# NAME

init - a UNIX process no 1

# SYNOPSIS

**init** \[ 0 \| 6 \]

# DESCRIPTION

**khepri** is the first process the kernel starts. If **khepri**
is started as process no 1, it runs and replaces itself with
**atum**(8).

If **khepri** is started while the system is up, it must be either
called as **init 0** or **init 6**:

**init 0**
:   tells the Unix process no 1 to shutdown and halt the system. To
    signal **atum**(8) the system halt request, **khepri** removes
    all permissions of the file */etc/atum/reboot* (chmod 0), and sets
    the execute by owner permission of the file */etc/atum/stopit*
    (chmod 100). Then a CONT signal is sent to **atum**(8).

**init 6**
:   tells the Unix process no 1 to shutdown and reboot the system. To
    signal **atum**(8) the system reboot request, **khepri** sets
    the execute by owner permission of the files */etc/atum/reboot* and
    */etc/atum/stopit* (chmod 100). Then a CONT signal is sent to
    **atum**(8).

# EXIT CODES

**khepri** returns 111 on error, 0 in all other cases.

# SEE ALSO

atum(8), ennead(8), wepwawet(8), heka(8), nehebkau(8), khnum(8),
seshat(8)

index.html

# AUTHOR

Gerrit Pape \<pape@smarden.org\>
