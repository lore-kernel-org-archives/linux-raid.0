From: Leopoldo Ghielmetti <leopoldo.ghielmetti@a3.epfl.ch>
Subject: Incompatibility between Linux and Windows
Date: Thu, 17 Jan 2008 12:46:52 +0100
Message-ID: <1200570412.19278.26.camel@synda.ghielmetti.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I've some questions on the Linux software raid. I have assembled a raid1
array with 2 external disks and what we want is to mount those disks in
Linux (using raid), in Windows (using a read-only mount of only one
disk) and in a Linux without the raid support (also with a read-only
mount).

I remember that it was possible when I've used the raid tools but today
it seems to be impossible, the Windows don't recognize the partition and
Linux answer that he can't mount a linux_raid_member partition when I
choose to mount only one of the devices (in read-only mode).

Before it was possible to mount the discs independently or using the
raidtools.

How can I make this operations?

It's a problem in the superblock? I remember that normally the
superblock is at the end of the partition so he don't interfere with the
using of the filesystem by an OS that don't known Linux Raid Arrays but
the error of the Linux itself and the non recognition by Windows let me
suppose that now the mdadm create the superblock at the beginning of the
filesystem. There is a method to move the superblock at the end and
leave the system compatible with both OS?

There is a method to access only one disk from a Linux that don't known
raid arrays?

Why the implementation (that worked very well) has been changed to block
the easy use of the Linux Raid partitions (that was the real improvement
over all other raid solutions)?

We seriously think to remove the mdadm tool and recompile the old
version of the raidtool that worked better than mdadm but I don't known
if the new kernels supports it.

Thank-you.

Leopoldo Ghielmetti

