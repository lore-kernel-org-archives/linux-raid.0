From: Shaohua Li <shli@fb.com>
Subject: [PATCH] raid5-cache: add journal hot add/remove support
Date: Mon, 14 Dec 2015 22:22:36 -0800
Message-ID: <48dfb85817d51f68d8da85368711ed14f945caa4.1450159900.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
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
 drivers/md/md.c    | 44 +++++++++++++++++++++++++++++++++-----------
 drivers/md/raid5.c | 31 +++++++++++++++++++++++--------
 2 files changed, 56 insertions(+), 19 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 807095f..de9e3a1 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -2053,7 +2053,9 @@ static int bind_rdev_to_array(struct md_rdev *rdev, struct mddev *mddev)
 
 	/* make sure rdev->sectors exceeds mddev->dev_sectors */
 	if (rdev->sectors && (mddev->dev_sectors == 0 ||
-			rdev->sectors < mddev->dev_sectors)) {
+			rdev->sectors < mddev->dev_sectors) &&
+	    !(test_bit(MD_HAS_JOURNAL, &mddev->flags) &&
+	      test_bit(Journal, &rdev->flags))) {
 		if (mddev->pers) {
 			/* Cannot change size, so fail
 			 * If mddev->level <= 0, then we don't care
@@ -2084,7 +2086,9 @@ static int bind_rdev_to_array(struct md_rdev *rdev, struct mddev *mddev)
 		}
 	}
 	rcu_read_unlock();
-	if (mddev->max_disks && rdev->desc_nr >= mddev->max_disks) {
+	if (mddev->max_disks && rdev->desc_nr >= mddev->max_disks &&
+	    !(test_bit(MD_HAS_JOURNAL, &mddev->flags) &&
+	     test_bit(Journal, &rdev->flags))) {
 		printk(KERN_WARNING "md: %s: array is limited to %d devices\n",
 		       mdname(mddev), mddev->max_disks);
 		return -EBUSY;
@@ -6031,8 +6035,25 @@ static int add_new_disk(struct mddev *mddev, mdu_disk_info_t *info)
 		else
 			clear_bit(WriteMostly, &rdev->flags);
 
-		if (info->state & (1<<MD_DISK_JOURNAL))
+		if (info->state & (1<<MD_DISK_JOURNAL)) {
+			struct md_rdev *rdev2;
+			bool has_journal = false;
+
+			/* make sure no existing journal disk */
+			rcu_read_lock();
+			rdev_for_each(rdev2, mddev) {
+				if (test_bit(Journal, &rdev2->flags)) {
+					has_journal = true;
+					break;
+				}
+			}
+			rcu_read_unlock();
+			if (has_journal) {
+				export_rdev(rdev);
+				return -EBUSY;
+			}
 			set_bit(Journal, &rdev->flags);
+		}
 		/*
 		 * check whether the device shows up in other nodes
 		 */
@@ -8162,19 +8183,20 @@ static int remove_and_add_spares(struct mddev *mddev,
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
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 704ef7f..f8f3d52 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -7141,14 +7141,16 @@ static int raid5_remove_disk(struct mddev *mddev, struct md_rdev *rdev)
 	struct disk_info *p = conf->disks + number;
 
 	print_raid5_conf(conf);
-	if (test_bit(Journal, &rdev->flags)) {
+	if (test_bit(Journal, &rdev->flags) && conf->log) {
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
+		r5l_exit_log(conf->log);
+		conf->log = NULL;
+		return 0;
 	}
 	if (rdev == p->rdev)
 		rdevp = &p->rdev;
@@ -7212,8 +7214,21 @@ static int raid5_add_disk(struct mddev *mddev, struct md_rdev *rdev)
 	int first = 0;
 	int last = conf->raid_disks - 1;
 
-	if (test_bit(Journal, &rdev->flags))
-		return -EINVAL;
+	if (test_bit(Journal, &rdev->flags)) {
+		char b[BDEVNAME_SIZE];
+		if (conf->log)
+			return -EBUSY;
+
+		rdev->raid_disk = mddev->raid_disks;
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

