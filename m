From: "Adam J Morand" <Adam.Morand@illuminatedtechnologies.com>
Subject: RAID 1 / Power Loss / No SuperBlock
Date: Sun, 2 Feb 2003 12:50:30 -0800
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <00c301c2cafc$b9df8c80$6701a8c0@bc.hsia.telus.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

I apologize if this is the wrong place to talk about this.
I run a RH7.2 with software RAID 1, recently the power went out, and drained
the UPS before I got home.
I am unable to restart my RAID because fsck can not run without finding the
superblock

The error I get
[aj@r2d2 aj]$ fsck /dev/hdd1
Parallelizing fsck version 1.23 (15-Aug-2001)
e2fsck 1.23, 15-Aug-2001 for EXT2 FS 0.5b, 95/08/09
Couldn't find ext2 superblock, trying backup blocks...
fsck.ext2: Bad magic number in super-block while trying to open /dev/hdd1

The superblock could not be read or does not describe a correct ext2
filesystem.  If the device is valid and it really contains an ext2
filesystem (and not swap or ufs or something else), then the superblock
is corrupt, and you might try running e2fsck with an alternate superblock:
    e2fsck -b 8193 <device>

Exit 8

Is there RAID tools available for a situation like this that can recreate
the superblocks?
I have tried the backup blocks, I do not know how else or where to look for
more information on reconstructed my dead RAID.

Thank you for any information or hints possible,

aj


