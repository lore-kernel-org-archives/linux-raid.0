From: "Lewis Shobbrook" <lshobbrook@fasttrack.net.au>
Subject: lilo fails on root raid 1 on 2.6.4
Date: Thu, 8 Apr 2004 13:09:19 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <0C8098CA7F09CE419F0C2B68EB8358761EB882@exchange.fasttrack.net.au>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
To: linux-raid@vger.kernel.org
Cc: debian-testing@lists.debian.org
List-Id: linux-raid.ids


Hi All,

I've struck an issue attempting to run lilo when booting to a raid 1
system using a stock Debain 2.6.4-1-686 unstable release kernel image.

After sucecssfully booting into the raid filesystem, attempts to run
lilo give me the error...

Fatal: Trying to map files from unnamed device 0x0000 (NFS/RAID mirror
down ?)


This error occurrs regardless of how I specify the root device (eg
root=dev/hda2 or root=/dev/md0).
The mirror is in a failed disk state, with /dev/hda2 holding on to old
file system and manually marked as failed.
(This process has never been an issue in the past) Conf files listed
below...

Has anyone come across this before?

Any suggestions much appreciated,

Cheers,

Lewis


Raidtab

raiddev /dev/md0
        raid-level              1
        nr-raid-disks           2
        nr-spare-disks          0
        persistent-superblock   1
        device                  /dev/hda2
        failed-disk             0
        device                  /dev/hdc2
        raid-disk               1

fstab

/dev/md0        /               ext3    defaults,errors=remount-ro
0       1
/dev/hda1       none            swap    sw
0       0
proc            /proc           proc    defaults
0       0
/dev/fd0        /floppy         auto    defaults,user,noauto
0       0
/dev/cdrom      /cdrom          iso9660 defaults,ro,user,noauto
0       0


lilo.conf
boot=/dev/hda
root=/dev/md0
install=/boot/boot-menu.b
map=/boot/map
prompt
timeout=100


default=Linux

image=/vmlinuz
        label=Linux
        read-only
        initrd=/initrd.img
#        append="root=/dev/md0"

image=/vmlinuz.old
        label=LinuxOLD
        read-only
        initrd=/initrd.img.old
        append="root=/dev/hda2"



