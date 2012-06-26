From: "Stefan G. Weichinger" <lists@xunil.at>
Subject: Re-adding disks to RAID6 in a Fujitsu NAS: old mdadm?
Date: Tue, 26 Jun 2012 15:57:21 +0200
Message-ID: <4FE9BFC1.5070607@xunil.at>
Reply-To: lists@xunil.at
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Greets,

I currently try to re-add 2 disks to a RAID6 array.

There were 4 disks in a Fujitsu Q800 NAS, the RAID6 was done via WebGUI.

2 disks have been removed from the array and I am not able to re-add the
old disks or add new disks via WebGUI.

The support told me to "re-insert disks, if it doesn't work, rebuild
array" ... cool. What do I need a RAID for then ??

Anway.

Entered hacking mode ;-) at least in my terms.

sshed into box.

To get it short:

Currently the RAID6 array /dev/md0 is:

md0 : active raid6 sdc3[2] sdd3[3]
      3903891200 blocks level 6, 64k chunk, algorithm 2 [4/2] [__UU]

So I would like to re-add sda3 and sdb3 ...

I get:

# mdadm /dev/md0 -a /dev/sda3
mdadm: /dev/sda3 not large enough to join array

oops!

But the comparison shows:

[~] # fdisk -l /dev/sda

Disk /dev/sda: 2000.3 GB, 2000398934016 bytes
255 heads, 63 sectors/track, 243201 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes

   Device Boot      Start         End      Blocks   Id  System
/dev/sda1               1          66      530125   83  Linux
/dev/sda2              67         132      530142   83  Linux
/dev/sda3             133      243138  1951945693   83  Linux
/dev/sda4          243139      243200      498012   83  Linux

[~] # fdisk -l /dev/sdc

Disk /dev/sdc: 2000.3 GB, 2000398934016 bytes
255 heads, 63 sectors/track, 243201 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes

   Device Boot      Start         End      Blocks   Id  System
/dev/sdc1               1          66      530125   83  Linux
/dev/sdc2              67         132      530142   83  Linux
/dev/sdc3             133      243138  1951945693   83  Linux
/dev/sdc4          243139      243200      498012   83  Linux

-> identical partitions

---

Could that relate to this issue:

http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=500309

The NAS seems to run some ubuntu:

# cat /proc/version
Linux version 2.6.33.2 (root@NasX86-5) (gcc version 4.1.3 20070929
(prerelease) (Ubuntu 4.1.2-16ubuntu2)) #1 SMP Mon Sep 13 04:28:32 CST 2010

and brings an older mdadm:

# mdadm --version
mdadm - v2.6.3 - 20th August 2007


If that is the issue, is there a way to use some newer binary (magically
transferred to me by mail or URL ;-) ) of mdadm to re-add disks?

I would really really like to avoid to rebuild that array ...

Thanks in advance, looking forward to your hints, Stefan!
