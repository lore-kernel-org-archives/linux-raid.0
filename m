From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 2/2] md: raid0: remove ->dev pointer from strip_zone
	structure
Date: Sat, 16 May 2009 21:57:31 +1000
Message-ID: <20090516115731.14596.16948.stgit@notabene.brown>
References: <20090516115726.14596.58766.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090516115726.14596.58766.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

If we treat conf->devlist more like a 2 dimensional array,
we can get the devlist for a particular zone simply by indexing
that array, so we don't need to store the pointers to subarrays
in strip_zone.  This makes strip_zone smaller and so (hopefully)
searches faster.

Signed-of-by: NeilBrown <neilb@suse.de>
---

 drivers/md/raid0.c |   21 +++++++++++----------
 drivers/md/raid0.h |    1 -
 2 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index 4b6c16a..afea606 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -27,7 +27,7 @@ static void raid0_unplug(struct request_queue *q)
 {
 	mddev_t *mddev = q->queuedata;
 	raid0_conf_t *conf = mddev_to_conf(mddev);
-	mdk_rdev_t **devlist = conf->strip_zone[0].dev;
+	mdk_rdev_t **devlist = conf->devlist;
 	int i;
 
 	for (i=0; i<mddev->raid_disks; i++) {
@@ -41,7 +41,7 @@ static int raid0_congested(void *data, int bits)
 {
 	mddev_t *mddev = data;
 	raid0_conf_t *conf = mddev_to_conf(mddev);
-	mdk_rdev_t **devlist = conf->strip_zone[0].dev;
+	mdk_rdev_t **devlist = conf->devlist;
 	int i, ret = 0;
 
 	for (i = 0; i < mddev->raid_disks && !ret ; i++) {
@@ -56,7 +56,7 @@ static int create_strip_zones(mddev_t *mddev)
 {
 	int i, c, j, err;
 	sector_t current_start, curr_zone_start, sectors;
-	mdk_rdev_t *smallest, *rdev1, *rdev2, *rdev;
+	mdk_rdev_t *smallest, *rdev1, *rdev2, *rdev, **dev;
 	struct strip_zone *zone;
 	int cnt;
 	char b[BDEVNAME_SIZE];
@@ -115,7 +115,7 @@ static int create_strip_zones(mddev_t *mddev)
 	zone = &conf->strip_zone[0];
 	cnt = 0;
 	smallest = NULL;
-	zone->dev = conf->devlist;
+	dev = conf->devlist;
 	err = -EINVAL;
 	list_for_each_entry(rdev1, &mddev->disks, same_set) {
 		int j = rdev1->raid_disk;
@@ -125,12 +125,12 @@ static int create_strip_zones(mddev_t *mddev)
 				"aborting!\n", j);
 			goto abort;
 		}
-		if (zone->dev[j]) {
+		if (dev[j]) {
 			printk(KERN_ERR "raid0: multiple devices for %d - "
 				"aborting!\n", j);
 			goto abort;
 		}
-		zone->dev[j] = rdev1;
+		dev[j] = rdev1;
 
 		blk_queue_stack_limits(mddev->queue,
 				       rdev1->bdev->bd_disk->queue);
@@ -162,7 +162,7 @@ static int create_strip_zones(mddev_t *mddev)
 	for (i = 1; i < conf->nr_strip_zones; i++)
 	{
 		zone = conf->strip_zone + i;
-		zone->dev = conf->strip_zone[i-1].dev + mddev->raid_disks;
+		dev = conf->devlist + i * mddev->raid_disks;
 
 		printk(KERN_INFO "raid0: zone %d\n", i);
 		zone->dev_start = current_start;
@@ -171,7 +171,7 @@ static int create_strip_zones(mddev_t *mddev)
 
 		for (j=0; j<cnt; j++) {
 			char b[BDEVNAME_SIZE];
-			rdev = conf->strip_zone[0].dev[j];
+			rdev = conf->devlist[j];
 			printk(KERN_INFO "raid0: checking %s ...",
 				bdevname(rdev->bdev, b));
 			if (rdev->sectors <= current_start) {
@@ -179,7 +179,7 @@ static int create_strip_zones(mddev_t *mddev)
 				continue;
 			}
 			printk(KERN_INFO " contained as device %d\n", c);
-			zone->dev[c] = rdev;
+			dev[c] = rdev;
 			c++;
 			if (!smallest || rdev->sectors < smallest->sectors) {
 				smallest = rdev;
@@ -385,7 +385,8 @@ static int raid0_make_request (struct request_queue *q, struct bio *bio)
 		chunk = x;
 
 		x = sector >> chunksect_bits;
-		tmp_dev = zone->dev[sector_div(x, zone->nb_dev)];
+		tmp_dev = conf->devlist[(zone - conf->strip_zone)*mddev->raid_disks
+					+ sector_div(x, zone->nb_dev)];
 	}
 	rsect = (chunk << chunksect_bits) + zone->dev_start + sect_in_chunk;
  
diff --git a/drivers/md/raid0.h b/drivers/md/raid0.h
index 124ba34..7b3605e 100644
--- a/drivers/md/raid0.h
+++ b/drivers/md/raid0.h
@@ -6,7 +6,6 @@ struct strip_zone
 	sector_t zone_end;	/* Start of the next zone (in sectors) */
 	sector_t dev_start;	/* Zone offset in real dev (in sectors) */
 	int nb_dev;		/* # of devices attached to the zone */
-	mdk_rdev_t **dev;	/* Devices attached to the zone */
 };
 
 struct raid0_private_data


