From: raz ben yehuda <raziebe@gmail.com>
Subject: Subject:[PATCH 005:013]: raid0: refactor create_strip and raid0_run
Date: Wed, 17 Jun 2009 00:53:54 +0300
Message-ID: <1245189234.3478.102.camel@raz>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux raid <linux-raid@vger.kernel.org>, Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids

split raid0_run and create_strip_zones
    have create_strip work with conf structure instead of mddev
    have create_strip accept a list of disks instead of mddev->disks
    remove illegal disks before moving into create_strip
 
 raid0.c |  292 +++++++++++++++++++++++++++++++++++++---------------------------
 1 file changed, 173 insertions(+), 119 deletions(-)

Signed-off-by: razb <raziebe@gmail.com>
---
diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index 6f87db2..0bb151b 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -84,68 +84,35 @@ static void print_conf(raid0_conf_t *conf, int raid_disks, char *name)
 	printk(KERN_INFO "**********************************\n\n");
 }
 
-static int create_strip_zones(mddev_t *mddev)
+static void set_queues(struct list_head *disks, struct request_queue *queue)
 {
-	int i, c, j, err;
+	mdk_rdev_t *rdev1;
+	list_for_each_entry(rdev1, disks, same_set) {
+		blk_queue_stack_limits(queue,
+				       rdev1->bdev->bd_disk->queue);
+		/* as we don't honour merge_bvec_fn, we must never risk
+		 * violating it, so limit ->max_sector to one PAGE, as
+		 * a one page request is never in violation.
+		 */
+		if (rdev1->bdev->bd_disk->queue->merge_bvec_fn &&
+			queue_max_sectors(queue) > (PAGE_SIZE>>9))
+				blk_queue_max_sectors(queue, PAGE_SIZE>>9);
+	}
+}
+
+/*
+ * calculate the zones of the array.
+ * we calcuate the size of each zone and its offset.
+*/
+static int calc_zones(raid0_conf_t *conf, struct list_head *disks,
+			int raid_disks)
+{
+	int i, c, j;
 	sector_t current_start, curr_zone_start, sectors;
-	mdk_rdev_t *smallest, *rdev1, *rdev2, *rdev, **dev;
+	mdk_rdev_t *smallest, *rdev1, *rdev, **dev;
 	struct strip_zone *zone;
 	int cnt;
 	char b[BDEVNAME_SIZE];
-	raid0_conf_t *conf = kzalloc(sizeof(*conf), GFP_KERNEL);
-
-	if (!conf)
-		return -ENOMEM;
-	list_for_each_entry(rdev1, &mddev->disks, same_set) {
-		printk(KERN_INFO "raid0: looking at %s\n",
-			bdevname(rdev1->bdev,b));
-		c = 0;
-
-		/* round size to chunk_size */
-		sectors = rdev1->sectors;
-		sector_div(sectors, mddev->chunk_sectors);
-		rdev1->sectors = sectors * mddev->chunk_sectors;
-
-		list_for_each_entry(rdev2, &mddev->disks, same_set) {
-			printk(KERN_INFO "raid0:   comparing %s(%llu)",
-			       bdevname(rdev1->bdev,b),
-			       (unsigned long long)rdev1->sectors);
-			printk(KERN_INFO " with %s(%llu)\n",
-			       bdevname(rdev2->bdev,b),
-			       (unsigned long long)rdev2->sectors);
-			if (rdev2 == rdev1) {
-				printk(KERN_INFO "raid0:   END\n");
-				break;
-			}
-			if (rdev2->sectors == rdev1->sectors) {
-				/*
-				 * Not unique, don't count it as a new
-				 * group
-				 */
-				printk(KERN_INFO "raid0:   EQUAL\n");
-				c = 1;
-				break;
-			}
-			printk(KERN_INFO "raid0:   NOT EQUAL\n");
-		}
-		if (!c) {
-			printk(KERN_INFO "raid0:   ==> UNIQUE\n");
-			conf->nr_strip_zones++;
-			printk(KERN_INFO "raid0: %d zones\n",
-				conf->nr_strip_zones);
-		}
-	}
-	printk(KERN_INFO "raid0: FINAL %d zones\n", conf->nr_strip_zones);
-	err = -ENOMEM;
-	conf->strip_zone = kzalloc(sizeof(struct strip_zone)*
-				conf->nr_strip_zones, GFP_KERNEL);
-	if (!conf->strip_zone)
-		goto abort;
-	conf->devlist = kzalloc(sizeof(mdk_rdev_t*)*
-				conf->nr_strip_zones*mddev->raid_disks,
-				GFP_KERNEL);
-	if (!conf->devlist)
-		goto abort;
 
 	/* The first zone must contain all devices, so here we check that
 	 * there is a proper alignment of slots to devices and find them all
@@ -154,41 +121,30 @@ static int create_strip_zones(mddev_t *mddev)
 	cnt = 0;
 	smallest = NULL;
 	dev = conf->devlist;
-	err = -EINVAL;
-	list_for_each_entry(rdev1, &mddev->disks, same_set) {
+
+	list_for_each_entry(rdev1, disks, same_set) {
 		int j = rdev1->raid_disk;
 
-		if (j < 0 || j >= mddev->raid_disks) {
-			printk(KERN_ERR "raid0: bad disk number %d - "
-				"aborting!\n", j);
-			goto abort;
+		if (j < 0 || j >= raid_disks) {
+			printk(KERN_INFO "raid0: %s bad disk number id=%d"
+					" aborting!\n",
+					bdevname(rdev1->bdev, b), j);
 		}
 		if (dev[j]) {
-			printk(KERN_ERR "raid0: multiple devices for %d - "
-				"aborting!\n", j);
-			goto abort;
+			printk(KERN_ERR "raid0: multiple devices for %d/%d - "
+				"aborting!\n", j, raid_disks);
+			return -1;
 		}
 		dev[j] = rdev1;
 
-		blk_queue_stack_limits(mddev->queue,
-				       rdev1->bdev->bd_disk->queue);
-		/* as we don't honour merge_bvec_fn, we must never risk
-		 * violating it, so limit ->max_sector to one PAGE, as
-		 * a one page request is never in violation.
-		 */
-
-		if (rdev1->bdev->bd_disk->queue->merge_bvec_fn &&
-		    queue_max_sectors(mddev->queue) > (PAGE_SIZE>>9))
-			blk_queue_max_sectors(mddev->queue, PAGE_SIZE>>9);
-
 		if (!smallest || (rdev1->sectors < smallest->sectors))
 			smallest = rdev1;
 		cnt++;
 	}
