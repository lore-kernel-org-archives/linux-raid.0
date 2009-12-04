From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 07/22] md/raid1: add takeover support for raid5->raid1
Date: Fri, 04 Dec 2009 17:48:02 +1100
Message-ID: <20091204064802.10264.37738.stgit@notabene.brown>
References: <20091204064559.10264.37619.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20091204064559.10264.37619.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

A 2-device raid5 array can now be converted to raid1.

Signed-off-by: NeilBrown <neilb@suse.de>
---
 drivers/md/raid1.c |  193 +++++++++++++++++++++++++++++++---------------------
 drivers/md/raid1.h |    5 +
 2 files changed, 121 insertions(+), 77 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 35b2d86..18da334 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -677,6 +677,7 @@ static void raise_barrier(conf_t *conf)
 static void lower_barrier(conf_t *conf)
 {
 	unsigned long flags;
+	BUG_ON(conf->barrier <= 0);
 	spin_lock_irqsave(&conf->resync_lock, flags);
 	conf->barrier--;
 	spin_unlock_irqrestore(&conf->resync_lock, flags);
@@ -1960,74 +1961,48 @@ static sector_t raid1_size(mddev_t *mddev, sector_t sectors, int raid_disks)
 	return mddev->dev_sectors;
 }
 
-static int run(mddev_t *mddev)
+static conf_t *setup_conf(mddev_t *mddev)
 {
 	conf_t *conf;
-	int i, j, disk_idx;
-	mirror_info_t *disk;
 	mdk_rdev_t *rdev;
+	int err = -ENOMEM;
+	mirror_info_t *disk;
+	int i;
 
-	if (mddev->level != 1) {
-		printk("raid1: %s: raid level not set to mirroring (%d)\n",
-		       mdname(mddev), mddev->level);
-		goto out;
-	}
-	if (mddev->reshape_position != MaxSector) {
-		printk("raid1: %s: reshape_position set but not supported\n",
-		       mdname(mddev));
-		goto out;
-	}
-	/*
-	 * copy the already verified devices into our private RAID1
-	 * bookkeeping area. [whatever we allocate in run(),
-	 * should be freed in stop()]
-	 */
 	conf = kzalloc(sizeof(conf_t), GFP_KERNEL);
-	mddev->private = conf;
 	if (!conf)
-		goto out_no_mem;
+		goto abort;
 
 	conf->mirrors = kzalloc(sizeof(struct mirror_info)*mddev->raid_disks,
 				 GFP_KERNEL);
 	if (!conf->mirrors)
-		goto out_no_mem;
+		goto abort;
 
 	conf->tmppage = alloc_page(GFP_KERNEL);
 	if (!conf->tmppage)
-		goto out_no_mem;
+		goto abort;
 
-	conf->poolinfo = kmalloc(sizeof(*conf->poolinfo), GFP_KERNEL);
+	conf->poolinfo = kzalloc(sizeof(*conf->poolinfo), GFP_KERNEL);
 	if (!conf->poolinfo)
-		goto out_no_mem;
-	conf->poolinfo->mddev = NULL;
+		goto abort;
 	conf->poolinfo->raid_disks = mddev->raid_disks;
 	conf->r1bio_pool = mempool_create(NR_RAID1_BIOS, r1bio_pool_alloc,
 					  r1bio_pool_free,
 					  conf->poolinfo);
 	if (!conf->r1bio_pool)
-		goto out_no_mem;
+		goto abort;
+
 	conf->poolinfo->mddev = mddev;
 
 	spin_lock_init(&conf->device_lock);
-	mddev->queue->queue_lock = &conf->device_lock;
-
 	list_for_each_entry(rdev, &mddev->disks, same_set) {
-		disk_idx = rdev->raid_disk;
+		int disk_idx = rdev->raid_disk;
 		if (disk_idx >= mddev->raid_disks
 		    || disk_idx < 0)
 			continue;
 		disk = conf->mirrors + disk_idx;
 
 		disk->rdev = rdev;
-		disk_stack_limits(mddev->gendisk, rdev->bdev,
-				  rdev->data_offset << 9);
-		/* as we don't honour merge_bvec_fn, we must never risk
-		 * violating it, so limit ->max_sector to one PAGE, as
-		 * a one page request is never in violation.
-		 */
-		if (rdev->bdev->bd_disk->queue->merge_bvec_fn &&
-		    queue_max_sectors(mddev->queue) > (PAGE_SIZE>>9))
-			blk_queue_max_sectors(mddev->queue, PAGE_SIZE>>9);
 
 		disk->head_position = 0;
 	}
@@ -2041,8 +2016,7 @@ static int run(mddev_t *mddev)
 	bio_list_init(&conf->pending_bio_list);
 	bio_list_init(&conf->flushing_bio_list);
 
-
-	mddev->degraded = 0;
+	conf->last_used = -1;
 	for (i = 0; i < conf->raid_disks; i++) {
 
 		disk = conf->mirrors + i;
@@ -2050,38 +2024,97 @@ static int run(mddev_t *mddev)
 		if (!disk->rdev ||
 		    !test_bit(In_sync, &disk->rdev->flags)) {
 			disk->head_position = 0;
-			mddev->degraded++;
 			if (disk->rdev)
 				conf->fullsync = 1;
-		}
+		} else if (conf->last_used < 0)
+			/*
+			 * The first working device is used as a
+			 * starting point to read balancing.
+			 */
+			conf->last_used = i;
 	}
