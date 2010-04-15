From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 11/28] md: remove unneeded sysfs files more promptly
Date: Thu, 15 Apr 2010 16:21:08 +1000
Message-ID: <20100415062108.5126.51912.stgit@notabene.brown>
References: <20100415061516.5126.53068.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100415061516.5126.53068.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

When an array is stopped we need to remove some
sysfs files which are dependent on the type of array.

We need to delay that deletion as deleting them while holding
reconfig_mutex can lead to deadlocks.

We currently delay them until the array is completely destroyed.
However it is possible to deactivate and then reactivate the array.
So we need to delete these files more promptly: as soon as
reconfig_mutex is dropped.

We need to ensure this happens before do_md_run can restart the array,
so we use open_mutex for some extra locking.  This is not deadlock
prone.

Signed-off-by: NeilBrown <neilb@suse.de>
---
 drivers/md/md.c |   41 +++++++++++++++++++++++++++++++----------
 1 files changed, 31 insertions(+), 10 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 9385d1e..3fcbe8a 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -507,9 +507,32 @@ static inline int mddev_trylock(mddev_t * mddev)
 	return mutex_trylock(&mddev->reconfig_mutex);
 }
 
+static struct attribute_group md_redundancy_group;
+
 static inline void mddev_unlock(mddev_t * mddev)
 {
-	mutex_unlock(&mddev->reconfig_mutex);
+	if (mddev->pers == NULL && mddev->private) {
+		/* These cannot be removed under reconfig_mutex as
+		 * an access to the files will try to take reconfig_mutex
+		 * while holding the file unremovable, which leads to
+		 * a deadlock.
+		 * So hold open_mutex instead - we are allowed to take
+		 * it while holding reconfig_mutex, and md_run can
+		 * use it to wait for the remove to complete.
+		 */
+		mutex_lock(&mddev->open_mutex);
+		mutex_unlock(&mddev->reconfig_mutex);
+
+		sysfs_remove_group(&mddev->kobj, &md_redundancy_group);
+		if (mddev->private != (void*)1)
+			sysfs_remove_group(&mddev->kobj, mddev->private);
+		if (mddev->sysfs_action)
+			sysfs_put(mddev->sysfs_action);
+		mddev->sysfs_action = NULL;
+		mddev->private = NULL;
+		mutex_unlock(&mddev->open_mutex);
+	} else
+		mutex_unlock(&mddev->reconfig_mutex);
 
 	md_wakeup_thread(mddev->thread);
 }
@@ -4097,15 +4120,6 @@ static void mddev_delayed_delete(struct work_struct *ws)
 {
 	mddev_t *mddev = container_of(ws, mddev_t, del_work);
 
-	if (mddev->private) {
-		sysfs_remove_group(&mddev->kobj, &md_redundancy_group);
-		if (mddev->private != (void*)1)
-			sysfs_remove_group(&mddev->kobj, mddev->private);
-		if (mddev->sysfs_action)
-			sysfs_put(mddev->sysfs_action);
-		mddev->sysfs_action = NULL;
-		mddev->private = NULL;
-	}
 	sysfs_remove_group(&mddev->kobj, &md_bitmap_group);
 	kobject_del(&mddev->kobj);
 	kobject_put(&mddev->kobj);
@@ -4263,6 +4277,13 @@ static int do_md_run(mddev_t * mddev)
 	if (mddev->pers)
 		return -EBUSY;
 
+	/* These two calls synchronise us with the
+	 * sysfs_remove_group calls in mddev_unlock,
+	 * so they must have completed.
+	 */
+	mutex_lock(&mddev->open_mutex);
+	mutex_unlock(&mddev->open_mutex);
+
 	/*
 	 * Analyze all RAID superblock(s)
 	 */


