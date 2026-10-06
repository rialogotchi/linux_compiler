% atum(8)

# NAME

atum - a UNIX process no 1

# SYNOPSIS

**atum**

# DESCRIPTION

**atum** must be run as Unix process no 1. It performs the system\'s
booting, running, and shutdown in three stages:

# STAGE 1

**atum** runs */etc/atum/1* and waits for it to terminate. The
system\'s one time tasks are done here. */etc/atum/1* has full control
of */dev/console* to be able to start an emergency shell if the one time
initialization tasks fail. If */etc/atum/1* crashes, or exits 100,
**atum** will skip stage 2 and enter stage 3.

# STAGE 2

**atum** runs */etc/atum/2*, which should not return until system
shutdown; if it crashes, or exits 111, it will be restarted. Normally
*/etc/atum/2* starts **ennead**(8). **atum** is able to handle the
ctrl-alt-del keyboard request in stage 2, see below.

# STAGE 3

If **atum** is told to shutdown the system, or stage 2 returns, it
terminates stage 2 if it is running, and runs */etc/atum/3*. The
systems tasks to shutdown and possibly halt or reboot the system are
done here. If stage 3 returns, **atum** checks if the file
*/etc/atum/reboot* exists and has the execute by owner permission set.
If so, the system is rebooted, it\'s halted otherwise. If
*/etc/atum/nosync* exists, **atum** doesn\'t invoke sync(). This is
useful in vservers.

# CTRL-ALT-DEL

If **atum** receives the ctrl-alt-del keyboard request and the file
*/etc/atum/ctrlaltdel* exists and has the execute by owner permission
set, **atum** runs */etc/atum/ctrlaltdel*, waits for it to terminate,
and then sends itself a CONT signal.

# SIGNALS

**atum** only accepts signals in stage 2.

If **atum** receives a CONT signal and the file */etc/atum/stopit*
exists and has the execute by owner permission set, **atum** is told to
shutdown the system.

If **atum** receives an INT signal, a ctrl-alt-del keyboard request is
triggered.

If **atum** receives a PWR signal and the file */etc/atum/pwrfail*
exists and has the execute by owner permission set, **atum** runs
*/etc/atum/pwrfail*, waits for it to terminate, and then sends itself a
CONT signal. On platforms where PWR is not defined, USR2 is used
instead.

# SEE ALSO

khepri(8), ennead(8), wepwawet(8), heka(8), nehebkau(8), khnum(8),
seshat(8)

index.html

# AUTHOR

Gerrit Pape \<pape@smarden.org\>
