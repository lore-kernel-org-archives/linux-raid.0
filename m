From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH] md - 2 of 7 - Split read and write end_request handlers
Date: Fri, 06 Feb 2004 16:35:52 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <E1Aoyee-00083M-00@notabene>
References: <20040206162532.30220.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Instead of having a single end_request handler that must
determine whether it was a read or a write request, we have
two separate handlers, which makes each of them easier to follow.

 ----------- Diffstat output ------------
 ./drivers/md/raid1.c |  102 +++++++++++++++++++++++++++++++++------------------
 1 files changed, 66 insertions(+), 36 deletions(-)

diff ./drivers/md/raid1.c~current~ ./drivers/md/raid1.c
--- ./drivers/md/raid1.c~current~	2004-02-06 16:18:22.000000000 +1100
+++ ./drivers/md/raid1.c	2004-02-06 16:18:22.000000000 +1100
@@ -261,7 +261,7 @@ static inline void update_head_pos(int d
 		r1_bio->sector + (r1_bio->master_bio->bi_size >> 9);
 }
 
-static int raid1_end_request(struct bio *bio, unsigned int bytes_done, int error)
+static int raid1_end_read_request(struct bio *bio, unsigned int bytes_done, int error)
 {
 	int uptodate = test_bit(BIO_UPTODATE, &bio->bi_flags);
 	r1bio_t * r1_bio = (r1bio_t *)(bio->bi_private);
@@ -271,13 +271,7 @@ static int raid1_end_request(struct bio 
 	if (bio->bi_size)
 		return 1;
 	
-	if (r1_bio->cmd == READ || r1_bio->cmd == READA)
-		mirror = r1_bio->read_disk;
-	else {
-		for (mirror = 0; mirror < conf->raid_disks; mirror++)
-			if (r1_bio->write_bios[mirror] == bio)
-				break;
-	}
+	mirror = r1_bio->read_disk;
 	/*
 	 * this branch is our 'one mirror IO has finished' event handler:
 	 */
@@ -296,42 +290,78 @@ static int raid1_end_request(struct bio 
 		set_bit(R1BIO_Uptodate, &r1_bio->state);
 
 	update_head_pos(mirror, r1_bio);
-	if ((r1_bio->cmd == READ) || (r1_bio->cmd == READA)) {
-		if (!r1_bio->read_bio)
-			BUG();
+
+	if (!r1_bio->read_bio)
+		BUG();
+	/*
+	 * we have only one bio on the read side
+	 */
+	if (uptodate)
+		raid_end_bio_io(r1_bio);
+	else {
 		/*
-		 * we have only one bio on the read side
+		 * oops, read error:
 		 */
-		if (uptodate)
-			raid_end_bio_io(r1_bio);
-		else {
-			/*
-			 * oops, read error:
-			 */
-			char b[BDEVNAME_SIZE];
-			printk(KERN_ERR "raid1: %s: rescheduling sector %llu\n",
-				bdevname(conf->mirrors[mirror].rdev->bdev,b), (unsigned long long)r1_bio->sector);
-			reschedule_retry(r1_bio);
-		}
-	} else {
+		char b[BDEVNAME_SIZE];
+		printk(KERN_ERR "raid1: %s: rescheduling sector %llu\n",
+		       bdevname(conf->mirrors[mirror].rdev->bdev,b), (unsigned long long)r1_bio->sector);
+		reschedule_retry(r1_bio);
+	}
 
-		if (r1_bio->read_bio)
-			BUG();
+	atomic_dec(&conf->mirrors[mirror].rdev->nr_pending);
+	return 0;
+}
+
+static int raid1_end_write_request(struct bio *bio, unsigned int bytes_done, int error)
+{
+	int uptodate = test_bit(BIO_UPTODATE, &bio->bi_flags);
+	r1bio_t * r1_bio = (r1bio_t *)(bio->bi_private);
+	int mirror;
+	conf_t *conf = mddev_to_conf(r1_bio->mddev);
+
+	if (bio->bi_size)
+		return 1;
+	
+	for (mirror = 0; mirror < conf->raid_disks; mirror++)
+		if (r1_bio->write_bios[mirror] == bio)
+			break;
+
+	/*
+	 * this branch is our 'one mirror IO has finished' event handler:
+	 */
+	if (!uptodate)
+		md_error(r1_bio->mddev, conf->mirrors[mirror].rdev);
+	else
 		/*
-		 * WRITE:
+		 * Set R1BIO_Uptodate in our master bio, so that
+		 * we will return a good error code for to the higher
+		 * levels even if IO on some other mirrored buffer fails.
 		 *
-		 * Let's see if all mirrored write operations have finished
-		 * already.
+		 * The 'master' represents the composite IO operation to
+		 * user-side. So if something waits for IO, then it will
+		 * wait for the 'master' bio.
 		 */
-		if (atomic_dec_and_test(&r1_bio->remaining)) {
-			md_write_end(r1_bio->mddev);
-			raid_end_bio_io(r1_bio);
-		}	
-	}
+		set_bit(R1BIO_Uptodate, &r1_bio->state);
+
+	update_head_pos(mirror, r1_bio);
+
+	if (r1_bio->read_bio)
+		BUG();
+	/*
+	 *
+	 * Let's see if all mirrored write operations have finished
+	 * already.
+	 */
+	if (atomic_dec_and_test(&r1_bio->remaining)) {
+		md_write_end(r1_bio->mddev);
+		raid_end_bio_io(r1_bio);
+	}	
+
 	atomic_dec(&conf->mirrors[mirror].rdev->nr_pending);
 	return 0;
 }
 
+
 /*
  * This routine returns the disk from which the requested read should
  * be done. There is a per-array 'next expected sequential IO' sector
@@ -508,7 +538,7 @@ static int make_request(request_queue_t 
 
 		read_bio->bi_sector = r1_bio->sector + mirror->rdev->data_offset;
 		read_bio->bi_bdev = mirror->rdev->bdev;
-		read_bio->bi_end_io = raid1_end_request;
+		read_bio->bi_end_io = raid1_end_read_request;
 		read_bio->bi_rw = r1_bio->cmd;
 		read_bio->bi_private = r1_bio;
 
@@ -546,7 +576,7 @@ static int make_request(request_queue_t 
 
 		mbio->bi_sector	= r1_bio->sector + conf->mirrors[i].rdev->data_offset;
 		mbio->bi_bdev = conf->mirrors[i].rdev->bdev;
-		mbio->bi_end_io	= raid1_end_request;
+		mbio->bi_end_io	= raid1_end_write_request;
 		mbio->bi_rw = r1_bio->cmd;
 		mbio->bi_private = r1_bio;
 
