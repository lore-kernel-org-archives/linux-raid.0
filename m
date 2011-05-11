From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 05/16] md/raid1: clean up read_balance.
Date: Wed, 11 May 2011 16:30:31 +1000
Message-ID: <20110511063030.21263.65786.stgit@notabene.brown>
References: <20110511062743.21263.72802.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110511062743.21263.72802.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

read_balance has two loops which both look for a 'best'
device based on slightly different criteria.
This is clumsy and makes is hard to add extra criteria.

So replace it all with a single loop that combines everything.

Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/raid1.c |   83 +++++++++++++++++++++-------------------------------
 1 files changed, 34 insertions(+), 49 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 2b7a7ff..f0b0c79 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -411,10 +411,10 @@ static int read_balance(conf_t *conf, r1bio_t *r1_bio)
 {
 	const sector_t this_sector = r1_bio->sector;
 	const int sectors = r1_bio->sectors;
-	int new_disk = -1;
 	int start_disk;
+	int best_disk;
 	int i;
-	sector_t new_distance, current_distance;
+	sector_t best_dist;
 	mdk_rdev_t *rdev;
 	int choose_first;
 
@@ -425,6 +425,8 @@ static int read_balance(conf_t *conf, r1bio_t *r1_bio)
 	 * We take the first readable disk when above the resync window.
 	 */
  retry:
+	best_disk = -1;
+	best_dist = MaxSector;
 	if (conf->mddev->recovery_cp < MaxSector &&
 	    (this_sector + sectors >= conf->next_resync)) {
 		choose_first = 1;
@@ -434,8 +436,8 @@ static int read_balance(conf_t *conf, r1bio_t *r1_bio)
 		start_disk = conf->last_used;
 	}
 
-	/* make sure the disk is operational */
 	for (i = 0 ; i < conf->raid_disks ; i++) {
+		sector_t dist;
 		int disk = start_disk + i;
 		if (disk >= conf->raid_disks)
 			disk -= conf->raid_disks;
@@ -443,60 +445,43 @@ static int read_balance(conf_t *conf, r1bio_t *r1_bio)
 		rdev = rcu_dereference(conf->mirrors[disk].rdev);
 		if (r1_bio->bios[disk] == IO_BLOCKED
 		    || rdev == NULL
-		    || !test_bit(In_sync, &rdev->flags))
+		    || test_bit(Faulty, &rdev->flags))
 			continue;
-
-		new_disk = disk;
-		if (!test_bit(WriteMostly, &rdev->flags))
-			break;
-	}
-
-	if (new_disk < 0 || choose_first)
-		goto rb_out;
-
-	/*
-	 * Don't change to another disk for sequential reads:
-	 */
-	if (conf->next_seq_sect == this_sector)
-		goto rb_out;
-	if (this_sector == conf->mirrors[new_disk].head_position)
-		goto rb_out;
-
-	current_distance = abs(this_sector 
-			       - conf->mirrors[new_disk].head_position);
-
-	/* look for a better disk - i.e. head is closer */
-	start_disk = new_disk;
-	for (i = 1; i < conf->raid_disks; i++) {
-		int disk = start_disk + 1;
-		if (disk >= conf->raid_disks)
-			disk -= conf->raid_disks;
-
-		rdev = rcu_dereference(conf->mirrors[disk].rdev);
-		if (r1_bio->bios[disk] == IO_BLOCKED
-		    || rdev == NULL
-		    || !test_bit(In_sync, &rdev->flags)
-		    || test_bit(WriteMostly, &rdev->flags))
+		if (!test_bit(In_sync, &rdev->flags) &&
+		    rdev->recovery_offset < this_sector + sectors)
 			continue;
-
-		if (!atomic_read(&rdev->nr_pending)) {
-			new_disk = disk;
+		if (test_bit(WriteMostly, &rdev->flags)) {
+			/* Don't balance among write-mostly, just
+			 * use the first as a last resort */
+			if (best_disk < 0)
+				best_disk = disk;
+			continue;
+		}
+		/* This is a reasonable device to use.  It might
+		 * even be best.
+		 */
+		dist = abs(this_sector - conf->mirrors[disk].head_position);
+		if (choose_first
+		    /* Don't change to another disk for sequential reads */
+		    || conf->next_seq_sect == this_sector
+		    || dist == 0
+		    /* If device is idle, use it */
+		    || atomic_read(&rdev->nr_pending) == 0) {
+			best_disk = disk;
 			break;
 		}
-		new_distance = abs(this_sector - conf->mirrors[disk].head_position);
-		if (new_distance < current_distance) {
-			current_distance = new_distance;
-			new_disk = disk;
+		if (dist < best_dist) {
+			best_dist = dist;
+			best_disk = disk;
 		}
 	}
 
- rb_out:
-	if (new_disk >= 0) {
-		rdev = rcu_dereference(conf->mirrors[new_disk].rdev);
+	if (best_disk >= 0) {
+		rdev = rcu_dereference(conf->mirrors[best_disk].rdev);
 		if (!rdev)
 			goto retry;
 		atomic_inc(&rdev->nr_pending);
-		if (!test_bit(In_sync, &rdev->flags)) {
+		if (test_bit(Faulty, &rdev->flags)) {
 			/* cannot risk returning a device that failed
 			 * before we inc'ed nr_pending
 			 */
@@ -504,11 +489,11 @@ static int read_balance(conf_t *conf, r1bio_t *r1_bio)
 			goto retry;
 		}
 		conf->next_seq_sect = this_sector + sectors;
-		conf->last_used = new_disk;
+		conf->last_used = best_disk;
 	}
 	rcu_read_unlock();
 
-	return new_disk;
+	return best_disk;
 }
 
 static int raid1_congested(void *data, int bits)


