From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH md 2 of 4] Assorted minor md/raid1 fixes
Date: Mon, 23 Aug 2004 13:10:27 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <E1Bz5E3-0005Bx-9j@notabene.cse.unsw.edu.au>
References: <20040823130657.19914.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


1/ rationalise read_balance and "map" in raid1.  Discard map and 
   tidyup the interface to read_balance so it can be used instead.

2/ use offsetof rather than a caclulation to find the size of an
   structure with a var-length array at the end.

3/ remove some meaningless #defines 

4/ use printk_ratelimit to limit reports of failed sectors being redirected.

Signed-off-by: Neil Brown <neilb@cse.unsw.edu.au>

### Diffstat output
 ./drivers/md/raid1.c |   89 ++++++++++++++++++++-------------------------------
 1 files changed, 36 insertions(+), 53 deletions(-)

diff ./drivers/md/raid1.c~current~ ./drivers/md/raid1.c
--- ./drivers/md/raid1.c~current~	2004-08-23 12:20:59.000000000 +1000
+++ ./drivers/md/raid1.c	2004-08-23 12:31:36.000000000 +1000
@@ -24,10 +24,6 @@
 
 #include <linux/raid/raid1.h>
 
-#define MAJOR_NR MD_MAJOR
-#define MD_DRIVER
-#define MD_PERSONALITY
-
 /*
  * Number of guaranteed r1bios in case of extreme VM load:
  */
