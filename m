From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 12/23] md: add proper merge_bvec handling to RAID0 and
 Linear.
Date: Wed, 14 Mar 2012 15:40:40 +1100
Message-ID: <20120314044040.7978.99912.stgit@notabene.brown>
References: <20120314043555.7978.75486.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120314043555.7978.75486.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

These personalities currently set a max request size of one page
when any member device has a merge_bvec_fn because they don't
bother to call that function.

This causes extra works in splitting and combining requests.

So make the extra effort to call the merge_bvec_fn when it exists
so that we end up with larger requests out the bottom.

Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/linear.c |   30 +++++-----
 drivers/md/raid0.c  |  154 ++++++++++++++++++++++++++++-----------------------
 drivers/md/raid0.h  |   11 ++--
 3 files changed, 107 insertions(+), 88 deletions(-)

diff --git a/drivers/md/linear.c b/drivers/md/linear.c
index 6794074..b0fcc7d 100644
--- a/drivers/md/linear.c
+++ b/drivers/md/linear.c
@@ -68,10 +68,19 @@ static int linear_mergeable_bvec(struct request_queue *q,
 	struct dev_info *dev0;
 	unsigned long maxsectors, bio_sectors = bvm->bi_size >> 9;
 	sector_t sector = bvm->bi_sector + get_start_sect(bvm->bi_bdev);
+	int maxbytes = biovec->bv_len;
+	struct request_queue *subq;
 
 	rcu_read_lock();
 	dev0 = which_dev(mddev, sector);
 	maxsectors = dev0->end_sector - sector;
+	subq = bdev_get_queue(dev0->rdev->bdev);
+	if (subq->merge_bvec_fn) {
+		bvm->bi_bdev = dev0->rdev->bdev;
+		bvm->bi_sector -= dev0->end_sector - dev0->rdev->sectors;
+		maxbytes = min(maxbytes, subq->merge_bvec_fn(subq, bvm,
+							     biovec));
+	}
 	rcu_read_unlock();
 
 	if (maxsectors < bio_sectors)
@@ -80,12 +89,12 @@ static int linear_mergeable_bvec(struct request_queue *q,
 		maxsectors -= bio_sectors;
 
 	if (maxsectors <= (PAGE_SIZE >> 9 ) && bio_sectors == 0)
-		return biovec->bv_len;
-	/* The bytes available at this offset could be really big,
-	 * so we cap at 2^31 to avoid overflow */
-	if (maxsectors > (1 << (31-9)))
-		return 1<<31;
-	return maxsectors << 9;
+		return maxbytes;
+
+	if (maxsectors > (maxbytes >> 9))
+		return maxbytes;
+	else
+		return maxsectors << 9;
 }
 
 static int linear_congested(void *data, int bits)
@@ -158,15 +167,6 @@ static struct linear_conf *linear_conf(struct mddev *mddev, int raid_disks)
 
 		disk_stack_limits(mddev->gendisk, rdev->bdev,
 				  rdev->data_offset << 9);
-		/* as we don't honour merge_bvec_fn, we must never risk
-		 * violating it, so limit max_segments to 1 lying within
-		 * a single page.
-		 */
-		if (rdev->bdev->bd_disk->queue->merge_bvec_fn) {
-			blk_queue_max_segments(mddev->queue, 1);
-			blk_queue_segment_boundary(mddev->queue,
-						   PAGE_CACHE_SIZE - 1);
-		}
 
 		conf->array_sectors += rdev->sectors;
 		cnt++;
diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index 7ef5cbf..6f31f55 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -188,16 +188,10 @@ static int create_strip_zones(struct mddev *mddev, struct r0conf **private_conf)
 
 		disk_stack_limits(mddev->gendisk, rdev1->bdev,
 				  rdev1->data_offset << 9);
-		/* as we don't honour merge_bvec_fn, we must never risk
-		 * violating it, so limit ->max_segments to 1, lying within
-		 * a single page.
-		 */
 
-		if (rdev1->bdev->bd_disk->queue->merge_bvec_fn) {
-			blk_queue_max_segments(mddev->queue, 1);
-			blk_queue_segment_boundary(mddev->queue,
-						   PAGE_CACHE_SIZE - 1);
-		}
+		if (rdev1->bdev->bd_disk->queue->merge_bvec_fn)
+			conf->has_merge_bvec = 1;
+
 		if (!smallest || (rdev1->sectors < smallest->sectors))
 			smallest = rdev1;
 		cnt++;
@@ -290,8 +284,64 @@ abort:
 	return err;
 }
 
