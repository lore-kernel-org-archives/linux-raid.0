From: raz ben yehuda <raziebe@gmail.com>
Subject: Subject:[PATCH 008:013]:raid0, split raid0_make_request
Date: Wed, 17 Jun 2009 00:56:39 +0300
Message-ID: <1245189399.3478.109.camel@raz>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>, linux raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

split raid0_make_request. reshape uses make_request directly.
in raid0_make_request we test the reshape bit.
 raid0.c |   66 ++++++++++++++++++++++++++++++++++++++++++----------------------
 1 file changed, 44 insertions(+), 22 deletions(-)

Signed-off-by: razb <raziebe@gmail.com>
---
diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index eaad2f9..1e01c61 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -491,29 +491,28 @@ static inline int is_io_in_chunk_boundary(unsigned int chunk_sects,
 	}
 }
 
-static int raid0_make_request(struct request_queue *q, struct bio *bio)
+/*
+ * main transmit routine. make_request is aloof to mddev, the mapping
+ * information is gathered from the raid configuration and numeber of raid
+ * disks in array.
+*/
+static int make_request(struct request_queue *q,
+			raid0_conf_t *conf,
+			int raid_disks,
+			unsigned int chunk_sectors,
+			struct bio *bio)
 {
 	mddev_t *mddev = q->queuedata;
-	unsigned int chunk_sects;
 	sector_t sector_offset;
 	struct strip_zone *zone;
 	mdk_rdev_t *tmp_dev;
-	const int rw = bio_data_dir(bio);
-	int cpu;
 
 	if (unlikely(bio_barrier(bio))) {
 		bio_endio(bio, -EOPNOTSUPP);
 		return 0;
 	}
 
-	cpu = part_stat_lock();
-	part_stat_inc(cpu, &mddev->gendisk->part0, ios[rw]);
-	part_stat_add(cpu, &mddev->gendisk->part0, sectors[rw],
-		      bio_sectors(bio));
-	part_stat_unlock();
-
-	chunk_sects = mddev->chunk_sectors;
-	if (unlikely(!is_io_in_chunk_boundary(chunk_sects, bio))) {
+	if (unlikely(!is_io_in_chunk_boundary(chunk_sectors, bio))) {
 		sector_t sector = bio->bi_sector;
 		struct bio_pair *bp;
 		/* Sanity check -- queue functions should prevent this happening */
@@ -523,15 +522,16 @@ static int raid0_make_request(struct request_queue *q, struct bio *bio)
 		/* This is a one page bio that upper layers
 		 * refuse to split for us, so we need to split it.
 		 */
-		if (likely(is_power_of_2(chunk_sects)))
-			bp = bio_split(bio, chunk_sects - (sector &
-							   (chunk_sects-1)));
+		if (likely(is_power_of_2(chunk_sectors)))
+			bp = bio_split(bio, chunk_sectors - (sector &
+							   (chunk_sectors-1)));
 		else
-			bp = bio_split(bio, chunk_sects -
-				       sector_div(sector, chunk_sects));
-		if (raid0_make_request(q, &bp->bio1))
+			bp = bio_split(bio, chunk_sectors -
+				       sector_div(sector, chunk_sectors));
+
+		if (make_request(q, conf, raid_disks, chunk_sectors, &bp->bio1))
 			generic_make_request(&bp->bio1);
-		if (raid0_make_request(q, &bp->bio2))
+		if (make_request(q, conf, raid_disks, chunk_sectors, &bp->bio2))
 			generic_make_request(&bp->bio2);
 
 		bio_pair_release(bp);
@@ -543,8 +543,8 @@ static int raid0_make_request(struct request_queue *q, struct bio *bio)
 	if (!zone)
 		BUG();
 	tmp_dev = map_sector(mddev->private,
-				mddev->chunk_sectors,
-				mddev->raid_disks,
+				chunk_sectors,
+				raid_disks,
 				zone,
 				bio->bi_sector,
 				&sector_offset);
@@ -558,13 +558,35 @@ static int raid0_make_request(struct request_queue *q, struct bio *bio)
 
 bad_map:
 	printk("raid0_make_request bug: can't convert block across chunks"
-		" or bigger than %dk %llu %d\n", chunk_sects / 2,
+		" or bigger than %dk %llu %d\n", chunk_sectors / 2,
 		(unsigned long long)bio->bi_sector, bio->bi_size >> 10);
 
 	bio_io_error(bio);
 	return 0;
 }
 
+static int raid0_make_request(struct request_queue *q, struct bio *bio)
+{
+	int cpu;
+	const int rw = bio_data_dir(bio);
+	mddev_t *mddev = q->queuedata;
+
+	cpu = part_stat_lock();
+	part_stat_inc(cpu, &mddev->gendisk->part0, ios[rw]);
+	part_stat_add(cpu, &mddev->gendisk->part0, sectors[rw],
+		      bio_sectors(bio));
+	part_stat_unlock();
+
+	if (unlikely(bio_barrier(bio))) {
+		bio_endio(bio, -EOPNOTSUPP);
+		return 0;
+	}
+
+	return make_request(q, mddev->private,
+				mddev->raid_disks,
+				mddev->chunk_sectors, bio);
+}
+
 static void raid0_status(struct seq_file *seq, mddev_t *mddev)
 {
 #undef MD_DEBUG



