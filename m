From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 1/3] raid5-cache: use a bio_set
Date: Thu, 17 Dec 2015 23:09:55 +0100
Message-ID: <1450390197-19479-2-git-send-email-hch@lst.de>
References: <1450390197-19479-1-git-send-email-hch@lst.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1450390197-19479-1-git-send-email-hch@lst.de>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.com, shli@fb.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This allows us to make guaranteed forward progress.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/raid5-cache.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index 668e973..0a64e97 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -34,6 +34,12 @@
 #define RECLAIM_MAX_FREE_SPACE (10 * 1024 * 1024 * 2) /* sector */
 #define RECLAIM_MAX_FREE_SPACE_SHIFT (2)
 
+/*
+ * We only need 2 bios per I/O unit to make progress, but ensure we
+ * have a few more available to not get too tight.
+ */
+#define R5L_POOL_SIZE	4
+
 struct r5l_log {
 	struct md_rdev *rdev;
 
@@ -70,6 +76,7 @@ struct r5l_log {
 	struct bio flush_bio;
 
 	struct kmem_cache *io_kc;
+	struct bio_set *bs;
 
 	struct md_thread *reclaim_thread;
 	unsigned long reclaim_target;	/* number of space that need to be
@@ -248,7 +255,7 @@ static void r5l_submit_current_io(struct r5l_log *log)
 
 static struct bio *r5l_bio_alloc(struct r5l_log *log)
 {
-	struct bio *bio = bio_kmalloc(GFP_NOIO | __GFP_NOFAIL, BIO_MAX_PAGES);
+	struct bio *bio = bio_alloc_bioset(GFP_NOIO, BIO_MAX_PAGES, log->bs);
 
 	bio->bi_rw = WRITE;
 	bio->bi_bdev = log->rdev->bdev;
@@ -1153,6 +1160,10 @@ int r5l_init_log(struct r5conf *conf, struct md_rdev *rdev)
 	if (!log->io_kc)
 		goto io_kc;
 
+	log->bs = bioset_create(R5L_POOL_SIZE, 0);
+	if (!log->bs)
+		goto io_bs;
+
 	log->reclaim_thread = md_register_thread(r5l_reclaim_thread,
 						 log->rdev->mddev, "reclaim");
 	if (!log->reclaim_thread)
@@ -1170,6 +1181,8 @@ int r5l_init_log(struct r5conf *conf, struct md_rdev *rdev)
 error:
 	md_unregister_thread(&log->reclaim_thread);
 reclaim_thread:
+	bioset_free(log->bs);
+io_bs:
 	kmem_cache_destroy(log->io_kc);
 io_kc:
 	kfree(log);
@@ -1179,6 +1192,7 @@ io_kc:
 void r5l_exit_log(struct r5l_log *log)
 {
 	md_unregister_thread(&log->reclaim_thread);
+	bioset_free(log->bs);
 	kmem_cache_destroy(log->io_kc);
 	kfree(log);
 }
-- 
1.9.1

