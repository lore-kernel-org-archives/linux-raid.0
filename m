From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 3/3] raid5: allow r5l_io_unit allocations to fail
Date: Fri, 18 Dec 2015 12:23:12 +0100
Message-ID: <20151218112312.GA28224@lst.de>
References: <1450390197-19479-1-git-send-email-hch@lst.de> <1450390197-19479-4-git-send-email-hch@lst.de> <20151217234748.GA1860175@devbig084.prn1.facebook.com> <874mfg8qyc.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <874mfg8qyc.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: Shaohua Li <shli@fb.com>, Christoph Hellwig <hch@lst.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Dec 18, 2015 at 12:51:07PM +1100, NeilBrown wrote:
> > if the reclaim thread doesn't have anything to reclaim,
> > r5l_run_no_space_stripes isn't called. we might miss the retry.
> 
> so something like this:

that looks fine to me.  I'll give a spin on my QA setup.

> > I'm a little worrying about the GFP_ATOMIC allocation. In the first try,
> > GFP_NOWAIT is better. And on the other hand, why sleep is bad here? We
> > could use GFP_NOIO | __GFP_NORETRY, there is no deadlock risk.
> >
> > In the retry, GFP_NOIO looks better. No deadlock too, since it's not
> > called from raid5d (maybe we shouldn't call from reclaim thread if using
> > GFP_NOIO, a workqueue is better). Otherwise we could keep retring but do
> > nothing.
> 
> I did wonder a little bit about that.
> GFP_ATOMIC is (__GFP_HIGH)
> GFP_NOIO | __GFP_NORETRY is  (__GFP_WAIT | __GFP_NORETRY)
> 
> It isn't clear that we need 'HIGH', and WAIT with NORETRY should be OK.
> It allows __alloc_pages_direct_reclaim, but only once and never waits
> for other IO.

In general we go for HIGH on non-sleeping allocation to avoid having
the stalled.  This is especially important in the I/O path.

WAIT means we will reclaim and wait for it, which looks a little dangerous
to me.  In general I'd prefer not to use obscure gfp flag combination
unless there is a real need, and it's clearly documented.

