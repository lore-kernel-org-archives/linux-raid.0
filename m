From: raz ben yehuda <raziebe@gmail.com>
Subject: Subject [ raid0 PATCH 3/6] : Add support to chunk size of 4K*n
	instead of 4K*2^n
Date: Tue, 19 May 2009 02:05:04 +0300
Message-ID: <1242687904.21201.13.camel@raz>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux raid <linux-raid@vger.kernel.org>, Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids

Add support to chunk size of 4K*n instead of 4K*2^n
raid0.c |  205 ++++++++++++++++++++++++++++++++++++++++++++++++----------------
1 file changed, 156 insertions(+), 49 deletions(-)
Signed-off-by: raziebe@gmail.com
--
diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index 80ac685..dc2671f 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -23,6 +23,9 @@
 #include "md.h"
 #include "raid0.h"
 
+static int handle_split(struct request_queue *q,
+		unsigned int chunk_sects, struct bio *bio);
+
 static void raid0_unplug(struct request_queue *q)
 {
 	mddev_t *mddev = q->queuedata;
@@ -263,7 +266,12 @@ static int raid0_mergeable_bvec(struct request_queue *q,
 	unsigned int chunk_sectors = mddev->chunk_size >> 9;
 	unsigned int bio_sectors = bvm->bi_size >> 9;
 
-	max =  (chunk_sectors - ((sector & (chunk_sectors - 1)) + bio_sectors)) << 9;
+	if (is_power_of_2(mddev->chunk_size))
+		max =  (chunk_sectors - ((sector & (chunk_sectors-1))
+						+ bio_sectors)) << 9;
+	else
+		max =  (chunk_sectors - (sector_div(sector, chunk_sectors)
+						+ bio_sectors)) << 9;
 	if (max < 0) max = 0; /* bio_add cannot handle a negative return */
 	if (max <= biovec->bv_len && bio_sectors == 0)
 		return biovec->bv_len;
@@ -356,15 +364,114 @@ static struct strip_zone *find_zone(struct raid0_private_data *conf,
 	BUG();
 }
 
-static int raid0_make_request (struct request_queue *q, struct bio *bio)
+static void position_bio_pow2(mddev_t *mddev, struct bio *bio)
 {
-	mddev_t *mddev = q->queuedata;
-	unsigned int sect_in_chunk, chunksect_bits, chunk_sects;
+	sector_t sect_in_chunk;
+	mdk_rdev_t *tmp_dev;
+	unsigned int chunksect_bits;
+	sector_t chunk;
+	sector_t rsect;
+	sector_t x;
+
+	sector_t sector_offset = bio->bi_sector;
 	raid0_conf_t *conf = mddev->private;
-	struct strip_zone *zone;
+	unsigned int chunk_sects = mddev->chunk_size >> 9;
+	struct strip_zone *zone = find_zone(conf, &sector_offset);
+
+	chunksect_bits = ffz(~chunk_sects);
+	/* find the sector offset inside the chunk */
+	sect_in_chunk  = bio->bi_sector & (chunk_sects - 1);
+	/* chunk in zone */
+	x = sector_offset >> chunksect_bits;
+	/* quotient is the chunk in real device*/
+	sector_div(x, zone->nb_dev);
+	chunk  = x;
+	/*
+	* we treat the device list a two dimensional array.
+	* devices row + offset inside the devices row = real dev
+	*/
+	x = bio->bi_sector >> chunksect_bits;
+	tmp_dev = conf->devlist[(zone - conf->strip_zone)*mddev->raid_disks
+				+ sector_div(x, zone->nb_dev)];
+	/*
+	*  position the bio over the real device
+	*  real sector = chunk in device + starting of zone
+			+ the position in the chunk
+	*/
+	rsect = (chunk << chunksect_bits) + zone->dev_start + sect_in_chunk;
+	bio->bi_bdev = tmp_dev->bdev;
+	bio->bi_sector = rsect + tmp_dev->data_offset;
+}
+
+static void position_bio_notpow2(mddev_t *mddev, struct bio *bio)
+{
+	sector_t sect_in_chunk;
 	mdk_rdev_t *tmp_dev;
 	sector_t chunk;
-	sector_t sector, rsect, sector_offset;
+	sector_t rsect;
+	sector_t x;
+
+	raid0_conf_t *conf = mddev->private;
+	sector_t chunk_sects = mddev->chunk_size >> 9;
+	sector_t sector_offset = bio->bi_sector;
+	struct strip_zone *zone = find_zone(conf, &sector_offset);
+
+	/* find the sector offset inside the chunk */
+	x = bio->bi_sector;
+	sect_in_chunk = sector_div(x, chunk_sects);
+	/* find the chunk in the zone */
+	x = sector_offset;
+	sector_div(x, chunk_sects);
+	/* quotient is the chunk in the real device */
+	sector_div(x, zone->nb_dev);
+	chunk = x;
+	/* find the real device  */
+	x = bio->bi_sector;
+	sector_div(x, chunk_sects);
+	tmp_dev = conf->devlist[(zone - conf->strip_zone)*mddev->raid_disks
+				 + sector_div(x, zone->nb_dev)];
+	/*
+	*  position the bio over the real device
+	*  real sector = chunk in device + starting of zone
+		+ the position in the chunk
+	*/
+	rsect = (chunk * chunk_sects) + zone->dev_start + sect_in_chunk;
+	bio->bi_bdev = tmp_dev->bdev;
+	bio->bi_sector = rsect + tmp_dev->data_offset;
+}
+
+/*
+ * position the io to the real target device.
+ * for the sake of performance we maintain two flows, one for
+ * power2 chunk sizes and one non-power 2 chunk size.
+*/
+static void position_bio(mddev_t *mddev, struct bio *bio)
+{
+	if (is_power_of_2(mddev->chunk_size))
+		return (void)position_bio_pow2(mddev, bio);
+	position_bio_notpow2(mddev, bio);
+}
+
+/*
+ * Is io distribute over 1 or more chunks ?
+*/
+static inline int is_io_in_chunk_boundary(mddev_t *mddev,
+			unsigned int chunk_sects, struct bio *bio)
+{
+	if (is_power_of_2(mddev->chunk_size)) {
+		return !(chunk_sects < ((bio->bi_sector & (chunk_sects-1))
+					+ (bio->bi_size >> 9)));
+	} else{
+		sector_t sector = bio->bi_sector;
+		return !(chunk_sects < (sector_div(sector, chunk_sects)
+						+ (bio->bi_size >> 9)));
+	}
+}
+
+static int raid0_make_request(struct request_queue *q, struct bio *bio)
+{
+	mddev_t *mddev = q->queuedata;
+	unsigned int chunk_sects;
 	const int rw = bio_data_dir(bio);
 	int cpu;
 
@@ -380,59 +487,59 @@ static int raid0_make_request (struct request_queue *q, struct bio *bio)
 	part_stat_unlock();
 
 	chunk_sects = mddev->chunk_size >> 9;
-	chunksect_bits = ffz(~chunk_sects);
-	sector = bio->bi_sector;
-
-	if (unlikely(chunk_sects < (bio->bi_sector & (chunk_sects - 1)) + (bio->bi_size >> 9))) {
-		struct bio_pair *bp;
-		/* Sanity check -- queue functions should prevent this happening */
-		if (bio->bi_vcnt != 1 ||
-		    bio->bi_idx != 0)
-			goto bad_map;
-		/* This is a one page bio that upper layers
-		 * refuse to split for us, so we need to split it.
-		 */
-		bp = bio_split(bio, chunk_sects - (bio->bi_sector & (chunk_sects - 1)));
-		if (raid0_make_request(q, &bp->bio1))
-			generic_make_request(&bp->bio1);
-		if (raid0_make_request(q, &bp->bio2))
-			generic_make_request(&bp->bio2);
-
-		bio_pair_release(bp);
-		return 0;
+	if (is_io_in_chunk_boundary(mddev, chunk_sects, bio)) {
+		position_bio(mddev, bio);
+		/* let upper layer do the actual io */
+		return 1;
 	}
-	sector_offset = sector;
-	zone = find_zone(conf, &sector_offset);
-	sect_in_chunk = bio->bi_sector & (chunk_sects - 1);
-	{
-		sector_t x = sector_offset >> chunksect_bits;
-
-		sector_div(x, zone->nb_dev);
-		chunk = x;
-
-		x = sector >> chunksect_bits;
-		tmp_dev = conf->devlist[(zone - conf->strip_zone)*mddev->raid_disks
-					+ sector_div(x, zone->nb_dev)];
-	}
-	rsect = (chunk << chunksect_bits) + zone->dev_start + sect_in_chunk;
- 
-	bio->bi_bdev = tmp_dev->bdev;
-	bio->bi_sector = rsect + tmp_dev->data_offset;
-
 	/*
-	 * Let the main block layer submit the IO and resolve recursion:
-	 */
-	return 1;
+	* io splits over two chunks at least
+	*/
+	if (!handle_split(q, chunk_sects, bio))
+		/*
+		 * handle split already made the ios
+		 * report all ok and leave
+		 */
+		return 0;
 
-bad_map:
 	printk("raid0_make_request bug: can't convert block across chunks"
 		" or bigger than %dk %llu %d\n", chunk_sects / 2,
 		(unsigned long long)bio->bi_sector, bio->bi_size >> 10);
-
 	bio_io_error(bio);
 	return 0;
 }
 
+/*
+ *  This io should be splitted to two ios.We split it,bounce it up,
+  * and each io will return to raid within the chunk boundaries
+*/
+static int handle_split(struct request_queue *q,
+		unsigned int chunk_sects, struct bio *bio)
+{
+	sector_t sector = bio->bi_sector;
+	struct bio_pair *bp;
+	mddev_t *mddev = q->queuedata;
+	/* Sanity check -- queue functions should prevent this happening */
+	if (bio->bi_vcnt != 1 || bio->bi_idx != 0)
+			return 1;
+	/* This is a one page bio that upper layers
+	 * refuse to split for us, so we need to split it.
+	*/
+	if (likely(is_power_of_2(mddev->chunk_size)))
+		bp = bio_split(bio, chunk_sects - (bio->bi_sector &
+							 (chunk_sects-1)));
+	else
+		bp = bio_split(bio, chunk_sects -
+				sector_div(sector, chunk_sects));
+	if (raid0_make_request(q, &bp->bio1))
+		generic_make_request(&bp->bio1);
+	if (raid0_make_request(q, &bp->bio2))
+		generic_make_request(&bp->bio2);
+
+	bio_pair_release(bp);
+	return 0;
+}
+
 static void raid0_status(struct seq_file *seq, mddev_t *mddev)
 {
 #undef MD_DEBUG


