From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 1/3] md: add 'size' as a personality method
Date: Thu, 05 Mar 2009 17:24:48 -0700
Message-ID: <20090306002448.9882.88409.stgit@dwillia2-linux.ch.intel.com>
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

In preparation for giving userspace control over ->array_sectors we need
to be able to retrieve the 'default' size, and the 'anticipated' size
when a reshape is requested.  For personalities that do not reshape emit
a warning if anything but the default size is requested.

In the raid5 case we need to update ->previous_raid_disks to make the
new 'default' size available.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/md/faulty.c       |   14 +++++++++++++-
 drivers/md/linear.c       |   15 +++++++++++++--
 drivers/md/multipath.c    |   11 ++++++++++-
 drivers/md/raid0.c        |   20 ++++++++++++++++----
 drivers/md/raid1.c        |   13 +++++++++++--
 drivers/md/raid10.c       |   27 +++++++++++++++++++++++++--
 drivers/md/raid5.c        |   36 ++++++++++++++++++++++++++----------
 include/linux/raid/md_k.h |    1 +
 8 files changed, 115 insertions(+), 22 deletions(-)

diff --git a/drivers/md/faulty.c b/drivers/md/faulty.c
index b3b0437..9bf3629 100644
--- a/drivers/md/faulty.c
+++ b/drivers/md/faulty.c
@@ -280,6 +280,17 @@ static int reconfig(mddev_t *mddev, int layout, int chunk_size)
 	return 0;
 }
 
+static sector_t faulty_size(mddev_t *mddev, sector_t sectors, int raid_disks)
+{
+	WARN_ONCE(raid_disks,
+		  "%s does not support generic reshape\n", __func__);
+
+	if (sectors == 0)
+		return mddev->dev_sectors;
+
+	return sectors;
+}
+
 static int run(mddev_t *mddev)
 {
 	mdk_rdev_t *rdev;
@@ -298,7 +309,7 @@ static int run(mddev_t *mddev)
 	list_for_each_entry(rdev, &mddev->disks, same_set)
 		conf->rdev = rdev;
 
-	mddev->array_sectors = mddev->dev_sectors;
+	mddev->array_sectors = faulty_size(mddev, 0, 0);
 	mddev->private = conf;
 
 	reconfig(mddev, mddev->layout, -1);
@@ -325,6 +336,7 @@ static struct mdk_personality faulty_personality =
 	.stop		= stop,
 	.status		= status,
 	.reconfig	= reconfig,
+	.size		= faulty_size,
 };
 
 static int __init raid_init(void)
diff --git a/drivers/md/linear.c b/drivers/md/linear.c
index 83110f8..4a7397e 100644
--- a/drivers/md/linear.c
+++ b/drivers/md/linear.c
@@ -97,6 +97,16 @@ static int linear_congested(void *data, int bits)
 	return ret;
 }
 
+static sector_t linear_size(mddev_t *mddev, sector_t sectors, int raid_disks)
+{
+	linear_conf_t *conf = mddev_to_conf(mddev);
+
+	WARN_ONCE(sectors || raid_disks,
+		  "%s does not support generic reshape\n", __func__);
+
+	return conf->array_sectors;
+}
+
 static linear_conf_t *linear_conf(mddev_t *mddev, int raid_disks)
 {
 	linear_conf_t *conf;
@@ -249,7 +259,7 @@ static int linear_run (mddev_t *mddev)
 	if (!conf)
 		return 1;
 	mddev->private = conf;
-	mddev->array_sectors = conf->array_sectors;
+	mddev->array_sectors = linear_size(mddev, 0, 0);
 
 	blk_queue_merge_bvec(mddev->queue, linear_mergeable_bvec);
 	mddev->queue->unplug_fn = linear_unplug;
@@ -283,7 +293,7 @@ static int linear_add(mddev_t *mddev, mdk_rdev_t *rdev)
 	newconf->prev = mddev_to_conf(mddev);
 	mddev->private = newconf;
 	mddev->raid_disks++;
-	mddev->array_sectors = newconf->array_sectors;
+	mddev->array_sectors = linear_size(mddev, 0, 0);
 	set_capacity(mddev->gendisk, mddev->array_sectors);
 	return 0;
 }
