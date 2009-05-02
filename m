From: raz ben yehuda <raziebe@013.net>
Subject: Subject: [001/002 ] raid0 reshape
Date: Sun, 03 May 2009 00:46:04 +0300
Message-ID: <1241300764.5607.36.camel@raz>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Hello
The bellow is the raid0 grow code.I have decided to fix raid0 and not 
perform the transformation raid0-raid4-raid0 due to two reasons:
1. raid0 zones. this patch support any zone transformations.
2. Undesired dependency of raid0 over raid4 re-striping code. 

The following tests were conducted:
1. various chunk sizes, 4K to 512K. ( mainly in 2.6.27 and 2.6.18 )
2. regrow ( tested on 2.6.27 and 2.6.18 )
3. various super blocks. 0.9 , 1, 1.1 and 1.2 ( mainly in 2.6.27 and 2.6.18 ).
4. support assembling and mounting older raid version ( older kernels and code before patch) after it was grown.

patch passed checkpatch.pl . other than reshaping code i beautified the code. 
Currently i about to pass this code to our testing team for further tests. 
Other things to do:
1. Speedup the reshape process.It is too slow.
2. Support for non power 2^n ( page size) chunks.

I will be thankful for your criticism.

Raz


 drivers/md/Kconfig |   13 
 drivers/md/md.c    |    6 
 drivers/md/raid0.c |  711 ++++++++++++++++++++++++++++++++++---------
 drivers/md/raid0.h |    5 
 4 files changed, 590 insertions(+), 145 deletions(-)

Signed-off-by:  Neil Brown <neilb@suse.de>
---
diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
index 36e0675..a9f0ff6 100644
--- a/drivers/md/Kconfig
+++ b/drivers/md/Kconfig
@@ -77,6 +77,19 @@ config MD_RAID0
 
 	  If unsure, say Y.
 
+config MD_RAID0_RESHAPE
+	bool "Support adding drives to a raid-0 array.(EXPERIMENTAL)"
+	depends on MD_RAID0 && EXPERIMENTAL
+	default n
+	---help---
+	  A RAID-0 set can be expanded by adding extra drives. This
+	  requires "restriping" .
+	  You will need mdadm version 2.4.x or later to use this.
+	  The mdadm usage is e.g.
+	       mdadm --grow /dev/md0 --raid-disks=6
+	  Note: The array can only be expanded.
+	  If unsure, say N.
+
 config MD_RAID1
 	tristate "RAID-1 (mirroring) mode"
 	depends on BLK_DEV_MD
diff --git a/drivers/md/md.c b/drivers/md/md.c
index ed5727c..82f57ea 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -5707,6 +5707,8 @@ static void status_resync(struct seq_file *seq, mddev_t * mddev)
 		max_blocks = mddev->resync_max_sectors >> 1;
 	else
 		max_blocks = mddev->dev_sectors / 2;
+	if (mddev->level == 0)
+		max_blocks = mddev->array_sectors>>1;
 
 	/*
 	 * Should not happen.
@@ -5915,7 +5917,7 @@ static int md_seq_show(struct seq_file *seq, void *v)
 		if (mddev->pers) {
 			mddev->pers->status(seq, mddev);
 	 		seq_printf(seq, "\n      ");
-			if (mddev->pers->sync_request) {
+			if (mddev->pers->sync_request || !mddev->level) {
 				if (mddev->curr_resync > 2) {
 					status_resync(seq, mddev);
 					seq_printf(seq, "\n      ");
@@ -6146,7 +6148,7 @@ int md_allow_write(mddev_t *mddev)
 		return 0;
 	if (mddev->ro)
 		return 0;
-	if (!mddev->pers->sync_request)
+	if (!mddev->pers->sync_request && mddev->level != 0)
 		return 0;
 
 	spin_lock_irq(&mddev->write_lock);
diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index c08d755..9e2b6de 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -18,11 +18,14 @@
    Software Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.  
 */
 
+#include <linux/kthread.h>
 #include <linux/blkdev.h>
 #include <linux/seq_file.h>
 #include "md.h"
 #include "raid0.h"
 
