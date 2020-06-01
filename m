From: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Subject: [PATCH] md: improve io stats accounting
Date: Mon,  1 Jun 2020 18:12:56 +0200
Message-ID: <20200601161256.27718-1-artur.paszkiewicz@intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: song@kernel.org
Cc: linux-raid@vger.kernel.org, Artur Paszkiewicz <artur.paszkiewicz@intel.com>
List-Id: linux-raid.ids

Use generic io accounting functions to manage io stats. There was an
attempt to do this earlier in commit 18c0b223cf990172 ("md: use generic
io stats accounting functions to simplify io stat accounting"), but it
did not include a call to generic_end_io_acct() and caused issues with
tracking in-flight IOs, so it was later removed in commit
74672d069b298b03 ("md: fix md io stats accounting broken").

This patch attempts to fix this by using both generic_start_io_acct()
and generic_end_io_acct(). To make it possible, in md_make_request() a
bio is cloned with additional data - struct md_io, which includes the io
start_time. A new bioset is introduced for this purpose. We call
generic_start_io_acct() and pass the clone instead of the original to
md_handle_request(). When it completes, we call generic_end_io_acct()
and complete the original bio.

This adds correct statistics about in-flight IOs and IO processing time,
interpreted e.g. in iostat as await, svctm, aqu-sz and %util.

It also fixes a situation where too many IOs where reported if a bio was
re-submitted to the mddev, because io accounting is now performed only
on newly arriving bios.

Signed-off-by: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
---
 drivers/md/md.c | 65 +++++++++++++++++++++++++++++++++++++++----------
 drivers/md/md.h |  1 +
 2 files changed, 53 insertions(+), 13 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index f567f536b529..5a9f167ef5b9 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -463,12 +463,32 @@ void md_handle_request(struct mddev *mddev, struct bio *bio)
 }
 EXPORT_SYMBOL(md_handle_request);
 
+struct md_io {
+	struct mddev *mddev;
+	struct bio *orig_bio;
+	unsigned long start_time;
+	struct bio orig_bio_clone;
+};
+
+static void md_end_request(struct bio *bio)
+{
+	struct md_io *md_io = bio->bi_private;
+	struct mddev *mddev = md_io->mddev;
+	struct bio *orig_bio = md_io->orig_bio;
+
+	orig_bio->bi_status = bio->bi_status;
+
+	generic_end_io_acct(mddev->queue, bio_op(orig_bio),
+			    &mddev->gendisk->part0, md_io->start_time);
+	bio_put(bio);
+
+	bio_endio(orig_bio);
+}
+
 static blk_qc_t md_make_request(struct request_queue *q, struct bio *bio)
 {
 	const int rw = bio_data_dir(bio);
-	const int sgrp = op_stat_group(bio_op(bio));
 	struct mddev *mddev = bio->bi_disk->private_data;
-	unsigned int sectors;
 
 	if (unlikely(test_bit(MD_BROKEN, &mddev->flags)) && (rw == WRITE)) {
 		bio_io_error(bio);
@@ -488,21 +508,30 @@ static blk_qc_t md_make_request(struct request_queue *q, struct bio *bio)
 		return BLK_QC_T_NONE;
 	}
 
-	/*
-	 * save the sectors now since our bio can
-	 * go away inside make_request
-	 */
-	sectors = bio_sectors(bio);
+	if (bio->bi_pool != &mddev->md_io_bs) {
+		struct bio *clone;
+		struct md_io *md_io;
+
+		clone = bio_clone_fast(bio, GFP_NOIO, &mddev->md_io_bs);
+
+		md_io = container_of(clone, struct md_io, orig_bio_clone);
+		md_io->mddev = mddev;
+		md_io->orig_bio = bio;
+		md_io->start_time = jiffies;
+
+		clone->bi_end_io = md_end_request;
+		clone->bi_private = md_io;
+		bio = clone;
+
+		generic_start_io_acct(mddev->queue, bio_op(bio),
+				      bio_sectors(bio), &mddev->gendisk->part0);
+	}
+
 	/* bio could be mergeable after passing to underlayer */
 	bio->bi_opf &= ~REQ_NOMERGE;
 
 	md_handle_request(mddev, bio);
 
-	part_stat_lock();
-	part_stat_inc(&mddev->gendisk->part0, ios[sgrp]);
-	part_stat_add(&mddev->gendisk->part0, sectors[sgrp], sectors);
-	part_stat_unlock();
-
 	return BLK_QC_T_NONE;
 }
 
@@ -2338,7 +2367,8 @@ int md_integrity_register(struct mddev *mddev)
 			       bdev_get_integrity(reference->bdev));
 
 	pr_debug("md: data integrity enabled on %s\n", mdname(mddev));
-	if (bioset_integrity_create(&mddev->bio_set, BIO_POOL_SIZE)) {
+	if (bioset_integrity_create(&mddev->bio_set, BIO_POOL_SIZE) ||
+	    bioset_integrity_create(&mddev->md_io_bs, BIO_POOL_SIZE)) {
 		pr_err("md: failed to create integrity pool for %s\n",
 		       mdname(mddev));
 		return -EINVAL;
@@ -5545,6 +5575,7 @@ static void md_free(struct kobject *ko)
 
 	bioset_exit(&mddev->bio_set);
 	bioset_exit(&mddev->sync_set);
+	bioset_exit(&mddev->md_io_bs);
 	kfree(mddev);
 }
 
@@ -5838,6 +5869,12 @@ int md_run(struct mddev *mddev)
 		if (err)
 			return err;
 	}
+	if (!bioset_initialized(&mddev->md_io_bs)) {
+		err = bioset_init(&mddev->md_io_bs, BIO_POOL_SIZE,
+				  offsetof(struct md_io, orig_bio_clone), 0);
+		if (err)
+			return err;
+	}
 
 	spin_lock(&pers_lock);
 	pers = find_pers(mddev->level, mddev->clevel);
@@ -6015,6 +6052,7 @@ int md_run(struct mddev *mddev)
 abort:
 	bioset_exit(&mddev->bio_set);
 	bioset_exit(&mddev->sync_set);
+	bioset_exit(&mddev->md_io_bs);
 	return err;
 }
 EXPORT_SYMBOL_GPL(md_run);
@@ -6239,6 +6277,7 @@ void md_stop(struct mddev *mddev)
 	__md_stop(mddev);
 	bioset_exit(&mddev->bio_set);
 	bioset_exit(&mddev->sync_set);
+	bioset_exit(&mddev->md_io_bs);
 }
 
 EXPORT_SYMBOL_GPL(md_stop);
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 612814d07d35..74273728b898 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -481,6 +481,7 @@ struct mddev {
 	struct bio_set			sync_set; /* for sync operations like
 						   * metadata and bitmap writes
 						   */
+	struct bio_set			md_io_bs;
 
 	/* Generic flush handling.
 	 * The last to finish preflush schedules a worker to submit
-- 
2.26.0
