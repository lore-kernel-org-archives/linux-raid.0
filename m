From: Guoqing Jiang <gqjiang@suse.com>
Subject: [PATCH 1/3] md: set MD_CHANGE_PENDING in a atomic region
Date: Tue,  3 May 2016 22:22:13 -0400
Message-ID: <1462328535-22566-1-git-send-email-gqjiang@suse.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: shli@kernel.org
Cc: neilb@suse.de, linux-raid@vger.kernel.org, Guoqing Jiang <gqjiang@suse.com>, Martin Kepplinger <martink@posteo.de>, Andrew Morton <akpm@linux-foundation.org>, Denys Vlasenko <dvlasenk@redhat.com>, Sasha Levin <sasha.levin@oracle.com>, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

Some code waits for a metadata update by:

1. flagging that it is needed (MD_CHANGE_DEVS or MD_CHANGE_CLEAN)
2. setting MD_CHANGE_PENDING and waking the management thread
3. waiting for MD_CHANGE_PENDING to be cleared

If the first two are done without locking, the code in md_update_sb()
which checks if it needs to repeat might test if an update is needed
before step 1, then clear MD_CHANGE_PENDING after step 2, resulting
in the wait returning early.

So make sure all places that set MD_CHANGE_PENDING are atomicial, and
bit_clear_unless (suggested by Neil) is introduced for the purpose.

Cc: Martin Kepplinger <martink@posteo.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Denys Vlasenko <dvlasenk@redhat.com>
Cc: Sasha Levin <sasha.levin@oracle.com>
Cc: <linux-kernel@vger.kernel.org>
Reviewed-by: NeilBrown <neilb@suse.com>
Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
---
 drivers/md/md.c          | 27 ++++++++++++++-------------
 drivers/md/raid1.c       |  4 ++--
 drivers/md/raid10.c      |  8 ++++----
 drivers/md/raid5-cache.c |  4 ++--
 drivers/md/raid5.c       |  4 ++--
 include/linux/bitops.h   | 16 ++++++++++++++++
 6 files changed, 40 insertions(+), 23 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 06f6e81..892d639 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -2295,12 +2295,16 @@ repeat:
 	if (mddev_is_clustered(mddev)) {
 		if (test_and_clear_bit(MD_CHANGE_DEVS, &mddev->flags))
 			force_change = 1;
+		if (test_and_clear_bit(MD_CHANGE_CLEAN, &mddev->flags))
+			nospares = 1;
 		ret = md_cluster_ops->metadata_update_start(mddev);
 		/* Has someone else has updated the sb */
 		if (!does_sb_need_changing(mddev)) {
 			if (ret == 0)
 				md_cluster_ops->metadata_update_cancel(mddev);
-			clear_bit(MD_CHANGE_PENDING, &mddev->flags);
+			bit_clear_unless(&mddev->flags, BIT(MD_CHANGE_PENDING),
+							 BIT(MD_CHANGE_DEVS) |
+							 BIT(MD_CHANGE_CLEAN));
 			return;
 		}
 	}
@@ -2434,15 +2438,11 @@ repeat:
 	if (mddev_is_clustered(mddev) && ret == 0)
 		md_cluster_ops->metadata_update_finish(mddev);
 
-	spin_lock(&mddev->lock);
 	if (mddev->in_sync != sync_req ||
-	    test_bit(MD_CHANGE_DEVS, &mddev->flags)) {
+	    !bit_clear_unless(&mddev->flags, BIT(MD_CHANGE_PENDING),
+			       BIT(MD_CHANGE_DEVS) | BIT(MD_CHANGE_CLEAN)))
 		/* have to write it out again */
-		spin_unlock(&mddev->lock);
 		goto repeat;
-	}
-	clear_bit(MD_CHANGE_PENDING, &mddev->flags);
-	spin_unlock(&mddev->lock);
 	wake_up(&mddev->sb_wait);
 	if (test_bit(MD_RECOVERY_RUNNING, &mddev->recovery))
 		sysfs_notify(&mddev->kobj, NULL, "sync_completed");
@@ -8147,18 +8147,18 @@ void md_do_sync(struct md_thread *thread)
 		}
 	}
  skip:
