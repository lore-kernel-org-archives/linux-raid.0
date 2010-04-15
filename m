From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 05/28] md: don't use mddev->raid_disks in raid0 or raid10
	while array is active.
Date: Thu, 15 Apr 2010 16:21:07 +1000
Message-ID: <20100415062107.5126.5497.stgit@notabene.brown>
References: <20100415061516.5126.53068.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100415061516.5126.53068.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

In a subsequent patch we will make it possible to change
mddev->raid_disks while a RAID0 or RAID10 array is active.  This is
part of the process of reshaping such an array.

This means that we cannot use this value while processes requests
(it is OK to use it during initialisation as we are locked against
changes then).
Both RAID0 and RAID10 have the same value stored in the private data
structure, so use that value instead.

Signed-off-by: NeilBrown <neilb@suse.de>
---
 drivers/md/raid0.c  |   15 ++++++++++-----
 drivers/md/raid10.c |   16 ++++++++--------
 2 files changed, 18 insertions(+), 13 deletions(-)

diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index 377cf2a..c2e0d1d 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -28,9 +28,10 @@ static void raid0_unplug(struct request_queue *q)
 	mddev_t *mddev = q->queuedata;
 	raid0_conf_t *conf = mddev->private;
 	mdk_rdev_t **devlist = conf->devlist;
+	int raid_disks = conf->strip_zone[0].nb_dev;
 	int i;
 
