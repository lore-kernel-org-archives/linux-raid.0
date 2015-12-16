From: Shaohua Li <shli@fb.com>
Subject: [PATCH 2/2] raid5-cache: add journal hot add/remove support
Date: Wed, 16 Dec 2015 13:13:48 -0800
Message-ID: <2b10b1d8988431c43f013fecc28008fb4585c888.1450300354.git.shli@fb.com>
References: <2f750625c6c016754fabfab98b84e6f2719bb0e5.1450300354.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <2f750625c6c016754fabfab98b84e6f2719bb0e5.1450300354.git.shli@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Kernel-team@fb.com, songliubraving@fb.com, hch@infradead.org, neilb@suse.de
List-Id: linux-raid.ids

Add support for journal disk hot add/remove. Mostly trival checks in md
part. The raid5 part is a little tricky. For hot-remove, we can't wait
pending write as it's called from raid5d. The wait will cause deadlock.
We simplily fail the hot-remove. A hot-remove retry can success
eventually since if journal disk is faulty all pending write will be
failed and finish. For hot-add, since an array supporting journal but
without journal disk will be marked read-only, we are safe to hot add
journal without stopping IO (should be read IO, while journal only
handles write IO).

Signed-off-by: Shaohua Li <shli@fb.com>
---
 drivers/md/md.c          | 42 ++++++++++++++++++++++++++++++------------
 drivers/md/raid5-cache.c | 16 ++++++++++++----
 drivers/md/raid5.c       | 34 ++++++++++++++++++++++++++--------
 3 files changed, 68 insertions(+), 24 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 874c843..7e0a7c6 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -2052,8 +2052,9 @@ static int bind_rdev_to_array(struct md_rdev *rdev, struct mddev *mddev)
 		return -EEXIST;
 
 	/* make sure rdev->sectors exceeds mddev->dev_sectors */
