From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH 3/3] md: 'array_size' sysfs attribute
Date: Fri, 06 Mar 2009 23:28:09 -0700
Message-ID: <1236407289.28806.9.camel@dwillia2-linux.ch.intel.com>
References: <20090306002341.9882.61625.stgit@dwillia2-linux.ch.intel.com>
	 <20090306002458.9882.82188.stgit@dwillia2-linux.ch.intel.com>
	 <20090306161559.GJ32416@skl-net.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090306161559.GJ32416@skl-net.de>
Sender: linux-raid-owner@vger.kernel.org
To: Andre Noll <maan@systemlinux.org>, "neilb@suse.de" <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Danecki, Jacek" <jacek.danecki@intel.com>
List-Id: linux-raid.ids

Subject: md: fixups to the userspace array size changes

From: Dan Williams <dan.j.williams@intel.com>

As identified by Andre Noll <maan@systemlinux.org>:
1/ No need to recalculate chunk shift in raid10_size
2/ Check for overflow in conversions from blocks to sectors
3/ Missing cast to sector_t in raid5_size

Cc: Andre Noll <maan@systemlinux.org>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
On Fri, 2009-03-06 at 09:15 -0700, Andre Noll wrote: 
> This holds only until the array is stopped and reassembled (for
> example due to a reboot). Is that correct and intended?
[..] 
> Is it possible that already the "sectors *= 2" overflows? If this
> happens a much too small value is going to be stored by set_capacity()
> later.
[..]
> bdev is only used inside the if (mddev->pers). No need to define it at
> the top of the function.
[..]

Here is a fixup patch to be folded into the existing series.  Do you
want the fixed series in a git tree?

Thanks,
Dan

 drivers/md/faulty.c    |    2 +-
 drivers/md/linear.c    |    4 ++-
 drivers/md/md.c        |   55 ++++++++++++++++++++++++++++--------------------
 drivers/md/md.h        |    4 ++-
 drivers/md/multipath.c |    2 +-
 drivers/md/raid0.c     |    2 +-
 drivers/md/raid1.c     |    4 ++-
 drivers/md/raid10.c    |    9 +++-----
 drivers/md/raid5.c     |    9 +++-----
 9 files changed, 48 insertions(+), 43 deletions(-)

diff --git a/drivers/md/faulty.c b/drivers/md/faulty.c
index 24656c2..8695809 100644
--- a/drivers/md/faulty.c
+++ b/drivers/md/faulty.c
@@ -312,7 +312,7 @@ static int run(mddev_t *mddev)
 	list_for_each_entry(rdev, &mddev->disks, same_set)
 		conf->rdev = rdev;
 
-	md_set_size(mddev, faulty_size(mddev, 0, 0));
+	md_set_array_sectors(mddev, faulty_size(mddev, 0, 0));
 	mddev->private = conf;
 
 	reconfig(mddev, mddev->layout, -1);
diff --git a/drivers/md/linear.c b/drivers/md/linear.c
index 5b982a0..7a36e38 100644
--- a/drivers/md/linear.c
+++ b/drivers/md/linear.c
@@ -263,7 +263,7 @@ static int linear_run (mddev_t *mddev)
 	if (!conf)
 		return 1;
 	mddev->private = conf;
-	md_set_size(mddev, linear_size(mddev, 0, 0));
+	md_set_array_sectors(mddev, linear_size(mddev, 0, 0));
 
 	blk_queue_merge_bvec(mddev->queue, linear_mergeable_bvec);
 	mddev->queue->unplug_fn = linear_unplug;
@@ -297,7 +297,7 @@ static int linear_add(mddev_t *mddev, mdk_rdev_t *rdev)
 	newconf->prev = mddev_to_conf(mddev);
 	mddev->private = newconf;
 	mddev->raid_disks++;
-	md_set_size(mddev, linear_size(mddev, 0, 0));
+	md_set_array_sectors(mddev, linear_size(mddev, 0, 0));
 	set_capacity(mddev->gendisk, mddev->array_sectors);
 	return 0;
 }
