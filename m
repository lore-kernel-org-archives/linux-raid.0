From: Andre Noll <maan@systemlinux.org>
Subject: [PATCH 4/6] md: linear: Represent dev_info->size and dev_info->offset in sectors.
Date: Fri, 25 Jul 2008 17:27:50 +0200
Message-ID: <1216999672-4943-5-git-send-email-maan@systemlinux.org>
References: <1216999672-4943-1-git-send-email-maan@systemlinux.org>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1216999672-4943-1-git-send-email-maan@systemlinux.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Andre Noll <maan@systemlinux.org>
List-Id: linux-raid.ids

Rename them to num_sectors and start_sector which is more descriptive.

Signed-off-by: Andre Noll <maan@systemlinux.org>
---
 drivers/md/linear.c         |   51 ++++++++++++++++++++++---------------------
 include/linux/raid/linear.h |    4 +-
 2 files changed, 28 insertions(+), 27 deletions(-)

diff --git a/drivers/md/linear.c b/drivers/md/linear.c
index f33b574..b33e433 100644
--- a/drivers/md/linear.c
+++ b/drivers/md/linear.c
@@ -42,7 +42,7 @@ static inline dev_info_t *which_dev(mddev_t *mddev, sector_t sector)
 	(void)sector_div(block, conf->hash_spacing);
 	hash = conf->hash_table[block];
 
-	while ((sector>>1) >= (hash->size + hash->offset))
+	while (sector >= hash->num_sectors + hash->start_sector)
 		hash++;
 	return hash;
 }
@@ -63,7 +63,7 @@ static int linear_mergeable_bvec(struct request_queue *q, struct bio *bio, struc
 	sector_t sector = bio->bi_sector + get_start_sect(bio->bi_bdev);
 
 	dev0 = which_dev(mddev, sector);
-	maxsectors = (dev0->size << 1) - (sector - (dev0->offset<<1));
+	maxsectors = dev0->num_sectors - sector + dev0->start_sector;
 
 	if (maxsectors < bio_sectors)
 		maxsectors = 0;
@@ -111,7 +111,7 @@ static linear_conf_t *linear_conf(mddev_t *mddev, int raid_disks)
 	mdk_rdev_t *rdev;
 	int i, nb_zone, cnt;
 	sector_t min_spacing;
-	sector_t curr_offset;
+	sector_t curr_sector;
 	struct list_head *tmp;
 
 	conf = kzalloc (sizeof (*conf) + raid_disks*sizeof(dev_info_t),
@@ -143,7 +143,7 @@ static linear_conf_t *linear_conf(mddev_t *mddev, int raid_disks)
 		    mddev->queue->max_sectors > (PAGE_SIZE>>9))
 			blk_queue_max_sectors(mddev->queue, PAGE_SIZE>>9);
 
-		disk->size = rdev->size;
+		disk->num_sectors = rdev->size * 2;
 		conf->array_sectors += rdev->size * 2;
 
 		cnt++;
@@ -167,7 +167,7 @@ static linear_conf_t *linear_conf(mddev_t *mddev, int raid_disks)
 		sector_t sz = 0;
 		int j;
 		for (j = i; j < cnt - 1 && sz < min_spacing; j++)
-			sz += conf->disks[j].size;
+			sz += conf->disks[j].num_sectors / 2;
 		if (sz >= min_spacing && sz < conf->hash_spacing)
 			conf->hash_spacing = sz;
 	}
@@ -209,20 +209,20 @@ static linear_conf_t *linear_conf(mddev_t *mddev, int raid_disks)
 	 * Here we generate the linear hash table
 	 * First calculate the device offsets.
 	 */
-	conf->disks[0].offset = 0;
+	conf->disks[0].start_sector = 0;
 	for (i = 1; i < raid_disks; i++)
-		conf->disks[i].offset =
-			conf->disks[i-1].offset +
-			conf->disks[i-1].size;
+		conf->disks[i].start_sector =
+			conf->disks[i-1].start_sector +
+			conf->disks[i-1].num_sectors;
 
 	table = conf->hash_table;
 	i = 0;
