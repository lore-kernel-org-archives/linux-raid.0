From: Dan Williams <dan.j.williams@intel.com>
Subject: [ md/for-next git pull ] Support setting the array size from
	userspace
Date: Tue, 17 Mar 2009 17:58:57 -0700
Message-ID: <1237337937.4026.13.camel@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid <linux-raid@vger.kernel.org>, Andre Noll <maan@systemlinux.org>, Jacek Danecki <jacek.danecki@intel.com>, Ed Ciechanowski <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids

The following changes since commit 28453471bcdd767f22b8c03987f1acd73a8f34c3:
  Atsushi SAKAI (1):
        md: fix typo in FSF address

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/djbw/md.git md-array-size

Dan Williams (3):
      md: add 'size' as a personality method
      md: centralize ->array_sectors modifications
      md: 'array_size' sysfs attribute

 drivers/md/faulty.c    |   14 +++++-
 drivers/md/linear.c    |   15 +++++-
 drivers/md/md.c        |  118 +++++++++++++++++++++++++++++++++++++++++++++---
 drivers/md/md.h        |    4 ++
 drivers/md/multipath.c |   11 ++++-
 drivers/md/raid0.c     |   22 +++++++--
 drivers/md/raid1.c     |   19 ++++++--
 drivers/md/raid10.c    |   24 +++++++++-
 drivers/md/raid5.c     |   42 +++++++++++++-----
 9 files changed, 236 insertions(+), 33 deletions(-)

This is the same series that was sent before, but with the fixes
identified by Andre and rebased on your 'md-scratch' branch.

Thanks,
Dan

---
commit 6c4bf89c12d629c8ed914247100aecc0e7830d7e
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Tue Mar 17 11:10:40 2009 -0700

    md: add 'size' as a personality method
    
    In preparation for giving userspace control over ->array_sectors we need
    to be able to retrieve the 'default' size, and the 'anticipated' size
    when a reshape is requested.  For personalities that do not reshape emit
    a warning if anything but the default size is requested.
    
    In the raid5 case we need to update ->previous_raid_disks to make the
    new 'default' size available.
    
    Reviewed-by: Andre Noll <maan@systemlinux.org>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

diff --git a/drivers/md/faulty.c b/drivers/md/faulty.c
index 18793c1..d76c87f 100644
--- a/drivers/md/faulty.c
+++ b/drivers/md/faulty.c
@@ -283,6 +283,17 @@ static int reconfig(mddev_t *mddev, int layout, int chunk_size)
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
@@ -301,7 +312,7 @@ static int run(mddev_t *mddev)
 	list_for_each_entry(rdev, &mddev->disks, same_set)
 		conf->rdev = rdev;
 
-	mddev->array_sectors = mddev->dev_sectors;
+	mddev->array_sectors = faulty_size(mddev, 0, 0);
 	mddev->private = conf;
 
 	reconfig(mddev, mddev->layout, -1);
@@ -328,6 +339,7 @@ static struct mdk_personality faulty_personality =
 	.stop		= stop,
 	.status		= status,
 	.reconfig	= reconfig,
+	.size		= faulty_size,
 };
 
 static int __init raid_init(void)
diff --git a/drivers/md/linear.c b/drivers/md/linear.c
index d5d9929..b6bb976 100644
--- a/drivers/md/linear.c
+++ b/drivers/md/linear.c
@@ -101,6 +101,16 @@ static int linear_congested(void *data, int bits)
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
@@ -253,7 +263,7 @@ static int linear_run (mddev_t *mddev)
 	if (!conf)
 		return 1;
 	mddev->private = conf;
-	mddev->array_sectors = conf->array_sectors;
+	mddev->array_sectors = linear_size(mddev, 0, 0);
 
 	blk_queue_merge_bvec(mddev->queue, linear_mergeable_bvec);
 	mddev->queue->unplug_fn = linear_unplug;
@@ -287,7 +297,7 @@ static int linear_add(mddev_t *mddev, mdk_rdev_t *rdev)
 	newconf->prev = mddev_to_conf(mddev);
 	mddev->private = newconf;
 	mddev->raid_disks++;
