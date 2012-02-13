From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: XFS on top RAID10 with odd drives count and 2 near copies
Date: Mon, 13 Feb 2012 07:46:46 -0600
Message-ID: <4F391446.4060308@hardwarefreak.com>
References: <CAGqmV7o7AQFY1K-1JLDk02Cv6GpAUQFjiSdM2Wbdbu6Zh_t0Wg@mail.gmail.com> <4F35E925.6000003@hardwarefreak.com> <CAGqmV7rBa39U-RWkzH-cTci1pNrrY1sfS=DkyK1wHE80bMt6qA@mail.gmail.com> <4F38CEE2.6000701@westcontrol.com>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F38CEE2.6000701@westcontrol.com>
Sender: linux-raid-owner@vger.kernel.org
To: David Brown <david@westcontrol.com>
Cc: CoolCold <coolthecold@gmail.com>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 2/13/2012 2:50 AM, David Brown wrote:

> It is also far from clear whether a linear concat XFS is better than a
> normal XFS on a raid0 of the same drives (or raid1 pairs).  I think it

As always the answer depends on the workload.  As you correctly stated
above (I snipped it) you'll end up with less head seeks with the linear
array than with the RAID0.  How many less depends on the workload,
again, as always.

I need to correct something I stated in my previous post that's relevant
here.  I forgot that the per drive read_ahead_kb value is ignored when a
filesystem resides on an md device.  Read ahead works at the file
descriptor level, not at the block device level.  So when using mdraid
the read_ahead_kb value of the md device is used and the per drive
settings are ignored.  Thus kernel read ahead efficiency doesn't suffer
on striped mdraid as I previously stated.  Apologies for the error.

> will have lower average latencies on small accesses if you also have big
> reads/writes mixed in, but you will also have lower throughput for
> larger accesses.  For some uses, this sort of XFS arrangement is ideal -
> a particular favourite is for mail servers.  But I suspect in many other
> cases you will stray enough from the ideal access patterns to lose any
> benefits it might have.

Yeah, if one will definitely have a mixed workload including
reading/writing sufficiently large files (more than a few MB) where
striping would be of benefit, then using RAID0 over mirror would be
better.  Once you go there though you may as well go RAID10 with a fast
layout, unless your workload is such that a single md thread eats a CPU.
 Then the layered RAID0 over mirror may be a better option.

> Stan is the expert on this, and can give advice on getting the best out
> of XFS.  But personally I don't think a linear concat there is the best
> way to go - especially when you want LVM and multiple filesystems on the
> array.

I'm no XFS expert.  The experts are the devs.  As far as users go, I
probably know some of the XFS internals and theory better than many others.

For the primary workload as stated, XFS over linear is a perfect fit.
WRT doing thin provisioning with virtual machines on this host, using
sparse files to create virtual disks for the VMs and the like, I'm not
sure how well that would work on a linear array with a single XFS
filesystem.  As David mentions, I def wouldn't put multiple XFS
filesystems on the array, with or without LVM.  This can lead to excess
head seeking, and you don't have the spindle RPM for lots of seeks.

WRT sparse file virtual disks, it would depend alot on the IO access
patterns of the VM guests and their total IO load.  If it's minimal then
the XFS + linear would be fine.  If the guests do a lot of IO, and their
disk files all end up in the same AG, that wouldn't be so good.  Without
more information it's hard to say.

> As another point, since you have mostly read accesses, you should
> probably use raid10,f2 far layout rather than near layout.  It's a bit
> slower for writes, but can be much faster for reads.

Near.. far.. whereeeeever you are...

Neil must have watched Titanic just before he came up with these labels. ;)

-- 
Stan

