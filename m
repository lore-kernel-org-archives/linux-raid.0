From: "Martin Bene" <martin.bene@icomedias.com>
Subject: AW: Raid 1 vs 5 ?
Date: Fri, 7 May 2004 07:10:20 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <FA095C015271B64E99B197937712FD0227A85D@freedom.grz.icomedias.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
To: LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> Which one is the better choice and what are the trade offs? Or is
> another configuration more sensible? I'm under the impression that you
> shouldn't (can't?) boot from RAID 5.

Depends very much on what you're going to do with the system - I've
found a high performnce impact of raid5 for database applicaions with
frequent updates (where you end up with lots of small writes scattered
allover the partition). If write speed isn't too important, the space
savings may well make raid5 more attractive.

True, you can't boot directly off raid5, but you can have a /boot on
raid1 and the rest of the system on raid5. Also, you definitely should
consider putting swap on raid1: otherwise a failure of the swap disk
will bring you system down.(don't put swap on raid5 - same performance
issue as mentioned above.)

A minimal configuration for 4 disks optimized for max space could be
like this, though you might want seperate raid5s for /, /usr, /var.  

Each disk partitioned alike:
	1	30MB 
	2	1/2 size_of_swap_
	5	rest_of_disk

Now you can create mds on the disk:
	md0	raid1 sda1 sda2 sda3 sda4
	md1	raid1 sda1 sdb1
	md2	raid1 sdc1 sdd1
	md3	raid5 sda5 sdb5 sdc5 sdd5

	md0	/boot
	md1	swap
	md2	swap
	md3	/

You've got a small 4-disk raid1 as /boot, so each of our disks can be
bootable.
Swap is on 2 2-disk raid1 partitions so your system can survive failure
of a disk used for swap.
Main data storage is on 4-disk raid5.

Bye, Martin
