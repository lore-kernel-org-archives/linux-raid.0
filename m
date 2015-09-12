From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 09/12] raid5-cache: inline r5l_alloc_io_unit into r5l_new_meta
Date: Sat, 12 Sep 2015 08:17:15 +0200
Message-ID: <1442038638-6947-10-git-send-email-hch@lst.de>
References: <1442038638-6947-1-git-send-email-hch@lst.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1442038638-6947-1-git-send-email-hch@lst.de>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@fb.com>, neilb@suse.de
Cc: linux-raid@vger.kernel.org, Kernel-team@fb.com, dan.j.williams@intel.com
List-Id: linux-raid.ids

This is the only user, and keeping all code initializing the io_unit
structure together improves readbility.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/raid5-cache.c | 26 ++++++++------------------
 1 file changed, 8 insertions(+), 18 deletions(-)

diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index df24e9c..82a9d32 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -148,23 +148,6 @@ static bool r5l_has_free_space(struct r5l_log *log, sector_t size)
 	return log->device_size > used_size + size;
 }
 
-static struct r5l_io_unit *r5l_alloc_io_unit(struct r5l_log *log)
-{
-	struct r5l_io_unit *io;
-	/* We can't handle memory allocate failure so far */
-	gfp_t gfp = GFP_NOIO | __GFP_NOFAIL;
-
-	io = kmem_cache_zalloc(log->io_kc, gfp);
-	io->log = log;
-	io->meta_page = alloc_page(gfp | __GFP_ZERO);
-
-	bio_list_init(&io->bios);
-	INIT_LIST_HEAD(&io->log_sibling);
-	INIT_LIST_HEAD(&io->stripe_list);
-	io->state = IO_UNIT_RUNNING;
-	return io;
-}
-
 static void r5l_free_io_unit(struct r5l_log *log, struct r5l_io_unit *io)
 {
 	__free_page(io->meta_page);
@@ -291,8 +274,15 @@ static struct r5l_io_unit *r5l_new_meta(struct r5l_log *log)
 	struct r5l_io_unit *io;
 	struct r5l_meta_block *block;
 
-	io = r5l_alloc_io_unit(log);
+	/* We can't handle memory allocate failure so far */
+	io = kmem_cache_zalloc(log->io_kc, GFP_NOIO | __GFP_NOFAIL);
+	io->log = log;
+	bio_list_init(&io->bios);
+	INIT_LIST_HEAD(&io->log_sibling);
+	INIT_LIST_HEAD(&io->stripe_list);
+	io->state = IO_UNIT_RUNNING;
 
+	io->meta_page = alloc_page(GFP_NOIO | __GFP_NOFAIL | __GFP_ZERO);
 	block = page_address(io->meta_page);
 	block->magic = cpu_to_le32(R5LOG_MAGIC);
 	block->version = R5LOG_VERSION;
-- 
1.9.1

