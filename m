From: Mark Hahn <hahn@physics.mcmaster.ca>
Subject: Re: RAID5 crash and burn
Date: Sun, 31 Oct 2004 14:41:08 -0500 (EST)
Message-ID: <Pine.LNX.4.44.0410311434240.17633-100000@coffee.psychology.mcmaster.ca>
References: <4184EE8C.2020408@ndietsch.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4184EE8C.2020408@ndietsch.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> If you are seriously considering the performance implications of RAID1 
> vs RAID5 for swap, you are already done for performance wise.

I disagree.  the whole point of Linux's approach to swap is that 
it's fairly cheap to write a page to swap.  whether you ever need 
it again depends on how overcommitted you are.  this is assuming that
the kernel successfully chooses not-likley-to-be-reused pages to 
write to swap, and that your swap partitions are reasonably fast 
to write to.  this approach works very well, excepting heuristic problems
in certain kernel versions.

in other words, reading from swap is permitted to be expensive,
since any disk read is always assumed to be slow.  but writing to 
swap really should be fairly cheap, and this is a premise of the 
kernel's swap policies.

I would not use raid5 swap for this reason; raid1 is not insane,
since you don't need *that* much swap space, so the 50% overhead 
is not crippling.  (don't even think about things like raid 10
for swap - the kernel already has zero-overhead swap striping.)

regards, mark hahn.

