From: Eddy Ilg <eddyilg@gmx.de>
Subject: RAID5 damaged without any reason
Date: Fri, 28 Jun 2002 16:12:40 +0200 (MEST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <10391.1025273560@www34.gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I have posted this once already but did not get any reply, to be sure here
it is again. 
Any hints, thoughts, ideas would be great. 

I have been successfully running a RAID5 for a long time now. It the last
week the computer running the RAID crashed, probably because of too high
temperature.

The disk configuration is as follows:

/dev/hda1 - ext2 - /boot
/dev/hda2 - swap
/dev/hda3 - reiserfs - /
/dev/hdc1 - linux raid auto
/dev/hde1 - linux raid auto
/dev/hdg1 - linux raid auto

The three RAID partitions run as a RAID5 (/dev/md0) with LVM on top
(/dev/raid5storage/lvol1) and the ext2 filesystem.

After the crash I could not boot linux. After some repairing I got the root
partiotion boot (some shared library was damaged). The system booted
up, the RAID reconstructed and I could successfully e2fsck
/dev/raid5storage/lvol1.

The I decided to make a partiotion on the first disk to back some things
that are on the RAID up. I did

# fdisk /dev/hda
:n (new)
... (/dev/hda4, 55GB)
:w (write and exit)
#

The partition did not show up under /dev/hda4 immediatly, so I rebooted the
system.
After that the RAID started running the reconstruction again and e2fsck told
me:

/dev/raid5storage/lvol1: UNEXPECTED INCONSISTENCY; run fsck MANUALLY
/dev/raid4storage/lvol1: Block bitmap for group 141 is no in group (block
32768)
fsck.ext2 /dev/raid5storage/lvol1 failed (status 4)! run it manually!

I did that:
# e2fsck /dev/raid5storage/lvol1
Group descriptors look bad... trying to backup blocks...
e2fsck: Bad magic number in super-block whily trying to open
/dev/raid5storage/lvol1

The superblock could not be read or does not describe a correct ext2 file
system.
...

I have no idea why the superbock is damaged, since I did not repartition any

of the disks in the RAID.

Can somebody please help me? I need to recover the data.

Thanks in advance.

Eddy 

-- 
GMX - Die Kommunikationsplattform im Internet.
http://www.gmx.net

