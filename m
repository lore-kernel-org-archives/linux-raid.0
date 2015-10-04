From: Shaohua Li <shli@fb.com>
Subject: [PATCH 3/6] raid5-cache: add trim support for log
Date: Sun, 4 Oct 2015 09:20:13 -0700
Message-ID: <581084e9c46ee200f8fedf2dcfec4e897517c0ed.1443973492.git.shli@fb.com>
References: <cover.1443973492.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <cover.1443973492.git.shli@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Kernel-team@fb.com, songliubraving@fb.com, hch@infradead.org, dan.j.williams@intel.com, neilb@suse.de
List-Id: linux-raid.ids

Since superblock is updated infrequently, we do a simple trim of log
disk (a synchronous trim)

Signed-off-by: Shaohua Li <shli@fb.com>
---
 drivers/md/raid5-cache.c | 38 +++++++++++++++++++++++++++++++++++++-
 1 file changed, 37 insertions(+), 1 deletion(-)

diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index 93097a8..6c52168 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -654,6 +654,42 @@ static void r5l_kick_io_unit(struct r5l_log *log)
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
+	mddev = log->rdev->mddev;
+	if (!mddev_is_locked(mddev)) {
+		set_bit(MD_CHANGE_PENDING, &mddev->flags);
+		md_wakeup_thread(mddev->thread);
+		wait_event(mddev->sb_wait,
+			   !test_bit(MD_CHANGE_PENDING, &mddev->flags));
+	} else { /* we are stopping the array, already take reconfig_mutex */
+		md_update_sb(mddev, 1);
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
@@ -709,7 +745,7 @@ static void r5l_do_reclaim(struct r5l_log *log)
 	 * here, because the log area might be reused soon and we don't want to
 	 * confuse recovery
 	 */
-	r5l_write_super(log, last->log_start);
+	r5l_write_super_and_discard_space(log, last->log_start);
 
 	mutex_lock(&log->io_mutex);
 	log->last_checkpoint = last->log_start;
-- 
2.4.6

