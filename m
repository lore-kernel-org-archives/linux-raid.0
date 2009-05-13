From: raz ben yehuda <raziebe@013.net>
Subject: Subject: [001/001 ] raid0 remove hashing, variable chunk size
Date: Wed, 13 May 2009 21:03:25 +0300
Message-ID: <1242237805.8753.6.camel@raz>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

1. Beautify raid0 code
2. Remove hashing 
3. Chunk size of 4K*n instead of 4K*2^n ( must apply a patch to mdadm ).
patch was tested with backward compatibility to 2.6.18. i did not test 32bit, i do have 
a 32bit compiler for 2.6.30-rc2.  
 md.c    |   24 ++-
 raid0.c |  428 ++++++++++++++++++++++++++++++----------------------------------
 raid0.h |    3 
 3 files changed, 221 insertions(+), 234 deletions(-)
Signed-of-By : Neil Brown neilb@suse.de
---
diff --git a/drivers/md/md.c b/drivers/md/md.c
index ed5727c..068e18d 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -444,8 +444,10 @@ static sector_t calc_num_sectors(mdk_rdev_t *rdev, unsigned chunk_size)
 {
 	sector_t num_sectors = rdev->sb_start;
 
-	if (chunk_size)
-		num_sectors &= ~((sector_t)chunk_size/512 - 1);
+	if (chunk_size) {
+		int chunk_sects = chunk_size>>9;
+		num_sectors = (num_sectors/chunk_sects)*chunk_sects;
+	}
 	return num_sectors;
 }
 
@@ -3512,7 +3514,7 @@ min_sync_store(mddev_t *mddev, const char *buf, size_t len)
 
 	/* Must be a multiple of chunk_size */
 	if (mddev->chunk_size) {
-		if (min & (sector_t)((mddev->chunk_size>>9)-1))
+		if (min % (sector_t)(mddev->chunk_size>>9))
 			return -EINVAL;
 	}
 	mddev->resync_min = min;
@@ -3549,7 +3551,7 @@ max_sync_store(mddev_t *mddev, const char *buf, size_t len)
 
 		/* Must be a multiple of chunk_size */
 		if (mddev->chunk_size) {
-			if (max & (sector_t)((mddev->chunk_size>>9)-1))
+			if (max % (sector_t)(mddev->chunk_size>>9))
 				return -EINVAL;
 		}
 		mddev->resync_max = max;
