From: hpa@zytor.com (H. Peter Anvin)
Subject: Re: Raidreconf and raid-6
Date: Tue, 30 Mar 2004 22:24:25 +0000 (UTC)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <c4cs2p$p29$1@terminus.zytor.com>
References: <40603AE7.4050301@wasp.net.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Followup to:  <40603AE7.4050301@wasp.net.au>
By author:    Brad Campbell <brad@wasp.net.au>
In newsgroup: linux.dev.raid
>
> G'day all,
> 
> I'm in the middle of adding journaling to raidreconf to try and make it resilient to any failures
> except hard disk failures (Power fails, reboots and that kind of thing). It's not pretty, and it
> slows the process down something chronic but hopefully it will make the process bulletproof.
> 
> While I'm here I'm looking at trying to add raid-6 support also. I have had a pretty good trawl
> through the raid-6 kernel code and given raidreconf does not do anything with parity blocks it looks
> pretty similar to raid-5 from that respect.
> Are there any gotchas that anyone can think of I should look out for that may trip me up with the
> difference between raid5 & 6 ?
> 
> I figure if you could do an easy conversion between raid-5 and raid-6 it might speed up testing and
> adoption of raid-6.
> 

Indeed it would, and I would very much appreciate if you'd take this
on, since I'm personally in the middle of moving and not really having
a whole lot of time.

I presume the way raidreconf works is that it reads all the data off a
stripe in format-1 and than writes all the data back to the stripe in
format-2.  Since the disk format is inherently unstable during the
conversion it's pretty much the best you can do.

At that point all you need is to have the layout of the blocks, which
is similar to the way they are layed out in RAID-5, and an algorithm
to compute the Q syndromes.  There are two ways to accomplish the
latter: one way is to grab the portable C implementation (raid6int.uc)
from the kernel, and the other one is to use the fact that the
full-blown raid-6 implementation in the kernel can be compiled for
userspace testing as well, which would give you top performance.

Please keep me posted; I may not read this mailing list that often for
the next month or so since my Internet connectivity is kind of limited
at the moment.

	-hpa

