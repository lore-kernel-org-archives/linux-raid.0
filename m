From: pg@lxra2.to.sabi.co.UK (Peter Grandi)
Subject: Re: RAID5 Performance
Date: Wed, 3 Aug 2016 22:23:28 +0100
Message-ID: <22434.24784.805935.448459@tree.ty.sabi.co.uk>
References: <7b7d730f-2951-ba5f-7f6b-33624b59a02d@websitemanagers.com.au>
	<22424.50313.900162.715200@tree.ty.sabi.co.uk>
	<CAFx4rwSRYDACX631eLpX7Jr9jB2u4jbC7dr-0rdi9U1nV9og3Q@mail.gmail.com>
	<22425.63565.439521.592849@tree.ty.sabi.co.uk>
	<22426.2167.369879.756599@tree.ty.sabi.co.uk>
	<a0921a51-d841-7fbd-0f31-21f5ba8c6f4b@websitemanagers.com.au>
	<22426.16080.579831.750402@tree.ty.sabi.co.uk>
	<36cb010d-0b77-964e-fae5-5494e5f7766b@websitemanagers.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <36cb010d-0b77-964e-fae5-5494e5f7766b@websitemanagers.com.au>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

[ ... ]

> However, I can't get the budget for those really awesome
> drives up the top of the list, that would require around
> $20k... or more.

> For now, I've got 16 x 545s TB drives, and have replaced the
> first half (ie, all drives in one server). Now I can see that
> the drives themselves don't seem to be the bottleneck (the
> drives don't run at 100% util, while the DRBD device does run
> at 100%).

The "%util" number is not that easy to interpret, especially for
flash SSD and in some situations which probably include this
one:

  https://brooker.co.za/blog/2014/07/04/iostat-pct.html

> Hopefully that will line up right !

It is hard to read, and I don't understand what the numbers are,
but it does not matter a lot.

> So I can only presume the new drives are much better than the
> 530 series, but still not as good as the 520 series.

The 540s have an SLC write buffer as I mentioned previously,
which should help.

> However, the point of note is that DRBD devices are showing
> high util levels much more frequently than the underlying
> devices, so I can only assume that the current limitation is
> caused by DRBD rather than the drives.

I like guessing, but this assumptions seems to me a bit
excessive.

> From my understanding, the times these settings can cause a
> problem: [ ... ]

If you don't have reliable sync barriers at all levels (not just
DRBD) *any* crash (e.g. bug crash, mistake-crash, memory-full
crash, not just power crash) is going to cause massive trouble,
especially in a mostly-write workload where what is being
written is cache spill. Some interesting pages:

http://blog.2ndquadrant.com/intel_ssd_now_off_the_sherr_sh/
http://wiki.postgresql.org/wiki/Reliable_Writes
http://archive.is/WTeAE
https://news.ycombinator.com/item?id=6973179
http://lkcl.net/reports/ssd_analysis.html

>>> Do you have any other suggestions or ideas that might
>>> assist?

Another one that would likely give a bit of relief as you can't
budget for write-optimized "enterprise" flash SSDs is a SATA/SAS
host adapter with a very large battery-backed RAM buffer. As the
tests that I previously mentioned show, longer writes result in
much improved write rates on "consumer" flash SSD devices, and
hopefully the large buffer results in:

 #1 When the large write buffer flushes, *hopefully* much longer
    writes to the flash SSD will happen on average.

 #2 Thanks to the battery backing, writes are reporte completed
    to the OS when they reach the host adapter's buffer, rather
    than the flash SSD layer.

If #1 does not happen #2 won't help much if writes are at the
flash SSD saturation level, only if they are bursty and on
average below it.

>> * Smaller RAID5 stripes, as in 4+1 or 2+1, are cheaper in
>>   space than RAID10 and enormously raise the chances that a
>>   full stripe-write can happen (it still has the write-hole
>>   problem of parity RAID).

> I was planning to upgrade to the 4.4.x kernel, which would
> kind of solve this, [ ... ]

The write hole workaround in MD RAID relies on a mostly-write
journal device like for DRBD.

>> * Make sure the DRBD journal is also on a separate device
>>   that allows fast small sync writes.

> I think this would be the next option to investigate.
> Currently the DRBD journal is on the same devices.

That means that every sync'ed write becomes two writes to the
same device.

> 2 x P3700 400GB is probably around $2500,

The Samsung SM863 I ahve already mentioned are write-optimized
too and much cheaper, at around $300-350 for the 480GB model.

> while 12 x 545s 1000GB is around $4800, [ ... ]

Many people try to use "consumer" drives to build manager wowing
systems that have huge capacity and low cost, but vendors are not
stupid, and make sure that premium priced "enteprise" drives have
some critical advantage for at least some important workloads
(usually write heavy, guessing that "enterprise" workloads that
can command premium prices are transactional); sometimes like for
SSDs the advantages are based on real stuff, capacitors and
overprovisioning, which do cost money, sometimes artificial like
disabling SCT/ERC control.
