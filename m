From: NeilBrown <neilb@suse.com>
Subject: [md PATCH 5/6] md/raid10: add failfast handling for reads.
Date: Fri, 18 Nov 2016 16:16:12 +1100
Message-ID: <147944617219.3302.11046193829428098248.stgit@noble>
References: <147944614789.3302.1959091446949640579.stgit@noble>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <147944614789.3302.1959091446949640579.stgit@noble>
Sender: linux-kernel-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org, linux-block@vger.kernel.org, Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org, hare@suse.de
List-Id: linux-raid.ids

If a device is marked FailFast, and it is not the only
device we can read from, we mark the bio as MD_FAILFAST.

If this does fail-fast, we don't try read repair but just
allow failure.

If it was the last device, it doesn't get marked Faulty so
the retry happens on the same device - this time without
FAILFAST.  A subsequent failure will not retry but will just
pass up the error.

During resync we may use FAILFAST requests, and on a failure
we will simply use the other device(s).

During recovery we will only use FAILFAST in the unusual
case were there are multiple places to read from - i.e. if
there are > 2 devices.  If we get a failure we will fail the
device and complete the resync/recovery with remaining
devices.

Signed-off-by: NeilBrown <neilb@suse.com>
---
 drivers/md/raid10.c |   49 ++++++++++++++++++++++++++++++++++++++++++++-----
 drivers/md/raid10.h |    2 ++
 2 files changed, 46 insertions(+), 5 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 763ca45b6b32..99fa1b980371 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -720,6 +720,7 @@ static struct md_rdev *read_balance(struct r10conf *conf,
 	best_dist = MaxSector;
 	best_good_sectors = 0;
 	do_balance = 1;
+	clear_bit(R10BIO_FailFast, &r10_bio->state);
 	/*
 	 * Check if we can balance. We can balance on the whole
 	 * device if no resync is going on (recovery is ok), or below
@@ -784,15 +785,18 @@ static struct md_rdev *read_balance(struct r10conf *conf,
 		if (!do_balance)
 			break;
 
+		if (best_slot >= 0)
+			/* At least 2 disks to choose from so failfast is OK */
+			set_bit(R10BIO_FailFast, &r10_bio->state);
 		/* This optimisation is debatable, and completely destroys
 		 * sequential read speed for 'far copies' arrays.  So only
 		 * keep it for 'near' arrays, and review those later.
 		 */
 		if (geo->near_copies > 1 && !atomic_read(&rdev->nr_pending))
-			break;
+			new_distance = 0;
 
 		/* for far > 1 always use the lowest address */
-		if (geo->far_copies > 1)
+		else if (geo->far_copies > 1)
 			new_distance = r10_bio->devs[slot].addr;
 		else
 			new_distance = abs(r10_bio->devs[slot].addr -
@@ -1171,6 +1175,9 @@ static void __make_request(struct mddev *mddev, struct bio *bio)
 		read_bio->bi_bdev = rdev->bdev;
 		read_bio->bi_end_io = raid10_end_read_request;
 		bio_set_op_attrs(read_bio, op, do_sync);
+		if (test_bit(FailFast, &rdev->flags) &&
+		    test_bit(R10BIO_FailFast, &r10_bio->state))
+			read_bio->bi_opf |= MD_FAILFAST;
 		read_bio->bi_private = r10_bio;
 
 		if (mddev->gendisk)
@@ -1987,6 +1994,7 @@ static void sync_request_write(struct mddev *mddev, struct r10bio *r10_bio)
 	/* now find blocks with errors */
 	for (i=0 ; i < conf->copies ; i++) {
 		int  j, d;
+		struct md_rdev *rdev;
 
 		tbio = r10_bio->devs[i].bio;
 
@@ -1994,6 +2002,8 @@ static void sync_request_write(struct mddev *mddev, struct r10bio *r10_bio)
 			continue;
 		if (i == first)
 			continue;
+		d = r10_bio->devs[i].devnum;
+		rdev = conf->mirrors[d].rdev;
 		if (!r10_bio->devs[i].bio->bi_error) {
 			/* We know that the bi_io_vec layout is the same for
 			 * both 'first' and 'i', so we just compare them.
@@ -2016,6 +2026,10 @@ static void sync_request_write(struct mddev *mddev, struct r10bio *r10_bio)
 			if (test_bit(MD_RECOVERY_CHECK, &mddev->recovery))
 				/* Don't fix anything. */
 				continue;
+		} else if (test_bit(FailFast, &rdev->flags)) {
+			/* Just give up on this device */
+			md_error(rdev->mddev, rdev);
+			continue;
 		}
 		/* Ok, we need to write this bio, either to correct an
 		 * inconsistency or to correct an unreadable block.
@@ -2033,7 +2047,6 @@ static void sync_request_write(struct mddev *mddev, struct r10bio *r10_bio)
 
 		bio_copy_data(tbio, fbio);
 
-		d = r10_bio->devs[i].devnum;
 		atomic_inc(&conf->mirrors[d].rdev->nr_pending);
 		atomic_inc(&r10_bio->remaining);
 		md_sync_acct(conf->mirrors[d].rdev->bdev, bio_sectors(tbio));
@@ -2540,12 +2553,14 @@ static void handle_read_error(struct mddev *mddev, struct r10bio *r10_bio)
 	bio_put(bio);
 	r10_bio->devs[slot].bio = NULL;
 
-	if (mddev->ro == 0) {
+	if (mddev->ro)
+		r10_bio->devs[slot].bio = IO_BLOCKED;
+	else if (!test_bit(FailFast, &rdev->flags)) {
 		freeze_array(conf, 1);
 		fix_read_error(conf, mddev, r10_bio);
 		unfreeze_array(conf);
 	} else
-		r10_bio->devs[slot].bio = IO_BLOCKED;
+		md_error(mddev, rdev);
 
 	rdev_dec_pending(rdev, mddev);
 
@@ -2574,6 +2589,9 @@ static void handle_read_error(struct mddev *mddev, struct r10bio *r10_bio)
 		+ choose_data_offset(r10_bio, rdev);
 	bio->bi_bdev = rdev->bdev;
 	bio_set_op_attrs(bio, REQ_OP_READ, do_sync);
+	if (test_bit(FailFast, &rdev->flags) &&
+	    test_bit(R10BIO_FailFast, &r10_bio->state))
+		bio->bi_opf |= MD_FAILFAST;
 	bio->bi_private = r10_bio;
 	bio->bi_end_io = raid10_end_read_request;
 	trace_block_bio_remap(bdev_get_queue(bio->bi_bdev),
@@ -3095,6 +3113,8 @@ static sector_t raid10_sync_request(struct mddev *mddev, sector_t sector_nr,
 				bio->bi_private = r10_bio;
 				bio->bi_end_io = end_sync_read;
 				bio_set_op_attrs(bio, REQ_OP_READ, 0);
+				if (test_bit(FailFast, &rdev->flags))
+					bio->bi_opf |= MD_FAILFAST;
 				from_addr = r10_bio->devs[j].addr;
 				bio->bi_iter.bi_sector = from_addr +
 					rdev->data_offset;
@@ -3200,6 +3220,23 @@ static sector_t raid10_sync_request(struct mddev *mddev, sector_t sector_nr,
 			rdev_dec_pending(mrdev, mddev);
 			if (mreplace)
 				rdev_dec_pending(mreplace, mddev);
+			if (r10_bio->devs[0].bio->bi_opf & MD_FAILFAST) {
+				/* Only want this if there is elsewhere to
+				 * read from. 'j' is currently the first
+				 * readable copy.
+				 */
+				int targets = 1;
+				for (; j < conf->copies; j++) {
+					int d = r10_bio->devs[j].devnum;
+					if (conf->mirrors[d].rdev &&
+					    test_bit(In_sync,
+						      &conf->mirrors[d].rdev->flags))
+						targets++;
+				}
+				if (targets == 1)
+					r10_bio->devs[0].bio->bi_opf
+						&= ~MD_FAILFAST;
+			}
 		}
 		if (biolist == NULL) {
 			while (r10_bio) {
@@ -3278,6 +3315,8 @@ static sector_t raid10_sync_request(struct mddev *mddev, sector_t sector_nr,
 			bio->bi_private = r10_bio;
 			bio->bi_end_io = end_sync_read;
 			bio_set_op_attrs(bio, REQ_OP_READ, 0);
+			if (test_bit(FailFast, &conf->mirrors[d].rdev->flags))
+				bio->bi_opf |= MD_FAILFAST;
 			bio->bi_iter.bi_sector = sector + rdev->data_offset;
 			bio->bi_bdev = rdev->bdev;
 			count++;
diff --git a/drivers/md/raid10.h b/drivers/md/raid10.h
index 18ec1f7a98bf..3162615e57bd 100644
--- a/drivers/md/raid10.h
+++ b/drivers/md/raid10.h
@@ -156,5 +156,7 @@ enum r10bio_state {
  * flag is set
  */
 	R10BIO_Previous,
+/* failfast devices did receive failfast requests. */
+	R10BIO_FailFast,
 };
 #endif
