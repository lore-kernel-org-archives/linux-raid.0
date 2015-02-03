From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 13/26] md: protect ->pers changes with mddev->lock
Date: Wed, 04 Feb 2015 08:42:29 +1100
Message-ID: <20150203214229.3448.30410.stgit@notabene.brown>
References: <20150203213948.3448.80258.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150203213948.3448.80258.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

->pers is already protected by ->reconfig_mutex, and
cannot possibly change when there are threads running or
outstanding IO.

However there are some places where we access ->pers
not in a thread or IO context, and where ->reconfig_mutex
is unnecessarily heavy-weight:  level_show and md_seq_show().

So protect all changes, and those accesses, with ->lock.
This is a step toward taking those accesses out from under
reconfig_mutex.

Signed-off-by: NeilBrown <neilb@suse.de>
---
 drivers/md/md.c |   51 ++++++++++++++++++++++++++++++++-------------------
 drivers/md/md.h |    1 +
 2 files changed, 33 insertions(+), 19 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 58f531f8dcc2..421d47e2d457 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -3264,15 +3264,20 @@ __ATTR(safe_mode_delay, S_IRUGO|S_IWUSR,safe_delay_show, safe_delay_store);
 static ssize_t
 level_show(struct mddev *mddev, char *page)
 {
-	struct md_personality *p = mddev->pers;
+	struct md_personality *p;
+	int ret;
+	spin_lock(&mddev->lock);
+	p = mddev->pers;
 	if (p)
-		return sprintf(page, "%s\n", p->name);
+		ret = sprintf(page, "%s\n", p->name);
 	else if (mddev->clevel[0])
-		return sprintf(page, "%s\n", mddev->clevel);
+		ret = sprintf(page, "%s\n", mddev->clevel);
 	else if (mddev->level != LEVEL_NONE)
-		return sprintf(page, "%d\n", mddev->level);
+		ret = sprintf(page, "%d\n", mddev->level);
 	else
-		return 0;
+		ret = 0;
+	spin_unlock(&mddev->lock);
+	return ret;
 }
 
 static ssize_t
@@ -3374,6 +3379,8 @@ level_store(struct mddev *mddev, const char *buf, size_t len)
 	/* Looks like we have a winner */
 	mddev_suspend(mddev);
 	mddev_detach(mddev);
+
+	spin_lock(&mddev->lock);
 	oldpers = mddev->pers;
 	oldpriv = mddev->private;
 	mddev->pers = pers;
@@ -3385,6 +3392,7 @@ level_store(struct mddev *mddev, const char *buf, size_t len)
 	mddev->delta_disks = 0;
 	mddev->reshape_backwards = 0;
 	mddev->degraded = 0;
+	spin_unlock(&mddev->lock);
 
 	if (oldpers->sync_request == NULL &&
 	    mddev->external) {
@@ -4866,7 +4874,6 @@ int md_run(struct mddev *mddev)
 			       mddev->clevel);
 		return -EINVAL;
 	}
