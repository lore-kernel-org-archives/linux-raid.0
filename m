From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH] MD: md, fix lock imbalance
Date: Wed, 1 Jul 2009 11:46:23 +1000
Message-ID: <19018.49135.87053.44522@notabene.brown>
References: <1245621576-27066-1-git-send-email-jirislaby@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Jiri Slaby on Sunday June 21
Sender: linux-raid-owner@vger.kernel.org
To: Jiri Slaby <jirislaby@gmail.com>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

On Sunday June 21, jirislaby@gmail.com wrote:
> Add unlock and put to one of fail paths in md_alloc.

Hi Jiri,
 thanks for finding this.
 I have split it up in to two patches.  One just fixes the bug as
 simply as possible.  This will be tagged for -stable.
 The other tidies up the exist paths (a little differently to the way
 you did).  That one won't go to -stable.

 See below.

Thanks,
NeilBrown

commit d7a0dc02b59b8656d7817bf2da3822df64fe4886
Author: NeilBrown <neilb@suse.de>
Date:   Wed Jul 1 11:45:14 2009 +1000

    md: fix error patch which duplicate name is found on md device creation.
    
    When an md device is created by name (rather than number) we need to
    check that the name is not already in use.  If this check finds a
    duplicate, we return an error without dropping the lock or freeing
    the newly create mddev.
    This patch fixes that.
    
    Cc: stable@kernel.org
    Found-by: Jiri Slaby <jirislaby@gmail.com>
    Signed-off-by: NeilBrown <neilb@suse.de>

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 2166af8..58bee23 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -3862,6 +3862,8 @@ static int md_alloc(dev_t dev, char *name)
 			if (mddev2->gendisk &&
 			    strcmp(mddev2->gendisk->disk_name, name) == 0) {
 				spin_unlock(&all_mddevs_lock);
+				mutex_unlock(&disks_mutex);
+				mddev_put(mddev);
 				return -EEXIST;
 			}
 		spin_unlock(&all_mddevs_lock);

commit 84dfea9c9910a7e01ecb2463c6298c0689a0c6a1
Author: NeilBrown <neilb@suse.de>
Date:   Wed Jul 1 11:45:14 2009 +1000

    md: tidy up error paths in md_alloc
    
    As the recent bug in md_alloc showed, having a single exit path for
    unlocking and putting is a good idea.  So restructure md_alloc to have
    a single mutex_unlock and mddev_put, and use gotos where necessary.
    
    Found-by: Jiri Slaby <jirislaby@gmail.com>
    Signed-off-by: NeilBrown <neilb@suse.de>

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 58bee23..65fe35b 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -3846,11 +3846,9 @@ static int md_alloc(dev_t dev, char *name)
 	flush_scheduled_work();
 
 	mutex_lock(&disks_mutex);
-	if (mddev->gendisk) {
-		mutex_unlock(&disks_mutex);
-		mddev_put(mddev);
-		return -EEXIST;
-	}
+	error = -EEXIST;
+	if (mddev->gendisk)
+		goto abort;
 
 	if (name) {
 		/* Need to ensure that 'name' is not a duplicate.
@@ -3862,19 +3860,15 @@ static int md_alloc(dev_t dev, char *name)
 			if (mddev2->gendisk &&
 			    strcmp(mddev2->gendisk->disk_name, name) == 0) {
 				spin_unlock(&all_mddevs_lock);
-				mutex_unlock(&disks_mutex);
-				mddev_put(mddev);
-				return -EEXIST;
+				goto abort;
 			}
 		spin_unlock(&all_mddevs_lock);
 	}
 
+	error = -ENOMEM;
 	mddev->queue = blk_alloc_queue(GFP_KERNEL);
-	if (!mddev->queue) {
-		mutex_unlock(&disks_mutex);
-		mddev_put(mddev);
-		return -ENOMEM;
-	}
+	if (!mddev->queue)
+		goto abort;
 	mddev->queue->queuedata = mddev;
 
 	/* Can be unlocked because the queue is new: no concurrency */
@@ -3884,11 +3878,9 @@ static int md_alloc(dev_t dev, char *name)
 
 	disk = alloc_disk(1 << shift);
 	if (!disk) {
-		mutex_unlock(&disks_mutex);
 		blk_cleanup_queue(mddev->queue);
 		mddev->queue = NULL;
-		mddev_put(mddev);
-		return -ENOMEM;
+		goto abort;
 	}
 	disk->major = MAJOR(mddev->unit);
 	disk->first_minor = unit << shift;
@@ -3910,16 +3902,22 @@ static int md_alloc(dev_t dev, char *name)
 	mddev->gendisk = disk;
 	error = kobject_init_and_add(&mddev->kobj, &md_ktype,
 				     &disk_to_dev(disk)->kobj, "%s", "md");
-	mutex_unlock(&disks_mutex);
-	if (error)
+	if (error) {
+		/* This isn't possible, but as kobject_init_and_add is marked
+		 * __must_check, we must do something with the result
+		 */
 		printk(KERN_WARNING "md: cannot register %s/md - name in use\n",
 		       disk->disk_name);
-	else {
+		error = 0;
+	}
+ abort:
+	mutex_unlock(&disks_mutex);
+	if (!error) {
 		kobject_uevent(&mddev->kobj, KOBJ_ADD);
 		mddev->sysfs_state = sysfs_get_dirent(mddev->kobj.sd, "array_state");
 	}
 	mddev_put(mddev);
-	return 0;
+	return error;
 }
 
 static struct kobject *md_probe(dev_t dev, int *part, void *data)
