From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 2/3] md: centralize ->array_sectors modifications
Date: Thu, 05 Mar 2009 17:24:53 -0700
Message-ID: <20090306002453.9882.7305.stgit@dwillia2-linux.ch.intel.com>
References: <20090306002341.9882.61625.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090306002341.9882.61625.stgit@dwillia2-linux.ch.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, ed.ciechanowski@intel.com, jacek.danecki@intel.com
List-Id: linux-raid.ids

Get personalities out of the business of directly modifying
->array_sectors.  Lays groundwork to introduce policy on when
->array_sectors can be modified.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/md/faulty.c     |    2 +-
 drivers/md/linear.c     |    4 ++--
 drivers/md/md.c         |    6 ++++++
 drivers/md/multipath.c  |    2 +-
 drivers/md/raid0.c      |    2 +-
 drivers/md/raid1.c      |    4 ++--
 drivers/md/raid10.c     |    2 +-
 drivers/md/raid5.c      |    6 +++---
 include/linux/raid/md.h |    1 +
 9 files changed, 18 insertions(+), 11 deletions(-)

diff --git a/drivers/md/faulty.c b/drivers/md/faulty.c
index 9bf3629..93ff27b 100644
--- a/drivers/md/faulty.c
+++ b/drivers/md/faulty.c
@@ -309,7 +309,7 @@ static int run(mddev_t *mddev)
 	list_for_each_entry(rdev, &mddev->disks, same_set)
 		conf->rdev = rdev;
 
-	mddev->array_sectors = faulty_size(mddev, 0, 0);
+	md_set_size(mddev, faulty_size(mddev, 0, 0));
 	mddev->private = conf;
 
 	reconfig(mddev, mddev->layout, -1);
diff --git a/drivers/md/linear.c b/drivers/md/linear.c
index 4a7397e..694f857 100644
--- a/drivers/md/linear.c
+++ b/drivers/md/linear.c
@@ -259,7 +259,7 @@ static int linear_run (mddev_t *mddev)
 	if (!conf)
 		return 1;
 	mddev->private = conf;
-	mddev->array_sectors = linear_size(mddev, 0, 0);
+	md_set_size(mddev, linear_size(mddev, 0, 0));
 
 	blk_queue_merge_bvec(mddev->queue, linear_mergeable_bvec);
 	mddev->queue->unplug_fn = linear_unplug;
@@ -293,7 +293,7 @@ static int linear_add(mddev_t *mddev, mdk_rdev_t *rdev)
 	newconf->prev = mddev_to_conf(mddev);
 	mddev->private = newconf;
 	mddev->raid_disks++;
-	mddev->array_sectors = linear_size(mddev, 0, 0);
+	md_set_size(mddev, linear_size(mddev, 0, 0));
 	set_capacity(mddev->gendisk, mddev->array_sectors);
 	return 0;
 }
diff --git a/drivers/md/md.c b/drivers/md/md.c
index f538c3d..031411b 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -4975,6 +4975,12 @@ static int set_array_info(mddev_t * mddev, mdu_array_info_t *info)
 	return 0;
 }
 
