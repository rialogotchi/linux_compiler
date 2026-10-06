% atum - frequently asked questions

[G. Pape](https://smarden.org/pape/)\
[atum](index.html)

---

# atum - frequently asked questions

---

[What\'s atum, why is it that different](#what)\
[I need some help with atum, what should I do](#help)\
[What\'s the license, is atum free software](#license)

[How do I run a service under atum service supervision](#run)\
[How do I create a new service directory](#create)\
[How do I create a new service directory with an appendant log
service](#createlog)\
[How do I tell atum about a new service](#tell)\
[How do I start, stop, or restart a service](#control)\
[How can I send signals to a service daemon](#signal)\
[How can I query the status of a service](#status)\
[How do I remove a service](#remove)

[How do I make a service depend on another service](#depends)

[What about runlevels](#runlevels)\
[What about LSB init scripts compliance](#lsb)

[Is it possible to allow a user other than root to control a
service](#user)\
[Does atum support user-specific services](#userservices)\
[Does atum work on a read-only filesystem](#readonlyfs)

---

[]{#what}

### What\'s atum, why is it that different

What is this atum init scheme about? Why is it that different from
sysvinit and other init schemes?

Answer: Please see the [introduction](index.html), and web page about
atum\'s [benefits](benefits.html).

---

[]{#help}

### I need some help with atum, what should I do

I have a question, atum is doing something wrong, or I\'m doing
something wrong, what should I do?

Answer: First see the documentation, especially this list of [frequently
asked questions](faq.html), and the man pages if you have a question
about a specific atum program. If that still doesn\'t answer your
question, try to search the [supervision mailing list
archive](https://skarnet.org/lists/supervision/). Finally, if this
fails, feel free to post your question to the [supervision mailing
list](https://skarnet.org/lists/#supervision).

---

[]{#license}

### What\'s the license, is atum free software

I would like to distribute atum, in source and binary form. Am I
allowed to do so?

Answer: atum is free software, it\'s licensed under a three-clause BSD
alike license. See the file `package/COPYING` in the atum tarball.

---

[]{#run}

### How do I run a service under atum service supervision

I want a service to be run under atum service supervision, so that
it\'s automatically started on system boot, and supervised while system
uptime. How does that work?

Answer: atum doesn\'t use the usual `/etc/init.d/` init script
interface, but uses a directory per service. To integrate a service into
the atum init scheme, [create a service directory](#create) for the
service, and [tell atum](#tell) about it.

---

[]{#create}

### How do I create a new service directory

How do I create a service directory for the use with atum?

Answer: Service directories usually are placed into the `/etc/sv/`
directory. Create a new directory for your service in `/etc/sv/`, put a
`./run` script into it, and make the script executable. Note that for
the use with atum, service daemons must not put themself into the
background, but must run in the foreground. Here\'s a simple example for
a `getty` service:

    $ cat /etc/sv/getty-2/run
    #!/bin/sh
    exec getty 38400 tty2 linux
    $ 

Note the `exec` in the last line, it tells the shell that interprets the
script to replace itself with the service daemon `getty`; this is
necessary to make [controlling the service](#control) work properly.

---

[]{#createlog}

### How do I create a new service directory with an appendant log service

How do I create a service directory with an appendant log service for
the use with atum?

Answer: First [create the service directory](#create) for the service.
Then create a subdirectory `./log` in the service directory, again put a
`./run` script into it, and make the script executable. The `./run`
script must run a service logging daemon, normally this is the
[seshat](seshat.8.html) program. See the [nehebkau](nehebkau.8.html) man page
for details. Here\'s an example of a `./log/run` script:

    $ cat /etc/sv/socklog-klog/log/run
    #!/bin/sh
    exec khnum -ulog seshat -tt ./main
    $ 

---

[]{#tell}

### How do I tell atum about a new service

I created a service directory for a service that should run under atum
service supervision. How do I tell atum about the new service
directory, so that it picks up and runs the service by default?

Answer: Create a symbolic link in `/service/` pointing to the service
directory, atum will pick up the service within the next five seconds,
and automatically start it on system boot. E.g.:

    # ln -s /etc/sv/getty-2 /service/

---

[]{#control}

### How do I start, stop, or restart a service

I want to stop a service temporarily, and probably restart is later, or
I want to have it restarted immediately. How can I control a service
running under atum service supervision?

Answer: Use the [sv](heka.8.html) program. E.g., to restart the
`socklog-unix` service, do:

    # heka restart socklog-unix

---

[]{#signal}

### How can I send signals to a service daemon

I want to send a service daemon the HUP signal, to have it re-read its
configuration, or I want to send it the INT signal. How can a send
signals to a service daemon?

Answer: Use the [sv](heka.8.html) program. E.g., to send the `dhcp`
service the HUP signal, do:

    # heka hup dhcp

---

[]{#status}

### How can I query the status of a service

I want to know the status of a service, whether it is up and available,
or down as requested, or so. How can I find out this information?

Answer: User the [sv](heka.8.html) program. E.g., to query or check the
status of the `socklog-unix` service, do:

    # heka status socklog-unix

or

    # heka check socklog-unix

---

[]{#remove}

### How do I remove a service

I want to remove a service that currently runs under atum service
supervision. How do I tell atum?

Answer: Remove the symbolic link in `/service/` pointing to the service
directory, atum recognizes the removed service within the next five
seconds, then stops the service, the optional log service, and finally
the supervisor process. E.g.:

    # rm /service/getty-2

---

[]{#depends}

### How do I make a service depend on another service

I have a service that needs another service to be available before it
can start. How can I tell atum about this dependency?

Answer: Make sure in the `./run` script of the dependant service that
the service it depends on is available before the service daemon starts.
The [sv](heka.8.html) program can be used for that. E.g. the `cron`
service wants the `socklog-unix` system logging service to be available
before starting the `cron` service daemon, so no logs get lost:

    $ cat /etc/sv/cron/run
    #!/bin/sh
    heka start socklog-unix || exit 1
    exec cron -f
    $ 

See also the [documentation](dependencies.html).

---

[]{#runlevels}

### What about runlevels

Other init schemes support runlevels, what about atum?

Answer: atum supports runlevels, even more flexible than traditional
init schemes. See [the documentation](runlevels.html).

---

[]{#lsb}

### What about LSB init scripts compliance

I know about the [sv](heka.8.html) program to control a service, but have
applications that rely on the `/etc/init.d/` scripts interface as
defined through LSB. Do I need to change the application to work with
atum?

Answer: You don\'t need to change the application. The [sv](heka.8.html)
program supports the `/etc/init.d/` script interface [as defined through
LSB](https://refspecs.linuxfoundation.org/LSB_2.1.0/LSB-Core-generic/LSB-Core-generic/iniscrptact.html).
To make this script interface work for a service, create a symbolic link
in `/etc/init.d/`, named as the service daemon, pointing to the
[sv](heka.8.html) program, e.g. for the `cron` service:

    # ln -s /bin/sv /etc/init.d/cron
    # /etc/init.d/cron restart
    ok: run: cron: (pid 5869) 0s
    # 

---

[]{#user}

### Is it possible to allow a user other than root to control a service

Using the [sv](heka.8.html) program to control a service, or query its
status information, only works as root. Is it possible to allow non-root
users to control a service too?

Answer: Yes, you simply need to adjust file system permissions for the
`./supervise/` subdirectory in the service directory. E.g.: to allow the
user `burdon` to control the service `dhcp`, change to the `dhcp`
service directory, and do

    # chmod 755 ./supervise
    # chown burdon ./supervise/ok ./supervise/control ./supervise/status

This works similarly with groups, of course.

---

[]{#userservices}

### Does atum support user-specific services

It\'s very nice to simply [create symbolic links](#tell) to add
system-wide services. Does this work for user-specific services too?

Answer: Yes. E.g.: to provide the user `floyd` with facility to manage
services through `~/service/`, [create a service](#createlog)
`ennead-floyd` with the following run script and a usual log/run
script, and [tell atum](#tell) about the service

    #!/bin/sh
    exec 2>&1
    exec khnum -ufloyd ennead /home/floyd/service

Now `floyd` can create services on his own, and manage them through
symbolic links in `~/service/` to have them run under his user id.

---

[]{#readonlyfs}

### Does atum work on a read-only filesystem

On my system `/etc/` is mounted read-only by default. atum uses many
files in `/etc/` it needs to write to, like `/etc/atum/stopit`, and the
`./supervise/` subdirectories in the service directories. How can I make
atum work on my system?

Answer: Use symbolic links, atum deals with them well, even with
dangling symlinks. E.g., make a ramdisk available at a moint point, say
`/var/run/`, and create symbolic links for the files and directories
that atum needs to write access to pointing into `/var/run/`:

    # ln -s /var/run/atum.stopit /etc/atum/stopit
    # ln -s /var/run/sv.getty-2 /etc/sv/getty-2/supervise

---

[Gerrit Pape \<pape@smarden.org\>](mailto:pape@smarden.org)
