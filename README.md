unraid-snap
===========

SNAP for unRAID Server
======================

Snap: Share Non-Array Partitions 

Adding storage devices to an unRAID server without them being part of the unRAID array. Adding a device to SNAP means that it's filesystem will be mounted to make it available in linux and shared out to make it available on the network. SNAP is aware of the unRAID array drives and doesn't disturb any drives assined to the array. 


SNAP Installation
=================

To install SNAP you need to download the snap.plg and put it in the /boot/config/plugins directory.  You can download the file directly from GitHub and then browse to your flash drive and copy it to the /config/plugins directory or use a telnet session to download the file directly from GitHub.  To install the plugin file, use a telnet session to your server, log in to the server, and then issue the following commsnds:

cd /boot/config/plugins

wget --no-check-certificate https://github.com/dlandon/unraid-snap/raw/master/snap.plg

Reboot your server
or
installplg snap.plg

SNAP will install.


NTFS Write Driver
=================

If you are using NTFS disk drives and need to write on then, you will need the ntfs-3g driver installed.  unRAID only supports reading from NTFS devices.  To enable NTFS write capability, do the following:

copy /boot/config/plugins/snap/ntfs-3g-2011.1.15-i486-1.txz /boot/extra

Reboot your server.  This will install the ntfs-3g driver.

