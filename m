From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH] md - 10 of 12 - Allow components of MD raid array to have data start at offset from start of device.
Date: Wed, 12 Mar 2003 14:59:38 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <E18sxP0-0004qM-00@notabene.cse.unsw.edu.au>
Return-path: <linux-raid-owner@vger.kernel.org>
To: Linus Torvalds <torvalds@transmeta.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


### Comments for ChangeSet

Normally the data stored on a component of a RAID array is stored 
from the start of the device.  This patch allows a per-device
data_offset so the data can start elsewhere. This will allow
RAID arrays where the metadata is at the head of the device
rather than the tail.

 ----------- Diffstat output ------------
 ./drivers/md/linear.c       |    2 +-
 ./drivers/md/md.c           |    2 ++
 ./drivers/md/raid0.c        |    2 +-
 ./drivers/md/raid1.c        |   10 +++++-----
 ./drivers/md/raid5.c        |    2 +-
 ./include/linux/raid/md_k.h |    1 +
 6 files changed, 11 insertions(+), 8 deletions(-)

diff ./drivers/md/linear.c~current~ ./drivers/md/linear.c
--- ./drivers/md/linear.c~current~	2003-03-12 13:46:21.000000000 +1100
+++ ./drivers/md/linear.c	2003-03-12 13:46:36.000000000 +1100
@@ -203,7 +203,7 @@ static int linear_make_request (request_
 		return 0;
 	}
 	bio->bi_bdev = tmp_dev->rdev->bdev;
-	bio->bi_sector = bio->bi_sector - (tmp_dev->offset << 1);
+	bio->bi_sector = bio->bi_sector - (tmp_dev->offset << 1) + tmp_dev->rdev->data_offset;
 
 	return 1;
 }

diff ./drivers/md/md.c~current~ ./drivers/md/md.c
--- ./drivers/md/md.c~current~	2003-03-12 13:46:25.000000000 +1100
+++ ./drivers/md/md.c	2003-03-12 13:46:36.000000000 +1100
@@ -555,6 +555,7 @@ static int super_90_load(mdk_rdev_t *rde
 	}
 
 	rdev->preferred_minor = sb->md_minor;
+	rdev->data_offset = 0;
 
 	if (refdev == 0)
 		ret = 1;
@@ -1137,6 +1138,7 @@ static mdk_rdev_t *md_import_device(dev_
 	rdev->desc_nr = -1;
 	rdev->faulty = 0;
 	rdev->in_sync = 0;
+	rdev->data_offset = 0;
 	atomic_set(&rdev->nr_pending, 0);
 
 	size = rdev->bdev->bd_inode->i_size >> BLOCK_SIZE_BITS;

diff ./drivers/md/raid0.c~current~ ./drivers/md/raid0.c
--- ./drivers/md/raid0.c~current~	2003-03-12 13:46:21.000000000 +1100
+++ ./drivers/md/raid0.c	2003-03-12 13:46:36.000000000 +1100
@@ -349,7 +349,7 @@ static int raid0_make_request (request_q
 	 * is the only IO operation happening on this bh.
 	 */
 	bio->bi_bdev = tmp_dev->bdev;
-	bio->bi_sector = rsect;
+	bio->bi_sector = rsect + tmp_dev->data_offset;
 
 	/*
 	 * Let the main block layer submit the IO and resolve recursion:

diff ./drivers/md/raid1.c~current~ ./drivers/md/raid1.c
--- ./drivers/md/raid1.c~current~	2003-03-12 13:46:21.000000000 +1100
+++ ./drivers/md/raid1.c	2003-03-12 13:46:36.000000000 +1100
@@ -493,7 +493,7 @@ static int make_request(request_queue_t 
 			BUG();
 		r1_bio->read_bio = read_bio;
 
-		read_bio->bi_sector = r1_bio->sector;
+		read_bio->bi_sector = r1_bio->sector + mirror->rdev->data_offset;
 		read_bio->bi_bdev = mirror->rdev->bdev;
 		read_bio->bi_end_io = end_request;
 		read_bio->bi_rw = r1_bio->cmd;
@@ -528,7 +528,7 @@ static int make_request(request_queue_t 
 		mbio = bio_clone(bio, GFP_NOIO);
 		r1_bio->write_bios[i] = mbio;
 
-		mbio->bi_sector	= r1_bio->sector;
+		mbio->bi_sector	= r1_bio->sector + conf->mirrors[i].rdev->data_offset;
 		mbio->bi_bdev = conf->mirrors[i].rdev->bdev;
 		mbio->bi_end_io	= end_request;
 		mbio->bi_rw = r1_bio->cmd;
@@ -856,7 +856,7 @@ static void sync_request_write(mddev_t *
 		mbio = bio_clone(bio, GFP_NOIO);
 		r1_bio->write_bios[i] = mbio;
 		mbio->bi_bdev = conf->mirrors[i].rdev->bdev;
-		mbio->bi_sector = r1_bio->sector;
+		mbio->bi_sector = r1_bio->sector | conf->mirrors[i].rdev->data_offset;
 		mbio->bi_end_io	= end_sync_write;
 		mbio->bi_rw = WRITE;
 		mbio->bi_private = r1_bio;
@@ -934,7 +934,7 @@ static void raid1d(mddev_t *mddev)
 			printk(REDIRECT_SECTOR,
 				bdev_partition_name(rdev->bdev), (unsigned long long)r1_bio->sector);
 			bio->bi_bdev = rdev->bdev;
-			bio->bi_sector = r1_bio->sector;
+			bio->bi_sector = r1_bio->sector + rdev->data_offset;
 			bio->bi_rw = r1_bio->cmd;
 
 			generic_make_request(bio);
@@ -1045,7 +1045,7 @@ static int sync_request(mddev_t *mddev, 
 
 	read_bio = bio_clone(r1_bio->master_bio, GFP_NOIO);
 
-	read_bio->bi_sector = sector_nr;
+	read_bio->bi_sector = sector_nr + mirror->rdev->data_offset;
 	read_bio->bi_bdev = mirror->rdev->bdev;
 	read_bio->bi_end_io = end_sync_read;
 	read_bio->bi_rw = READ;

diff ./drivers/md/raid5.c~current~ ./drivers/md/raid5.c
--- ./drivers/md/raid5.c~current~	2003-03-12 13:46:21.000000000 +1100
+++ ./drivers/md/raid5.c	2003-03-12 13:46:36.000000000 +1100
@@ -1206,7 +1206,7 @@ static void handle_stripe(struct stripe_
 			bi->bi_bdev = rdev->bdev;
 			PRINTK("for %llu schedule op %ld on disc %d\n", (unsigned long long)sh->sector, bi->bi_rw, i);
 			atomic_inc(&sh->count);
-			bi->bi_sector = sh->sector;
+			bi->bi_sector = sh->sector + rdev->data_offset;
 			bi->bi_flags = 1 << BIO_UPTODATE;
 			bi->bi_vcnt = 1;	
 			bi->bi_idx = 0;

diff ./include/linux/raid/md_k.h~current~ ./include/linux/raid/md_k.h
--- ./include/linux/raid/md_k.h~current~	2003-03-12 13:46:21.000000000 +1100
+++ ./include/linux/raid/md_k.h	2003-03-12 13:46:36.000000000 +1100
@@ -155,6 +155,7 @@ struct mdk_rdev_s
 
 	struct page	*sb_page;
 	int		sb_loaded;
+	sector_t	data_offset;	/* start of data in array */
 	sector_t	sb_offset;
 	int		preferred_minor;	/* autorun support */
 
