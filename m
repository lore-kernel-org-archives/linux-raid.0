From: Daniel Reurich <daniel@centurion.net.nz>
Subject: md extension to support booting from raid whole disks.
Date: Sat, 25 Apr 2009 00:08:20 +1200
Message-ID: <1240574900.4507.2076.camel@ezra>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I have got linux successfully booting from a raid5 whole disk set with /
& /boot filesystems on that raid5 disk set.  This is possible thanks to
grub2 (with some hacking to make it install correctly.)

The downside I found is that the system won't boot if the 1st disk is
missing, as that contains the boot sector and core.img that grub
requires to boot.  The linux kernel also get unhappy about the partition
table of the first disk saying the volume is larger then the geometry of
the physical first disk.

I was wondering if it was worth extending the md superblock to make it
easier for booting raided whole disks.  There are several ideas I had
thought of that would make this achieveable:

A first cylinder which needs to be mirrored across all the devices.
This would be for the Volume/Master Boot record + Boot Sector Code.
Grub2 bootsector + core.img should fit in here at (or least enough of it
to bring grub up with the appropriate raid drivers.)

We could include a dummy partition table with the whole disk in the 1st
partition labeled as something like linux-raid (0xfd) or Non-FS data
(0xda).

The second cylinder has the md superblock and write intent bitmap, and
the raid volume starts at the beginning of the 3rd cylinder.

This would allow for this scheme to work with booting of all whole disk
raid arrays of all levels using grub2, without any significant changes
required in grub2.

Thanks for the awesomeness that is linux software raid.
 
-- 
Daniel Reurich

Centurion Computer Technology (2005) Ltd
Ph 021 797 722