@@ -44,13 +40,12 @@ static void * r1bio_pool_alloc(int gfp_f
 {
 	struct pool_info *pi = data;
 	r1bio_t *r1_bio;
+	int size = offsetof(r1bio_t, bios[pi->raid_disks]);
 
 	/* allocate a r1bio with room for raid_disks entries in the bios array */
-	r1_bio = kmalloc(sizeof(r1bio_t) + sizeof(struct bio*)*pi->raid_disks,
-			 gfp_flags);
+	r1_bio = kmalloc(size, gfp_flags);
 	if (r1_bio)
-		memset(r1_bio, 0, sizeof(*r1_bio) +
-			       sizeof(struct bio*) * pi->raid_disks);
+		memset(r1_bio, 0, size);
 	else
 		unplug_slaves(pi->mddev);
 
@@ -104,7 +99,7 @@ static void * r1buf_pool_alloc(int gfp_f
 		bio->bi_io_vec[i].bv_page = page;
 	}
 
-	r1_bio->master_bio = bio;
+	r1_bio->master_bio = NULL;
 
 	return r1_bio;
 
@@ -189,32 +184,6 @@ static inline void put_buf(r1bio_t *r1_b
 	spin_unlock_irqrestore(&conf->resync_lock, flags);
 }
 
-static int map(mddev_t *mddev, mdk_rdev_t **rdevp)
-{
-	conf_t *conf = mddev_to_conf(mddev);
-	int i, disks = conf->raid_disks;
-
-	/*
-	 * Later we do read balancing on the read side
-	 * now we use the first available disk.
-	 */
-
-	spin_lock_irq(&conf->device_lock);
-	for (i = 0; i < disks; i++) {
-		mdk_rdev_t *rdev = conf->mirrors[i].rdev;
-		if (rdev && rdev->in_sync) {
-			*rdevp = rdev;
-			atomic_inc(&rdev->nr_pending);
-			spin_unlock_irq(&conf->device_lock);
-			return i;
-		}
-	}
-	spin_unlock_irq(&conf->device_lock);
-
-	printk(KERN_ERR "raid1_map(): huh, no more operational devices?\n");
-	return -1;
-}
-
 static void reschedule_retry(r1bio_t *r1_bio)
 {
 	unsigned long flags;
@@ -292,8 +261,9 @@ static int raid1_end_read_request(struct
 		 * oops, read error:
 		 */
 		char b[BDEVNAME_SIZE];
-		printk(KERN_ERR "raid1: %s: rescheduling sector %llu\n",
-		       bdevname(conf->mirrors[mirror].rdev->bdev,b), (unsigned long long)r1_bio->sector);
+		if (printk_ratelimit())
+			printk(KERN_ERR "raid1: %s: rescheduling sector %llu\n",
+			       bdevname(conf->mirrors[mirror].rdev->bdev,b), (unsigned long long)r1_bio->sector);
 		reschedule_retry(r1_bio);
 	}
 
@@ -363,11 +333,11 @@ static int raid1_end_write_request(struc
  *
  * The rdev for the device selected will have nr_pending incremented.
  */
-static int read_balance(conf_t *conf, struct bio *bio, r1bio_t *r1_bio)
+static int read_balance(conf_t *conf, r1bio_t *r1_bio)
 {
 	const unsigned long this_sector = r1_bio->sector;
 	int new_disk = conf->last_used, disk = new_disk;
-	const int sectors = bio->bi_size >> 9;
+	const int sectors = r1_bio->sectors;
 	sector_t new_distance, current_distance;
 
 	spin_lock_irq(&conf->device_lock);
@@ -378,14 +348,14 @@ static int read_balance(conf_t *conf, st
 	 */
 	if (conf->mddev->recovery_cp < MaxSector &&
 	    (this_sector + sectors >= conf->next_resync)) {
-		/* make sure that disk is operational */
+		/* Choose the first operation device, for consistancy */
 		new_disk = 0;
 
 		while (!conf->mirrors[new_disk].rdev ||
 		       !conf->mirrors[new_disk].rdev->in_sync) {
 			new_disk++;
 			if (new_disk == conf->raid_disks) {
-				new_disk = 0;
+				new_disk = -1;
 				break;
 			}
 		}
@@ -400,7 +370,7 @@ static int read_balance(conf_t *conf, st
 			new_disk = conf->raid_disks;
 		new_disk--;
 		if (new_disk == disk) {
-			new_disk = conf->last_used;
+			new_disk = -1;
 			goto rb_out;
 		}
 	}
@@ -440,13 +410,13 @@ static int read_balance(conf_t *conf, st
 	} while (disk != conf->last_used);
 
 rb_out:
-	r1_bio->read_disk = new_disk;
-	conf->next_seq_sect = this_sector + sectors;
 
-	conf->last_used = new_disk;
 
-	if (conf->mirrors[new_disk].rdev)
+	if (new_disk >= 0) {
+		conf->next_seq_sect = this_sector + sectors;
+		conf->last_used = new_disk;
 		atomic_inc(&conf->mirrors[new_disk].rdev->nr_pending);
+	}
 	spin_unlock_irq(&conf->device_lock);
 
 	return new_disk;
@@ -571,15 +541,26 @@ static int make_request(request_queue_t 
 	r1_bio->mddev = mddev;
 	r1_bio->sector = bio->bi_sector;
 
+	r1_bio->state = 0;
+
 	if (bio_data_dir(bio) == READ) {
 		/*
 		 * read balancing logic:
 		 */
-		mirror = conf->mirrors + read_balance(conf, bio, r1_bio);
+		int rdisk = read_balance(conf, r1_bio);
+
+		if (rdisk < 0) {
+			/* couldn't find anywhere to read from */
+			raid_end_bio_io(r1_bio);
+			return 0;
+		}
+		mirror = conf->mirrors + rdisk;
+
+		r1_bio->read_disk = rdisk;
 
 		read_bio = bio_clone(bio, GFP_NOIO);
 
-		r1_bio->bios[r1_bio->read_disk] = read_bio;
+		r1_bio->bios[rdisk] = read_bio;
 
 		read_bio->bi_sector = r1_bio->sector + mirror->rdev->data_offset;
 		read_bio->bi_bdev = mirror->rdev->bdev;
@@ -951,7 +932,7 @@ static void raid1d(mddev_t *mddev)
 		} else {
 			int disk;
 			bio = r1_bio->bios[r1_bio->read_disk];
-			if ((disk=map(mddev, &rdev)) == -1) {
+			if ((disk=read_balance(conf, r1_bio)) == -1) {
 				printk(KERN_ALERT "raid1: %s: unrecoverable I/O"
 				       " read error for block %llu\n",
 				       bdevname(bio->bi_bdev,b),
@@ -961,10 +942,12 @@ static void raid1d(mddev_t *mddev)
 				r1_bio->bios[r1_bio->read_disk] = NULL;
 				r1_bio->read_disk = disk;
 				r1_bio->bios[r1_bio->read_disk] = bio;
-				printk(KERN_ERR "raid1: %s: redirecting sector %llu to"
-				       " another mirror\n",
-				       bdevname(rdev->bdev,b),
-				       (unsigned long long)r1_bio->sector);
+				rdev = conf->mirrors[disk].rdev;
+				if (printk_ratelimit())
+					printk(KERN_ERR "raid1: %s: redirecting sector %llu to"
+					       " another mirror\n",
+					       bdevname(rdev->bdev,b),
+					       (unsigned long long)r1_bio->sector);
 				bio->bi_bdev = rdev->bdev;
 				bio->bi_sector = r1_bio->sector + rdev->data_offset;
 				bio->bi_rw = READ;
