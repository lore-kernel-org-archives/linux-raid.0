From: Neil Brown <neilb@suse.de>
Subject: Re: How to grow RAID1 mirror on top of LVM?
Date: Sun, 4 May 2008 21:20:57 +1000
Message-ID: <18461.39961.921994.904814@notabene.brown>
References: <25F8EF57-9606-4217-B2D4-2DD3D8E064C4@cam.ac.uk>
	<18408.36712.100712.499844@notabene.brown>
	<20080428162556.00ee0d72.taeuber@bbaw.de>
	<18458.34575.416075.798546@notabene.brown>
	<1209740806.4319.26.camel@russ-ifl90>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Russ Hammer on Friday May 2
Sender: linux-raid-owner@vger.kernel.org
To: Russ Hammer <russ@perneus.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday May 2, russ@perneus.com wrote:
> 
> My plan basically was:
> 
> # remove one small disk
> /sbin/mdadm /dev/md0 --fail /dev/sdb1
> /sbin/mdadm /dev/md0 --remove /dev/sdb1
> 
> # shutdown and swap in large disk
> # (with larger partition for the RAID1 component)
> # add large drive into array
> /sbin/mdadm /dev/md0 --add /dev/sdb1
> 
> # Allow the array to resync
> # remove the remaining small drive
> /sbin/mdadm /dev/md0 --fail /dev/sda1
> /sbin/mdadm /dev/md0 --remove /dev/sda1
> 
> # Grow the array
> /sbin/mdadm -G /dev/md0 -z max
> 
> # shutdown and swap in second large disk
> # (with larger partition for the RAID1 component)
> # add in the second large drive
> /sbin/mdadm /dev/md0 --add /dev/sda1
> 
> My concern (based on this discussion) is that this will fail because I
> am changing the size of the partition underlying the RAID1 array, much
> like the LVM discussion above, while using ver 0.90 superblock.
> 
> Do I have a legitimate concern??

Your recipe is perfect.  You need not be concerned.

You are *not* changing the size of the partition underlying the RAID1
array.  When you change the size of a partition, it is not part of the
array at that time.  It has no superblock on it, so there is no room
to be confused.

If you were to make a small partition on the new sdb, add that to the
array, then change the partition table to make sdb1 bigger, that would
cause confusion.
However as you are making sdb1 nice and be before including it in the
array, everything should work perfectly.

The only possible problem area in your recipe is if the drives are not
actually identical (not all 750GB drive have the same number of
blocks), the array you get with the -G command might be too big to
allow the partition you create on the new sda.  However if the drives
do have exactly the same number of sectors, this will not be a problem.

NeilBrown


