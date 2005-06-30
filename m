From: Gil <gil@fooplanet.com>
Subject: Re: Hung rebuilding
Date: Thu, 30 Jun 2005 09:25:18 -0700
Message-ID: <42C41CEE.6020602@fooplanet.com>
References: <20050630134537.GA14145@casa.e-den.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20050630134537.GA14145@casa.e-den.it>
Sender: linux-raid-owner@vger.kernel.org
To: Sandro Dentella <sandro@e-den.it>
Cc: Linux Raid List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> Jun 30 14:40:31 srv-ornago kernel: hda: dma_intr: status=0x51 {
> DriveReady SeekComplete Error } Jun 30 14:40:31 srv-ornago
> kernel: hda: dma_intr: error=0x40 { UncorrectableError },
> LBAsect=15584452, sector=4194304 Jun 30 14:40:31 srv-ornago
> kernel: end_request: I/O error, dev 03:07 (hda), sector 4194304

This sequence usually indicates a bad block on the media.  If you
have enabled SMART on your disks, you can confirm this with

    smartctl -l error /dev/hda

You'll see a bunch of UNC errors.

> Jun 30 14:40:31 srv-ornago kernel: ide0(3,7):sh-2029: reiserfs
> read_bitmaps: bitmap block (#524288) reading failed Jun 30
> 14:40:31 srv-ornago kernel: ide0(3,7):sh-2014:
> reiserfs_read_super: unable to read bitmap

Worse yet it appears that your bad block contains a part of the
reiserfs superblock which would be why you can't mount the filesystem.

At first blush it would appear that the bad block is preventing the
resync from happening, but I'm no expert in the reading of mdadm -D.

>       srv-ornago:~# mdadm -D /dev/md3
>       /dev/md3:
> 	      Version : 00.90.00
> 	Creation Time : Wed Dec  8 12:28:15 2004
> 	   Raid Level : raid1
> 	   Array Size : 74340672 (70.90 GiB 76.12 GB)
> 	  Device Size : 74340672 (70.90 GiB 76.12 GB)
> 	 Raid Devices : 2
> 	Total Devices : 2
>       Preferred Minor : 3
> 	  Persistence : Superblock is persistent
>
> 	  Update Time : Thu Jun 30 12:53:14 2005
> 		State : dirty, degraded, recovering
>        Active Devices : 1
>       Working Devices : 2
>        Failed Devices : 0
> 	Spare Devices : 1
>
>        Rebuild Status : 0% complete
>
> 		 UUID : 1ea38e0e:050ac659:7e84e367:2d256edd
> 	       Events : 0.171
>
> 	  Number   Major   Minor   RaidDevice State
> 	     0       0        0        0      faulty removed
> 	     1      22        7        1      active sync
> /dev/ide/host0/bus1/target0/lun0/part7
>
> 	     2       3        7        2      spare rebuilding
> /dev/ide/host0/bus0/target0/lun0/part7


I'm confused by this because your I/O error is on hda according to
the kernel output, but hda should be the disk onto which the rebuild
would be writing.

>    Jun 30 14:33:48 srv-ornago kernel: md: cannot remove active
> disk ide/host0/bus0/target0/lun0/part7 from md3 ...

However, this error message seems to say that hda is, in fact, a
part of the array.

Someone with better mdadm -D kung-fu: what are your thoughts?

--Gil
