From: Daniel Reurich <daniel@centurion.net.nz>
Subject: RE: Broken RAID1 boot arrays
Date: Thu, 13 May 2010 16:15:33 +1200
Message-ID: <1273724133.5140.833.camel@localhost.localdomain>
References: <1D.35.20763.7865BEB4@cdptpa-omtalb.mail.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1D.35.20763.7865BEB4@cdptpa-omtalb.mail.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Leslie Rhorer <lrhorer@satx.rr.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 2010-05-12 at 20:31 -0500, Leslie Rhorer wrote:
> 	Hello?  Anyone?  I'm flummoxed, here.  I tried to write in a manual
> assembly of the arrays in the initrd, but so far I haven't been able to get
> it to work.  One way or another, it just hangs when running
> /scripts/local-top/mdadm in the initrd.  Even `ls -1 /dev/sd*` returns an
> error.
> 
Ok.  

1) Get business card image from the link provided and burn to CD and
boot of it.

http://www.debian.org/devel/debian-installer/

2) Select Advanced Options then expert install.
3) Set Language etc.
4) When it asks to select installer components select "Network Console"
and continue.
5) Configure the network (if you haven't already),
6) In the menu select "Continue installation remotely using ssh and
follow the instructions to connect in via ssh from your desired
workstation and continue.
7) Select exit to shell
8) insert the appropriate raid modules: 'modprobe raidX' where X is the
raid levels you use for each raid level you use.
9) use mdadm to manually assemble the necessary root, /boot and /var
arrays.
10) If your root fs is in LVM do: "modprobe dm_mod" followed by 
"vgchange -ay" 
11) make a target directory: "mkdir /target"
12) mount the root filesystem on /target: mount /dev/<rootfs> /target
13) bind mount the dev sys and proc virtual filesystems:
	"mount -o bind /dev /target/dev"
	"mount -o bind /sys /target/sys"
	"mount -o bind /proc /target/proc"
14) Chroot: chroot /target /bin/bash
15) mount /boot /usr /var as needed.
16) update your mdadm.conf and /etc/fstab etc (ideally use labels for
root and boot or fs UUID's), and any other stuff like installing the
latest mdadm (apt|aptitude should work fine if your internet connected).
***See my notes below.
17) update your grub config, and run update-grub.
18) update your initrd image: "mkinitramfs -k all"
19) unmount the fs's you mounted in the chroot
20) umount /target/proc /target/sys and /target/dev.
21) reboot and try it out.

*** You might want to post your real mdadm.conf at this point.  If your
not sure about what the issue is, then perhaps IRC (does linux-raid have
a channel?) might be the best bet.



> 	It's also really odd that I can assemble and mount the root and boot
> arrays, but under Ubuntu I can't even assemble the swap array.  It complains
> that the first member of the array is busy and refuses to start /dev/md3.
> The results of --examine look identical to those listed below, except of
> course for the partition specific entries (size, drive and array UUID,
> events, etc).
> 
This is because ubuntu probably picks up the first swap partition it
finds and uses it.

> 	I really need to get this machine back on line, and any suggestions
> are greatly appreciated.
> 
> > > don't want to try to install the OS: that could be a disaster.  BTW, the
> > > 2.6.32 kernel is moving the IDE disks all the way from /hda and /hdb to
> > > /sdj
> > > and /sdk.  I think that's part of why it's breaking: the existing
> > > mdadm.conf
> > > doesn't scan that high.
mdadm shouldn't care unless you've changed the "DEVICE partitions" line
to something else.

> > 	OK, maybe not.  I re-arranged things so the boot drives are /dev/sda
> > and /dev/sdb, but it still isn't working.  When I boot the Ubuntu live CD
> > and install mdadm, it creates the following mdadm.conf:
> > 
> > ubuntu@ubuntu:~$ cat /etc/mdadm/mdadm.conf
> > # mdadm.conf
> > #
> > # Please refer to mdadm.conf(5) for information about this file.
> > #
> > 
> > # by default, scan all partitions (/proc/partitions) for MD superblocks.
> > # alternatively, specify devices to scan, using wildcards if desired.
> > DEVICE partitions
> > 
> > # auto-create devices with Debian standard permissions
> > CREATE owner=root group=disk mode=0660 auto=yes
> > 
> > # automatically tag new arrays as belonging to the local system
> > HOMEHOST <system>
> > 
> > # instruct the monitoring daemon where to send mail alerts
> > MAILADDR root
> > 
> > # definitions of existing MD arrays
> > ARRAY /dev/md/1 level=raid1 metadata=1.0 num-devices=2
> > UUID=d6a2c60b:7345e957:05aefe0b:f8d1527f name='Backup':1
> > ARRAY /dev/md/2 level=raid1 metadata=1.2 num-devices=2
> > UUID=d45ff663:9e53774c:6fcf9968:21692025 name='Backup':2
> > ARRAY /dev/md/3 level=raid1 metadata=1.2 num-devices=2
> > UUID=3615c4a2:33786b6d:b13863d9:458cd054 name='Backup':3
> > ARRAY /dev/md/0 level=raid5 metadata=1.2 num-devices=8
> > UUID=940ae4e4:04057ffc:5e92d2fb:63e3efb7 name='Backup':0
> > 
> > # This file was auto-generated on Tue, 11 May 2010 23:45:16 +0000
> > # by mkconf $Id$
> > 
> > 	If I try to auto-assemble the arrays, it fails:
> > 
> > ubuntu@ubuntu:~$ sudo mdadm --assemble --scan
> > mdadm: no devices found for /dev/md/1
> > mdadm: no devices found for /dev/md/2
> > mdadm: no devices found for /dev/md/3
> > mdadm: no devices found for /dev/md/0
> > 
It seems odd to me that all the raid volumes are named "Backup".
Perhaps mdadm doesn't like the name collision.

Perhaps you need to recreate some of them with a different name.  I'd
suggest recreating the raid1 volumes with different names and the
--assume-clean flag (except the swap one which won't be since the ubuntu
live cd's been messing with one of those component partitions).

I hope this helps.

Regards,
	

-- 
Daniel Reurich.

Centurion Computer Technology (2005) Ltd
Mobile +64 21 797 722



