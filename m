From: "Mike Garey" <random51k@gmail.com>
Subject: Can't mount /dev/md0 after stopping a synchronization
Date: Tue, 4 Apr 2006 15:25:06 -0400
Message-ID: <c79e949d0604041225jc9b89cclf8653cd18e88d632@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I'm in the process of setting up a software RAID level 1 on debian
testing with two 160 gig drives on an Asus P4P800 motherboard with
Intel Pentium 4 CPU 3.00GHz and 512 megs of RAM.  I've been following
the instructions in /usr/share/doc/mdadm/rootraiddoc97.html, but after
rebooting to /dev/hdc1 (/dev/md0) and issuing the command "mdadm --add
/dev/md0 /dev/hda1", I was only getting 1636K/sec for the
synchronization, which was _way_ too slow (I forgot I had left a CDROM
drive on the secondary IDE channel, so /dev/hdc1 was running at UDMA2,
plus, I was using a 40 conductor cable instead of 80).  So I decided
to reboot the system and cancel the synchronization, thus destroying
everything on /dev/hda1 (but this didn't seem like an issue, since I
was able to boot from /dev/md0 aka /dev/hdc1).

So after stopping the sync process and rebooting, I was unable to boot
from hdc1 because I had forgotten to copy over my initrd with md/raid1
modules from /dev/hda1 to /dev/hdc1, and of course now /dev/hda1 is
destroyed, so I can't use the initrd-RAID that was previously on there
(and the initrd-RAID never existed on /dev/hdc1, since I created it on
/dev/hda1 _after_ I had issued the "mount /dev/md0 /mnt/md0; cp -axu /
/mnt/md0" commands - don't ask why).  So when I rebooted, I didn't
have md/raid1 support, and so /dev/md0 couldn't mount.. I ended up
building a new initrd with md/raid1 on another debian box, then
copying them to /dev/hdc1.  I've now tried installing grub on
/dev/hdc, disconnected /dev/hda, and attempted to boot.  I now get the
following message:

md: md driver 0.90.3 MAX_MD_DEVS=3D256, MD_SB_DISKS=3D27
md: bitmap version 4.39
md: raid1 personality registered as nr3
.
.
Begin: Mounting root file system...
Begin: Running /scripts/local-top
Done.
ALERT! /dev/md0 does not exist.  Dropping to a shell!

At which point I get dropped into busybox..  One thing I notice is
that although it shows the md module being loaded, it doesn't really
say anything about configuring/adding any RAID disks (which is used to
say, back when I had first booted into /dev/md0 (hdc1) before killing
/dev/hda1).  So now apparently /dev/md0 no longer exists, and I have
no idea how to create it.

In fstab on /dev/hcd1, I have:

/dev/md0 / ext3 defaults 0 0

and in /boot/grub/menu.lst I have:

title           Debian GNU/Linux, kernel 2.6.15-486 RAID
root            (hd0,0)
kernel          /boot/vmlinuz-2.6.15-486 root=3D/dev/md0 ro
initrd          /boot/initrd.img-2.6.15-486-RAID
savedefault
boot

Now, /dev/md0 was originally created by using:

mdadm --create /dev/md0 --level=3D1 --raid-disks=3D2 missing /dev/hdc1

can anybody tell me why /dev/md0 is no longer available on /dev/hdc1,
and if possible how to recreate it?

I should mention that after I cancelled the synchronization process,
and was unable to reboot into /dev/hdc1, I then mounted /dev/hdc1
through busybox, changed the Type of the disk from FD (linux raid) to
83 (linux), modified /etc/fstab and /boot/grub/menu.lst so it pointed
to /dev/hdc1 instead of /dev/md0.  I tried rebooting after changing
these options, and it gave me a message saying "Failed to mount root
file system" or something to that effect. Could changing the Type of
the disk or mounting /dev/hdc1 have caused /dev/md0 to become
corrupted/deleted?

If anybody has the time to read through my message
and give me some advice, I would very much appreciate it.  Thanks,

Mike
