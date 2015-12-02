From: Christoph Hellwig <hch@lst.de>
Subject: [RFC] using mempools for raid5-cache
Date: Wed,  2 Dec 2015 17:10:36 +0100
Message-ID: <1449072638-15409-1-git-send-email-hch@lst.de>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: shli@fb.com, neilb@suse.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Currently the raid5-cache code is heavily relying on GFP_NOFAIL allocations.

I've looked into replacing these with mempools and biosets, and for the
bio and the meta_page that's pretty trivial as they have short life times
and do make guaranteed progress.  I'm massively struggling with the iounit
allocation, though.  These can live on for a long time over log I/O, cache
flushing and last but not least RAID I/O, and every attempt at something
mempool-like results in reproducible deadlocks.  I wonder if we need to
figure out some more efficient data structure to communicate the completion
status that doesn't rely on these fairly long living allocations from
the I/O path.

FYI, my last attempt to use the bio frontpad is below, but a mempool showed
pretty similar results:

diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index 2e3f22a..d2438be 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -33,12 +33,12 @@
  */
 #define RECLAIM_MAX_FREE_SPACE (10 * 1024 * 1024 * 2) /* sector */
 #define RECLAIM_MAX_FREE_SPACE_SHIFT (2)
-
+	
 /*
  * We only need 2 bios per I/O unit to make progress, but ensure we
  * have a few more available to not get too tight.
  */
-#define R5L_POOL_SIZE	1024
+#define R5L_POOL_SIZE	16384
 
 struct r5l_log {
 	struct md_rdev *rdev;
@@ -75,7 +75,6 @@ struct r5l_log {
 	struct list_head finished_ios;	/* io_units which settle down in log disk */
 	struct bio flush_bio;
 
-	struct kmem_cache *io_kc;
 	struct bio_set *bs;
 	mempool_t *meta_pool;
 
@@ -120,6 +119,8 @@ struct r5l_io_unit {
 
 	int state;
 	bool need_split_bio;
+
+	struct bio bio;
 };
 
 /* r5l_io_unit state */
@@ -209,14 +210,13 @@ static void r5l_move_to_end_ios(struct r5l_log *log)
 
 static void r5l_log_endio(struct bio *bio)
 {
-	struct r5l_io_unit *io = bio->bi_private;
+	struct r5l_io_unit *io = container_of(bio, struct r5l_io_unit, bio);
 	struct r5l_log *log = io->log;
 	unsigned long flags;
 
 	if (bio->bi_error)
 		md_error(log->rdev->mddev, log->rdev);
 
-	bio_put(bio);
 	mempool_free(io->meta_page, log->meta_pool);
 
 	spin_lock_irqsave(&log->io_list_lock, flags);
@@ -284,11 +284,13 @@ static void r5_reserve_log_entry(struct r5l_log *log, struct r5l_io_unit *io)
 
 static struct r5l_io_unit *r5l_new_meta(struct r5l_log *log)
 {
+	struct bio *bio;
 	struct r5l_io_unit *io;
 	struct r5l_meta_block *block;
 
-	/* We can't handle memory allocate failure so far */
-	io = kmem_cache_zalloc(log->io_kc, GFP_NOIO | __GFP_NOFAIL);
+	bio = r5l_bio_alloc(log);
+
+	io = container_of(bio, struct r5l_io_unit, bio);
 	io->log = log;
 	INIT_LIST_HEAD(&io->log_sibling);
 	INIT_LIST_HEAD(&io->stripe_list);
@@ -306,7 +308,7 @@ static struct r5l_io_unit *r5l_new_meta(struct r5l_log *log)
 	io->meta_offset = sizeof(struct r5l_meta_block);
 	io->seq = log->seq++;
 
-	io->current_bio = r5l_bio_alloc(log);
+	io->current_bio = bio;
 	io->current_bio->bi_end_io = r5l_log_endio;
 	io->current_bio->bi_private = io;
 	bio_add_page(io->current_bio, io->meta_page, PAGE_SIZE, 0);
@@ -556,7 +558,7 @@ static bool r5l_complete_finished_ios(struct r5l_log *log)
 		log->next_cp_seq = io->seq;
 
 		list_del(&io->log_sibling);
-		kmem_cache_free(log->io_kc, io);
+		bio_put(&io->bio);
 
 		found = true;
 	}
@@ -1158,11 +1160,8 @@ int r5l_init_log(struct r5conf *conf, struct md_rdev *rdev)
 	INIT_LIST_HEAD(&log->finished_ios);
 	bio_init(&log->flush_bio);
 
-	log->io_kc = KMEM_CACHE(r5l_io_unit, 0);
-	if (!log->io_kc)
-		goto io_kc;
-
-	log->bs = bioset_create(R5L_POOL_SIZE, 0);
+	log->bs = bioset_create(R5L_POOL_SIZE,
+			offsetof(struct r5l_io_unit, bio));
 	if (!log->bs)
 		goto io_bs;
 
@@ -1192,8 +1191,6 @@ reclaim_thread:
 out_mempool:
 	bioset_free(log->bs);
 io_bs:
-	kmem_cache_destroy(log->io_kc);
-io_kc:
 	kfree(log);
 	return -EINVAL;
 }
@@ -1203,6 +1200,5 @@ void r5l_exit_log(struct r5l_log *log)
 	md_unregister_thread(&log->reclaim_thread);
 	mempool_destroy(log->meta_pool);
 	bioset_free(log->bs);
-	kmem_cache_destroy(log->io_kc);
 	kfree(log);
 }

