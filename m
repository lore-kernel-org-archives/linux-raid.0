From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 18/54] md/raid1: Adjust 12 checks for null pointers
Date: Thu, 6 Oct 2016 11:15:51 +0200
Message-ID: <125fd683-dab1-6e28-3955-20953d06fff4@users.sourceforge.net>
References: <566ABCD9.1060404@users.sourceforge.net>
 <786843ef-4b6f-eb04-7326-2f6f5b408826@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <786843ef-4b6f-eb04-7326-2f6f5b408826@users.sourceforge.net>
Sender: kernel-janitors-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Guoqing Jiang <gqjiang@suse.com>, Jens Axboe <axboe@fb.com>, Mike Christie <mchristi@redhat.com>, Neil Brown <neilb@suse.com>, Shaohua Li <shli@kernel.org>, Tomasz Majchrzak <tomasz.majchrzak@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>
List-Id: linux-raid.ids

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Tue, 4 Oct 2016 18:55:42 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The script "checkpatch.pl" pointed information out like the following.

Comparison to NULL could be written …

Thus fix the affected source code places.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/md/raid1.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 958bf41..3a1194e 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -474,7 +474,7 @@ static void raid1_end_write_request(struct bio *bio)
 			}
 		}
 	}
-	if (r1_bio->bios[mirror] == NULL)
+	if (!r1_bio->bios[mirror])
 		rdev_dec_pending(rdev, conf->mddev);
 
 	/*
@@ -549,7 +549,7 @@ static int read_balance(struct r1conf *conf, struct r1bio *r1_bio, int *max_sect
 
 		rdev = rcu_dereference(conf->mirrors[disk].rdev);
 		if (r1_bio->bios[disk] == IO_BLOCKED
-		    || rdev == NULL
+		    || !rdev
 		    || test_bit(Faulty, &rdev->flags))
 			continue;
 		if (!test_bit(In_sync, &rdev->flags) &&
@@ -1582,7 +1582,7 @@ static int raid1_add_disk(struct mddev *mddev, struct md_rdev *rdev)
 	 */
 	if (rdev->saved_raid_disk >= 0 &&
 	    rdev->saved_raid_disk >= first &&
-	    conf->mirrors[rdev->saved_raid_disk].rdev == NULL)
+	    !conf->mirrors[rdev->saved_raid_disk].rdev)
 		first = last = rdev->saved_raid_disk;
 
 	for (mirror = first; mirror <= last; mirror++) {
@@ -1605,7 +1605,7 @@ static int raid1_add_disk(struct mddev *mddev, struct md_rdev *rdev)
 			break;
 		}
 		if (test_bit(WantReplacement, &p->rdev->flags) &&
-		    p[conf->raid_disks].rdev == NULL) {
+		    !p[conf->raid_disks].rdev) {
 			/* Add this device as a replacement */
 			clear_bit(In_sync, &rdev->flags);
 			set_bit(Replacement, &rdev->flags);
@@ -2002,7 +2002,7 @@ static void sync_request_write(struct mddev *mddev, struct r1bio *r1_bio)
 	atomic_set(&r1_bio->remaining, 1);
 	for (i = 0; i < disks ; i++) {
 		wbio = r1_bio->bios[i];
-		if (wbio->bi_end_io == NULL ||
+		if (!wbio->bi_end_io ||
 		    (wbio->bi_end_io == end_sync_read &&
 		     (i == r1_bio->read_disk ||
 		      !test_bit(MD_RECOVERY_SYNC, &mddev->recovery))))
@@ -2220,7 +2220,7 @@ static void handle_sync_write_finished(struct r1conf *conf, struct r1bio *r1_bio
 	for (m = 0; m < conf->raid_disks * 2 ; m++) {
 		struct md_rdev *rdev = conf->mirrors[m].rdev;
 		struct bio *bio = r1_bio->bios[m];
-		if (bio->bi_end_io == NULL)
+		if (!bio->bi_end_io)
 			continue;
 		if (!bio->bi_error &&
 		    test_bit(R1BIO_MadeGood, &r1_bio->state)) {
@@ -2247,7 +2247,7 @@ static void handle_write_finished(struct r1conf *conf, struct r1bio *r1_bio)
 					     r1_bio->sector,
 					     r1_bio->sectors, 0);
 			rdev_dec_pending(rdev, conf->mddev);
-		} else if (r1_bio->bios[m] != NULL) {
+		} else if (r1_bio->bios[m]) {
 			/* This drive got a write error.  We need to
 			 * narrow down and record precise write
 			 * errors.
@@ -2509,7 +2509,7 @@ static sector_t raid1_sync_request(struct mddev *mddev, sector_t sector_nr,
 		return 0;
 	}
 
-	if (mddev->bitmap == NULL &&
+	if (!mddev->bitmap &&
 	    mddev->recovery_cp == MaxSector &&
 	    !test_bit(MD_RECOVERY_REQUESTED, &mddev->recovery) &&
 	    conf->fullsync == 0) {
@@ -2564,7 +2564,7 @@ static sector_t raid1_sync_request(struct mddev *mddev, sector_t sector_nr,
 		bio_reset(bio);
 
 		rdev = rcu_dereference(conf->mirrors[i].rdev);
-		if (rdev == NULL ||
+		if (!rdev ||
 		    test_bit(Faulty, &rdev->flags)) {
 			if (i < conf->raid_disks)
 				still_degraded = 1;
@@ -2710,7 +2710,7 @@ static sector_t raid1_sync_request(struct mddev *mddev, sector_t sector_nr,
 					while (i > 0) {
 						i--;
 						bio = r1_bio->bios[i];
-						if (bio->bi_end_io==NULL)
+						if (!bio->bi_end_io)
 							continue;
 						/* remove last page from this bio */
 						bio->bi_vcnt--;
@@ -2924,7 +2924,7 @@ static int raid1_run(struct mddev *mddev)
 	 * bookkeeping area. [whatever we allocate in run(),
 	 * should be freed in raid1_free()]
 	 */
-	if (mddev->private == NULL)
+	if (!mddev->private)
 		conf = setup_conf(mddev);
 	else
 		conf = mddev->private;
@@ -2946,7 +2946,7 @@ static int raid1_run(struct mddev *mddev)
 
 	mddev->degraded = 0;
 	for (i=0; i < conf->raid_disks; i++)
-		if (conf->mirrors[i].rdev == NULL ||
+		if (!conf->mirrors[i].rdev ||
 		    !test_bit(In_sync, &conf->mirrors[i].rdev->flags) ||
 		    test_bit(Faulty, &conf->mirrors[i].rdev->flags))
 			mddev->degraded++;
-- 
2.10.1

