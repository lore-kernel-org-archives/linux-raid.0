From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH v2 11/51] md: raid1: initialize bvec table via
 bio_add_page()
Date: Wed, 28 Jun 2017 00:22:51 +0800
Message-ID: <20170627162242.GA19610@ming.t460p>
References: <20170626121034.3051-1-ming.lei@redhat.com>
 <20170626121034.3051-12-ming.lei@redhat.com>
 <59522727.7040700@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <59522727.7040700@suse.com>
Sender: linux-block-owner@vger.kernel.org
To: Guoqing Jiang <gqjiang@suse.com>
Cc: Jens Axboe <axboe@fb.com>, Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Jun 27, 2017 at 05:36:39PM +0800, Guoqing Jiang wrote:
> 
> 
> On 06/26/2017 08:09 PM, Ming Lei wrote:
> > We will support multipage bvec soon, so initialize bvec
> > table using the standardy way instead of writing the
> > talbe directly. Otherwise it won't work any more once
> > multipage bvec is enabled.
> > 
> > Cc: Shaohua Li <shli@kernel.org>
> > Cc: linux-raid@vger.kernel.org
> > Signed-off-by: Ming Lei <ming.lei@redhat.com>
> > ---
> >   drivers/md/raid1.c | 27 ++++++++++++++-------------
> >   1 file changed, 14 insertions(+), 13 deletions(-)
> > 
> > diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> > index 3febfc8391fb..835c42396861 100644
> > --- a/drivers/md/raid1.c
> > +++ b/drivers/md/raid1.c
> > @@ -2086,10 +2086,8 @@ static void process_checks(struct r1bio *r1_bio)
> >   	/* Fix variable parts of all bios */
> >   	vcnt = (r1_bio->sectors + PAGE_SIZE / 512 - 1) >> (PAGE_SHIFT - 9);
> >   	for (i = 0; i < conf->raid_disks * 2; i++) {
> > -		int j;
> >   		int size;
> >   		blk_status_t status;
> > -		struct bio_vec *bi;
> >   		struct bio *b = r1_bio->bios[i];
> >   		struct resync_pages *rp = get_resync_pages(b);
> >   		if (b->bi_end_io != end_sync_read)
> > @@ -2098,8 +2096,6 @@ static void process_checks(struct r1bio *r1_bio)
> >   		status = b->bi_status;
> >   		bio_reset(b);
> >   		b->bi_status = status;
> > -		b->bi_vcnt = vcnt;
> > -		b->bi_iter.bi_size = r1_bio->sectors << 9;
> >   		b->bi_iter.bi_sector = r1_bio->sector +
> >   			conf->mirrors[i].rdev->data_offset;
> >   		b->bi_bdev = conf->mirrors[i].rdev->bdev;
> > @@ -2107,15 +2103,20 @@ static void process_checks(struct r1bio *r1_bio)
> >   		rp->raid_bio = r1_bio;
> >   		b->bi_private = rp;
> > -		size = b->bi_iter.bi_size;
> > -		bio_for_each_segment_all(bi, b, j) {
> > -			bi->bv_offset = 0;
> > -			if (size > PAGE_SIZE)
> > -				bi->bv_len = PAGE_SIZE;
> > -			else
> > -				bi->bv_len = size;
> > -			size -= PAGE_SIZE;
> > -		}
> > +		/* initialize bvec table again */
> > +		rp->idx = 0;
> > +		size = r1_bio->sectors << 9;
> > +		do {
> > +			struct page *page = resync_fetch_page(rp, rp->idx++);
> > +			int len = min_t(int, size, PAGE_SIZE);
> > +
> > +			/*
> > +			 * won't fail because the vec table is big
> > +			 * enough to hold all these pages
> > +			 */
> > +			bio_add_page(b, page, len, 0);
> > +			size -= len;
> > +		} while (rp->idx < RESYNC_PAGES && size > 0);
> >   	}
> 
> Seems above section is similar as reset_bvec_table introduced in next patch,
> why there is difference between raid1 and raid10? Maybe add reset_bvec_table
> into md.c, then call it in raid1 or raid10 is better, just my 2 cents.

