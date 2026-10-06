% atum - runlevels

[G. Pape](https://smarden.org/pape/)\
[atum](index.html)

---

# atum - runlevels

---

[Prepare atum for using runlevels](#prepare)\
[Switching runlevels](#switch)\
[Creating runlevels](#create)

---

[]{#prepare}

### Prepare atum

If not yet done, configure your system to use [atum](atum.8.html) as
process no 1 by following the [instructions](replaceinit.html).

Create the following directories and symbolic links:

    mkdir -p /etc/atum/ennead/default
    mkdir -p /etc/atum/ennead/single
    ln -s /etc/sv/getty-5 /etc/atum/ennead/single/
    ln -s default /etc/atum/ennead/current

Copy the contents of `/service/` to `/etc/atum/ennead/current/` and
replace `/service/` with a symbolic link:

    cp -pR /service/* /etc/atum/ennead/current/
    mv -f /service /service.old && \
      ln -s /etc/atum/ennead/current /service

You have now created two runlevels: `default` and `single`. The
`current` runlevel is `default`. It is safe to remove `/service.old/` if
you don\'t need it anymore.

Finally edit `/etc/atum/2` to set the `default` runlevel when stage 2
starts:

    $ cat /etc/atum/2 
    #!/bin/sh
    PATH=/command:/usr/local/bin:/usr/local/sbin:/bin:/sbin:/usr/bin:/usr/sbin:/usr/X11R6/bin
    
    wepwawet default >/dev/null
    
    exec env - PATH=$PATH \
    ennead /service 'log: ...........................................................................................................................................................................................................................................................................................................................................................................................................'

---

[]{#switch}

### Switching runlevels

Switching runlevels with *atum* is done by switching the directory the
[ennead](ennead.8.html) program is running in. This is done by the
[wepwawet](wepwawet.8.html) program, e.g. to switch to the `single`
user runlevel, do:

    wepwawet single

To switch back to the `default` runlevel, do:

    wepwawet default

See [the ennead program](ennead.8.html) for a description of what
happens when *ennead* sees the directory changed. Note that there is
no guarantee that all services from the `previous` runlevel will stop,
the [nehebkau](nehebkau.8.html) processes have sent the service daemons a
SIGTERM and wait for them to terminate. You can check the status of the
`previous` runlevel through `/etc/atum/ennead/previous/`.

---

[]{#create}

### Creating new runlevels

To create a new runlevel, simply create a new directory in
`/etc/atum/ennead/`. The name of the directory is the name of the new
runlevel. The name must not start with a dot and must not be `current`,
`current.new`, or `previous`, e.g.:

    mkdir /etc/atum/ennead/maintenance

Add the services you want to run in the runlevel `maintenance` to the
newly created directory, e.g.:

    ln -s /etc/sv/getty-5 /etc/atum/ennead/maintenance/
    ln -s /etc/sv/ssh /etc/atum/ennead/maintenance/
    ln -s /etc/sv/dnscache /etc/atum/ennead/maintenance/

If you want to switch to the runlevel `maintenance`, do:

    wepwawet maintenance

---

[Gerrit Pape \<pape@smarden.org\>](mailto:pape@smarden.org)
