From: Yuanhan Liu <yuanhan.liu@linux.intel.com>
Subject: [PATCH 3/4] md: introduce md_rdev_merge_bvec to reduce code duplicate
Date: Thu, 31 May 2012 18:18:47 +0800
Message-ID: <1338459528-24490-3-git-send-email-yuanhan.liu@linux.intel.com>
References: <1338459528-24490-1-git-send-email-yuanhan.liu@linux.intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1338459528-24490-1-git-send-email-yuanhan.liu@linux.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, Yuanhan Liu <yuanhan.liu@linux.intel.com>
List-Id: linux-raid.ids

There are several copies of the same code to try to merge biovec. Here
introduce md_rdev_merge_bvec for that to reduce code duplicate.

Signed-off-by: Yuanhan Liu <yuanhan.liu@linux.intel.com>
---
 drivers/md/linear.c |   13 +++++--------
 drivers/md/md.c     |   18 ++++++++++++++++++
 drivers/md/md.h     |    5 +++++
 drivers/md/raid0.c  |   13 ++++---------
 drivers/md/raid1.c  |   10 ++++------
 drivers/md/raid10.c |   21 +++++++--------------
 6 files changed, 43 insertions(+), 37 deletions(-)

diff --git a/drivers/md/linear.c b/drivers/md/linear.c
index fa211d8..50ddd26 100644
--- a/drivers/md/linear.c
+++ b/drivers/md/linear.c
@@ -65,22 +65,19 @@ static int linear_mergeable_bvec(struct request_queue *q,
 				 struct bio_vec *biovec)
 {
 	struct mddev *mddev = q->queuedata;
+	struct md_rdev *rdev;
 	struct dev_info *dev0;
 	unsigned long maxsectors, bio_sectors = bvm->bi_size >> 9;
 	sector_t sector = bvm->bi_sector + get_start_sect(bvm->bi_bdev);
+	sector_t bi_sector;
 	int maxbytes = biovec->bv_len;
-	struct request_queue *subq;
 
 	rcu_read_lock();
 	dev0 = which_dev(mddev, sector);
+	rdev = dev0->rdev;
 	maxsectors = dev0->end_sector - sector;
-	subq = bdev_get_queue(dev0->rdev->bdev);
-	if (subq->merge_bvec_fn) {
-		bvm->bi_bdev = dev0->rdev->bdev;
-		bvm->bi_sector -= dev0->end_sector - dev0->rdev->sectors;
-		maxbytes = min(maxbytes, subq->merge_bvec_fn(subq, bvm,
-							     biovec));
-	}
+	bi_sector = bvm->bi_sector - (dev0->end_sector - rdev->sectors);
+	maxbytes = md_rdev_merge_bvec(rdev, bvm, biovec, bi_sector, maxbytes);
 	rcu_read_unlock();
 
 	if (maxsectors < bio_sectors)
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 1c2f904..87e5ce8 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -5446,6 +5446,24 @@ static int do_md_stop(struct mddev * mddev, int mode, int is_open)
 	return 0;
 }
 
