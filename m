From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 12/28] md: manage redundancy group in sysfs when changing
	level.
Date: Thu, 15 Apr 2010 16:21:08 +1000
Message-ID: <20100415062108.5126.62404.stgit@notabene.brown>
References: <20100415061516.5126.53068.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100415061516.5126.53068.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Some levels expect the 'redundancy group' to be present,
others don't.
So when we change level of an array we might need to
add or remove this group.

This requires fixing up the current practice of overloading ->private
to indicate (when ->pers == NULL) that something needs to be removed.
So create a new ->to_remove to fill that role.

Signed-off-by: NeilBrown <neilb@suse.de>
---
 drivers/md/md.c    |   43 ++++++++++++++++++++++++++++++++-----------
 drivers/md/md.h    |    1 +
 drivers/md/raid5.c |    7 +++++--
 3 files changed, 38 insertions(+), 13 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 3fcbe8a..03d6a52 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -509,9 +509,9 @@ static inline int mddev_trylock(mddev_t * mddev)
 
 static struct attribute_group md_redundancy_group;
 
-static inline void mddev_unlock(mddev_t * mddev)
+static void mddev_unlock(mddev_t * mddev)
 {
-	if (mddev->pers == NULL && mddev->private) {
+	if (mddev->to_remove) {
 		/* These cannot be removed under reconfig_mutex as
 		 * an access to the files will try to take reconfig_mutex
 		 * while holding the file unremovable, which leads to
@@ -520,16 +520,20 @@ static inline void mddev_unlock(mddev_t * mddev)
 		 * it while holding reconfig_mutex, and md_run can
 		 * use it to wait for the remove to complete.
 		 */
+		struct attribute_group *to_remove = mddev->to_remove;
+		mddev->to_remove = NULL;
 		mutex_lock(&mddev->open_mutex);
 		mutex_unlock(&mddev->reconfig_mutex);
 
-		sysfs_remove_group(&mddev->kobj, &md_redundancy_group);
-		if (mddev->private != (void*)1)
-			sysfs_remove_group(&mddev->kobj, mddev->private);
-		if (mddev->sysfs_action)
-			sysfs_put(mddev->sysfs_action);
-		mddev->sysfs_action = NULL;
-		mddev->private = NULL;
+		if (to_remove != &md_redundancy_group)
+			sysfs_remove_group(&mddev->kobj, to_remove);
+		if (mddev->pers == NULL ||
+		    mddev->pers->sync_request == NULL) {
+			sysfs_remove_group(&mddev->kobj, &md_redundancy_group);
+			if (mddev->sysfs_action)
+				sysfs_put(mddev->sysfs_action);
+			mddev->sysfs_action = NULL;
+		}
 		mutex_unlock(&mddev->open_mutex);
 	} else
 		mutex_unlock(&mddev->reconfig_mutex);
@@ -2998,6 +3002,23 @@ level_store(mddev_t *mddev, const char *buf, size_t len)
 	/* Looks like we have a winner */
 	mddev_suspend(mddev);
 	mddev->pers->stop(mddev);
+	
+	if (mddev->pers->sync_request == NULL &&
+	    pers->sync_request != NULL) {
+		/* need to add the md_redundancy_group */
+		if (sysfs_create_group(&mddev->kobj, &md_redundancy_group))
+			printk(KERN_WARNING
+			       "md: cannot register extra attributes for %s\n",
+			       mdname(mddev));
+		mddev->sysfs_action = sysfs_get_dirent(mddev->kobj.sd, "sync_action");
+	}		
+	if (mddev->pers->sync_request != NULL &&
+	    pers->sync_request == NULL) {
+		/* need to remove the md_redundancy_group */
+		if (mddev->to_remove == NULL)
+			mddev->to_remove = &md_redundancy_group;
+	}
+
 	if (mddev->pers->sync_request == NULL &&
 	    mddev->external) {
 		/* We are converting from a no-redundancy array
@@ -4572,8 +4593,8 @@ static int do_md_stop(mddev_t * mddev, int mode, int is_open)
 			mddev->queue->unplug_fn = NULL;
 			mddev->queue->backing_dev_info.congested_fn = NULL;
 			module_put(mddev->pers->owner);
-			if (mddev->pers->sync_request && mddev->private == NULL)
-				mddev->private = (void*)1;
+			if (mddev->pers->sync_request && mddev->to_remove == NULL)
+				mddev->to_remove = &md_redundancy_group;
 			mddev->pers = NULL;
 			/* tell userspace to handle 'inactive' */
 			sysfs_notify_dirent(mddev->sysfs_state);
diff --git a/drivers/md/md.h b/drivers/md/md.h
index b9dc3ea..e4836c6 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -299,6 +299,7 @@ struct mddev_s
 	atomic_t 			max_corr_read_errors; /* max read retries */
 	struct list_head		all_mddevs;
 
+	struct attribute_group		*to_remove;
 	/* Generic barrier handling.
 	 * If there is a pending barrier request, all other
 	 * writes are blocked while the devices are flushed.
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index c54ddbc..bb28fd6 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -5091,7 +5091,9 @@ static int run(mddev_t *mddev)
 	}
 
 	/* Ok, everything is just fine now */
-	if (sysfs_create_group(&mddev->kobj, &raid5_attrs_group))
+	if (mddev->to_remove == &raid5_attrs_group)
+		mddev->to_remove = NULL;
+	else if (sysfs_create_group(&mddev->kobj, &raid5_attrs_group))
 		printk(KERN_WARNING
 		       "raid5: failed to create sysfs attributes for %s\n",
 		       mdname(mddev));
@@ -5138,7 +5140,8 @@ static int stop(mddev_t *mddev)
 	mddev->queue->backing_dev_info.congested_fn = NULL;
 	blk_sync_queue(mddev->queue); /* the unplug fn references 'conf'*/
 	free_conf(conf);
-	mddev->private = &raid5_attrs_group;
+	mddev->private = NULL;
+	mddev->to_remove = &raid5_attrs_group;
 	return 0;
 }
 


