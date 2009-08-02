From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 8/8] md: Use revalidate_disk to effect changes in size of
	device.
Date: Mon, 03 Aug 2009 07:58:19 +1000
Message-ID: <20090802215818.4198.77041.stgit@notabene.brown>
References: <20090802215444.4198.83094.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090802215444.4198.83094.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: NeilBrown <neilb@suse.de>
List-Id: linux-raid.ids

As revalidate_disk calls check_disk_size_change, it will cause
any capacity change of a gendisk to be propagated to the blockdev
inode.  So use that instead of mucking about with locks and
i_size_write.

Also add a call to revalidate_disk in do_md_run and a few other places
where the gendisk capacity is changed.

Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/linear.c |    1 +
 drivers/md/md.c     |   28 +++++-----------------------
 drivers/md/raid1.c  |    1 +
 drivers/md/raid5.c  |   12 ++----------
 4 files changed, 9 insertions(+), 33 deletions(-)

diff --git a/drivers/md/linear.c b/drivers/md/linear.c
index 54c8677..5fe39c2 100644
--- a/drivers/md/linear.c
+++ b/drivers/md/linear.c
@@ -257,6 +257,7 @@ static int linear_add(mddev_t *mddev, mdk_rdev_t *rdev)
 	rcu_assign_pointer(mddev->private, newconf);
 	md_set_array_sectors(mddev, linear_size(mddev, 0, 0));
 	set_capacity(mddev->gendisk, mddev->array_sectors);
+	revalidate_disk(mddev->gendisk);
 	call_rcu(&oldconf->rcu, free_conf);
 	return 0;
 }
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 5b507e9..5b722d8 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -3740,17 +3740,8 @@ array_size_store(mddev_t *mddev, const char *buf, size_t len)
 
 	mddev->array_sectors = sectors;
 	set_capacity(mddev->gendisk, mddev->array_sectors);
-	if (mddev->pers) {
-		struct block_device *bdev = bdget_disk(mddev->gendisk, 0);
-
-		if (bdev) {
-			mutex_lock(&bdev->bd_inode->i_mutex);
-			i_size_write(bdev->bd_inode,
-				     (loff_t)mddev->array_sectors << 9);
-			mutex_unlock(&bdev->bd_inode->i_mutex);
-			bdput(bdev);
-		}
-	}
+	if (mddev->pers)
+		revalidate_disk(mddev->gendisk);
 
 	return len;
 }
@@ -4240,6 +4231,7 @@ static int do_md_run(mddev_t * mddev)
 	md_wakeup_thread(mddev->thread);
 	md_wakeup_thread(mddev->sync_thread); /* possibly kick off a reshape */
 
+	revalidate_disk(mddev->gendisk);
 	mddev->changed = 1;
 	md_new_event(mddev);
 	sysfs_notify_dirent(mddev->sysfs_state);
@@ -5138,18 +5130,8 @@ static int update_size(mddev_t *mddev, sector_t num_sectors)
 			return -ENOSPC;
 	}
 	rv = mddev->pers->resize(mddev, num_sectors);
-	if (!rv) {
-		struct block_device *bdev;
-
-		bdev = bdget_disk(mddev->gendisk, 0);
-		if (bdev) {
-			mutex_lock(&bdev->bd_inode->i_mutex);
-			i_size_write(bdev->bd_inode,
-				     (loff_t)mddev->array_sectors << 9);
-			mutex_unlock(&bdev->bd_inode->i_mutex);
-			bdput(bdev);
-		}
-	}
+	if (!rv)
+		revalidate_disk(mddev->gendisk);
 	return rv;
 }
 
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 67e794d..8726fd7 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -2134,6 +2134,7 @@ static int raid1_resize(mddev_t *mddev, sector_t sectors)
 		return -EINVAL;
 	set_capacity(mddev->gendisk, mddev->array_sectors);
 	mddev->changed = 1;
+	revalidate_disk(mddev->gendisk);
 	if (sectors > mddev->dev_sectors &&
 	    mddev->recovery_cp == MaxSector) {
 		mddev->recovery_cp = mddev->dev_sectors;
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 2dc35b4..2b521ee 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -4858,6 +4858,7 @@ static int raid5_resize(mddev_t *mddev, sector_t sectors)
 		return -EINVAL;
 	set_capacity(mddev->gendisk, mddev->array_sectors);
 	mddev->changed = 1;
+	revalidate_disk(mddev->gendisk);
 	if (sectors > mddev->dev_sectors && mddev->recovery_cp == MaxSector) {
 		mddev->recovery_cp = mddev->dev_sectors;
 		set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
@@ -5058,7 +5059,6 @@ static void end_reshape(raid5_conf_t *conf)
  */
 static void raid5_finish_reshape(mddev_t *mddev)
 {
-	struct block_device *bdev;
 	raid5_conf_t *conf = mddev->private;
 
 	if (!test_bit(MD_RECOVERY_INTR, &mddev->recovery)) {
@@ -5067,15 +5067,7 @@ static void raid5_finish_reshape(mddev_t *mddev)
 			md_set_array_sectors(mddev, raid5_size(mddev, 0, 0));
 			set_capacity(mddev->gendisk, mddev->array_sectors);
 			mddev->changed = 1;
-
-			bdev = bdget_disk(mddev->gendisk, 0);
-			if (bdev) {
-				mutex_lock(&bdev->bd_inode->i_mutex);
-				i_size_write(bdev->bd_inode,
-					     (loff_t)mddev->array_sectors << 9);
-				mutex_unlock(&bdev->bd_inode->i_mutex);
-				bdput(bdev);
-			}
+			revalidate_disk(mddev->gendisk);
 		} else {
 			int d;
 			mddev->degraded = conf->raid_disks;


