From: Neil Brown <neilb@suse.de>
Subject: Re: Large Stripe Size (>4MB)
Date: Thu, 23 Mar 2006 13:40:32 +1100
Message-ID: <17442.2720.146886.112633@cse.unsw.edu.au>
References: <dd43dcfb0602180704n78f4de2lb61dd359387897b3@mail.gmail.com>
	<loom.20060322T223645-85@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Alex Izvorski on Wednesday March 22
Sender: linux-raid-owner@vger.kernel.org
To: Alex Izvorski <aizvorski@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday March 22, aizvorski@gmail.com wrote:
> Paul M. <paul <at> gpmidi.net> writes:
> 
> > 
> > Couple questions related to some raid using some firewire disks:
> > 
> > Is it possible to set the stripe size to 16+MB?
> > 
> > Is there a way to force the raid driver to only access one disk at a time?
> > 
> > Thanks,
> > 
> > Paul
> 
> Yes, it's possible - just change the #define MAX_CHUNK_SIZE 
> in linux/include/linux/raid/md_k.h and rebuild your kernel.  I am 
> happily running an array with a 64MB chunk.
> 
> Can some knowledgeable person explain if there is any downside to a very large
> number in that define (as in, a few GB)?  Does it use up any resources or can it
> overflow any arithmetic somewhere in the kernel?

Up to 2Gig should work without problems.  More than that will cause
overflow in the 0.90 superblock.  With the version-1 superblock we
should be able to support chunks upto a terrabyte (I think) but we
would need a code-audit and a fair bit of fixing first.

NeilBrown
