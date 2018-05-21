## Getting the overlay

* Ensure `conf_type` is set to `repos.conf` in `/etc/layman/layman.cfg`:
```
$ grep '^conf_type' /etc/layman/layman.cfg
conf_type : repos.conf
```
* Run `layman-updater -R` to rebuild `layman's` `repo.conf` files
```
# Requires layman 2.3.0 or greater
# layman-updater -R
```
* Finally, add the overlay:
```
# Installs (by default) to /var/lib/layman/installed.xml
# layman -o 'https://raw.githubusercontent.com/sirjaren/gentoo-overlay/master/sirjaren.xml' -f -a sirjaren
```
* Or do it manually
```
$ cd /etc/layman/overlays/
$ wget 'https://raw.githubusercontent.com/sirjaren/gentoo-overlay/master/sirjaren.xml'
# layman -a sirjaren
```
