From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH] md - 2 of 14 - Use new  single page bio splitting for raid0 and linear
Date: Tue, 27 May 2003 13:01:12 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <E19KUi8-0003Gd-00@notabene.cse.unsw.edu.au>
Return-path: <linux-raid-owner@vger.kernel.org>
To: Linus Torvalds <torvalds@transmeta.com>
Cc: linux-raid@vger.kernel.org, Jens Axboe <axboe@suse.de>
List-Id: linux-raid.ids

### Comments for ChangeSet

Sometimes raid0 and linear are required to take a single page bio that
spans two devices.  We use bio_split to split such a bio into two.

The the same time, bio.h is included by linux/raid/md.h so 
we don't included it elsewhere anymore.

We also modify the mergeable_bvec functions to allow a bvec
that doesn't fit if it is the first bvec to be added to
the bio, and be careful never to return a negative length from a 
bvec_mergable funciton.

 ----------- Diffstat output ------------
 ./drivers/md/linear.c            |   31 +++++++++++++++++++++++++++--
 ./drivers/md/md.c                |    1 
 ./drivers/md/multipath.c         |    1 
 ./drivers/md/raid0.c             |   41 ++++++++++++++++++++++++++-------------
 ./drivers/md/raid1.c             |    1 
 ./drivers/md/raid5.c             |    1 
 ./include/linux/raid/md.h        |    1 
 ./include/linux/raid/multipath.h |    1 
 ./include/linux/raid/raid5.h     |    1 
 9 files changed, 58 insertions(+), 21 deletions(-)

diff ./drivers/md/linear.c~current~ ./drivers/md/linear.c
--- ./drivers/md/linear.c~current~	2003-05-27 11:51:05.000000000 +1000
+++ ./drivers/md/linear.c	2003-05-27 11:58:20.000000000 +1000
@@ -20,7 +20,6 @@
 
 #include <linux/raid/md.h>
 #include <linux/slab.h>
-#include <linux/bio.h>
 #include <linux/raid/linear.h>
 
 #define MAJOR_NR MD_MAJOR
@@ -67,7 +66,18 @@ static int linear_mergeable_bvec(request
 	dev0 = which_dev(mddev, bio->bi_sector);
 	maxsectors = (dev0->size << 1) - (bio->bi_sector - (dev0->offset<<1));
 
-	return (maxsectors - bio_sectors) << 9;
+	if (maxsectors < bio_sectors)
+		maxsectors = 0;
+	else
+		maxsectors -= bio_sectors;
+
+	if (maxsectors <= (PAGE_SIZE >> 9 ) && bio_sectors == 0)
+		return biovec->bv_len;
+	/* The bytes available at this offset could be really big,
+	 * so we cap at 2^31 to avoid overflow */
+	if (maxsectors > (1 << (31-9)))
+		return 1<<31;
+	return maxsectors << 9;
 }
 
 static int linear_run (mddev_t *mddev)
@@ -209,6 +219,23 @@ static int linear_make_request (request_
 		bio_io_error(bio, bio->bi_size);
 		return 0;
 	}
+	if (unlikely(bio->bi_sector + (bio->bi_size >> 9) >
+		     (tmp_dev->offset + tmp_dev->size)<<1)) {
+		/* This bio crosses a device boundary, so we have to
+		 * split it.
+		 */
+		struct bio_pair *bp;
+		bp = bio_split(bio, bio_split_pool, 
+			       (bio->bi_sector + (bio->bi_size >> 9) -
+				(tmp_dev->offset + tmp_dev->size))<<1);
+		if (linear_make_request(q, &bp->bio1))
+			generic_make_request(&bp->bio1);
+		if (linear_make_request(q, &bp->bio2))
+			generic_make_request(&bp->bio2);
+		bio_pair_release(bp);
+		return 0;
+	}
+		    
 	bio->bi_bdev = tmp_dev->rdev->bdev;
 	bio->bi_sector = bio->bi_sector - (tmp_dev->offset << 1) + tmp_dev->rdev->data_offset;
 

diff ./drivers/md/md.c~current~ ./drivers/md/md.c
--- ./drivers/md/md.c~current~	2003-05-27 11:51:05.000000000 +1000
+++ ./drivers/md/md.c	2003-05-27 11:58:20.000000000 +1000
@@ -33,7 +33,6 @@
 #include <linux/linkage.h>
 #include <linux/raid/md.h>
 #include <linux/sysctl.h>
-#include <linux/bio.h>
 #include <linux/devfs_fs_kernel.h>
 #include <linux/buffer_head.h> /* for invalidate_bdev */
 #include <linux/suspend.h>

diff ./drivers/md/multipath.c~current~ ./drivers/md/multipath.c
--- ./drivers/md/multipath.c~current~	2003-05-27 11:51:05.000000000 +1000
+++ ./drivers/md/multipath.c	2003-05-27 11:58:20.000000000 +1000
@@ -23,7 +23,6 @@
 #include <linux/slab.h>
 #include <linux/spinlock.h>
 #include <linux/raid/multipath.h>
-#include <linux/bio.h>
 #include <linux/buffer_head.h>
 #include <asm/atomic.h>
 

