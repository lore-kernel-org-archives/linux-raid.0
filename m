From: "Eric Wood" <eric@interplas.com>
Subject: raid-1 with  ide-scsi emulation and mkswap failure
Date: Thu, 15 Apr 2004 09:51:19 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <007401c422f0$baec4bc0$b100000a@M145Primary>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I did Warren's RAID-1 howto:
http://togami.com/~warren/guides/remoteraidcrazies/
===========
1.  On this system I raid-1 /dev/hda and /dev/hdc together.

And I'm getting these errors during the copy process.
hdc: dma_intr: error=0x84 { DriveStatusError BadCRC }
hdc: dma_intr: status=0x51 { DriveReady SeekComplete Error }

Come to find out Fedore Core 1 put's the "ide-scsi" in the second ide
channel since I've got a CDRW there (hdd).  Doing a 'rmmod ide-scsi' took
care of all the dma errors and the copy process goes through fine.  So I
removed the "ide-scsi" from grub too.

I assume that ide-scsi on a same channel as a raid-1 member is a big no-no?
Maybe I should be putting raid devices on the same channel now so that dma
is at it's highest setting for both devices.
===========

===========
2. On another system with the same raid-1 setup, I'm getting kernel errors:
 kernel:  Unable to handle kernel NULL pointer dereference at virtual
address 00000015
 kernel:  printing eip:
 kernel: c0159772
 kernel: *pde = 04f30067
 kernel: *pte = 00000000
 kernel: Oops: 0000, etc. ,etc.

So I decided to redo the swap partition (which is ARRAY /dev/md3
devices=/dev/hdd3,/dev/hda3):

# swapoff -a
# mdadm --stop --scan
# sync; mkswap /dev/md3
mkswap: error: swap area needs to be at least 40kB
Usage: mkswap [-c] [-v0|-v1] [-pPAGESZ] /dev/name [blocks]

What I don't understand is that the 3rd partion of both drives which are
identical have 522112 blocks available:
# sfdisk -l /dev/hda

Disk /dev/hda: 4865 cylinders, 255 heads, 63 sectors/track
Units = cylinders of 8225280 bytes, blocks of 1024 bytes, counting from 0

  Device Boot Start     End   #cyls    #blocks   Id  System
/dev/hda1   *      0+     12      13-    104391   fd  Linux raid autodetect
/dev/hda2         13     904     892    7164990   fd  Linux raid autodetect
/dev/hda3        905     969      65     522112+  fd  Linux raid autodetect
/dev/hda4        970    4864    3895   31286587+  fd  Linux raid autodetect

# sfdisk -l /dev/hdd

Disk /dev/hdd: 4865 cylinders, 255 heads, 63 sectors/track
Units = cylinders of 8225280 bytes, blocks of 1024 bytes, counting from 0

  Device Boot Start     End   #cyls    #blocks   Id  System
/dev/hdd1   *      0+     12      13-    104391   fd  Linux raid autodetect
/dev/hdd2         13     904     892    7164990   fd  Linux raid autodetect
/dev/hdd3        905     969      65     522112+  fd  Linux raid autodetect
/dev/hdd4        970    4864    3895   31286587+  fd  Linux raid autodetect

I'll trying removing the swap line out of /etc/fstab and reboot, and try and
add it back but I have a feeling that won't work.  Any other ideas?
===========


-Eric Wood

