From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 10/10] md/raid10: add reshape support
Date: Tue, 03 Apr 2012 15:53:02 +1000
Message-ID: <20120403055302.19495.40559.stgit@notabene.brown>
References: <20120403054656.19495.36380.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120403054656.19495.36380.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

A 'near' or 'offset' lay RAID10 array can be reshaped to a different
'near' or 'offset' layout, a different chunk size, and a different
number of devices.
However the number of copies cannot change.

Unlike RAID5/6, we do not support having user-space backup data that
is being relocated during a 'critical section'.  Rather, the
data_offset of each device must change so that when writing any block
to a new location, it will not over-write any data that is still
'live'.

This means that RAID10 reshape is not supportable on v0.90 metadata.

The different between the old data_offset and the new_offset must be
at least the larger of the chunksize multiplied by offset copies of
each of the old and new layout. (for 'near' mode, offset_copies == 1).

A larger difference of around 64M seems useful for in-place reshapes
as more data can be moved between metadata updates.
Very large differences (e.g. 512M) seem to slow the process down due
to lots of long seeks (on oldish consumer graded devices at least).

Metadata needs to be updated whenever the place we are about to write
to is considered - by the current metadata - to still contain data in
the old layout.

Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/raid10.c |  888 ++++++++++++++++++++++++++++++++++++++++++++++++++-
 drivers/md/raid10.h |    6 
 2 files changed, 874 insertions(+), 20 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 1f84b8e..409dcc4 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -24,6 +24,7 @@
 #include <linux/module.h>
 #include <linux/seq_file.h>
 #include <linux/ratelimit.h>
+#include <linux/kthread.h>
 #include "md.h"
 #include "raid10.h"
 #include "raid0.h"
@@ -68,6 +69,11 @@ static int max_queued_requests = 1024;
 static void allow_barrier(struct r10conf *conf);
 static void lower_barrier(struct r10conf *conf);
 static int enough(struct r10conf *conf, int ignore);
