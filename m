From: Aaron Longfield <aaron@wire-head.org>
Subject: Mounting Promise RAID0 w/ Linux software RAID
Date: Thu, 01 Jul 2004 08:39:50 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <40E40616.8000004@wire-head.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I am trying to recover data from a stripe set (RAID0) that was written 
using the sort-RAID functions of a Promise UDMA-133 Fasttrak controller. 
    The mainboard with that controller has died, and I don't have 
another one around to try to run the discs on!

I've been able to start and mount the array, but I think I'm only 
getting the first stripe or something that's on the first disc.

I know the stripe size had been 64kb and there were two discs in the 
array.  The first disc has a proper partition table, but it's for the 
full array, as would be on a Linux md device.  I'm having trouble 
figuring how I would even try to specify this...

Does anyone happen to have any suggestions on this one?  I don't want to 
have the scrap the data, or buy another piece of hardware with one of 
those controllers on it!

Here's the partition tables:

	Disk /dev/hdl: 122.9 GB, 122942324736 bytes
	255 heads, 63 sectors/track, 14946 cylinders
	Units = cylinders of 16065 * 512 = 8225280 bytes

	   Device Boot    Start       End    Blocks   Id  System
	/dev/hdl1   *         1     29893 240115491    7  HPFS/NTFS

	Disk /dev/hdj: 122.9 GB, 122942324736 bytes
	16 heads, 63 sectors/track, 238216 cylinders
	Units = cylinders of 1008 * 512 = 516096 bytes

	Disk /dev/hdj doesn't contain a valid partition table

And here's the raidtab:

raiddev /dev/md2
         raid-level              0
         nr-raid-disks           2
         persistent-superblock   0
         chunk-size              64

         device                  /dev/hdl1
         raid-disk               0
         device                  /dev/hdj
         raid-disk               1
