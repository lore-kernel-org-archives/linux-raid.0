From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH] md - 2 of 4 - Fix raid1 handling of writing to multiple devices.
Date: Thu, 05 Jun 2003 11:51:41 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <E19Njun-0005Fn-00@notabene.cse.unsw.edu.au>
Return-path: <linux-raid-owner@vger.kernel.org>
To: Linus Torvalds <torvalds@transmeta.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

### Comments for ChangeSet

When raid1 writes, it needs to schedule writes to some number
of devices, and when all writes have completed, the r1_bio
structure that holds it all together must be freed.
However we must make sure not to free it before all devices
have been considered for submitting writes to.

This happens in two places: when submitting a normal write request
and when submiting a write as part of resync.

This patch makes both these places:
  the same
  simpler
  more correct.

 ----------- Diffstat output ------------
 ./drivers/md/raid1.c |   68 +++++++++------------------------------------------
 1 files changed, 12 insertions(+), 56 deletions(-)

diff ./drivers/md/raid1.c~current~ ./drivers/md/raid1.c
--- ./drivers/md/raid1.c~current~	2003-06-02 14:09:36.000000000 +1000
+++ ./drivers/md/raid1.c	2003-06-02 14:09:37.000000000 +1000
@@ -462,7 +462,7 @@ static int make_request(request_queue_t 
 	mirror_info_t *mirror;
 	r1bio_t *r1_bio;
 	struct bio *read_bio;
-	int i, sum_bios = 0, disks = conf->raid_disks;
+	int i, disks = conf->raid_disks;
 
 	/*
 	 * Register the new request and wait if the reconstruction
@@ -525,6 +525,9 @@ static int make_request(request_queue_t 
 			r1_bio->write_bios[i] = NULL;
 	}
 	spin_unlock_irq(&conf->device_lock);
+
+	atomic_set(&r1_bio->remaining, 1);
+	md_write_start(mddev);
 	for (i = 0; i < disks; i++) {
 		struct bio *mbio;
 		if (!r1_bio->write_bios[i])
@@ -539,37 +542,7 @@ static int make_request(request_queue_t 
 		mbio->bi_rw = r1_bio->cmd;
 		mbio->bi_private = r1_bio;
 
-		sum_bios++;
-	}
-	if (!sum_bios) {
-		/*
-		 * If all mirrors are non-operational
-		 * then return an IO error:
-		 */
-		md_write_end(mddev);
-		raid_end_bio_io(r1_bio);
-		return 0;
-	}
-	atomic_set(&r1_bio->remaining, sum_bios+1);
-
-	/*
-	 * We have to be a bit careful about the semaphore above, thats
-	 * why we start the requests separately. Since generic_make_request()
-	 * can sleep, this is the safer solution. Imagine, raid1_end_request
-	 * decreasing the semaphore before we could have set it up ...
-	 * We could play tricks with the semaphore (presetting it and
-	 * correcting at the end if sum_bios is not 'n' but we have to
-	 * do raid1_end_request by hand if all requests finish until we had a
-	 * chance to set up the semaphore correctly ... lots of races).
-	 */
-
-	md_write_start(mddev);
-	for (i=disks; i--; ) {
-		struct bio *mbio;
-		mbio = r1_bio->write_bios[i];
-		if (!mbio)
-			continue;
-
+		atomic_inc(&r1_bio->remaining);
 		generic_make_request(mbio);
 	}
 
@@ -802,7 +775,7 @@ static int end_sync_write(struct bio *bi
 static void sync_request_write(mddev_t *mddev, r1bio_t *r1_bio)
 {
 	conf_t *conf = mddev_to_conf(mddev);
-	int i, sum_bios = 0;
+	int i;
 	int disks = conf->raid_disks;
 	struct bio *bio, *mbio;
 
@@ -849,7 +822,8 @@ static void sync_request_write(mddev_t *
 	}
 	spin_unlock_irq(&conf->device_lock);
 
-	for (i = 0; i < disks ; i++) {
+	atomic_set(&r1_bio->remaining, 1);
+	for (i = disks; i-- ; ) {
 		if (!r1_bio->write_bios[i])
 			continue;
 		mbio = bio_clone(bio, GFP_NOIO);
@@ -860,32 +834,14 @@ static void sync_request_write(mddev_t *
 		mbio->bi_rw = WRITE;
 		mbio->bi_private = r1_bio;
 
-		sum_bios++;
+		atomic_inc(&r1_bio->remaining);
+		md_sync_acct(conf->mirrors[i].rdev, mbio->bi_size >> 9);
+		generic_make_request(mbio);
 	}
-	if (i != disks)
-		BUG();
-	atomic_set(&r1_bio->remaining, sum_bios);
 
-
-	if (!sum_bios) {
-		/*
-		 * Nowhere to write this to... I guess we
-		 * must be done
-		 */
-		printk(KERN_ALERT "raid1: sync aborting as there is nowhere"
-			" to write sector %llu\n", 
-			(unsigned long long)r1_bio->sector);
+	if (atomic_dec_and_test(&r1_bio->remaining)) {
 		md_done_sync(mddev, r1_bio->master_bio->bi_size >> 9, 0);
 		put_buf(r1_bio);
-		return;
-	}
-	for (i = 0; i < disks ; i++) {
-		mbio = r1_bio->write_bios[i];
-		if (!mbio)
-			continue;
-
-		md_sync_acct(conf->mirrors[i].rdev, mbio->bi_size >> 9);
-		generic_make_request(mbio);
 	}
 }
 
