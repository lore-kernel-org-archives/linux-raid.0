From: NeilBrown <neilb@suse.de>
Subject: [PATCH 1/2] md: make devices disappear when they are no longer needed.
Date: Mon, 24 Nov 2008 14:55:30 +1100
Message-ID: <20081124035530.3465.26724.stgit@notabene.brown>
References: <20081124035516.3465.66413.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20081124035516.3465.66413.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, Doug Ledford <dledford@redhat.com>, NeilBrown <neilb@suse.de>
List-Id: linux-raid.ids

Currently md devices, once created, never disappear until the module
is unloaded.  This is essentially because the gendisk holds a
reference to the mddev, and the mddev holds a reference to the
gendisk, this a circular reference.

If we drop the reference from mddev to gendisk, then we need to ensure
that the mddev is destroyed when the gendisk is destroyed.  However it
is not possible to hook into the gendisk destruction process to enable
this.

So we drop the reference from the gendisk to the mddev and destroy the
gendisk when the mddev gets destroyed.  However this has a
complication.
Between the call
   __blkdev_get->get_gendisk->kobj_lookup->md_probe
and the call
   __blkdev_get->md_open

there is no obvious way to hold a reference on the mddev any more, so
unless something is done, it will disappear and gendisk will be
destroyed prematurely.

Also, once we decide to destroy the mddev, there will be an unlockable
moment before the gendisk is unlinked (blk_unregister_region) during
which a new reference to the gendisk can be created.  We need to
ensure that this reference can not be used.  i.e. the ->open must
fail.

So:
 1/  in md_probe we set a flag in the mddev (hold_active) which
     indicates that the array should be treated as active, even
     though there are no references, and no appearance of activity.
     This is cleared by md_release when the device is closed.
     This ensure that the gendisk will survive between md_probe and
     md_open.

 2/  In md_open we check if the mddev we expect to open matches
     the gendisk that we did open.
     If there is a mismatch we return -ERESTARTSYS and modify
     __blkdev_get to retry from the top in that case.
     In the -ERESTARTSYS sys case we make sure to wait until
     the old gendisk (that we succeeded in opening) is really gone so
     we loop at most once.

If an inactive md device is opened and closed in quick succession, a
gendisk will be created and destroyed repeatedly.  If this happens
often, udev can easily get a backlog of ADD/DELETE requests.  However
this is not normally the case (and it does work, just slowly).
Normally the first open of an MD device will involve initialising it
(SET_ARRAY_INFO / NEW_DISK) which will cause it to appear active and
not be destroyed.

When an array is stopped, the gendisk will remain around until the
last open is closed, then it will disappear.

As an array can be stopped by writing to a sysfs attribute
  echo clear > /sys/block/mdXXX/md/array_state
we need to use scheduled work for deleting the gendisk and other
kobjects.  This allows us to wait for any pending gendisk deletion to
complete by simply calling flush_scheduled_work().



Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/md.c           |   57 ++++++++++++++++++++++++++++++++++++---------
 fs/block_dev.c            |   14 +++++++++++
 include/linux/raid/md_k.h |    4 +++
 3 files changed, 63 insertions(+), 12 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index cad0825..5ebda55 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -214,16 +214,33 @@ static inline mddev_t *mddev_get(mddev_t *mddev)
 	return mddev;
 }
 
+static void mddev_delayed_delete(struct work_struct *ws)
+{
+	mddev_t *mddev = container_of(ws, mddev_t, del_work);
+	kobject_del(&mddev->kobj);
+	kobject_put(&mddev->kobj);
+}
+
 static void mddev_put(mddev_t *mddev)
 {
 	if (!atomic_dec_and_lock(&mddev->active, &all_mddevs_lock))
 		return;
-	if (!mddev->raid_disks && list_empty(&mddev->disks)) {
+	if (!mddev->raid_disks && list_empty(&mddev->disks) &&
+	    !mddev->hold_active) {
 		list_del(&mddev->all_mddevs);
-		spin_unlock(&all_mddevs_lock);
-		kobject_put(&mddev->kobj);
-	} else
-		spin_unlock(&all_mddevs_lock);
+		if (mddev->gendisk) {
+			/* we did a probe so need to clean up.
+			 * Call schedule_work inside the spinlock
+			 * so that flush_scheduled_work() after
+			 * mddev_find will succeed in waiting for the
+			 * work to be done.
+			 */
+			INIT_WORK(&mddev->del_work, mddev_delayed_delete);
+			schedule_work(&mddev->del_work);
+		} else
+			kfree(mddev);
+	}
+	spin_unlock(&all_mddevs_lock);
 }
 
 static mddev_t * mddev_find(dev_t unit)
@@ -242,6 +259,7 @@ static mddev_t * mddev_find(dev_t unit)
 
 	if (new) {
 		list_add(&new->all_mddevs, &all_mddevs);
+		mddev->hold_active = UNTIL_CLOSE;
 		spin_unlock(&all_mddevs_lock);
 		return new;
 	}
