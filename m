From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH] md - 3 of 7 - Discard the cmd field from r1_bio structure
Date: Fri, 06 Feb 2004 16:35:52 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <E1Aoyee-00083V-00@notabene>
References: <20040206162532.30220.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


The only time it is really needed is to differentiate a retry-on-fail
from a write-after-read-for-resync request to raid1d.
So we use a bit in 'state' for that.

 ----------- Diffstat output ------------
 ./drivers/md/raid1.c         |   43 +++++++++++++++++++------------------------
 ./include/linux/raid/raid1.h |    5 ++---
 2 files changed, 21 insertions(+), 27 deletions(-)

diff ./drivers/md/raid1.c~current~ ./drivers/md/raid1.c
--- ./drivers/md/raid1.c~current~	2004-02-06 16:18:22.000000000 +1100
+++ ./drivers/md/raid1.c	2004-02-06 16:18:52.000000000 +1100
@@ -523,9 +523,8 @@ static int make_request(request_queue_t 
 
 	r1_bio->mddev = mddev;
 	r1_bio->sector = bio->bi_sector;
-	r1_bio->cmd = bio_data_dir(bio);
 
-	if (r1_bio->cmd == READ) {
+	if (bio_data_dir(bio) == READ) {
 		/*
 		 * read balancing logic:
 		 */
@@ -539,7 +538,7 @@ static int make_request(request_queue_t 
 		read_bio->bi_sector = r1_bio->sector + mirror->rdev->data_offset;
 		read_bio->bi_bdev = mirror->rdev->bdev;
 		read_bio->bi_end_io = raid1_end_read_request;
-		read_bio->bi_rw = r1_bio->cmd;
+		read_bio->bi_rw = READ;
 		read_bio->bi_private = r1_bio;
 
 		generic_make_request(read_bio);
@@ -577,7 +576,7 @@ static int make_request(request_queue_t 
 		mbio->bi_sector	= r1_bio->sector + conf->mirrors[i].rdev->data_offset;
 		mbio->bi_bdev = conf->mirrors[i].rdev->bdev;
 		mbio->bi_end_io	= raid1_end_write_request;
-		mbio->bi_rw = r1_bio->cmd;
+		mbio->bi_rw = WRITE;
 		mbio->bi_private = r1_bio;
 
 		atomic_inc(&r1_bio->remaining);
@@ -926,30 +925,26 @@ static void raid1d(mddev_t *mddev)
 		mddev = r1_bio->mddev;
 		conf = mddev_to_conf(mddev);
 		bio = r1_bio->master_bio;
-		switch(r1_bio->cmd) {
-		case SPECIAL:
+		if (test_bit(R1BIO_IsSync, &r1_bio->state)) {
 			sync_request_write(mddev, r1_bio);
-			break;
-		case READ:
-		case READA:
+		} else {
 			if (map(mddev, &rdev) == -1) {
 				printk(KERN_ALERT "raid1: %s: unrecoverable I/O"
-				" read error for block %llu\n",
-				bdevname(bio->bi_bdev,b),
-				(unsigned long long)r1_bio->sector);
+				       " read error for block %llu\n",
+				       bdevname(bio->bi_bdev,b),
+				       (unsigned long long)r1_bio->sector);
 				raid_end_bio_io(r1_bio);
-				break;
-			}
-			printk(KERN_ERR "raid1: %s: redirecting sector %llu to"
-				" another mirror\n",
-				bdevname(rdev->bdev,b),
-				(unsigned long long)r1_bio->sector);
-			bio->bi_bdev = rdev->bdev;
-			bio->bi_sector = r1_bio->sector + rdev->data_offset;
-			bio->bi_rw = r1_bio->cmd;
+			} else {
+				printk(KERN_ERR "raid1: %s: redirecting sector %llu to"
+				       " another mirror\n",
+				       bdevname(rdev->bdev,b),
+				       (unsigned long long)r1_bio->sector);
+				bio->bi_bdev = rdev->bdev;
+				bio->bi_sector = r1_bio->sector + rdev->data_offset;
+				bio->bi_rw = READ;
 
-			generic_make_request(bio);
-			break;
+				generic_make_request(bio);
+			}
 		}
 	}
 	spin_unlock_irqrestore(&retry_list_lock, flags);
@@ -1037,7 +1032,7 @@ static int sync_request(mddev_t *mddev, 
 
 	r1_bio->mddev = mddev;
 	r1_bio->sector = sector_nr;
-	r1_bio->cmd = SPECIAL;
+	set_bit(R1BIO_IsSync, &r1_bio->state);
 	r1_bio->read_disk = disk;
 
 	bio = r1_bio->master_bio;

diff ./include/linux/raid/raid1.h~current~ ./include/linux/raid/raid1.h
--- ./include/linux/raid/raid1.h~current~	2004-02-06 16:18:52.000000000 +1100
+++ ./include/linux/raid/raid1.h	2004-02-06 16:18:52.000000000 +1100
@@ -54,7 +54,6 @@ struct r1bio_s {
 	atomic_t		remaining; /* 'have we finished' count,
 					    * used from IRQ handlers
 					    */
-	int			cmd;
 	sector_t		sector;
 	unsigned long		state;
 	mddev_t			*mddev;
@@ -78,6 +77,6 @@ struct r1bio_s {
 };
 
 /* bits for r1bio.state */
-#define	R1BIO_Uptodate	1
-
+#define	R1BIO_Uptodate	0
+#define	R1BIO_IsSync	1
 #endif
