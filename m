From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH] MD - 10 of 27 - Pass the correct bdev to md_error
Date: Thu, 18 Jul 2002 23:33:09 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1020718133309.4857@cse.unsw.edu.au>
Return-path: <linux-raid-owner@vger.kernel.org>
To: Linus Torvalds <torvalds@transmeta.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


### Comments for ChangeSet
Pass the correct bdev to md_error

After a call to generic_make_request, bio->bi_bdev can have changed 
(e.g. by a re-mapped like raid0).  So we cannot trust it for reporting
the source of an error.  This patch takes care to find the correct
bdev.




 ----------- Diffstat output ------------
 ./drivers/md/multipath.c         |   12 ++++++++----
 ./drivers/md/raid1.c             |   39 +++++++++++++++++++++------------------
 ./drivers/md/raid5.c             |    4 ++--
 ./include/linux/raid/multipath.h |    1 +
 4 files changed, 32 insertions(+), 24 deletions(-)

--- ./drivers/md/multipath.c	2002/07/18 12:00:37	1.7
+++ ./drivers/md/multipath.c	2002/07/18 12:00:58	1.8
@@ -128,7 +128,8 @@ void multipath_end_request(struct bio *b
 {
 	int uptodate = test_bit(BIO_UPTODATE, &bio->bi_flags);
 	struct multipath_bh * mp_bh = (struct multipath_bh *)(bio->bi_private);
-
+	multipath_conf_t *conf;
+	struct block_device *bdev;
 	if (uptodate) {
 		multipath_end_bh_io(mp_bh, uptodate);
 		return;
@@ -136,9 +137,11 @@ void multipath_end_request(struct bio *b
 	/*
 	 * oops, IO error:
 	 */
-	md_error (mp_bh->mddev, bio->bi_bdev);
+	conf = mddev_to_conf(mp_bh->mddev);
+	bdev = conf->multipaths[mp_bh->path].bdev;
+	md_error (mp_bh->mddev, bdev);
 	printk(KERN_ERR "multipath: %s: rescheduling sector %lu\n", 
-		 bdev_partition_name(bio->bi_bdev), bio->bi_sector);
+		 bdev_partition_name(bdev), bio->bi_sector);
 	multipath_reschedule_retry(mp_bh);
 	return;
 }
@@ -174,7 +177,8 @@ static int multipath_make_request (reque
 	/*
 	 * read balancing logic:
 	 */
-	multipath = conf->multipaths + multipath_read_balance(conf);
+	mp_bh->path = multipath_read_balance(conf);
+	multipath = conf->multipaths + mp_bh->path;
 
 	mp_bh->bio = *bio;
 	mp_bh->bio.bi_bdev = multipath->bdev;
--- ./drivers/md/raid1.c	2002/07/18 11:57:49	1.2
+++ ./drivers/md/raid1.c	2002/07/18 12:00:58	1.3
@@ -251,13 +251,21 @@ static void end_request(struct bio *bio)
 {
 	int uptodate = test_bit(BIO_UPTODATE, &bio->bi_flags);
 	r1bio_t * r1_bio = (r1bio_t *)(bio->bi_private);
-	int i;
-
+	int mirror;
+	conf_t *conf = mddev_to_conf(r1_bio->mddev);
+	
+	if (r1_bio->cmd == READ || r1_bio->cmd == READA)
+		mirror = r1_bio->read_disk;
+	else {
+		for (mirror = 0; mirror < MD_SB_DISKS; mirror++)
+			if (r1_bio->write_bios[mirror] == bio)
+				break;
+	}
 	/*
 	 * this branch is our 'one mirror IO has finished' event handler:
 	 */
 	if (!uptodate)
-		md_error(r1_bio->mddev, bio->bi_bdev);
+		md_error(r1_bio->mddev, conf->mirrors[mirror].bdev);
 	else
 		/*
 		 * Set R1BIO_Uptodate in our master bio, so that
@@ -270,10 +278,10 @@ static void end_request(struct bio *bio)
 		 */
 		set_bit(R1BIO_Uptodate, &r1_bio->state);
 
+	update_head_pos(mirror, r1_bio);
 	if ((r1_bio->cmd == READ) || (r1_bio->cmd == READA)) {
 		if (!r1_bio->read_bio)
 			BUG();
-		update_head_pos(r1_bio->read_disk, r1_bio);
 		/*
 		 * we have only one bio on the read side
 		 */
@@ -295,14 +303,6 @@ static void end_request(struct bio *bio)
 	/*
 	 * WRITE:
 	 *
-	 * First, find the disk this bio belongs to.
-	 */
-	for (i = 0; i < MD_SB_DISKS; i++)
-		if (r1_bio->write_bios[i] == bio) {
-			update_head_pos(i, r1_bio);
-			break;
-		}
-	/*
 	 * Let's see if all mirrored write operations have finished
 	 * already.
 	 */
@@ -911,6 +911,7 @@ static void end_sync_read(struct bio *bi
 {
 	int uptodate = test_bit(BIO_UPTODATE, &bio->bi_flags);
 	r1bio_t * r1_bio = (r1bio_t *)(bio->bi_private);
+	conf_t *conf = mddev_to_conf(r1_bio->mddev);
 
 	if (r1_bio->read_bio != bio)
 		BUG();
@@ -921,7 +922,8 @@ static void end_sync_read(struct bio *bi
 	 * We don't do much here, just schedule handling by raid1d
 	 */
 	if (!uptodate)
-		md_error (r1_bio->mddev, bio->bi_bdev);
+		md_error(r1_bio->mddev,
+			 conf->mirrors[r1_bio->read_disk].bdev);
 	else
 		set_bit(R1BIO_Uptodate, &r1_bio->state);
 	reschedule_retry(r1_bio);
@@ -932,19 +934,20 @@ static void end_sync_write(struct bio *b
 	int uptodate = test_bit(BIO_UPTODATE, &bio->bi_flags);
 	r1bio_t * r1_bio = (r1bio_t *)(bio->bi_private);
 	mddev_t *mddev = r1_bio->mddev;
+	conf_t *conf = mddev_to_conf(mddev);
 	int i;
-
-	if (!uptodate)
-		md_error(mddev, bio->bi_bdev);
+	int mirror=0;
 
 	for (i = 0; i < MD_SB_DISKS; i++)
 		if (r1_bio->write_bios[i] == bio) {
-			update_head_pos(i, r1_bio);
+			mirror = i;
 			break;
 		}
+	if (!uptodate)
+		md_error(mddev, conf->mirrors[mirror].bdev);
+	update_head_pos(mirror, r1_bio);
 
 	if (atomic_dec_and_test(&r1_bio->remaining)) {
-		conf_t *conf = mddev_to_conf(mddev);
 		md_done_sync(mddev, r1_bio->master_bio->bi_size >> 9, uptodate);
 		resume_device(conf);
 		put_buf(r1_bio);
--- ./drivers/md/raid5.c	2002/07/18 12:00:55	1.1
+++ ./drivers/md/raid5.c	2002/07/18 12:00:58	1.2
@@ -371,7 +371,7 @@ static void raid5_end_read_request (stru
 		set_bit(R5_UPTODATE, &sh->dev[i].flags);
 #endif		
 	} else {
-		md_error(conf->mddev, bi->bi_bdev);
+		md_error(conf->mddev, conf->disks[i].bdev);
 		clear_bit(R5_UPTODATE, &sh->dev[i].flags);
 	}
 #if 0
@@ -407,7 +407,7 @@ static void raid5_end_write_request (str
 
 	spin_lock_irqsave(&conf->device_lock, flags);
 	if (!uptodate)
-		md_error(conf->mddev, bi->bi_bdev);
+		md_error(conf->mddev, conf->disks[i].bdev);
 	
 	clear_bit(R5_LOCKED, &sh->dev[i].flags);
 	set_bit(STRIPE_HANDLE, &sh->state);
--- ./include/linux/raid/multipath.h	2002/07/18 12:00:24	1.4
+++ ./include/linux/raid/multipath.h	2002/07/18 12:00:58	1.5
@@ -48,6 +48,7 @@ struct multipath_bh {
 	mddev_t			*mddev;
 	struct bio		*master_bio;
 	struct bio		bio;
+	int			path;
 	struct multipath_bh	*next_mp; /* next for retry */
 };
 #endif
