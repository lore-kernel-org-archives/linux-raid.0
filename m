From: Ming Lei <tom.leiming@gmail.com>
Subject: [PATCH v3 02/14] md: move two macros into md.h
Date: Fri, 17 Mar 2017 00:12:23 +0800
Message-ID: <20170316161235.27110-3-tom.leiming@gmail.com>
References: <20170316161235.27110-1-tom.leiming@gmail.com>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170316161235.27110-1-tom.leiming@gmail.com>
Sender: linux-block-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>, Jens Axboe <axboe@fb.com>, linux-raid@vger.kernel.org, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
Cc: Ming Lei <tom.leiming@gmail.com>
List-Id: linux-raid.ids

Both raid1 and raid10 share common resync
block size and page count, so move them into md.h.

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
---
 drivers/md/md.h     | 5 +++++
 drivers/md/raid1.c  | 2 --
 drivers/md/raid10.c | 3 ---
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/md/md.h b/drivers/md/md.h
index b8859cbf84b6..1d63239a1be4 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -715,4 +715,9 @@ static inline void mddev_check_writesame(struct mddev *mddev, struct bio *bio)
 	    !bdev_get_queue(bio->bi_bdev)->limits.max_write_same_sectors)
 		mddev->queue->limits.max_write_same_sectors = 0;
 }
+
+/* Maximum size of each resync request */
+#define RESYNC_BLOCK_SIZE (64*1024)
+#define RESYNC_PAGES ((RESYNC_BLOCK_SIZE + PAGE_SIZE-1) / PAGE_SIZE)
+
 #endif /* _MD_MD_H */
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 4a0b2ad5025e..908e2caeb704 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -94,10 +94,8 @@ static void r1bio_pool_free(void *r1_bio, void *data)
 	kfree(r1_bio);
 }
 
-#define RESYNC_BLOCK_SIZE (64*1024)
 #define RESYNC_DEPTH 32
 #define RESYNC_SECTORS (RESYNC_BLOCK_SIZE >> 9)
-#define RESYNC_PAGES ((RESYNC_BLOCK_SIZE + PAGE_SIZE-1) / PAGE_SIZE)
 #define RESYNC_WINDOW (RESYNC_BLOCK_SIZE * RESYNC_DEPTH)
 #define RESYNC_WINDOW_SECTORS (RESYNC_WINDOW >> 9)
 #define CLUSTER_RESYNC_WINDOW (16 * RESYNC_WINDOW)
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index b4a56a488668..2b40420299e3 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -125,9 +125,6 @@ static void r10bio_pool_free(void *r10_bio, void *data)
 	kfree(r10_bio);
 }
 
-/* Maximum size of each resync request */
-#define RESYNC_BLOCK_SIZE (64*1024)
-#define RESYNC_PAGES ((RESYNC_BLOCK_SIZE + PAGE_SIZE-1) / PAGE_SIZE)
 /* amount of memory to reserve for resync requests */
 #define RESYNC_WINDOW (1024*1024)
 /* maximum number of concurrent requests, memory permitting */
-- 
2.9.3
