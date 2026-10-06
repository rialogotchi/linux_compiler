% wepwawet(8)

# NAME

wepwawet - change services directory of ennead(8)

# SYNOPSIS

**wepwawet** *dir*

# DESCRIPTION

*dir* is a services directory for the use with **ennead**(8). If *dir*
does not start with a slash, it is searched in **wepwawet**\'s working
directory, by default */etc/atum/ennead/*. *dir* must not start with
a dot.

**wepwawet** switches to its working directory, copies *current* to
*previous*, and replaces *current* with a symlink pointing to *dir*.

Normally */service* is a symlink to *current*, and **ennead**(8) is
running */service/*.

# ENVIRONMENT

**ENNEAD**
:   The environment variable $ENNEAD overrides the default working
    directory */etc/atum/ennead/*.

# EXIT CODES

**wepwawet** prints an error message and exits 111 on error.
**wepwawet** exits 0 on success.

# FILES

/etc/atum/ennead/previous\
/etc/atum/ennead/current\
/etc/atum/ennead/current.new

# SEE ALSO

ennead(8), atum(8), khepri(8), heka(8), nehebkau(8)

index.html

# AUTHOR

Gerrit Pape \<pape@smarden.org\>
