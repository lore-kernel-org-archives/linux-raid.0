From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 2/3] raid5-cache: use a mempool for the metadata block
Date: Thu, 17 Dec 2015 23:09:56 +0100
Message-ID: <1450390197-19479-3-git-send-email-hch@lst.de>
References: <1450390197-19479-1-git-send-email-hch@lst.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1450390197-19479-1-git-send-email-hch@lst.de>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.com, shli@fb.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

We only have a limited number in flight, so use a page based mempool.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/raid5-cache.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index 0a64e97..e0a605f 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -77,6 +77,7 @@ struct r5l_log {
 
 	struct kmem_cache *io_kc;
 	struct bio_set *bs;
+	mempool_t *meta_pool;
 
 	struct md_thread *reclaim_thread;
 	unsigned long reclaim_target;	/* number of space that need to be
@@ -216,7 +217,7 @@ static void r5l_log_endio(struct bio *bio)
 		md_error(log->rdev->mddev, log->rdev);
 
 	bio_put(bio);
-	__free_page(io->meta_page);
+	mempool_free(io->meta_page, log->meta_pool);
 
 	spin_lock_irqsave(&log->io_list_lock, flags);
 	__r5l_set_io_unit_state(io, IO_UNIT_IO_END);
@@ -293,8 +294,9 @@ static struct r5l_io_unit *r5l_new_meta(struct r5l_log *log)
 	INIT_LIST_HEAD(&io->stripe_list);
 	io->state = IO_UNIT_RUNNING;
 
-	io->meta_page = alloc_page(GFP_NOIO | __GFP_NOFAIL | __GFP_ZERO);
+	io->meta_page = mempool_alloc(log->meta_pool, GFP_NOIO);
 	block = page_address(io->meta_page);
+	clear_page(block);
 	block->magic = cpu_to_le32(R5LOG_MAGIC);
 	block->version = R5LOG_VERSION;
 	block->seq = cpu_to_le64(log->seq);
@@ -1164,6 +1166,10 @@ int r5l_init_log(struct r5conf *conf, struct md_rdev *rdev)
 	if (!log->bs)
 		goto io_bs;
 
+	log->meta_pool = mempool_create_page_pool(R5L_POOL_SIZE, 0);
+	if (!log->meta_pool)
+		goto out_mempool;
+
 	log->reclaim_thread = md_register_thread(r5l_reclaim_thread,
 						 log->rdev->mddev, "reclaim");
 	if (!log->reclaim_thread)
@@ -1178,9 +1184,12 @@ int r5l_init_log(struct r5conf *conf, struct md_rdev *rdev)
 
 	conf->log = log;
 	return 0;
+
 error:
 	md_unregister_thread(&log->reclaim_thread);
 reclaim_thread:
+	mempool_destroy(log->meta_pool);
+out_mempool:
 	bioset_free(log->bs);
 io_bs:
 	kmem_cache_destroy(log->io_kc);
@@ -1192,6 +1201,7 @@ io_kc:
 void r5l_exit_log(struct r5l_log *log)
 {
 	md_unregister_thread(&log->reclaim_thread);
+	mempool_destroy(log->meta_pool);
 	bioset_free(log->bs);
 	kmem_cache_destroy(log->io_kc);
 	kfree(log);
-- 
1.9.1