+/* Find the zone which holds a particular offset
+ * Update *sectorp to be an offset in that zone
+ */
+static struct strip_zone *find_zone(struct r0conf *conf,
+				    sector_t *sectorp)
+{
+	int i;
+	struct strip_zone *z = conf->strip_zone;
+	sector_t sector = *sectorp;
+
+	for (i = 0; i < conf->nr_strip_zones; i++)
+		if (sector < z[i].zone_end) {
+			if (i)
+				*sectorp = sector - z[i-1].zone_end;
+			return z + i;
+		}
+	BUG();
+}
+
+/*
+ * remaps the bio to the target device. we separate two flows.
+ * power 2 flow and a general flow for the sake of perfromance
+*/
+static struct md_rdev *map_sector(struct mddev *mddev, struct strip_zone *zone,
+				sector_t sector, sector_t *sector_offset)
+{
+	unsigned int sect_in_chunk;
+	sector_t chunk;
+	struct r0conf *conf = mddev->private;
+	int raid_disks = conf->strip_zone[0].nb_dev;
+	unsigned int chunk_sects = mddev->chunk_sectors;
+
+	if (is_power_of_2(chunk_sects)) {
+		int chunksect_bits = ffz(~chunk_sects);
+		/* find the sector offset inside the chunk */
+		sect_in_chunk  = sector & (chunk_sects - 1);
+		sector >>= chunksect_bits;
+		/* chunk in zone */
+		chunk = *sector_offset;
+		/* quotient is the chunk in real device*/
+		sector_div(chunk, zone->nb_dev << chunksect_bits);
+	} else{
+		sect_in_chunk = sector_div(sector, chunk_sects);
+		chunk = *sector_offset;
+		sector_div(chunk, chunk_sects * zone->nb_dev);
+	}
+	/*
+	*  position the bio over the real device
+	*  real sector = chunk in device + starting of zone
+	*	+ the position in the chunk
+	*/
+	*sector_offset = (chunk * chunk_sects) + sect_in_chunk;
+	return conf->devlist[(zone - conf->strip_zone)*raid_disks
+			     + sector_div(sector, zone->nb_dev)];
+}
+
 /**
- *	raid0_mergeable_bvec -- tell bio layer if a two requests can be merged
+ *	raid0_mergeable_bvec -- tell bio layer if two requests can be merged
  *	@q: request queue
  *	@bvm: properties of new bio
  *	@biovec: the request that could be merged to it.
@@ -303,10 +353,15 @@ static int raid0_mergeable_bvec(struct request_queue *q,
 				struct bio_vec *biovec)
 {
 	struct mddev *mddev = q->queuedata;
+	struct r0conf *conf = mddev->private;
 	sector_t sector = bvm->bi_sector + get_start_sect(bvm->bi_bdev);
+	sector_t sector_offset = sector;
 	int max;
 	unsigned int chunk_sectors = mddev->chunk_sectors;
 	unsigned int bio_sectors = bvm->bi_size >> 9;
+	struct strip_zone *zone;
+	struct md_rdev *rdev;
+	struct request_queue *subq;
 
 	if (is_power_of_2(chunk_sectors))
 		max =  (chunk_sectors - ((sector & (chunk_sectors-1))
@@ -314,10 +369,27 @@ static int raid0_mergeable_bvec(struct request_queue *q,
 	else
 		max =  (chunk_sectors - (sector_div(sector, chunk_sectors)
 						+ bio_sectors)) << 9;
-	if (max < 0) max = 0; /* bio_add cannot handle a negative return */
+	if (max < 0)
+		max = 0; /* bio_add cannot handle a negative return */
 	if (max <= biovec->bv_len && bio_sectors == 0)
 		return biovec->bv_len;