-	for (i=0; i<mddev->raid_disks; i++) {
+	for (i=0; i < raid_disks; i++) {
 		struct request_queue *r_queue = bdev_get_queue(devlist[i]->bdev);
 
 		blk_unplug(r_queue);
@@ -42,12 +43,13 @@ static int raid0_congested(void *data, int bits)
 	mddev_t *mddev = data;
 	raid0_conf_t *conf = mddev->private;
 	mdk_rdev_t **devlist = conf->devlist;
+	int raid_disks = conf->strip_zone[0].nb_dev;
 	int i, ret = 0;
 
 	if (mddev_congested(mddev, bits))
 		return 1;
 
-	for (i = 0; i < mddev->raid_disks && !ret ; i++) {
+	for (i = 0; i < raid_disks && !ret ; i++) {
 		struct request_queue *q = bdev_get_queue(devlist[i]->bdev);
 
 		ret |= bdi_congested(&q->backing_dev_info, bits);
@@ -65,6 +67,7 @@ static void dump_zones(mddev_t *mddev)
 	sector_t zone_start = 0;
 	char b[BDEVNAME_SIZE];
 	raid0_conf_t *conf = mddev->private;
+	int raid_disks = conf->strip_zone[0].nb_dev;
 	printk(KERN_INFO "******* %s configuration *********\n",
 		mdname(mddev));
 	h = 0;
@@ -72,7 +75,7 @@ static void dump_zones(mddev_t *mddev)
 		printk(KERN_INFO "zone%d=[", j);
 		for (k = 0; k < conf->strip_zone[j].nb_dev; k++)
 			printk("%s/",
-			bdevname(conf->devlist[j*mddev->raid_disks
+			bdevname(conf->devlist[j*raid_disks
 						+ k]->bdev, b));
 		printk("]\n");
 
@@ -401,6 +404,7 @@ static mdk_rdev_t *map_sector(mddev_t *mddev, struct strip_zone *zone,
 	unsigned int sect_in_chunk;
 	sector_t chunk;
 	raid0_conf_t *conf = mddev->private;
+	int raid_disks = conf->strip_zone[0].nb_dev;
 	unsigned int chunk_sects = mddev->chunk_sectors;
 
 	if (is_power_of_2(chunk_sects)) {
@@ -423,7 +427,7 @@ static mdk_rdev_t *map_sector(mddev_t *mddev, struct strip_zone *zone,
 	*	+ the position in the chunk
 	*/
 	*sector_offset = (chunk * chunk_sects) + sect_in_chunk;
-	return conf->devlist[(zone - conf->strip_zone)*mddev->raid_disks
+	return conf->devlist[(zone - conf->strip_zone)*raid_disks
 			     + sector_div(sector, zone->nb_dev)];
 }
 
@@ -518,6 +522,7 @@ static void raid0_status(struct seq_file *seq, mddev_t *mddev)
 	int j, k, h;
 	char b[BDEVNAME_SIZE];
 	raid0_conf_t *conf = mddev->private;
+	int raid_disks = conf->strip_zone[0].nb_dev;
 
 	sector_t zone_size;
 	sector_t zone_start = 0;
@@ -528,7 +533,7 @@ static void raid0_status(struct seq_file *seq, mddev_t *mddev)
 		seq_printf(seq, "=[");
 		for (k = 0; k < conf->strip_zone[j].nb_dev; k++)
 			seq_printf(seq, "%s/", bdevname(
-				conf->devlist[j*mddev->raid_disks + k]
+				conf->devlist[j*raid_disks + k]
 						->bdev, b));
 
 		zone_size  = conf->strip_zone[j].zone_end - zone_start;
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index b90fef6..044c115 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -600,7 +600,7 @@ static void unplug_slaves(mddev_t *mddev)
 	int i;
 
 	rcu_read_lock();
-	for (i=0; i<mddev->raid_disks; i++) {
+	for (i=0; i < conf->raid_disks; i++) {
 		mdk_rdev_t *rdev = rcu_dereference(conf->mirrors[i].rdev);
 		if (rdev && !test_bit(Faulty, &rdev->flags) && atomic_read(&rdev->nr_pending)) {
 			struct request_queue *r_queue = bdev_get_queue(rdev->bdev);
@@ -634,7 +634,7 @@ static int raid10_congested(void *data, int bits)
 	if (mddev_congested(mddev, bits))
 		return 1;
 	rcu_read_lock();
-	for (i = 0; i < mddev->raid_disks && ret == 0; i++) {
+	for (i = 0; i < conf->raid_disks && ret == 0; i++) {
 		mdk_rdev_t *rdev = rcu_dereference(conf->mirrors[i].rdev);
 		if (rdev && !test_bit(Faulty, &rdev->flags)) {
 			struct request_queue *q = bdev_get_queue(rdev->bdev);
@@ -1131,7 +1131,7 @@ static int raid10_add_disk(mddev_t *mddev, mdk_rdev_t *rdev)
 	int mirror;
 	mirror_info_t *p;
 	int first = 0;
-	int last = mddev->raid_disks - 1;
+	int last = conf->raid_disks - 1;
 
 	if (mddev->recovery_cp < MaxSector)
 		/* only hot-add to in-sync arrays, as recovery is
@@ -2139,7 +2139,7 @@ raid10_size(mddev_t *mddev, sector_t sectors, int raid_disks)
 	conf_t *conf = mddev->private;
 
 	if (!raid_disks)
-		raid_disks = mddev->raid_disks;
+		raid_disks = conf->raid_disks;
 	if (!sectors)
 		sectors = mddev->dev_sectors;
 
@@ -2250,7 +2250,7 @@ static int run(mddev_t *mddev)
 
 	list_for_each_entry(rdev, &mddev->disks, same_set) {
 		disk_idx = rdev->raid_disk;
-		if (disk_idx >= mddev->raid_disks
+		if (disk_idx >= conf->raid_disks
 		    || disk_idx < 0)
 			continue;
 		disk = conf->mirrors + disk_idx;
@@ -2311,8 +2311,8 @@ static int run(mddev_t *mddev)
 		       mdname(mddev));
 	printk(KERN_INFO
 		"raid10: raid set %s active with %d out of %d devices\n",
-		mdname(mddev), mddev->raid_disks - mddev->degraded,
-		mddev->raid_disks);
+		mdname(mddev), conf->raid_disks - mddev->degraded,
+		conf->raid_disks);
 	/*
 	 * Ok, everything is just fine now
 	 */
@@ -2335,7 +2335,7 @@ static int run(mddev_t *mddev)
 			mddev->queue->backing_dev_info.ra_pages = 2* stripe;
 	}
 
-	if (conf->near_copies < mddev->raid_disks)
+	if (conf->near_copies < conf->raid_disks)
 		blk_queue_merge_bvec(mddev->queue, raid10_mergeable_bvec);
 	md_integrity_register(mddev);
 	return 0;


