From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH] md - 4 of 7 - Remove some un-needed fields from r1bio_s
Date: Fri, 06 Feb 2004 16:35:53 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <E1Aoyef-00083e-00@notabene>
References: <20040206162532.30220.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


next_r1 is never used, so it can just go.

read_bio isn't needed as we can easily use one of the pointers
in the write_bios array - write_bios[->read_disk].
So rename "write_bios" to "bios" and store the pointer to the
read bio in there.

 ----------- Diffstat output ------------
 ./drivers/md/raid1.c         |   55 ++++++++++++++-----------------------------
 ./include/linux/raid/raid1.h |    6 +---
 2 files changed, 21 insertions(+), 40 deletions(-)

diff ./drivers/md/raid1.c~current~ ./drivers/md/raid1.c
--- ./drivers/md/raid1.c~current~	2004-02-06 16:18:52.000000000 +1100
+++ ./drivers/md/raid1.c	2004-02-06 16:19:15.000000000 +1100
@@ -42,7 +42,7 @@ static void * r1bio_pool_alloc(int gfp_f
 	mddev_t *mddev = data;
 	r1bio_t *r1_bio;
 
-	/* allocate a r1bio with room for raid_disks entries in the write_bios array */
+	/* allocate a r1bio with room for raid_disks entries in the bios array */
 	r1_bio = kmalloc(sizeof(r1bio_t) + sizeof(struct bio*)*mddev->raid_disks,
 			 gfp_flags);
 	if (r1_bio)
@@ -132,19 +132,10 @@ static void put_all_bios(conf_t *conf, r
 {
 	int i;
 
-	if (r1_bio->read_bio) {
-		if (atomic_read(&r1_bio->read_bio->bi_cnt) != 1)
-			BUG();
-		bio_put(r1_bio->read_bio);
-		r1_bio->read_bio = NULL;
-	}
 	for (i = 0; i < conf->raid_disks; i++) {
-		struct bio **bio = r1_bio->write_bios + i;
-		if (*bio) {
-			if (atomic_read(&(*bio)->bi_cnt) != 1)
-				BUG();
+		struct bio **bio = r1_bio->bios + i;
+		if (*bio)
 			bio_put(*bio);
-		}
 		*bio = NULL;
 	}
 }
@@ -291,8 +282,6 @@ static int raid1_end_read_request(struct
 
 	update_head_pos(mirror, r1_bio);
 
-	if (!r1_bio->read_bio)
-		BUG();
 	/*
 	 * we have only one bio on the read side
 	 */
@@ -323,7 +312,7 @@ static int raid1_end_write_request(struc
 		return 1;
 	
 	for (mirror = 0; mirror < conf->raid_disks; mirror++)
-		if (r1_bio->write_bios[mirror] == bio)
+		if (r1_bio->bios[mirror] == bio)
 			break;
 
 	/*
@@ -345,8 +334,6 @@ static int raid1_end_write_request(struc
 
 	update_head_pos(mirror, r1_bio);
 
-	if (r1_bio->read_bio)
-		BUG();
 	/*
 	 *
 	 * Let's see if all mirrored write operations have finished
@@ -531,9 +518,8 @@ static int make_request(request_queue_t 
 		mirror = conf->mirrors + read_balance(conf, bio, r1_bio);
 
 		read_bio = bio_clone(bio, GFP_NOIO);
-		if (r1_bio->read_bio)
-			BUG();
-		r1_bio->read_bio = read_bio;
+
+		r1_bio->bios[r1_bio->read_disk] = read_bio;
 
 		read_bio->bi_sector = r1_bio->sector + mirror->rdev->data_offset;
 		read_bio->bi_bdev = mirror->rdev->bdev;
@@ -550,16 +536,16 @@ static int make_request(request_queue_t 
 	 */
 	/* first select target devices under spinlock and
 	 * inc refcount on their rdev.  Record them by setting
-	 * write_bios[x] to bio
+	 * bios[x] to bio
 	 */
 	spin_lock_irq(&conf->device_lock);
 	for (i = 0;  i < disks; i++) {
 		if (conf->mirrors[i].rdev &&
 		    !conf->mirrors[i].rdev->faulty) {
 			atomic_inc(&conf->mirrors[i].rdev->nr_pending);
-			r1_bio->write_bios[i] = bio;
+			r1_bio->bios[i] = bio;
 		} else
-			r1_bio->write_bios[i] = NULL;
+			r1_bio->bios[i] = NULL;
 	}
 	spin_unlock_irq(&conf->device_lock);
 
@@ -567,11 +553,11 @@ static int make_request(request_queue_t 
 	md_write_start(mddev);
 	for (i = 0; i < disks; i++) {
 		struct bio *mbio;
-		if (!r1_bio->write_bios[i])
+		if (!r1_bio->bios[i])
 			continue;
 
 		mbio = bio_clone(bio, GFP_NOIO);
-		r1_bio->write_bios[i] = mbio;
+		r1_bio->bios[i] = mbio;
 
 		mbio->bi_sector	= r1_bio->sector + conf->mirrors[i].rdev->data_offset;
 		mbio->bi_bdev = conf->mirrors[i].rdev->bdev;
@@ -773,7 +759,7 @@ static int end_sync_read(struct bio *bio
 	if (bio->bi_size)
 		return 1;
 
-	if (r1_bio->read_bio != bio)
+	if (r1_bio->bios[r1_bio->read_disk] != bio)
 		BUG();
 	update_head_pos(r1_bio->read_disk, r1_bio);
 	/*
@@ -804,7 +790,7 @@ static int end_sync_write(struct bio *bi
 		return 1;
 
 	for (i = 0; i < conf->raid_disks; i++)
-		if (r1_bio->write_bios[i] == bio) {
+		if (r1_bio->bios[i] == bio) {
 			mirror = i;
 			break;
 		}
@@ -850,11 +836,11 @@ static void sync_request_write(mddev_t *
 
 	spin_lock_irq(&conf->device_lock);
 	for (i = 0; i < disks ; i++) {
-		r1_bio->write_bios[i] = NULL;
+		r1_bio->bios[i] = NULL;
 		if (!conf->mirrors[i].rdev || 
 		    conf->mirrors[i].rdev->faulty)
 			continue;
-		if (conf->mirrors[i].rdev->bdev == bio->bi_bdev)
+		if (i == r1_bio->read_disk)
 			/*
 			 * we read from here, no need to write
 			 */
@@ -866,16 +852,16 @@ static void sync_request_write(mddev_t *
 			 */
 			continue;
 		atomic_inc(&conf->mirrors[i].rdev->nr_pending);
-		r1_bio->write_bios[i] = bio;
+		r1_bio->bios[i] = bio;
 	}
 	spin_unlock_irq(&conf->device_lock);
 
 	atomic_set(&r1_bio->remaining, 1);
 	for (i = disks; i-- ; ) {
-		if (!r1_bio->write_bios[i])
+		if (!r1_bio->bios[i])
 			continue;
 		mbio = bio_clone(bio, GFP_NOIO);
-		r1_bio->write_bios[i] = mbio;
+		r1_bio->bios[i] = mbio;
 		mbio->bi_bdev = conf->mirrors[i].rdev->bdev;
 		mbio->bi_sector = r1_bio->sector + conf->mirrors[i].rdev->data_offset;
 		mbio->bi_end_io	= end_sync_write;
@@ -1056,10 +1042,7 @@ static int sync_request(mddev_t *mddev, 
 	read_bio->bi_end_io = end_sync_read;
 	read_bio->bi_rw = READ;
 	read_bio->bi_private = r1_bio;
-
-	if (r1_bio->read_bio)
-		BUG();
-	r1_bio->read_bio = read_bio;
+	r1_bio->bios[r1_bio->read_disk] = read_bio;
 
 	md_sync_acct(mirror->rdev, nr_sectors);
 

diff ./include/linux/raid/raid1.h~current~ ./include/linux/raid/raid1.h
--- ./include/linux/raid/raid1.h~current~	2004-02-06 16:18:52.000000000 +1100
+++ ./include/linux/raid/raid1.h	2004-02-06 16:19:15.000000000 +1100
@@ -62,18 +62,16 @@ struct r1bio_s {
 	 */
 	struct bio		*master_bio;
 	/*
-	 * if the IO is in READ direction, then this bio is used:
+	 * if the IO is in READ direction, then this is where we read
 	 */
-	struct bio		*read_bio;
 	int			read_disk;
 
-	r1bio_t			*next_r1; /* next for retry or in free list */
 	struct list_head	retry_list;
 	/*
 	 * if the IO is in WRITE direction, then multiple bios are used.
 	 * We choose the number when they are allocated.
 	 */
-	struct bio		*write_bios[0];
+	struct bio		*bios[0];
 };
 
 /* bits for r1bio.state */