+void md_set_size(mddev_t *mddev, sector_t array_sectors)
+{
+	mddev->array_sectors = array_sectors;
+}
+EXPORT_SYMBOL(md_set_size);
+
 static int update_size(mddev_t *mddev, sector_t num_sectors)
 {
 	mdk_rdev_t *rdev;
diff --git a/drivers/md/multipath.c b/drivers/md/multipath.c
index 1ca72ed..f03d8ea 100644
--- a/drivers/md/multipath.c
+++ b/drivers/md/multipath.c
@@ -506,7 +506,7 @@ static int multipath_run (mddev_t *mddev)
 	/*
 	 * Ok, everything is just fine now
 	 */
-	mddev->array_sectors = multipath_size(mddev, 0, 0);
+	md_set_size(mddev, multipath_size(mddev, 0, 0));
 
 	mddev->queue->unplug_fn = multipath_unplug;
 	mddev->queue->backing_dev_info.congested_fn = multipath_congested;
diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index d5c8ea9..64c62bc 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -303,7 +303,7 @@ static int raid0_run (mddev_t *mddev)
 		goto out_free_conf;
 
 	/* calculate array device size */
-	mddev->array_sectors = raid0_size(mddev, 0, 0);
+	md_set_size(mddev, raid0_size(mddev, 0, 0));
 
 	printk(KERN_INFO "raid0 : md_size is %llu sectors.\n",
 		(unsigned long long)mddev->array_sectors);
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 5f62d42..a9f19b7 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -2056,7 +2056,7 @@ static int run(mddev_t *mddev)
 	/*
 	 * Ok, everything is just fine now
 	 */
-	mddev->array_sectors = raid1_size(mddev, 0, 0);
+	md_set_size(mddev, raid1_size(mddev, 0, 0));
 
 	mddev->queue->unplug_fn = raid1_unplug;
 	mddev->queue->backing_dev_info.congested_fn = raid1_congested;
@@ -2121,7 +2121,7 @@ static int raid1_resize(mddev_t *mddev, sector_t sectors)
 	 * any io in the removed space completes, but it hardly seems
 	 * worth it.
 	 */
-	mddev->array_sectors = raid1_size(mddev, sectors, 0);
+	md_set_size(mddev, raid1_size(mddev, sectors, 0));
 	set_capacity(mddev->gendisk, mddev->array_sectors);
 	mddev->changed = 1;
 	if (mddev->array_sectors > mddev->dev_sectors &&
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 1c28679..571a3c8 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -2193,7 +2193,7 @@ static int run(mddev_t *mddev)
 	/*
 	 * Ok, everything is just fine now
 	 */
-	mddev->array_sectors = raid10_size(mddev, 0, 0);
+	md_set_size(mddev, raid10_size(mddev, 0, 0));
 	mddev->resync_max_sectors = mddev->array_sectors;
 
 	mddev->queue->unplug_fn = raid10_unplug;
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 3cc570b..41a6ec9 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -4472,7 +4472,7 @@ static int run(mddev_t *mddev)
 	mddev->queue->backing_dev_info.congested_data = mddev;
 	mddev->queue->backing_dev_info.congested_fn = raid5_congested;
 
-	mddev->array_sectors = raid5_size(mddev, 0, 0);
+	md_set_size(mddev, raid5_size(mddev, 0, 0));
 
 	blk_queue_merge_bvec(mddev->queue, raid5_mergeable_bvec);
 
@@ -4694,7 +4694,7 @@ static int raid5_resize(mddev_t *mddev, sector_t sectors)
 	 * worth it.
 	 */
 	sectors &= ~((sector_t)mddev->chunk_size/512 - 1);
-	mddev->array_sectors = raid5_size(mddev, sectors, mddev->raid_disks);
+	md_set_size(mddev, raid5_size(mddev, sectors, mddev->raid_disks));
 	set_capacity(mddev->gendisk, mddev->array_sectors);
 	mddev->changed = 1;
 	if (sectors > mddev->dev_sectors && mddev->recovery_cp == MaxSector) {
@@ -4832,7 +4832,7 @@ static void end_reshape(raid5_conf_t *conf)
 	if (!test_bit(MD_RECOVERY_INTR, &conf->mddev->recovery)) {
 		mddev_t *mddev = conf->mddev;
 
-		mddev->array_sectors = raid5_size(mddev, 0, conf->raid_disks);
+		md_set_size(mddev, raid5_size(mddev, 0, conf->raid_disks));
 		set_capacity(mddev->gendisk, mddev->array_sectors);
 		mddev->changed = 1;
 		conf->previous_raid_disks = conf->raid_disks;
diff --git a/include/linux/raid/md.h b/include/linux/raid/md.h
index 82bea14..de9bec2 100644
--- a/include/linux/raid/md.h
+++ b/include/linux/raid/md.h
@@ -75,6 +75,7 @@ extern void md_do_sync(mddev_t *mddev);
 extern void md_new_event(mddev_t *mddev);
 extern int md_allow_write(mddev_t *mddev);
 extern void md_wait_for_blocked_rdev(mdk_rdev_t *rdev, mddev_t *mddev);
+extern void md_set_size(mddev_t *mddev, sector_t array_sectors);
 
 #endif /* CONFIG_MD */
 #endif 