-	if (cnt != mddev->raid_disks) {
+	if (cnt < raid_disks) {
 		printk(KERN_ERR "raid0: too few disks (%d of %d) - "
-			"aborting!\n", cnt, mddev->raid_disks);
-		goto abort;
+			"aborting!\n", cnt, raid_disks);
+		return -1;
 	}
 	zone->nb_dev = cnt;
 	zone->zone_end = smallest->sectors * cnt;
@@ -200,7 +156,7 @@ static int create_strip_zones(mddev_t *mddev)
 	for (i = 1; i < conf->nr_strip_zones; i++)
 	{
 		zone = conf->strip_zone + i;
-		dev = conf->devlist + i * mddev->raid_disks;
+		dev = conf->devlist + i * raid_disks;
 
 		printk(KERN_INFO "raid0: zone %d\n", i);
 		zone->dev_start = current_start;
@@ -225,7 +181,6 @@ static int create_strip_zones(mddev_t *mddev)
 					(unsigned long long)rdev->sectors);
 			}
 		}
-
 		zone->nb_dev = c;
 		sectors = (smallest->sectors - current_start) * c;
 		printk(KERN_INFO "raid0: zone->nb_dev: %d, sectors: %llu\n",
@@ -238,29 +193,74 @@ static int create_strip_zones(mddev_t *mddev)
 		printk(KERN_INFO "raid0: current zone start: %llu\n",
 			(unsigned long long)current_start);
 	}
-	mddev->queue->unplug_fn = raid0_unplug;
-	mddev->queue->backing_dev_info.congested_fn = raid0_congested;
-	mddev->queue->backing_dev_info.congested_data = mddev;
+	return 0;
+}
 
