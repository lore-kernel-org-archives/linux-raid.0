From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH] md - 1 of 6 - Split single page bios for raid0 and linear
Date: Thu, 08 May 2003 11:39:43 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <E19DaNq-0004uZ-00@notabene.cse.unsw.edu.au>
Return-path: <linux-raid-owner@vger.kernel.org>
To: Linus Torvalds <torvalds@transmeta.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This set of 6 patches for the 'md' driver in 2.5:
 - adds support for splitting awkward bios (at last)
 - fixes a couple of tiny bugs - r1 and md
 - removes vmalloc use  from raid0
 - changes raid0 address mapping so the a large kmalloc is
   never needed
 - allows a half-built array to be stoped even when there are multiple
   users, which can be needed when "raidstart" is used.

NeilBrown

### Comments for ChangeSet
Sometimes raid0 and linear are required to take a single page bio that
spans two devices.  We define (in fs/bio.c) bio_split which will split
one of these into two requests.

The the same time, bio.h is included by linux/raid/md.h so 
we don't included it elsewhere anymore.

We also modify the mergeable_bvec functions to allow a bvec
that doesn't fit if it is the first bvec to be added to
the bio, and be careful never to return a negative length from a 
bvec_mergable funciton.

 ----------- Diffstat output ------------
 ./drivers/md/linear.c            |   41 ++++++++++++++++-
 ./drivers/md/md.c                |    1 
 ./drivers/md/multipath.c         |    1 
 ./drivers/md/raid0.c             |   51 ++++++++++++++++------
 ./drivers/md/raid1.c             |    1 
 ./drivers/md/raid5.c             |    1 
 ./fs/bio.c                       |   89 +++++++++++++++++++++++++++++++++++++++
 ./include/linux/bio.h            |   24 ++++++++++
 ./include/linux/raid/linear.h    |    1 
 ./include/linux/raid/md.h        |    1 
 ./include/linux/raid/multipath.h |    1 
 ./include/linux/raid/raid0.h     |    1 
 ./include/linux/raid/raid5.h     |    1 
 13 files changed, 191 insertions(+), 23 deletions(-)

diff ./drivers/md/linear.c~current~ ./drivers/md/linear.c
--- ./drivers/md/linear.c~current~	2003-04-30 11:12:42.000000000 +1000
+++ ./drivers/md/linear.c	2003-04-30 10:47:00.000000000 +1000
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
@@ -85,6 +95,10 @@ static int linear_run (mddev_t *mddev)
 	memset(conf, 0, sizeof(*conf));
 	mddev->private = conf;
 
+	conf->pool = bio_pair_pool(8);
+	if (!conf->pool)
+		goto out;
+
 	/*
 	 * Find the smallest device.
 	 */
@@ -166,8 +180,11 @@ static int linear_run (mddev_t *mddev)
 	return 0;
 
 out:
-	if (conf)
+	if (conf) {
+		if (conf->pool)
+			mempool_destroy(conf->pool);
 		kfree(conf);
+	}
 	return 1;
 }
 
