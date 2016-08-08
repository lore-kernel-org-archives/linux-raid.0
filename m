From: shli@kernel.org
Subject: [PATCH 1/2] MD: add extra parameter for .quiesce
Date: Mon,  8 Aug 2016 08:37:03 -0700
Message-ID: <2a17e29eea7636568f6327f4de5fbe90b861fb04.1470670241.git.shli@fb.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: yizhan@redhat.com, gqjiang@suse.com, neilb@suse.com, Shaohua Li <shli@fb.com>
List-Id: linux-raid.ids

From: Shaohua Li <shli@fb.com>

Add extra parameter to indicate if .quiesce is called with reconfig_mutex hold.
The raid5-cache .quiesce will use the parameter to avoid a deadlock.

Signed-off-by: Shaohua Li <shli@fb.com>
---
 drivers/md/bitmap.c      | 12 ++++++------
 drivers/md/linear.c      |  3 ++-
 drivers/md/md-cluster.c  |  8 ++++----
 drivers/md/md.c          | 36 ++++++++++++++++++------------------
 drivers/md/md.h          |  2 +-
 drivers/md/raid0.c       |  3 ++-
 drivers/md/raid1.c       |  3 ++-
 drivers/md/raid10.c      |  3 ++-
 drivers/md/raid5-cache.c |  2 +-
 drivers/md/raid5.c       |  5 +++--
 drivers/md/raid5.h       |  3 ++-
 11 files changed, 43 insertions(+), 37 deletions(-)

diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
index 13041ee..94cb895 100644
--- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@ -2044,7 +2044,7 @@ int bitmap_resize(struct bitmap *bitmap, sector_t blocks,
 	}
 
 	if (!init)
-		bitmap->mddev->pers->quiesce(bitmap->mddev, 1);
+		bitmap->mddev->pers->quiesce(bitmap->mddev, 1, true);
 
 	store.file = bitmap->storage.file;
 	bitmap->storage.file = NULL;
@@ -2158,7 +2158,7 @@ int bitmap_resize(struct bitmap *bitmap, sector_t blocks,
 
 	if (!init) {
 		bitmap_unplug(bitmap);
-		bitmap->mddev->pers->quiesce(bitmap->mddev, 0);
+		bitmap->mddev->pers->quiesce(bitmap->mddev, 0, true);
 	}
 	ret = 0;
 err:
@@ -2207,9 +2207,9 @@ location_store(struct mddev *mddev, const char *buf, size_t len)
 			goto out;
 		}
 		if (mddev->pers) {
-			mddev->pers->quiesce(mddev, 1);
+			mddev->pers->quiesce(mddev, 1, true);
 			bitmap_destroy(mddev);
-			mddev->pers->quiesce(mddev, 0);
+			mddev->pers->quiesce(mddev, 0, true);
 		}
 		mddev->bitmap_info.offset = 0;
 		if (mddev->bitmap_info.file) {
@@ -2246,7 +2246,7 @@ location_store(struct mddev *mddev, const char *buf, size_t len)
 			mddev->bitmap_info.offset = offset;
 			if (mddev->pers) {
 				struct bitmap *bitmap;
-				mddev->pers->quiesce(mddev, 1);
+				mddev->pers->quiesce(mddev, 1, true);
 				bitmap = bitmap_create(mddev, -1);
 				if (IS_ERR(bitmap))
 					rv = PTR_ERR(bitmap);
@@ -2256,7 +2256,7 @@ location_store(struct mddev *mddev, const char *buf, size_t len)
 					if (rv)
 						mddev->bitmap_info.offset = 0;
 				}
-				mddev->pers->quiesce(mddev, 0);
+				mddev->pers->quiesce(mddev, 0, true);
 				if (rv) {
 					bitmap_destroy(mddev);
 					goto out;
diff --git a/drivers/md/linear.c b/drivers/md/linear.c
index 70ff888..25cb10f 100644
--- a/drivers/md/linear.c
+++ b/drivers/md/linear.c
@@ -279,7 +279,8 @@ static void linear_status (struct seq_file *seq, struct mddev *mddev)
 	seq_printf(seq, " %dk rounding", mddev->chunk_sectors / 2);
 }
 
-static void linear_quiesce(struct mddev *mddev, int state)
+static void linear_quiesce(struct mddev *mddev, int state,
+	bool reconfig_mutex_locked)
 {
 }
 
diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
index 41573f1..d9a71c5 100644
--- a/drivers/md/md-cluster.c
+++ b/drivers/md/md-cluster.c
@@ -406,7 +406,7 @@ static void remove_suspend_info(struct mddev *mddev, int slot)
 	spin_lock_irq(&cinfo->suspend_lock);
 	__remove_suspend_info(cinfo, slot);
 	spin_unlock_irq(&cinfo->suspend_lock);
-	mddev->pers->quiesce(mddev, 2);
+	mddev->pers->quiesce(mddev, 2, false);
 }
 
 
