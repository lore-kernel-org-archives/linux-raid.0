From: "Matthew Simpson" <matthew@symatec-computer.com>
Subject: please help, I've screwed up my RAID 1 install
Date: Sat, 3 Jan 2004 20:39:15 -0600
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <004601c3d26b$f2d70fa0$c800a8c0@KARI>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello everyone, I've really buggered up a RAID 1 install, and I need some
help.

My first mistake was when I was setting up the partition tables, the HOWTO I
was reading mentioned to set the partition type to 0xfd in fdisk.  I've
always used 82 and 83 so I assumed that it may be prudent to actually type
0xfd into fdisk instead of just fd... which fdisk promptly accepted as "00"
[empty].  I didn't notice that, though.

I started out originally with the entire disks partitioned this way, and I
could read/write data, but I couldn't boot from /dev/md0 using the boot
floppy I set up.

I then changed it so that I have hda1, hda2, and hda3 [and corresponding
hdc1, hdc2, hdc3].  Hda1/hdc1 are still erroneously marked 0xfd, and are
80GB.  Hda2/hdc2 are marked 83, Hda3/hdc3 are marked 82 [swap].  I'm booting
into hda2 from the floppy, and then I can:

mkraid /dev/md0
mount -text3 /dev/md0 /drives/md0

and it works.

[you can see my /etc/raidtab at the bottom of this message]

The problem is, if I reboot the machine, then I cannot mount /dev/md0 again
until I do a mkraid /dev/md0 --really-force and rewrite the superblock.  I
do not lose any data, but I know this "can't be good" [tm].

What can I do to fix this?  I've tried setting the partition types for
hda1/hdc1 to the correct "fd" type, but fdisk complains "Partition 1 does
not exist yet".

Also, it is possible to boot from a RAID device, is it not?  I assume it
wasn't working before because of the superblock problem.

My /etc/raidtab:

raiddev /dev/md0
        raid-level      1
        nr-raid-disks   2
        nr-spare-disks  0
        chunk-size      4
        persistent-superblock   1
        device  /dev/hda1
        raid-disk       0
        device  /dev/hdc1
        raid-disk       1