-	else 
+	if (max < biovec->bv_len)
+		/* too small already, no need to check further */
+		return max;
+	if (!conf->has_merge_bvec)
+		return max;
+
+	/* May need to check subordinate device */
+	sector = sector_offset;
+	zone = find_zone(mddev->private, &sector_offset);
+	rdev = map_sector(mddev, zone, sector, &sector_offset);
+	subq = bdev_get_queue(rdev->bdev);
+	if (subq->merge_bvec_fn) {
+		bvm->bi_bdev = rdev->bdev;
+		bvm->bi_sector = sector_offset + zone->dev_start +
+			rdev->data_offset;
+		return min(max, subq->merge_bvec_fn(subq, bvm, biovec));
+	} else
 		return max;
 }
 
@@ -397,62 +469,6 @@ static int raid0_stop(struct mddev *mddev)
 	return 0;
 }
 
-/* Find the zone which holds a particular offset
- * Update *sectorp to be an offset in that zone
- */
-static struct strip_zone *find_zone(struct r0conf *conf,
-				    sector_t *sectorp)
-{
-	int i;
-	struct strip_zone *z = conf->strip_zone;
-	sector_t sector = *sectorp;
-
-	for (i = 0; i < conf->nr_strip_zones; i++)
-		if (sector < z[i].zone_end) {
-			if (i)
-				*sectorp = sector - z[i-1].zone_end;
-			return z + i;
-		}
-	BUG();
-}
-
-/*
- * remaps the bio to the target device. we separate two flows.
- * power 2 flow and a general flow for the sake of perfromance
-*/
-static struct md_rdev *map_sector(struct mddev *mddev, struct strip_zone *zone,
-				sector_t sector, sector_t *sector_offset)
-{
-	unsigned int sect_in_chunk;
-	sector_t chunk;
-	struct r0conf *conf = mddev->private;
-	int raid_disks = conf->strip_zone[0].nb_dev;
-	unsigned int chunk_sects = mddev->chunk_sectors;
-
-	if (is_power_of_2(chunk_sects)) {
-		int chunksect_bits = ffz(~chunk_sects);
-		/* find the sector offset inside the chunk */
-		sect_in_chunk  = sector & (chunk_sects - 1);
-		sector >>= chunksect_bits;
-		/* chunk in zone */
-		chunk = *sector_offset;
-		/* quotient is the chunk in real device*/
-		sector_div(chunk, zone->nb_dev << chunksect_bits);
-	} else{
-		sect_in_chunk = sector_div(sector, chunk_sects);
-		chunk = *sector_offset;
-		sector_div(chunk, chunk_sects * zone->nb_dev);
-	}
-	/*
-	*  position the bio over the real device
-	*  real sector = chunk in device + starting of zone
-	*	+ the position in the chunk
-	*/
-	*sector_offset = (chunk * chunk_sects) + sect_in_chunk;
-	return conf->devlist[(zone - conf->strip_zone)*raid_disks
-			     + sector_div(sector, zone->nb_dev)];
-}
-
 /*
  * Is io distribute over 1 or more chunks ?
 */
@@ -505,7 +521,7 @@ static void raid0_make_request(struct mddev *mddev, struct bio *bio)
 	}
 
 	sector_offset = bio->bi_sector;
-	zone =  find_zone(mddev->private, &sector_offset);
+	zone = find_zone(mddev->private, &sector_offset);
 	tmp_dev = map_sector(mddev, zone, bio->bi_sector,
 			     &sector_offset);
 	bio->bi_bdev = tmp_dev->bdev;
diff --git a/drivers/md/raid0.h b/drivers/md/raid0.h
index 0884bba..05539d9 100644
--- a/drivers/md/raid0.h
+++ b/drivers/md/raid0.h
@@ -4,13 +4,16 @@
 struct strip_zone {
 	sector_t zone_end;	/* Start of the next zone (in sectors) */
 	sector_t dev_start;	/* Zone offset in real dev (in sectors) */
-	int nb_dev;		/* # of devices attached to the zone */
+	int	 nb_dev;	/* # of devices attached to the zone */
 };
 
 struct r0conf {
-	struct strip_zone *strip_zone;
-	struct md_rdev **devlist; /* lists of rdevs, pointed to by strip_zone->dev */
-	int nr_strip_zones;
+	struct strip_zone	*strip_zone;
+	struct md_rdev		**devlist; /* lists of rdevs, pointed to
+					    * by strip_zone->dev */
+	int			nr_strip_zones;
+	int			has_merge_bvec;	/* at least one member has
+						 * a merge_bvec_fn */
 };
 
 #endif


