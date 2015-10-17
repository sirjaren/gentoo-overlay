## Getting the overlay

* Ensure `conf_type` is set to `repos.conf` in `/etc/layman/layman.cfg`:
<pre>
<b>$ grep '^conf_type' /etc/layman/layman.cfg</b>
conf_type : repos.conf
</pre>
* Run `layman-updater -R` to rebuild `layman's` `repo.conf` files
<pre>
<i># Requires <b>layman 2.3.0</b> or greater</i>
<b># layman-updater -R</b>
</pre>
* Finally, add the overlay:
<pre>
<i># Installs (by default) to /var/lib/layman/installed.xml</i>
<b># layman -o 'https://raw.githubusercontent.com/sirjaren/gentoo-overlay/master/sirjaren.xml' -f -a sirjaren</b>
</pre>
* Or do it manually
<pre>
<b>$ cd /etc/layman/overlays/
$ wget 'https://raw.githubusercontent.com/sirjaren/gentoo-overlay/master/sirjaren.xml'
# layman -a sirjaren</b>
</pre>
