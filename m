From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: PATCH - raid0 and linear bvec_mergable fix
Date: Wed, 13 Nov 2002 09:37:49 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <15825.33469.482525.408713@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: Linus Torvalds <torvalds@transmeta.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


The mergable_bvec functions were mistakenly taking into account the
length of the passed bvec.

Also raid0 version changed to work in sectors, not blocks.



 ----------- Diffstat output ------------
 drivers/md/linear.c |    7 ++-----
 drivers/md/raid0.c  |   16 ++++++++--------
 2 files changed, 10 insertions(+), 13 deletions(-)

diff drivers/md/linear.c~current~ drivers/md/linear.c
--- drivers/md/linear.c~current~	2002-11-12 15:41:59.000000000 +1100
+++ drivers/md/linear.c	2002-11-12 15:41:59.000000000 +1100
@@ -58,15 +58,12 @@ static int linear_mergeable_bvec(request
 {
 	mddev_t *mddev = q->queuedata;
 	dev_info_t *dev0;
-	int maxsectors, bio_sectors = (bio->bi_size + biovec->bv_len) >> 9;
+	unsigned long maxsectors, bio_sectors = bio->bi_size >> 9;
 
 	dev0 = which_dev(mddev, bio->bi_sector);
 	maxsectors = (dev0->size << 1) - (bio->bi_sector - (dev0->offset<<1));
 
-	if (bio_sectors <= maxsectors)
-		return biovec->bv_len;
-
-	return (maxsectors << 9) - bio->bi_size;
+	return (maxsectors - bio_sectors) << 9;
 }
 
 static int linear_run (mddev_t *mddev)

diff drivers/md/raid0.c~current~ drivers/md/raid0.c
--- drivers/md/raid0.c~current~	2002-11-12 15:41:59.000000000 +1100
+++ drivers/md/raid0.c	2002-11-12 15:41:59.000000000 +1100
@@ -173,15 +173,15 @@ static int create_strip_zones (mddev_t *
 static int raid0_mergeable_bvec(request_queue_t *q, struct bio *bio, struct bio_vec *biovec)
 {
 	mddev_t *mddev = q->queuedata;
-	sector_t block;
-	unsigned int chunk_size;
-	unsigned int bio_sz;
+	sector_t sector;
+	unsigned int chunk_sectors;
+	unsigned int bio_sectors;
+
+	chunk_sectors = mddev->chunk_size >> 9;
+	sector = bio->bi_sector;
+	bio_sectors = bio->bi_size >> 9;
 
-	chunk_size = mddev->chunk_size >> 10;
-	block = bio->bi_sector >> 1;
-	bio_sz = (bio->bi_size + biovec->bv_len) >> 10;
-
-	return (chunk_size - ((block & (chunk_size - 1)) + bio_sz)) << 10;
+	return (chunk_sectors - ((sector & (chunk_sectors - 1)) + bio_sectors)) << 9;
 }
 
 static int raid0_run (mddev_t *mddev)