@@ -3484,6 +3502,11 @@ static struct kobject *md_probe(dev_t dev, int *part, void *data)
 	if (!mddev)
 		return NULL;
 
+	/* wait for any previous instance if this device
+	 * to be completed removed (mddev_delayed_delete).
+	 */
+	flush_scheduled_work();
+
 	mutex_lock(&disks_mutex);
 	if (mddev->gendisk) {
 		mutex_unlock(&disks_mutex);
@@ -3520,7 +3543,7 @@ static struct kobject *md_probe(dev_t dev, int *part, void *data)
 	disk->private_data = mddev;
 	disk->queue = mddev->queue;
 	/* Allow extended partitions.  This makes the
-	 * 'mdp' device redundant, but we can really
+	 * 'mdp' device redundant, but we can't really
 	 * remove it now.
 	 */
 	disk->flags |= GENHD_FL_EXT_DEVT;
@@ -3536,6 +3559,7 @@ static struct kobject *md_probe(dev_t dev, int *part, void *data)
 		kobject_uevent(&mddev->kobj, KOBJ_ADD);
 		mddev->sysfs_state = sysfs_get_dirent(mddev->kobj.sd, "array_state");
 	}
+	mddev_put(mddev);
 	return NULL;
 }
 
@@ -5070,14 +5094,25 @@ static int md_open(struct block_device *bdev, fmode_t mode)
 	 * Succeed if we can lock the mddev, which confirms that
 	 * it isn't being stopped right now.
 	 */
-	mddev_t *mddev = bdev->bd_disk->private_data;
+	mddev_t *mddev = mddev_find(bdev->bd_dev);
 	int err;
 
+	if (mddev->gendisk != bdev->bd_disk) {
+		/* we are racing with mddev_put which is discarding this
+		 * bd_disk.
+		 */
+		mddev_put(mddev);
+		/* Wait until bdev->bd_disk is definitely gone */
+		flush_scheduled_work();
+		/* Then retry the open from the top */
+		return -ERESTARTSYS;
+	}
+	BUG_ON(mddev != bdev->bd_disk->private_data);
+
 	if ((err = mutex_lock_interruptible_nested(&mddev->reconfig_mutex, 1)))
 		goto out;
 
 	err = 0;
-	mddev_get(mddev);
 	atomic_inc(&mddev->openers);
 	mddev_unlock(mddev);
 
@@ -5092,6 +5127,7 @@ static int md_release(struct gendisk *disk, fmode_t mode)
 
 	BUG_ON(!mddev);
 	atomic_dec(&mddev->openers);
+	mddev->hold_active = 0;
 	mddev_put(mddev);
 
 	return 0;
@@ -6436,11 +6472,8 @@ static __exit void md_exit(void)
 	unregister_sysctl_table(raid_table_header);
 	remove_proc_entry("mdstat", NULL);
 	for_each_mddev(mddev, tmp) {
-		struct gendisk *disk = mddev->gendisk;
-		if (!disk)
-			continue;
 		export_array(mddev);
-		mddev_put(mddev);
+		mddev->hold_active = 0;
 	}
 }
 
diff --git a/fs/block_dev.c b/fs/block_dev.c
index db831ef..30b88b9 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -1004,6 +1004,7 @@ static int __blkdev_get(struct block_device *bdev, fmode_t mode, int for_part)
 	}
 
 	lock_kernel();
+ restart:
 
 	ret = -ENXIO;
 	disk = get_gendisk(bdev->bd_dev, &partno);
@@ -1024,6 +1025,19 @@ static int __blkdev_get(struct block_device *bdev, fmode_t mode, int for_part)
 
 			if (disk->fops->open) {
 				ret = disk->fops->open(bdev, mode);
+				if (ret == -ERESTARTSYS) {
+					/* Lost a race with 'disk' being
+					 * deleted, try again.
+					 * See md.c
+					 */
+					disk_put_part(bdev->bd_part);
+					bdev->bd_part = NULL;
+					module_put(disk->fops->owner);
+					put_disk(disk);
+					bdev->bd_disk = NULL;
+					mutex_unlock(&bdev->bd_mutex);
+					goto restart;
+				}
 				if (ret)
 					goto out_clear;
 			}
diff --git a/include/linux/raid/md_k.h b/include/linux/raid/md_k.h
index 8f9a54c..7b6029b 100644
--- a/include/linux/raid/md_k.h
+++ b/include/linux/raid/md_k.h
@@ -137,6 +137,8 @@ struct mddev_s
 	struct gendisk			*gendisk;
 
 	struct kobject			kobj;
+	int				hold_active;
+#define	UNTIL_CLOSE	1
 
 	/* Superblock information */
 	int				major_version,
@@ -246,6 +248,8 @@ struct mddev_s
 							 */
 	struct sysfs_dirent		*sysfs_action;  /* handle for 'sync_action' */
 
+	struct work_struct del_work;	/* used for delayed sysfs removal */
+
 	spinlock_t			write_lock;
 	wait_queue_head_t		sb_wait;	/* for waiting on superblock updates */
 	atomic_t			pending_writes;	/* number of active superblock writes */


