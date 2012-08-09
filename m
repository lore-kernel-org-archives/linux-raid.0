From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: RAID10 Performance
Date: Thu, 09 Aug 2012 17:37:00 -0500
Message-ID: <50243B8C.7040407@hardwarefreak.com>
References: <50115123.1020900@websitemanagers.com.au> <50123E2C.8090108@hardwarefreak.com> <50129176.3050604@websitemanagers.com.au> <5012DE22.10108@hardwarefreak.com> <50138853.5030100@websitemanagers.com.au> <50140657.8010802@hardwarefreak.com> <5021E1BC.3060607@websitemanagers.com.au> <50229B0D.5070201@hardwarefreak.com> <50230BB0.60509@websitemanagers.com.au>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <50230BB0.60509@websitemanagers.com.au>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Goryachev <mailinglists@websitemanagers.com.au>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 8/8/2012 8:00 PM, Adam Goryachev wrote:

> OK, what if we manage to do 4 x SSD's providing 960GB space in RAID10,
> this might be possible now, and then we can add additional SATA
> controller with additional SSD's when we need to upgrade further.

With SSD storage, latency goes to effectively zero and IOPS through the
roof.  Combined with the cost of SSD, parity RAID makes sense, even for
high IOPS workloads, as the RMW penalty is negligible.  So you'd want to
go with RAID5 and get 1.4TB of space.  The downside to this is md/RAID5
currently uses a single write thread, so under high IOPS load you'll
saturate one CPU core, and performance hits a brick wall, even if all
other cores are idle.  This is currently being addressed with various
patches in development.

> A slightly different question, is the reason you don't suggest SSD
> because you feel that it is not as good as spinning disks (reliability
> or something else?)

I don't suggest *consumer* SSDs for server workloads.  The 480GB units
you are looking at are consumer grade.

> It would seem that SSD would be the ideal solution to this problem
> (ignoring cost) in that it provides very high IOPS for random read/write
> performance. I'm somewhat suggesting SSD as the best option, but I'm
> starting to question that. I don't have a lot of experience with SSD's,
> though my limited experience says they are perfectly good/fast/etc...

Read about consumer vs enterprise grade SSD, status of Linux TRIM
support--block/filesystem layers, realtime vs batch discard, etc.

> I meant can't be changed on the current MD, ie, convert the existing MD
> device to a different chunk size.

Surely you already know the answer to this.

> We only have 5 available sata ports right now, so probably I will mostly
> follow what you just said (only change is to create new array with one
> missing disk, then after the dd, remove the two old drives, and add the
> 4th missing disk.

And do two massive data moving operations instead of one?  An array
build and a mirror sync instead of just an array build.  For this, and
other more important reasons, you should really get a new HBA for the 4
new Raptor drives.  The card plus one breakout cable runs $270 USD and
gives you 4 spare fast SAS/SATA ports for adding 4 more Raptor drives in
the future.  It's a bit faster than motherboard-down SATA ASICs in
general, and even more so under high IOPS/bandwidth workloads.

http://www.newegg.com/Product/Product.aspx?Item=N82E16816118112
http://www.newegg.com/Product/Product.aspx?Item=N82E16816116098

It also gives you the flexibility to keep the 2TB drives in the machine
for nearline/backup duty, etc, and leave 3 mobo ports available to
expand that.  You'll be much happier going this route.

> Actually, I always thought RAID1 was the most expensive RAID (since it
> halves capacity) and provided the best read performance. Am I really
> wrong :(

It's cheap because it only requires two drives.  All other RAID levels
require 3 or more, sans the quasi RAID configurations one or more of the
resident list idiots will surely retort with (rolls eyes).  Pure, i.e.
textbook original implementation, RAID1 read performance is the same as
a single drive.  md/RAID1 has a few tricks to increase read performance
on RAID1, but overall you won't get 2x read performance over a single
drive, not even close.

> Why doesn't the md driver "attempt" to balance read requests across both
> members of a RAID1? 

I'm not a kernel dev.  Ask Neil.

> Or are you saying it does attempt to, it just isn't
> guaranteed?

I was pretty clear.

> That is perfectly understandable on RAID0, since the data only exists in
> one place, so you MUST read it from the disk it exists on. You are
> optimizing how the data is spread by changing the chunk size/stripe
> size/etc, not where it CAN be read from.

You misunderstood my point.

> Finally, just to throw a really horrible thought into the mix... RAID5
> is considered horrible because you need to read/modify/write when doing
> a write smaller than the stripe size. 

This is true specifically of mechanical storage.  Creating a new stripe
with a partial width write is only one of multiple scenarios that will
cause an RMW.  In this case the RMW will occur later, when the
filesystem creates another small file(s) in the sectors of the stripe.
An RMW will occur immediately when modifying an existing file.

> Is this still a significant issue
> when dealing with SSD's, where we don't care about the seek time to do
> this? Or is RAID5 still silly to consider (I think it is)?

See up above.  Again, RAID5 is much more amenable to SSD due to the low
latency and high IOPS.  But with the current md/RAID5 single write
thread implementation, and a high write IOPS workload, you can easily
run out of CPU long before peaking the SSDs.  This is true of md/RAID
1/6/10 as well, but again is being addressed in development.  Currently
for maximum SSD write performance you need to use md/RAID0 or linear, as
both fully thread across all CPUs/cores.

-- 
Stan