-	for (curr_offset = 0;
-	     curr_offset < conf->array_sectors / 2;
-	     curr_offset += conf->hash_spacing) {
+	for (curr_sector = 0;
+	     curr_sector < conf->array_sectors;
+	     curr_sector += conf->hash_spacing * 2) {
 
 		while (i < raid_disks-1 &&
-		       curr_offset >= conf->disks[i+1].offset)
+		       curr_sector >= conf->disks[i+1].start_sector)
 			i++;
 
 		*table ++ = conf->disks + i;
@@ -314,7 +314,6 @@ static int linear_make_request (struct request_queue *q, struct bio *bio)
 	const int rw = bio_data_dir(bio);
 	mddev_t *mddev = q->queuedata;
 	dev_info_t *tmp_dev;
-	sector_t block;
 
 	if (unlikely(bio_barrier(bio))) {
 		bio_endio(bio, -EOPNOTSUPP);
@@ -325,29 +324,30 @@ static int linear_make_request (struct request_queue *q, struct bio *bio)
 	disk_stat_add(mddev->gendisk, sectors[rw], bio_sectors(bio));
 
 	tmp_dev = which_dev(mddev, bio->bi_sector);
-	block = bio->bi_sector >> 1;
     
-	if (unlikely(block >= (tmp_dev->size + tmp_dev->offset)
-		     || block < tmp_dev->offset)) {
+	if (unlikely(bio->bi_sector >= tmp_dev->num_sectors
+		+ tmp_dev->start_sector || bio->bi_sector <
+		tmp_dev->start_sector)) {
 		char b[BDEVNAME_SIZE];
 
-		printk("linear_make_request: Block %llu out of bounds on "
-			"dev %s size %llu offset %llu\n",
-			(unsigned long long)block,
+		printk("linear_make_request: Sector %llu out of bounds on "
+			"dev %s: %llu sectors, offset %llu\n",
+			(unsigned long long)bio->bi_sector,
 			bdevname(tmp_dev->rdev->bdev, b),
-			(unsigned long long)tmp_dev->size,
-		        (unsigned long long)tmp_dev->offset);
+			(unsigned long long)tmp_dev->num_sectors,
+			(unsigned long long)tmp_dev->start_sector);
 		bio_io_error(bio);
 		return 0;
 	}
 	if (unlikely(bio->bi_sector + (bio->bi_size >> 9) >
-		     (tmp_dev->offset + tmp_dev->size)<<1)) {
+			tmp_dev->start_sector + tmp_dev->num_sectors)) {
 		/* This bio crosses a device boundary, so we have to
 		 * split it.
 		 */
 		struct bio_pair *bp;
 		bp = bio_split(bio, bio_split_pool,
-			       ((tmp_dev->offset + tmp_dev->size)<<1) - bio->bi_sector);
+			tmp_dev->start_sector + tmp_dev->num_sectors
+			- bio->bi_sector);
 		if (linear_make_request(q, &bp->bio1))
 			generic_make_request(&bp->bio1);
 		if (linear_make_request(q, &bp->bio2))
@@ -357,7 +357,8 @@ static int linear_make_request (struct request_queue *q, struct bio *bio)
 	}
 		    
 	bio->bi_bdev = tmp_dev->rdev->bdev;
-	bio->bi_sector = bio->bi_sector - (tmp_dev->offset << 1) + tmp_dev->rdev->data_offset;
+	bio->bi_sector = bio->bi_sector - tmp_dev->start_sector
+		+ tmp_dev->rdev->data_offset;
 
 	return 1;
 }
diff --git a/include/linux/raid/linear.h b/include/linux/raid/linear.h
index 7e37511..87090e9 100644
--- a/include/linux/raid/linear.h
+++ b/include/linux/raid/linear.h
@@ -5,8 +5,8 @@
 
 struct dev_info {
 	mdk_rdev_t	*rdev;
-	sector_t	size;
-	sector_t	offset;
+	sector_t	num_sectors;
+	sector_t	start_sector;
 };
 
 typedef struct dev_info dev_info_t;
-- 
1.5.4.3

