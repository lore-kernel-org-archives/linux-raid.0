From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: Which raid card to buy for Sarge
Date: Thu, 1 Apr 2004 00:29:33 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200404010529.i315TbW21661@dns1.watkins-home.com>
References: <406B9F3E.4020701@wasp.net.au>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <406B9F3E.4020701@wasp.net.au>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have hot swapped software RAID disks, and re-synced without a re-boot.
Another time the system had a disk failure and re-synced to the hot spare.
I was there and using the system and never knew until the next day.
So, very little performance impact.

With software RAID (md) you must invoke some commands to do the hot swap.
It's not auto-magic.  Some of the hardware RAID systems I know of don't need
any user input to re-sync.  Just swap the bad disk for a good one.

It would be nice if md could detect a disk being replaced and do everything
needed without user input.
BUT!!  md has a big difference on that point.
md does not mirror disks!
Read the above line again!

md mirrors partitions.  I think it is a major difference.  You must
partition the disk that is replacing the failed disk.  A hardware RAID
system usually (maybe always) works on the whole disk.  Since md only works
on partitions it makes having a hot spare a real pain.  I have 2 disk that
make up "/boot" and "/".  Each are mirrored using these 2 disks.  I also
have 14 disks in a RAID5 array.  I have 1 spare.  The spare is configured
with 1 partition.  It is a spare for the RAID5 array.  It can't spare for
the other 2 disks since they have 2 partitions.

Guy

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Brad Campbell
Sent: Wednesday, March 31, 2004 11:49 PM
To: linux-raid@vger.kernel.org
Subject: Re: Which raid card to buy for Sarge

Mark Hahn wrote:
>>If would not use the "raid" feature of the Highpoint cards, because it is
only 
>>software raid and not so performant as a hardware raid. If you don't need
a 
> 
> 
> please don't say things like this.  HW raid is *NOT* generally
> faster or better than software raid.  yes, if you're building a 
> quad-gigabit fileserver out of an old P5/100 you had sitting around,
> you're not even going to start looking at sw raid.

One point. Hardware raid (and faux hardware raid) provides real hot swap
with on-the-fly rebuilds.
Linux software raid can't (yet).
Both promise and highpoint proprietary ide raid drivers can, but no raw
kernel or libata drivers can 
as yet, and the interface between the hotswap driver and md driver is no
where near there.

With the Highpoint driver I get a drive failure and the card starts beeping.
I fire up the 
management util, remove the faulty drive, swap it out and insert the new
drive in the array. The 
array starts rebuilding - no effect on the uptime and only a slight loss in
throughput. Plus it's 
seamless.

I used a pair of Highpoint Rocketraid 1540 cards with the Highpoint driver
(as it presented all 8 
drives as 8 units on a scsi chain) with linux md raid-5, and I have now
moved onto 3 Promise 
SATA150-TX4 units in an md raid-5.

I did play with the highpoint raid-5 (which can now span controllers) and
it's management features, 
hotswap and hot-rebuild were quite good.

Not that I'm advocating hardware or faux hardware raid, just noting that
linux software raid still 
has a large deficiency.

Regards,
Brad
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html