diff ./drivers/md/raid0.c~current~ ./drivers/md/raid0.c
--- ./drivers/md/raid0.c~current~	2003-05-27 11:51:05.000000000 +1000
+++ ./drivers/md/raid0.c	2003-05-27 11:58:20.000000000 +1000
@@ -20,7 +20,6 @@
 
 #include <linux/module.h>
 #include <linux/raid/raid0.h>
-#include <linux/bio.h>
 
 #define MAJOR_NR MD_MAJOR
 #define MD_DRIVER
@@ -179,15 +178,17 @@ static int create_strip_zones (mddev_t *
 static int raid0_mergeable_bvec(request_queue_t *q, struct bio *bio, struct bio_vec *biovec)
 {
 	mddev_t *mddev = q->queuedata;
-	sector_t sector;
-	unsigned int chunk_sectors;
-	unsigned int bio_sectors;
-
-	chunk_sectors = mddev->chunk_size >> 9;
-	sector = bio->bi_sector;
-	bio_sectors = bio->bi_size >> 9;
-
-	return (chunk_sectors - ((sector & (chunk_sectors - 1)) + bio_sectors)) << 9;
+	sector_t sector = bio->bi_sector;
+	int max;
+	unsigned int chunk_sectors = mddev->chunk_size >> 9;
+	unsigned int bio_sectors = bio->bi_size >> 9;
+
+	max =  (chunk_sectors - ((sector & (chunk_sectors - 1)) + bio_sectors)) << 9;
+	if (max < 0) max = 0; /* bio_add cannot handle a negative return */
+	if (max <= biovec->bv_len && bio_sectors == 0)
+		return biovec->bv_len;
+	else 
+		return max;
 }
 
 static int raid0_run (mddev_t *mddev)
@@ -322,9 +323,23 @@ static int raid0_make_request (request_q
 		hash = conf->hash_table + x;
 	}
 
-	/* Sanity check -- queue functions should prevent this happening */
-	if (unlikely(chunk_size < (block & (chunk_size - 1)) + (bio->bi_size >> 10)))
-		goto bad_map;
+	if (unlikely(chunk_size < (block & (chunk_size - 1)) + (bio->bi_size >> 10))) {
+		struct bio_pair *bp;
+		/* Sanity check -- queue functions should prevent this happening */
+		if (bio->bi_vcnt != 1 ||
+		    bio->bi_idx != 0)
+			goto bad_map;
+		/* This is a one page bio that upper layers
+		 * refuse to split for us, so we need to split it.
+		 */
+		bp = bio_split(bio, bio_split_pool, (chunk_size - (block & (chunk_size - 1)))<<1 );
+		if (raid0_make_request(q, &bp->bio1))
+			generic_make_request(&bp->bio1);
+		if (raid0_make_request(q, &bp->bio2))
+			generic_make_request(&bp->bio2);
+		bio_pair_release(bp);
+		return 0;
+	}
  
 	if (!hash)
 		goto bad_hash;

diff ./drivers/md/raid1.c~current~ ./drivers/md/raid1.c
--- ./drivers/md/raid1.c~current~	2003-05-27 11:51:05.000000000 +1000
+++ ./drivers/md/raid1.c	2003-05-27 11:58:20.000000000 +1000
@@ -23,7 +23,6 @@
  */
 
 #include <linux/raid/raid1.h>
-#include <linux/bio.h>
 
 #define MAJOR_NR MD_MAJOR
 #define MD_DRIVER

diff ./drivers/md/raid5.c~current~ ./drivers/md/raid5.c
--- ./drivers/md/raid5.c~current~	2003-05-27 11:51:05.000000000 +1000
+++ ./drivers/md/raid5.c	2003-05-27 11:58:20.000000000 +1000
@@ -20,7 +20,6 @@
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/raid/raid5.h>
-#include <linux/bio.h>
 #include <linux/highmem.h>
 #include <asm/bitops.h>
 #include <asm/atomic.h>

diff ./include/linux/raid/md.h~current~ ./include/linux/raid/md.h
--- ./include/linux/raid/md.h~current~	2003-05-27 11:51:05.000000000 +1000
+++ ./include/linux/raid/md.h	2003-05-27 11:58:20.000000000 +1000
@@ -40,6 +40,7 @@
 #include <linux/reboot.h>
 #include <linux/vmalloc.h>
 #include <linux/blkpg.h>
+#include <linux/bio.h>
 
 /*
  * 'md_p.h' holds the 'physical' layout of RAID devices

diff ./include/linux/raid/multipath.h~current~ ./include/linux/raid/multipath.h
--- ./include/linux/raid/multipath.h~current~	2003-05-27 11:51:05.000000000 +1000
+++ ./include/linux/raid/multipath.h	2003-05-27 11:58:20.000000000 +1000
@@ -2,7 +2,6 @@
 #define _MULTIPATH_H
 
 #include <linux/raid/md.h>
-#include <linux/bio.h>
 
 struct multipath_info {
 	mdk_rdev_t	*rdev;

diff ./include/linux/raid/raid5.h~current~ ./include/linux/raid/raid5.h
--- ./include/linux/raid/raid5.h~current~	2003-05-27 11:51:05.000000000 +1000
+++ ./include/linux/raid/raid5.h	2003-05-27 11:58:20.000000000 +1000
@@ -3,7 +3,6 @@
 
 #include <linux/raid/md.h>
 #include <linux/raid/xor.h>
-#include <linux/bio.h>
 
 /*
  *
