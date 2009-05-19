From: raz ben yehuda <raziebe@gmail.com>
Subject: Subject: [PATCH 003/009]: raid0 :Enables chunk size other than 4K.
Date: Tue, 19 May 2009 19:07:07 +0300
Message-ID: <1242749227.3293.63.camel@raz>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de, linux raid <linux-raid@vger.kernel.org>
Cc: ofer <ofer@bitband.com>, yaron <yaronp@bitband.com>
List-Id: linux-raid.ids

	Enables chunk size other than 4K.
2. Maintain two flows, one for pow2 chunk sizes and a flow for the general case.
   This is for the sake of performance.
3. in make_request move the splliting code after the likely code. It is
   possible for the compiler to neglect ( gcc .. -Os.. see What 
   programmer should know about memory,urlich dreper, page 57)
4. add a memeory allocation check after the bio_split.
5. inroduce map_sector as the remapping of the bio in the common case.
6. fix blk_mergeable to support the two flows.
 raid0.c |  163 +++++++++++++++++++++++++++++++++++++++++++++-------------------
 1 file changed, 116 insertions(+), 47 deletions(-)

Signed-off-by: raziebe@gmail.com
diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index 0a6d0fa..a994169 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -23,6 +23,7 @@
 #include "md.h"
 #include "raid0.h"
 
