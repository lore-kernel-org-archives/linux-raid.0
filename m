From: Shaohua Li <shli@fb.com>
Subject: [PATCH 1/3] raid5-cache: add trim support for log
Date: Wed, 30 Sep 2015 16:15:38 -0700
Message-ID: <9ee5464d20a78732ba4dda9c0601ea10d47f0e03.1443653794.git.shli@fb.com>
References: <cover.1443653794.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <cover.1443653794.git.shli@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Kernel-team@fb.com, songliubraving@fb.com, hch@infradead.org, dan.j.williams@intel.com, neilb@suse.de
List-Id: linux-raid.ids

Since superblock is updated infrequently, we do a simple trim of log
disk (a synchronous trim)

Signed-off-by: Shaohua Li <shli@fb.com>
---
 drivers/md/raid5-cache.c | 44 +++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 43 insertions(+), 1 deletion(-)

diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index a02f9ce..afc3b6b 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -654,6 +654,48 @@ static void r5l_kick_io_unit(struct r5l_log *log)
 }
 
 static void r5l_write_super(struct r5l_log *log, sector_t cp);
+static void r5l_write_super_and_discard_space(struct r5l_log *log,
+	sector_t end)
+{
+	struct block_device *bdev = log->rdev->bdev;
+	struct mddev *mddev;
+
+	r5l_write_super(log, end);
+
+	if (!blk_queue_discard(bdev_get_queue(bdev)))
+		return;
+
+	/* discard destroy old data in log, so force a super update */
+	mddev = log->rdev->mddev;
+	/*
+	 * mddev->thread could be shut down already in raid array stop. At that
+	 * time, we should already lock reconfig_mutex
+	 * */
+	if (!mddev->thread) {
+		WARN_ON(!mddev_is_locked(mddev));
+		md_update_sb(mddev, 1);
+	} else {
+		set_bit(MD_CHANGE_PENDING, &mddev->flags);
+		md_wakeup_thread(mddev->thread);
+		wait_event(mddev->sb_wait,
+			   !test_bit(MD_CHANGE_PENDING, &mddev->flags));
+	}
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
@@ -709,7 +751,7 @@ static void r5l_do_reclaim(struct r5l_log *log)
 	 * here, because the log area might be reused soon and we don't want to
 	 * confuse recovery
 	 */
-	r5l_write_super(log, last->log_start);
+	r5l_write_super_and_discard_space(log, last->log_start);
 
 	mutex_lock(&log->io_mutex);
 	log->last_checkpoint = last->log_start;
-- 
2.4.6

