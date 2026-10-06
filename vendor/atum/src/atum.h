#define ATUM "/sbin/atum"
#define STOPIT "/etc/atum/stopit"
#define REBOOT "/etc/atum/reboot"
#define NOSYNC "/etc/atum/nosync"
#define CTRLALTDEL "/etc/atum/ctrlaltdel"
#define PWRFAIL "/etc/atum/pwrfail"

#ifdef NEHEBKAU_USE_SYSLIMITS
#include <limits.h>
#ifndef PATH_MAX
#define PATH_MAX 256
#endif
#define BUFSIZE (PATH_MAX > 256 ? PATH_MAX : 256)
#else
#define BUFSIZE 256
#endif
