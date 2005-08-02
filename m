From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH md 006 of 7] Yet another attempt to get bitmap-based resync to do the right thing in all cases...
Date: Tue, 02 Aug 2005 19:53:41 +1000
Message-ID: <E1DztSv-0004Ve-Rn@notabene.cse.unsw.edu.au>
References: <20050802193525.12307.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Firstly, R1BIO_Degraded was being set in a number of places in the
resync code, but is never used there, so get rid of those settings.

Then: When doing a resync, we want to clear the bit in the bitmap iff
the array will be non-degraded when the sync has completed.  However
the current code would clear the bitmap if the array was non-degraded
when the resync *started*, which obviously isn't right (it is for
'resync' but not for 'recovery' - i.e. rebuilding a failed drive).

This patch calculated 'still_degraded' and uses the to tell
bitmap_start_sync whether this sync should clear the corresponding
bit.



Signed-off-by: Neil Brown <neilb@cse.unsw.edu.au>

### Diffstat output
 ./drivers/md/raid1.c |   29 +++++++++++++++--------------
 1 files changed, 15 insertions(+), 14 deletions(-)

diff ./drivers/md/raid1.c~current~ ./drivers/md/raid1.c
--- ./drivers/md/raid1.c~current~	2005-08-02 15:23:02.000000000 +1000
+++ ./drivers/md/raid1.c	2005-08-02 15:23:16.000000000 +1000
@@ -897,7 +897,6 @@ static int end_sync_read(struct bio *bio
 	if (!uptodate) {
 		md_error(r1_bio->mddev,
 			 conf->mirrors[r1_bio->read_disk].rdev);
-		set_bit(R1BIO_Degraded, &r1_bio->state);
 	} else
 		set_bit(R1BIO_Uptodate, &r1_bio->state);
 	rdev_dec_pending(conf->mirrors[r1_bio->read_disk].rdev, conf->mddev);
@@ -922,10 +921,9 @@ static int end_sync_write(struct bio *bi
 			mirror = i;
 			break;
 		}
-	if (!uptodate) {
+	if (!uptodate)
 		md_error(mddev, conf->mirrors[mirror].rdev);
-		set_bit(R1BIO_Degraded, &r1_bio->state);
-	}
+
 	update_head_pos(mirror, r1_bio);
 
 	if (atomic_dec_and_test(&r1_bio->remaining)) {
@@ -1113,6 +1111,7 @@ static sector_t sync_request(mddev_t *md
 	int i;
 	int write_targets = 0;
 	int sync_blocks;
+	int still_degraded = 0;
 
 	if (!conf->r1buf_pool)
 	{
@@ -1141,7 +1140,10 @@ static sector_t sync_request(mddev_t *md
 		return 0;
 	}
 
-	if (!bitmap_start_sync(mddev->bitmap, sector_nr, &sync_blocks, mddev->degraded) &&
+	/* before building a request, check if we can skip these blocks..
+	 * This call the bitmap_start_sync doesn't actually record anything
+	 */
+	if (!bitmap_start_sync(mddev->bitmap, sector_nr, &sync_blocks, 1) &&
 	    !conf->fullsync) {
 		/* We can skip this block, and probably several more */
 		*skipped = 1;
@@ -1207,24 +1209,23 @@ static sector_t sync_request(mddev_t *md
 		if (i == disk) {
 			bio->bi_rw = READ;
 			bio->bi_end_io = end_sync_read;
-		} else if (conf->mirrors[i].rdev &&
-			   !conf->mirrors[i].rdev->faulty &&
-			   (!conf->mirrors[i].rdev->in_sync ||
-			    sector_nr + RESYNC_SECTORS > mddev->recovery_cp)) {
+		} else if (conf->mirrors[i].rdev == NULL ||
+			   conf->mirrors[i].rdev->faulty) {
+			still_degraded = 1;
+			continue;
+		} else if (!conf->mirrors[i].rdev->in_sync ||
+			   sector_nr + RESYNC_SECTORS > mddev->recovery_cp) {
 			bio->bi_rw = WRITE;
 			bio->bi_end_io = end_sync_write;
 			write_targets ++;
 		} else
+			/* no need to read or write here */
 			continue;
 		bio->bi_sector = sector_nr + conf->mirrors[i].rdev->data_offset;
 		bio->bi_bdev = conf->mirrors[i].rdev->bdev;
 		bio->bi_private = r1_bio;
 	}
 
-	if (write_targets + 1 < conf->raid_disks)
-		/* array degraded, can't clear bitmap */
-		set_bit(R1BIO_Degraded, &r1_bio->state);
-
 	if (write_targets == 0) {
 		/* There is nowhere to write, so all non-sync
 		 * drives must be failed - so we are finished
@@ -1247,7 +1248,7 @@ static sector_t sync_request(mddev_t *md
 			break;
 		if (sync_blocks == 0) {
 			if (!bitmap_start_sync(mddev->bitmap, sector_nr,
-					&sync_blocks, mddev->degraded) &&
+					&sync_blocks, still_degraded) &&
 					!conf->fullsync)
 				break;
 			if (sync_blocks < (PAGE_SIZE>>9))