+int md_rdev_merge_bvec(struct md_rdev *rdev,
+		       struct bvec_merge_data *bvm,
+		       struct bio_vec *biovec,
+		       sector_t sector,
+		       int max_size)
+{
+	struct request_queue *q = bdev_get_queue(rdev->bdev);
+
+	if (q->merge_bvec_fn) {
+		bvm->bi_sector = sector;
+		bvm->bi_bdev = rdev->bdev;
+		max_size = min(max_size, q->merge_bvec_fn(q, bvm, biovec));
+	}
+
+	return max_size;
+}
+EXPORT_SYMBOL_GPL(md_rdev_merge_bvec);
+
 #ifndef MODULE
 static void autorun_array(struct mddev *mddev)
 {
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 7b4a3c3..fb80ce1 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -623,6 +623,11 @@ extern void md_stop(struct mddev *mddev);
 extern void md_stop_writes(struct mddev *mddev);
 extern int md_rdev_init(struct md_rdev *rdev);
 extern void md_rdev_clear(struct md_rdev *rdev);
+extern int md_rdev_merge_bvec(struct md_rdev *rdev,
+			       struct bvec_merge_data *bvm,
+			       struct bio_vec *biovec,
+			       sector_t sector,
+			       int max_size);
 
 extern void mddev_suspend(struct mddev *mddev);
 extern void mddev_resume(struct mddev *mddev);
diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index de63a1f..8f1eb2f 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -356,12 +356,12 @@ static int raid0_mergeable_bvec(struct request_queue *q,
 	struct r0conf *conf = mddev->private;
 	sector_t sector = bvm->bi_sector + get_start_sect(bvm->bi_bdev);
 	sector_t sector_offset = sector;
+	sector_t bi_sector;
 	int max;
 	unsigned int chunk_sectors = mddev->chunk_sectors;
 	unsigned int bio_sectors = bvm->bi_size >> 9;
 	struct strip_zone *zone;
 	struct md_rdev *rdev;
-	struct request_queue *subq;
 
 	if (is_power_of_2(chunk_sectors))
 		max =  (chunk_sectors - ((sector & (chunk_sectors-1))
@@ -383,14 +383,9 @@ static int raid0_mergeable_bvec(struct request_queue *q,
 	sector = sector_offset;
 	zone = find_zone(mddev->private, &sector_offset);
 	rdev = map_sector(mddev, zone, sector, &sector_offset);
-	subq = bdev_get_queue(rdev->bdev);
-	if (subq->merge_bvec_fn) {
-		bvm->bi_bdev = rdev->bdev;
-		bvm->bi_sector = sector_offset + zone->dev_start +
-			rdev->data_offset;
-		return min(max, subq->merge_bvec_fn(subq, bvm, biovec));
-	} else
-		return max;
+	bi_sector = sector_offset + zone->dev_start + rdev->data_offset;
+
+	return md_rdev_merge_bvec(rdev, bvm, biovec, bi_sector, max);
 }
 
 static sector_t raid0_size(struct mddev *mddev, sector_t sectors, int raid_disks)
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 5829f46..ed3c039 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -622,6 +622,7 @@ static int raid1_mergeable_bvec(struct request_queue *q,
 	struct mddev *mddev = q->queuedata;
 	struct r1conf *conf = mddev->private;
 	sector_t sector = bvm->bi_sector + get_start_sect(bvm->bi_bdev);
+	sector_t bi_sector;
 	int max = biovec->bv_len;
 	int disk;
 
@@ -632,12 +633,9 @@ static int raid1_mergeable_bvec(struct request_queue *q,
 	for (disk = 0; disk < conf->raid_disks * 2; disk++) {
 		struct md_rdev *rdev = rcu_dereference(conf->mirrors[disk].rdev);
 		if (rdev && !test_bit(Faulty, &rdev->flags)) {
-			struct request_queue *q = bdev_get_queue(rdev->bdev);
-			if (q->merge_bvec_fn) {
-				bvm->bi_sector = sector + rdev->data_offset;
-				bvm->bi_bdev = rdev->bdev;
-				max = min(max, q->merge_bvec_fn(q, bvm, biovec));
-			}
+			bi_sector = sector + rdev->data_offset;
+			max = md_rdev_merge_bvec(rdev, bvm, biovec,
+						 bi_sector, max);
 		}
 	}
 	rcu_read_unlock();
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 83d0e65..1b0ff80 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -622,6 +622,7 @@ static int raid10_mergeable_bvec(struct request_queue *q,
 	struct mddev *mddev = q->queuedata;
 	struct r10conf *conf = mddev->private;
 	sector_t sector = bvm->bi_sector + get_start_sect(bvm->bi_bdev);
+	sector_t bi_sector;
 	int max;
 	unsigned int chunk_sectors;
 	unsigned int bio_sectors = bvm->bi_size >> 9;
@@ -663,23 +664,15 @@ static int raid10_mergeable_bvec(struct request_queue *q,
 		int disk = r10_bio.devs[s].devnum;
 		struct md_rdev *rdev = rcu_dereference(conf->mirrors[disk].rdev);
 		if (rdev && !test_bit(Faulty, &rdev->flags)) {
-			struct request_queue *q = bdev_get_queue(rdev->bdev);
-			if (q->merge_bvec_fn) {
-				bvm->bi_sector = r10_bio.devs[s].addr +
-						 rdev->data_offset;
-				bvm->bi_bdev = rdev->bdev;
-				max = min(max, q->merge_bvec_fn(q, bvm, biovec));
-			}
+			bi_sector = r10_bio.devs[s].addr + rdev->data_offset;
+			max = md_rdev_merge_bvec(rdev, bvm, biovec,
+						 bi_sector, max);
 		}
 		rdev = rcu_dereference(conf->mirrors[disk].replacement);
 		if (rdev && !test_bit(Faulty, &rdev->flags)) {
-			struct request_queue *q = bdev_get_queue(rdev->bdev);
-			if (q->merge_bvec_fn) {
-				bvm->bi_sector = r10_bio.devs[s].addr +
-						 rdev->data_offset;
-				bvm->bi_bdev = rdev->bdev;
-				max = min(max, q->merge_bvec_fn(q, bvm, biovec));
-			}
+			bi_sector = r10_bio.devs[s].addr + rdev->data_offset;
+			max = md_rdev_merge_bvec(rdev, bvm, biovec,
+						 bi_sector, max);
 		}
 	}
 	rcu_read_unlock();
-- 
1.7.7.6

