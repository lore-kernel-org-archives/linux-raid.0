From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: RAID10 Performance
Date: Fri, 27 Jul 2012 13:29:54 -0500
Message-ID: <5012DE22.10108@hardwarefreak.com>
References: <50115123.1020900@websitemanagers.com.au> <50123E2C.8090108@hardwarefreak.com> <50129176.3050604@websitemanagers.com.au>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <50129176.3050604@websitemanagers.com.au>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Goryachev <mailinglists@websitemanagers.com.au>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 7/27/2012 8:02 AM, Adam Goryachev wrote:
> On 27/07/12 17:07, Stan Hoeppner wrote:

>> 1.  Recreate the arrays with 6 or 8 drives each, use a 64KB chunk
> 
> Would you suggest these 6 - 8 drives in RAID10 or some other RAID
> level? (IMHO, the best performance with reasonable protection is RAID10)

You're running many VMs.  That implies a mixed read/write workload.  You
can't beat RAID10 for this workload.

> How do you get that many drives into a decent "server"? I'm using a
> 4RU rackmount server case, but it only has capacity for 5 x hot swap
> 3.5" drives (plus one internal drive).

Given that's a 4U chassis, I'd bet you mean 5 x 5.25" bays with 3.5" hot
swap carriers.

In that case, get 8 of these:
http://www.newegg.com/Product/Product.aspx?Item=N82E16822148710

and replace two carriers with two of these:
http://www.newegg.com/Product/Product.aspx?Item=N82E16817994142

Providing the make/model of the case would be helpful.

>> 2.  Replace the 7.2k WD drives with 10k SATA, or 15k SAS drives
> 
> Which drives would you suggest? The drives I have are already over
> $350 each (AUD)...

See above.  Or you could get 6 of these:
http://www.newegg.com/Product/Product.aspx?Item=N82E16822236243

>> 3.  Replace the drives with SSDs
> 
> Yes, I'd love to do this.
> 
>> Any of these 3 things will decrease latency per request.
> 
> I have already advised adding an additional pair of drives, and
> converting to SSD's.
> 
> Would adding another 2 identical drives and configuring in RAID10
> really improve performance by double?

No because you'd have 5 drives and you have 3 now.  With 6 drives total,
yes, performance will be doubled.  And BTW, there is no such thing as an
odd number of drives RAID10.  That's actually more akin to RAID1E.  It
just happens that the md/RAID driver that provides it is the RAID10
driver.  You want an even number of drives. Use a standard RAID10
layout, not "near" or "far" layouts.

> Would it be more than double (because much less seeking should give
> better throughput, similar I expect to performance of two concurrent
> reads is less than half of a single read)?

It's not throughput you're after, but latency reduction.  More spindles
in the stripe, or faster spindles, is what you want for a high
concurrency workload, to reduce latency.  Reducing latency will increase
the responsiveness of the client machines, and, to some degree
throughput, because the array can now process more IO transactions per
unit time.

> If using SSD's, what would you suggest to get 1TB usable space?
> Would 4 x Intel 480GB SSD 520 Series (see link) in RAID10 be the best
> solution? Would it make more sense to use 4 in RAID6 so that expansion
> is easier in future (ie, add a 5th drive to add 480G usable storage)?

I actually wouldn't recommend SSDs for this server.  The technology is
still young, hasn't been proven yet for long term server use, and the
cost/GB is still very high, more than double that of rust.

I'd recommend the 10k RPM WD Raptor 1TB drives.  They're sold as 3.5"
drives but are actually 2.5" drives in a custom mounting frame, so you
can use them in a chassis with either size of hot swap cage.  They're
also very inexpensive given the performance plus capacity.

I'd also recommend using XFS if you aren't already.  And do NOT use the
metadata 1.2 default 512KB chunk size.  It is horrible for random write
workloads.  Use a 32KB chunk with your md/RAID10 with these fast drives,
and align XFS during mkfs.xfs using -d options su/sw.

> PS, thanks for the reminder that RAID10 grow is not yet supported, I
> may need to do some creative raid management to "grow" the array,
> extended downtime is possible to get that done when needed...

You can grow a RAID10 based array:  join 2 or more 4 drive RAID10s in a
--linear array.  Add more 4 drive RAID10s in the future by growing the
linear array.  Then grow the filesystem over the new space.

-- 
Stan