+static sector_t reshape_request(struct mddev *mddev, sector_t sector_nr,
+				int *skipped);
+static void reshape_request_write(struct mddev *mddev, struct r10bio *r10_bio);
+static void end_reshape_write(struct bio *bio, int error);
+static void end_reshape(struct r10conf *conf);
 
 static void * r10bio_pool_alloc(gfp_t gfp_flags, void *data)
 {
@@ -112,7 +118,8 @@ static void * r10buf_pool_alloc(gfp_t gfp_flags, void *data)
 	if (!r10_bio)
 		return NULL;
 
-	if (test_bit(MD_RECOVERY_SYNC, &conf->mddev->recovery))
+	if (test_bit(MD_RECOVERY_SYNC, &conf->mddev->recovery) ||
+	    test_bit(MD_RECOVERY_RESHAPE, &conf->mddev->recovery))
 		nalloc = conf->copies; /* resync */
 	else
 		nalloc = 2; /* recovery */
@@ -140,9 +147,10 @@ static void * r10buf_pool_alloc(gfp_t gfp_flags, void *data)
 		struct bio *rbio = r10_bio->devs[j].repl_bio;
 		bio = r10_bio->devs[j].bio;
 		for (i = 0; i < RESYNC_PAGES; i++) {
-			if (j == 1 && !test_bit(MD_RECOVERY_SYNC,
-						&conf->mddev->recovery)) {
-				/* we can share bv_page's during recovery */
+			if (j > 0 && !test_bit(MD_RECOVERY_SYNC,
+					       &conf->mddev->recovery)) {
+				/* we can share bv_page's during recovery
+				 * and reshape */
 				struct bio *rbio = r10_bio->devs[0].bio;
 				page = rbio->bi_io_vec[i].bv_page;
 				get_page(page);
@@ -309,6 +317,10 @@ static int find_bio_disk(struct r10conf *conf, struct r10bio *r10_bio,
 			break;
 		}
 	}
+	/* Handle reshape reads */
+	if (slot == conf->copies &&
+	    bio == r10_bio->master_bio)
+		slot = r10_bio->read_slot;
 
 	BUG_ON(slot == conf->copies);
 	update_head_pos(slot, r10_bio);
@@ -614,10 +626,11 @@ static int raid10_mergeable_bvec(struct request_queue *q,
 	struct r10conf *conf = mddev->private;
 	sector_t sector = bvm->bi_sector + get_start_sect(bvm->bi_bdev);
 	int max;
-	unsigned int chunk_sectors = mddev->chunk_sectors;
+	unsigned int chunk_sectors;
 	unsigned int bio_sectors = bvm->bi_size >> 9;
 	struct geom *geo = &conf->geo;
 
+	chunk_sectors = (conf->geo.chunk_mask & conf->prev.chunk_mask) + 1;
 	if (conf->reshape_progress != MaxSector &&
 	    ((sector >= conf->reshape_progress) !=
 	     conf->mddev->reshape_backwards))
@@ -1032,6 +1045,7 @@ static void make_request(struct mddev *mddev, struct bio * bio)
 	int plugged;
 	int sectors_handled;
 	int max_sectors;
+	int sectors;
 
 	if (unlikely(bio->bi_rw & REQ_FLUSH)) {
 		md_flush_request(mddev, bio);
@@ -1096,10 +1110,41 @@ static void make_request(struct mddev *mddev, struct bio * bio)
 	 */
 	wait_barrier(conf);
 
+	sectors = bio->bi_size >> 9;
+	while (test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery) &&
+	    bio->bi_sector < conf->reshape_progress &&
+	    bio->bi_sector + sectors > conf->reshape_progress) {
+		/* IO spans the reshape position.  Need to wait for
+		 * reshape to pass
+		 */
+		allow_barrier(conf);
+		wait_event(conf->wait_barrier,
+			   conf->reshape_progress <= bio->bi_sector ||
+			   conf->reshape_progress >= bio->bi_sector + sectors);
+		wait_barrier(conf);
+	}
+	if (test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery) &&
+	    bio_data_dir(bio) == WRITE &&
+	    (mddev->reshape_backwards
+	     ? (bio->bi_sector < conf->reshape_safe &&
+		bio->bi_sector + sectors > conf->reshape_progress)
+	     : (bio->bi_sector + sectors > conf->reshape_safe &&
+		bio->bi_sector < conf->reshape_progress))) {
+		/* Need to update reshape_position in metadata */
+		mddev->reshape_position = conf->reshape_progress;
+		set_bit(MD_CHANGE_DEVS, &mddev->flags);
+		set_bit(MD_CHANGE_PENDING, &mddev->flags);
+		md_wakeup_thread(mddev->thread);
+		wait_event(mddev->sb_wait,
+			   !test_bit(MD_CHANGE_PENDING, &mddev->flags));
+
+		conf->reshape_safe = mddev->reshape_position;
+	}
+
 	r10_bio = mempool_alloc(conf->r10bio_pool, GFP_NOIO);
 
 	r10_bio->master_bio = bio;
-	r10_bio->sectors = bio->bi_size >> 9;
+	r10_bio->sectors = sectors;
 
 	r10_bio->mddev = mddev;
 	r10_bio->sector = bio->bi_sector;
@@ -2631,6 +2676,8 @@ static void raid10d(struct mddev *mddev)
 		if (test_bit(R10BIO_MadeGood, &r10_bio->state) ||
 		    test_bit(R10BIO_WriteError, &r10_bio->state))
 			handle_write_completed(conf, r10_bio);
+		else if (test_bit(R10BIO_IsReshape, &r10_bio->state))
+			reshape_request_write(mddev, r10_bio);
 		else if (test_bit(R10BIO_IsSync, &r10_bio->state))
 			sync_request_write(mddev, r10_bio);
 		else if (test_bit(R10BIO_IsRecover, &r10_bio->state))
@@ -2723,7 +2770,8 @@ static sector_t sync_request(struct mddev *mddev, sector_t sector_nr,
 
  skipped:
 	max_sector = mddev->dev_sectors;
-	if (test_bit(MD_RECOVERY_SYNC, &mddev->recovery))
+	if (test_bit(MD_RECOVERY_SYNC, &mddev->recovery) ||
+	    test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery))
 		max_sector = mddev->resync_max_sectors;
 	if (sector_nr >= max_sector) {
 		/* If we aborted, we need to abort the
@@ -2735,6 +2783,11 @@ static sector_t sync_request(struct mddev *mddev, sector_t sector_nr,
 		 * we need to convert that to several
 		 * virtual addresses.
 		 */
+		if (test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery)) {
+			end_reshape(conf);
+			return 0;
+		}
+
 		if (mddev->curr_resync < max_sector) { /* aborted */
 			if (test_bit(MD_RECOVERY_SYNC, &mddev->recovery))
 				bitmap_end_sync(mddev->bitmap, mddev->curr_resync,
@@ -2766,6 +2819,10 @@ static sector_t sync_request(struct mddev *mddev, sector_t sector_nr,
 		*skipped = 1;
 		return sectors_skipped;
 	}
+
+	if (test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery))
+		return reshape_request(mddev, sector_nr, skipped);
+
 	if (chunks_skipped >= conf->geo.raid_disks) {
 		/* if there has been nothing to do on any drive,
 		 * then there is nothing to do at all..
@@ -3211,7 +3268,8 @@ raid10_size(struct mddev *mddev, sector_t sectors, int raid_disks)
 	struct r10conf *conf = mddev->private;
 
 	if (!raid_disks)
-		raid_disks = conf->geo.raid_disks;
+		raid_disks = min(conf->geo.raid_disks,
+				 conf->prev.raid_disks);
 	if (!sectors)
 		sectors = conf->dev_sectors;
 
@@ -3223,6 +3281,34 @@ raid10_size(struct mddev *mddev, sector_t sectors, int raid_disks)
 	return size << conf->geo.chunk_shift;
 }
 
+static int LCM(int a, int b)
+{
+	int prod = a * b;
+
+	while (a != b) {
+		if (a < b)
+			b -= a;
+		else
+			a -= b;
+	}
+	return prod / a;
+}
+
+static unsigned long stripe_blocks(struct geom *geo)
+{
+	/* Given a 'geom', calculate the 'stripe' size being the
+	 * number of stored blocks (sectors) before the stripe pattern
+	 * repeats.  This is not well-defined for 'far' layouts, so we
+	 * assume 'offset' or 'near'.
+	 *
+	 * The answer is the chunk size times the LCM of raid_disks
+	 * and near_copies, times far_copies.
+	 */
+	unsigned long size = geo->far_copies * LCM(geo->raid_disks,
+						   geo->near_copies);
+	return size << geo->chunk_shift;
+}
+
 enum geo_type {geo_new, geo_old, geo_start};
 static int setup_geo(struct geom *geo, struct mddev *mddev, enum geo_type new)
 {
@@ -3292,7 +3378,9 @@ static struct r10conf *setup_conf(struct mddev *mddev)
 	if (!conf)
 		goto out;
 
-	conf->mirrors = kzalloc(sizeof(struct mirror_info)*mddev->raid_disks,
+	/* FIXME calc properly */
+	conf->mirrors = kzalloc(sizeof(struct mirror_info)*(mddev->raid_disks +
+							    max(0,mddev->delta_disks)),
 				GFP_KERNEL);
 	if (!conf->mirrors)
 		goto out;
@@ -3329,9 +3417,17 @@ static struct r10conf *setup_conf(struct mddev *mddev)
 	else
 		sector_div(stride, geo.far_copies);
 	conf->geo.stride = stride << conf->geo.chunk_shift;
-	conf->prev = conf->geo;
-	conf->reshape_progress = MaxSector;
-
+	if (mddev->reshape_position == MaxSector) {
+		conf->prev = conf->geo;
+		conf->reshape_progress = MaxSector;
+	} else {
+		if (setup_geo(&conf->prev, mddev, geo_old) != conf->copies) {
+			err = -EINVAL;
+			goto out;
+		}
+		conf->reshape_progress = mddev->reshape_position;
+		conf->prev.stride = 1 << conf->prev.chunk_shift;
+	}
 	spin_lock_init(&conf->device_lock);
 	INIT_LIST_HEAD(&conf->retry_list);
 
@@ -3346,8 +3442,9 @@ static struct r10conf *setup_conf(struct mddev *mddev)
 	return conf;
 
  out:
-	printk(KERN_ERR "md/raid10:%s: couldn't allocate memory.\n",
-	       mdname(mddev));
+	if (err == -ENOMEM)
+		printk(KERN_ERR "md/raid10:%s: couldn't allocate memory.\n",
+		       mdname(mddev));
 	if (conf) {
 		if (conf->r10bio_pool)
 			mempool_destroy(conf->r10bio_pool);
@@ -3365,12 +3462,8 @@ static int run(struct mddev *mddev)
 	struct mirror_info *disk;
 	struct md_rdev *rdev;
 	sector_t size;
-
-	/*
-	 * copy the already verified devices into our private RAID10
-	 * bookkeeping area. [whatever we allocate in run(),
-	 * should be freed in stop()]
-	 */
+	sector_t min_offset_diff = 0;
+	int first = 1;
 
 	if (mddev->private == NULL) {
 		conf = setup_conf(mddev);
@@ -3394,6 +3487,7 @@ static int run(struct mddev *mddev)
 				 (conf->geo.raid_disks / conf->geo.near_copies));
 
 	rdev_for_each(rdev, mddev) {
+		long long diff;
 
 		disk_idx = rdev->raid_disk;
 		if (disk_idx < 0)
@@ -3412,12 +3506,20 @@ static int run(struct mddev *mddev)
 				goto out_free_conf;
 			disk->rdev = rdev;
 		}
+		diff = (rdev->new_data_offset - rdev->data_offset);
+		if (!mddev->reshape_backwards)
+			diff = -diff;
+		if (diff < 0)
+			diff = 0;
+		if (first || diff < min_offset_diff)
+			min_offset_diff = diff;
 
 		disk_stack_limits(mddev->gendisk, rdev->bdev,
 				  rdev->data_offset << 9);
 
 		disk->head_position = 0;
 	}
+
 	/* need to check that every block has at least one working mirror */
 	if (!enough(conf, -1)) {
 		printk(KERN_ERR "md/raid10:%s: not enough operational mirrors.\n",
@@ -3425,6 +3527,16 @@ static int run(struct mddev *mddev)
 		goto out_free_conf;
 	}
 
+	if (conf->reshape_progress != MaxSector) {
+		/* must ensure that shape change is supported */
+		if (conf->geo.far_copies != 1 &&
+		    conf->geo.far_offset == 0)
+			goto out_free_conf;
+		if (conf->prev.far_copies != 1 &&
+		    conf->geo.far_offset == 0)
+			goto out_free_conf;
+	}
+
 	mddev->degraded = 0;
 	for (i = 0;
 	     i < conf->geo.raid_disks
@@ -3486,6 +3598,40 @@ static int run(struct mddev *mddev)
 	if (md_integrity_register(mddev))
 		goto out_free_conf;
 
+	if (conf->reshape_progress != MaxSector) {
+		unsigned long before_size, before_length;
+		unsigned long after_size, after_length;
+		unsigned long blocks;
+
+		blocks = stripe_blocks(&conf->prev);
+		before_size = blocks / conf->copies;
+		before_length = blocks / conf->prev.raid_disks;
+
+		blocks = stripe_blocks(&conf->geo);
+		after_size = blocks / conf->copies;
+		after_length = blocks / conf->geo.raid_disks;
+
+		if (max(before_length, after_length) > min_offset_diff) {
+			/* This cannot work */
+			printk("md/raid10: offset difference not enough to continue reshape\n");
+			goto out_free_conf;
+		}
+		conf->offset_diff = min_offset_diff;
+
+		conf->geo.stripe_size = after_size;
+		conf->geo.stripe_length = after_length;
+		conf->prev.stripe_size = before_size;
+		conf->prev.stripe_length = before_length;
+
+		conf->reshape_safe = conf->reshape_progress;
+		clear_bit(MD_RECOVERY_SYNC, &mddev->recovery);
+		clear_bit(MD_RECOVERY_CHECK, &mddev->recovery);
+		set_bit(MD_RECOVERY_RESHAPE, &mddev->recovery);
+		set_bit(MD_RECOVERY_RUNNING, &mddev->recovery);
+		mddev->sync_thread = md_register_thread(md_do_sync, mddev,
+							"reshape");
+	}
+
 	return 0;
 
 out_free_conf:
@@ -3624,6 +3770,705 @@ static void *raid10_takeover(struct mddev *mddev)
 	return ERR_PTR(-EINVAL);
 }
 
+static int raid10_check_reshape(struct mddev *mddev)
+{
+	/* Called when there is a request to change
+	 * - layout (to ->new_layout)
+	 * - chunk size (to ->new_chunk_sectors)
+	 * - raid_disks (by delta_disks)
+	 * or when trying to restart a reshape that was ongoing.
+	 *
+	 * We need to validate the request and possibly allocate
+	 * space if that might be an issue later.
+	 *
+	 * Currently we reject any reshape of a 'far' mode array,
+	 * allow chunk size to change if new is generally acceptable,
+	 * allow raid_disks to increase, and allow
+	 * a switch between 'near' mode and 'offset' mode.
+	 */
+	struct r10conf *conf = mddev->private;
+	struct geom geo;
+
+	if (conf->geo.far_copies != 1 && !conf->geo.far_offset)
+		return -EINVAL;
+
+	if (setup_geo(&geo, mddev, geo_start) != conf->copies)
+		/* mustn't change number of copies */
+		return -EINVAL;
+	if (geo.far_copies > 1 && !geo.far_offset)
+		/* Cannot switch to 'far' mode */
+		return -EINVAL;
+
+	if (mddev->array_sectors & geo.chunk_mask)
+			/* not factor of array size */
+			return -EINVAL;
+
+	if (mddev->delta_disks < 0)
+		return -EINVAL;
+
+	if (mddev->bitmap)
+		return -EBUSY;
+	if (!enough(conf, -1))
+		return -EINVAL;
+
+	kfree(conf->mirrors_new);
+	conf->mirrors_new = NULL;
+	if (mddev->delta_disks > 0) {
+		/* allocate new 'mirrors' list */
+		conf->mirrors_new = kzalloc(
+			sizeof(struct mirror_info)
+			*(mddev->raid_disks +
+			  mddev->delta_disks),
+			GFP_KERNEL);
+		if (!conf->mirrors_new)
+			return -ENOMEM;
+	}
+	return 0;
+}
+
+/*
+ * Need to check if array has failed when deciding whether to:
+ *  - start an array
+ *  - remove non-faulty devices
+ *  - add a spare
+ *  - allow a reshape
+ * This determination is simple when no reshape is happening.
+ * However if there is a reshape, we need to carefully check
+ * both the before and after sections.
+ * This is because some failed devices may only affect one
+ * of the two sections, and some non-in_sync devices may
+ * be insync in the section most affected by failed devices.
+ */
+static int calc_degraded(struct r10conf *conf)
+{
+	int degraded, degraded2;
+	int i;
+
+	rcu_read_lock();
+	degraded = 0;
+	/* 'prev' section first */
+	for (i = 0; i < conf->prev.raid_disks; i++) {
+		struct md_rdev *rdev = rcu_dereference(conf->mirrors[i].rdev);
+		if (!rdev || test_bit(Faulty, &rdev->flags))
+			degraded++;
+		else if (!test_bit(In_sync, &rdev->flags))
+			/* When we can reduce the number of devices in
+			 * an array, this might not contribute to
+			 * 'degraded'.  It does now.
+			 */
+			degraded++;
+	}
+	rcu_read_unlock();
+	if (conf->geo.raid_disks == conf->prev.raid_disks)
+		return degraded;
+	rcu_read_lock();
+	degraded2 = 0;
+	for (i = 0; i < conf->geo.raid_disks; i++) {
+		struct md_rdev *rdev = rcu_dereference(conf->mirrors[i].rdev);
+		if (!rdev || test_bit(Faulty, &rdev->flags))
+			degraded2++;
+		else if (!test_bit(In_sync, &rdev->flags)) {
+			/* If reshape is increasing the number of devices,
+			 * this section has already been recovered, so
+			 * it doesn't contribute to degraded.
+			 * else it does.
+			 */
+			if (conf->geo.raid_disks <= conf->prev.raid_disks)
+				degraded2++;
+		}
+	}
+	rcu_read_unlock();
+	if (degraded2 > degraded)
+		return degraded2;
+	return degraded;
+}
+
+static int raid10_start_reshape(struct mddev *mddev)
+{
+	/* A 'reshape' has been requested. This commits
+	 * the various 'new' fields and sets MD_RECOVER_RESHAPE
+	 * This also checks if there are enough spares and adds them
+	 * to the array.
+	 * We currently require enough spares to make the final
+	 * array non-degraded.  We also require that the difference
+	 * between old and new data_offset - on each device - is
+	 * enough that we never risk over-writing.
+	 */
+
+	unsigned long before_size, before_length;
+	unsigned long after_size, after_length;
+	unsigned long blocks;
+	sector_t min_offset_diff = 0;
+	int first = 1;
+	struct geom new;
+	struct r10conf *conf = mddev->private;
+	struct md_rdev *rdev;
+	int spares = 0;
+
+	if (test_bit(MD_RECOVERY_RUNNING, &mddev->recovery))
+		return -EBUSY;
+
+	blocks = stripe_blocks(&conf->geo);
+	before_size = blocks / conf->copies;
+	before_length = blocks / conf->geo.raid_disks;
+
+	if (setup_geo(&new, mddev, geo_start) != conf->copies)
+		return -EINVAL;
+	blocks = stripe_blocks(&new);
+	after_size = blocks / conf->copies;
+	after_length = blocks / new.raid_disks;
+
+	conf->geo.stripe_size = after_size;
+	conf->geo.stripe_length = after_length;
+	conf->prev.stripe_size = before_size;
+	conf->prev.stripe_length = before_length;
+
+	rdev_for_each(rdev, mddev) {
+		if (!test_bit(In_sync, &rdev->flags)
+		    && !test_bit(Faulty, &rdev->flags))
+			spares++;
+		if (rdev->raid_disk >= 0) {
+			long long diff = (rdev->new_data_offset
+					  - rdev->data_offset);
+			if (!mddev->reshape_backwards)
+				diff = -diff;
+			if (diff < 0)
+				diff = 0;
+			if (first || diff < min_offset_diff)
+				min_offset_diff = diff;
+		}
+	}
+	printk("Required offset diff %llu\n",(unsigned long long)max(before_length, after_length));
+	printk("Have: %llu\n",(unsigned long long)min_offset_diff);
+
+	if (max(before_length, after_length) > min_offset_diff)
+		return -EINVAL;
+
+	if (spares < mddev->delta_disks)
+		return -EINVAL;
+
+	conf->offset_diff = min_offset_diff;
+	spin_lock_irq(&conf->device_lock);
+	if (conf->mirrors_new) {
+		memcpy(conf->mirrors_new, conf->mirrors,
+		       sizeof(struct mirror_info)*conf->prev.raid_disks);
+		smp_mb();
+		kfree(conf->mirrors_old); /* FIXME and elsewhere */
+		conf->mirrors_old = conf->mirrors;
+		conf->mirrors = conf->mirrors_new;
+		conf->mirrors_new = NULL;
+	}
+	setup_geo(&conf->geo, mddev, geo_start);
+	smp_mb();
+	if (mddev->reshape_backwards)
+		conf->reshape_progress = raid10_size(mddev, 0, 0);
+	else
+		conf->reshape_progress = 0;
+	spin_unlock_irq(&conf->device_lock);
+
+	if (mddev->delta_disks > 0) {
+		rdev_for_each(rdev, mddev)
+			if (rdev->raid_disk < 0 &&
+			    !test_bit(Faulty, &rdev->flags)) {
+				if (raid10_add_disk(mddev, rdev) == 0) {
+					if (rdev->raid_disk >=
+					    conf->prev.raid_disks)
+						set_bit(In_sync, &rdev->flags);
+					else
+						rdev->recovery_offset = 0;
+
+					if (sysfs_link_rdev(mddev, rdev))
+						/* Failure here  is OK */;
+				}
+			} else if (rdev->raid_disk >= conf->prev.raid_disks
+				   && !test_bit(Faulty, &rdev->flags)) {
+				/* This is a spare that was manually added */
+				set_bit(In_sync, &rdev->flags);
+			}
+
+		/* When a reshape changes the number of devices,
+		 * ->degraded is measured against the large of the
+		 * pre and  post numbers.
+		 */
+		spin_lock_irq(&conf->device_lock);
+		mddev->degraded = calc_degraded(conf);
+		spin_unlock_irq(&conf->device_lock);
+	}
+	mddev->raid_disks = conf->geo.raid_disks;
+	mddev->reshape_position = conf->reshape_progress;
+	set_bit(MD_CHANGE_DEVS, &mddev->flags);
+
+	clear_bit(MD_RECOVERY_SYNC, &mddev->recovery);
+	clear_bit(MD_RECOVERY_CHECK, &mddev->recovery);
+	set_bit(MD_RECOVERY_RESHAPE, &mddev->recovery);
+	set_bit(MD_RECOVERY_RUNNING, &mddev->recovery);
+
+	mddev->sync_thread = md_register_thread(md_do_sync, mddev,
+						"reshape");
+	if (!mddev->sync_thread) {
+		mddev->recovery = 0;
+		spin_lock_irq(&conf->device_lock);
+		conf->geo = conf->prev;
+		mddev->raid_disks = conf->geo.raid_disks;
+		rdev_for_each(rdev, mddev)
+			rdev->new_data_offset = rdev->data_offset;
+		smp_wmb();
+		conf->reshape_progress = MaxSector;
+		mddev->reshape_position = MaxSector;
+		spin_unlock_irq(&conf->device_lock);
+		return -EAGAIN;
+	}
+	conf->reshape_checkpoint = jiffies;
+	md_wakeup_thread(mddev->sync_thread);
+	md_new_event(mddev);
+	return 0;
+}
+
+static sector_t reshape_request(struct mddev *mddev, sector_t sector_nr,
+				int *skipped)
+{
+	/* We simply copy at most one chunk (smallest of old and new)
+	 * at a time, possibly less if that exceeds RESYNC_PAGES,
+	 * or we hit a bad block or something.
+	 * This might mean we pause for normal IO in the middle of
+	 * a chunk, but that is not a problem was mddev->reshape_position
+	 * can record any location.
+	 *
+	 * If we will want to write to a location that isn't
+	 * yet recorded as 'safe' (i.e. in metadata on disk) then
+	 * we need to flush all reshape requests and update the metadata.
+	 *
+	 * When reshaping forwards (e.g. to more devices), we interpret
+	 * 'safe' as the earliest block which might not have been copied
+	 * down yet.  We divide this by previous stripe size and multiply
+	 * by previous stripe length to get lowest device offset that we
+	 * cannot write to yet.
+	 * We interpret 'sector_nr' as an address that we want to write to.
+	 * We divide by new stripe size and multiply by stripe_length to
+	 * get device offset that we might want to write to.  We round up
+	 * be sure we cover the whole stripe.
+	 * If this 'next' write position is after the 'safe' position,
+	 * we must update the metadata to increase the 'safe' position.
+	 *
+	 * When reshaping backwards, we round in the opposite direction
+	 * and perform the reverse test:  next write position must not be
+	 * less than current safe position.
+	 *
+	 * In all this the minimum difference in data offsets
+	 * (conf->offset_diff - always positive) allows a bit of slack,
+	 * so next can be after 'safe', but not by more than offset_disk
+	 *
+	 * We need to prepare all the bios here before we start any IO
+	 * to ensure the size we choose is acceptable to all devices.
+	 * The means one for each copy for write-out and an extra one for
+	 * read-in.
+	 * We store the read-in bio in ->master_bio and the others in
+	 * ->devs[x].bio and ->devs[x].repl_bio.
+	 */
+	struct r10conf *conf = mddev->private;
+	struct r10bio *r10_bio;
+	sector_t next, safe, last;
+	int max_sectors;
+	int nr_sectors;
+	int s;
+	struct md_rdev *rdev;
+	int need_flush = 0;
+	struct bio *blist;
+	struct bio *bio, *read_bio;
+	int sectors_done = 0;
+
+	if (sector_nr == 0) {
+		/* If restarting in the middle, skip the initial sectors */
+		if (mddev->reshape_backwards &&
+		    conf->reshape_progress < raid10_size(mddev, 0, 0)) {
+			sector_nr = (raid10_size(mddev, 0, 0)
+				     - conf->reshape_progress);
+		} else if (!mddev->reshape_backwards &&
+			   conf->reshape_progress > 0)
+			sector_nr = conf->reshape_progress;
+		if (sector_nr) {
+			mddev->curr_resync_completed = sector_nr;
+			sysfs_notify(&mddev->kobj, NULL, "sync_completed");
+			*skipped = 1;
+			return sector_nr;
+		}
+	}
+
+	/* We don't use sector_nr to track where we are up to
+	 * as that doesn't work well for ->reshape_backwards.
+	 * So just use ->reshape_progress.
+	 */
+	if (mddev->reshape_backwards) {
+		/* 'next' is the earliest device address that we might
+		 * write to for this chunk in the new layout
+		 */
+		next = conf->reshape_progress - 1;
+		sector_div(next, conf->geo.stripe_size);
+		next *= conf->geo.stripe_length;
+
+		/* 'safe' is the last device address that we might read from
+		 * in the old layout after a restart
+		 */
+		safe = (conf->reshape_safe | conf->prev.chunk_mask) + 1;
+		safe = DIV_ROUND_UP_SECTOR_T(safe, conf->prev.stripe_size);
+		safe *= conf->prev.stripe_length;
+
+		if (next + conf->offset_diff < safe)
+			need_flush = 1;
+
+		last = conf->reshape_progress - 1;
+		sector_nr = last & ~(sector_t)(conf->geo.chunk_mask
+					       & conf->prev.chunk_mask);
+		if (sector_nr + RESYNC_BLOCK_SIZE/512 < last)
+			sector_nr = last + 1 - RESYNC_BLOCK_SIZE/512;
+	} else {
+		/* 'next' is the last device address that we might write to
+		 * for this chunk in the new layout
+		 */
+		next = (conf->reshape_progress | conf->geo.chunk_mask) + 1;
+		next = DIV_ROUND_UP_SECTOR_T(next, conf->geo.stripe_size);
+		next *= conf->geo.stripe_length;
+
+		/* 'safe' is the earliest device address that we might read from
+		 * in the old layout after a restart
+		 */
+		safe = conf->reshape_safe;
+		sector_div(safe, conf->prev.stripe_size);
+		safe *= conf->prev.stripe_length;
+
+		/* Need to update metadata if 'next' might be beyond 'safe'
+		 * as that would possibly corrupt data
+		 */
+		if (next >= safe + conf->offset_diff)
+			need_flush = 1;
+
+		sector_nr = conf->reshape_progress;
+		last  = sector_nr | (conf->geo.chunk_mask
+				     & conf->prev.chunk_mask);
+
+		if (sector_nr + RESYNC_BLOCK_SIZE/512 <= last)
+			last = sector_nr + RESYNC_BLOCK_SIZE/512 - 1;
+	}
+
+	if (need_flush ||
+	    time_after(jiffies, conf->reshape_checkpoint + 10*HZ)) {
+		/* Need to update reshape_position in metadata */
+		wait_barrier(conf);
+		mddev->reshape_position = conf->reshape_progress;
+		mddev->curr_resync_completed = sector_nr;
+		conf->reshape_checkpoint = jiffies;
+		set_bit(MD_CHANGE_DEVS, &mddev->flags);
+		md_wakeup_thread(mddev->thread);
+		wait_event(mddev->sb_wait, mddev->flags == 0 ||
+			   kthread_should_stop());
+		conf->reshape_safe = mddev->reshape_position;
+		allow_barrier(conf);
+	}
+
+read_more:
+	/* Now schedule reads for blocks from sector_nr to last */
+	r10_bio = mempool_alloc(conf->r10buf_pool, GFP_NOIO);
+	raise_barrier(conf, sectors_done != 0);
+	atomic_set(&r10_bio->remaining, 0);
+	r10_bio->mddev = mddev;
+	r10_bio->sector = sector_nr;
+	set_bit(R10BIO_IsReshape, &r10_bio->state);
+	r10_bio->sectors = last - sector_nr + 1;
+	rdev = read_balance(conf, r10_bio, &max_sectors);
+	BUG_ON(!test_bit(R10BIO_Previous, &r10_bio->state));
+
+	if (!rdev) {
+		/* Cannot read from here, so need to record bad blocks
+		 * on all the target devices.
+		 */
+		// FIXME
+		set_bit(MD_RECOVERY_INTR, &mddev->recovery);
+		return sectors_done;
+	}
+
+	read_bio = bio_alloc_mddev(GFP_KERNEL, RESYNC_PAGES, mddev);
+
+	read_bio->bi_bdev = rdev->bdev;
+	read_bio->bi_sector = (r10_bio->devs[r10_bio->read_slot].addr
+			       + rdev->data_offset);
+	read_bio->bi_private = r10_bio;
+	read_bio->bi_end_io = end_sync_read;
+	read_bio->bi_rw = READ;
+	read_bio->bi_flags &= ~(BIO_POOL_MASK - 1);
+	read_bio->bi_flags |= 1 << BIO_UPTODATE;
+	read_bio->bi_vcnt = 0;
+	read_bio->bi_idx = 0;
+	read_bio->bi_size = 0;
+	r10_bio->master_bio = read_bio;
+
+	/* Now find the locations in the new layout */
+	__raid10_find_phys(&conf->geo, r10_bio);
+
+	blist = read_bio;
+	read_bio->bi_next = NULL;
+
+	for (s = 0; s < conf->copies*2; s++) {
+		struct bio *b;
+		int d = r10_bio->devs[s/2].devnum;
+		struct md_rdev *rdev2;
+		if (s&1) {
+			rdev2 = conf->mirrors[d].replacement;
+			b = r10_bio->devs[s/2].repl_bio;
+		} else {
+			rdev2 = conf->mirrors[d].rdev;
+			b = r10_bio->devs[s/2].bio;
+		}
+		if (!rdev2 || test_bit(Faulty, &rdev2->flags))
+			continue;
+		b->bi_bdev = rdev2->bdev;
+		b->bi_sector = r10_bio->devs[s/2].addr + rdev2->new_data_offset;
+		b->bi_private = r10_bio;
+		b->bi_end_io = end_reshape_write;
+		b->bi_rw = WRITE;
+		b->bi_flags &= ~(BIO_POOL_MASK - 1);
+		b->bi_flags |= 1 << BIO_UPTODATE;
+		b->bi_next = blist;
+		b->bi_vcnt = 0;
+		b->bi_idx = 0;
+		b->bi_size = 0;
+		blist = b;
+	}
+
+	/* Now add as many pages as possible to all of these bios. */
+
+	nr_sectors = 0;
+	for (s = 0 ; s < max_sectors; s += PAGE_SIZE >> 9) {
+		struct page *page = r10_bio->devs[0].bio->bi_io_vec[s/(PAGE_SIZE>>9)].bv_page;
+		int len = (max_sectors - s) << 9;
+		if (len > PAGE_SIZE)
+			len = PAGE_SIZE;
+		for (bio = blist; bio ; bio = bio->bi_next) {
+			struct bio *bio2;
+			if (bio_add_page(bio, page, len, 0))
+				continue;
+
+			/* Didn't fit, must stop */
+			for (bio2 = blist;
+			     bio2 && bio2 != bio;
+			     bio2 = bio2->bi_next) {
+				/* Remove last page from this bio */
+				bio2->bi_vcnt--;
+				bio2->bi_size -= len;
+				bio2->bi_flags &= ~(1<<BIO_SEG_VALID);
+			}
+			goto bio_full;
+		}
+		sector_nr += len >> 9;
+		nr_sectors += len >> 9;
+	}
+bio_full:
+	r10_bio->sectors = nr_sectors;
+
+	/* Now submit the read */
+	md_sync_acct(read_bio->bi_bdev, r10_bio->sectors);
+	atomic_inc(&r10_bio->remaining);
+	read_bio->bi_next = NULL;
+	generic_make_request(read_bio);
+	sector_nr += nr_sectors;
+	sectors_done += nr_sectors;
+	if (sector_nr <= last)
+		goto read_more;
+
+	/* Now that we have done the whole section we can
+	 * update reshape_progress
+	 */
+	if (mddev->reshape_backwards)
+		conf->reshape_progress -= sectors_done;
+	else
+		conf->reshape_progress += sectors_done;
+
+	return sectors_done;
+}
+
+static void end_reshape_request(struct r10bio *r10_bio);
+static int handle_reshape_read_error(struct mddev *mddev,
+				     struct r10bio *r10_bio);
+static void reshape_request_write(struct mddev *mddev, struct r10bio *r10_bio)
+{
+	/* Reshape read completed.  Hopefully we have a block
+	 * to write out.
+	 * If we got a read error then we do sync 1-page reads from
+	 * elsewhere until we find the data - or give up.
+	 */
+	struct r10conf *conf = mddev->private;
+	int s;
+
+	if (!test_bit(R10BIO_Uptodate, &r10_bio->state))
+		if (handle_reshape_read_error(mddev, r10_bio) < 0) {
+			/* Reshape has been aborted */
+			md_done_sync(mddev, r10_bio->sectors, 0);
+			return;
+		}
+
+	/* We definitely have the data in the pages, schedule the
+	 * writes.
+	 */
+	atomic_set(&r10_bio->remaining, 1);
+	for (s = 0; s < conf->copies*2; s++) {
+		struct bio *b;
+		int d = r10_bio->devs[s/2].devnum;
+		struct md_rdev *rdev;
+		if (s&1) {
+			rdev = conf->mirrors[d].replacement;
+			b = r10_bio->devs[s/2].repl_bio;
+		} else {
+			rdev = conf->mirrors[d].rdev;
+			b = r10_bio->devs[s/2].bio;
+		}
+		if (!rdev || test_bit(Faulty, &rdev->flags))
+			continue;
+		atomic_inc(&rdev->nr_pending);
+		md_sync_acct(b->bi_bdev, r10_bio->sectors);
+		atomic_inc(&r10_bio->remaining);
+		b->bi_next = NULL;
+		generic_make_request(b);
+	}
+	end_reshape_request(r10_bio);
+}
+
+static void end_reshape(struct r10conf *conf)
+{
+	if (test_bit(MD_RECOVERY_INTR, &conf->mddev->recovery))
+		return;
+
+	spin_lock_irq(&conf->device_lock);
+	conf->prev = conf->geo;
+	md_finish_reshape(conf->mddev);
+	smp_wmb();
+	conf->reshape_progress = MaxSector;
+	spin_unlock_irq(&conf->device_lock);
+
+	/* read-ahead size must cover two whole stripes, which is
+	 * 2 * (datadisks) * chunksize where 'n' is the number of raid devices
+	 */
+	if (conf->mddev->queue) {
+		int stripe = conf->geo.raid_disks *
+			((conf->mddev->chunk_sectors << 9) / PAGE_SIZE);
+		stripe /= conf->geo.near_copies;
+		if (conf->mddev->queue->backing_dev_info.ra_pages < 2* stripe)
+			conf->mddev->queue->backing_dev_info.ra_pages = 2* stripe;
+	}
+}
+
+
+static int handle_reshape_read_error(struct mddev *mddev,
+				     struct r10bio *r10_bio)
+{
+	/* Use sync reads to get the blocks from somewhere else */
+	int sectors = r10_bio->sectors;
+	struct r10bio r10b;
+	struct r10conf *conf = mddev->private;
+	int slot = 0;
+	int idx = 0;
+	struct bio_vec *bvec = r10_bio->master_bio->bi_io_vec;
+
+	__raid10_find_phys(&conf->prev, &r10b);
+
+	while (sectors) {
+		int s = sectors;
+		int success = 0;
+		int first_slot = slot;
+
+		if (s > (PAGE_SIZE >> 9))
+			s = PAGE_SIZE >> 9;
+
+		while (!success) {
+			int d = r10b.devs[slot].devnum;
+			struct md_rdev *rdev = conf->mirrors[d].rdev;
+			sector_t addr;
+			if (rdev == NULL ||
+			    test_bit(Faulty, &rdev->flags) ||
+			    !test_bit(In_sync, &rdev->flags))
+				goto failed;
+
+			addr = r10b.devs[slot].addr + idx * PAGE_SIZE;
+			success = sync_page_io(rdev,
+					       addr,
+					       s << 9,
+					       bvec[idx].bv_page,
+					       READ, false);
+			if (success)
+				break;
+		failed:
+			slot++;
+			if (slot >= conf->copies)
+				slot = 0;
+			if (slot == first_slot)
+				break;
+		}
+		if (!success) {
+			/* couldn't read this block, must give up */
+			set_bit(MD_RECOVERY_INTR,
+				&mddev->recovery);
+			return -EIO;
+		}
+		sectors -= s;
+		idx++;
+	}
+	return 0;
+}
+
+static void end_reshape_write(struct bio *bio, int error)
+{
+	int uptodate = test_bit(BIO_UPTODATE, &bio->bi_flags);
+	struct r10bio *r10_bio = bio->bi_private;
+	struct mddev *mddev = r10_bio->mddev;
+	struct r10conf *conf = mddev->private;
+	int d;
+	int slot;
+	int repl;
+	struct md_rdev *rdev = NULL;
+
+	d = find_bio_disk(conf, r10_bio, bio, &slot, &repl);
+	if (repl)
+		rdev = conf->mirrors[d].replacement;
+	if (!rdev) {
+		smp_mb();
+		rdev = conf->mirrors[d].rdev;
+	}
+
+	if (!uptodate) {
+		/* FIXME should record badblock */
+		md_error(mddev, rdev);
+	}
+
+	rdev_dec_pending(rdev, mddev);
+	end_reshape_request(r10_bio);
+}
+
+static void end_reshape_request(struct r10bio *r10_bio)
+{
+	if (!atomic_dec_and_test(&r10_bio->remaining))
+		return;
+	md_done_sync(r10_bio->mddev, r10_bio->sectors, 1);
+	bio_put(r10_bio->master_bio);
+	put_buf(r10_bio);
+}
+
+static void raid10_finish_reshape(struct mddev *mddev)
+{
+	struct r10conf *conf = mddev->private;
+
+	if (test_bit(MD_RECOVERY_INTR, &mddev->recovery))
+		return;
+
+	if (mddev->delta_disks > 0) {
+		md_set_array_sectors(mddev, raid10_size(mddev, 0, 0));
+		set_capacity(mddev->gendisk, mddev->array_sectors);
+		revalidate_disk(mddev->gendisk);
+	}
+	mddev->layout = mddev->new_layout;
+	mddev->chunk_sectors = 1 << conf->geo.chunk_shift;
+	mddev->reshape_position = MaxSector;
+	mddev->delta_disks = 0;
+	mddev->reshape_backwards = 0;
+}
+
 static struct md_personality raid10_personality =
 {
 	.name		= "raid10",
@@ -3642,6 +4487,9 @@ static struct md_personality raid10_personality =
 	.size		= raid10_size,
 	.resize		= raid10_resize,
 	.takeover	= raid10_takeover,
+	.check_reshape	= raid10_check_reshape,
+	.start_reshape	= raid10_start_reshape,
+	.finish_reshape	= raid10_finish_reshape,
 };
 
 static int __init raid_init(void)
diff --git a/drivers/md/raid10.h b/drivers/md/raid10.h
index 37509d7..630d0f2 100644
--- a/drivers/md/raid10.h
+++ b/drivers/md/raid10.h
@@ -14,6 +14,7 @@ struct mirror_info {
 struct r10conf {
 	struct mddev		*mddev;
 	struct mirror_info	*mirrors;
+	struct mirror_info	*mirrors_new, *mirrors_old;
 	spinlock_t		device_lock;
 
 	/* geometry */
@@ -34,6 +35,7 @@ struct r10conf {
 					       */
 		int		chunk_shift; /* shift from chunks to sectors */
 		sector_t	chunk_mask;
+		long		stripe_size, stripe_length;
 	} prev, geo;
 	int			copies;	      /* near_copies * far_copies.
 					       * must be <= raid_disks
@@ -42,6 +44,9 @@ struct r10conf {
 	sector_t		dev_sectors;  /* temp copy of
 					       * mddev->dev_sectors */
 	sector_t		reshape_progress;
+	sector_t		reshape_safe;
+	unsigned long		reshape_checkpoint;
+	sector_t		offset_diff;
 
 	struct list_head	retry_list;
 	/* queue pending writes and submit them on unplug */
@@ -138,6 +143,7 @@ enum r10bio_state {
 	R10BIO_Uptodate,
 	R10BIO_IsSync,
 	R10BIO_IsRecover,
+	R10BIO_IsReshape,
 	R10BIO_Degraded,
 /* Set ReadError on bios that experience a read error
  * so that raid10d knows what to do with them.


