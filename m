From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH 00/19] Hardware Accelerated MD RAID5: Introduction
Date: Wed, 11 Oct 2006 12:44:49 +1000
Message-ID: <17708.23201.992343.810034@cse.unsw.edu.au>
References: <1158015632.4241.31.camel@dwillia2-linux.ch.intel.com>
	<17705.31033.706571.150023@cse.unsw.edu.au>
	<e9c3a7c20610101123t5e763297i1f0525893f6f11b6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Dan Williams on Tuesday October 10
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, christopher.leech@intel.com
List-Id: linux-raid.ids

[dropped akpm from the Cc: as current discussion isn't directly
relevant to him]
On Tuesday October 10, dan.j.williams@intel.com wrote:
> On 10/8/06, Neil Brown <neilb@suse.de> wrote:
> 
> > Is there something really important I have missed?
> No, nothing important jumps out.  Just a follow up question/note about
> the details.
> 
> You imply that the async path and the sync path are unified in this
> implementation.  I think it is doable but it will add some complexity
> since the sync case is not a distinct subset of the async case.  For
> example "Clear a target cache block" is required for the sync case,
> but it can go away when using hardware engines.  Engines typically
> have their own accumulator buffer to store the temporary result,
> whereas software only operates on memory.
> 
> What do you think of adding async tests for these situations?
> test_bit(XOR, &conf->async)
> 
> Where a flag is set if calls to async_<operation> may be routed to
> hardware engine?  Otherwise skip any async specific details.

I'd rather try to come up with an interface that was equally
appropriate to both offload and inline.  I appreciate that it might
not be possible to get an interface that gets best performance out of
both, but I'd like to explore that direction first.

I'd guess from what you say that the dma engine is given a bunch of
sources and a destination and it xor's all the sources together into
an accumulation buffer, and then writes the accum buffer to the
destination.  Would that be right?  Can you use the destination as one
of the sources?

That can obviously be done inline too with some changes to the xor
code, and avoiding the initial memset might be good for performance
too. 

So I would suggest we drop the memset idea, and define the async_xor
interface to xor a number of sources into a destination, where the
destination is allowed to be the same as the first source, but
doesn't need to be.
Then the inline version could use a memset followed by the current xor
operations, or could use newly written xor operations, and the offload
version could equally do whatever is appropriate.

Another place where combining operations might make sense is copy-in
and post-xor.  In some cases it might be more efficient to only read
the source once, and both write it to the destination and xor it into
the target.  Would your DMA engine be able to optimise this
combination?  I think current processors could certainly do better if
the two were combined.

So there is definitely room to move, but would rather avoid flags if I
could.

NeilBrown
