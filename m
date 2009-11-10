From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: Bitmap did not survive reboot
Date: Mon, 9 Nov 2009 19:44:05 -0600
Message-ID: <20091110014415205.WMYE3390@cdptpa-omta03.mail.rr.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


	I had to reboot one of my Linux systems a few days ago (November 2)
because something was a little unstable, although RAID was AFAIK working
just fine.  This is not an online production system, so rather than try to
run down the culprit, I just rebooted the box.  Everything seemed to come
back up just fine, so I really didn't spend too much time checking
everything out.  Today one of the drives in the RAID5 array was kicked out,
so I removed it and added it back.  It wasn't until I added the drive back
that I noticed the array no longer had a write-intent bitmap.  The array had
an external bitmap, but it is no longer there, and I presume for some reason
it was not registered when the box rebooted.  I don't see anything which
looks like a failure related to md in the logs.  The external bitmap is in
an ext2 file system in a partition of the boot drive, so the file should be
available during boot prior to building the RAID array.  What could be
causing the bitmap to drop out?  This isn't the first time it has happened.
I searched /var/log for the string "md" to find the messages related to
activity on the array.  Is there some other string for which I should
search?  Here is /etc/fstab :

Backup:/var/log# cat /etc/fstab
# /etc/fstab: static file system information.
#
# <file system> <mount point>   <type>     <options>       <dump>  <pass>
proc          /proc             proc       defaults        0       0
/dev/hda2     /                 reiserfs   defaults        0       1
/dev/hda1     /boot             reiserfs   notail          0       2
/dev/hda4     /etc/mdadm/bitmap ext2       defaults        0       1
/dev/hda5     none              swap       sw              0       0
/dev/hdb      /media/cdrom0     udf,iso9660user,noauto     0       0
/dev/md0      /Backup           xfs        defaults        0       2

	Here is /etc/mdadm/mdadm.conf

Backup:/etc/mdadm# cat mdadm.conf
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
DEVICE /dev/sd[a-g]
ARRAY /dev/md0 level=raid5 metadata=1.2 num-devices=7
UUID=940ae4e4:04057ffc:5e92d2fb:63e3efb7 name='Backup':0
bitmap=/etc/mdadm/bitmap/md0.map