@@ -175,6 +192,7 @@ static int linear_stop (mddev_t *mddev)
 {
 	linear_conf_t *conf = mddev_to_conf(mddev);
   
+	mempool_destroy(conf->pool);
 	kfree(conf->hash_table);
 	kfree(conf);
 
@@ -209,6 +227,23 @@ static int linear_make_request (request_
 		bio_io_error(bio, bio->bi_size);
 		return 0;
 	}
+	if (unlikely(bio->bi_sector + (bio->bi_size >> 9) >
+		     (tmp_dev->offset + tmp_dev->size)<<1)) {
+		/* This bio crosses a device boundary, so we have to
+		 * split it.
+		 */
+		struct bio_pair *bp;
+		bp = bio_split(bio, mddev_to_conf(mddev)->pool, 
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
--- ./drivers/md/md.c~current~	2003-04-30 11:12:42.000000000 +1000
+++ ./drivers/md/md.c	2003-04-30 10:41:49.000000000 +1000
@@ -33,7 +33,6 @@
 #include <linux/linkage.h>
 #include <linux/raid/md.h>
 #include <linux/sysctl.h>
-#include <linux/bio.h>
 #include <linux/devfs_fs_kernel.h>
 #include <linux/buffer_head.h> /* for invalidate_bdev */
 #include <linux/suspend.h>

diff ./drivers/md/multipath.c~current~ ./drivers/md/multipath.c
--- ./drivers/md/multipath.c~current~	2003-04-30 11:12:42.000000000 +1000
+++ ./drivers/md/multipath.c	2003-04-30 10:37:48.000000000 +1000
@@ -23,7 +23,6 @@
 #include <linux/slab.h>
 #include <linux/spinlock.h>
 #include <linux/raid/multipath.h>
-#include <linux/bio.h>
 #include <linux/buffer_head.h>
 #include <asm/atomic.h>
 

diff ./drivers/md/raid0.c~current~ ./drivers/md/raid0.c
--- ./drivers/md/raid0.c~current~	2003-04-30 11:12:42.000000000 +1000
+++ ./drivers/md/raid0.c	2003-04-30 10:38:24.000000000 +1000
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
@@ -204,8 +205,11 @@ static int raid0_run (mddev_t *mddev)
 		goto out;
 	mddev->private = (void *)conf;
  
-	if (create_strip_zones (mddev)) 
+	conf->pool = bio_pair_pool(64);
+	if (!conf->pool)
 		goto out_free_conf;
+	if (create_strip_zones (mddev)) 
+		goto out_free_pool;
 
 	/* calculate array device size */
 	mddev->array_size = 0;
@@ -276,6 +280,9 @@ out_free_zone_conf:
 	vfree(conf->strip_zone);
 	conf->strip_zone = NULL;
 
+ out_free_pool:
+	mempool_destroy(conf->pool);
+
 out_free_conf:
 	vfree(conf);
 	mddev->private = NULL;
@@ -291,6 +298,8 @@ static int raid0_stop (mddev_t *mddev)
 	conf->hash_table = NULL;
 	vfree (conf->strip_zone);
 	conf->strip_zone = NULL;
+	if (conf->pool)
+		mempool_destroy(conf->pool);
 	vfree (conf);
 	mddev->private = NULL;
 
@@ -322,9 +331,23 @@ static int raid0_make_request (request_q
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
+		bp = bio_split(bio, conf->pool, (chunk_size - (block & (chunk_size - 1)))<<1 );
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
--- ./drivers/md/raid1.c~current~	2003-04-30 11:12:42.000000000 +1000
+++ ./drivers/md/raid1.c	2003-04-30 10:37:48.000000000 +1000
@@ -23,7 +23,6 @@
  */
 
 #include <linux/raid/raid1.h>
-#include <linux/bio.h>
 
 #define MAJOR_NR MD_MAJOR
 #define MD_DRIVER

diff ./drivers/md/raid5.c~current~ ./drivers/md/raid5.c
--- ./drivers/md/raid5.c~current~	2003-04-30 11:12:42.000000000 +1000
+++ ./drivers/md/raid5.c	2003-04-30 10:37:48.000000000 +1000
@@ -20,7 +20,6 @@
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/raid/raid5.h>
-#include <linux/bio.h>
 #include <linux/highmem.h>
 #include <asm/bitops.h>
 #include <asm/atomic.h>

diff ./fs/bio.c~current~ ./fs/bio.c
--- ./fs/bio.c~current~	2003-04-30 11:12:42.000000000 +1000
+++ ./fs/bio.c	2003-04-30 10:41:24.000000000 +1000
@@ -733,6 +733,95 @@ void bio_endio(struct bio *bio, unsigned
 		bio->bi_end_io(bio, bytes_done, error);
 }
 
+
+/*
+ * split a bio - only worry about a bio with a single page
+ * in it's iovec
+ */
+
+static void *bio_pair_alloc(int gfp_flags, void *data)
+{
+	struct bio_pair *bp;
+	bp = kmalloc(sizeof(*bp), gfp_flags);
+	return bp;
+}
+static void bio_pair_free(void *bp, void *data)
+{
+	kfree(bp);
+}
+
+mempool_t *bio_pair_pool(int n)
+{
+	return mempool_create(n, bio_pair_alloc,
+			      bio_pair_free, NULL);
+}
+EXPORT_SYMBOL(bio_pair_pool);
+
+
+void bio_pair_release(struct bio_pair *bp)
+{
+	if (atomic_dec_and_test(&bp->cnt)) {
+		struct bio *master = bp->bio1.bi_private;
+		bio_endio(master, master->bi_size, bp->error);
+		mempool_free(bp, bp->bio2.bi_private);
+	}
+}
+EXPORT_SYMBOL(bio_pair_release);
+
+static int bio_pair_end_1(struct bio * bi, unsigned int done, int err)
+{
+	struct bio_pair *bp = container_of(bi, struct bio_pair, bio1);
+	if (bi->bi_size) return 1;
+	if (err) bp->error = err;
+	bio_pair_release(bp);
+	return 0;
+}
+
+static int bio_pair_end_2(struct bio * bi, unsigned int done, int err)
+{
+	struct bio_pair *bp = container_of(bi, struct bio_pair, bio2);
+	if (bi->bi_size) return 1;
+	if (err) bp->error = err;
+	bio_pair_release(bp);
+	return 0;
+}
+
+struct bio_pair *bio_split(struct bio *bi, mempool_t *pool, int first_sectors)
+{
+	struct bio_pair *bp = mempool_alloc(pool, GFP_NOIO);
+	if (!bp)
+		return bp;
+
+	BUG_ON(bi->bi_vcnt != 1);
+	BUG_ON(bi->bi_idx != 0);
+	atomic_set(&bp->cnt, 3);
+	bp->error = 0;
+	bp->bio1 = *bi;
+	bp->bio2 = *bi;
+	bp->bio2.bi_sector += first_sectors;
+	bp->bio2.bi_size -= first_sectors << 9;
+	bp->bio1.bi_size = first_sectors << 9;
+
+	bp->bv1 = bi->bi_io_vec[0];
+	bp->bv2 = bi->bi_io_vec[0];
+	bp->bv2.bv_offset += first_sectors << 9;
+	bp->bv2.bv_len -= first_sectors << 9;
+	bp->bv1.bv_len = first_sectors << 9;
+
+	bp->bio1.bi_io_vec = &bp->bv1;
+	bp->bio2.bi_io_vec = &bp->bv2;
+
+	bp->bio1.bi_end_io = bio_pair_end_1;
+	bp->bio2.bi_end_io = bio_pair_end_2;
+
+	bp->bio1.bi_private = bi;
+	bp->bio2.bi_private = pool;
+	return bp;
+}
+EXPORT_SYMBOL(bio_split);
+/* End bio-splitting code */
+
+
 static void __init biovec_init_pools(void)
 {
 	int i, size, megabytes, pool_entries = BIO_POOL_SIZE;

diff ./include/linux/bio.h~current~ ./include/linux/bio.h
--- ./include/linux/bio.h~current~	2003-04-30 11:12:42.000000000 +1000
+++ ./include/linux/bio.h	2003-04-30 11:12:52.000000000 +1000
@@ -22,6 +22,7 @@
 
 #include <linux/kdev_t.h>
 #include <linux/highmem.h>
+#include <linux/mempool.h>
 
 /* Platforms may set this to teach the BIO layer about IOMMU hardware. */
 #include <asm/io.h>
@@ -201,6 +202,29 @@ struct bio {
  */
 #define bio_get(bio)	atomic_inc(&(bio)->bi_cnt)
 
+
+/*
+ * A bio_pair is used when we need to split a bio.
+ * This can only happen for a bio that refers to just one
+ * page of data, and in the unusual situation when the
+ * page crosses a chunk/device boundary
+ *
+ * The address of the master bio is stored in bio1.bi_private
+ * The address of the pool the pair was allocated from is stored
+ *   in bio2.bi_private
+ */
+struct bio_pair {
+	struct bio	bio1, bio2;
+	struct bio_vec	bv1, bv2;
+	atomic_t	cnt;
+	int		error;
+};
+extern struct bio_pair *bio_split(struct bio *bi, mempool_t *pool,
+				  int first_sectors);
+extern void bio_pair_release(struct bio_pair *dbio);
+extern mempool_t *bio_pair_pool(int n);
+
+
 extern struct bio *bio_alloc(int, int);
 extern void bio_put(struct bio *);
 

diff ./include/linux/raid/linear.h~current~ ./include/linux/raid/linear.h
--- ./include/linux/raid/linear.h~current~	2003-04-30 11:12:42.000000000 +1000
+++ ./include/linux/raid/linear.h	2003-04-30 10:37:48.000000000 +1000
@@ -22,6 +22,7 @@ struct linear_private_data
 	dev_info_t		disks[MD_SB_DISKS];
 	dev_info_t		*smallest;
 	int			nr_zones;
+	mempool_t		*pool;
 };
 
 

diff ./include/linux/raid/md.h~current~ ./include/linux/raid/md.h
--- ./include/linux/raid/md.h~current~	2003-04-30 11:12:42.000000000 +1000
+++ ./include/linux/raid/md.h	2003-04-30 10:37:48.000000000 +1000
@@ -40,6 +40,7 @@
 #include <linux/reboot.h>
 #include <linux/vmalloc.h>
 #include <linux/blkpg.h>
+#include <linux/bio.h>
 
 /*
  * 'md_p.h' holds the 'physical' layout of RAID devices

diff ./include/linux/raid/multipath.h~current~ ./include/linux/raid/multipath.h
--- ./include/linux/raid/multipath.h~current~	2003-04-30 11:12:42.000000000 +1000
+++ ./include/linux/raid/multipath.h	2003-04-30 10:37:48.000000000 +1000
@@ -2,7 +2,6 @@
 #define _MULTIPATH_H
 
 #include <linux/raid/md.h>
-#include <linux/bio.h>
 
 struct multipath_info {
 	mdk_rdev_t	*rdev;

diff ./include/linux/raid/raid0.h~current~ ./include/linux/raid/raid0.h
--- ./include/linux/raid/raid0.h~current~	2003-04-30 11:12:42.000000000 +1000
+++ ./include/linux/raid/raid0.h	2003-04-30 10:37:48.000000000 +1000
@@ -24,6 +24,7 @@ struct raid0_private_data
 	int nr_strip_zones;
 	struct strip_zone *smallest;
 	int nr_zones;
+	mempool_t	*pool;
 };
 
 typedef struct raid0_private_data raid0_conf_t;

diff ./include/linux/raid/raid5.h~current~ ./include/linux/raid/raid5.h
--- ./include/linux/raid/raid5.h~current~	2003-04-30 11:12:42.000000000 +1000
+++ ./include/linux/raid/raid5.h	2003-04-30 10:37:48.000000000 +1000
@@ -3,7 +3,6 @@
 
 #include <linux/raid/md.h>
 #include <linux/raid/xor.h>
-#include <linux/bio.h>
 
 /*
  *
