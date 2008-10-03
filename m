From: Denis ChengRq <crquan@gmail.com>
Subject: [PATCH] [VFS] mark bio_split_pool static
Date: Fri,  3 Oct 2008 21:01:18 +0800
Message-ID: <1223038878-8038-1-git-send-email-crquan@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org, Peter Osterlund <petero2@telia.com>, NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

Since all bio_split calls refer the same single bio_split_pool, the bio_split
function can use bio_split_pool directly instead of the mempool_t parameter;

then the mempool_t parameter can be removed from bio_split param list, and
bio_split_pool is only referred in fs/bio.c file, can be marked static.

Signed-off-by: Denis ChengRq <crquan@gmail.com>
---
 drivers/block/pktcdvd.c |    2 +-
 drivers/md/linear.c     |    2 +-
 drivers/md/raid0.c      |    2 +-
 drivers/md/raid10.c     |    2 +-
 fs/bio.c                |    9 ++++-----
 include/linux/bio.h     |    4 +---
 6 files changed, 9 insertions(+), 12 deletions(-)

diff --git a/drivers/block/pktcdvd.c b/drivers/block/pktcdvd.c
index 29b7a64..df8775a 100644
--- a/drivers/block/pktcdvd.c
+++ b/drivers/block/pktcdvd.c
@@ -2544,7 +2544,7 @@ static int pkt_make_request(struct request_queue *q, struct bio *bio)
 		if (last_zone != zone) {
 			BUG_ON(last_zone != zone + pd->settings.size);
 			first_sectors = last_zone - bio->bi_sector;
-			bp = bio_split(bio, bio_split_pool, first_sectors);
+			bp = bio_split(bio, first_sectors);
 			BUG_ON(!bp);
 			pkt_make_request(q, &bp->bio1);
 			pkt_make_request(q, &bp->bio2);
diff --git a/drivers/md/linear.c b/drivers/md/linear.c
index b1eebf8..38e7890 100644
--- a/drivers/md/linear.c
+++ b/drivers/md/linear.c
@@ -349,7 +349,7 @@ static int linear_make_request (struct request_queue *q, struct bio *bio)
 		 * split it.
 		 */
 		struct bio_pair *bp;
-		bp = bio_split(bio, bio_split_pool,
+		bp = bio_split(bio,
 			       ((tmp_dev->offset + tmp_dev->size)<<1) - bio->bi_sector);
 		if (linear_make_request(q, &bp->bio1))
 			generic_make_request(&bp->bio1);
diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index 1836106..b493729 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -423,7 +423,7 @@ static int raid0_make_request (struct request_queue *q, struct bio *bio)
 		/* This is a one page bio that upper layers
 		 * refuse to split for us, so we need to split it.
 		 */
-		bp = bio_split(bio, bio_split_pool, chunk_sects - (bio->bi_sector & (chunk_sects - 1)) );
+		bp = bio_split(bio, chunk_sects - (bio->bi_sector & (chunk_sects - 1)));
 		if (raid0_make_request(q, &bp->bio1))
 			generic_make_request(&bp->bio1);
 		if (raid0_make_request(q, &bp->bio2))
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index e34cd0e..bc1f782 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -816,7 +816,7 @@ static int make_request(struct request_queue *q, struct bio * bio)
 		/* This is a one page bio that upper layers
 		 * refuse to split for us, so we need to split it.
 		 */
-		bp = bio_split(bio, bio_split_pool,
+		bp = bio_split(bio,
 			       chunk_sects - (bio->bi_sector & (chunk_sects - 1)) );
 		if (make_request(q, &bp->bio1))
 			generic_make_request(&bp->bio1);
diff --git a/fs/bio.c b/fs/bio.c
index 3cba7ae..22ce5fb 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -30,7 +30,7 @@
 
 static struct kmem_cache *bio_slab __read_mostly;
 
-mempool_t *bio_split_pool __read_mostly;
+static mempool_t *bio_split_pool __read_mostly;
 
 /*
  * if you change this list, also change bvec_alloc or things will
@@ -1230,9 +1230,9 @@ static void bio_pair_end_2(struct bio *bi, int err)
  * split a bio - only worry about a bio with a single page
  * in it's iovec
  */
-struct bio_pair *bio_split(struct bio *bi, mempool_t *pool, int first_sectors)
+struct bio_pair *bio_split(struct bio *bi, int first_sectors)
 {
-	struct bio_pair *bp = mempool_alloc(pool, GFP_NOIO);
+	struct bio_pair *bp = mempool_alloc(bio_split_pool, GFP_NOIO);
 
 	if (!bp)
 		return bp;
@@ -1266,7 +1266,7 @@ struct bio_pair *bio_split(struct bio *bi, mempool_t *pool, int first_sectors)
 	bp->bio2.bi_end_io = bio_pair_end_2;
 
 	bp->bio1.bi_private = bi;
-	bp->bio2.bi_private = pool;
+	bp->bio2.bi_private = bio_split_pool;
 
 	if (bio_integrity(bi))
 		bio_integrity_split(bi, bp, first_sectors);
@@ -1393,7 +1393,6 @@ EXPORT_SYMBOL(bio_map_kern);
 EXPORT_SYMBOL(bio_copy_kern);
 EXPORT_SYMBOL(bio_pair_release);
 EXPORT_SYMBOL(bio_split);
-EXPORT_SYMBOL(bio_split_pool);
 EXPORT_SYMBOL(bio_copy_user);
 EXPORT_SYMBOL(bio_uncopy_user);
 EXPORT_SYMBOL(bioset_create);
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 0933a14..90d621c 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -319,9 +319,7 @@ struct bio_pair {
 	atomic_t			cnt;
 	int				error;
 };
-extern struct bio_pair *bio_split(struct bio *bi, mempool_t *pool,
-				  int first_sectors);
-extern mempool_t *bio_split_pool;
+extern struct bio_pair *bio_split(struct bio *bi, int first_sectors);
 extern void bio_pair_release(struct bio_pair *dbio);
 
 extern struct bio_set *bioset_create(int, int);
-- 
1.6.0.2

