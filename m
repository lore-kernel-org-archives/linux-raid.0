From: Shaohua Li <shli@kernel.org>
Subject: Re: [RFC]raid5: add an option to avoid copy data from bio to stripe
 cache
Date: Tue, 29 Apr 2014 10:01:24 +0800
Message-ID: <20140429020124.GA24123@kernel.org>
References: <20140428065841.GA28726@kernel.org>
 <20140428101748.GA17026@infradead.org>
 <20140428204407.226c88e4@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20140428204407.226c88e4@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Apr 28, 2014 at 08:44:07PM +1000, NeilBrown wrote:
> On Mon, 28 Apr 2014 03:17:48 -0700 Christoph Hellwig <hch@infradead.org>
> wrote:
> 
> > On Mon, Apr 28, 2014 at 02:58:41PM +0800, Shaohua Li wrote:
> > > 
> > > The stripe cache has two goals:
> > > 1. cache data, so next time if data can be found in stripe cache, disk access
> > > can be avoided.
> > 
> > I think this is mostly a side effect.  We have a much larger and better
> > tuned page cache to take care of this.
> > 
> > > 2. stable data. data is copied from bio to stripe cache and calculated parity.
> > > data written to disk is from stripe cache, so if upper layer changes bio data,
> > > data written to disk isn't impacted.
> > > 
> > > In my environment, I can guarantee 2 will not happen.
> > 
> > Why just in your environment?  Now that we got stable pages in the page
> > cache this should always be the case.
> 
> Hmm... I hadn't realised that we were guaranteed stabled pages always (if
> requested).  It seems that we are.
> 
> > 
> > > Of course, this shouldn't be enabled by default, so I added an option to
> > > control it.
> > 
> > Unless careful benchmarking in various scenarious shows adverse effects
> > this should be the default.  And if we can find adverse effects we need
> > to look into them.
> 
> Certainly some benchmarking is needed.
> 
> We should set
> 
>  mddev->queue->backing_dev_info.capabilities |= BDI_CAP_STABLE_WRITES
> 
> if and only iff 'skip_copy' is set. Then test various cases just to confirm
> that it is generally an improvement.

IIRC, we switched from 'force wait page writeback' to 'wait page writeback if
required' because of performance issues reported, so we shoudn't always enable
BDI_CAP_STABLE_WRITES. Is it safe to set/clear BDI_CAP_STABLE_WRITES at
runtime, if we use 'skip_copy' to control it? Ofcourse, we don't need runtime
changing the setting, but we need a mechanism to setup it before array runs.

As of performance, the 'skip_copy' is very helpful (> 30% boost) for my raid5
array (with 6 fast PCIe SSD) for 1M request size workload. Nothing changed for
4k randwrite workload.

Thanks,
Shaohua