Hi Guoqing,

I think it is a good idea, and even the two patches can be put into
one, so how about the following patch?

Shaohua, what do you think of this one?

---
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 3d957ac1e109..7ffc622dd7fa 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -9126,6 +9126,24 @@ void md_reload_sb(struct mddev *mddev, int nr)
 }
 EXPORT_SYMBOL(md_reload_sb);
 
+/* generally called after bio_reset() for reseting bvec */
+void reset_bvec_table(struct bio *bio, struct resync_pages *rp, int size)
+{
+	/* initialize bvec table again */
+	rp->idx = 0;
+	do {
+		struct page *page = resync_fetch_page(rp, rp->idx++);
+		int len = min_t(int, size, PAGE_SIZE);
+
+		/*
+		 * won't fail because the vec table is big
+		 * enough to hold all these pages
+		 */
+		bio_add_page(bio, page, len, 0);
+		size -= len;
+	} while (rp->idx < RESYNC_PAGES && size > 0);
+}
+
 #ifndef MODULE
 
 /*
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 991f0fe2dcc6..f569831b1de9 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -783,4 +783,6 @@ static inline struct page *resync_fetch_page(struct resync_pages *rp,
 		return NULL;
 	return rp->pages[idx];
 }
+
+void reset_bvec_table(struct bio *bio, struct resync_pages *rp, int size);
 #endif /* _MD_MD_H */
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 3febfc8391fb..6ae2665ecd58 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -2086,10 +2086,7 @@ static void process_checks(struct r1bio *r1_bio)
 	/* Fix variable parts of all bios */
 	vcnt = (r1_bio->sectors + PAGE_SIZE / 512 - 1) >> (PAGE_SHIFT - 9);
 	for (i = 0; i < conf->raid_disks * 2; i++) {
-		int j;
-		int size;
 		blk_status_t status;
-		struct bio_vec *bi;
 		struct bio *b = r1_bio->bios[i];
 		struct resync_pages *rp = get_resync_pages(b);
 		if (b->bi_end_io != end_sync_read)
@@ -2098,8 +2095,6 @@ static void process_checks(struct r1bio *r1_bio)
 		status = b->bi_status;
 		bio_reset(b);
 		b->bi_status = status;
-		b->bi_vcnt = vcnt;
-		b->bi_iter.bi_size = r1_bio->sectors << 9;
 		b->bi_iter.bi_sector = r1_bio->sector +
 			conf->mirrors[i].rdev->data_offset;
 		b->bi_bdev = conf->mirrors[i].rdev->bdev;
@@ -2107,15 +2102,8 @@ static void process_checks(struct r1bio *r1_bio)
 		rp->raid_bio = r1_bio;
 		b->bi_private = rp;
 
-		size = b->bi_iter.bi_size;
-		bio_for_each_segment_all(bi, b, j) {
-			bi->bv_offset = 0;
-			if (size > PAGE_SIZE)
-				bi->bv_len = PAGE_SIZE;
-			else
-				bi->bv_len = size;
-			size -= PAGE_SIZE;
-		}
+		/* initialize bvec table again */
+		reset_bvec_table(b, rp, r1_bio->sectors << 9);
 	}
 	for (primary = 0; primary < conf->raid_disks * 2; primary++)
 		if (r1_bio->bios[primary]->bi_end_io == end_sync_read &&
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 5026e7ad51d3..72f4fa07449b 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -2087,8 +2087,8 @@ static void sync_request_write(struct mddev *mddev, struct r10bio *r10_bio)
 		rp = get_resync_pages(tbio);
 		bio_reset(tbio);
 
-		tbio->bi_vcnt = vcnt;
-		tbio->bi_iter.bi_size = fbio->bi_iter.bi_size;
+		reset_bvec_table(tbio, rp, fbio->bi_iter.bi_size);
+
 		rp->raid_bio = r10_bio;
 		tbio->bi_private = rp;
 		tbio->bi_iter.bi_sector = r10_bio->devs[i].addr;

Thanks,
Ming
