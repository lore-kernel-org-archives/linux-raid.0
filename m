From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH v3 05/14] md: raid1: don't use bio's vec table to manage
 resync pages
Date: Thu, 13 Jul 2017 09:22:12 +0800
Message-ID: <20170713012205.GA670@ming.t460p>
References: <20170316161235.27110-6-tom.leiming@gmail.com>
 <87mv8d5ht7.fsf@notabene.neil.brown.name>
 <CACVXFVP69kLQyr0NOY7zXMZ_bdJYCV7fBbDrKdFF9fBPBTsU-g@mail.gmail.com>
 <20170710041304.GB15321@ming.t460p>
 <87h8yk6h50.fsf@notabene.neil.brown.name>
 <20170710072538.GA32208@ming.t460p>
 <20170710190549.luj7zrnq7mo4x36b@kernel.org>
 <874luj6g1y.fsf@notabene.neil.brown.name>
 <CACVXFVOu92NhB+TmytW8Nk6bmL83cDHJFCf=gH5a_+GM6ov5kA@mail.gmail.com>
 <20170712163050.sxmylv7uq5f2z6gp@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170712163050.sxmylv7uq5f2z6gp@kernel.org>
Sender: linux-block-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: Ming Lei <tom.leiming@gmail.com>, NeilBrown <neilb@suse.com>, Jens Axboe <axboe@fb.com>, "open list:SOFTWARE RAID (Multiple Disks) SUPPORT" <linux-raid@vger.kernel.org>, linux-block <linux-block@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>
List-Id: linux-raid.ids

On Wed, Jul 12, 2017 at 09:30:50AM -0700, Shaohua Li wrote:
> On Wed, Jul 12, 2017 at 09:40:10AM +0800, Ming Lei wrote:
> > On Tue, Jul 11, 2017 at 7:14 AM, NeilBrown <neilb@suse.com> wrote:
> > > On Mon, Jul 10 2017, Shaohua Li wrote:
> > >
> > >> On Mon, Jul 10, 2017 at 03:25:41PM +0800, Ming Lei wrote:
> > >>> On Mon, Jul 10, 2017 at 02:38:19PM +1000, NeilBrown wrote:
> > >>> > On Mon, Jul 10 2017, Ming Lei wrote:
> > >>> >
> > >>> > > On Mon, Jul 10, 2017 at 11:35:12AM +0800, Ming Lei wrote:
> > >>> > >> On Mon, Jul 10, 2017 at 7:09 AM, NeilBrown <neilb@suse.com> wrote:
> > >>> > ...
> > >>> > >> >> +
> > >>> > >> >> +             rp->idx = 0;
> > >>> > >> >
> > >>> > >> > This is the only place the ->idx is initialized, in r1buf_pool_alloc().
> > >>> > >> > The mempool alloc function is suppose to allocate memory, not initialize
> > >>> > >> > it.
> > >>> > >> >
> > >>> > >> > If the mempool_alloc() call cannot allocate memory it will use memory
> > >>> > >> > from the pool.  If this memory has already been used, then it will no
> > >>> > >> > longer have the initialized value.
> > >>> > >> >
> > >>> > >> > In short: you need to initialise memory *after* calling
> > >>> > >> > mempool_alloc(), unless you ensure it is reset to the init values before
> > >>> > >> > calling mempool_free().
> > >>> > >> >
> > >>> > >> > https://bugzilla.kernel.org/show_bug.cgi?id=196307
> > >>> > >>
> > >>> > >> OK, thanks for posting it out.
> > >>> > >>
> > >>> > >> Another fix might be to reinitialize the variable(rp->idx = 0) in
> > >>> > >> r1buf_pool_free().
> > >>> > >> Or just set it as zero every time when it is used.
> > >>> > >>
> > >>> > >> But I don't understand why mempool_free() calls pool->free() at the end of
> > >>> > >> this function, which may cause to run pool->free() on a new allocated buf,
> > >>> > >> seems a bug in mempool?
> > >>> > >
> > >>> > > Looks I missed the 'return' in mempool_free(), so it is fine.
> > >>> > >
> > >>> > > How about the following fix?
> > >>> >
> > >>> > It looks like it would probably work, but it is rather unusual to
> > >>> > initialise something just before freeing it.
> > >>> >
> > >>> > Couldn't you just move the initialization to shortly after the
> > >>> > mempool_alloc() call.  There looks like a good place that already loops
> > >>> > over all the bios....
> > >>>
> > >>> OK, follows the revised patch according to your suggestion.
> > >
> > > Thanks.
> > >
> > > That isn't as tidy as I hoped.  So I went deeper into the code to try to
> > > understand why...
> > >
> > > I think that maybe we should just discard the ->idx field completely.
> > > It is only used in this code:
> > >
> > >         do {
> > >                 struct page *page;
> > >                 int len = PAGE_SIZE;
> > >                 if (sector_nr + (len>>9) > max_sector)
> > >                         len = (max_sector - sector_nr) << 9;
> > >                 if (len == 0)
> > >                         break;
> > >                 for (bio= biolist ; bio ; bio=bio->bi_next) {
> > >                         struct resync_pages *rp = get_resync_pages(bio);
> > >                         page = resync_fetch_page(rp, rp->idx++);
> > >                         /*
> > >                          * won't fail because the vec table is big enough
> > >                          * to hold all these pages
> > >                          */
> > >                         bio_add_page(bio, page, len, 0);
> > >                 }
> > >                 nr_sectors += len>>9;
> > >                 sector_nr += len>>9;
> > >         } while (get_resync_pages(biolist)->idx < RESYNC_PAGES);
> > >
> > > and all of the different 'rp' always have the same value for 'idx'.
> > > This code is more complex than it needs to be.  This is because it used
> > > to be possible for bio_add_page() to fail.  That cannot happen any more.
> > > So we can make the code something like:
> > >
> > >   for (idx = 0; idx < RESYNC_PAGES; idx++) {
> > >      struct page *page;
> > >      int len = PAGE_SIZE;
> > >      if (sector_nr + (len >> 9) > max_sector)
> > >          len = (max_sector - sector_nr) << 9
> > >      if (len == 0)
> > >          break;
> > >      for (bio = biolist; bio; bio = bio->bi_next) {
> > >         struct resync_pages *rp = get_resync_pages(bio);
> > >         page = resync_fetch_page(rp, idx);
> > >         bio_add_page(bio, page, len, 0);
> > >      }
> > >      nr_sectors += len >> 9;
> > >      sector_nr += len >> 9;
> > >   }
> > >
> > > Or did I miss something?
> > 
> > I think this approach is much clean.
> 
> Thought I suggested not using the 'idx' in your previous post, but you said
> there is reason (not because of bio_add_page) not to do it. Is that changed?
> can't remember the details, I need to dig the mail archives. 

I found it:

	http://marc.info/?l=linux-raid&m=148847751302825&w=2

Not sure why I didn't change to this way in v3, but the idea is correct.
Maybe I misunderstood it that time.

-- 
Ming
