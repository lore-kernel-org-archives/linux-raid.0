From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: Broken RAID1 boot arrays
Date: Sat, 15 May 2010 02:23:36 -0500
Message-ID: <6B.E6.29689.EFB4EEB4@cdptpa-omtalb.mail.rr.com>
References: <1273724133.5140.833.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1273724133.5140.833.camel@localhost.localdomain>
Sender: linux-raid-owner@vger.kernel.org
To: 'Daniel Reurich' <daniel@centurion.net.nz>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> 11) make a target directory: "mkdir /target"
> 12) mount the root filesystem on /target: mount /dev/<rootfs> /target

	OK, I got this to work.  I started the installer, did an sftp to one
of my other servers, and then copied the /bin/mount command and the
/lib/libselinux.so.1 library over to the temporary system.  After that, I
was able to mount the partitions with no trouble.

> 13) bind mount the dev sys and proc virtual filesystems:
> 	"mount -o bind /dev /target/dev"
> 	"mount -o bind /sys /target/sys"
> 	"mount -o bind /proc /target/proc"
> 14) Chroot: chroot /target /bin/bash
> 15) mount /boot /usr /var as needed.
> 16) update your mdadm.conf and /etc/fstab etc (ideally use labels for
> root and boot or fs UUID's), and any other stuff like installing the

	These should be OK, but then they should always have been OK,
AFAICT.  They worked before:

# mdadm.conf
#
# Please refer to mdadm.conf(5) for information about this file.
#

# by default, scan all partitions (/proc/partitions) for MD superblocks.
# alternatively, specify devices to scan, using wildcards if desired.
DEVICE partitions


# auto-create devices with Debian standard permissions
CREATE owner=root group=disk mode=0660 auto=yes

# automatically tag new arrays as belonging to the local system
HOMEHOST <system>

# instruct the monitoring daemon where to send mail alerts
MAILADDR lrhorer@satx.rr.com

# definitions of existing MD arrays

# This file was auto-generated on Thu, 14 May 2009 20:25:57 -0500
# by mkconf $Id$
PROGRAM /usr/bin/mdadm_notify
ARRAY /dev/md0 level=raid5 num-devices=8 metadata=01.02 name='Backup':0
UUID=940ae4e4:04057ffc:5e92d2fb:63e3efb7
ARRAY /dev/md3 level=raid1 num-devices=2 metadata=01.02 name='Backup':3
UUID=3615c4a2:33786b6d:b13863d9:458cd054
ARRAY /dev/md2 level=raid1 num-devices=2 metadata=01.02 name='Backup':2
UUID=d45ff663:9e53774c:6fcf9968:21692025
ARRAY /dev/md1 level=raid1 num-devices=2 metadata=01.00 name='Backup':1
UUID=d6a2c60b:7345e957:05aefe0b:f8d1527f

# /etc/fstab: static file system information.
#
# <file system>	 <mount point>	<type> 	<options>     <dump>  <pass>
proc			/proc			proc		defaults
0	0
/dev/md2		/			ext3		defaults
0	1
/dev/md1          /boot             ext2        defaults    0     2
/dev/md3		none			swap		sw
0	0
/dev/cdrom		/media/cdrom0	udf,iso9660	user,noauto	0
0
/dev/md0		/Backup		xfs		defaults	0
2
RAID-Server:/RAID	/RAID			nfs         tcp         0
0

> latest mdadm (apt|aptitude should work fine if your internet connected).
> ***See my notes below.

	I ran `apt-get install mdadm`, and it responded mdadm was the
current version for "Squeeze" (3.0.3, as I recall)

> 17) update your grub config, and run update-grub.
> 18) update your initrd image: "mkinitramfs -k all"

	Uh-uh, that failed.  Firstly, "all" is not a valid switch for this
version of mkinitramfs.  Secondly, the running version of the kernel
(2.6.30-2-amd64) is not the same as the installed version (2.6.32-3-amd64),
so it complained about various missing items.  I seem to recall one can have
mkinitramfs roll up an image for a secific version of a kernel not running,
but I decided instead to just try to complete the apt-get upgrade.  It's
running now.  We'll see how it goes.  It's getting a lot of log failures
because /dev/pts is not mounted, and mandb locale errors because $LC and
$LANG are not set.  'No shocker there, and it shouldn't be fatal.  Hopefully
nothing fatal will pop up.

