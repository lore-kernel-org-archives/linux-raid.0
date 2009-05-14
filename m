From: raz ben yehuda <raziebe@gmail.com>
Subject: PATCH md [001:002]: raid0: fix chunk size to 4K*n granularity
Date: Thu, 14 May 2009 18:58:23 +0300
Message-ID: <1242316703.11444.12.camel@raz>
References: <1242297833-13908-1-git-send-email-maan@systemlinux.org>
	 <1242297833-13908-2-git-send-email-maan@systemlinux.org>
	 <fe4d072c76f1ce1d6b2b75f83766b1f0.squirrel@neil.brown.name>
	 <20090514121042.GH11504@skl-net.de>
	 <4743925b38e2d64317e0b6d7c8005a29.squirrel@neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4743925b38e2d64317e0b6d7c8005a29.squirrel@neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Andre Noll <maan@systemlinux.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

 move raid0 chunk size to 4K*n granularity. 
 motivation for this patch is to have a better access to raid550. if a raid 5 is 3M
 stripe (4-1),and you have two of these raids 5's, and on top of you have a raid0, 
 it is better to access raid550 with a 3MB buffers and not 1M ( no raid5 write penalty).
 Andre, Patch is applied on top of your last post. now it is your turn to merge :)
 md.c    |   24 ++++++++++-----
 raid0.c |  102 ++++++++++++++++++++++++++++++----------------------------------
 
 2 files changed, 65 insertions(+), 61 deletions(-) 
Signed-Off-by:raziebe@gmail.com

diff --git a/drivers/md/md.c b/drivers/md/md.c
index ed5727c..5eab782 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -440,12 +440,14 @@ static inline sector_t calc_dev_sboffset(struct block_device *bdev)
 	return MD_NEW_SIZE_SECTORS(num_sectors);
 }
 
+
 static sector_t calc_num_sectors(mdk_rdev_t *rdev, unsigned chunk_size)
 {
 	sector_t num_sectors = rdev->sb_start;
-
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
+			if (max % (sector_t)((mddev->chunk_size>>9)))
 				return -EINVAL;
 		}
 		mddev->resync_max = max;
@@ -3993,11 +3995,19 @@ static int do_md_run(mddev_t * mddev)
 		/*
 		 * chunk-size has to be a power of 2
 		 */