+
 static void raid0_unplug(struct request_queue *q)
 {
 	mddev_t *mddev = q->queuedata;
@@ -265,7 +266,12 @@ static int raid0_mergeable_bvec(struct request_queue *q,
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
@@ -358,15 +364,73 @@ static struct strip_zone *find_zone(struct raid0_private_data *conf,
 	BUG();
 }
 
-static int raid0_make_request (struct request_queue *q, struct bio *bio)
+/*
+ * remaps the bio to the target device. we separate two flows.
+ * power 2 flow and a general flow for the sake of perfromance
+*/
+static mdk_rdev_t *map_sector(mddev_t *mddev, struct strip_zone *zone,
+				sector_t sector, sector_t *sector_offset)
 {
-	mddev_t *mddev = q->queuedata;
-	unsigned int sect_in_chunk, chunksect_bits, chunk_sects;
-	raid0_conf_t *conf = mddev->private;
-	struct strip_zone *zone;
-	mdk_rdev_t *tmp_dev;
+	sector_t sect_in_chunk;
 	sector_t chunk;
-	sector_t sector, rsect, sector_offset;
+	sector_t x;
+	raid0_conf_t *conf = mddev->private;
+	sector_t chunk_sects = mddev->chunk_size >> 9;
+
+	if (is_power_of_2(mddev->chunk_size)) {
+		int chunksect_bits = ffz(~chunk_sects);
+		/* find the sector offset inside the chunk */
+		sect_in_chunk  = sector & (chunk_sects - 1);
+		/* chunk in zone */
+		x = *sector_offset >> chunksect_bits;
+		/* quotient is the chunk in real device*/
+		sector_div(x, zone->nb_dev);
+		chunk  = x;
+		/*
+		* we treat the device list a two dimensional array.
+		* devices row + offset inside the devices row = real dev
+		*/
+		x = sector >> chunksect_bits;
+	} else{
+		x = sector;
+		sect_in_chunk = sector_div(x, chunk_sects);
+		x = *sector_offset;
+		sector_div(x, chunk_sects);
+		sector_div(x, zone->nb_dev);
+		chunk = x;
+		x = sector;
+		sector_div(x, chunk_sects);
+	}
+	/*
+	*  position the bio over the real device
+	*  real sector = chunk in device + starting of zone
+	*	+ the position in the chunk
+	*/
+	*sector_offset = (chunk * chunk_sects) + sect_in_chunk;
+	return conf->devlist[(zone - conf->strip_zone)*mddev->raid_disks
+					 + sector_div(x, zone->nb_dev)];
+}
+
+/*
+ * Is io distribute over 1 or more chunks ?
+*/
+static inline int is_io_in_chunk_boundary(mddev_t *mddev,
+			unsigned int chunk_sects, struct bio *bio)
+{
+	if (likely(is_power_of_2(mddev->chunk_size))) {
+		return chunk_sects >= ((bio->bi_sector & (chunk_sects-1))
+					+ (bio->bi_size >> 9));
+	} else{
+		sector_t sector = bio->bi_sector;
+		return chunk_sects >= (sector_div(sector, chunk_sects)
+						+ (bio->bi_size >> 9));
+	}
+}
+
+static int raid0_make_request(struct request_queue *q, struct bio *bio)
+{
+	mddev_t *mddev = q->queuedata;
+	unsigned int chunk_sects;
 	const int rw = bio_data_dir(bio);
 	int cpu;
 
@@ -382,55 +446,60 @@ static int raid0_make_request (struct request_queue *q, struct bio *bio)
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
+	if (likely(is_io_in_chunk_boundary(mddev, chunk_sects, bio))) {
+		mdk_rdev_t *tmp_dev;
+		sector_t sector_offset = bio->bi_sector;
+		struct strip_zone *zone =  find_zone(mddev->private,
+							&sector_offset);
+		tmp_dev = map_sector(mddev, zone, bio->bi_sector,
+					&sector_offset);
+		bio->bi_bdev = tmp_dev->bdev;
+		bio->bi_sector = sector_offset + zone->dev_start +
+					tmp_dev->data_offset;
+		/* let upper layer do the actual io */
+		return 1;
 	}
-	sector_offset = sector;
-	zone = find_zone(conf, &sector_offset);
-	sect_in_chunk = bio->bi_sector & (chunk_sects - 1);
 	{
-		sector_t x = sector_offset >> chunksect_bits;
-
-		sector_div(x, zone->nb_dev);
-		chunk = x;
-
-		x = sector >> chunksect_bits;
-		tmp_dev = conf->devlist[(zone - conf->strip_zone)*mddev->raid_disks
-					+ sector_div(x, zone->nb_dev)];
+	/*
+	* the bio splits over two chunks at least
+	*/
+	sector_t sector = bio->bi_sector;
+	struct bio_pair *bp;
+	mddev_t *mddev = q->queuedata;
+	/* Sanity check -- queue functions should prevent this happening */
+	if (bio->bi_vcnt != 1 || bio->bi_idx != 0)
+		goto bad_map;
+	/* This is a one page bio that upper layers
+	 * refuse to split for us, so we need to split it.
+	*/
+	if (likely(is_power_of_2(mddev->chunk_size)))
+		bp = bio_split(bio, chunk_sects - (bio->bi_sector &
+							 (chunk_sects-1)));
+	else
+		bp = bio_split(bio, chunk_sects -
+				sector_div(sector, chunk_sects));
+	if (!bp) {
+		printk(KERN_ERR "%s: Critical error,failed to "
+					"split bio\n", mdname(mddev));
+		goto bad_map;
 	}
-	rsect = (chunk << chunksect_bits) + zone->dev_start + sect_in_chunk;
- 
-	bio->bi_bdev = tmp_dev->bdev;
-	bio->bi_sector = rsect + tmp_dev->data_offset;
+	if (raid0_make_request(q, &bp->bio1))
+		generic_make_request(&bp->bio1);
+	if (raid0_make_request(q, &bp->bio2))
+		generic_make_request(&bp->bio2);
 
+	bio_pair_release(bp);
 	/*
-	 * Let the main block layer submit the IO and resolve recursion:
+	 * handle split already made the ios
+	 * report all ok and leave
 	 */
-	return 1;
+	return 0;
+	}
 
-bad_map:
 	printk("raid0_make_request bug: can't convert block across chunks"
 		" or bigger than %dk %llu %d\n", chunk_sects / 2,
 		(unsigned long long)bio->bi_sector, bio->bi_size >> 10);
-
+bad_map:
 	bio_io_error(bio);
 	return 0;
 }


