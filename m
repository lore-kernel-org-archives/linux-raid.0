From: Ming Lei <ming.lei@redhat.com>
Subject: [PATCH 2/2] md: raid1/raid10: initialize bvec table via bio_add_page()
Date: Wed, 12 Jul 2017 16:29:12 +0800
Message-ID: <20170712082912.491-1-ming.lei@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org
Cc: NeilBrown <neilb@suse.com>, linux-block@vger.kernel.org, Jens Axboe <axboe@fb.com>, Christoph Hellwig <hch@infradead.org>, Ming Lei <ming.lei@redhat.com>
List-Id: linux-raid.ids

We will support multipage bvec soon, so initialize bvec
table using the standardy way instead of writing the
talbe directly. Otherwise it won't work any more once
multipage bvec is enabled.

Acked-by: Guoqing Jiang <gqjiang@suse.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 drivers/md/md.c     | 21 +++++++++++++++++++++
 drivers/md/md.h     |  3 +++
 drivers/md/raid1.c  | 16 ++--------------
 drivers/md/raid10.c |  4 ++--
 4 files changed, 28 insertions(+), 16 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 8cdca0296749..cc8dcd928dde 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -9130,6 +9130,27 @@ void md_reload_sb(struct mddev *mddev, int nr)
 }
 EXPORT_SYMBOL(md_reload_sb);
 
+/* generally called after bio_reset() for reseting bvec */
+void md_bio_reset_resync_pages(struct bio *bio, struct resync_pages *rp,
+			       int size)
+{
+	int idx = 0;
+
+	/* initialize bvec table again */
+	do {
+		struct page *page = resync_fetch_page(rp, idx);
+		int len = min_t(int, size, PAGE_SIZE);
+
+		/*
+		 * won't fail because the vec table is big
+		 * enough to hold all these pages
+		 */
+		bio_add_page(bio, page, len, 0);
+		size -= len;
+	} while (idx++ < RESYNC_PAGES && size > 0);
+}
+EXPORT_SYMBOL(md_bio_reset_resync_pages);
+
 #ifndef MODULE
 
 /*
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 2c780aa8d07f..efb32ce7a2f1 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -782,4 +782,7 @@ static inline struct page *resync_fetch_page(struct resync_pages *rp,
 		return NULL;
 	return rp->pages[idx];
 }
+
+void md_bio_reset_resync_pages(struct bio *bio, struct resync_pages *rp,
+			       int size);
 #endif /* _MD_MD_H */
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 7901ddc3362f..5dc3fda2fdf7 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -2085,10 +2085,7 @@ static void process_checks(struct r1bio *r1_bio)
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
@@ -2097,8 +2094,6 @@ static void process_checks(struct r1bio *r1_bio)
 		status = b->bi_status;
 		bio_reset(b);
 		b->bi_status = status;
-		b->bi_vcnt = vcnt;
-		b->bi_iter.bi_size = r1_bio->sectors << 9;
 		b->bi_iter.bi_sector = r1_bio->sector +
 			conf->mirrors[i].rdev->data_offset;
 		b->bi_bdev = conf->mirrors[i].rdev->bdev;
@@ -2106,15 +2101,8 @@ static void process_checks(struct r1bio *r1_bio)
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
+		md_bio_reset_resync_pages(b, rp, r1_bio->sectors << 9);
 	}
 	for (primary = 0; primary < conf->raid_disks * 2; primary++)
 		if (r1_bio->bios[primary]->bi_end_io == end_sync_read &&
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index e594ca610f27..cb8e803cd1c2 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -2086,8 +2086,8 @@ static void sync_request_write(struct mddev *mddev, struct r10bio *r10_bio)
 		rp = get_resync_pages(tbio);
 		bio_reset(tbio);
 
-		tbio->bi_vcnt = vcnt;
-		tbio->bi_iter.bi_size = fbio->bi_iter.bi_size;
+		md_bio_reset_resync_pages(tbio, rp, fbio->bi_iter.bi_size);
+
 		rp->raid_bio = r10_bio;
 		tbio->bi_private = rp;
 		tbio->bi_iter.bi_sector = r10_bio->devs[i].addr;
-- 
2.9.4

