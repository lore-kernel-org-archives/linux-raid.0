From: Aaron Longfield <aaron@wire-head.org>
Subject: Partitioning on RAID (Ref: Mounting Promise RAID0 w/ Linux software
 RAID)
Date: Thu, 01 Jul 2004 12:01:56 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <40E43574.5050802@wire-head.org>
References: <40E40616.8000004@wire-head.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <40E40616.8000004@wire-head.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I found that I can combine the discs raw into one large array that maps 
properly.  Problem is that now I have an array that has a partition 
table and a partition that I can't seem to mount.  Is there any way to 
coax the system into letting me do this?  I couldn't find any 
documentation on it, but there seems to be support in the kernel code 
for the md driver.

-Aaron Longfield

Partition on the array:

Disk /dev/md0: 245.8 GB, 245884649472 bytes
255 heads, 63 sectors/track, 29893 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes

     Device Boot	     Start	   End	    Blocks    Id  System
/dev/md0p1   *		 1	 29893	 240115491     7  HPFS/NTFS


raidtab entry:

raiddev /dev/md0
	raid-level		0
	nr-raid-disks		2
	persistent-superblock	0
	chunk-size		64

	device			/dev/hdc
	raid-disk		0
	device			/dev/hdd
	raid-disk		1