@@ -381,6 +391,7 @@ static struct mdk_personality linear_personality =
 	.stop		= linear_stop,
 	.status		= linear_status,
 	.hot_add_disk	= linear_add,
+	.size		= linear_size,
 };
 
 static int __init linear_init (void)
diff --git a/drivers/md/multipath.c b/drivers/md/multipath.c
index a21084b..1ca72ed 100644
--- a/drivers/md/multipath.c
+++ b/drivers/md/multipath.c
@@ -402,6 +402,14 @@ static void multipathd (mddev_t *mddev)
 	spin_unlock_irqrestore(&conf->device_lock, flags);
 }
 
+static sector_t multipath_size(mddev_t *mddev, sector_t sectors, int raid_disks)
+{
+	WARN_ONCE(sectors || raid_disks,
+		  "%s does not support generic reshape\n", __func__);
+
+	return mddev->dev_sectors;
+}
+
 static int multipath_run (mddev_t *mddev)
 {
 	multipath_conf_t *conf;
@@ -498,7 +506,7 @@ static int multipath_run (mddev_t *mddev)
 	/*
 	 * Ok, everything is just fine now
 	 */
-	mddev->array_sectors = mddev->dev_sectors;
+	mddev->array_sectors = multipath_size(mddev, 0, 0);
 
 	mddev->queue->unplug_fn = multipath_unplug;
 	mddev->queue->backing_dev_info.congested_fn = multipath_congested;
@@ -543,6 +551,7 @@ static struct mdk_personality multipath_personality =
 	.error_handler	= multipath_error,
 	.hot_add_disk	= multipath_add_disk,
 	.hot_remove_disk= multipath_remove_disk,
+	.size		= multipath_size,
 };
 
 static int __init multipath_init (void)
diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index a5037de..d5c8ea9 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -260,12 +260,25 @@ static int raid0_mergeable_bvec(struct request_queue *q,
 		return max;
 }
 
