From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH v3 05/14] md: raid1: don't use bio's vec table to manage
 resync pages
Date: Mon, 10 Jul 2017 12:13:12 +0800
Message-ID: <20170710041304.GB15321@ming.t460p>
References: <20170316161235.27110-1-tom.leiming@gmail.com>
 <20170316161235.27110-6-tom.leiming@gmail.com>
 <87mv8d5ht7.fsf@notabene.neil.brown.name>
 <CACVXFVP69kLQyr0NOY7zXMZ_bdJYCV7fBbDrKdFF9fBPBTsU-g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CACVXFVP69kLQyr0NOY7zXMZ_bdJYCV7fBbDrKdFF9fBPBTsU-g@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Ming Lei <tom.leiming@gmail.com>
Cc: NeilBrown <neilb@suse.com>, Shaohua Li <shli@kernel.org>, Jens Axboe <axboe@fb.com>, "open list:SOFTWARE RAID (Multiple Disks) SUPPORT" <linux-raid@vger.kernel.org>, linux-block <linux-block@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>
List-Id: linux-raid.ids

On Mon, Jul 10, 2017 at 11:35:12AM +0800, Ming Lei wrote:
> On Mon, Jul 10, 2017 at 7:09 AM, NeilBrown <neilb@suse.com> wrote:
> > On Fri, Mar 17 2017, Ming Lei wrote:
> >
> >> Now we allocate one page array for managing resync pages, instead
> >> of using bio's vec table to do that, and the old way is very hacky
> >> and won't work any more if multipage bvec is enabled.
> >>
> >> The introduced cost is that we need to allocate (128 + 16) * raid_disks
> >> bytes per r1_bio, and it is fine because the inflight r1_bio for
> >> resync shouldn't be much, as pointed by Shaohua.
> >>
> >> Also the bio_reset() in raid1_sync_request() is removed because
> >> all bios are freshly new now and not necessary to reset any more.
> >>
> >> This patch can be thought as a cleanup too
> >>
> >> Suggested-by: Shaohua Li <shli@kernel.org>
> >> Signed-off-by: Ming Lei <tom.leiming@gmail.com>
> >> ---
> >>  drivers/md/raid1.c | 94 +++++++++++++++++++++++++++++++++++++-----------------
> >>  1 file changed, 64 insertions(+), 30 deletions(-)
> >>
> >> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> >> index e30d89690109..0e64beb60e4d 100644
> >> --- a/drivers/md/raid1.c
> >> +++ b/drivers/md/raid1.c
> >> @@ -80,6 +80,24 @@ static void lower_barrier(struct r1conf *conf, sector_t sector_nr);
> >>  #define raid1_log(md, fmt, args...)                          \
> >>       do { if ((md)->queue) blk_add_trace_msg((md)->queue, "raid1 " fmt, ##args); } while (0)
> >>
> >> +/*
> >> + * 'strct resync_pages' stores actual pages used for doing the resync
> >> + *  IO, and it is per-bio, so make .bi_private points to it.
> >> + */
> >> +static inline struct resync_pages *get_resync_pages(struct bio *bio)
> >> +{
> >> +     return bio->bi_private;
> >> +}
> >> +
> >> +/*
> >> + * for resync bio, r1bio pointer can be retrieved from the per-bio
> >> + * 'struct resync_pages'.
> >> + */
> >> +static inline struct r1bio *get_resync_r1bio(struct bio *bio)
> >> +{
> >> +     return get_resync_pages(bio)->raid_bio;
> >> +}
> >> +
> >>  static void * r1bio_pool_alloc(gfp_t gfp_flags, void *data)
> >>  {
> >>       struct pool_info *pi = data;
> >> @@ -107,12 +125,18 @@ static void * r1buf_pool_alloc(gfp_t gfp_flags, void *data)
> >>       struct r1bio *r1_bio;
> >>       struct bio *bio;
> >>       int need_pages;
> >> -     int i, j;
> >> +     int j;
> >> +     struct resync_pages *rps;
> >>
> >>       r1_bio = r1bio_pool_alloc(gfp_flags, pi);
> >>       if (!r1_bio)
> >>               return NULL;
> >>
> >> +     rps = kmalloc(sizeof(struct resync_pages) * pi->raid_disks,
> >> +                   gfp_flags);
> >> +     if (!rps)
> >> +             goto out_free_r1bio;
> >> +
> >>       /*
> >>        * Allocate bios : 1 for reading, n-1 for writing
> >>        */
> >> @@ -132,22 +156,22 @@ static void * r1buf_pool_alloc(gfp_t gfp_flags, void *data)
> >>               need_pages = pi->raid_disks;
> >>       else
> >>               need_pages = 1;
> >> -     for (j = 0; j < need_pages; j++) {
> >> +     for (j = 0; j < pi->raid_disks; j++) {
> >> +             struct resync_pages *rp = &rps[j];
> >> +
> >>               bio = r1_bio->bios[j];
> >> -             bio->bi_vcnt = RESYNC_PAGES;
> >> -
> >> -             if (bio_alloc_pages(bio, gfp_flags))
> >> -                     goto out_free_pages;
> >> -     }
> >> -     /* If not user-requests, copy the page pointers to all bios */
> >> -     if (!test_bit(MD_RECOVERY_REQUESTED, &pi->mddev->recovery)) {
> >> -             for (i=0; i<RESYNC_PAGES ; i++)
> >> -                     for (j=1; j<pi->raid_disks; j++) {
> >> -                             struct page *page =
> >> -                                     r1_bio->bios[0]->bi_io_vec[i].bv_page;
> >> -                             get_page(page);
> >> -                             r1_bio->bios[j]->bi_io_vec[i].bv_page = page;
> >> -                     }
> >> +
> >> +             if (j < need_pages) {
> >> +                     if (resync_alloc_pages(rp, gfp_flags))
> >> +                             goto out_free_pages;
> >> +             } else {
> >> +                     memcpy(rp, &rps[0], sizeof(*rp));
> >> +                     resync_get_all_pages(rp);
> >> +             }
> >> +
> >> +             rp->idx = 0;
> >
> > This is the only place the ->idx is initialized, in r1buf_pool_alloc().
> > The mempool alloc function is suppose to allocate memory, not initialize
> > it.
> >
> > If the mempool_alloc() call cannot allocate memory it will use memory
> > from the pool.  If this memory has already been used, then it will no
> > longer have the initialized value.
> >
> > In short: you need to initialise memory *after* calling
> > mempool_alloc(), unless you ensure it is reset to the init values before
> > calling mempool_free().
> >
> > https://bugzilla.kernel.org/show_bug.cgi?id=196307
> 
> OK, thanks for posting it out.
> 
> Another fix might be to reinitialize the variable(rp->idx = 0) in
> r1buf_pool_free().
> Or just set it as zero every time when it is used.
> 
> But I don't understand why mempool_free() calls pool->free() at the end of
> this function, which may cause to run pool->free() on a new allocated buf,
> seems a bug in mempool?

Looks I missed the 'return' in mempool_free(), so it is fine.

How about the following fix?

---
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index e1a7e3d4c5e4..d31b06da3e3d 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -242,6 +242,7 @@ static void put_buf(struct r1bio *r1_bio)
 		struct bio *bio = r1_bio->bios[i];
 		if (bio->bi_end_io)
 			rdev_dec_pending(conf->mirrors[i].rdev, r1_bio->mddev);
+		get_resync_pages(bio)->idx = 0;
 	}
 
 	mempool_free(r1_bio, conf->r1buf_pool);
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 797ed60abd5e..c61523768745 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -299,12 +299,21 @@ static void free_r10bio(struct r10bio *r10_bio)
 	mempool_free(r10_bio, conf->r10bio_pool);
 }
 
-static void put_buf(struct r10bio *r10_bio)
+static void free_r10bio_buf(struct r10bio *r10_bio, struct r10conf *conf)
 {
-	struct r10conf *conf = r10_bio->mddev->private;
+	int j;
+
+	for (j = conf->copies; j--; )
+		get_resync_pages(r10_bio->devs[j].bio)->idx = 0;
 
 	mempool_free(r10_bio, conf->r10buf_pool);
+}
+
+static void put_buf(struct r10bio *r10_bio)
+{
+	struct r10conf *conf = r10_bio->mddev->private;
 
+	free_r10bio_buf(r10_bio, conf);
 	lower_barrier(conf);
 }
 
@@ -4383,7 +4392,7 @@ static sector_t reshape_request(struct mddev *mddev, sector_t sector_nr,
 		 * on all the target devices.
 		 */
 		// FIXME
-		mempool_free(r10_bio, conf->r10buf_pool);
+		free_r10bio_buf(r10_bio, conf);
 		set_bit(MD_RECOVERY_INTR, &mddev->recovery);
 		return sectors_done;
 	}

-- 
Ming
