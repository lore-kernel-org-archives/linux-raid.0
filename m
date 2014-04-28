From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC]raid5: add an option to avoid copy data from bio to stripe
 cache
Date: Mon, 28 Apr 2014 03:17:48 -0700
Message-ID: <20140428101748.GA17026@infradead.org>
References: <20140428065841.GA28726@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20140428065841.GA28726@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: neilb@suse.de, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Apr 28, 2014 at 02:58:41PM +0800, Shaohua Li wrote:
> 
> The stripe cache has two goals:
> 1. cache data, so next time if data can be found in stripe cache, disk access
> can be avoided.

I think this is mostly a side effect.  We have a much larger and better
tuned page cache to take care of this.

> 2. stable data. data is copied from bio to stripe cache and calculated parity.
> data written to disk is from stripe cache, so if upper layer changes bio data,
> data written to disk isn't impacted.
> 
> In my environment, I can guarantee 2 will not happen.

Why just in your environment?  Now that we got stable pages in the page
cache this should always be the case.

> Of course, this shouldn't be enabled by default, so I added an option to
> control it.

Unless careful benchmarking in various scenarious shows adverse effects
this should be the default.  And if we can find adverse effects we need
to look into them.

