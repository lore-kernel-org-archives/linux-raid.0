From: Neil Brown <neilb@suse.de>
Subject: Re: Interesting RAID checking observations
Date: Mon, 28 Aug 2006 11:04:35 +1000
Message-ID: <17650.16675.561765.886119@cse.unsw.edu.au>
References: <20060827064644.26795.qmail@science.horizon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from linux@horizon.com on  August 27
Sender: linux-raid-owner@vger.kernel.org
To: linux@horizon.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On  August 27, linux@horizon.com wrote:
> Two discoveries: first, I locked up my machine, and second, it's surprisingly
> slow.
...
> 
> I think this is a "duh! that's why seed_limit_max is there" thing,
> but I didn't expect it to saturate the processor before the drives.
> 

I don't think the processor is saturating.  I've seen reports of this
sort of thing before and until recently had no idea what was happening,
couldn't reproduce it, and couldn't think of any more useful data to
collect.
I think I may have recently stumbled across the problem though.
md doesn't support 'bdi_write_congested' simply because I never knew
about it until recently.
This means that when the VM is trying to gently flush out dirty memory
is checks to see if an MD device is congested, sees (wrongly) that it
isn't, and happily try to write data to it.  But if it really is
congested (e.g. because a resync is using up all the bandwidth so the
device queues are full), the VM blocks when it doesn't expect to.
I'm not sure exactly how that translates into the machine being
unresponsive, but it wouldn't surprise me.  I'll try to post a patch
for that to linux-raid in a soonish.

How much RAM does this system have?


> 
> Second, trying checks on a fast (2.2 GHz AMD64) machine, I'm surprised
> at how slow it is:
> 
> md4 : active raid10 sdf3[4] sde3[3] sdd3[2] sdc3[1] sdb3[0] sda3[5]
>       131837184 blocks 256K chunks 2 near-copies [6/6] [UUUUUU]
>       [==================>..]  resync = 90.5% (119333248/131837184) finish=4.2min speed=48628K/sec
> 
> This is 6 ST3400832AS 400 GB SATA drives, each capable of 60 MB/s
> sustained, on Sil3132 PCIe controllers with NCQ enabled.  I measured
> > 300 MB/sec sustained aggregate off a temporary RAID-0 device during
> installation.
> 
> RAID-5 is even slower:
> md5 : active raid5 sdf4[5] sde4[4] sdd4[3] sdc4[2] sdb4[1] sda4[0]
>       1719155200 blocks level 5, 64k chunk, algorithm 2 [6/6] [UUUUUU]
>       [>....................]  resync =  2.4% (8401536/343831040) finish=242.9min speed=23012K/sec
> 

Again, you aren't the first to report this.  I haven't seen it myself,
but my regular test machine is busy at the moment.  I'll try to
organise some testing soon.

Thanks for the reports.

NeilBrown