diff --git a/drivers/md/md.c b/drivers/md/md.c
index cd1f6f0..b28db42 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -2287,16 +2287,34 @@ static int overlaps(sector_t s1, sector_t l1, sector_t s2, sector_t l2)
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
@@ -3187,12 +3205,11 @@ size_store(mddev_t *mddev, const char *buf, size_t len)
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
@@ -3645,8 +3662,7 @@ array_size_show(mddev_t *mddev, char *page)
 static ssize_t
 array_size_store(mddev_t *mddev, const char *buf, size_t len)
 {
-	unsigned long long sectors;
-	struct block_device *bdev;
+	sector_t sectors;
 
 	if (strncmp(buf, "default", 7) == 0) {
 		if (mddev->pers)
@@ -3656,15 +3672,7 @@ array_size_store(mddev_t *mddev, const char *buf, size_t len)
 
 		mddev->external_size = 0;
 	} else {
-		int err;
-		sector_t new;
-
-		err = strict_strtoull(buf, 10, &sectors);
-		if (err < 0)
-			return err;
-		sectors *= 2;
-		new = sectors;
-		if (new != sectors) /* overflow */
+		if (strict_blocks_to_sectors(buf, &sectors) < 0)
 			return -EINVAL;
 		if (mddev->pers && mddev->pers->size(mddev, 0, 0) < sectors)
 			return -EINVAL;
@@ -3675,7 +3683,8 @@ array_size_store(mddev_t *mddev, const char *buf, size_t len)
 	mddev->array_sectors = sectors;
 	set_capacity(mddev->gendisk, mddev->array_sectors);
 	if (mddev->pers) {
-		bdev = bdget_disk(mddev->gendisk, 0);
+		struct block_device *bdev = bdget_disk(mddev->gendisk, 0);
+
 		if (bdev) {
 			mutex_lock(&bdev->bd_inode->i_mutex);
 			i_size_write(bdev->bd_inode,
@@ -5050,7 +5059,7 @@ static int set_array_info(mddev_t * mddev, mdu_array_info_t *info)
 	return 0;
 }
 
-void md_set_size(mddev_t *mddev, sector_t array_sectors)
+void md_set_array_sectors(mddev_t *mddev, sector_t array_sectors)
 {
 	WARN(!mddev_is_locked(mddev), "%s: unlocked mddev!\n", __func__);
 
@@ -5059,15 +5068,15 @@ void md_set_size(mddev_t *mddev, sector_t array_sectors)
 
 	mddev->array_sectors = array_sectors;
 }
-EXPORT_SYMBOL(md_set_size);
+EXPORT_SYMBOL(md_set_array_sectors);
 
-void md_set_size_lock(mddev_t *mddev, sector_t array_sectors)
+void md_set_array_sectors_lock(mddev_t *mddev, sector_t array_sectors)
 {
 	mddev_lock(mddev);
-	md_set_size(mddev, array_sectors);
+	md_set_array_sectors(mddev, array_sectors);
 	mddev_unlock(mddev);
 }
-EXPORT_SYMBOL(md_set_size_lock);
+EXPORT_SYMBOL(md_set_array_sectors_lock);
 
 static int update_size(mddev_t *mddev, sector_t num_sectors)
 {
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 5ef9625..614329d 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -431,5 +431,5 @@ extern void md_do_sync(mddev_t *mddev);
 extern void md_new_event(mddev_t *mddev);
 extern int md_allow_write(mddev_t *mddev);
 extern void md_wait_for_blocked_rdev(mdk_rdev_t *rdev, mddev_t *mddev);
-extern void md_set_size(mddev_t *mddev, sector_t array_sectors);
-extern void md_set_size_lock(mddev_t *mddev, sector_t array_sectors);
+extern void md_set_array_sectors(mddev_t *mddev, sector_t array_sectors);
+extern void md_set_array_sectors_lock(mddev_t *mddev, sector_t array_sectors);
diff --git a/drivers/md/multipath.c b/drivers/md/multipath.c
index 273abca..41ced0c 100644
--- a/drivers/md/multipath.c
+++ b/drivers/md/multipath.c
@@ -510,7 +510,7 @@ static int multipath_run (mddev_t *mddev)
 	/*
 	 * Ok, everything is just fine now
 	 */
-	md_set_size(mddev, multipath_size(mddev, 0, 0));
+	md_set_array_sectors(mddev, multipath_size(mddev, 0, 0));
 
 	mddev->queue->unplug_fn = multipath_unplug;
 	mddev->queue->backing_dev_info.congested_fn = multipath_congested;
diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index e0603e2..c08d755 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -306,7 +306,7 @@ static int raid0_run (mddev_t *mddev)
 		goto out_free_conf;
 
 	/* calculate array device size */
-	md_set_size(mddev, raid0_size(mddev, 0, 0));
+	md_set_array_sectors(mddev, raid0_size(mddev, 0, 0));
 
 	printk(KERN_INFO "raid0 : md_size is %llu sectors.\n",
 		(unsigned long long)mddev->array_sectors);
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index e22fca0..b4f4bad 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -2059,7 +2059,7 @@ static int run(mddev_t *mddev)
 	/*
 	 * Ok, everything is just fine now
 	 */
-	md_set_size(mddev, raid1_size(mddev, 0, 0));
+	md_set_array_sectors(mddev, raid1_size(mddev, 0, 0));
 
 	mddev->queue->unplug_fn = raid1_unplug;
 	mddev->queue->backing_dev_info.congested_fn = raid1_congested;
@@ -2124,7 +2124,7 @@ static int raid1_resize(mddev_t *mddev, sector_t sectors)
 	 * any io in the removed space completes, but it hardly seems
 	 * worth it.
 	 */
-	md_set_size(mddev, raid1_size(mddev, sectors, 0));
+	md_set_array_sectors(mddev, raid1_size(mddev, sectors, 0));
 	if (mddev->array_sectors > raid1_size(mddev, sectors, 0))
 		return -EINVAL;
 	set_capacity(mddev->gendisk, mddev->array_sectors);
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index dd9850f..efbfbfa 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -2026,22 +2026,19 @@ static sector_t
 raid10_size(mddev_t *mddev, sector_t sectors, int raid_disks)
 {
 	sector_t size;
-	int chunk_shift;
 	conf_t *conf = mddev_to_conf(mddev);
-	int chunk_size = mddev->chunk_size;
 
 	if (!raid_disks)
 		raid_disks = mddev->raid_disks;
 	if (!sectors)
 		sectors = mddev->dev_sectors;
 
-	chunk_shift = ffz(~chunk_size) - 9;
-	size = sectors >> chunk_shift;
+	size = sectors >> conf->chunk_shift;
 	sector_div(size, conf->far_copies);
 	size = size * raid_disks;
 	sector_div(size, conf->near_copies);
 
-	return size << chunk_shift;
+	return size << conf->chunk_shift;
 }
 
 static int run(mddev_t *mddev)
@@ -2195,7 +2192,7 @@ static int run(mddev_t *mddev)
 	/*
 	 * Ok, everything is just fine now
 	 */
-	md_set_size(mddev, raid10_size(mddev, 0, 0));
+	md_set_array_sectors(mddev, raid10_size(mddev, 0, 0));
 	mddev->resync_max_sectors = raid10_size(mddev, 0, 0);
 
 	mddev->queue->unplug_fn = raid10_unplug;
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 0e9e867..582a87e 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -4172,14 +4172,13 @@ static sector_t
 raid5_size(mddev_t *mddev, sector_t sectors, int raid_disks)
 {
 	raid5_conf_t *conf = mddev_to_conf(mddev);
-	int chunk_size = mddev->chunk_size;
 
 	if (!sectors)
 		sectors = mddev->dev_sectors;
 	if (!raid_disks)
 		raid_disks = conf->previous_raid_disks;
 
-	sectors &= ~(chunk_size / 512 - 1);
+	sectors &= ~((sector_t)mddev->chunk_size/512 - 1);
 	return sectors * (raid_disks - conf->max_degraded);
 }
 
@@ -4477,7 +4476,7 @@ static int run(mddev_t *mddev)
 	mddev->queue->backing_dev_info.congested_data = mddev;
 	mddev->queue->backing_dev_info.congested_fn = raid5_congested;
 
-	md_set_size(mddev, raid5_size(mddev, 0, 0));
+	md_set_array_sectors(mddev, raid5_size(mddev, 0, 0));
 
 	blk_queue_merge_bvec(mddev->queue, raid5_mergeable_bvec);
 
@@ -4699,7 +4698,7 @@ static int raid5_resize(mddev_t *mddev, sector_t sectors)
 	 * worth it.
 	 */
 	sectors &= ~((sector_t)mddev->chunk_size/512 - 1);
-	md_set_size(mddev, raid5_size(mddev, sectors, mddev->raid_disks));
+	md_set_array_sectors(mddev, raid5_size(mddev, sectors, mddev->raid_disks));
 	if (mddev->array_sectors >
 	    raid5_size(mddev, sectors, mddev->raid_disks))
 		return -EINVAL;
@@ -4840,7 +4839,7 @@ static void end_reshape(raid5_conf_t *conf)
 	if (!test_bit(MD_RECOVERY_INTR, &conf->mddev->recovery)) {
 		mddev_t *mddev = conf->mddev;
 
-		md_set_size_lock(mddev, raid5_size(mddev, 0, conf->raid_disks));
+		md_set_array_sectors_lock(mddev, raid5_size(mddev, 0, conf->raid_disks));
 		set_capacity(mddev->gendisk, mddev->array_sectors);
 		mddev->changed = 1;
 		conf->previous_raid_disks = conf->raid_disks;


