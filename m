From: raz ben yehuda <raziebe@gmail.com>
Subject: Subject:[PATCH 007:013]: raid0 , change map_sector arguements
Date: Wed, 17 Jun 2009 00:54:47 +0300
Message-ID: <1245189287.3478.106.camel@raz>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux raid <linux-raid@vger.kernel.org>, Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids

have map_sector get raid0_conf instead of mddev

 raid0.c |   20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

Signed-off-by: razb <raziebe@gmail.com>
---
diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index c3fd471..eaad2f9 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -441,13 +441,15 @@ static struct strip_zone *find_zone(struct raid0_private_data *conf,
  * remaps the bio to the target device. we separate two flows.
  * power 2 flow and a general flow for the sake of perfromance
 */
-static mdk_rdev_t *map_sector(mddev_t *mddev, struct strip_zone *zone,
-				sector_t sector, sector_t *sector_offset)
+static mdk_rdev_t *map_sector(raid0_conf_t *conf,
+				sector_t chunk_sects,
+				int raid_disks,
+				struct strip_zone *zone,
+				sector_t sector,
+				sector_t *sector_offset)
 {
 	unsigned int sect_in_chunk;
 	sector_t chunk;
-	raid0_conf_t *conf = mddev->private;
-	unsigned int chunk_sects = mddev->chunk_sectors;
 
 	if (is_power_of_2(chunk_sects)) {
 		int chunksect_bits = ffz(~chunk_sects);
@@ -469,7 +471,7 @@ static mdk_rdev_t *map_sector(mddev_t *mddev, struct strip_zone *zone,
 	*	+ the position in the chunk
 	*/
 	*sector_offset = (chunk * chunk_sects) + sect_in_chunk;
-	return conf->devlist[(zone - conf->strip_zone)*mddev->raid_disks
+	return conf->devlist[(zone - conf->strip_zone) * raid_disks
 			     + sector_div(sector, zone->nb_dev)];
 }
 
@@ -540,8 +542,12 @@ static int raid0_make_request(struct request_queue *q, struct bio *bio)
 	zone =  find_zone(mddev->private, &sector_offset);
 	if (!zone)
 		BUG();
-	tmp_dev = map_sector(mddev, zone, bio->bi_sector,
-			     &sector_offset);
+	tmp_dev = map_sector(mddev->private,
+				mddev->chunk_sectors,
+				mddev->raid_disks,
+				zone,
+				bio->bi_sector,
+				&sector_offset);
 	bio->bi_bdev = tmp_dev->bdev;
 	bio->bi_sector = sector_offset + zone->dev_start +
 		tmp_dev->data_offset;



