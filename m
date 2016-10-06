From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 51/54] md/raid10: Adjust 22 checks for null pointers
Date: Thu, 6 Oct 2016 11:51:05 +0200
Message-ID: <34060cc2-82f8-942d-7b2a-ca20f2424b58@users.sourceforge.net>
References: <566ABCD9.1060404@users.sourceforge.net>
 <786843ef-4b6f-eb04-7326-2f6f5b408826@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <786843ef-4b6f-eb04-7326-2f6f5b408826@users.sourceforge.net>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Guoqing Jiang <gqjiang@suse.com>, Jens Axboe <axboe@fb.com>, Mike Christie <mchristi@redhat.com>, Neil Brown <neilb@suse.com>, Shaohua Li <shli@kernel.org>, Tomasz Majchrzak <tomasz.majchrzak@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>
List-Id: linux-raid.ids

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Wed, 5 Oct 2016 21:36:43 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The script "checkpatch.pl" pointed information out like the following.

Comparison to NULL could be written …

Thus fix the affected source code places.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/md/raid10.c | 43 ++++++++++++++++++++++---------------------
 1 file changed, 22 insertions(+), 21 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 2181f53..82d79f5 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -734,10 +734,10 @@ static struct md_rdev *read_balance(struct r10conf *conf,
 			continue;
 		disk = r10_bio->devs[slot].devnum;
 		rdev = rcu_dereference(conf->mirrors[disk].replacement);
-		if (rdev == NULL || test_bit(Faulty, &rdev->flags) ||
+		if (!rdev || test_bit(Faulty, &rdev->flags) ||
 		    r10_bio->devs[slot].addr + sectors > rdev->recovery_offset)
 			rdev = rcu_dereference(conf->mirrors[disk].rdev);
-		if (rdev == NULL ||
+		if (!rdev ||
 		    test_bit(Faulty, &rdev->flags))
 			continue;
 		if (!test_bit(In_sync, &rdev->flags) &&
@@ -1386,7 +1386,8 @@ static void __make_request(struct mddev *mddev, struct bio *bio)
 
 		if (r10_bio->devs[i].repl_bio) {
 			struct md_rdev *rdev = conf->mirrors[d].replacement;
-			if (rdev == NULL) {
+
+			if (!rdev) {
 				/* Replacement just got moved to main 'rdev' */
 				smp_mb();
 				rdev = conf->mirrors[d].rdev;
@@ -1701,7 +1702,7 @@ static int raid10_add_disk(struct mddev *mddev, struct md_rdev *rdev)
 		first = last = rdev->raid_disk;
 
 	if (rdev->saved_raid_disk >= first &&
-	    conf->mirrors[rdev->saved_raid_disk].rdev == NULL)
+	    !conf->mirrors[rdev->saved_raid_disk].rdev)
 		mirror = rdev->saved_raid_disk;
 	else
 		mirror = first;
@@ -1711,7 +1712,7 @@ static int raid10_add_disk(struct mddev *mddev, struct md_rdev *rdev)
 			continue;
 		if (p->rdev) {
 			if (!test_bit(WantReplacement, &p->rdev->flags) ||
-			    p->replacement != NULL)
+			    p->replacement)
 				continue;
 			clear_bit(In_sync, &rdev->flags);
 			set_bit(Replacement, &rdev->flags);
@@ -1849,7 +1850,7 @@ static void end_sync_request(struct r10bio *r10_bio)
 	struct mddev *mddev = r10_bio->mddev;
 
 	while (atomic_dec_and_test(&r10_bio->remaining)) {
-		if (r10_bio->master_bio == NULL) {
+		if (!r10_bio->master_bio) {
 			/* the primary of several recovery bios */
 			sector_t s = r10_bio->sectors;
 			if (test_bit(R10BIO_MadeGood, &r10_bio->state) ||
@@ -2515,7 +2516,7 @@ static void handle_read_error(struct mddev *mddev, struct r10bio *r10_bio)
 
 read_more:
 	rdev = read_balance(conf, r10_bio, &max_sectors);
-	if (rdev == NULL) {
+	if (!rdev) {
 		pr_alert("%s: %s: unrecoverable I/O read error for block %llu\n",
 			 mdname(mddev), b,
 			 (unsigned long long)r10_bio->sector);
@@ -2587,7 +2588,7 @@ static void handle_write_completed(struct r10conf *conf, struct r10bio *r10_bio)
 		for (m = 0; m < conf->copies; m++) {
 			int dev = r10_bio->devs[m].devnum;
 			rdev = conf->mirrors[dev].rdev;
-			if (r10_bio->devs[m].bio == NULL)
+			if (!r10_bio->devs[m].bio)
 				continue;
 			if (!r10_bio->devs[m].bio->bi_error) {
 				rdev_clear_badblocks(
@@ -2602,7 +2603,7 @@ static void handle_write_completed(struct r10conf *conf, struct r10bio *r10_bio)
 					md_error(conf->mddev, rdev);
 			}
 			rdev = conf->mirrors[dev].replacement;
-			if (r10_bio->devs[m].repl_bio == NULL)
+			if (!r10_bio->devs[m].repl_bio)
 				continue;
 
 			if (!r10_bio->devs[m].repl_bio->bi_error) {
@@ -2631,7 +2632,7 @@ static void handle_write_completed(struct r10conf *conf, struct r10bio *r10_bio)
 					r10_bio->devs[m].addr,
 					r10_bio->sectors, 0);
 				rdev_dec_pending(rdev, conf->mddev);
-			} else if (bio != NULL && bio->bi_error) {
+			} else if (bio && bio->bi_error) {
 				fail = true;
 				if (!narrow_write_error(r10_bio, m)) {
 					md_error(conf->mddev, rdev);
@@ -2816,7 +2817,7 @@ static sector_t raid10_sync_request(struct mddev *mddev, sector_t sector_nr,
 	 * Allow skipping a full rebuild for incremental assembly
 	 * of a clean array, like RAID1 does.
 	 */
-	if (mddev->bitmap == NULL &&
+	if (!mddev->bitmap &&
 	    mddev->recovery_cp == MaxSector &&
 	    mddev->reshape_position == MaxSector &&
 	    !test_bit(MD_RECOVERY_SYNC, &mddev->recovery) &&
@@ -2945,10 +2946,10 @@ static sector_t raid10_sync_request(struct mddev *mddev, sector_t sector_nr,
 			mrdev = rcu_dereference(mirror->rdev);
 			mreplace = rcu_dereference(mirror->replacement);
 
-			if ((mrdev == NULL ||
+			if ((!mrdev ||
 			     test_bit(Faulty, &mrdev->flags) ||
 			     test_bit(In_sync, &mrdev->flags)) &&
-			    (mreplace == NULL ||
+			    (!mreplace ||
 			     test_bit(Faulty, &mreplace->flags))) {
 				rcu_read_unlock();
 				continue;
@@ -2976,7 +2977,7 @@ static sector_t raid10_sync_request(struct mddev *mddev, sector_t sector_nr,
 			if (sync_blocks < max_sync)
 				max_sync = sync_blocks;
 			if (!must_sync &&
-			    mreplace == NULL &&
+			    !mreplace &&
 			    !conf->fullsync) {
 				/* yep, skip the sync_blocks here, but don't assume
 				 * that there will never be anything to do here
@@ -3011,7 +3012,7 @@ static sector_t raid10_sync_request(struct mddev *mddev, sector_t sector_nr,
 			for (j = 0; j < conf->geo.raid_disks; j++) {
 				struct md_rdev *rdev = rcu_dereference(
 					conf->mirrors[j].rdev);
-				if (rdev == NULL || test_bit(Faulty, &rdev->flags)) {
+				if (!rdev || test_bit(Faulty, &rdev->flags)) {
 					still_degraded = 1;
 					break;
 				}
@@ -3099,7 +3100,7 @@ static sector_t raid10_sync_request(struct mddev *mddev, sector_t sector_nr,
 				 * this comment keeps human reviewers
 				 * happy.
 				 */
-				if (mreplace == NULL || bio == NULL ||
+				if (!mreplace || !bio ||
 				    test_bit(Faulty, &mreplace->flags))
 					break;
 				bio_reset(bio);
@@ -3161,7 +3162,7 @@ static sector_t raid10_sync_request(struct mddev *mddev, sector_t sector_nr,
 			if (mreplace)
 				rdev_dec_pending(mreplace, mddev);
 		}
-		if (biolist == NULL) {
+		if (!biolist) {
 			while (r10_bio) {
 				struct r10bio *rb2 = r10_bio;
 				r10_bio = (struct r10bio*) rb2->master_bio;
@@ -3214,7 +3215,7 @@ static sector_t raid10_sync_request(struct mddev *mddev, sector_t sector_nr,
 			bio->bi_error = -EIO;
 			rcu_read_lock();
 			rdev = rcu_dereference(conf->mirrors[d].rdev);
-			if (rdev == NULL || test_bit(Faulty, &rdev->flags)) {
+			if (!rdev || test_bit(Faulty, &rdev->flags)) {
 				rcu_read_unlock();
 				continue;
 			}
@@ -3243,7 +3244,7 @@ static sector_t raid10_sync_request(struct mddev *mddev, sector_t sector_nr,
 			count++;
 
 			rdev = rcu_dereference(conf->mirrors[d].replacement);
-			if (rdev == NULL || test_bit(Faulty, &rdev->flags)) {
+			if (!rdev || test_bit(Faulty, &rdev->flags)) {
 				rcu_read_unlock();
 				continue;
 			}
@@ -3565,7 +3566,7 @@ static int raid10_run(struct mddev *mddev)
 	int first = 1;
 	bool discard_supported = false;
 
-	if (mddev->private == NULL) {
+	if (!mddev->private) {
 		conf = setup_conf(mddev);
 		if (IS_ERR(conf))
 			return PTR_ERR(conf);
@@ -4542,7 +4543,7 @@ static int handle_reshape_read_error(struct mddev *mddev,
 			int d = r10b->devs[slot].devnum;
 			struct md_rdev *rdev = rcu_dereference(conf->mirrors[d].rdev);
 			sector_t addr;
-			if (rdev == NULL ||
+			if (!rdev ||
 			    test_bit(Faulty, &rdev->flags) ||
 			    !test_bit(In_sync, &rdev->flags))
 				goto failed;
-- 
2.10.1