-	mddev->array_sectors = newconf->array_sectors;
+	mddev->array_sectors = linear_size(mddev, 0, 0);
 	set_capacity(mddev->gendisk, mddev->array_sectors);
 	return 0;
 }
@@ -385,6 +395,7 @@ static struct mdk_personality linear_personality =
 	.stop		= linear_stop,
 	.status		= linear_status,
 	.hot_add_disk	= linear_add,
+	.size		= linear_size,
 };
 
 static int __init linear_init (void)
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 8034f62..d2c50da 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -312,6 +312,7 @@ struct mdk_personality
 	int (*spare_active) (mddev_t *mddev);
 	sector_t (*sync_request)(mddev_t *mddev, sector_t sector_nr, int *skipped, int go_faster);
 	int (*resize) (mddev_t *mddev, sector_t sectors);
+	sector_t (*size) (mddev_t *mddev, sector_t sectors, int raid_disks);
 	int (*check_reshape) (mddev_t *mddev);
 	int (*start_reshape) (mddev_t *mddev);
 	int (*reconfig) (mddev_t *mddev, int layout, int chunk_size);
diff --git a/drivers/md/multipath.c b/drivers/md/multipath.c
index 87accf7..a3f6d86 100644
--- a/drivers/md/multipath.c
+++ b/drivers/md/multipath.c
@@ -406,6 +406,14 @@ static void multipathd (mddev_t *mddev)
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
@@ -502,7 +510,7 @@ static int multipath_run (mddev_t *mddev)
 	/*
 	 * Ok, everything is just fine now
 	 */
-	mddev->array_sectors = mddev->dev_sectors;
+	mddev->array_sectors = multipath_size(mddev, 0, 0);
 
 	mddev->queue->unplug_fn = multipath_unplug;
 	mddev->queue->backing_dev_info.congested_fn = multipath_congested;
@@ -547,6 +555,7 @@ static struct mdk_personality multipath_personality =
 	.error_handler	= multipath_error,
 	.hot_add_disk	= multipath_add_disk,
 	.hot_remove_disk= multipath_remove_disk,
+	.size		= multipath_size,
 };
 
 static int __init multipath_init (void)
diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index 9aebb4c..bb0df6a 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -263,12 +263,25 @@ static int raid0_mergeable_bvec(struct request_queue *q,
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
@@ -293,9 +306,7 @@ static int raid0_run (mddev_t *mddev)
 		goto out_free_conf;
 
 	/* calculate array device size */
-	mddev->array_sectors = 0;
-	list_for_each_entry(rdev, &mddev->disks, same_set)
-		mddev->array_sectors += rdev->sectors;
+	mddev->array_sectors = raid0_size(mddev, 0, 0);
 
 	printk(KERN_INFO "raid0 : md_size is %llu sectors.\n",
 		(unsigned long long)mddev->array_sectors);
@@ -511,6 +522,7 @@ static struct mdk_personality raid0_personality=
 	.run		= raid0_run,
 	.stop		= raid0_stop,
 	.status		= raid0_status,
+	.size		= raid0_size,
 };
 
 static int __init raid0_init (void)
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 7eaca32..a2a83b0 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1922,6 +1922,14 @@ static sector_t sync_request(mddev_t *mddev, sector_t sector_nr, int *skipped, i
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
@@ -2051,7 +2059,7 @@ static int run(mddev_t *mddev)
 	/*
 	 * Ok, everything is just fine now
 	 */
-	mddev->array_sectors = mddev->dev_sectors;
+	mddev->array_sectors = raid1_size(mddev, 0, 0);
 
 	mddev->queue->unplug_fn = raid1_unplug;
 	mddev->queue->backing_dev_info.congested_fn = raid1_congested;
@@ -2116,7 +2124,7 @@ static int raid1_resize(mddev_t *mddev, sector_t sectors)
 	 * any io in the removed space completes, but it hardly seems
 	 * worth it.
 	 */
-	mddev->array_sectors = sectors;
+	mddev->array_sectors = raid1_size(mddev, sectors, 0);
 	set_capacity(mddev->gendisk, mddev->array_sectors);
 	mddev->changed = 1;
 	if (mddev->array_sectors > mddev->dev_sectors &&
@@ -2270,6 +2278,7 @@ static struct mdk_personality raid1_personality =
 	.spare_active	= raid1_spare_active,
 	.sync_request	= sync_request,
 	.resize		= raid1_resize,
+	.size		= raid1_size,
 	.check_reshape	= raid1_reshape,
 	.quiesce	= raid1_quiesce,
 };
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index c2059e2..5bf1b24 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -2023,6 +2023,25 @@ static sector_t sync_request(mddev_t *mddev, sector_t sector_nr, int *skipped, i
 	goto skipped;
 }
 
+static sector_t
+raid10_size(mddev_t *mddev, sector_t sectors, int raid_disks)
+{
+	sector_t size;
+	conf_t *conf = mddev_to_conf(mddev);
+
+	if (!raid_disks)
+		raid_disks = mddev->raid_disks;
+	if (!sectors)
+		sectors = mddev->dev_sectors;
+
+	size = sectors >> conf->chunk_shift;
+	sector_div(size, conf->far_copies);
+	size = size * raid_disks;
+	sector_div(size, conf->near_copies);
+
+	return size << conf->chunk_shift;
+}
+
 static int run(mddev_t *mddev)
 {
 	conf_t *conf;
@@ -2174,8 +2193,8 @@ static int run(mddev_t *mddev)
 	/*
 	 * Ok, everything is just fine now
 	 */
-	mddev->array_sectors = size << conf->chunk_shift;
-	mddev->resync_max_sectors = size << conf->chunk_shift;
+	mddev->array_sectors = raid10_size(mddev, 0, 0);
+	mddev->resync_max_sectors = mddev->array_sectors;
 
 	mddev->queue->unplug_fn = raid10_unplug;
 	mddev->queue->backing_dev_info.congested_fn = raid10_congested;
@@ -2261,6 +2280,7 @@ static struct mdk_personality raid10_personality =
 	.spare_active	= raid10_spare_active,
 	.sync_request	= sync_request,
 	.quiesce	= raid10_quiesce,
+	.size		= raid10_size,
 };
 
 static int __init raid_init(void)
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 70b50af..2cd619f 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -4166,6 +4166,20 @@ static struct attribute_group raid5_attrs_group = {
 	.attrs = raid5_attrs,
 };
 
+static sector_t
+raid5_size(mddev_t *mddev, sector_t sectors, int raid_disks)
+{
+	raid5_conf_t *conf = mddev_to_conf(mddev);
+
+	if (!sectors)
+		sectors = mddev->dev_sectors;
+	if (!raid_disks)
+		raid_disks = conf->previous_raid_disks;
+
+	sectors &= ~((sector_t)mddev->chunk_size/512 - 1);
+	return sectors * (raid_disks - conf->max_degraded);
+}
+
 static raid5_conf_t *setup_conf(mddev_t *mddev)
 {
 	raid5_conf_t *conf;
@@ -4460,8 +4474,7 @@ static int run(mddev_t *mddev)
 	mddev->queue->backing_dev_info.congested_data = mddev;
 	mddev->queue->backing_dev_info.congested_fn = raid5_congested;
 
-	mddev->array_sectors = mddev->dev_sectors *
-		(conf->previous_raid_disks - conf->max_degraded);
+	mddev->array_sectors = raid5_size(mddev, 0, 0);
 
 	blk_queue_merge_bvec(mddev->queue, raid5_mergeable_bvec);
 
@@ -4684,11 +4697,8 @@ static int raid5_resize(mddev_t *mddev, sector_t sectors)
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
@@ -4824,10 +4834,12 @@ static void end_reshape(raid5_conf_t *conf)
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
@@ -5076,6 +5088,7 @@ static struct mdk_personality raid6_personality =
 	.spare_active	= raid5_spare_active,
 	.sync_request	= sync_request,
 	.resize		= raid5_resize,
+	.size		= raid5_size,
 #ifdef CONFIG_MD_RAID5_RESHAPE
 	.check_reshape	= raid5_check_reshape,
 	.start_reshape  = raid5_start_reshape,
@@ -5098,6 +5111,7 @@ static struct mdk_personality raid5_personality =
 	.spare_active	= raid5_spare_active,
 	.sync_request	= sync_request,
 	.resize		= raid5_resize,
+	.size		= raid5_size,
 #ifdef CONFIG_MD_RAID5_RESHAPE
 	.check_reshape	= raid5_check_reshape,
 	.start_reshape  = raid5_start_reshape,
@@ -5122,6 +5136,7 @@ static struct mdk_personality raid4_personality =
 	.spare_active	= raid5_spare_active,
 	.sync_request	= sync_request,
 	.resize		= raid5_resize,
+	.size		= raid5_size,
 #ifdef CONFIG_MD_RAID5_RESHAPE
 	.check_reshape	= raid5_check_reshape,
 	.start_reshape  = raid5_start_reshape,

commit 19428262e6c734c9fe01282588563fd2cd15d0cb
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Tue Mar 17 11:18:11 2009 -0700

    md: centralize ->array_sectors modifications
    
    Get personalities out of the business of directly modifying
    ->array_sectors.  Lays groundwork to introduce policy on when
    ->array_sectors can be modified.
    
    Reviewed-by: Andre Noll <maan@systemlinux.org>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

diff --git a/drivers/md/faulty.c b/drivers/md/faulty.c
index d76c87f..8695809 100644
--- a/drivers/md/faulty.c
+++ b/drivers/md/faulty.c
@@ -312,7 +312,7 @@ static int run(mddev_t *mddev)
 	list_for_each_entry(rdev, &mddev->disks, same_set)
 		conf->rdev = rdev;
 
-	mddev->array_sectors = faulty_size(mddev, 0, 0);
+	md_set_array_sectors(mddev, faulty_size(mddev, 0, 0));
 	mddev->private = conf;
 
 	reconfig(mddev, mddev->layout, -1);
diff --git a/drivers/md/linear.c b/drivers/md/linear.c
index b6bb976..7a36e38 100644
--- a/drivers/md/linear.c
+++ b/drivers/md/linear.c
@@ -263,7 +263,7 @@ static int linear_run (mddev_t *mddev)
 	if (!conf)
 		return 1;
 	mddev->private = conf;
-	mddev->array_sectors = linear_size(mddev, 0, 0);
+	md_set_array_sectors(mddev, linear_size(mddev, 0, 0));
 
 	blk_queue_merge_bvec(mddev->queue, linear_mergeable_bvec);
 	mddev->queue->unplug_fn = linear_unplug;
@@ -297,7 +297,7 @@ static int linear_add(mddev_t *mddev, mdk_rdev_t *rdev)
 	newconf->prev = mddev_to_conf(mddev);
 	mddev->private = newconf;
 	mddev->raid_disks++;
-	mddev->array_sectors = linear_size(mddev, 0, 0);
+	md_set_array_sectors(mddev, linear_size(mddev, 0, 0));
 	set_capacity(mddev->gendisk, mddev->array_sectors);
 	return 0;
 }
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 0689d89..76ba69b 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -4977,6 +4977,12 @@ static int set_array_info(mddev_t * mddev, mdu_array_info_t *info)
 	return 0;
 }
 