-	if (mddev->degraded == conf->raid_disks) {
+
+	err = -EIO;
+	if (conf->last_used < 0) {
 		printk(KERN_ERR "raid1: no operational mirrors for %s\n",
-			mdname(mddev));
-		goto out_free_conf;
+		       mdname(mddev));
+		goto abort;
 	}
-	if (conf->raid_disks - mddev->degraded == 1)
-		mddev->recovery_cp = MaxSector;
+	err = -ENOMEM;
+	conf->thread = md_register_thread(raid1d, mddev, NULL);
+	if (!conf->thread) {
+		printk(KERN_ERR
+		       "raid1: couldn't allocate thread for %s\n",
+		       mdname(mddev));
+		goto abort;
+	}
+
+	return conf;
+
+ abort:
+	if (conf) {
+		if (conf->r1bio_pool)
+			mempool_destroy(conf->r1bio_pool);
+		kfree(conf->mirrors);
+		safe_put_page(conf->tmppage);
+		kfree(conf->poolinfo);
+		kfree(conf);
+	}
+	return ERR_PTR(err);
+}
 
+static int run(mddev_t *mddev)
+{
+	conf_t *conf;
+	int i;
+	mdk_rdev_t *rdev;
+
+	if (mddev->level != 1) {
+		printk("raid1: %s: raid level not set to mirroring (%d)\n",
+		       mdname(mddev), mddev->level);
+		return -EIO;
+	}
+	if (mddev->reshape_position != MaxSector) {
+		printk("raid1: %s: reshape_position set but not supported\n",
+		       mdname(mddev));
+		return -EIO;
+	}
 	/*
-	 * find the first working one and use it as a starting point
-	 * to read balancing.
+	 * copy the already verified devices into our private RAID1
+	 * bookkeeping area. [whatever we allocate in run(),
+	 * should be freed in stop()]
 	 */
-	for (j = 0; j < conf->raid_disks &&
-		     (!conf->mirrors[j].rdev ||
-		      !test_bit(In_sync, &conf->mirrors[j].rdev->flags)) ; j++)
-		/* nothing */;
-	conf->last_used = j;
+	if (mddev->private == NULL)
+		conf = setup_conf(mddev);
+	else
+		conf = mddev->private;
 
+	if (IS_ERR(conf))
+		return PTR_ERR(conf);
 
-	mddev->thread = md_register_thread(raid1d, mddev, NULL);
-	if (!mddev->thread) {
-		printk(KERN_ERR
-		       "raid1: couldn't allocate thread for %s\n",
-		       mdname(mddev));
-		goto out_free_conf;
+	mddev->queue->queue_lock = &conf->device_lock;
+	list_for_each_entry(rdev, &mddev->disks, same_set) {
+		disk_stack_limits(mddev->gendisk, rdev->bdev,
+				  rdev->data_offset << 9);
+		/* as we don't honour merge_bvec_fn, we must never risk
+		 * violating it, so limit ->max_sector to one PAGE, as
+		 * a one page request is never in violation.
+		 */
+		if (rdev->bdev->bd_disk->queue->merge_bvec_fn &&
+		    queue_max_sectors(mddev->queue) > (PAGE_SIZE>>9))
+			blk_queue_max_sectors(mddev->queue, PAGE_SIZE>>9);
 	}
 
+	mddev->degraded = 0;
+	for (i=0; i < conf->raid_disks; i++)
+		if (conf->mirrors[i].rdev == NULL ||
+		    !test_bit(In_sync, &conf->mirrors[i].rdev->flags) ||
+		    test_bit(Faulty, &conf->mirrors[i].rdev->flags))
+			mddev->degraded++;
+
+	if (conf->raid_disks - mddev->degraded == 1)
+		mddev->recovery_cp = MaxSector;
+
 	if (mddev->recovery_cp != MaxSector)
 		printk(KERN_NOTICE "raid1: %s is not clean"
 		       " -- starting background reconstruction\n",
@@ -2090,9 +2123,14 @@ static int run(mddev_t *mddev)
 		"raid1: raid set %s active with %d out of %d mirrors\n",
 		mdname(mddev), mddev->raid_disks - mddev->degraded, 
 		mddev->raid_disks);
+
 	/*
 	 * Ok, everything is just fine now
 	 */
+	mddev->thread = conf->thread;
+	conf->thread = NULL;
+	mddev->private = conf;
+
 	md_set_array_sectors(mddev, raid1_size(mddev, 0, 0));
 
 	mddev->queue->unplug_fn = raid1_unplug;
@@ -2100,23 +2138,6 @@ static int run(mddev_t *mddev)
 	mddev->queue->backing_dev_info.congested_data = mddev;
 	md_integrity_register(mddev);
 	return 0;
-
-out_no_mem:
-	printk(KERN_ERR "raid1: couldn't allocate memory for %s\n",
-	       mdname(mddev));
-
-out_free_conf:
-	if (conf) {
-		if (conf->r1bio_pool)
-			mempool_destroy(conf->r1bio_pool);
-		kfree(conf->mirrors);
-		safe_put_page(conf->tmppage);
-		kfree(conf->poolinfo);
-		kfree(conf);
-		mddev->private = NULL;
-	}
-out:
-	return -EIO;
 }
 
 static int stop(mddev_t *mddev)
@@ -2302,6 +2323,23 @@ static void raid1_quiesce(mddev_t *mddev, int state)
 	}
 }
 
