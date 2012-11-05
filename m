From: Dave Chinner <david@fromorbit.com>
Subject: Re: Problem with DISCARD and RAID5
Date: Tue, 6 Nov 2012 08:48:46 +1100
Message-ID: <20121105214846.GM29378@dastard>
References: <20121101173854.62061307@notabene.brown>
 <20121102014058.GA20526@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20121102014058.GA20526@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: NeilBrown <neilb@suse.de>, linux RAID <linux-raid@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, lkml <linux-kernel@vger.kernel.org>
List-Id: linux-raid.ids

On Fri, Nov 02, 2012 at 09:40:58AM +0800, Shaohua Li wrote:
> On Thu, Nov 01, 2012 at 05:38:54PM +1100, NeilBrown wrote:
> > 
> > Hi Shaohua,
> >  I've been doing some testing and discovered a problem with your discard
> >  support for RAID5.
> > 
> >  The code in blkdev_issue_discard assumes that the 'granularity' is a power
> >  of 2, and for example subtracts 1 to get a mask.
> > 
> >  However RAID5 sets the granularity to be the stripe size which often is not
> >  a power of two.  When this happens you can easily get into an infinite loop.
> > 
> >  I suspect that to make this work properly, blkdev_issue_discard will need to
> >  be changed to allow 'granularity' to be an arbitrary value.
> >  When it is a power of two, the current masking can be used.
> >  When it is anything else, it will need to use sector_div().
> 
> Yep, looks we need use sector_div. And this isn't the only problem. discard
> request can be merged, and the merge check only checks max_discard_sectors.
> That means the split requests in blkdev_issue_discard can be merged again. The
> split nerver works.
> 
> I'm wondering what's purpose of discard_alignment and discard_granularity. Are
> there devices with discard_granularity not 1 sector?

Most certainly. Thin provisioned storage often has granularity in the
order of megabytes....

> If bio isn't discard
> aligned, what device will do?

Up to the device.

> Further, why driver handles alignment/granularity
> if device will ignore misaligned request.

When you send a series of sequential unaligned requests, the device
may ignore them all. Hence you end up with nothing being discarded,
even though the entire range being discarded is much, much larger
than the discard granularity....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