+void md_set_array_sectors(mddev_t *mddev, sector_t array_sectors)
+{
+	mddev->array_sectors = array_sectors;
+}
+EXPORT_SYMBOL(md_set_array_sectors);
+
 static int update_size(mddev_t *mddev, sector_t num_sectors)
 {
 	mdk_rdev_t *rdev;
diff --git a/drivers/md/md.h b/drivers/md/md.h
index d2c50da..ce89dda 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -430,3 +430,4 @@ extern void md_do_sync(mddev_t *mddev);
 extern void md_new_event(mddev_t *mddev);
 extern int md_allow_write(mddev_t *mddev);
 extern void md_wait_for_blocked_rdev(mdk_rdev_t *rdev, mddev_t *mddev);
+extern void md_set_array_sectors(mddev_t *mddev, sector_t array_sectors);
diff --git a/drivers/md/multipath.c b/drivers/md/multipath.c
index a3f6d86..41ced0c 100644
--- a/drivers/md/multipath.c
+++ b/drivers/md/multipath.c
@@ -510,7 +510,7 @@ static int multipath_run (mddev_t *mddev)
 	/*
 	 * Ok, everything is just fine now
 	 */
-	mddev->array_sectors = multipath_size(mddev, 0, 0);
+	md_set_array_sectors(mddev, multipath_size(mddev, 0, 0));
 
 	mddev->queue->unplug_fn = multipath_unplug;
 	mddev->queue->backing_dev_info.congested_fn = multipath_congested;
diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index bb0df6a..6f7e538 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -306,7 +306,7 @@ static int raid0_run (mddev_t *mddev)
 		goto out_free_conf;
 
 	/* calculate array device size */
-	mddev->array_sectors = raid0_size(mddev, 0, 0);
+	md_set_array_sectors(mddev, raid0_size(mddev, 0, 0));
 
 	printk(KERN_INFO "raid0 : md_size is %llu sectors.\n",
 		(unsigned long long)mddev->array_sectors);
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index a2a83b0..044116b 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -2059,7 +2059,7 @@ static int run(mddev_t *mddev)
 	/*
 	 * Ok, everything is just fine now
 	 */
-	mddev->array_sectors = raid1_size(mddev, 0, 0);
+	md_set_array_sectors(mddev, raid1_size(mddev, 0, 0));
 
 	mddev->queue->unplug_fn = raid1_unplug;
 	mddev->queue->backing_dev_info.congested_fn = raid1_congested;
@@ -2124,7 +2124,7 @@ static int raid1_resize(mddev_t *mddev, sector_t sectors)
 	 * any io in the removed space completes, but it hardly seems
 	 * worth it.
 	 */
-	mddev->array_sectors = raid1_size(mddev, sectors, 0);
+	md_set_array_sectors(mddev, raid1_size(mddev, sectors, 0));
 	set_capacity(mddev->gendisk, mddev->array_sectors);
 	mddev->changed = 1;
 	if (mddev->array_sectors > mddev->dev_sectors &&
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 5bf1b24..ad153b2 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -2193,7 +2193,7 @@ static int run(mddev_t *mddev)
 	/*
 	 * Ok, everything is just fine now
 	 */
-	mddev->array_sectors = raid10_size(mddev, 0, 0);
+	md_set_array_sectors(mddev, raid10_size(mddev, 0, 0));
 	mddev->resync_max_sectors = mddev->array_sectors;
 
 	mddev->queue->unplug_fn = raid10_unplug;
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 2cd619f..c9c4ef2 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -4474,7 +4474,7 @@ static int run(mddev_t *mddev)
 	mddev->queue->backing_dev_info.congested_data = mddev;
 	mddev->queue->backing_dev_info.congested_fn = raid5_congested;
 
-	mddev->array_sectors = raid5_size(mddev, 0, 0);
+	md_set_array_sectors(mddev, raid5_size(mddev, 0, 0));
 
 	blk_queue_merge_bvec(mddev->queue, raid5_mergeable_bvec);
 
@@ -4698,7 +4698,7 @@ static int raid5_resize(mddev_t *mddev, sector_t sectors)
 	 * worth it.
 	 */
 	sectors &= ~((sector_t)mddev->chunk_size/512 - 1);
-	mddev->array_sectors = raid5_size(mddev, sectors, mddev->raid_disks);
+	md_set_array_sectors(mddev, raid5_size(mddev, sectors, mddev->raid_disks));
 	set_capacity(mddev->gendisk, mddev->array_sectors);
 	mddev->changed = 1;
 	if (sectors > mddev->dev_sectors && mddev->recovery_cp == MaxSector) {
@@ -4836,7 +4836,7 @@ static void end_reshape(raid5_conf_t *conf)
 	if (!test_bit(MD_RECOVERY_INTR, &conf->mddev->recovery)) {
 		mddev_t *mddev = conf->mddev;
 
-		mddev->array_sectors = raid5_size(mddev, 0, conf->raid_disks);
+		md_set_array_sectors(mddev, raid5_size(mddev, 0, conf->raid_disks));
 		set_capacity(mddev->gendisk, mddev->array_sectors);
 		mddev->changed = 1;
 		conf->previous_raid_disks = conf->raid_disks;

commit e22fb959bfafc2e1963bc09436ddd6017d99af70
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Tue Mar 17 11:26:59 2009 -0700

    md: 'array_size' sysfs attribute
    
    Allow userspace to set the size of the array according to the following
    semantics:
    
    1/ size must be <= to the size returned by mddev->pers->size(mddev, 0, 0)
       a) If size is set before the array is running, do_md_run will fail
          if size is greater than the default size
       b) A reshape attempt that reduces the default size to less than the set
          array size should be blocked
    2/ once userspace sets the size the kernel will not change it
    3/ writing 'default' to this attribute returns control of the size to the
       kernel and reverts to the size reported by the personality
    
    Also, convert locations that need to know the default size from directly
    reading ->array_sectors to <pers>_size.  Resync/reshape operations
    always follow the default size.
    
    Finally, fixup other locations that read a number of 1k-blocks from
    userspace to use strict_blocks_to_sectors() which checks for unsigned
    long long to sector_t overflow and blocks to sectors overflow.
    
    Reviewed-by: Andre Noll <maan@systemlinux.org>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 76ba69b..923d125 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -387,6 +387,11 @@ static inline int mddev_lock(mddev_t * mddev)
 	return mutex_lock_interruptible(&mddev->reconfig_mutex);
 }
 
+static inline int mddev_is_locked(mddev_t *mddev)
+{
+	return mutex_is_locked(&mddev->reconfig_mutex);
+}
+
 static inline int mddev_trylock(mddev_t * mddev)
 {
 	return mutex_trylock(&mddev->reconfig_mutex);
@@ -2282,16 +2287,34 @@ static int overlaps(sector_t s1, sector_t l1, sector_t s2, sector_t l2)
 	return 1;
 }
 
+static int strict_blocks_to_sectors(const char *buf, sector_t *sectors)
+{
+	unsigned long long blocks;
+	sector_t new;
+
+	if (strict_strtoull(buf, 10, &blocks) < 0)
+		return -EINVAL;
+
+	if (blocks & 1ULL << (8 * sizeof(blocks) - 1))
+		return -EINVAL; /* sector conversion overflow */
+
+	new = blocks * 2;
+	if (new != blocks * 2)
+		return -EINVAL; /* unsigned long long to sector_t overflow */
+
+	*sectors = new;
+	return 0;
+}
+
 static ssize_t
 rdev_size_store(mdk_rdev_t *rdev, const char *buf, size_t len)
 {
 	mddev_t *my_mddev = rdev->mddev;
 	sector_t oldsectors = rdev->sectors;
-	unsigned long long sectors;
+	sector_t sectors;
 
-	if (strict_strtoull(buf, 10, &sectors) < 0)
+	if (strict_blocks_to_sectors(buf, &sectors) < 0)
 		return -EINVAL;
-	sectors *= 2;
 	if (my_mddev->pers && rdev->raid_disk >= 0) {
 		if (my_mddev->persistent) {
 			sectors = super_types[my_mddev->major_version].
@@ -3182,12 +3205,11 @@ size_store(mddev_t *mddev, const char *buf, size_t len)
 	 * not increase it (except from 0).
 	 * If array is active, we can try an on-line resize
 	 */
-	unsigned long long sectors;
-	int err = strict_strtoull(buf, 10, &sectors);
+	sector_t sectors;
+	int err = strict_blocks_to_sectors(buf, &sectors);
 
 	if (err < 0)
 		return err;
-	sectors *= 2;
 	if (mddev->pers) {
 		err = update_size(mddev, sectors);
 		md_update_sb(mddev, 1);
@@ -3627,6 +3649,57 @@ static struct md_sysfs_entry md_reshape_position =
 __ATTR(reshape_position, S_IRUGO|S_IWUSR, reshape_position_show,
        reshape_position_store);
 
+static ssize_t
+array_size_show(mddev_t *mddev, char *page)
+{
+	if (mddev->external_size)
+		return sprintf(page, "%llu\n",
+			       (unsigned long long)mddev->array_sectors/2);
+	else
+		return sprintf(page, "default\n");
+}
+
+static ssize_t
+array_size_store(mddev_t *mddev, const char *buf, size_t len)
+{
+	sector_t sectors;
+
+	if (strncmp(buf, "default", 7) == 0) {
+		if (mddev->pers)
+			sectors = mddev->pers->size(mddev, 0, 0);
+		else
+			sectors = mddev->array_sectors;
+
+		mddev->external_size = 0;
+	} else {
+		if (strict_blocks_to_sectors(buf, &sectors) < 0)
+			return -EINVAL;
+		if (mddev->pers && mddev->pers->size(mddev, 0, 0) < sectors)
+			return -EINVAL;
+
+		mddev->external_size = 1;
+	}
+
+	mddev->array_sectors = sectors;
+	set_capacity(mddev->gendisk, mddev->array_sectors);
+	if (mddev->pers) {
+		struct block_device *bdev = bdget_disk(mddev->gendisk, 0);
+
+		if (bdev) {
+			mutex_lock(&bdev->bd_inode->i_mutex);
+			i_size_write(bdev->bd_inode,
+				     (loff_t)mddev->array_sectors << 9);
+			mutex_unlock(&bdev->bd_inode->i_mutex);
+			bdput(bdev);
+		}
+	}
+
+	return len;
+}
+
+static struct md_sysfs_entry md_array_size =
+__ATTR(array_size, S_IRUGO|S_IWUSR, array_size_show,
+       array_size_store);
 
 static struct attribute *md_default_attrs[] = {
 	&md_level.attr,
@@ -3640,6 +3713,7 @@ static struct attribute *md_default_attrs[] = {
 	&md_safe_delay.attr,
 	&md_array_state.attr,
 	&md_reshape_position.attr,
+	&md_array_size.attr,
 	NULL,
 };
 
@@ -4045,7 +4119,17 @@ static int do_md_run(mddev_t * mddev)
 	err = mddev->pers->run(mddev);
 	if (err)
 		printk(KERN_ERR "md: pers->run() failed ...\n");
-	else if (mddev->pers->sync_request) {
+	else if (mddev->pers->size(mddev, 0, 0) < mddev->array_sectors) {
+		WARN_ONCE(!mddev->external_size, "%s: default size too small,"
+			  " but 'external_size' not in effect?\n", __func__);
+		printk(KERN_ERR
+		       "md: invalid array_size %llu > default size %llu\n",
+		       (unsigned long long)mddev->array_sectors / 2,
+		       (unsigned long long)mddev->pers->size(mddev, 0, 0) / 2);
+		err = -EINVAL;
+		mddev->pers->stop(mddev);
+	}
+	if (err == 0 && mddev->pers->sync_request) {
 		err = bitmap_create(mddev);
 		if (err) {
 			printk(KERN_ERR "%s: failed to create bitmap (%d)\n",
@@ -4281,6 +4365,7 @@ static int do_md_stop(mddev_t * mddev, int mode, int is_open)
 		export_array(mddev);
 
 		mddev->array_sectors = 0;
+		mddev->external_size = 0;
 		mddev->dev_sectors = 0;
 		mddev->raid_disks = 0;
 		mddev->recovery_cp = 0;
@@ -4979,10 +5064,23 @@ static int set_array_info(mddev_t * mddev, mdu_array_info_t *info)
 
 void md_set_array_sectors(mddev_t *mddev, sector_t array_sectors)
 {
+	WARN(!mddev_is_locked(mddev), "%s: unlocked mddev!\n", __func__);
+
+	if (mddev->external_size)
+		return;
+
 	mddev->array_sectors = array_sectors;
 }
 EXPORT_SYMBOL(md_set_array_sectors);
 
+void md_set_array_sectors_lock(mddev_t *mddev, sector_t array_sectors)
+{
+	mddev_lock(mddev);
+	md_set_array_sectors(mddev, array_sectors);
+	mddev_unlock(mddev);
+}
+EXPORT_SYMBOL(md_set_array_sectors_lock);
+
 static int update_size(mddev_t *mddev, sector_t num_sectors)
 {
 	mdk_rdev_t *rdev;
diff --git a/drivers/md/md.h b/drivers/md/md.h
index ce89dda..614329d 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -147,6 +147,7 @@ struct mddev_s
 	sector_t			dev_sectors; 	/* used size of
 							 * component devices */
 	sector_t			array_sectors; /* exported array size */
+	int				external_size; /* size managed externallly */
 	__u64				events;
 
 	char				uuid[16];
@@ -431,3 +432,4 @@ extern void md_new_event(mddev_t *mddev);
 extern int md_allow_write(mddev_t *mddev);
 extern void md_wait_for_blocked_rdev(mdk_rdev_t *rdev, mddev_t *mddev);
 extern void md_set_array_sectors(mddev_t *mddev, sector_t array_sectors);
+extern void md_set_array_sectors_lock(mddev_t *mddev, sector_t array_sectors);
diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index 6f7e538..c08d755 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -313,7 +313,7 @@ static int raid0_run (mddev_t *mddev)
 	printk(KERN_INFO "raid0 : conf->spacing is %llu sectors.\n",
 		(unsigned long long)conf->spacing);
 	{
-		sector_t s = mddev->array_sectors;
+		sector_t s = raid0_size(mddev, 0, 0);
 		sector_t space = conf->spacing;
 		int round;
 		conf->sector_shift = 0;
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 044116b..b4f4bad 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -2125,14 +2125,16 @@ static int raid1_resize(mddev_t *mddev, sector_t sectors)
 	 * worth it.
 	 */
 	md_set_array_sectors(mddev, raid1_size(mddev, sectors, 0));
+	if (mddev->array_sectors > raid1_size(mddev, sectors, 0))
+		return -EINVAL;
 	set_capacity(mddev->gendisk, mddev->array_sectors);
 	mddev->changed = 1;
-	if (mddev->array_sectors > mddev->dev_sectors &&
+	if (sectors > mddev->dev_sectors &&
 	    mddev->recovery_cp == MaxSector) {
 		mddev->recovery_cp = mddev->dev_sectors;
 		set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
 	}
-	mddev->dev_sectors = mddev->array_sectors;
+	mddev->dev_sectors = sectors;
 	mddev->resync_max_sectors = sectors;
 	return 0;
 }
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index ad153b2..e293d92 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -2194,7 +2194,7 @@ static int run(mddev_t *mddev)
 	 * Ok, everything is just fine now
 	 */
 	md_set_array_sectors(mddev, raid10_size(mddev, 0, 0));
-	mddev->resync_max_sectors = mddev->array_sectors;
+	mddev->resync_max_sectors = raid10_size(mddev, 0, 0);
 
 	mddev->queue->unplug_fn = raid10_unplug;
 	mddev->queue->backing_dev_info.congested_fn = raid10_congested;
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index c9c4ef2..21fcbaa 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -3703,6 +3703,8 @@ static int make_request(struct request_queue *q, struct bio * bi)
 	return 0;
 }
 
+static sector_t raid5_size(mddev_t *mddev, sector_t sectors, int raid_disks);
+
 static sector_t reshape_request(mddev_t *mddev, sector_t sector_nr, int *skipped)
 {
 	/* reshaping is quite different to recovery/resync so it is
@@ -3781,7 +3783,7 @@ static sector_t reshape_request(mddev_t *mddev, sector_t sector_nr, int *skipped
 			    j == sh->qd_idx)
 				continue;
 			s = compute_blocknr(sh, j);
-			if (s < mddev->array_sectors) {
+			if (s < raid5_size(mddev, 0, 0)) {
 				skipped = 1;
 				continue;
 			}
@@ -4699,6 +4701,9 @@ static int raid5_resize(mddev_t *mddev, sector_t sectors)
 	 */
 	sectors &= ~((sector_t)mddev->chunk_size/512 - 1);
 	md_set_array_sectors(mddev, raid5_size(mddev, sectors, mddev->raid_disks));
+	if (mddev->array_sectors >
+	    raid5_size(mddev, sectors, mddev->raid_disks))
+		return -EINVAL;
 	set_capacity(mddev->gendisk, mddev->array_sectors);
 	mddev->changed = 1;
 	if (sectors > mddev->dev_sectors && mddev->recovery_cp == MaxSector) {
@@ -4836,7 +4841,7 @@ static void end_reshape(raid5_conf_t *conf)
 	if (!test_bit(MD_RECOVERY_INTR, &conf->mddev->recovery)) {
 		mddev_t *mddev = conf->mddev;
 
-		md_set_array_sectors(mddev, raid5_size(mddev, 0, conf->raid_disks));
+		md_set_array_sectors_lock(mddev, raid5_size(mddev, 0, conf->raid_disks));
 		set_capacity(mddev->gendisk, mddev->array_sectors);
 		mddev->changed = 1;
 		conf->previous_raid_disks = conf->raid_disks;