+static int raid0_create_reshape_thread(mddev_t *mddev);
+
 static void raid0_unplug(struct request_queue *q)
 {
 	mddev_t *mddev = q->queuedata;
@@ -53,27 +56,46 @@ static int raid0_congested(void *data, int bits)
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
+	printk(KERN_INFO "***** %s configuration ******\n\n",
+		mdname(mddev));
+	h = 0;
+	for (j = 0; j < conf->nr_strip_zones; j++) {
+		printk(KERN_INFO "zone%d", j);
+		if (conf->hash_table[h] == conf->strip_zone+j)
+			printk("(h%d)", h++);
+		printk(KERN_INFO "=[");
+		for (k = 0; k < conf->strip_zone[j].nb_dev; k++)
+			printk(KERN_INFO "%s/", bdevname(
+				conf->strip_zone[j].dev[k]->bdev, b));
+		printk(KERN_INFO "]\n\t zone offset=%llu device offset=%llu size=%llukb\n",
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
 			       bdevname(rdev1->bdev,b),
 			       (unsigned long long)rdev1->sectors);
@@ -103,78 +125,72 @@ static int create_strip_zones (mddev_t *mddev)
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
+
 
-	current_start = smallest->sectors;
-	curr_zone_start = zone->sectors;
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
 			printk(KERN_INFO "raid0: checking %s ...",
@@ -197,25 +213,33 @@ static int create_strip_zones (mddev_t *mddev)
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
+
+/* Now find appropriate hash spacing.
+ * We want a number which causes most hash entries to cover
+ * at most two strips, but the hash table must be at most
+ * 1 PAGE.  We choose the smallest strip, or contiguous collection
+ * of strips, that has big enough size.  We never consider the last
+ * strip though as it's size has no bearing on the efficacy of the hash
+ * table.
+ */
+static void raid0_find_hash_spacing(mddev_t *mddev)
+{
+	int i, j;
+	sector_t min_spacing;
+	raid0_conf_t *conf = mddev_to_conf(mddev);
+
+	conf->spacing = 0;
+	for (i = 0; i < conf->nr_strip_zones; i++)
+		conf->spacing += conf->strip_zone[i].sectors;
+	min_spacing = conf->spacing;
 	sector_div(min_spacing, PAGE_SIZE/sizeof(struct strip_zone*));
 	for (i=0; i < conf->nr_strip_zones-1; i++) {
 		sector_t s = 0;
@@ -225,16 +249,31 @@ static int create_strip_zones (mddev_t *mddev)
 		if (s >= min_spacing && s < conf->spacing)
 			conf->spacing = s;
 	}
+}
 
-	mddev->queue->unplug_fn = raid0_unplug;
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
+	raid0_find_hash_spacing(mddev);
+	mddev->queue->unplug_fn = raid0_unplug;
 	mddev->queue->backing_dev_info.congested_fn = raid0_congested;
 	mddev->queue->backing_dev_info.congested_data = mddev;
-
 	printk(KERN_INFO "raid0: done.\n");
 	return 0;
- abort:
-	return 1;
 }
 
 /**
@@ -265,79 +304,73 @@ static int raid0_mergeable_bvec(struct request_queue *q,
 
 static sector_t raid0_size(mddev_t *mddev, sector_t sectors, int raid_disks)
 {
-	sector_t array_sectors = 0;
+	int i;
 	mdk_rdev_t *rdev;
-
-	WARN_ONCE(sectors || raid_disks,
-		  "%s does not support generic reshape\n", __func__);
-
-	list_for_each_entry(rdev, &mddev->disks, same_set)
-		array_sectors += rdev->sectors;
-
+	sector_t array_sectors = 0;
+	raid0_conf_t *conf = mddev_to_conf(mddev);
+	mdk_rdev_t **devlist = conf->strip_zone[0].dev;
+	for (i = 0; i < mddev->raid_disks; i++) {
+		rdev = devlist[i];
+		if (test_bit(In_sync, &rdev->flags))
+			array_sectors += rdev->sectors;
+	}
 	return array_sectors;
 }
 
-static int raid0_run (mddev_t *mddev)
+static void raid0_set_queue_limits(mddev_t *mddev)
 {
-	unsigned  cur=0, i=0, nb_zone;
-	s64 sectors;
-	raid0_conf_t *conf;
+	mdk_rdev_t  *rdev;
 
-	if (mddev->chunk_size == 0) {
-		printk(KERN_ERR "md/raid0: non-zero chunk size required.\n");
-		return -EINVAL;
-	}
-	printk(KERN_INFO "%s: setting max_sectors to %d, segment boundary to %d\n",
-	       mdname(mddev),
-	       mddev->chunk_size >> 9,
-	       (mddev->chunk_size>>1)-1);
-	blk_queue_max_sectors(mddev->queue, mddev->chunk_size >> 9);
-	blk_queue_segment_boundary(mddev->queue, (mddev->chunk_size>>1) - 1);
-	mddev->queue->queue_lock = &mddev->queue->__queue_lock;
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
 
-	conf = kmalloc(sizeof (raid0_conf_t), GFP_KERNEL);
-	if (!conf)
-		goto out;
-	mddev->private = (void *)conf;
- 
-	conf->strip_zone = NULL;
-	conf->devlist = NULL;
-	if (create_strip_zones (mddev)) 
-		goto out_free_conf;
+	}
+}
 
-	/* calculate array device size */
-	md_set_array_sectors(mddev, raid0_size(mddev, 0, 0));
+static int raid0_set_array_hash(mddev_t *mddev)
+{
+	int nb_zone = 0;
+	sector_t space;
+	int round;
+	sector_t s , sectors;
+	int  cur = 0, i = 0;
+	raid0_conf_t *conf = mddev_to_conf(mddev);
 
 	printk(KERN_INFO "raid0 : md_size is %llu sectors.\n",
 		(unsigned long long)mddev->array_sectors);
 	printk(KERN_INFO "raid0 : conf->spacing is %llu sectors.\n",
 		(unsigned long long)conf->spacing);
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
+
+	s = raid0_size(mddev, 0, mddev->raid_disks);
+	space = conf->spacing;
+	conf->sector_shift = 0;
+	if (sizeof(sector_t) > sizeof(u32)) {
+		/*shift down space and s so that sector_div will work */
+		while (space > (sector_t) (~(u32)0)) {
+			s >>= 1;
+			space >>= 1;
+			s += 1; /* force round-up */
+			conf->sector_shift++;
 		}
-		round = sector_div(s, (u32)space) ? 1 : 0;
-		nb_zone = s + round;
 	}
+	round = sector_div(s, (u32)space) ? 1 : 0;
+	nb_zone = s + round;
 	printk(KERN_INFO "raid0 : nb_zone is %d.\n", nb_zone);
 
 	printk(KERN_INFO "raid0 : Allocating %zu bytes for hash.\n",
 				nb_zone*sizeof(struct strip_zone*));
 	conf->hash_table = kmalloc (sizeof (struct strip_zone *)*nb_zone, GFP_KERNEL);
 	if (!conf->hash_table)
-		goto out_free_conf;
+		return -1;
 	sectors = conf->strip_zone[cur].sectors;
-
 	conf->hash_table[0] = conf->strip_zone + cur;
 	for (i=1; i< nb_zone; i++) {
 		while (sectors <= conf->spacing) {
@@ -354,24 +387,59 @@ static int raid0_run (mddev_t *mddev)
 		 */
 		conf->spacing++;
 	}
+	return 0;
+}
 
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
 
+}
+
+static int raid0_run(mddev_t *mddev)
+{
+	raid0_conf_t *conf;
+	if (mddev->chunk_size == 0) {
+		printk(KERN_ERR "md/raid0: non-zero chunk size required.\n");
+		return -EINVAL;
+	}
+	printk(KERN_INFO "%s: setting max_sectors"
+			" to %d, segment boundary to %d\n",
+	       mdname(mddev),
+	       mddev->chunk_size >> 9,
+	       (mddev->chunk_size>>1)-1);
+	blk_queue_max_sectors(mddev->queue, mddev->chunk_size >> 9);
+	blk_queue_segment_boundary(mddev->queue, (mddev->chunk_size>>1) - 1);
+	mddev->queue->queue_lock = &mddev->queue->__queue_lock;
 
+	conf = kmalloc(sizeof(raid0_conf_t), GFP_KERNEL);
+	if (!conf)
+		goto out;
+	mddev->private = (void *)conf;
+	conf->strip_zone = NULL;
+	conf->devlist = NULL;
+	if (raid0_create_strip_zones(mddev, &mddev->disks))
+		goto out_free_conf;
+	/* calculate array device size */
+	md_set_array_sectors(mddev, raid0_size(mddev, 0, mddev->raid_disks));
+	raid0_set_array_hash(mddev);
+	raid0_set_queue_limits(mddev);
+	raid0_set_max_ra(mddev);
 	blk_queue_merge_bvec(mddev->queue, raid0_mergeable_bvec);
+	raid0_dump_zones(mddev);
+	raid0_create_reshape_thread(mddev);
+	init_completion(&conf->wait_reshape);
 	return 0;
 
 out_free_conf:
@@ -386,7 +454,10 @@ out:
 static int raid0_stop (mddev_t *mddev)
 {
 	raid0_conf_t *conf = mddev_to_conf(mddev);
-
+	if (mddev->thread) {
+		md_unregister_thread(mddev->thread);
+		mddev->thread = 0;
+	}
 	blk_sync_queue(mddev->queue); /* the unplug fn references 'conf'*/
 	kfree(conf->hash_table);
 	conf->hash_table = NULL;
@@ -414,7 +485,10 @@ static int raid0_make_request (struct request_queue *q, struct bio *bio)
 		bio_endio(bio, -EOPNOTSUPP);
 		return 0;
 	}
-
+	if (test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery)) {
+		bio_endio(bio, -EBUSY);
+		return 0;
+	}
 	cpu = part_stat_lock();
 	part_stat_inc(cpu, &mddev->gendisk->part0, ios[rw]);
 	part_stat_add(cpu, &mddev->gendisk->part0, sectors[rw],
@@ -513,6 +587,357 @@ static void raid0_status (struct seq_file *seq, mddev_t *mddev)
 	return;
 }
 
+#ifdef CONFIG_MD_RAID0_RESHAPE
+
+#define DEBUG 0
+#define r0_dprintk(x...) ((void)(DEBUG && printk(x)))
+
+static void raid0_reshape_endio(struct bio *bi, int error)
+{
+	struct completion* w = (struct completion *)bi->bi_private;
+	int uptodate = test_bit(BIO_UPTODATE, &bi->bi_flags);
+	r0_dprintk("raid0: endio: sec=%lld:size=%d "
+		"bvlen=%d bvoff=%d \n",
+			(unsigned long long)bi->bi_sector,
+			bi->bi_size,
+			bi->bi_io_vec[0].bv_len,
+			bi->bi_io_vec[0].bv_offset);
+	if (!error || uptodate)
+		return (void)complete(w);
+	printk("raid0: end reshape: io error sector=%llu\n",
+			(unsigned long long)bi->bi_sector);
+}
+
+static int raid0_reshape_rw(struct bio *bi, int dir, int size)
+{
+	char b[BDEVNAME_SIZE];
+	bi->bi_rw  	= dir;
+	bi->bi_size     = size;
+	bi->bi_idx      = 0;
+	r0_dprintk("%s %c %llu sec size=%d\n",
+			bdevname(bi->bi_bdev, b),
+			dir == 0 ? 'R' : 'W',
+			(unsigned long long)bi->bi_sector, bi->bi_size);
+	generic_make_request(bi);
+	wait_for_completion((struct completion *)(bi->bi_private));
+	return 0;
+}
+
+static struct strip_zone *raid0_point_to_zone(mddev_t *mddev,
+					sector_t sector)
+{
+	sector_t x;
+	struct strip_zone *zone;
+	raid0_conf_t *conf = mddev_to_conf(mddev);
+
+	x = sector >> conf->sector_shift;
+	sector_div(x, (u32)conf->spacing);
+	zone = conf->hash_table[x];
+	while (sector >= zone->zone_start + zone->sectors)
+		zone++;
+	return zone;
+}
+
+
+static int raid0_point_bio_to_disk(struct bio *bio, sector_t raid_sector,
+				mddev_t *mddev)
+{
+	int chunksect_bits;
+	mdk_rdev_t *tmp_dev;
+	sector_t x, chunk_sects, chunk, rsect;
+	sector_t sect_in_chunk;
+	struct strip_zone *zone;
+
+	chunk_sects = mddev->chunk_size >> 9;
+	chunksect_bits = ffz(~chunk_sects);
+
+	zone = raid0_point_to_zone(mddev, raid_sector);
+	sect_in_chunk = raid_sector & (chunk_sects - 1);
+	x = (raid_sector - zone->zone_start) >> chunksect_bits;
+	sector_div(x, zone->nb_dev);
+	chunk = x;
+	x = raid_sector >> chunksect_bits;
+	tmp_dev = zone->dev[sector_div(x, zone->nb_dev)];
+	rsect = (chunk << chunksect_bits) + zone->dev_start + sect_in_chunk;
+
+	bio->bi_bdev   = tmp_dev->bdev;
+	bio->bi_sector = rsect + tmp_dev->data_offset;
+	return 0;
+}
+
+
+static void raid0_take_speed(mddev_t *mddev, sector_t raid_sector)
+{
+	if ((jiffies-mddev->resync_mark) < 1000)
+		return;
+	mddev->resync_mark = jiffies;
+	mddev->resync_mark_cnt = raid_sector;
+}
+
+
+static sector_t raid0_reshape_move_blocks(mddev_t *mddev,
+					mddev_t *mddev_target,
+					struct strip_zone *zone)
+{
+	raid0_conf_t *conf 	= mddev_to_conf(mddev);
+	struct bio  *bi 	= conf->reshape_bi;
+	int io_size 		= bi->bi_size;
+	sector_t raid_sector    = zone->zone_start;
+	sector_t last_sector 	= (zone->zone_start + zone->sectors);
+	mddev->curr_mark_cnt    = io_size>>10;
+
+	while (raid_sector < last_sector && !kthread_should_stop()) {
+		raid0_take_speed(mddev, raid_sector);
+		if (raid0_point_bio_to_disk(bi, raid_sector, mddev)) {
+			printk(KERN_ERR "raid0:reshape point"
+					" read to bio failed\n");
+			break;
+		}
+		raid0_reshape_rw(bi, READ, io_size);
+		if (raid0_point_bio_to_disk(bi, raid_sector, mddev_target)) {
+			printk(KERN_ERR "raid0: point write to bio failed\n");
+			break;
+		}
+		raid0_reshape_rw(bi, WRITE, io_size);
+		raid_sector += io_size>>9;
+		mddev->curr_mark_cnt = raid_sector;
+		mddev->curr_resync = raid_sector;
+	}
+	bi->bi_size = io_size;
+	return raid_sector - zone->zone_start;
+}
+
+
+static void raid0_reshape_move_zones(mddev_t *mddev, mddev_t *mddev_target)
+{
+	raid0_conf_t *conf = mddev_to_conf(mddev);
+	sector_t raid_sector = 0;
+	int i = 0;
+	for (; i < conf->nr_strip_zones && !kthread_should_stop() ; i++)
+		raid_sector += raid0_reshape_move_blocks(mddev,
+						mddev_target,
+						&conf->strip_zone[i]);
+	if (raid_sector == mddev->array_sectors) {
+		printk(KERN_INFO "raid0: reshape ended %llu sectors moved OK\n",
+			(unsigned long long)raid_sector);
+	} else{
+		printk(KERN_INFO "raid0: reshape ended %llu sector moved BAD\n",
+			(unsigned long long)raid_sector);
+	}
+}
+
+
+static int raid0_reshape_prepare(mddev_t *mddev, mddev_t *mddev_target)
+{
+	raid0_conf_t *conf;
+	mddev_target->private = NULL;
+	conf = kzalloc(sizeof(raid0_conf_t), GFP_KERNEL);
+	if (!conf)
+		return -1;
+	mddev_target->private = (void *)conf;
+	conf->strip_zone = NULL;
+	conf->devlist = NULL;
+	if (raid0_create_strip_zones(mddev_target, &mddev->disks))
+		return -1;
+	return raid0_set_array_hash(mddev_target);
+}
+
+
+static	mddev_t *raid0_clone_mddev(mddev_t *mddev)
+{
+	void *m = kmalloc(sizeof(*mddev), GFP_NOIO);
+	if (!m)
+		return NULL;
+	memcpy(m, mddev, sizeof(*mddev));
+	return (mddev_t *)m;
+}
+
+static int raid0_reshape_iosize(mddev_t *mddev)
+{
+	int chunk_size_sectors = (mddev->chunk_size / PAGE_SIZE)*8;
+
+	if (mddev->queue->max_hw_sectors >= chunk_size_sectors)
+		return chunk_size_sectors;
+	if ((chunk_size_sectors % mddev->queue->max_hw_sectors) == 0)
+		return mddev->queue->max_hw_sectors;
+	return chunk_size_sectors /
+		((chunk_size_sectors / mddev->queue->max_hw_sectors)*2);
+}
+
+
+static mddev_t *raid0_reshape_init(mddev_t *mddev)
+{
+	int i;
+	mddev_t *mddev_target = NULL;
+	mdk_rdev_t *rdev = NULL;
+	int nraid_disks = 0;
+	struct bio *bi = NULL;
+	raid0_conf_t *conf = mddev_to_conf(mddev);
+	int pages = raid0_reshape_iosize(mddev)/8;
+	if (pages == 0) {
+		printk(KERN_INFO "raid0: failed to "
+				"determine transfer size\n");
+		return NULL;
+	}
+	printk("raid0: using transfer size %usectors\n", pages*8);
+	bi = bio_alloc(GFP_NOIO, pages);
+	if (!bi) {
+		printk(KERN_INFO "raid0:failed too alloc bio for"
+			" reshaping. rejecting\n");
+		goto RAID0_RESHAPE_INIT_EXIT_BAD;
+	}
+	mddev_target = raid0_clone_mddev(mddev);
+	bi->bi_vcnt = 0;
+	if (!mddev_target) {
+		printk(KERN_INFO "raid0: failed to clone mddev\n");
+		goto RAID0_RESHAPE_INIT_EXIT_BAD;
+	}
+	mddev->reshape_position = 0;
+	mddev->delta_disks = 0;
+	atomic_set(&mddev->recovery_active, 0);
+	nraid_disks = mddev->raid_disks;
+
+	list_for_each_entry(rdev, &mddev->disks, same_set) {
+		if (!test_bit(In_sync, &rdev->flags)) {
+			rdev->raid_disk = nraid_disks++;
+			rdev->desc_nr = rdev->raid_disk;
+			set_bit(In_sync, &rdev->flags);
+		}
+	}
+	mddev_target->raid_disks = nraid_disks;
+	if (raid0_reshape_prepare(mddev, mddev_target)) {
+		printk(KERN_INFO "raid0: failed to"
+			" setup temporary mappings\n");
+		goto RAID0_RESHAPE_INIT_EXIT_BAD;
+	}
+	bi->bi_vcnt = pages;
+	for (i = 0; i < bi->bi_vcnt; i++) {
+		bi->bi_io_vec[i].bv_len    = PAGE_SIZE;
+		bi->bi_io_vec[i].bv_offset = 0;
+		bi->bi_io_vec[i].bv_page   = alloc_page(GFP_NOIO);
+		get_page(bi->bi_io_vec[i].bv_page);
+	}
+	bi->bi_next    		   = NULL;
+	bi->bi_end_io 		   = raid0_reshape_endio;
+	bi->bi_size     	   = PAGE_SIZE * bi->bi_vcnt;
+	bi->bi_private  	   = &conf->wait_reshape;
+	bi->bi_idx  		   = 0;
+	conf->reshape_bi 	   = bi;
+	return mddev_target;
+
+RAID0_RESHAPE_INIT_EXIT_BAD:
+	kfree(mddev_target);
+	for (i = 0; i < bi->bi_vcnt; i++)
+		safe_put_page(bi->bi_io_vec[i].bv_page);
+	if (bi)
+		bio_put(bi);
+	return NULL;
+}
+
+
+static void raid0_reshape_thread(mddev_t *mddev)
+{
+	int i = 0;
+	mddev_t *mddev_target = 0;
+	raid0_conf_t *conf = mddev_to_conf(mddev);
+
+	if (!test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery))
+		return;
+	clear_bit(MD_RECOVERY_SYNC, &mddev->recovery);
+	clear_bit(MD_RECOVERY_RECOVER, &mddev->recovery);
+	mddev_target = raid0_reshape_init(mddev);
+	if (!mddev_target)
+		return;
+	raid0_reshape_move_zones(mddev, mddev_target);
+	if (kthread_should_stop())
+		goto RAID0_RELEASE_PSEUDO_RAID;
+	for (i = 0; i < conf->reshape_bi->bi_vcnt; i++)
+		safe_put_page(conf->reshape_bi->bi_io_vec[i].bv_page);
+	bio_put(conf->reshape_bi);
+	mddev->resync_mark = 0L;
+	mddev->resync_mark_cnt = 0L;
+	mddev->curr_resync = 0;
+	mddev->recovery_cp = MaxSector;
+	mddev->reshape_position = MaxSector;
+	mddev->raid_disks = mddev_target->raid_disks;
+	kfree(conf->hash_table);
+	kfree(conf);
+	mutex_lock(&mddev->reconfig_mutex);
+	raid0_run(mddev);
+RAID0_RELEASE_PSEUDO_RAID:
+	if (!mutex_is_locked(&mddev->reconfig_mutex))
+		mutex_lock(&mddev->reconfig_mutex);
+	mddev->in_sync = 1;
+	if (md_allow_write(mddev)) {
+		printk("raid0: did not write sb"
+				" critical error\n");
+	}
+	mutex_unlock(&mddev->reconfig_mutex);
+	clear_bit(MD_RECOVERY_RESHAPE, &mddev->recovery);
+	conf = mddev_target->private;
+	kfree(conf->hash_table);
+	kfree(conf->strip_zone);
+	kfree(conf->devlist);
+	kfree(mddev_target);
+}
+
+
+static int raid0_add_disk(mddev_t *mddev, mdk_rdev_t *rdev)
+{
+	mdk_rdev_t *rdev1;
+	if (rdev->sectors < (mddev->chunk_size>>11)) {
+		printk(KERN_INFO "raid0: device smaller than "
+			"chunk size %llusectors < %llusectors\n",
+				(unsigned long long)rdev->sectors,
+				((unsigned long long)mddev->chunk_size)>>10);
+		return -1;
+	}
+	if (rdev->bdev->bd_disk->queue->max_hw_sectors <
+				mddev->queue->max_hw_sectors) {
+		printk(KERN_INFO "raid0: device trasnfer"
+			" size %usectors is smaller than other"
+			"raid's components %usectors, rejecting ",
+			 rdev->bdev->bd_disk->queue->max_hw_sectors,
+			 mddev->queue->max_hw_sectors);
+		return -1;
+	}
+	list_for_each_entry(rdev1, &mddev->disks, same_set) {
+		if (rdev1 == rdev) {
+			clear_bit(In_sync, &rdev->flags);
+			return 0;
+		}
+	}
+	return -1;
+}
+
+
+static int raid0_create_reshape_thread(mddev_t *mddev)
+{
+	if (mddev->thread)
+		return 0;
+	mddev->thread = md_register_thread(
+			raid0_reshape_thread,
+				mddev, "%s_raid0");
+	if (!mddev->thread) {
+		printk(KERN_ERR
+			"raid0: couldn't allocate thread for %s\n",
+			mdname(mddev));
+		return -1;
+	}
+	mddev->recovery_cp = MaxSector;
+	return 0;
+}
+
+
+static int raid0_reshape(mddev_t *mddev)
+{
+	set_bit(MD_RECOVERY_RESHAPE, &mddev->recovery);
+	md_wakeup_thread(mddev->thread);
+	return 0;
+}
+
+#endif
+
 static struct mdk_personality raid0_personality=
 {
 	.name		= "raid0",
@@ -523,6 +948,10 @@ static struct mdk_personality raid0_personality=
 	.stop		= raid0_stop,
 	.status		= raid0_status,
 	.size		= raid0_size,
+#ifdef CONFIG_MD_RAID0_RESHAPE
+	.check_reshape	= raid0_reshape,
+	.hot_add_disk	= raid0_add_disk,
+#endif
 };
 
 static int __init raid0_init (void)
diff --git a/drivers/md/raid0.h b/drivers/md/raid0.h
index 824b12e..ff2dca9 100644
--- a/drivers/md/raid0.h
+++ b/drivers/md/raid0.h
@@ -14,9 +14,10 @@ struct raid0_private_data
 {
 	struct strip_zone **hash_table; /* Table of indexes into strip_zone */
 	struct strip_zone *strip_zone;
-	mdk_rdev_t **devlist; /* lists of rdevs, pointed to by strip_zone->dev */
+	mdk_rdev_t **devlist;/* lists of rdevs, pointed to by strip_zone->dev */
 	int nr_strip_zones;
-
+	struct bio *reshape_bi;
+	struct completion wait_reshape;
 	sector_t spacing;
 	int sector_shift; /* shift this before divide by spacing */
 };



