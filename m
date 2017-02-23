From: Shaohua Li <shli@fb.com>
Subject: [PATCH 2/2] md: delete dead code
Date: Thu, 23 Feb 2017 12:34:35 -0800
Message-ID: <c50373e8960c41ec6cd3ab7308e666acd4e6d7c1.1487881989.git.shli@fb.com>
References: <bf67a7498d5807e3913762f63402f367a6de401e.1487881989.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <bf67a7498d5807e3913762f63402f367a6de401e.1487881989.git.shli@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.com
List-Id: linux-raid.ids

Nobody is using mddev_check_plugged(), so delete the dead code

Signed-off-by: Shaohua Li <shli@fb.com>
---
 drivers/md/md.c | 8 --------
 drivers/md/md.h | 6 ------
 2 files changed, 14 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index bef1863..b97f133 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -439,14 +439,6 @@ void md_flush_request(struct mddev *mddev, struct bio *bio)
 }
 EXPORT_SYMBOL(md_flush_request);
 
-void md_unplug(struct blk_plug_cb *cb, bool from_schedule)
-{
-	struct mddev *mddev = cb->data;
-	md_wakeup_thread(mddev->thread);
-	kfree(cb);
-}
-EXPORT_SYMBOL(md_unplug);
-
 static inline struct mddev *mddev_get(struct mddev *mddev)
 {
 	atomic_inc(&mddev->active);
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 44fe227..8c4f462 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -674,16 +674,10 @@ extern void md_rdev_clear(struct md_rdev *rdev);
 extern void mddev_suspend(struct mddev *mddev);
 extern void mddev_resume(struct mddev *mddev);
 
-extern void md_unplug(struct blk_plug_cb *cb, bool from_schedule);
 extern void md_reload_sb(struct mddev *mddev, int raid_disk);
 extern void md_update_sb(struct mddev *mddev, int force);
 extern void md_kick_rdev_from_array(struct md_rdev * rdev);
 struct md_rdev *md_find_rdev_nr_rcu(struct mddev *mddev, int nr);
-static inline int mddev_check_plugged(struct mddev *mddev)
-{
-	return !!blk_check_plugged(md_unplug, mddev,
-				   sizeof(struct blk_plug_cb));
-}
 
 static inline void rdev_dec_pending(struct md_rdev *rdev, struct mddev *mddev)
 {
-- 
2.9.3

