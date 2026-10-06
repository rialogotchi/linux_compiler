% atum - use with traditional init

[G. Pape](https://smarden.org/pape/)\
[atum](index.html)

---

# atum - use with traditional init

---

It\'s possible to use *atum*\'s service supervision without replacing
the *init* scheme of the system. Simply run the *stage 2* of *atum* as
a service with your current *init*.

Normally this is done by either adding an entry for
`/sbin/ennead-start` to `/etc/inittab`, or by adding
`/sbin/ennead-start` as command to /etc/rc.local, or by adding
`/sbin/ennead-start` to the system\'s `StartupItems`.

In any case, you first need to copy the *stage 2* script to
`/sbin/ennead-start`, and create the services directory `/service/`:

    install -m0750 /package/admin/atum/etc/2 /sbin/ennead-start
    mkdir -p /service

---

[How to use with sysvinit and inittab](#sysv)\
[How to use with sysvinit and upstart](#upstart)\
[How to use with \*BSD init](#bsd)\
[How to use with MacOSX init](#macosx)

---

[]{#sysv}

## Using with sysvinit and inittab

If your system uses a sysvinit alike init scheme with a `/etc/inittab`
file, do:

    cat >>/etc/inittab <<EOT
    SV:123456:respawn:/sbin/ennead-start
    EOT

and tell *init* to re-read its configuration, e.g.:

    init q

---

[]{#upstart}

## Using with sysvinit and upstart

If your system uses a sysvinit alike init scheme that utilizes upstart
instead of inittab, and which has start and stop scripts located in
`/etc/init/`, do:

    cat >/etc/init/ennead.conf <<\EOT
    # for atum - manage /usr/sbin/ennead-start
    start on runlevel 2
    start on runlevel 3
    start on runlevel 4
    start on runlevel 5
    stop on shutdown
    respawn
    exec /usr/sbin/ennead-start
    EOT

and tell init to start the new service, e.g.:

    start ennead

---

[]{#bsd}

## Using with \*BSD init

If your system uses a BSD alike init scheme with a `/etc/rc.local`
script, do:

    cat >>/etc/rc.local <<EOT
    csh -cf '/sbin/ennead-start &'
    EOT

and reboot your system.

---

[]{#macosx}

## Using with MacOSX init

On MacOSX 10.2 create an entry for *atum* in
`/System/Library/StartupItems/`:

    cd /System/Library/StartupItems
    mkdir -p atum
    cp -p /package/admin/atum/etc/macosx/StartupItems/* atum/

and reboot your system.

On MacOSX 10.4 create an entry for *atum* in `/Library/LaunchDaemons/`,
and tell *launchd* to start the new service:

    cp /package/admin/atum/etc/macosx/org.atum.plist \
      /Library/LaunchDaemons/
    launchctl load /Library/LaunchDaemons/org.atum.plist

---

[Gerrit Pape \<pape@smarden.org\>](mailto:pape@smarden.org)
