From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 2/2] raid5-cache: free meta_page earlier
Date: Wed,  2 Dec 2015 17:06:39 +0100
Message-ID: <1449072399-15360-3-git-send-email-hch@lst.de>
References: <1449072399-15360-1-git-send-email-hch@lst.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1449072399-15360-1-git-send-email-hch@lst.de>
Sender: linux-raid-owner@vger.kernel.org
To: shli@fb.com, neilb@suse.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Once the I/O completed we don't need the meta page anymore.  As the iounits
can live on for a long time this reduces memory pressure a bit.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/raid5-cache.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index 3699c47..668e973 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -150,12 +150,6 @@ static bool r5l_has_free_space(struct r5l_log *log, sector_t size)
 	return log->device_size > used_size + size;
 }
 
-static void r5l_free_io_unit(struct r5l_log *log, struct r5l_io_unit *io)
-{
-	__free_page(io->meta_page);
-	kmem_cache_free(log->io_kc, io);
-}
-
 static void __r5l_set_io_unit_state(struct r5l_io_unit *io,
 				    enum r5l_io_unit_state state)
 {
@@ -215,6 +209,7 @@ static void r5l_log_endio(struct bio *bio)
 		md_error(log->rdev->mddev, log->rdev);
 
 	bio_put(bio);
+	__free_page(io->meta_page);
 
 	spin_lock_irqsave(&log->io_list_lock, flags);
 	__r5l_set_io_unit_state(io, IO_UNIT_IO_END);
@@ -552,7 +547,7 @@ static bool r5l_complete_finished_ios(struct r5l_log *log)
 		log->next_cp_seq = io->seq;
 
 		list_del(&io->log_sibling);
-		r5l_free_io_unit(log, io);
+		kmem_cache_free(log->io_kc, io);
 
 		found = true;
 	}
-- 
1.9.1

