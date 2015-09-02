From: Shaohua Li <shli@fb.com>
Subject: [PATCH 8/8] raid5-cache: add trim support for log
Date: Wed, 2 Sep 2015 13:49:51 -0700
Message-ID: <4ac2b019b16111478c46ea6decb672d5a4de7de3.1441221530.git.shli@fb.com>
References: <cover.1441221530.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <cover.1441221530.git.shli@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Kernel-team@fb.com, songliubraving@fb.com, hch@infradead.org, dan.j.williams@intel.com, neilb@suse.de
List-Id: linux-raid.ids

Since superblock is updated infrequently, we do a simple trim of log
disk (a synchronous trim)

Signed-off-by: Shaohua Li <shli@fb.com>
---
 drivers/md/raid5-cache.c | 30 +++++++++++++++++++++++++++++-
 1 file changed, 29 insertions(+), 1 deletion(-)

diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index 27fb513..410b85b 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -639,6 +639,34 @@ static void r5l_kick_io_unit(struct r5l_log *log)
 }
 
 static void r5l_write_super(struct r5l_log *log, sector_t cp);
+static void r5l_write_super_and_discard_space(struct r5l_log *log,
+	sector_t end)
+{
+	struct block_device *bdev = log->rdev->bdev;
+
+	r5l_write_super(log, end);
+
+	if (!blk_queue_discard(bdev_get_queue(bdev)))
+		return;
+
+	/* discard destroy old data in log, so force a super update */
+	md_update_sb(log->rdev->mddev, 1);
+
+	if (log->last_checkpoint < end) {
+		blkdev_issue_discard(bdev,
+				log->last_checkpoint + log->rdev->data_offset,
+				end - log->last_checkpoint, GFP_NOIO, 0);
+	} else {
+		blkdev_issue_discard(bdev,
+				log->last_checkpoint + log->rdev->data_offset,
+				log->device_size - log->last_checkpoint,
+				GFP_NOIO, 0);
+		blkdev_issue_discard(bdev, log->rdev->data_offset, end,
+				GFP_NOIO, 0);
+	}
+}
+
+
 static void r5l_do_reclaim(struct r5l_log *log)
 {
 	struct r5l_io_unit *io, *last;
@@ -694,7 +722,7 @@ static void r5l_do_reclaim(struct r5l_log *log)
 	 * here, because the log area might be reused soon and we don't want to
 	 * confuse recovery
 	 * */
-	r5l_write_super(log, last->log_start);
+	r5l_write_super_and_discard_space(log, last->log_start);
 
 	mutex_lock(&log->io_mutex);
 	log->last_checkpoint = last->log_start;
-- 
1.8.1

