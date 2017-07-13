From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH 2/2] md: raid1/raid10: initialize bvec table via
 bio_add_page()
Date: Thu, 13 Jul 2017 09:39:09 -0700
Message-ID: <20170713163909.whltvlms2zwgevkf@kernel.org>
References: <20170712082912.491-1-ming.lei@redhat.com>
 <87zic92oiq.fsf@notabene.neil.brown.name>
 <20170713013710.GC670@ming.t460p>
 <87inix2ftj.fsf@notabene.neil.brown.name>
 <20170713092050.GG670@ming.t460p>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170713092050.GG670@ming.t460p>
Sender: linux-raid-owner@vger.kernel.org
To: Ming Lei <ming.lei@redhat.com>
Cc: NeilBrown <neilb@suse.com>, linux-raid@vger.kernel.org, linux-block@vger.kernel.org, Jens Axboe <axboe@fb.com>, Christoph Hellwig <hch@infradead.org>
List-Id: linux-raid.ids

On Thu, Jul 13, 2017 at 05:20:52PM +0800, Ming Lei wrote:
> On Thu, Jul 13, 2017 at 01:09:28PM +1000, NeilBrown wrote:
> > On Thu, Jul 13 2017, Ming Lei wrote:
> > 
> > > On Thu, Jul 13, 2017 at 10:01:33AM +1000, NeilBrown wrote:
> > >> On Wed, Jul 12 2017, Ming Lei wrote:
> > >> 
> > >> > We will support multipage bvec soon, so initialize bvec
> > >> > table using the standardy way instead of writing the
> > >> > talbe directly. Otherwise it won't work any more once
> > >> > multipage bvec is enabled.
> > >> >
> > >> > Acked-by: Guoqing Jiang <gqjiang@suse.com>
> > >> > Signed-off-by: Ming Lei <ming.lei@redhat.com>
> > >> > ---
> > >> >  drivers/md/md.c     | 21 +++++++++++++++++++++
> > >> >  drivers/md/md.h     |  3 +++
> > >> >  drivers/md/raid1.c  | 16 ++--------------
> > >> >  drivers/md/raid10.c |  4 ++--
> > >> >  4 files changed, 28 insertions(+), 16 deletions(-)
> > >> >
> > >> > diff --git a/drivers/md/md.c b/drivers/md/md.c
> > >> > index 8cdca0296749..cc8dcd928dde 100644
> > >> > --- a/drivers/md/md.c
> > >> > +++ b/drivers/md/md.c
> > >> > @@ -9130,6 +9130,27 @@ void md_reload_sb(struct mddev *mddev, int nr)
> > >> >  }
> > >> >  EXPORT_SYMBOL(md_reload_sb);
> > >> >  
> > >> > +/* generally called after bio_reset() for reseting bvec */
> > >> > +void md_bio_reset_resync_pages(struct bio *bio, struct resync_pages *rp,
> > >> > +			       int size)
> > >> > +{
> > >> > +	int idx = 0;
> > >> > +
> > >> > +	/* initialize bvec table again */
> > >> > +	do {
> > >> > +		struct page *page = resync_fetch_page(rp, idx);
> > >> > +		int len = min_t(int, size, PAGE_SIZE);
> > >> > +
> > >> > +		/*
> > >> > +		 * won't fail because the vec table is big
> > >> > +		 * enough to hold all these pages
> > >> > +		 */
> > >> > +		bio_add_page(bio, page, len, 0);
> > >> > +		size -= len;
> > >> > +	} while (idx++ < RESYNC_PAGES && size > 0);
> > >> > +}
> > >> > +EXPORT_SYMBOL(md_bio_reset_resync_pages);
> > >> 
> > >> I really don't think this is a good idea.
> > >> This code is specific to raid1/raid10.  It is not generic md code.  So
> > >> it doesn't belong here.
> > >
> > > We already added 'struct resync_pages' in drivers/md/md.h, so I think
> > > it is reasonable to add this function into drivers/md/md.c
> > 
> > Alternative perspective: it was unreasonable to add "resync_pages" to
> > md.h.
> > 
> > >
> > >> 
> > >> If you want to remove code duplication, then work on moving all raid1
> > >> functionality into raid10.c, then discard raid1.c
> > >
> > > This patch is for avoiding new code duplication, not for removing current
> > > duplication.
> > >
> > >> 
> > >> Or at the very least, have a separate "raid1-10.c" file for the common
> > >> code.
> > >
> > > You suggested it last time, but looks too overkill to be taken. But if
> > > someone wants to refactor raid1 and raid10, I think it can be a good start,
> > > but still not belong to this patch.
> > 
> > You are trying to create common code for raid1 and raid10.  This does
> > not belong in md.c.
> > If you really want to have a single copy of common code, then it exactly
> > is the role of this patch to create a place to put it.
> > I'm not saying you should put all common code in raid1-10.c.   Just the
> > function that you have identified.
> 
> I really don't want to waste time on this kind of thing, I can do
> either one frankly.
> 
> Shaohua, could you share me which way you like to merge? I can do it in
> either way.

I don't have strong preference, but Neil's suggestion does make the code a
little better. Of course, only put the function into the raid1-10.c right now.

Thanks,
Shaohua
