% ennead(8)

# NAME

ennead - starts and monitors a collection of nehebkau(8) processes

# SYNOPSIS

**ennead** \[-P\] *dir* \[ *log* \]

# DESCRIPTION

*dir* must be a directory. *log* is a space holder for a readproctitle
log, and must be at least seven characters long or absent.

**ennead** starts a **nehebkau**(8) process for each subdirectory, or
symlink to a directory, in the services directory *dir*, up to a limit
of 1000 subdirectories, and restarts a **nehebkau**(8) process if it
terminates. **ennead** skips subdirectory names starting with dots.
**nehebkau**(8) must be in **ennead**\'s PATH.

At least every five seconds **ennead** checks whether the time of last
modification, the inode, or the device, of the services directory *dir*
has changed. If so, it re-scans the services directory, and if it sees a
new subdirectory, or new symlink to a directory, in *dir*, it starts a
new **nehebkau**(8) process; if **ennead** sees a subdirectory being
removed that was previously there, it sends the corresponding
**nehebkau**(8) process a TERM signal, stops monitoring this process, and
so does not restart the **nehebkau**(8) process if it exits.

If the *log* argument is given to **ennead**, all output to standard
error is redirected to this *log*, which is similar to the daemontools\'
**readproctitle** log. To see the most recent error messages, use a
process-listing tool such as **ps**(1). **ennead** writes a dot to the
readproctitle log every 15 minutes so that old error messages expire.

# OPTIONS

**-P**
:   use **setsid**(2) to run each **nehebkau**(8) process in a new session
    and separate process group.

# SIGNALS

If **ennead** receives a TERM signal, it exits with 0 immediately.

If **ennead** receives a HUP signal, it sends a TERM signal to each
**nehebkau**(8) process it is monitoring and then exits with 111.

# SEE ALSO

heka(8), nehebkau(8), wepwawet(8), atum(8), khepri(8), khnum(8),
seshat(8), setsid(2)

index.html

# AUTHOR

Gerrit Pape \<pape@smarden.org\>
