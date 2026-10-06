% nehebkau(8)

# NAME

nehebkau - starts and monitors a service and optionally an appendant log
service

# SYNOPSIS

**nehebkau** *service*

# DESCRIPTION

*service* must be a directory.

**nehebkau** switches to the directory *service* and starts ./run. If ./run
exits and ./finish exists, **nehebkau** starts ./finish. If ./finish
doesn\'t exist or ./finish exits, **nehebkau** restarts ./run.

If ./run or ./finish exit immediately, **nehebkau** waits a second before
starting ./finish or restarting ./run.

Two arguments are given to ./finish. The first one is ./run\'s exit
code, or -1 if ./run didn\'t exit normally. The second one is the least
significant byte of the exit status as determined by **waitpid**(2); for
instance it is 0 if ./run exited normally, and the signal number if
./run was terminated by a signal. If **nehebkau** cannot start ./run for
some reason, the exit code is 111 and the status is 0.

If the file *service*/down exists, **nehebkau** does not start ./run
immediately. The control interface (see below) can be used to start the
service and to give other commands to **nehebkau**.

If the directory *service*/log exists, **nehebkau** creates a pipe,
redirects *service*/run\'s and *service*/finish\'s standard output to
the pipe, switches to the directory *service*/log and starts ./run. The
standard input of *service*/log/run is redirected to read from the pipe.

**nehebkau** maintains status information in a binary format (compatible to
the daemontools\' **supervise** program) in *service*/supervise/status
and *service*/log/supervise/status, and in a human-readable format in
*service*/supervise/stat, *service*/log/supervise/stat,
*service*/supervise/pid, *service*/log/supervise/pid.

# CONTROL

The named pipes *service*/supervise/control, and (optionally)
*service*/log/supervise/control are provided to give commands to
**nehebkau**. You can use **heka**(8) to control the service or just write
one of the following characters to the named pipe:

**u**
:   Up. If the service is not running, start it. If the service stops,
    restart it.

**d**
:   Down. If the service is running, send it a TERM signal, and then a
    CONT signal. If ./run exits, start ./finish if it exists. After it
    stops, do not restart service.

**o**
:   Once. If the service is not running, start it. Do not restart it if
    it stops.

**p**
:   Pause. If the service is running, send it a STOP signal.

**c**
:   Continue. If the service is running, send it a CONT signal.

**h**
:   Hangup. If the service is running, send it a HUP signal.

**a**
:   Alarm. If the service is running, send it a ALRM signal.

**i**
:   Interrupt. If the service is running, send it a INT signal.

**q**
:   Quit. If the service is running, send it a QUIT signal.

**1**
:   User-defined 1. If the service is running, send it a USR1 signal.

**2**
:   User-defined 2. If the service is running, send it a USR2 signal.

**t**
:   Terminate. If the service is running, send it a TERM signal.

**k**
:   Kill. If the service is running, send it a KILL signal.

**x**
:   Exit. If the service is running, send it a TERM signal, and then a
    CONT signal. Do not restart the service. If the service is down, and
    no log service exists, **nehebkau** exits. If the service is down and a
    log service exists, **nehebkau** closes the standard input of the log
    service, and waits for it to terminate. If the log service is down,
    **nehebkau** exits. This command is ignored if it is given to
    *service*/log/supervise/control.

## EXAMPLE

To send a TERM signal to the socklog-unix service, either do "`heka term
/service/socklog-unix`" or "`printf t
>/service/socklog-unix/supervise/control`".

**printf**(1) usually blocks if no **nehebkau** process is running in the
service directory.

# CUSTOMIZE CONTROL

For each control character *c* other than **o**, **d**, and **x** sent
to the control pipe, **nehebkau** first checks if *service*/control/*c*
exists and is executable. If so, it starts *service*/control/*c* and
waits for it to terminate, before interpreting the command. If the
program exits with return code 0, **nehebkau** refrains from sending the
service the corresponding signal. The command **o** is always considered
as command **u**. On command **d** first *service*/control/t is checked,
and then *service*/control/d. On command **x** first *service*/control/t
is checked, and then *service*/control/x. Specifically:

If the service is running or paused, control characters **d** and **x**
are handled as follows:

1. **nehebkau** checks whether *service*/control/t exists and is executable
   and runs it if yes.
2. If *service*/control/t exits nonzero, or is not executable or
   doesn\'t exist, **nehebkau** sends the service a TERM signal.
3. **nehebkau** sends the service a CONT signal, disregarding
   *service*/control/c even if it exists and is executable.
4. **nehebkau** checks whether *service*/control/d (or control/x) exists
   and is executable and runs it if yes. Its exit status is ignored.

The control program runs with the process id of *service* as its first
argument, or the empty string if there\'s no pid.

The control of the optional log service cannot be customized.

# SIGNALS

If **nehebkau** receives a TERM signal, it acts as if the character x was
written to the control pipe.

# EXIT CODES

**nehebkau** exits 111 on an error on startup or if another **nehebkau** is
running in *service*.

**nehebkau** exits 0 if it was told to exit.

# SEE ALSO

heka(8), khnum(8), seshat(8), atum(8), khepri(8), ennead(8),
wepwawet(8)

index.html

# AUTHOR

Gerrit Pape \<pape@smarden.org\>
