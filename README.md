SNAP for unRAID Server
======================

SNAP: Share Non-Array Partitions 

Add storage devices to an unRAID server without them being part of the unRAID array. Adding a device to SNAP means that it's filesystem will be mounted to make it available in linux and shared out to make it available on the network. SNAP is aware of the unRAID array drives and doesn't disturb any drives assigned to the array. 

Copyright (c) Copyright (C) 2010-2014, Dave Lewis or Queegtech.com

All rights reserved.

SNAP is now ready for unRAID v6 64bit.  There is a plugin for v5 and a separate plugin for v6.  Be sure to use the correct plugin for your version of unRAID.

SNAP Installation
=================

To install SNAP you need to download the snap.plg and put it in the /boot/config/plugins directory.  You can download the file directly from GitHub and then browse to your flash drive and copy it to the /config/plugins directory or use a telnet session to download the file directly from GitHub with wget.  To install the plugin file, use a telnet session to your server, log in to the server, and then issue the following commands:

cd /boot/config/plugins

unRAID v5
=========
wget --no-check-certificate https://github.com/dlandon/unraid-snap/raw/master/snap.plg

Reboot your server

or

installplg snap.plg

SNAP will install.

unRAID v6
=========
wget https://github.com/dlandon/unraid-snap/raw/master/snap-x86_64.plg

Reboot your server

or

installplg snap-x86_64.plg

SNAP will install.


NTFS Write Driver
=================

There is a NTFS driver plugin for v5 and a separate plugin for v6 of unRAID.  Be sure you use the correct plugin for your version of unRAID.

Before you install this plugin, delete any ntfs-3g packages from the /boot/extra directory otherwise you could end up with multiple package versions.  I know this is messy, but until unRAID package management is sorted out, this is the best I can do.

If you are using NTFS disk drives and need to write on them, you will need the ntfs-3g driver installed.  unRAID only supports reading from NTFS devices.  To enable NTFS write capability, do the following:

unRAID v5
=========
cd /boot/config/plugins

wget --no-check-certificate https://github.com/dlandon/unraid-snap/raw/master/ntfs-3g.plg

Reboot your server.

or

installplg ntfs-3g.plg

This will install the ntfs-3g package.

unRAID v6
=========
cd /boot/config/plugins

wget https://github.com/dlandon/unraid-snap/raw/master/ntfs-3g-x86_64.plg

Reboot your server.

or

installplg ntfs-3g-x86_64.plg

This will install the ntfs-3g package.


Revision History
================

Version 5.10 - Initial release.

Version 5.11 - Fixed drive busy detection and some unmount problems.

Version 5.12 - Fixed mount and unmount of disks with multiple partitions. SNAP should only mount the first partition on the disk.

Version 5.13 - Minor UI issues.

Version 5.14 - SNAP drives are now unmounted when the unRAID array is stopped.  Moved packages to the snap.plg where they belong.  Updated to latest inotify package.  Fixed "No Fs" indicator when stopping a preclear and the disk has a valid file system.  Created ntfs-3g plugin to install ntfs-3g driver needed for writing to ntfs disks.

Version 5.15 - More organizational changes.  All packages are now managed by the SNAP plugin.  Updated all packages to Slackware 14.0 - screen, libelf, inotify, and utempter.  I think this fixed a few webgui lockups I experienced when preclearing disks.  It hasn't happened since this update on my test server.  I have added a new command parameter -MW to snap.sh to wait for a disk to not be busy and then unmount it.  This is handy in your hot plug scripts to be sure the drive is successfully unmounted.  If the disk is busy, the -M command would not unmount the disk.

Version 5.16 - Fixed an update problem.  The SNAP plugin was not installed correctly and did not show up in the webgui.

Version 5.17 - Removed preclear and screen, libelf, and utempter packages.  Decided that it was best that SNAP not do preclears.

Version 5.18 - Made modifications to standardize plugin for plugin managers like Control Panel.

Version 5.19 - Added copyright notices and GPL license.

Version 5.20 - Released SNAP for unRAID v6. Aligned unRAID v5 SNAP to unRAID v6 SNAP.

Version 5.21 - Updated jQuery, jQuery ui, jQuery cookie, and fixed php errors.  Removed unused jQuery files.

Version 5.22 - Fixed a situation where a drive was shared and not mounted.

Version 5.23 - USB drives were not recognized and hot plugged in V6.  Changed SNAP so any hot pluggable drive is now hot plugged by SNAP.

Version 5.24 - Fixed some incompatibilities with Dynamix.

Version 5.25 - Fixed a hot plug issue with some devices.

Version 5.26 - SNAP will change themes (white/black) when working with Dynamix.

Version 5.27 - Modified style sheet to more closely match Dynamix black theme colors.

Version 5.28 - Depricated unRAID v5 at version 5.27.  V5 will no longer be updated.  Starting with 5.28, V6 will be the only unRAID version supported.
