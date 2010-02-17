From: Neil Brown <neilb@suse.de>
Subject: Re: Map Block number from hdd to md
Date: Thu, 18 Feb 2010 10:47:55 +1100
Message-ID: <20100218104755.5c03a8b9@notabene.brown>
References: <7362c3826262551b46e9b0bb1a777633@rw23.de>
	<20100216122014.18696241@notabene.brown>
	<84f3bb2dd3f8170f1e80df476770bdb5@rw23.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <84f3bb2dd3f8170f1e80df476770bdb5@rw23.de>
Sender: linux-raid-owner@vger.kernel.org
To: Michael <michael@rw23.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 16 Feb 2010 12:14:38 +0100
Michael <michael@rw23.de> wrote:

> On Tue, 16 Feb 2010 12:20:14 +1100, Neil Brown <neilb@suse.de> wrote:
> >> is there any method to find that bad block in context of the raid block
> >> device? reading all files is not a good option on large raidsets.
> >> level 5, 64k chunk, algorithm 2
> > 
> > It isn't that hard.  The code is in drivers/md/raid5.c in the
> kernel.....
> > 
> > Rather than trying to describe in general, give me the block number,
> > device,
> > and "mdadm --examine" of that device, and I'll tell you how I get the
> > answer.
> 
> 
> the bad block number was 122060740 sec.
> 
> [root@raw sqla]mdadm --examine /dev/sda3
> /dev/sda3:
>           Magic : a92b4efc
>         Version : 0.91.00
>            UUID : 9815a2c6:c83a9a53:2a8015ce:9d8e5e8c (local to host raw)
>   Creation Time : Thu Feb 11 16:01:12 2010
>      Raid Level : raid6
>   Used Dev Size : 966060672 (921.31 GiB 989.25 GB)
>      Array Size : 2898182016 (2763.92 GiB 2967.74 GB)
>    Raid Devices : 5
>   Total Devices : 5
> Preferred Minor : 2
> 
>   Reshape pos'n : 974014464 (928.89 GiB 997.39 GB)
>      New Layout : left-symmetric
> 
>     Update Time : Tue Feb 16 11:58:37 2010
>           State : clean
>  Active Devices : 5
> Working Devices : 5
>  Failed Devices : 0
>   Spare Devices : 0
>        Checksum : 16372b12 - correct
>          Events : 363519
> 
>          Layout : left-symmetric-6
>      Chunk Size : 64K

So...
There is no Data Offset give, so it is zero.  so the block is 122060740
sectors into the data area of the devices.
Chunksize if 64k (128 sectors), so 
122060740 / 128 == 953599 remainder 68.
So Stripe number 953599, and sector 68 of device '2' of that stripe.

A stripe had 4 disks when raid5, 5 when raid6, so 3 data drives.
So stripe 953599 is 953599 * 3 * 128 sectors from the start of the
array. i.e. 366182016 sectors.

In the raid5 layout:
4 drives, so 4 different stripe layouts.
953599 % 4 == 3, so it is layout 3 (of 0, 1, 2, 3).
Looking at the code in raid5.c for LEFT_SYMMETRIC 
The parity disk is disk 0. The data disks follow that,
so device '2' holds data chunk '1'.
So we add 1 full chunk plus the 68 sectors of the partial chunk.
i.e. that sector is 366182016 + 128 + 68
 or sector 366182212 in the array.

After the conversion to RAID6, there are 5 drives so 5 stripe layouts.
953599 % 5 == 4, so layout 4
So 'P' is device 0, 'Q' is device 1, D0 is device 2 etc.
So sda3 is the first data disk in the stripe, so there are no full stripes to
add, just the partial stripe.
366182016 + 68 == 366182084


> 
>       Number   Major   Minor   RaidDevice State
> this     2       8        3        2      active sync   /dev/sda3
> 
>    0     0       8       35        0      active sync   /dev/sdc3
>    1     1       8       51        1      active sync   /dev/sdd3
>    2     2       8        3        2      active sync   /dev/sda3
>    3     3       8       83        3      active sync   /dev/sdf3
>    4     4       8       99        4      active   /dev/sdg3
> 
> thank you.
> 
> iam currently reshaping my raid5 to a raid6.
> 
> i want to give you a note that i have had the "too-old metadata" problem
> with "mdadm - v3.1.1 - 19th November 2009"
> commenting out that check started my array again. i thought this should
> have been fixed in that version? 

I thought so too.  I'll have to have another look.

> 
> what is the right way to stop the reshaping process? kill <pid of mdadm
> --grow/assemble> and then mdadm --stop /dev/mdX or just mdadm --stop
> /dev/mdX without killing?

Don't kill things.  Just --stop the array.

> 
> other question: what happens when a operating raid5/6 encounters a bad
> block at read time? does it just mark the corresponding devices as faild?

A read error only causes the device to be failed if the array is degraded.
If the array is not degraded, md tries to recover the data and write it back
out.  If this fails, then the device is failed.


> 
> > If you were desperate, you could use 'dd' to read each of the chunks
> into a
> > file, then write a little c/perl/whatever program to xor those files
> > together, then use 'dd' to write that file back out the the target
> chunk.
> > 
> > NeilBrown
> 
> sounds easy so far. mapping blocks to chunks is also easy? and what to do
> in a raid6 case?

Much the same - it is just the finally mapping within a stripe that is
interesting ... look at the code :-)

NeilBrown