-	set_bit(MD_CHANGE_DEVS, &mddev->flags);
-
 	if (mddev_is_clustered(mddev) &&
 	    ret == 0) {
 		/* set CHANGE_PENDING here since maybe another
 		 * update is needed, so other nodes are informed */
-		set_bit(MD_CHANGE_PENDING, &mddev->flags);
+		set_mask_bits(&mddev->flags, 0,
+			      BIT(MD_CHANGE_PENDING) | BIT(MD_CHANGE_DEVS));
 		md_wakeup_thread(mddev->thread);
 		wait_event(mddev->sb_wait,
 			   !test_bit(MD_CHANGE_PENDING, &mddev->flags));
 		md_cluster_ops->resync_finish(mddev);
-	}
+	} else
+		set_bit(MD_CHANGE_DEVS, &mddev->flags);
 
 	spin_lock(&mddev->lock);
 	if (!test_bit(MD_RECOVERY_INTR, &mddev->recovery)) {
@@ -8550,6 +8550,7 @@ EXPORT_SYMBOL(md_finish_reshape);
 int rdev_set_badblocks(struct md_rdev *rdev, sector_t s, int sectors,
 		       int is_new)
 {
+	struct mddev *mddev = rdev->mddev;
 	int rv;
 	if (is_new)
 		s += rdev->new_data_offset;
@@ -8559,8 +8560,8 @@ int rdev_set_badblocks(struct md_rdev *rdev, sector_t s, int sectors,
 	if (rv == 0) {
 		/* Make sure they get written out promptly */
 		sysfs_notify_dirent_safe(rdev->sysfs_state);
-		set_bit(MD_CHANGE_CLEAN, &rdev->mddev->flags);
-		set_bit(MD_CHANGE_PENDING, &rdev->mddev->flags);
+		set_mask_bits(&mddev->flags, 0,
+			      BIT(MD_CHANGE_CLEAN) | BIT(MD_CHANGE_PENDING));
 		md_wakeup_thread(rdev->mddev->thread);
 		return 1;
 	} else
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index a7f2b9c..c7c8cde 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1474,8 +1474,8 @@ static void raid1_error(struct mddev *mddev, struct md_rdev *rdev)
 	 * if recovery is running, make sure it aborts.
 	 */
 	set_bit(MD_RECOVERY_INTR, &mddev->recovery);
-	set_bit(MD_CHANGE_DEVS, &mddev->flags);
-	set_bit(MD_CHANGE_PENDING, &mddev->flags);
+	set_mask_bits(&mddev->flags, 0,
+		      BIT(MD_CHANGE_DEVS) | BIT(MD_CHANGE_PENDING));
 	printk(KERN_ALERT
 	       "md/raid1:%s: Disk failure on %s, disabling device.\n"
 	       "md/raid1:%s: Operation continuing on %d devices.\n",
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index e3fd725..f21c4bb 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1102,8 +1102,8 @@ static void __make_request(struct mddev *mddev, struct bio *bio)
 		bio->bi_iter.bi_sector < conf->reshape_progress))) {
 		/* Need to update reshape_position in metadata */
 		mddev->reshape_position = conf->reshape_progress;
-		set_bit(MD_CHANGE_DEVS, &mddev->flags);
-		set_bit(MD_CHANGE_PENDING, &mddev->flags);
+		set_mask_bits(&mddev->flags, 0,
+			      BIT(MD_CHANGE_DEVS) | BIT(MD_CHANGE_PENDING));
 		md_wakeup_thread(mddev->thread);
 		wait_event(mddev->sb_wait,
 			   !test_bit(MD_CHANGE_PENDING, &mddev->flags));
@@ -1591,8 +1591,8 @@ static void raid10_error(struct mddev *mddev, struct md_rdev *rdev)
 	set_bit(MD_RECOVERY_INTR, &mddev->recovery);
 	set_bit(Blocked, &rdev->flags);
 	set_bit(Faulty, &rdev->flags);
-	set_bit(MD_CHANGE_DEVS, &mddev->flags);
-	set_bit(MD_CHANGE_PENDING, &mddev->flags);
+	set_mask_bits(&mddev->flags, 0,
+		      BIT(MD_CHANGE_DEVS) | BIT(MD_CHANGE_PENDING));
 	spin_unlock_irqrestore(&conf->device_lock, flags);
 	printk(KERN_ALERT
 	       "md/raid10:%s: Disk failure on %s, disabling device.\n"
diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index 9531f5f..ac51bc5 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -712,8 +712,8 @@ static void r5l_write_super_and_discard_space(struct r5l_log *log,
 	 * in_teardown check workaround this issue.
 	 */
 	if (!log->in_teardown) {
-		set_bit(MD_CHANGE_DEVS, &mddev->flags);
-		set_bit(MD_CHANGE_PENDING, &mddev->flags);
+		set_mask_bits(&mddev->flags, 0,
+			      BIT(MD_CHANGE_DEVS) | BIT(MD_CHANGE_PENDING));
 		md_wakeup_thread(mddev->thread);
 		wait_event(mddev->sb_wait,
 			!test_bit(MD_CHANGE_PENDING, &mddev->flags) ||
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index e48c262..cd110ce 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -2514,8 +2514,8 @@ static void raid5_error(struct mddev *mddev, struct md_rdev *rdev)
 
 	set_bit(Blocked, &rdev->flags);
 	set_bit(Faulty, &rdev->flags);
-	set_bit(MD_CHANGE_DEVS, &mddev->flags);
-	set_bit(MD_CHANGE_PENDING, &mddev->flags);
+	set_mask_bits(&mddev->flags, 0,
+		      BIT(MD_CHANGE_DEVS) | BIT(MD_CHANGE_PENDING));
 	printk(KERN_ALERT
 	       "md/raid:%s: Disk failure on %s, disabling device.\n"
 	       "md/raid:%s: Operation continuing on %d devices.\n",
diff --git a/include/linux/bitops.h b/include/linux/bitops.h
index defeaac..299e76b 100644
--- a/include/linux/bitops.h
+++ b/include/linux/bitops.h
@@ -227,6 +227,22 @@ static inline unsigned long __ffs64(u64 word)
 })
 #endif
 
+#ifndef bit_clear_unless
+#define bit_clear_unless(ptr, _clear, _test)	\
+({								\
+	const typeof(*ptr) clear = (_clear), test = (_test);	\
+	typeof(*ptr) old, new;					\
+								\
+	do {							\
+		old = ACCESS_ONCE(*ptr);			\
+		new = old & ~clear;				\
+	} while (!(old & test) &&				\
+		 cmpxchg(ptr, old, new) != old);		\
+								\
+	!(old & test);						\
+})
+#endif
+
 #ifndef find_last_bit
 /**
  * find_last_bit - find the last set bit in a memory region
-- 
2.6.6
