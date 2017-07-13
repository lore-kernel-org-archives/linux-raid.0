From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH 1/2] md: remove 'idx' from 'struct resync_pages'
Date: Thu, 13 Jul 2017 09:41:33 +0800
Message-ID: <20170713014132.GE670@ming.t460p>
References: <20170712082845.436-1-ming.lei@redhat.com>
 <8737a1437y.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <8737a1437y.fsf@notabene.neil.brown.name>
Sender: linux-block-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org, linux-block@vger.kernel.org, Jens Axboe <axboe@fb.com>, Christoph Hellwig <hch@infradead.org>
List-Id: linux-raid.ids

On Thu, Jul 13, 2017 at 09:58:41AM +1000, NeilBrown wrote:
> On Wed, Jul 12 2017, Ming Lei wrote:
> 
> > bio_add_page() won't fail for resync bio, and the page index for each
> > bio is same, so remove it.
> >
> > More importantly the 'idx' of 'struct resync_pages' is initialized in
> > mempool allocator function, this way is wrong since mempool is only
> > responsible for allocation, we can't use that for initialization.
> >
> > Suggested-by: NeilBrown <neilb@suse.com>
> > Reported-by: NeilBrown <neilb@suse.com>
> > Fixes: f0250618361d(md: raid10: don't use bio's vec table to manage resync pages)
> > Fixes: 98d30c5812c3(md: raid1: don't use bio's vec table to manage resync pages)
> > Signed-off-by: Ming Lei <ming.lei@redhat.com>
> > ---
> >  drivers/md/md.h     | 1 -
> >  drivers/md/raid1.c  | 6 +++---
> >  drivers/md/raid10.c | 6 +++---
> >  3 files changed, 6 insertions(+), 7 deletions(-)
> >
> > diff --git a/drivers/md/md.h b/drivers/md/md.h
> > index 991f0fe2dcc6..2c780aa8d07f 100644
> > --- a/drivers/md/md.h
> > +++ b/drivers/md/md.h
> > @@ -736,7 +736,6 @@ static inline void mddev_check_write_zeroes(struct mddev *mddev, struct bio *bio
> >  
> >  /* for managing resync I/O pages */
> >  struct resync_pages {
> > -	unsigned	idx;	/* for get/put page from the pool */
> >  	void		*raid_bio;
> >  	struct page	*pages[RESYNC_PAGES];
> >  };
> > diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> > index 3febfc8391fb..7901ddc3362f 100644
> > --- a/drivers/md/raid1.c
> > +++ b/drivers/md/raid1.c
> > @@ -170,7 +170,6 @@ static void * r1buf_pool_alloc(gfp_t gfp_flags, void *data)
> >  			resync_get_all_pages(rp);
> >  		}
> >  
> > -		rp->idx = 0;
> >  		rp->raid_bio = r1_bio;
> >  		bio->bi_private = rp;
> >  	}
> > @@ -2619,6 +2618,7 @@ static sector_t raid1_sync_request(struct mddev *mddev, sector_t sector_nr,
> >  	int good_sectors = RESYNC_SECTORS;
> >  	int min_bad = 0; /* number of sectors that are bad in all devices */
> >  	int idx = sector_to_idx(sector_nr);
> > +	int page_idx = 0;
> >  
> >  	if (!conf->r1buf_pool)
> >  		if (init_resync(conf))
> > @@ -2846,7 +2846,7 @@ static sector_t raid1_sync_request(struct mddev *mddev, sector_t sector_nr,
> >  			bio = r1_bio->bios[i];
> >  			rp = get_resync_pages(bio);
> >  			if (bio->bi_end_io) {
> > -				page = resync_fetch_page(rp, rp->idx++);
> > +				page = resync_fetch_page(rp, page_idx);
> >  
> >  				/*
> >  				 * won't fail because the vec table is big
> > @@ -2858,7 +2858,7 @@ static sector_t raid1_sync_request(struct mddev *mddev, sector_t sector_nr,
> >  		nr_sectors += len>>9;
> >  		sector_nr += len>>9;
> >  		sync_blocks -= (len>>9);
> > -	} while (get_resync_pages(r1_bio->bios[disk]->bi_private)->idx < RESYNC_PAGES);
> > +	} while (page_idx++ < RESYNC_PAGES);
> 
> I think you want ++page_idx < RESYNC_PAGES, otherwise there will be
> one pass through the loop where page_idx == RESYNC_PAGES

Good catch, thanks!

thanks, 
Ming
