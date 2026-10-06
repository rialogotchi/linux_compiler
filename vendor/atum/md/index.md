% atum - a UNIX init scheme with service supervision

[G. Pape](https://smarden.org/pape/)

---

# atum - a UNIX init scheme with service supervision

---

[How to install atum](install.html)\
[Upgrading from previous versions of atum](upgrade.html)

[Benefits](benefits.html)\
[How to replace init](replaceinit.html)\
[How to use atum with current init](useinit.html)\
[Frequently asked questions](faq.html)

[Runlevels](runlevels.html)\
[Service dependencies](dependencies.html)\
[A collection of run scripts](runscripts.html)

[The `atum` program](atum.8.html)\
[The `khepri` program](khepri.8.html)

[The `heka` program](heka.8.html)

[The `ennead` program](ennead.8.html)\
[The `wepwawet` program](wepwawet.8.html)\
[The `nehebkau` program](nehebkau.8.html)

[The `seshat` program](seshat.8.html)

[The `khnum` program](khnum.8.html)

---

*atum* is a cross-platform Unix init scheme with service supervision, a
replacement for [sysvinit](https://en.wikipedia.org/wiki/Init#SYSV) and
other init schemes. It runs on **GNU/Linux**, **\*BSD**, **MacOSX**,
**Solaris**, and can easily be adapted to other Unix operating systems.
If *atum* runs for you on any other operating system, please [let me
know](mailto:supervision@list.skarnet.org).

---

Contribute to *atum* through [GitHub
atum](#).

---

*atum* is discussed on the
[\<supervision@list.skarnet.org\>](https://skarnet.org/lists/#supervision)
mailing list. Please contact this list and not me privately.

To subscribe send an empty email to
[\<supervision-subscribe@list.skarnet.org\>](mailto:supervision-subscribe@list.skarnet.org).

Mailing list archives are available at
[skarnet.org](https://skarnet.org/lists/supervision/), and
[mail-archive.com](https://www.mail-archive.com/supervision@list.skarnet.org/).

---

The program [atum](atum.8.html) is intended to run as Unix process no
1, it is automatically started by the [khepri](khepri.8.html)
`/sbin/init`-replacement if this is started by the kernel.

[atum](atum.8.html) performs the system\'s *booting*, *running* and
*shutting down* in **three stages**:

-   **Stage 1:**\
    *atum* starts `/etc/atum/1` and waits for it to terminate. The
    system\'s one time initialization tasks are done here.
    `/etc/atum/1` has full control over `/dev/console` to be able to
    start an emergency shell in case the one time initialization tasks
    fail.
-   **Stage 2:**\
    *atum* starts `/etc/atum/2` which should not return until the
    system is going to halt or reboot; if it crashes, it will be
    restarted. Normally, `/etc/atum/2` runs
    [ennead](ennead.8.html). In Stage 2 *atum* optionally handles
    the INT signal (ctrl-alt-del keyboard request on Linux/i386).
-   **Stage 3:**\
    If *atum* is told to halt or reboot the system, or Stage 2 returns
    without errors, it terminates Stage 2 if it is running, and runs
    `/etc/atum/3`. The systems tasks to shutdown and halt or reboot are
    done here.

These are working examples for Debian sarge: [/etc/atum/1](debian/1),
[/etc/atum/2](debian/2), [/etc/atum/3](debian/3).

The program [khepri](khepri.8.html) is intended to replace
`/sbin/init`. The command **`init 0`** tells *atum* to halt the system,
and **`init 6`** to reboot. [Runlevels](runlevels.html) are handled
through the [ennead](ennead.8.html) and
[wepwawet](wepwawet.8.html) programs. Service
[dependencies](dependencies.html) are resolved automatically.

*atum* is optimized for reliability and small size. The amount of code
in process no 1 should be minimal.

---

See [How to install atum](install.html) for installing *atum*, and
[How to replace init](replaceinit.html) for configuring *atum* to run
as process no 1. See [How to use with current init](useinit.html) if you
want to use *atum* without replacing the current init scheme. Please
read the list of [Frequently asked questions with answers](faq.html).

---

The following distributions are known to include or package *atum*:

    alternative init scheme)
-   [Ubuntu](https://packages.ubuntu.com/search?keywords=atum) (as
    alternative init scheme)
-   [Void Linux](https://www.voidlinux.org/) (as default init scheme)
-   [Artix Linux](https://artixlinux.org/) (as alternative init scheme)
-   [antiX Linux](https://antixlinux.com/) (as alternative init scheme)
-   [Debian GNU/Hurd](https://skarnet.org/lists/supervision/3291.html)

If you know of more distributions, please [let me
know](mailto:supervision@list.skarnet.org).

---

***atum* in use**: I replaced *sysvinit* successfully with *atum* on
several server systems and a laptop running Debian/GNU Linux sarge,
woody, and potato. Here is an example:

    # strings /proc/1/exe |grep Id
    $Id: atum.c,v 1.7 2002/02/13 09:59:52 pape Exp $
    # uptime
     11:59:13 up 365 days, 23:22,  3 users,  load average: 0.01, 0.02, 0.00
    # ps axuw |head -n20
    USER       PID %CPU %MEM   VSZ  RSS TTY      STAT START   TIME COMMAND
    root         1  0.0  0.0    20   16 ?        S     2002   0:07 atum
    root         2  0.0  0.0     0    0 ?        SW    2002   0:00 [keventd]
    root         3  0.0  0.0     0    0 ?        SWN   2002   0:51 [ksoftirqd_CPU0]
    root         4  0.0  0.0     0    0 ?        SW    2002 144:38 [kswapd]
    root         5  0.0  0.0     0    0 ?        SW    2002   0:08 [bdflush]
    root         6  0.0  0.0     0    0 ?        SW    2002   7:24 [kupdated]
    root       168  0.0  0.0  1652  168 ?        S     2002   0:27 /usr/sbin/cron
    root       174  0.0  0.0    36   24 ?        S     2002   1:06 ennead /var/service log: ...............................................................................................
    root       176  0.0  0.0    20   20 ?        S     2002   0:00 nehebkau qmail-send
    root       177  0.0  0.0    20   20 ?        S     2002   0:00 nehebkau getty-5
    root       178  0.0  0.0    20   20 ?        S     2002   0:00 nehebkau getty-4
    root       179  0.0  0.0    20   20 ?        S     2002   0:00 nehebkau getty-3
    root       180  0.0  0.0    20   20 ?        S     2002   0:00 nehebkau getty-2
    root       182  0.0  0.0    20   20 ?        S     2002   0:00 nehebkau socklog-unix
    root       183  0.0  0.0  1256    4 tty5     S     2002   0:00 /sbin/getty 38400 tty5 linux
    root       184  0.0  0.0  1256    4 tty3     S     2002   0:00 getty 38400 tty3 linux
    root       185  0.0  0.0    20   20 ?        S     2002   0:00 nehebkau socklog-klog
    root       186  0.0  0.0    20   20 ?        S     2002   0:00 nehebkau ssh
    root       187  0.0  0.0  1256    4 tty4     S     2002   0:00 getty 38400 tty4 linux
    # pstree
    atum-+-bdflush
          |-cron
          |-gcache
          |-keventd
          |-ksoftirqd_CPU0
          |-kswapd
          |-kupdated
          `-ennead-+-nehebkau-+-multilog
                     |       `-qmail-send-+-qmail-clean
                     |                    |-qmail-lspawn
                     |                    `-qmail-rspawn---qmail-remote
                     |-4*[nehebkau---getty]
                     |-2*[nehebkau-+-multilog]
                     |          `-socklog]
                     |-nehebkau-+-multilog
                     |       `-sshd-+-sshd---sshd---bash---bash---pstree
                     |              `-sshd---sshd---rsync
                     |-nehebkau---clockspeed
                     |-nehebkau-+-dnscache
                     |       `-multilog
                     |-nehebkau---apache-ssl-+-9*[apache-ssl]
                     |                    |-gcache
                     |                    `-4*[multilog]
                     |-7*[nehebkau-+-multilog]
                     |          `-tcpserver]
                     |-4*[nehebkau-+-multilog]
                     |          `-tinydns]
                     |-nehebkau---uncat
                     |-2*[nehebkau-+-multilog]
                     |          `-tcpsvd]
                     |-nehebkau-+-seshat
                     |       `-tcpsvd-+-smtpfront-qmail
                     |                `-smtpfront-qmail---qmail-queue
                     `-nehebkau-+-seshat
                             `-tcpsvd---bincimap-up---bincimapd

---

See <index.html> for recent information.

---

[Gerrit Pape \<pape@smarden.org\>](mailto:pape@smarden.org)