+static void *raid1_takeover(mddev_t *mddev)
+{
+	/* raid1 can take over:
+	 *  raid5 with 2 devices, any layout or chunk size
+	 */
+	if (mddev->level == 5 && mddev->raid_disks == 2) {
+		conf_t *conf;
+		mddev->new_level = 1;
+		mddev->new_layout = 0;
+		mddev->new_chunk_sectors = 0;
+		conf = setup_conf(mddev);
+		if (!IS_ERR(conf))
+			conf->barrier = 1;
+		return conf;
+	}
+	return ERR_PTR(-EINVAL);
+}
 
 static struct mdk_personality raid1_personality =
 {
@@ -2321,6 +2359,7 @@ static struct mdk_personality raid1_personality =
 	.size		= raid1_size,
 	.check_reshape	= raid1_reshape,
 	.quiesce	= raid1_quiesce,
+	.takeover	= raid1_takeover,
 };
 
 static int __init raid_init(void)
diff --git a/drivers/md/raid1.h b/drivers/md/raid1.h
index e87b84d..5f2d443 100644
--- a/drivers/md/raid1.h
+++ b/drivers/md/raid1.h
@@ -59,6 +59,11 @@ struct r1_private_data_s {
 
 	mempool_t *r1bio_pool;
 	mempool_t *r1buf_pool;
+
+	/* When taking over an array from a different personality, we store
+	 * the new thread here until we fully activate the array.
+	 */
+	struct mdk_thread_s	*thread;
 };
 
 typedef struct r1_private_data_s conf_t;