-	/*
-	 * now since we have the hard sector sizes, we can make sure
-	 * chunk size is a multiple of that sector size
-	 */
-	if ((mddev->chunk_sectors << 9) % queue_logical_block_size(mddev->queue)) {
-		printk(KERN_ERR "%s chunk_size of %d not valid\n",
-		       mdname(mddev),
-		       mddev->chunk_sectors << 9);
-		goto abort;
+/*
+ * create a strip for each zone.
+*/
+static int create_strip_zones(raid0_conf_t *conf, struct list_head *disks,
+				int chunk_sectors, int raid_disks)
+{
+	int c;
+	mdk_rdev_t *rdev1, *rdev2;
+	char b[BDEVNAME_SIZE];
+	sector_t sectors;
+
+	list_for_each_entry(rdev1, disks, same_set) {
+		printk(KERN_INFO "raid0: looking at %s\n",
+			bdevname(rdev1->bdev, b));
+		c = 0;
+		/* round size to chunk_size */
+		sectors = rdev1->sectors;
+		sector_div(sectors, chunk_sectors);
+		rdev1->sectors = sectors*chunk_sectors;
+
+		list_for_each_entry(rdev2, disks, same_set) {
+			printk(KERN_INFO "raid0:   comparing %s(%llu)",
+			       bdevname(rdev1->bdev, b),
+			       (unsigned long long)rdev1->sectors);
+			printk(KERN_INFO " with %s(%llu)\n",
+			       bdevname(rdev2->bdev, b),
+			       (unsigned long long)rdev2->sectors);
+			if (rdev2 == rdev1) {
+				printk(KERN_INFO "raid0:   END\n");
+				break;
+			}
+			if (rdev2->sectors == rdev1->sectors) {
+				/*
+				 * Not unique, don't count it as a new
+				 * group
+				 */
+				printk(KERN_INFO "raid0:   EQUAL\n");
+				c = 1;
+				break;
+			}
+			printk(KERN_INFO "raid0:   NOT EQUAL\n");
+		}
+		if (!c) {
+			printk(KERN_INFO "raid0:   ==> UNIQUE\n");
+			conf->nr_strip_zones++;
+			printk(KERN_INFO "raid0: %d zones\n",
+				conf->nr_strip_zones);
+		}
 	}
-	printk(KERN_INFO "raid0: done.\n");
-	mddev->private = conf;
+	printk(KERN_INFO "raid0: FINAL %d zones\n", conf->nr_strip_zones);
+	conf->strip_zone = kzalloc(sizeof(struct strip_zone)*
+				conf->nr_strip_zones, GFP_KERNEL);
+	if (!conf->strip_zone)
+		goto abort;
+	conf->devlist = kzalloc(sizeof(mdk_rdev_t *)*
+				conf->nr_strip_zones*raid_disks,
+				GFP_KERNEL);
+	if (!conf->devlist)
+		goto abort;
 	return 0;
 abort:
 	kfree(conf->strip_zone);
 	kfree(conf->devlist);
 	kfree(conf);
-	mddev->private = NULL;
-	return err;
+	return -1;
 }
 
 /**
@@ -311,9 +311,46 @@ static sector_t raid0_size(mddev_t *mddev, sector_t sectors, int raid_disks)
 	return array_sectors;
 }
 
+/* calculate the max read-ahead size.
+ * For read-ahead of large files to be effective, we need to
+ * readahead at least twice a whole stripe. i.e. number of devices
+ * multiplied by chunk size times 2.
+ * If an individual device has an ra_pages greater than the
+ * chunk size, then we will not drive that device as hard as it
+ * wants.  We consider this a configuration error: a larger
+ * chunksize should be used in that case.
+ */
+static void set_readahead(mddev_t *mddev)
+{
+	int stripe = mddev->raid_disks *
+			(mddev->chunk_sectors << 9) / PAGE_SIZE;
+	if (mddev->queue->backing_dev_info.ra_pages < 2 * stripe)
+		mddev->queue->backing_dev_info.ra_pages = 2 * stripe;
+}
+
+/*
+ * now since we have the hard sector sizes, we can make sure
+ * chunk size is a multiple of that sector size
+ */
+static int validate_chunk_alignment(mddev_t *mddev)
+{
+	if ((mddev->chunk_sectors << 9) %
+		queue_logical_block_size(mddev->queue)) {
+			printk(KERN_ERR
+				"%s chunk_size of %d not valid\n",
+				mdname(mddev),
+				mddev->chunk_sectors << 9);
+		return -1;
+	}
+	return 0;
+}
+
 static int raid0_run(mddev_t *mddev)
 {
-	int ret;
+	int ret = -ENOMEM;
+	raid0_conf_t *conf;
+	mdk_rdev_t *rdev1, *rdev2;
+	LIST_HEAD(new_disks);
 
 	if (mddev->chunk_sectors == 0) {
 		printk(KERN_ERR "md/raid0: chunk size must be set.\n");
@@ -321,35 +358,52 @@ static int raid0_run(mddev_t *mddev)
 	}
 	blk_queue_max_sectors(mddev->queue, mddev->chunk_sectors);
 	mddev->queue->queue_lock = &mddev->queue->__queue_lock;
+	/*
+	* in the case of assemble of an interrupted reshape,
+	* we remove temporarily any new disk from list.
+	*/
+	list_for_each_entry_safe(rdev1, rdev2, &mddev->disks, same_set) {
+		if (rdev1->raid_disk < 0) {
+			list_del(&rdev1->same_set);
+			list_add_tail(&rdev1->same_set, &new_disks);
+		}
+	}
+	conf = kzalloc(sizeof(*conf), GFP_KERNEL);
+	if (!conf)
+		goto abort;
+	mddev->private = conf;
 
-	ret = create_strip_zones(mddev);
-	if (ret < 0)
-		return ret;
-
+	if (create_strip_zones(conf, &mddev->disks,
+			mddev->chunk_sectors,  mddev->raid_disks))
+		goto abort;
+	ret  = -EINVAL;
+	if (calc_zones(mddev->private, &mddev->disks, mddev->raid_disks))
+		goto abort;
+	set_queues(&mddev->disks, mddev->queue);
+	mddev->queue->unplug_fn = raid0_unplug;
+	mddev->queue->backing_dev_info.congested_fn = raid0_congested;
+	mddev->queue->backing_dev_info.congested_data = mddev;
+	if (validate_chunk_alignment(mddev))
+		goto abort;
 	/* calculate array device size */
 	md_set_array_sectors(mddev, raid0_size(mddev, 0, 0));
 
 	printk(KERN_INFO "raid0 : md_size is %llu sectors.\n",
 		(unsigned long long)mddev->array_sectors);
-	/* calculate the max read-ahead size.
-	 * For read-ahead of large files to be effective, we need to
-	 * readahead at least twice a whole stripe. i.e. number of devices
-	 * multiplied by chunk size times 2.
-	 * If an individual device has an ra_pages greater than the
-	 * chunk size, then we will not drive that device as hard as it
-	 * wants.  We consider this a configuration error: a larger
-	 * chunksize should be used in that case.
-	 */
-	{
-		int stripe = mddev->raid_disks *
-			(mddev->chunk_sectors << 9) / PAGE_SIZE;
-		if (mddev->queue->backing_dev_info.ra_pages < 2* stripe)
-			mddev->queue->backing_dev_info.ra_pages = 2* stripe;
-	}
-
+	set_readahead(mddev);
 	blk_queue_merge_bvec(mddev->queue, raid0_mergeable_bvec);
 	print_conf(mddev->private, mddev->raid_disks, mdname(mddev));
+	list_splice(&new_disks, &mddev->disks);
 	return 0;
+abort:
+	{
+	raid0_conf_t *conf  = mddev->private;
+	kfree(conf->strip_zone);
+	kfree(conf->devlist);
+	kfree(conf);
+	}
+	list_splice(&new_disks, &mddev->disks);
+	return ret;
 }
 
 static int raid0_stop(mddev_t *mddev)



