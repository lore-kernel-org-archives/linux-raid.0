From: Michael Robinton <michael@bizsystems.com>
Subject: Re: Replacing a RAID 1 array
Date: Wed, 24 Apr 2002 08:01:43 -0700 (PDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.33.0204240746410.1025-100000@pandora.is.bizsystems.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Apr 24, 2002 at 05:07:46AM -0700, Dovli X wrote:
> Will that work? Is there another way to do that? I
> need your help

Here's what I've done several times.

since raid 1 writes the super block at the end of the partition, by
changing the partition type to 83 (standard ext2) you can remount the
drive as an ext2 partition.

you need a boot diskette + rescue for your system that allows you
to manage the disks with raid tools. A regular rescue system with a raid
aware kernel and raidtools works fine.

1) use fdisk to remark the partitions as 83 instead of fd
2) change fstab to use /dev/hda1, /dev/hda2, etc.... instead of mdx
  save a copy of the original
3) reboot and verify that all is well, that fstab, etc... is correct
4) remove the second drive /dev/hdb or /dev/hdc whatever....
   and install the new 60 gig drive in it's place
5) create a new md0 with /dev/hda as a failed drive
6) create your new file system on /dev/md0
7) mount /dev/md0 on /mnt
8) from the root / use cpio and copy each subdirectory to /mnt, excluding
those which are unneeded or that must be manually created. i.e. /proc
/tmp?, etc...
   cd /
   find dirname | cpio -pamd /mnt

9) adjust fstab to again use /dev/md0, etc...
10) reboot the system with rescue pointing to /dev/md0 as root
11) if (10) worked fine (it should), adjust raidtab to change the failed
disk to raid disk. shut down the system, remove and replace the old hard
drive with the new.
12) reboot using rescue pointing to md0
13) partition and mark /dev/hda as 'fd'
14) raidhotadd /dev/md0 /dev/hda

done