-		if ( (1 << ffz(~chunk_size)) != chunk_size) {
+		if ((1 << ffz(~chunk_size)) != chunk_size &&
+			 mddev->level != 0) {
 			printk(KERN_ERR "chunk_size of %d not valid\n", chunk_size);
 			return -EINVAL;
 		}
-
+		/*
+		* raid0 chunk size has to divide by a page
+		*/
+		if (mddev->level == 0 && (chunk_size % 4096)) {
+			printk(KERN_ERR "chunk_size of %d not valid\n",
+				chunk_size);
+			return -EINVAL;
+		}
 		/* devices must have minimum size of one chunk */
 		list_for_each_entry(rdev, &mddev->disks, same_set) {
 			if (test_bit(Faulty, &rdev->flags))
diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index 36b747a..9865316 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -53,7 +53,7 @@ static int raid0_congested(void *data, int bits)
 }
 
 
-static int create_strip_zones (mddev_t *mddev)
+static int raid0_create_strip_zones(mddev_t *mddev)
 {
 	int i, c, j;
 	sector_t current_start, curr_zone_start;
@@ -237,7 +237,7 @@ static int raid0_mergeable_bvec(struct request_queue *q,
 	unsigned int chunk_sectors = mddev->chunk_size >> 9;
 	unsigned int bio_sectors = bvm->bi_size >> 9;
 
-	max =  (chunk_sectors - ((sector & (chunk_sectors - 1)) + bio_sectors)) << 9;
+	max =  (chunk_sectors - ((sector % chunk_sectors) + bio_sectors)) << 9;
 	if (max < 0) max = 0; /* bio_add cannot handle a negative return */
 	if (max <= biovec->bv_len && bio_sectors == 0)
 		return biovec->bv_len;
@@ -259,26 +259,37 @@ static sector_t raid0_size(mddev_t *mddev, sector_t sectors, int raid_disks)
 	return array_sectors;
 }
 
+static int raid0_is_power2_chunk(mddev_t *mddev)
+{
+	if ((1 << ffz(~mddev->chunk_size)) == mddev->chunk_size)
+		return 1;
+	return 0;
+}
+
+
 static int raid0_run(mddev_t *mddev)
 {
 	int ret;
+	int segment_boundary =  (mddev->chunk_size>>1)-1;
 
 	if (mddev->chunk_size == 0) {
 		printk(KERN_ERR "md/raid0: non-zero chunk size required.\n");
 		return -EINVAL;
 	}
-	printk(KERN_INFO "%s: setting max_sectors to %d, segment boundary to %d\n",
-	       mdname(mddev),
-	       mddev->chunk_size >> 9,
-	       (mddev->chunk_size>>1)-1);
 	blk_queue_max_sectors(mddev->queue, mddev->chunk_size >> 9);
-	blk_queue_segment_boundary(mddev->queue, (mddev->chunk_size>>1) - 1);
+	if (!raid0_is_power2_chunk(mddev))
+		segment_boundary = ~(ffz(~mddev->chunk_size))>>1;
+	printk(KERN_INFO "%s: setting max_sectors to %d, segment boundary to %d\n",
+		mdname(mddev),
+		mddev->chunk_size >> 9,
+		segment_boundary);
+	blk_queue_segment_boundary(mddev->queue, segment_boundary);
 	mddev->queue->queue_lock = &mddev->queue->__queue_lock;
 
 	mddev->private = kmalloc(sizeof(raid0_conf_t), GFP_KERNEL);
 	if (!mddev->private)
 		return -ENOMEM;
-	ret = create_strip_zones(mddev);
+	ret = raid0_create_strip_zones(mddev);
 	if (ret < 0) {
 		kfree(mddev->private);
 		mddev->private = NULL;
@@ -322,31 +333,35 @@ static int raid0_stop (mddev_t *mddev)
 	return 0;
 }
 
-/* Find the zone which holds a particular offset */
-static struct strip_zone *find_zone(struct raid0_private_data *conf,
-		sector_t sector)
+static int raid0_position_bio(mddev_t *mddev, struct bio *bio, sector_t sector)
 {
-	int i;
-
-	for (i = 0; i < conf->nr_strip_zones; i++) {
-		struct strip_zone *z = conf->strip_zone + i;
-
-		if (sector < z->zone_start + z->sectors)
-			return z;
-	}
-	BUG();
-	return NULL;
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
+	return 0;
 }
 
-static int raid0_make_request (struct request_queue *q, struct bio *bio)
+static int raid0_make_request(struct request_queue *q, struct bio *bio)
 {
 	mddev_t *mddev = q->queuedata;
-	unsigned int sect_in_chunk, chunksect_bits, chunk_sects;
-	raid0_conf_t *conf = mddev_to_conf(mddev);
-	struct strip_zone *zone;
-	mdk_rdev_t *tmp_dev;
-	sector_t chunk;
-	sector_t sector, rsect;
+	unsigned int chunk_sects;
 	const int rw = bio_data_dir(bio);
 	int cpu;
 
@@ -362,10 +377,9 @@ static int raid0_make_request (struct request_queue *q, struct bio *bio)
 	part_stat_unlock();
 
 	chunk_sects = mddev->chunk_size >> 9;
-	chunksect_bits = ffz(~chunk_sects);
-	sector = bio->bi_sector;
 
-	if (unlikely(chunk_sects < (bio->bi_sector & (chunk_sects - 1)) + (bio->bi_size >> 9))) {
+	if (unlikely(chunk_sects < ((bio->bi_sector % chunk_sects)
+			+ (bio->bi_size >> 9)))) {
 		struct bio_pair *bp;
 		/* Sanity check -- queue functions should prevent this happening */
 		if (bio->bi_vcnt != 1 ||
@@ -374,7 +388,8 @@ static int raid0_make_request (struct request_queue *q, struct bio *bio)
 		/* This is a one page bio that upper layers
 		 * refuse to split for us, so we need to split it.
 		 */
-		bp = bio_split(bio, chunk_sects - (bio->bi_sector & (chunk_sects - 1)));
+		bp = bio_split(bio, chunk_sects -
+					(bio->bi_sector % chunk_sects));
 		if (raid0_make_request(q, &bp->bio1))
 			generic_make_request(&bp->bio1);
 		if (raid0_make_request(q, &bp->bio2))
@@ -383,29 +398,8 @@ static int raid0_make_request (struct request_queue *q, struct bio *bio)
 		bio_pair_release(bp);
 		return 0;
 	}
-	zone = find_zone(conf, sector);
-	if (!zone)
+	if (!raid0_position_bio(mddev, bio, bio->bi_sector))
 		return 1;
-	sect_in_chunk = bio->bi_sector & (chunk_sects - 1);
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
-	/*
-	 * Let the main block layer submit the IO and resolve recursion:
-	 */
-	return 1;
-
 bad_map:
 	printk("raid0_make_request bug: can't convert block across chunks"
 		" or bigger than %dk %llu %d\n", chunk_sects / 2,


