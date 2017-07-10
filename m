From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH v3 05/14] md: raid1: don't use bio's vec table to manage
 resync pages
Date: Tue, 11 Jul 2017 06:54:59 +0800
Message-ID: <20170710225454.GA6138@ming.t460p>
References: <20170316161235.27110-1-tom.leiming@gmail.com>
 <20170316161235.27110-6-tom.leiming@gmail.com>
 <87mv8d5ht7.fsf@notabene.neil.brown.name>
 <CACVXFVP69kLQyr0NOY7zXMZ_bdJYCV7fBbDrKdFF9fBPBTsU-g@mail.gmail.com>
 <20170710041304.GB15321@ming.t460p>
 <87h8yk6h50.fsf@notabene.neil.brown.name>
 <20170710072538.GA32208@ming.t460p>
 <20170710190549.luj7zrnq7mo4x36b@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170710190549.luj7zrnq7mo4x36b@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: NeilBrown <neilb@suse.com>, Ming Lei <tom.leiming@gmail.com>, Jens Axboe <axboe@fb.com>, "open list:SOFTWARE RAID (Multiple Disks) SUPPORT" <linux-raid@vger.kernel.org>, linux-block <linux-block@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>
List-Id: linux-raid.ids

On Mon, Jul 10, 2017 at 12:05:49PM -0700, Shaohua Li wrote:
> On Mon, Jul 10, 2017 at 03:25:41PM +0800, Ming Lei wrote:
> > On Mon, Jul 10, 2017 at 02:38:19PM +1000, NeilBrown wrote:
> > > On Mon, Jul 10 2017, Ming Lei wrote:
> > > 
> > > > On Mon, Jul 10, 2017 at 11:35:12AM +0800, Ming Lei wrote:
> > > >> On Mon, Jul 10, 2017 at 7:09 AM, NeilBrown <neilb@suse.com> wrote:
> > > ...
> > > >> >> +
> > > >> >> +             rp->idx = 0;
> > > >> >
> > > >> > This is the only place the ->idx is initialized, in r1buf_pool_alloc().
> > > >> > The mempool alloc function is suppose to allocate memory, not initialize
> > > >> > it.
> > > >> >
> > > >> > If the mempool_alloc() call cannot allocate memory it will use memory
> > > >> > from the pool.  If this memory has already been used, then it will no
> > > >> > longer have the initialized value.
> > > >> >
> > > >> > In short: you need to initialise memory *after* calling
> > > >> > mempool_alloc(), unless you ensure it is reset to the init values before
> > > >> > calling mempool_free().
> > > >> >
> > > >> > https://bugzilla.kernel.org/show_bug.cgi?id=196307
> > > >> 
> > > >> OK, thanks for posting it out.
> > > >> 
> > > >> Another fix might be to reinitialize the variable(rp->idx = 0) in
> > > >> r1buf_pool_free().
> > > >> Or just set it as zero every time when it is used.
> > > >> 
> > > >> But I don't understand why mempool_free() calls pool->free() at the end of
> > > >> this function, which may cause to run pool->free() on a new allocated buf,
> > > >> seems a bug in mempool?
> > > >
> > > > Looks I missed the 'return' in mempool_free(), so it is fine.
> > > >
> > > > How about the following fix?
> > > 
> > > It looks like it would probably work, but it is rather unusual to
> > > initialise something just before freeing it.
> > > 
> > > Couldn't you just move the initialization to shortly after the
> > > mempool_alloc() call.  There looks like a good place that already loops
> > > over all the bios....
> > 
> > OK, follows the revised patch according to your suggestion.
> > ---
> > 
> > From 68f9936635b3dda13c87a6b6125ac543145bb940 Mon Sep 17 00:00:00 2001
> > From: Ming Lei <ming.lei@redhat.com>
> > Date: Mon, 10 Jul 2017 15:16:16 +0800
> > Subject: [PATCH] MD: move initialization of resync pages' index out of mempool
> >  allocator
> > 
> > mempool_alloc() is only responsible for allocation, not for initialization,
> > so we need to move the initialization of resync pages's index out of the
> > allocator function.
> > 
> > Reported-by: NeilBrown <neilb@suse.com>
> > Fixes: f0250618361d(md: raid10: don't use bio's vec table to manage resync pages)
> > Fixes: 98d30c5812c3(md: raid1: don't use bio's vec table to manage resync pages)
> > Signed-off-by: Ming Lei <ming.lei@redhat.com>
> > ---
> >  drivers/md/raid1.c  | 4 +++-
> >  drivers/md/raid10.c | 6 +++++-
> >  2 files changed, 8 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> > index e1a7e3d4c5e4..26f5efba0504 100644
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
> > @@ -2698,6 +2697,9 @@ static sector_t raid1_sync_request(struct mddev *mddev, sector_t sector_nr,
> >  		struct md_rdev *rdev;
> >  		bio = r1_bio->bios[i];
> >  
> > +		/* This initialization should follow mempool_alloc() */
> > +		get_resync_pages(bio)->idx = 0;
> > +
> 
> This is fragile and hard to maintain. Can we add a wrap for the
> allocation/init?

The resync pages's index init is done in the following loop
after mempool_alloc(), actually the whole loop is still sort of init,
so I think it isn't fragile, and it should be fine.

-- 
Ming