@@ -452,14 +452,14 @@ static void process_suspend_info(struct mddev *mddev,
 	s->slot = slot;
 	s->lo = lo;
 	s->hi = hi;
-	mddev->pers->quiesce(mddev, 1);
-	mddev->pers->quiesce(mddev, 0);
+	mddev->pers->quiesce(mddev, 1, false);
+	mddev->pers->quiesce(mddev, 0, false);
 	spin_lock_irq(&cinfo->suspend_lock);
 	/* Remove existing entry (if exists) before adding */
 	__remove_suspend_info(cinfo, slot);
 	list_add(&s->list, &cinfo->suspend_list);
 	spin_unlock_irq(&cinfo->suspend_lock);
-	mddev->pers->quiesce(mddev, 2);
+	mddev->pers->quiesce(mddev, 2, false);
 }
 
 static void process_add_new_disk(struct mddev *mddev, struct cluster_msg *cmsg)
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 2c3ab6f..ac151b9 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -312,7 +312,7 @@ void mddev_suspend(struct mddev *mddev)
 		return;
 	synchronize_rcu();
 	wait_event(mddev->sb_wait, atomic_read(&mddev->active_io) == 0);
-	mddev->pers->quiesce(mddev, 1);
+	mddev->pers->quiesce(mddev, 1, true);
 
 	del_timer_sync(&mddev->safemode_timer);
 }
@@ -323,7 +323,7 @@ void mddev_resume(struct mddev *mddev)
 	if (--mddev->suspended)
 		return;
 	wake_up(&mddev->sb_wait);
-	mddev->pers->quiesce(mddev, 0);
+	mddev->pers->quiesce(mddev, 0, true);
 
 	set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
 	md_wakeup_thread(mddev->thread);
@@ -4664,11 +4664,11 @@ suspend_lo_store(struct mddev *mddev, const char *buf, size_t len)
 	mddev->suspend_lo = new;
 	if (new >= old)
 		/* Shrinking suspended region */
-		mddev->pers->quiesce(mddev, 2);
+		mddev->pers->quiesce(mddev, 2, true);
 	else {
 		/* Expanding suspended region - need to wait */
-		mddev->pers->quiesce(mddev, 1);
-		mddev->pers->quiesce(mddev, 0);
+		mddev->pers->quiesce(mddev, 1, true);
+		mddev->pers->quiesce(mddev, 0, true);
 	}
 	err = 0;
 unlock:
@@ -4707,11 +4707,11 @@ suspend_hi_store(struct mddev *mddev, const char *buf, size_t len)
 	mddev->suspend_hi = new;
 	if (new <= old)
 		/* Shrinking suspended region */
-		mddev->pers->quiesce(mddev, 2);
+		mddev->pers->quiesce(mddev, 2, true);
 	else {
 		/* Expanding suspended region - need to wait */
-		mddev->pers->quiesce(mddev, 1);
-		mddev->pers->quiesce(mddev, 0);
+		mddev->pers->quiesce(mddev, 1, true);
+		mddev->pers->quiesce(mddev, 0, true);
 	}
 	err = 0;
 unlock:
@@ -5509,8 +5509,8 @@ static void mddev_detach(struct mddev *mddev)
 			   atomic_read(&bitmap->behind_writes) == 0);
 	}
 	if (mddev->pers && mddev->pers->quiesce) {
-		mddev->pers->quiesce(mddev, 1);
-		mddev->pers->quiesce(mddev, 0);
+		mddev->pers->quiesce(mddev, 1, true);
+		mddev->pers->quiesce(mddev, 0, true);
 	}
 	md_unregister_thread(&mddev->thread);
 	if (mddev->queue)
@@ -6321,7 +6321,7 @@ static int set_bitmap_file(struct mddev *mddev, int fd)
 		return -ENOENT; /* cannot remove what isn't there */
 	err = 0;
 	if (mddev->pers) {
-		mddev->pers->quiesce(mddev, 1);
+		mddev->pers->quiesce(mddev, 1, true);
 		if (fd >= 0) {
 			struct bitmap *bitmap;
 
@@ -6336,7 +6336,7 @@ static int set_bitmap_file(struct mddev *mddev, int fd)
 			bitmap_destroy(mddev);
 			fd = -1; /* make sure to put the file */
 		}
-		mddev->pers->quiesce(mddev, 0);
+		mddev->pers->quiesce(mddev, 0, true);
 	}
 	if (fd < 0) {
 		struct file *f = mddev->bitmap_info.file;
@@ -6617,7 +6617,7 @@ static int update_array_info(struct mddev *mddev, mdu_array_info_t *info)
 				mddev->bitmap_info.default_offset;
 			mddev->bitmap_info.space =
 				mddev->bitmap_info.default_space;
-			mddev->pers->quiesce(mddev, 1);
+			mddev->pers->quiesce(mddev, 1, true);
 			bitmap = bitmap_create(mddev, -1);
 			if (!IS_ERR(bitmap)) {
 				mddev->bitmap = bitmap;
@@ -6626,7 +6626,7 @@ static int update_array_info(struct mddev *mddev, mdu_array_info_t *info)
 				rv = PTR_ERR(bitmap);
 			if (rv)
 				bitmap_destroy(mddev);
-			mddev->pers->quiesce(mddev, 0);
+			mddev->pers->quiesce(mddev, 0, true);
 		} else {
 			/* remove the bitmap */
 			if (!mddev->bitmap) {
@@ -6650,9 +6650,9 @@ static int update_array_info(struct mddev *mddev, mdu_array_info_t *info)
 				mddev->bitmap_info.nodes = 0;
 				md_cluster_ops->leave(mddev);
 			}
-			mddev->pers->quiesce(mddev, 1);
+			mddev->pers->quiesce(mddev, 1, true);
 			bitmap_destroy(mddev);
-			mddev->pers->quiesce(mddev, 0);
+			mddev->pers->quiesce(mddev, 0, true);
 			mddev->bitmap_info.offset = 0;
 		}
 	}