@@ -3992,12 +3994,20 @@ static int do_md_run(mddev_t * mddev)
 		}
 		/*
 		 * chunk-size has to be a power of 2
-		 */
-		if ( (1 << ffz(~chunk_size)) != chunk_size) {
+		*/
+		if ((1 << ffz(~chunk_size)) != chunk_size
+			&& mddev->level != 0) {
 			printk(KERN_ERR "chunk_size of %d not valid\n", chunk_size);
 			return -EINVAL;
 		}
-
+		/*
+		* raid0 chunk size has to divide by a page
+		*/
+		if (mddev->level == 0 && (chunk_size % 4096)) {
+			printk(KERN_ERR "chunk_size of %d not valid\n",
+					chunk_size);
+			return -EINVAL;
+		}
 		/* devices must have minimum size of one chunk */
 		list_for_each_entry(rdev, &mddev->disks, same_set) {
 			if (test_bit(Faulty, &rdev->flags))
diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index c08d755..990ec6c 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -53,32 +53,49 @@ static int raid0_congested(void *data, int bits)
 }
 

-static int create_strip_zones (mddev_t *mddev)
+static void raid0_dump_zones(mddev_t *mddev)
 {
-	int i, c, j;
-	sector_t current_start, curr_zone_start;
-	sector_t min_spacing;
+	int j, k, h;
+	char b[BDEVNAME_SIZE];
 	raid0_conf_t *conf = mddev_to_conf(mddev);
-	mdk_rdev_t *smallest, *rdev1, *rdev2, *rdev;
-	struct strip_zone *zone;
-	int cnt;
+	printk(KERN_INFO "***** %s configuration ******",
+		mdname(mddev));
+	h = 0;
+	for (j = 0; j < conf->nr_strip_zones; j++) {
+		printk("\nzone%d", j);
+		printk("=[");
+		for (k = 0; k < conf->strip_zone[j].nb_dev; k++)
+			printk("%s/", bdevname(
+				conf->strip_zone[j].dev[k]->bdev, b));
+		printk("]\n\t zone offset=%llu device offset=%llu size=%llukb\n",
+			(unsigned long long)conf->strip_zone[j].zone_start,
+			(unsigned long long)conf->strip_zone[j].dev_start,
+			(unsigned long long)conf->strip_zone[j].sectors>>1);
+	}
+	printk(KERN_INFO "**********************************\n\n");
+}
+
+
+static void raid0_count_zones(mddev_t *mddev, struct list_head *disks)
+{
+	int c = 0;
 	char b[BDEVNAME_SIZE];
- 
+	mdk_rdev_t  *rdev1, *rdev2;
+	raid0_conf_t *conf = mddev_to_conf(mddev);
 	/*
 	 * The number of 'same size groups'
 	 */
 	conf->nr_strip_zones = 0;
- 
-	list_for_each_entry(rdev1, &mddev->disks, same_set) {
+	list_for_each_entry(rdev1, disks, same_set) {
 		printk(KERN_INFO "raid0: looking at %s\n",
 			bdevname(rdev1->bdev,b));
 		c = 0;
-		list_for_each_entry(rdev2, &mddev->disks, same_set) {
+		list_for_each_entry(rdev2, disks, same_set) {
 			printk(KERN_INFO "raid0:   comparing %s(%llu)",
-			       bdevname(rdev1->bdev,b),
+			       bdevname(rdev1->bdev, b),
 			       (unsigned long long)rdev1->sectors);
-			printk(KERN_INFO " with %s(%llu)\n",
-			       bdevname(rdev2->bdev,b),
+			printk(KERN_INFO "with %s(%llu)\n",
+			       bdevname(rdev2->bdev, b),
 			       (unsigned long long)rdev2->sectors);
 			if (rdev2 == rdev1) {
 				printk(KERN_INFO "raid0:   END\n");
@@ -103,81 +120,75 @@ static int create_strip_zones (mddev_t *mddev)
 		}
 	}
 	printk(KERN_INFO "raid0: FINAL %d zones\n", conf->nr_strip_zones);
+}
 
-	conf->strip_zone = kzalloc(sizeof(struct strip_zone)*
-				conf->nr_strip_zones, GFP_KERNEL);
-	if (!conf->strip_zone)
-		return 1;
-	conf->devlist = kzalloc(sizeof(mdk_rdev_t*)*
-				conf->nr_strip_zones*mddev->raid_disks,
-				GFP_KERNEL);
-	if (!conf->devlist)
-		return 1;
 
-	/* The first zone must contain all devices, so here we check that
-	 * there is a proper alignment of slots to devices and find them all
-	 */
-	zone = &conf->strip_zone[0];
-	cnt = 0;
-	smallest = NULL;
-	zone->dev = conf->devlist;
-	list_for_each_entry(rdev1, &mddev->disks, same_set) {
-		int j = rdev1->raid_disk;
+/*
+ * The first zone must contain all devices, so here we check that
+ * there is a proper alignment of slots to devices and find them all
+ */
+static int raid0_create_first_zone(mddev_t *mddev, struct list_head *disks)
+{
+	mdk_rdev_t *smallest = NULL;
+	mdk_rdev_t  *rdev;
+	int cnt = 0;
+	raid0_conf_t *conf = mddev_to_conf(mddev);
+	struct strip_zone *zone0 = &conf->strip_zone[0];
 
+	zone0->dev = conf->devlist;
+	list_for_each_entry(rdev, disks, same_set) {
+		int j = rdev->raid_disk;
 		if (j < 0 || j >= mddev->raid_disks) {
 			printk(KERN_ERR "raid0: bad disk number %d - "
 				"aborting!\n", j);
-			goto abort;
+			return -1;
 		}
-		if (zone->dev[j]) {
+		if (zone0->dev[j]) {
 			printk(KERN_ERR "raid0: multiple devices for %d - "
 				"aborting!\n", j);
-			goto abort;
+			return -1;
 		}
-		zone->dev[j] = rdev1;
-
-		blk_queue_stack_limits(mddev->queue,
-				       rdev1->bdev->bd_disk->queue);
-		/* as we don't honour merge_bvec_fn, we must never risk
-		 * violating it, so limit ->max_sector to one PAGE, as
-		 * a one page request is never in violation.
-		 */
-
-		if (rdev1->bdev->bd_disk->queue->merge_bvec_fn &&
-		    mddev->queue->max_sectors > (PAGE_SIZE>>9))
-			blk_queue_max_sectors(mddev->queue, PAGE_SIZE>>9);
-
-		if (!smallest || (rdev1->sectors < smallest->sectors))
-			smallest = rdev1;
+		zone0->dev[j] = rdev;
+		if (!smallest || (rdev->sectors < smallest->sectors))
+			smallest = rdev;
 		cnt++;
 	}
 	if (cnt != mddev->raid_disks) {
 		printk(KERN_ERR "raid0: too few disks (%d of %d) - "
 			"aborting!\n", cnt, mddev->raid_disks);
-		goto abort;
+		return -1;
 	}
-	zone->nb_dev = cnt;
-	zone->sectors = smallest->sectors * cnt;
-	zone->zone_start = 0;
+	zone0->nb_dev = cnt;
+	zone0->sectors = smallest->sectors * cnt;
+	zone0->zone_start = 0;
+	return 0;
+}
+
 
-	current_start = smallest->sectors;
-	curr_zone_start = zone->sectors;
+
+static void raid0_set_higher_zones(mddev_t *mddev)
+{
+	int i, j, c;
+	mdk_rdev_t *rdev;
+	struct strip_zone *zone;
+	raid0_conf_t *conf = mddev_to_conf(mddev);
+	mdk_rdev_t *smallest;
+	sector_t current_start =
+		conf->strip_zone[0].sectors/conf->strip_zone[0].nb_dev;
+	sector_t curr_zone_start = conf->strip_zone[0].sectors;
 
 	/* now do the other zones */
-	for (i = 1; i < conf->nr_strip_zones; i++)
-	{
+	for (i = 1; i < conf->nr_strip_zones; i++) {
 		zone = conf->strip_zone + i;
 		zone->dev = conf->strip_zone[i-1].dev + mddev->raid_disks;
-
 		printk(KERN_INFO "raid0: zone %d\n", i);
 		zone->dev_start = current_start;
 		smallest = NULL;
 		c = 0;
-
-		for (j=0; j<cnt; j++) {
+		for (j = 0; j < conf->strip_zone[0].nb_dev; j++) {
 			char b[BDEVNAME_SIZE];
 			rdev = conf->strip_zone[0].dev[j];
-			printk(KERN_INFO "raid0: checking %s ...",
+			printk("raid0: checking %s ...",
 				bdevname(rdev->bdev, b));
 			if (rdev->sectors <= current_start) {
 				printk(KERN_INFO " nope.\n");
@@ -197,54 +208,38 @@ static int create_strip_zones (mddev_t *mddev)
 		zone->sectors = (smallest->sectors - current_start) * c;
 		printk(KERN_INFO "raid0: zone->nb_dev: %d, sectors: %llu\n",
 			zone->nb_dev, (unsigned long long)zone->sectors);
-
 		zone->zone_start = curr_zone_start;
 		curr_zone_start += zone->sectors;
-
 		current_start = smallest->sectors;
 		printk(KERN_INFO "raid0: current zone start: %llu\n",
 			(unsigned long long)current_start);
 	}
+}
 
-	/* Now find appropriate hash spacing.
-	 * We want a number which causes most hash entries to cover
-	 * at most two strips, but the hash table must be at most
-	 * 1 PAGE.  We choose the smallest strip, or contiguous collection
-	 * of strips, that has big enough size.  We never consider the last
-	 * strip though as it's size has no bearing on the efficacy of the hash
-	 * table.
-	 */
-	conf->spacing = curr_zone_start;
-	min_spacing = curr_zone_start;
-	sector_div(min_spacing, PAGE_SIZE/sizeof(struct strip_zone*));
-	for (i=0; i < conf->nr_strip_zones-1; i++) {
-		sector_t s = 0;
-		for (j = i; j < conf->nr_strip_zones - 1 &&
-				s < min_spacing; j++)
-			s += conf->strip_zone[j].sectors;
-		if (s >= min_spacing && s < conf->spacing)
-			conf->spacing = s;
-	}
+static int raid0_create_strip_zones(mddev_t *mddev, struct list_head *disks)
+{
+	raid0_conf_t *conf = mddev_to_conf(mddev);
 
+	raid0_count_zones(mddev, disks);
+	conf->strip_zone = kzalloc(sizeof(struct strip_zone)*
+				conf->nr_strip_zones, GFP_KERNEL);
+	if (!conf->strip_zone)
+		return 1;
+	conf->devlist = kzalloc(sizeof(mdk_rdev_t *)*
+				conf->nr_strip_zones*mddev->raid_disks,
+				GFP_KERNEL);
+	if (!conf->devlist)
+		return 1;
+	if (raid0_create_first_zone(mddev, disks))
+		return 1;
+	raid0_set_higher_zones(mddev);
 	mddev->queue->unplug_fn = raid0_unplug;
-
 	mddev->queue->backing_dev_info.congested_fn = raid0_congested;
 	mddev->queue->backing_dev_info.congested_data = mddev;
-
 	printk(KERN_INFO "raid0: done.\n");
 	return 0;
- abort:
-	return 1;
 }
 
-/**
- *	raid0_mergeable_bvec -- tell bio layer if a two requests can be merged
- *	@q: request queue
- *	@bvm: properties of new bio
- *	@biovec: the request that could be merged to it.
- *
- *	Return amount of bytes we can accept at this offset
- */
 static int raid0_mergeable_bvec(struct request_queue *q,
 				struct bvec_merge_data *bvm,
 				struct bio_vec *biovec)
@@ -254,124 +249,119 @@ static int raid0_mergeable_bvec(struct request_queue *q,
 	int max;
 	unsigned int chunk_sectors = mddev->chunk_size >> 9;
 	unsigned int bio_sectors = bvm->bi_size >> 9;
-
-	max =  (chunk_sectors - ((sector & (chunk_sectors - 1)) + bio_sectors)) << 9;
-	if (max < 0) max = 0; /* bio_add cannot handle a negative return */
+	max =  (chunk_sectors - ((sector % chunk_sectors) + bio_sectors)) << 9;
+	if (max < 0)
+		max = 0;/*  bio_add cannot handle a negative return */
 	if (max <= biovec->bv_len && bio_sectors == 0)
 		return biovec->bv_len;
 	else 
 		return max;
+	return 0;
 }
 
+
 static sector_t raid0_size(mddev_t *mddev, sector_t sectors, int raid_disks)
 {
-	sector_t array_sectors = 0;
+	int i;
 	mdk_rdev_t *rdev;
+	sector_t array_sectors = 0;
+	raid0_conf_t *conf = mddev_to_conf(mddev);
+	mdk_rdev_t **devlist = conf->strip_zone[0].dev;
+	for (i = 0; i < mddev->raid_disks; i++) {
+		rdev = devlist[i];
+		if (test_bit(In_sync, &rdev->flags))
+			array_sectors += rdev->sectors;
+	}
+	return array_sectors;
+}
 
-	WARN_ONCE(sectors || raid_disks,
-		  "%s does not support generic reshape\n", __func__);
+static void raid0_set_queue_limits(mddev_t *mddev)
+{
+	mdk_rdev_t  *rdev;
 
-	list_for_each_entry(rdev, &mddev->disks, same_set)
-		array_sectors += rdev->sectors;
+	list_for_each_entry(rdev, &mddev->disks, same_set) {
+		blk_queue_stack_limits(mddev->queue,
+			       rdev->bdev->bd_disk->queue);
+		/* as we don't honour merge_bvec_fn, we must never risk
+		 * violating it, so limit ->max_sector to one PAGE, as
+		 * a one page request is never in violation.
+		 */
+		if (rdev->bdev->bd_disk->queue->merge_bvec_fn &&
+		    mddev->queue->max_sectors > (PAGE_SIZE>>9))
+			blk_queue_max_sectors(mddev->queue, PAGE_SIZE>>9);
+	}
+	printk(KERN_INFO "raid0:%s queue limits: hardware"
+		" segments=%d physical segments=%d\n"
+		" max hardware sectors = %d max sectors %d\n",
+		mdname(mddev),
+		mddev->queue->max_hw_segments,
+		mddev->queue->max_phys_segments,
+		mddev->queue->max_hw_sectors,
+		mddev->queue->max_sectors);
+}
+
+/* calculate the max read-ahead size.
+ * For read-ahead of large files to be effective, we need to
+ * readahead at least twice a whole stripe. i.e. number of devices
+ * multiplied by chunk size times 2.
+ * If an individual device has an ra_pages greater than the
+ * chunk size, then we will not drive that device as hard as it
+ * wants.  We consider this a configuration error: a larger
+ * chunksize should be used in that case.
+ */
+static void raid0_set_max_ra(mddev_t *mddev)
+{
+	int stripe = mddev->raid_disks * mddev->chunk_size / PAGE_SIZE;
+	if (mddev->queue->backing_dev_info.ra_pages < 2*stripe)
+		mddev->queue->backing_dev_info.ra_pages = 2*stripe;
 
-	return array_sectors;
 }
 
-static int raid0_run (mddev_t *mddev)
+static int raid0_is_power2_chunk(mddev_t *mddev)
 {
-	unsigned  cur=0, i=0, nb_zone;
-	s64 sectors;
-	raid0_conf_t *conf;
+	if ((1 << ffz(~mddev->chunk_size)) == mddev->chunk_size)
+		return 1;
+	return 0;
+}
 
+static int raid0_run(mddev_t *mddev)
+{
+	raid0_conf_t *conf;
+	int segment_boundary;
 	if (mddev->chunk_size == 0) {
 		printk(KERN_ERR "md/raid0: non-zero chunk size required.\n");
 		return -EINVAL;
 	}
-	printk(KERN_INFO "%s: setting max_sectors to %d, segment boundary to %d\n",
+	blk_queue_max_sectors(mddev->queue, mddev->chunk_size>>9);
+	if (!raid0_is_power2_chunk(mddev)) {
+		printk(KERN_INFO "raid0: not power 2 chunk size\n");
+		segment_boundary = ~(ffz(~mddev->chunk_size))>>1;
+	} else{
+		printk(KERN_INFO "raid0: is power 2 chunk size\n");
+		segment_boundary = (mddev->chunk_size>>1)-1;
+	}
+	blk_queue_segment_boundary(mddev->queue, segment_boundary);
+	printk(KERN_INFO "%s: setting max_sectors"
+			" to %d, segment boundary to %d\n",
 	       mdname(mddev),
 	       mddev->chunk_size >> 9,
-	       (mddev->chunk_size>>1)-1);
-	blk_queue_max_sectors(mddev->queue, mddev->chunk_size >> 9);
-	blk_queue_segment_boundary(mddev->queue, (mddev->chunk_size>>1) - 1);
+	       segment_boundary);
 	mddev->queue->queue_lock = &mddev->queue->__queue_lock;
 
-	conf = kmalloc(sizeof (raid0_conf_t), GFP_KERNEL);
+	conf = kmalloc(sizeof(raid0_conf_t), GFP_KERNEL);
 	if (!conf)
 		goto out;
 	mddev->private = (void *)conf;
- 
 	conf->strip_zone = NULL;
 	conf->devlist = NULL;
-	if (create_strip_zones (mddev)) 
+	if (raid0_create_strip_zones(mddev, &mddev->disks))
 		goto out_free_conf;
-
 	/* calculate array device size */
-	md_set_array_sectors(mddev, raid0_size(mddev, 0, 0));
-
-	printk(KERN_INFO "raid0 : md_size is %llu sectors.\n",
-		(unsigned long long)mddev->array_sectors);
-	printk(KERN_INFO "raid0 : conf->spacing is %llu sectors.\n",
-		(unsigned long long)conf->spacing);
-	{
-		sector_t s = raid0_size(mddev, 0, 0);
-		sector_t space = conf->spacing;
-		int round;
-		conf->sector_shift = 0;
-		if (sizeof(sector_t) > sizeof(u32)) {
-			/*shift down space and s so that sector_div will work */
-			while (space > (sector_t) (~(u32)0)) {
-				s >>= 1;
-				space >>= 1;
-				s += 1; /* force round-up */
-				conf->sector_shift++;
-			}
-		}
-		round = sector_div(s, (u32)space) ? 1 : 0;
-		nb_zone = s + round;
-	}
-	printk(KERN_INFO "raid0 : nb_zone is %d.\n", nb_zone);
-
-	printk(KERN_INFO "raid0 : Allocating %zu bytes for hash.\n",
-				nb_zone*sizeof(struct strip_zone*));
-	conf->hash_table = kmalloc (sizeof (struct strip_zone *)*nb_zone, GFP_KERNEL);
-	if (!conf->hash_table)
-		goto out_free_conf;
-	sectors = conf->strip_zone[cur].sectors;
-
-	conf->hash_table[0] = conf->strip_zone + cur;
-	for (i=1; i< nb_zone; i++) {
-		while (sectors <= conf->spacing) {
-			cur++;
-			sectors += conf->strip_zone[cur].sectors;
-		}
-		sectors -= conf->spacing;
-		conf->hash_table[i] = conf->strip_zone + cur;
-	}
-	if (conf->sector_shift) {
-		conf->spacing >>= conf->sector_shift;
-		/* round spacing up so when we divide by it, we
-		 * err on the side of too-low, which is safest
-		 */
-		conf->spacing++;
-	}
-
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
-		int stripe = mddev->raid_disks * mddev->chunk_size / PAGE_SIZE;
-		if (mddev->queue->backing_dev_info.ra_pages < 2* stripe)
-			mddev->queue->backing_dev_info.ra_pages = 2* stripe;
-	}
-
-
+	md_set_array_sectors(mddev, raid0_size(mddev, 0, mddev->raid_disks));
+	raid0_set_queue_limits(mddev);
+	raid0_set_max_ra(mddev);
 	blk_queue_merge_bvec(mddev->queue, raid0_mergeable_bvec);
+	raid0_dump_zones(mddev);
 	return 0;
 
 out_free_conf:
@@ -388,8 +378,6 @@ static int raid0_stop (mddev_t *mddev)
 	raid0_conf_t *conf = mddev_to_conf(mddev);
 
 	blk_sync_queue(mddev->queue); /* the unplug fn references 'conf'*/
-	kfree(conf->hash_table);
-	conf->hash_table = NULL;
 	kfree(conf->strip_zone);
 	conf->strip_zone = NULL;
 	kfree(conf);
@@ -398,15 +386,36 @@ static int raid0_stop (mddev_t *mddev)
 	return 0;
 }
 
+
+static void raid0_position_bio(mddev_t *mddev, struct bio *bio, sector_t sector)
+{
+	sector_t sect_in_chunk;
+	mdk_rdev_t *tmp_dev;
+	sector_t chunk_in_dev;
+	sector_t rsect;
+	sector_t x;
+	raid0_conf_t *conf = mddev_to_conf(mddev);
+	sector_t chunk_sects = mddev->chunk_size >> 9;
+	struct strip_zone *zone = &conf->strip_zone[0];
+
+	while (sector >= zone->zone_start + zone->sectors)
+		zone++;
+	sect_in_chunk = sector % chunk_sects;
+	x = (sector - zone->zone_start) / chunk_sects;
+	sector_div(x, zone->nb_dev);
+	chunk_in_dev = x;
+	x = sector / chunk_sects;
+	tmp_dev = zone->dev[sector_div(x, zone->nb_dev)];
+	rsect = (chunk_in_dev * chunk_sects) + zone->dev_start + sect_in_chunk;
+	bio->bi_bdev = tmp_dev->bdev;
+	bio->bi_sector = rsect + tmp_dev->data_offset;
+}
+
+
 static int raid0_make_request (struct request_queue *q, struct bio *bio)
 {
 	mddev_t *mddev = q->queuedata;
-	unsigned int sect_in_chunk, chunksect_bits, chunk_sects;
-	raid0_conf_t *conf = mddev_to_conf(mddev);
-	struct strip_zone *zone;
-	mdk_rdev_t *tmp_dev;
-	sector_t chunk;
-	sector_t sector, rsect;
+	unsigned int chunk_sects = mddev->chunk_size >> 9;
 	const int rw = bio_data_dir(bio);
 	int cpu;
 
@@ -414,18 +423,14 @@ static int raid0_make_request (struct request_queue *q, struct bio *bio)
 		bio_endio(bio, -EOPNOTSUPP);
 		return 0;
 	}
-
 	cpu = part_stat_lock();
 	part_stat_inc(cpu, &mddev->gendisk->part0, ios[rw]);
 	part_stat_add(cpu, &mddev->gendisk->part0, sectors[rw],
 		      bio_sectors(bio));
 	part_stat_unlock();
 
-	chunk_sects = mddev->chunk_size >> 9;
-	chunksect_bits = ffz(~chunk_sects);
-	sector = bio->bi_sector;
-
-	if (unlikely(chunk_sects < (bio->bi_sector & (chunk_sects - 1)) + (bio->bi_size >> 9))) {
+	if (unlikely(chunk_sects < ((bio->bi_sector % chunk_sects)
+			+ (bio->bi_size >> 9)))) {
 		struct bio_pair *bp;
 		/* Sanity check -- queue functions should prevent this happening */
 		if (bio->bi_vcnt != 1 ||
@@ -434,7 +439,8 @@ static int raid0_make_request (struct request_queue *q, struct bio *bio)
 		/* This is a one page bio that upper layers
 		 * refuse to split for us, so we need to split it.
 		 */
-		bp = bio_split(bio, chunk_sects - (bio->bi_sector & (chunk_sects - 1)));
+		bp = bio_split(bio, chunk_sects -
+					(bio->bi_sector % chunk_sects));
 		if (raid0_make_request(q, &bp->bio1))
 			generic_make_request(&bp->bio1);
 		if (raid0_make_request(q, &bp->bio2))
@@ -443,34 +449,7 @@ static int raid0_make_request (struct request_queue *q, struct bio *bio)
 		bio_pair_release(bp);
 		return 0;
 	}
- 
-
-	{
-		sector_t x = sector >> conf->sector_shift;
-		sector_div(x, (u32)conf->spacing);
-		zone = conf->hash_table[x];
-	}
-
-	while (sector >= zone->zone_start + zone->sectors)
-		zone++;
-
-	sect_in_chunk = bio->bi_sector & (chunk_sects - 1);
-
-
-	{
-		sector_t x = (sector - zone->zone_start) >> chunksect_bits;
-
-		sector_div(x, zone->nb_dev);
-		chunk = x;
-
-		x = sector >> chunksect_bits;
-		tmp_dev = zone->dev[sector_div(x, zone->nb_dev)];
-	}
-	rsect = (chunk << chunksect_bits) + zone->dev_start + sect_in_chunk;
- 
-	bio->bi_bdev = tmp_dev->bdev;
-	bio->bi_sector = rsect + tmp_dev->data_offset;
-
+	raid0_position_bio(mddev, bio, bio->bi_sector);
 	/*
 	 * Let the main block layer submit the IO and resolve recursion:
 	 */
@@ -485,6 +464,7 @@ bad_map:
 	return 0;
 }
 
+
 static void raid0_status (struct seq_file *seq, mddev_t *mddev)
 {
 #undef MD_DEBUG
diff --git a/drivers/md/raid0.h b/drivers/md/raid0.h
index 824b12e..2a73f94 100644
--- a/drivers/md/raid0.h
+++ b/drivers/md/raid0.h
@@ -16,9 +16,6 @@ struct raid0_private_data
 	struct strip_zone *strip_zone;
 	mdk_rdev_t **devlist; /* lists of rdevs, pointed to by strip_zone->dev */
 	int nr_strip_zones;
-
-	sector_t spacing;
-	int sector_shift; /* shift this before divide by spacing */
 };
 
 typedef struct raid0_private_data raid0_conf_t;



