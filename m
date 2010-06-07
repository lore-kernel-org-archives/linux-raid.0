From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 06/16] md/raid1: clean up read_balance.
Date: Mon, 07 Jun 2010 10:07:54 +1000
Message-ID: <20100607000754.13302.77379.stgit@notabene.brown>
References: <20100606235833.13302.60932.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100606235833.13302.60932.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

read_balance has three loops which all look for a 'best'
device based on slightly different criteria.
This is clumsy and makes is hard to add extra criteria.

So replace it all with a single loop that combines everything.

Signed-off-by: NeilBrown <neilb@suse.de>
---
 drivers/md/raid1.c |  144 ++++++++++++++++++++++------------------------------
 1 files changed, 60 insertions(+), 84 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 82440a7..fa62c7b 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -420,10 +420,13 @@ static void raid1_end_write_request(struct bio *bio, int error)
 static int read_balance(conf_t *conf, r1bio_t *r1_bio)
 {
 	const sector_t this_sector = r1_bio->sector;
-	int new_disk = conf->last_used, disk = new_disk;
-	int wonly_disk = -1;
 	const int sectors = r1_bio->sectors;
-	sector_t new_distance, current_distance;
+	int do_balance;
+	int disk;
+	int start_disk;
+	int best_disk;
+	int i;
+	sector_t best_dist;
 	mdk_rdev_t *rdev;
 
 	rcu_read_lock();
@@ -433,100 +436,73 @@ static int read_balance(conf_t *conf, r1bio_t *r1_bio)
 	 * We take the first readable disk when above the resync window.
 	 */
  retry:
+	disk = -1;
+	best_disk = -1;
+	best_dist = MaxSector;
 	if (conf->mddev->recovery_cp < MaxSector &&
 	    (this_sector + sectors >= conf->next_resync)) {
-		/* Choose the first operational device, for consistancy */
-		new_disk = 0;
-
-		for (rdev = rcu_dereference(conf->mirrors[new_disk].rdev);
-		     r1_bio->bios[new_disk] == IO_BLOCKED ||
-		     !rdev || !test_bit(In_sync, &rdev->flags)
-			     || test_bit(WriteMostly, &rdev->flags);
-		     rdev = rcu_dereference(conf->mirrors[++new_disk].rdev)) {
-
-			if (rdev && test_bit(In_sync, &rdev->flags) &&
-				r1_bio->bios[new_disk] != IO_BLOCKED)
-				wonly_disk = new_disk;
-
-			if (new_disk == conf->raid_disks - 1) {
-				new_disk = wonly_disk;
-				break;
-			}
-		}
-		goto rb_out;
+		/* just choose the first */
+		start_disk = 0;
+		do_balance = 0;
+	} else {
+		/* Else start from last used */
+		start_disk = conf->last_used;
+		do_balance = 1;
 	}
+	for (i = 0; i < conf->raid_disks; i++) {
+		sector_t dist;
 
+		disk = (start_disk + i) % conf->raid_disks;
+		if (r1_bio->bios[disk] == IO_BLOCKED)
+			continue;
+		rdev = rcu_dereference(conf->mirrors[disk].rdev);
+		if (!rdev)
+			continue;
+		if (test_bit(Faulty, &rdev->flags))
+			continue;
+		if (!test_bit(In_sync, &rdev->flags) &&
+		    rdev->recovery_offset < this_sector + sectors)
+			continue;
 
-	/* make sure the disk is operational */
-	for (rdev = rcu_dereference(conf->mirrors[new_disk].rdev);
-	     r1_bio->bios[new_disk] == IO_BLOCKED ||
-	     !rdev || !test_bit(In_sync, &rdev->flags) ||
-		     test_bit(WriteMostly, &rdev->flags);
-	     rdev = rcu_dereference(conf->mirrors[new_disk].rdev)) {
+		if (test_bit(WriteMostly, &rdev->flags)) {
+			/* don't balance among write-mostly, just
+			 * use first as a last resort */
+			if (best_disk < 0)
+				best_disk = disk;
+			continue;
+		}
+		/* This is a reasonable device to use.  It might
+		 * even be best.
+		 */
+		if (!do_balance)
+			break;
 
-		if (rdev && test_bit(In_sync, &rdev->flags) &&
-		    r1_bio->bios[new_disk] != IO_BLOCKED)
-			wonly_disk = new_disk;
+		/*
+		 * Don't change to another disk for sequential reads:
+		 */
+		if (conf->next_seq_sect == this_sector)
+			break;
 
-		if (new_disk <= 0)
-			new_disk = conf->raid_disks;
-		new_disk--;
-		if (new_disk == disk) {
-			new_disk = wonly_disk;
+		dist = abs(this_sector - conf->mirrors[disk].head_position);
+		if (dist == 0)
+			break;
+		if (!atomic_read(&rdev->nr_pending))
+			/* Device is idle, so use it */
 			break;
+		if (dist < best_dist) {
+			best_dist = dist;
+			best_disk = disk;
 		}
 	}
+	if (i == conf->raid_disks)
+		disk = best_disk;
 
-	if (new_disk < 0)
-		goto rb_out;
-
-	disk = new_disk;
-	/* now disk == new_disk == starting point for search */
-
-	/*
-	 * Don't change to another disk for sequential reads:
-	 */
-	if (conf->next_seq_sect == this_sector)
-		goto rb_out;
-	if (this_sector == conf->mirrors[new_disk].head_position)
-		goto rb_out;
-
-	current_distance = abs(this_sector - conf->mirrors[disk].head_position);
-
-	/* Find the disk whose head is closest */
-
-	do {
-		if (disk <= 0)
-			disk = conf->raid_disks;
-		disk--;
-
+	if (disk >= 0) {
 		rdev = rcu_dereference(conf->mirrors[disk].rdev);
-
-		if (!rdev || r1_bio->bios[disk] == IO_BLOCKED ||
-		    !test_bit(In_sync, &rdev->flags) ||
-		    test_bit(WriteMostly, &rdev->flags))
-			continue;
-
-		if (!atomic_read(&rdev->nr_pending)) {
-			new_disk = disk;
-			break;
-		}
-		new_distance = abs(this_sector - conf->mirrors[disk].head_position);
-		if (new_distance < current_distance) {
-			current_distance = new_distance;
-			new_disk = disk;
-		}
-	} while (disk != conf->last_used);
-
- rb_out:
-
-
-	if (new_disk >= 0) {
-		rdev = rcu_dereference(conf->mirrors[new_disk].rdev);
 		if (!rdev)
 			goto retry;
 		atomic_inc(&rdev->nr_pending);
-		if (!test_bit(In_sync, &rdev->flags)) {
+		if (test_bit(Faulty, &rdev->flags)) {
 			/* cannot risk returning a device that failed
 			 * before we inc'ed nr_pending
 			 */
@@ -534,11 +510,11 @@ static int read_balance(conf_t *conf, r1bio_t *r1_bio)
 			goto retry;
 		}
 		conf->next_seq_sect = this_sector + sectors;
-		conf->last_used = new_disk;
+		conf->last_used = disk;
 	}
 	rcu_read_unlock();
 
-	return new_disk;
+	return disk;
 }
 
 static void unplug_slaves(mddev_t *mddev)