@@ -7945,8 +7945,8 @@ void md_do_sync(struct md_thread *thread)
 		 * region.
 		 */
 		if (mddev->bitmap) {
-			mddev->pers->quiesce(mddev, 1);
-			mddev->pers->quiesce(mddev, 0);
+			mddev->pers->quiesce(mddev, 1, false);
+			mddev->pers->quiesce(mddev, 0, false);
 		}
 	}
 
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 20c6675..5035ffd 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -500,7 +500,7 @@ struct md_personality
 	 * 1 - no new requests allowed
 	 * others - reserved
 	 */
-	void (*quiesce) (struct mddev *mddev, int state);
+	void (*quiesce) (struct mddev *mddev, int state, bool reconfig_mutex_locked);
 	/* takeover is used to transition an array from one
 	 * personality to another.  The new personality must be able
 	 * to handle the data in the current layout.
diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index c3d4390..faa56c0 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -658,7 +658,8 @@ static void *raid0_takeover(struct mddev *mddev)
 	return ERR_PTR(-EINVAL);
 }
 
-static void raid0_quiesce(struct mddev *mddev, int state)
+static void raid0_quiesce(struct mddev *mddev, int state,
+	bool reconfig_mutex_locked)
 {
 }
 
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 46168ef..98cc597 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -3135,7 +3135,8 @@ static int raid1_reshape(struct mddev *mddev)
 	return 0;
 }
 
-static void raid1_quiesce(struct mddev *mddev, int state)
+static void raid1_quiesce(struct mddev *mddev, int state,
+	bool reconfig_mutex_locked)
 {
 	struct r1conf *conf = mddev->private;
 
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 1a632a8..6d1006d 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -3773,7 +3773,8 @@ static void raid10_free(struct mddev *mddev, void *priv)
 	kfree(conf);
 }
 
-static void raid10_quiesce(struct mddev *mddev, int state)
+static void raid10_quiesce(struct mddev *mddev, int state,
+	bool reconfig_mutex_locked)
 {
 	struct r10conf *conf = mddev->private;
 
diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index 5504ce2..551158c 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -821,7 +821,7 @@ static void r5l_wake_reclaim(struct r5l_log *log, sector_t space)
 	md_wakeup_thread(log->reclaim_thread);
 }
 
-void r5l_quiesce(struct r5l_log *log, int state)
+void r5l_quiesce(struct r5l_log *log, int state, bool reconfig_mutex_locked)
 {
 	struct mddev *mddev;
 	if (!log || state == 2)
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 4f8f524..7949dbf 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -7623,7 +7623,8 @@ static void raid5_finish_reshape(struct mddev *mddev)
 	}
 }
 
-static void raid5_quiesce(struct mddev *mddev, int state)
+static void raid5_quiesce(struct mddev *mddev, int state,
+	bool reconfig_mutex_locked)
 {
 	struct r5conf *conf = mddev->private;
 
@@ -7657,7 +7658,7 @@ static void raid5_quiesce(struct mddev *mddev, int state)
 		unlock_all_device_hash_locks_irq(conf);
 		break;
 	}
-	r5l_quiesce(conf->log, state);
+	r5l_quiesce(conf->log, state, reconfig_mutex_locked);
 }
 
 static void *raid45_takeover_raid0(struct mddev *mddev, int level)
diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
index 517d4b6..ef8eb2e 100644
--- a/drivers/md/raid5.h
+++ b/drivers/md/raid5.h
@@ -633,6 +633,7 @@ extern void r5l_write_stripe_run(struct r5l_log *log);
 extern void r5l_flush_stripe_to_raid(struct r5l_log *log);
 extern void r5l_stripe_write_finished(struct stripe_head *sh);
 extern int r5l_handle_flush_request(struct r5l_log *log, struct bio *bio);
-extern void r5l_quiesce(struct r5l_log *log, int state);
+extern void r5l_quiesce(struct r5l_log *log, int state,
+	bool reconfig_mutex_locked);
 extern bool r5l_log_disk_error(struct r5conf *conf);
 #endif
-- 
2.7.4