-	if (rdev->sectors && (mddev->dev_sectors == 0 ||
-			rdev->sectors < mddev->dev_sectors)) {
+	if (!test_bit(Journal, &rdev->flags) &&
+	    rdev->sectors &&
+	    (mddev->dev_sectors == 0 || rdev->sectors < mddev->dev_sectors)) {
 		if (mddev->pers) {
 			/* Cannot change size, so fail
 			 * If mddev->level <= 0, then we don't care
@@ -2084,7 +2085,8 @@ static int bind_rdev_to_array(struct md_rdev *rdev, struct mddev *mddev)
 		}
 	}
 	rcu_read_unlock();
-	if (mddev->max_disks && rdev->desc_nr >= mddev->max_disks) {
+	if (!test_bit(Journal, &rdev->flags) &&
+	    mddev->max_disks && rdev->desc_nr >= mddev->max_disks) {
 		printk(KERN_WARNING "md: %s: array is limited to %d devices\n",
 		       mdname(mddev), mddev->max_disks);
 		return -EBUSY;
@@ -6031,8 +6033,23 @@ static int add_new_disk(struct mddev *mddev, mdu_disk_info_t *info)
 		else
 			clear_bit(WriteMostly, &rdev->flags);
 
-		if (info->state & (1<<MD_DISK_JOURNAL))
+		if (info->state & (1<<MD_DISK_JOURNAL)) {
+			struct md_rdev *rdev2;
+			bool has_journal = false;
+
+			/* make sure no existing journal disk */
+			rdev_for_each(rdev2, mddev) {
+				if (test_bit(Journal, &rdev2->flags)) {
+					has_journal = true;
+					break;
+				}
+			}
+			if (has_journal) {
+				export_rdev(rdev);
+				return -EBUSY;
+			}
 			set_bit(Journal, &rdev->flags);
+		}
 		/*
 		 * check whether the device shows up in other nodes
 		 */
@@ -8162,19 +8179,20 @@ static int remove_and_add_spares(struct mddev *mddev,
 			continue;
 		if (test_bit(Faulty, &rdev->flags))
 			continue;
-		if (test_bit(Journal, &rdev->flags))
-			continue;
-		if (mddev->ro &&
-		    ! (rdev->saved_raid_disk >= 0 &&
-		       !test_bit(Bitmap_sync, &rdev->flags)))
-			continue;
+		if (!test_bit(Journal, &rdev->flags)) {
+			if (mddev->ro &&
+			    ! (rdev->saved_raid_disk >= 0 &&
+			       !test_bit(Bitmap_sync, &rdev->flags)))
+				continue;
 
-		rdev->recovery_offset = 0;
+			rdev->recovery_offset = 0;
+		}
 		if (mddev->pers->
 		    hot_add_disk(mddev, rdev) == 0) {
 			if (sysfs_link_rdev(mddev, rdev))
 				/* failure here is OK */;
-			spares++;
+			if (!test_bit(Journal, &rdev->flags))
+				spares++;
 			md_new_event(mddev);
 			set_bit(MD_CHANGE_DEVS, &mddev->flags);
 		}
diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index b887e04..9cd32c2 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -806,10 +806,18 @@ void r5l_quiesce(struct r5l_log *log, int state)
 
 bool r5l_log_disk_error(struct r5conf *conf)
 {
+	struct r5l_log *log;
+	bool ret;
 	/* don't allow write if journal disk is missing */
-	if (!conf->log)
-		return test_bit(MD_HAS_JOURNAL, &conf->mddev->flags);
-	return test_bit(Faulty, &conf->log->rdev->flags);
+	rcu_read_lock();
+	log = rcu_dereference(conf->log);
+
+	if (!log)
+		ret = test_bit(MD_HAS_JOURNAL, &conf->mddev->flags);
+	else
+		ret = test_bit(Faulty, &log->rdev->flags);
+	rcu_read_unlock();
+	return ret;
 }
 
 struct r5l_recovery_ctx {
@@ -1172,7 +1180,7 @@ int r5l_init_log(struct r5conf *conf, struct md_rdev *rdev)
 	if (r5l_load_log(log))
 		goto error;
 
-	conf->log = log;
+	rcu_assign_pointer(conf->log, log);
 	return 0;
 error:
 	md_unregister_thread(&log->reclaim_thread);
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 704ef7f..783376b 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -7141,14 +7141,19 @@ static int raid5_remove_disk(struct mddev *mddev, struct md_rdev *rdev)
 	struct disk_info *p = conf->disks + number;
 
 	print_raid5_conf(conf);
-	if (test_bit(Journal, &rdev->flags)) {
+	if (test_bit(Journal, &rdev->flags) && conf->log) {
+		struct r5l_log *log;
 		/*
-		 * journal disk is not removable, but we need give a chance to
-		 * update superblock of other disks. Otherwise journal disk
-		 * will be considered as 'fresh'
+		 * we can't wait pending write here, as this is called in
+		 * raid5d, wait will deadlock.
 		 */
-		set_bit(MD_CHANGE_DEVS, &mddev->flags);
-		return -EINVAL;
+		if (atomic_read(&mddev->writes_pending))
+			return -EBUSY;
+		log = conf->log;
+		conf->log = NULL;
+		synchronize_rcu();
+		r5l_exit_log(log);
+		return 0;
 	}
 	if (rdev == p->rdev)
 		rdevp = &p->rdev;
@@ -7212,8 +7217,21 @@ static int raid5_add_disk(struct mddev *mddev, struct md_rdev *rdev)
 	int first = 0;
 	int last = conf->raid_disks - 1;
 
-	if (test_bit(Journal, &rdev->flags))
-		return -EINVAL;
+	if (test_bit(Journal, &rdev->flags)) {
+		char b[BDEVNAME_SIZE];
+		if (conf->log)
+			return -EBUSY;
+
+		rdev->raid_disk = 0;
+		/*
+		 * The array is in readonly mode if journal is missing, so no
+		 * write requests running. We should be safe
+		 */
+		r5l_init_log(conf, rdev);
+		printk(KERN_INFO"md/raid:%s: using device %s as journal\n",
+		       mdname(mddev), bdevname(rdev->bdev, b));
+		return 0;
+	}
 	if (mddev->recovery_disabled == conf->recovery_disabled)
 		return -EBUSY;
 
-- 
2.4.6