-	mddev->pers = pers;
 	spin_unlock(&pers_lock);
 	if (mddev->level != pers->level) {
 		mddev->level = pers->level;
@@ -4877,7 +4884,6 @@ int md_run(struct mddev *mddev)
 	if (mddev->reshape_position != MaxSector &&
 	    pers->start_reshape == NULL) {
 		/* This personality cannot handle reshaping... */
-		mddev->pers = NULL;
 		module_put(pers->owner);
 		return -EINVAL;
 	}
@@ -4921,10 +4927,10 @@ int md_run(struct mddev *mddev)
 	if (start_readonly && mddev->ro == 0)
 		mddev->ro = 2; /* read-only, but switch on first write */
 
-	err = mddev->pers->run(mddev);
+	err = pers->run(mddev);
 	if (err)
 		printk(KERN_ERR "md: pers->run() failed ...\n");
-	else if (mddev->pers->size(mddev, 0, 0) < mddev->array_sectors) {
+	else if (pers->size(mddev, 0, 0) < mddev->array_sectors) {
 		WARN_ONCE(!mddev->external_size, "%s: default size too small,"
 			  " but 'external_size' not in effect?\n", __func__);
 		printk(KERN_ERR
@@ -4933,7 +4939,7 @@ int md_run(struct mddev *mddev)
 		       (unsigned long long)mddev->pers->size(mddev, 0, 0) / 2);
 		err = -EINVAL;
 	}
-	if (err == 0 && mddev->pers->sync_request &&
+	if (err == 0 && pers->sync_request &&
 	    (mddev->bitmap_info.file || mddev->bitmap_info.offset)) {
 		err = bitmap_create(mddev);
 		if (err)
@@ -4942,9 +4948,8 @@ int md_run(struct mddev *mddev)
 	}
 	if (err) {
 		mddev_detach(mddev);
-		mddev->pers->free(mddev, mddev->private);
-		module_put(mddev->pers->owner);
-		mddev->pers = NULL;
+		pers->free(mddev, mddev->private);
+		module_put(pers->owner);
 		bitmap_destroy(mddev);
 		return err;
 	}
@@ -4953,7 +4958,7 @@ int md_run(struct mddev *mddev)
 		mddev->queue->backing_dev_info.congested_fn = md_congested;
 		blk_queue_merge_bvec(mddev->queue, md_mergeable_bvec);
 	}
-	if (mddev->pers->sync_request) {
+	if (pers->sync_request) {
 		if (mddev->kobj.sd &&
 		    sysfs_create_group(&mddev->kobj, &md_redundancy_group))
 			printk(KERN_WARNING
@@ -4972,7 +4977,10 @@ int md_run(struct mddev *mddev)
 	mddev->safemode_delay = (200 * HZ)/1000 +1; /* 200 msec delay */
 	mddev->in_sync = 1;
 	smp_wmb();
+	spin_lock(&mddev->lock);
+	mddev->pers = pers;
 	mddev->ready = 1;
+	spin_unlock(&mddev->lock);
 	rdev_for_each(rdev, mddev)
 		if (rdev->raid_disk >= 0)
 			if (sysfs_link_rdev(mddev, rdev))
@@ -5137,13 +5145,16 @@ static void mddev_detach(struct mddev *mddev)
 
 static void __md_stop(struct mddev *mddev)
 {
-	mddev->ready = 0;
+	struct md_personality *pers = mddev->pers;
 	mddev_detach(mddev);
-	mddev->pers->free(mddev, mddev->private);
-	if (mddev->pers->sync_request && mddev->to_remove == NULL)
-		mddev->to_remove = &md_redundancy_group;
-	module_put(mddev->pers->owner);
+	spin_lock(&mddev->lock);
+	mddev->ready = 0;
 	mddev->pers = NULL;
+	spin_unlock(&mddev->lock);
+	pers->free(mddev, mddev->private);
+	if (pers->sync_request && mddev->to_remove == NULL)
+		mddev->to_remove = &md_redundancy_group;
+	module_put(pers->owner);
 	clear_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
 }
 
@@ -6942,6 +6953,7 @@ static int md_seq_show(struct seq_file *seq, void *v)
 	if (mddev_lock(mddev) < 0)
 		return -EINTR;
 
+	spin_lock(&mddev->lock);
 	if (mddev->pers || mddev->raid_disks || !list_empty(&mddev->disks)) {
 		seq_printf(seq, "%s : %sactive", mdname(mddev),
 						mddev->pers ? "" : "in");
@@ -7012,6 +7024,7 @@ static int md_seq_show(struct seq_file *seq, void *v)
 
 		seq_printf(seq, "\n");
 	}
+	spin_unlock(&mddev->lock);
 	mddev_unlock(mddev);
 
 	return 0;
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 37e7c17e56a6..e41559dccdc9 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -391,6 +391,7 @@ struct mddev {
 	 *   rdev superblocks, events
 	 *   clearing MD_CHANGE_*
 	 *   in_sync - and related safemode and MD_CHANGE changes
+	 *   pers (also protected by reconfig_mutex and pending IO).
 	 */
 	spinlock_t			lock;
 	wait_queue_head_t		sb_wait;	/* for waiting on superblock updates */


