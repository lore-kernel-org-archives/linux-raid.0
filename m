From: Christoph Hellwig <hch@infradead.org>
Subject: Re: "creative" bio usage in the RAID code
Date: Mon, 14 Nov 2016 00:57:20 -0800
Message-ID: <20161114085720.GB8405@infradead.org>
References: <20161110194636.GA32241@infradead.org>
 <20161111190223.4xrq3vvvvohzgs5e@kernel.org>
 <20161112174238.GA11518@infradead.org>
 <87vavrj8jp.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87vavrj8jp.fsf@notabene.neil.brown.name>
Sender: linux-block-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: Christoph Hellwig <hch@infradead.org>, Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org, linux-block@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Nov 14, 2016 at 09:53:46AM +1100, NeilBrown wrote:
> > While we're at it - I find the way MD_RECOVERY_REQUESTED is used highly
> > confusing, and I'm not 100% sure it's correct.  After all we check it
> > in r1buf_pool_alloc, which is a mempool alloc callback, so we rely
> > on these callbacks being done after the flag has been raise / cleared,
> > which makes me bit suspicious, and also question why we even need the
> > mempool.
> 
> MD_RECOVERY_REQUEST is only set or cleared when no recovery is running.
> The ->reconfig_mutex and MD_RECOVERY_RUNNING flags ensure there are no
> races there.
> The r1buf_pool mempool is created are the start of resync, so at that
> time MD_RECOVERY_RUNNING will be stable, and it will remain stable until
> after the mempool is freed.
> 
> To perform a resync we need a pool of memory buffers.  We don't want to
> have to cope with kmalloc failing, but are quite able to cope with
> mempool_alloc() blocking.
> We probably don't need nearly as many bufs as we allocate (4 is probably
> plenty), but having a pool is certainly convenient.

Would it be good to create/delete the pool explicitly through methods
to start/emd the sync?  Right now the behavior looks very, very
confusing.

> The "bigger bio" might cover a large number of sectors.  If there are
> media errors, there might be only one sector that is bad.  So we repeat
> the read with finer granularity (pages in the current code, though
> device block would be ideal) and only recovery bad blocks for individual
> pages which are bad and cannot be fixed.

i have no problems with the behavior - the point is that these days
this should be without poking into the bio internals, but by using
a bio iterator for just the range you want to re-read.  Potentially
using a bio clone if we can't reusing the existing bio, although I'm
not sure we even need that from looking at the code.
