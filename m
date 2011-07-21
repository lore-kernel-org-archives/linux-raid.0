From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 07/36] md/raid1: avoid reading known bad blocks during
 resync
Date: Thu, 21 Jul 2011 12:58:48 +1000
Message-ID: <20110721025848.8422.55863.stgit@notabene.brown>
References: <20110721024556.8422.99443.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110721024556.8422.99443.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

When performing resync/etc, keep the size of the request
small enough that it doesn't overlap any known bad blocks.
Devices with badblocks at the start of the request are completely
excluded.
If there is nowhere to read from due to bad blocks, record
a bad block on each target device.

Now that we never read from known-bad-blocks we can allow devices with
known-bad-blocks into a RAID1.

Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/raid1.c |   97 ++++++++++++++++++++++++++++++++++++++++------------
 1 files changed, 75 insertions(+), 22 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index cc3939d..8c31c39 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1155,9 +1155,6 @@ static int raid1_add_disk(mddev_t *mddev, mdk_rdev_t *rdev)
 	if (mddev->recovery_disabled == conf->recovery_disabled)
 		return -EBUSY;
 
-	if (rdev->badblocks.count)
-		return -EINVAL;
-
 	if (rdev->raid_disk >= 0)
 		first = last = rdev->raid_disk;
 
@@ -1303,6 +1300,9 @@ static int fix_sync_read_error(r1bio_t *r1_bio)
 	 * We don't need to freeze the array, because being in an
 	 * active sync request, there is no normal IO, and
 	 * no overlapping syncs.
+	 * We don't need to check is_badblock() again as we
+	 * made sure that anything with a bad block in range
+	 * will have bi_end_io clear.
 	 */
 	mddev_t *mddev = r1_bio->mddev;
 	conf_t *conf = mddev->private;
@@ -1792,6 +1792,8 @@ static sector_t sync_request(mddev_t *mddev, sector_t sector_nr, int *skipped, i
 	int write_targets = 0, read_targets = 0;
 	sector_t sync_blocks;
 	int still_degraded = 0;
+	int good_sectors = RESYNC_SECTORS;
+	int min_bad = 0; /* number of sectors that are bad in all devices */
 
 	if (!conf->r1buf_pool)
 		if (init_resync(conf))
@@ -1879,36 +1881,89 @@ static sector_t sync_request(mddev_t *mddev, sector_t sector_nr, int *skipped, i
 
 		rdev = rcu_dereference(conf->mirrors[i].rdev);
 		if (rdev == NULL ||
-			   test_bit(Faulty, &rdev->flags)) {
+		    test_bit(Faulty, &rdev->flags)) {
 			still_degraded = 1;
-			continue;
 		} else if (!test_bit(In_sync, &rdev->flags)) {
 			bio->bi_rw = WRITE;
 			bio->bi_end_io = end_sync_write;
 			write_targets ++;
 		} else {
 			/* may need to read from here */
-			bio->bi_rw = READ;
-			bio->bi_end_io = end_sync_read;
-			if (test_bit(WriteMostly, &rdev->flags)) {
-				if (wonly < 0)
-					wonly = i;
-			} else {
-				if (disk < 0)
-					disk = i;
+			sector_t first_bad = MaxSector;
+			int bad_sectors;
+
+			if (is_badblock(rdev, sector_nr, good_sectors,
+					&first_bad, &bad_sectors)) {
+				if (first_bad > sector_nr)
+					good_sectors = first_bad - sector_nr;
+				else {
+					bad_sectors -= (sector_nr - first_bad);
+					if (min_bad == 0 ||
+					    min_bad > bad_sectors)
+						min_bad = bad_sectors;
+				}
+			}
+			if (sector_nr < first_bad) {
+				if (test_bit(WriteMostly, &rdev->flags)) {
+					if (wonly < 0)
+						wonly = i;
+				} else {
+					if (disk < 0)
+						disk = i;
+				}
+				bio->bi_rw = READ;
+				bio->bi_end_io = end_sync_read;
+				read_targets++;
 			}
-			read_targets++;
 		}
-		atomic_inc(&rdev->nr_pending);
-		bio->bi_sector = sector_nr + rdev->data_offset;
-		bio->bi_bdev = rdev->bdev;
-		bio->bi_private = r1_bio;
+		if (bio->bi_end_io) {
+			atomic_inc(&rdev->nr_pending);
+			bio->bi_sector = sector_nr + rdev->data_offset;
+			bio->bi_bdev = rdev->bdev;
+			bio->bi_private = r1_bio;
+		}
 	}
 	rcu_read_unlock();
 	if (disk < 0)
 		disk = wonly;
 	r1_bio->read_disk = disk;
 
+	if (read_targets == 0 && min_bad > 0) {
+		/* These sectors are bad on all InSync devices, so we
+		 * need to mark them bad on all write targets
+		 */
+		int ok = 1;
+		for (i = 0 ; i < conf->raid_disks ; i++)
+			if (r1_bio->bios[i]->bi_end_io == end_sync_write) {
+				mdk_rdev_t *rdev =
+					rcu_dereference(conf->mirrors[i].rdev);
+				ok = rdev_set_badblocks(rdev, sector_nr,
+							min_bad, 0
+					) && ok;
+			}
+		set_bit(MD_CHANGE_DEVS, &mddev->flags);
+		*skipped = 1;
+		put_buf(r1_bio);
+
+		if (!ok) {
+			/* Cannot record the badblocks, so need to
+			 * abort the resync.
+			 * If there are multiple read targets, could just
+			 * fail the really bad ones ???
+			 */
+			conf->recovery_disabled = mddev->recovery_disabled;
+			set_bit(MD_RECOVERY_INTR, &mddev->recovery);
+			return 0;
+		} else
+			return min_bad;
+
+	}
+	if (min_bad > 0 && min_bad < good_sectors) {
+		/* only resync enough to reach the next bad->good
+		 * transition */
+		good_sectors = min_bad;
+	}
+
 	if (test_bit(MD_RECOVERY_SYNC, &mddev->recovery) && read_targets > 0)
 		/* extra read targets are also write targets */
 		write_targets += read_targets-1;
@@ -1925,6 +1980,8 @@ static sector_t sync_request(mddev_t *mddev, sector_t sector_nr, int *skipped, i
 
 	if (max_sector > mddev->resync_max)
 		max_sector = mddev->resync_max; /* Don't do IO beyond here */
+	if (max_sector > sector_nr + good_sectors)
+		max_sector = sector_nr + good_sectors;
 	nr_sectors = 0;
 	sync_blocks = 0;
 	do {
@@ -2147,10 +2204,6 @@ static int run(mddev_t *mddev)
 			blk_queue_segment_boundary(mddev->queue,
 						   PAGE_CACHE_SIZE - 1);
 		}
-		if (rdev->badblocks.count) {
-			printk(KERN_ERR "md/raid1: Cannot handle bad blocks yet\n");
-			return -EINVAL;
-		}
 	}
 
 	mddev->degraded = 0;


