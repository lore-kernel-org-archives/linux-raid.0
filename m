From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH md 1 of 9] Remove possible oops in md/raid1
Date: Fri, 18 Feb 2005 11:40:44 +1100
Message-ID: <E1D1wCK-0000Wx-4M@notabene.cse.unsw.edu.au>
References: <20050218111131.790.patches@notabene>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


When we get a pointer and check it is non-null,
we should not get the pointer again but should instead
use the pointer we got in the first place...

Signed-off-by: Neil Brown <neilb@cse.unsw.edu.au>

### Diffstat output
 ./drivers/md/raid1.c |   40 ++++++++++++++++++++++++++++------------
 1 files changed, 28 insertions(+), 12 deletions(-)

diff ./drivers/md/raid1.c~current~ ./drivers/md/raid1.c
--- ./drivers/md/raid1.c~current~	2005-02-18 11:08:39.000000000 +1100
+++ ./drivers/md/raid1.c	2005-02-18 11:11:11.000000000 +1100
@@ -338,6 +338,7 @@ static int read_balance(conf_t *conf, r1
 	int new_disk = conf->last_used, disk = new_disk;
 	const int sectors = r1_bio->sectors;
 	sector_t new_distance, current_distance;
+	mdk_rdev_t *new_rdev, *rdev;
 
 	rcu_read_lock();
 	/*
@@ -345,13 +346,14 @@ static int read_balance(conf_t *conf, r1
 	 * device if no resync is going on, or below the resync window.
 	 * We take the first readable disk when above the resync window.
 	 */
+ retry:
 	if (conf->mddev->recovery_cp < MaxSector &&
 	    (this_sector + sectors >= conf->next_resync)) {
 		/* Choose the first operation device, for consistancy */
 		new_disk = 0;
 
-		while (!conf->mirrors[new_disk].rdev ||
-		       !conf->mirrors[new_disk].rdev->in_sync) {
+		while ((new_rdev=conf->mirrors[new_disk].rdev) == NULL ||
+		       !new_rdev->in_sync) {
 			new_disk++;
 			if (new_disk == conf->raid_disks) {
 				new_disk = -1;
@@ -363,8 +365,8 @@ static int read_balance(conf_t *conf, r1
 
 
 	/* make sure the disk is operational */
-	while (!conf->mirrors[new_disk].rdev ||
-	       !conf->mirrors[new_disk].rdev->in_sync) {
+	while ((new_rdev=conf->mirrors[new_disk].rdev) == NULL ||
+	       !new_rdev->in_sync) {
 		if (new_disk <= 0)
 			new_disk = conf->raid_disks;
 		new_disk--;
@@ -393,18 +395,20 @@ static int read_balance(conf_t *conf, r1
 			disk = conf->raid_disks;
 		disk--;
 
-		if (!conf->mirrors[disk].rdev ||
-		    !conf->mirrors[disk].rdev->in_sync)
+		if ((rdev=conf->mirrors[disk].rdev) == NULL ||
+		    !rdev->in_sync)
 			continue;
 
-		if (!atomic_read(&conf->mirrors[disk].rdev->nr_pending)) {
+		if (!atomic_read(&rdev->nr_pending)) {
 			new_disk = disk;
+			new_rdev = rdev;
 			break;
 		}
 		new_distance = abs(this_sector - conf->mirrors[disk].head_position);
 		if (new_distance < current_distance) {
 			current_distance = new_distance;
 			new_disk = disk;
+			new_rdev = rdev;
 		}
 	} while (disk != conf->last_used);
 
@@ -414,7 +418,14 @@ rb_out:
 	if (new_disk >= 0) {
 		conf->next_seq_sect = this_sector + sectors;
 		conf->last_used = new_disk;
-		atomic_inc(&conf->mirrors[new_disk].rdev->nr_pending);
+		atomic_inc(&new_rdev->nr_pending);
+		if (!new_rdev->in_sync) {
+			/* cannot risk returning a device that failed
+			 * before we inc'ed nr_pending
+			 */
+			atomic_dec(&new_rdev->nr_pending);
+			goto retry;
+		}
 	}
 	rcu_read_unlock();
 
@@ -512,6 +523,7 @@ static int make_request(request_queue_t 
 	r1bio_t *r1_bio;
 	struct bio *read_bio;
 	int i, disks;
+	mdk_rdev_t *rdev;
 
 	/*
 	 * Register the new request and wait if the reconstruction
@@ -585,10 +597,14 @@ static int make_request(request_queue_t 
 	disks = conf->raid_disks;
 	rcu_read_lock();
 	for (i = 0;  i < disks; i++) {
-		if (conf->mirrors[i].rdev &&
-		    !conf->mirrors[i].rdev->faulty) {
-			atomic_inc(&conf->mirrors[i].rdev->nr_pending);
-			r1_bio->bios[i] = bio;
+		if ((rdev=conf->mirrors[i].rdev) != NULL &&
+		    !rdev->faulty) {
+			atomic_inc(&rdev->nr_pending);
+			if (rdev->faulty) {
+				atomic_dec(&rdev->nr_pending);
+				r1_bio->bios[i] = NULL;
+			} else
+				r1_bio->bios[i] = bio;
 		} else
 			r1_bio->bios[i] = NULL;
 	}
