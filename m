From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 27/36] md/raid10: avoid reading known bad blocks during
 resync/recovery.
Date: Thu, 21 Jul 2011 12:58:50 +1000
Message-ID: <20110721025850.8422.9694.stgit@notabene.brown>
References: <20110721024556.8422.99443.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110721024556.8422.99443.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

During resync/recovery limit the size of the request to avoid
reading into a bad block that does not start at-or-before the current
read address.

Similarly if there is a bad block at this address, don't allow the
current request to extend beyond the end of that bad block.

Now that we don't ever read from known bad blocks, it is safe to allow
devices with those blocks into the array.

Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/raid10.c |   44 +++++++++++++++++++++++++++++++++++---------
 1 files changed, 35 insertions(+), 9 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 47e6959..9bac312 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1203,9 +1203,6 @@ static int raid10_add_disk(mddev_t *mddev, mdk_rdev_t *rdev)
 	int first = 0;
 	int last = conf->raid_disks - 1;
 
-	if (rdev->badblocks.count)
-		return -EINVAL;
-
 	if (mddev->recovery_cp < MaxSector)
 		/* only hot-add to in-sync arrays, as recovery is
 		 * very different from resync
@@ -1927,7 +1924,6 @@ static sector_t sync_request(mddev_t *mddev, sector_t sector_nr,
 	int i;
 	int max_sync;
 	sector_t sync_blocks;
-
 	sector_t sectors_skipped = 0;
 	int chunks_skipped = 0;
 
@@ -2070,10 +2066,28 @@ static sector_t sync_request(mddev_t *mddev, sector_t sector_nr,
 
 			for (j=0; j<conf->copies;j++) {
 				int d = r10_bio->devs[j].devnum;
+				mdk_rdev_t *rdev;
+				sector_t sector, first_bad;
+				int bad_sectors;
 				if (!conf->mirrors[d].rdev ||
 				    !test_bit(In_sync, &conf->mirrors[d].rdev->flags))
 					continue;
 				/* This is where we read from */
+				rdev = conf->mirrors[d].rdev;
+				sector = r10_bio->devs[j].addr;
+
+				if (is_badblock(rdev, sector, max_sync,
+						&first_bad, &bad_sectors)) {
+					if (first_bad > sector)
+						max_sync = first_bad - sector;
+					else {
+						bad_sectors -= (sector
+								- first_bad);
+						if (max_sync > bad_sectors)
+							max_sync = bad_sectors;
+						continue;
+					}
+				}
 				bio = r10_bio->devs[0].bio;
 				bio->bi_next = biolist;
 				biolist = bio;
@@ -2160,12 +2174,28 @@ static sector_t sync_request(mddev_t *mddev, sector_t sector_nr,
 
 		for (i=0; i<conf->copies; i++) {
 			int d = r10_bio->devs[i].devnum;
+			sector_t first_bad, sector;
+			int bad_sectors;
+
 			bio = r10_bio->devs[i].bio;
 			bio->bi_end_io = NULL;
 			clear_bit(BIO_UPTODATE, &bio->bi_flags);
 			if (conf->mirrors[d].rdev == NULL ||
 			    test_bit(Faulty, &conf->mirrors[d].rdev->flags))
 				continue;
+			sector = r10_bio->devs[i].addr;
+			if (is_badblock(conf->mirrors[d].rdev,
+					sector, max_sync,
+					&first_bad, &bad_sectors)) {
+				if (first_bad > sector)
+					max_sync = first_bad - sector;
+				else {
+					bad_sectors -= (sector - first_bad);
+					if (max_sync > bad_sectors)
+						max_sync = max_sync;
+					continue;
+				}
+			}
 			atomic_inc(&conf->mirrors[d].rdev->nr_pending);
 			atomic_inc(&r10_bio->remaining);
 			bio->bi_next = biolist;
@@ -2173,7 +2203,7 @@ static sector_t sync_request(mddev_t *mddev, sector_t sector_nr,
 			bio->bi_private = r10_bio;
 			bio->bi_end_io = end_sync_read;
 			bio->bi_rw = READ;
-			bio->bi_sector = r10_bio->devs[i].addr +
+			bio->bi_sector = sector +
 				conf->mirrors[d].rdev->data_offset;
 			bio->bi_bdev = conf->mirrors[d].rdev->bdev;
 			count++;
@@ -2431,10 +2461,6 @@ static int run(mddev_t *mddev)
 
 	list_for_each_entry(rdev, &mddev->disks, same_set) {
 
-		if (rdev->badblocks.count) {
-			printk(KERN_ERR "md/raid10: cannot handle bad blocks yet\n");
-			goto out_free_conf;
-		}
 		disk_idx = rdev->raid_disk;
 		if (disk_idx >= conf->raid_disks
 		    || disk_idx < 0)