+static sector_t raid0_size(mddev_t *mddev, sector_t sectors, int raid_disks)
+{
+	sector_t array_sectors = 0;
+	mdk_rdev_t *rdev;
+
+	WARN_ONCE(sectors || raid_disks,
+		  "%s does not support generic reshape\n", __func__);
+
+	list_for_each_entry(rdev, &mddev->disks, same_set)
+		array_sectors += rdev->sectors;
+
+	return array_sectors;
+}
+
 static int raid0_run (mddev_t *mddev)
 {
 	unsigned  cur=0, i=0, nb_zone;
 	s64 sectors;
 	raid0_conf_t *conf;
-	mdk_rdev_t *rdev;
 
 	if (mddev->chunk_size == 0) {
 		printk(KERN_ERR "md/raid0: non-zero chunk size required.\n");
@@ -290,9 +303,7 @@ static int raid0_run (mddev_t *mddev)
 		goto out_free_conf;
 
 	/* calculate array device size */
-	mddev->array_sectors = 0;
-	list_for_each_entry(rdev, &mddev->disks, same_set)
-		mddev->array_sectors += rdev->sectors;
+	mddev->array_sectors = raid0_size(mddev, 0, 0);
 
 	printk(KERN_INFO "raid0 : md_size is %llu sectors.\n",
 		(unsigned long long)mddev->array_sectors);
@@ -508,6 +519,7 @@ static struct mdk_personality raid0_personality=
 	.run		= raid0_run,
 	.stop		= raid0_stop,
 	.status		= raid0_status,
+	.size		= raid0_size,
 };
 
 static int __init raid0_init (void)
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 9778bef..5f62d42 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1919,6 +1919,14 @@ static sector_t sync_request(mddev_t *mddev, sector_t sector_nr, int *skipped, i
 	return nr_sectors;
 }
 
+static sector_t raid1_size(mddev_t *mddev, sector_t sectors, int raid_disks)
+{
+	if (sectors)
+		return sectors;
+
+	return mddev->dev_sectors;
+}
+
 static int run(mddev_t *mddev)
 {
 	conf_t *conf;
@@ -2048,7 +2056,7 @@ static int run(mddev_t *mddev)
 	/*
 	 * Ok, everything is just fine now
 	 */
-	mddev->array_sectors = mddev->dev_sectors;
+	mddev->array_sectors = raid1_size(mddev, 0, 0);
 
 	mddev->queue->unplug_fn = raid1_unplug;
 	mddev->queue->backing_dev_info.congested_fn = raid1_congested;
@@ -2113,7 +2121,7 @@ static int raid1_resize(mddev_t *mddev, sector_t sectors)
 	 * any io in the removed space completes, but it hardly seems
 	 * worth it.
 	 */
-	mddev->array_sectors = sectors;
+	mddev->array_sectors = raid1_size(mddev, sectors, 0);
 	set_capacity(mddev->gendisk, mddev->array_sectors);
 	mddev->changed = 1;
 	if (mddev->array_sectors > mddev->dev_sectors &&
@@ -2267,6 +2275,7 @@ static struct mdk_personality raid1_personality =
 	.spare_active	= raid1_spare_active,
 	.sync_request	= sync_request,
 	.resize		= raid1_resize,
+	.size		= raid1_size,
 	.check_reshape	= raid1_reshape,
 	.quiesce	= raid1_quiesce,
 };
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 5579a26..1c28679 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -2020,6 +2020,28 @@ static sector_t sync_request(mddev_t *mddev, sector_t sector_nr, int *skipped, i
 	goto skipped;
 }
 
+static sector_t
+raid10_size(mddev_t *mddev, sector_t sectors, int raid_disks)
+{
+	sector_t size;
+	int chunk_shift;
+	conf_t *conf = mddev_to_conf(mddev);
+	int chunk_size = mddev->chunk_size;
+
+	if (!raid_disks)
+		raid_disks = mddev->raid_disks;
+	if (!sectors)
+		sectors = mddev->dev_sectors;
+
+	chunk_shift = ffz(~chunk_size) - 9;
+	size = sectors >> chunk_shift;
+	sector_div(size, conf->far_copies);
+	size = size * raid_disks;
+	sector_div(size, conf->near_copies);
+
+	return size << chunk_shift;
+}
+
 static int run(mddev_t *mddev)
 {
 	conf_t *conf;
@@ -2171,8 +2193,8 @@ static int run(mddev_t *mddev)
 	/*
 	 * Ok, everything is just fine now
 	 */
-	mddev->array_sectors = size << conf->chunk_shift;
-	mddev->resync_max_sectors = size << conf->chunk_shift;
+	mddev->array_sectors = raid10_size(mddev, 0, 0);
+	mddev->resync_max_sectors = mddev->array_sectors;
 
 	mddev->queue->unplug_fn = raid10_unplug;
 	mddev->queue->backing_dev_info.congested_fn = raid10_congested;
@@ -2258,6 +2280,7 @@ static struct mdk_personality raid10_personality =
 	.spare_active	= raid10_spare_active,
 	.sync_request	= sync_request,
 	.quiesce	= raid10_quiesce,
+	.size		= raid10_size,
 };
 
 static int __init raid_init(void)
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 46b097a..3cc570b 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -4298,6 +4298,21 @@ static raid5_conf_t *setup_conf(mddev_t *mddev)
 		return ERR_PTR(-ENOMEM);
 }
 
+static sector_t
+raid5_size(mddev_t *mddev, sector_t sectors, int raid_disks)
+{
+	raid5_conf_t *conf = mddev_to_conf(mddev);
+	int chunk_size = mddev->chunk_size;
+
+	if (!sectors)
+		sectors = mddev->dev_sectors;
+	if (!raid_disks)
+		raid_disks = conf->previous_raid_disks;
+
+	sectors &= ~(chunk_size / 512 - 1);
+	return sectors * (raid_disks - conf->max_degraded);
+}
+
 static int run(mddev_t *mddev)
 {
 	raid5_conf_t *conf;
@@ -4457,8 +4472,7 @@ static int run(mddev_t *mddev)
 	mddev->queue->backing_dev_info.congested_data = mddev;
 	mddev->queue->backing_dev_info.congested_fn = raid5_congested;
 
-	mddev->array_sectors = mddev->dev_sectors *
-		(conf->previous_raid_disks - conf->max_degraded);
+	mddev->array_sectors = raid5_size(mddev, 0, 0);
 
 	blk_queue_merge_bvec(mddev->queue, raid5_mergeable_bvec);
 
@@ -4679,11 +4693,8 @@ static int raid5_resize(mddev_t *mddev, sector_t sectors)
 	 * any io in the removed space completes, but it hardly seems
 	 * worth it.
 	 */
-	raid5_conf_t *conf = mddev_to_conf(mddev);
-
 	sectors &= ~((sector_t)mddev->chunk_size/512 - 1);
-	mddev->array_sectors = sectors * (mddev->raid_disks
-					  - conf->max_degraded);
+	mddev->array_sectors = raid5_size(mddev, sectors, mddev->raid_disks);
 	set_capacity(mddev->gendisk, mddev->array_sectors);
 	mddev->changed = 1;
 	if (sectors > mddev->dev_sectors && mddev->recovery_cp == MaxSector) {
@@ -4819,10 +4830,12 @@ static void end_reshape(raid5_conf_t *conf)
 	struct block_device *bdev;
 
 	if (!test_bit(MD_RECOVERY_INTR, &conf->mddev->recovery)) {
-		conf->mddev->array_sectors = conf->mddev->dev_sectors *
-			(conf->raid_disks - conf->max_degraded);
-		set_capacity(conf->mddev->gendisk, conf->mddev->array_sectors);
-		conf->mddev->changed = 1;
+		mddev_t *mddev = conf->mddev;
+
+		mddev->array_sectors = raid5_size(mddev, 0, conf->raid_disks);
+		set_capacity(mddev->gendisk, mddev->array_sectors);
+		mddev->changed = 1;
+		conf->previous_raid_disks = conf->raid_disks;
 
 		bdev = bdget_disk(conf->mddev->gendisk, 0);
 		if (bdev) {
@@ -5071,6 +5084,7 @@ static struct mdk_personality raid6_personality =
 	.spare_active	= raid5_spare_active,
 	.sync_request	= sync_request,
 	.resize		= raid5_resize,
+	.size		= raid5_size,
 #ifdef CONFIG_MD_RAID5_RESHAPE
 	.check_reshape	= raid5_check_reshape,
 	.start_reshape  = raid5_start_reshape,
@@ -5093,6 +5107,7 @@ static struct mdk_personality raid5_personality =
 	.spare_active	= raid5_spare_active,
 	.sync_request	= sync_request,
 	.resize		= raid5_resize,
+	.size		= raid5_size,
 #ifdef CONFIG_MD_RAID5_RESHAPE
 	.check_reshape	= raid5_check_reshape,
 	.start_reshape  = raid5_start_reshape,
@@ -5117,6 +5132,7 @@ static struct mdk_personality raid4_personality =
 	.spare_active	= raid5_spare_active,
 	.sync_request	= sync_request,
 	.resize		= raid5_resize,
+	.size		= raid5_size,
 #ifdef CONFIG_MD_RAID5_RESHAPE
 	.check_reshape	= raid5_check_reshape,
 	.start_reshape  = raid5_start_reshape,
diff --git a/include/linux/raid/md_k.h b/include/linux/raid/md_k.h
index 68a6ac0..564ce81 100644
--- a/include/linux/raid/md_k.h
+++ b/include/linux/raid/md_k.h
@@ -325,6 +325,7 @@ struct mdk_personality
 	int (*spare_active) (mddev_t *mddev);
 	sector_t (*sync_request)(mddev_t *mddev, sector_t sector_nr, int *skipped, int go_faster);
 	int (*resize) (mddev_t *mddev, sector_t sectors);
+	sector_t (*size) (mddev_t *mddev, sector_t sectors, int raid_disks);
 	int (*check_reshape) (mddev_t *mddev);
 	int (*start_reshape) (mddev_t *mddev);
 	int (*reconfig) (mddev_t *mddev, int layout, int chunk_size);

