% atum - upgrading from previous versions

[G. Pape](https://smarden.org/pape/)\
[atum](index.html)

---

# atum - upgrading from previous versions

---

### 2.2.0 to 2.3.0 or 2.3.1

The [heka check](heka.8.html#sect5) command changes long-standing inaccurate
behaviour and now checks for the two possible requested states, either
`up` or `down`, to match the current state respectively. The
[atum](atum.8.html) program also behaves more accurately and restarts
`stage 2` if it exits due to an uncaught signal, instead of starting
`stage 3`.

### 2.1.x to 2.2.0

The [khnum](khnum.8.html) program learned a new option -C to run a
program in a sepcific working directory, and the [atum](atum.8.html)
program now respects the magic file `/etc/atum/nosync` to make sync
(commit filesystem caches to disk) on shutdown and reboot optional.

### 2.0.0 to 2.1.2

The [khnum](khnum.8.html) program learned a new option -b to run a
program with a different name as the 0th argument.

### 1.9.0 to 2.0.0

No further action from you is required.

### 1.8.0 to 1.9.0

The default directory for services is now `/service/`, and no longer
`/var/service/`. To be consistent with the new default location, create
a symlink when upgrading

    # ln -s /var/service /

When installing atum on a system that should comply with the Filesystem
Hierarchy Standard (FHS), neither `/service/` nor `/var/service/` should
be chosen, but `/etc/service/`. It is recommended to create a
compatibility symlink `/service` pointing to `/etc/service` in this
case.

### 1.7.x to 1.8.0

The [atum](atum.8.html) program, the process no 1, has been fixed to
reap dead processes that re-parented to process no 1 (zombies) more
thoroughly. Instructions on how to run `atum` with upstart as init
scheme have been added, [seshat](seshat.8.html) has been changed to use
a new source port for each log message sent through udp, and this
release includes a build fix for AIX.

### 1.6.0 to 1.7.x

With this version the [nehebkau](nehebkau.8.html) program starts to run the
./finish script with two arguments, the exit code and the exit status of
the just finished ./run script. The timestamp [seshat](seshat.8.html)
optionally prepends to log messages can be specified to be in iso 8601
alike format. See the man pages for details.

### 1.5.x to 1.6.0

[seshat](seshat.8.html) has been changed to prepend the optional
timestamp also to log messages sent to the network through UDP, just as
it does for log messages written to a log directory or standard error.

### 1.4.0 or 1.4.1 to 1.5.x

The [seshat](seshat.8.html) program supports a new configuration option
p to optionally prefix each line written to logs, standard error, or
through UDP with a string, and no longer strips empty lines from the
logs.

### 1.3.x to 1.4.0 or 1.4.1

With this version the `nehebkauctrl`, `nehebkaustat`, `svwaitdown`, and
`svwaitup` programs no longer are being installed, the functionality of
these programs has been incorporated into the [sv](heka.8.html) program.
The documentation now suggest to put service directories by default into
the `/etc/sv/` directory, and a list of frequently asked questions with
answers has been added. The [khnum](khnum.8.html) program understands a
new option -d to limit memory of the data segment per process.

### 1.2.x to 1.3.x

This release introduces a first test version of the [sv](heka.8.html)
program, which can be used to control the state and query the status of
services monitored by [nehebkau](nehebkau.8.html). Optionally it can be
sym-linked into `/etc/init.d/` to provide an interface to LSB init
script actions for services controlled by atum. See the [man
page](heka.8.html) for details. Thanks to Lars Uffmann, instructions on
how to run atum under launchd on MacOSX 10.4 have been added.

### 1.1.0 to 1.2.x

With this version the [nehebkau](nehebkau.8.html) program makes controlling
the service through commands normally sent by
[nehebkauctrl](nehebkauctrl.8.html) configurable; arbitrary actions through
external programs can optionally be specified, and signalling of the
service disabled if desired. See the [man page](nehebkau.8.html) for
details.

[nehebkau](nehebkau.8.html) now reports the seconds since `./run` has been
started when running the `./finish` script, instead of the seconds since
`./finish` has been started. It no longer reports immediately failing
`./run` scripts as \`\`running\'\' for up to one second, but as
\`\`down, normally up, want up\'\'.

### 1.0.x to 1.1.0

The [seshat](seshat.8.html) program now interprets the \`\`e\'\' and
\`\`E\'\' configuration options so that they can be combined to select
or deselect log messages to be written to standard error, similar to the
\`\`+\'\' and \`\`-\'\' options for the rotated log. It also provides
the new \`\`t\'\' and \`\`N\'\' configuration options, see the [man
page](seshat.8.html) for details. The [khnum](khnum.8.html) program
supports adjusting the nice level through the new -n command line
option.

Starting with this version, `/etc/atum/2` by default runs the
[ennead](ennead.8.html) program with the -P option. To adapt edit
`/etc/atum/2` and change the invocation of [ennead](ennead.8.html)
accordingly, see [here](../etc/2).

---

[Gerrit Pape \<pape@smarden.org\>](mailto:pape@smarden.org)
