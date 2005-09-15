From: Neil Brown <neilb@suse.de>
Subject: Re: RAID6 on PowerPC is faulty
Date: Thu, 15 Sep 2005 14:44:37 +1000
Message-ID: <17192.64565.442838.126055@cse.unsw.edu.au>
References: <dgatfq$mrq$1@terminus.zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from H. Peter Anvin on Thursday September 15
Sender: linux-raid-owner@vger.kernel.org
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday September 15, hpa@zytor.com wrote:
> If you have been running RAID6 on a PowerPC with Altivec, your RAID is
> not two-disk redundant, due to bad Q syndrome computation.
> 
> It *is* one-disk redundant, however.
> 
> The following patch will fix it:
> 
> http://www.kernel.org/pub/linux/kernel/people/hpa/raid6-altivec-fix.patch
> 
> .. however, it will not correct an existing array without rewriting
> every stripe.
> 
> Neil, is there any way to force md to recompute all the syndromes?

mdadm --assemble --update=resync ....

should trigger a resync which should recalculate all P and Q (provided
your array isn't degraded).
This requires shutting the array down of course, but then so would
installing the patch.

I'm planning a feature whereby you can trigger a resync-like pass
which checks all redundancy and either report or reports-and-corrects
errors.  It's still a little way off though.

NeilBrown
