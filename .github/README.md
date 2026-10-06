# atum - a UNIX init scheme with service supervision

Build and check:
```
package/compile
package/check
```
To install the programs, as root do
```
install -m0755 command/* /bin/
mv /bin/atum* /bin/khepri /sbin/
```

| Program    | Role                                   |
|------------|----------------------------------------|
| atum       | init (stages 1/2/3)                    |
| khepri     | /sbin/init stub, halt/reboot           |
| nehebkau   | per-service supervisor                 |
| ennead     | supervises a directory of services     |
| wepwawet   | switches service directory (runlevel)  |
| heka       | control services                       |
| seshat     | logger                                 |
| khnum      | change process state                   |
