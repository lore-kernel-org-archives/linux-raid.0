From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH] md -  Fix raid1 oops
Date: Sun, 13 Apr 2003 16:18:45 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <E194apB-0007mb-00@notabene.cse.unsw.edu.au>
Return-path: <linux-raid-owner@vger.kernel.org>
To: Linus Torvalds <torvalds@transmeta.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

### Comments for ChangeSet

From: Angus Sawyer <angus.sawyer@dsl.pipex.com>

When the last device in a raid1 array is failed (or missing) the r1bio
structure can be released (especially on very fast devices) before 
make_request has finished using it.

This patch gets and puts an extra reference to the r1_bio around the 
submission loop, and uses the status in r1_bio to maintain the request status 
if the last refernce is held by make_request.

This is also more correct for write requests, as a write should succeed 
if any write succeeded, not only if the last write succceeded.

 ----------- Diffstat output ------------
 ./drivers/md/raid1.c |   21 ++++++++++++++-------
 1 files changed, 14 insertions(+), 7 deletions(-)

diff ./drivers/md/raid1.c~current~ ./drivers/md/raid1.c
--- ./drivers/md/raid1.c~current~	2003-04-13 16:14:23.000000000 +1000
+++ ./drivers/md/raid1.c	2003-04-13 16:14:24.000000000 +1000
@@ -238,11 +238,12 @@ static void reschedule_retry(r1bio_t *r1
  * operation and are ready to return a success/failure code to the buffer
  * cache layer.
  */
-static void raid_end_bio_io(r1bio_t *r1_bio, int uptodate)
+static void raid_end_bio_io(r1bio_t *r1_bio)
 {
 	struct bio *bio = r1_bio->master_bio;
 
-	bio_endio(bio, bio->bi_size, uptodate ? 0 : -EIO);
+	bio_endio(bio, bio->bi_size,
+		test_bit(R1BIO_Uptodate, &r1_bio->state) ? 0 : -EIO);
 	free_r1bio(r1_bio);
 }
 
@@ -299,7 +300,7 @@ static int end_request(struct bio *bio, 
 		 * we have only one bio on the read side
 		 */
 		if (uptodate)
-			raid_end_bio_io(r1_bio, uptodate);
+			raid_end_bio_io(r1_bio);
 		else {
 			/*
 			 * oops, read error:
@@ -320,7 +321,7 @@ static int end_request(struct bio *bio, 
 		 */
 		if (atomic_dec_and_test(&r1_bio->remaining)) {
 			md_write_end(r1_bio->mddev);
-			raid_end_bio_io(r1_bio, uptodate);
+			raid_end_bio_io(r1_bio);
 		}	
 	}
 	atomic_dec(&conf->mirrors[mirror].rdev->nr_pending);
@@ -542,10 +543,10 @@ static int make_request(request_queue_t 
 		 * then return an IO error:
 		 */
 		md_write_end(mddev);
-		raid_end_bio_io(r1_bio, 0);
+		raid_end_bio_io(r1_bio);
 		return 0;
 	}
-	atomic_set(&r1_bio->remaining, sum_bios);
+	atomic_set(&r1_bio->remaining, sum_bios+1);
 
 	/*
 	 * We have to be a bit careful about the semaphore above, thats
@@ -567,6 +568,12 @@ static int make_request(request_queue_t 
 
 		generic_make_request(mbio);
 	}
+
+	if (atomic_dec_and_test(&r1_bio->remaining)) {
+		md_write_end(mddev);
+		raid_end_bio_io(r1_bio);
+	}
+
 	return 0;
 }
 
@@ -917,7 +924,7 @@ static void raid1d(mddev_t *mddev)
 				" read error for block %llu\n",
 				bdev_partition_name(bio->bi_bdev), 
 				(unsigned long long)r1_bio->sector);
-				raid_end_bio_io(r1_bio, 0);
+				raid_end_bio_io(r1_bio);
 				break;
 			}
 			printk(KERN_ERR "raid1: %s: redirecting sector %llu to"
