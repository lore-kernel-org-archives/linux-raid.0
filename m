From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 06/23] md: allow last device to be forcibly removed from
 RAID1/RAID10.
Date: Wed, 14 Mar 2012 15:40:39 +1100
Message-ID: <20120314044039.7978.58429.stgit@notabene.brown>
References: <20120314043555.7978.75486.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120314043555.7978.75486.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

When the 'last' device in a RAID1 or RAID10 reports an error,
we do not mark it as failed.  This would serve little purpose
as there is no risk of losing data beyond that which is obviously
lost (as there is with RAID5), and there could be other sectors
on the device which are readable, and only readable from this device.
This in general this maximises access to data.

However the current implementation also stops an admin from removing
the last device by direct action.  This is rarely useful, but in many
case is not harmful and can make automation easier by removing special
cases.

Also, if an attempt to write metadata fails the device must be marked
as faulty, else an infinite loop will result, attempting to update
the metadata on all non-faulty devices.

So add a 'force' option to 'md_error()' and '*errorhandler()' which
bypasses the 'last disk' checks for RAID1 and RAID10.
Set it when the removal is explicitly requested by user-space, or
when it is the result of a failed metadata write.

Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/md.c        |   16 ++++++++--------
 drivers/md/md.h        |    4 ++--
 drivers/md/multipath.c |    6 +++---
 drivers/md/raid1.c     |   13 +++++++------
 drivers/md/raid10.c    |   19 ++++++++++---------
 drivers/md/raid5.c     |   10 +++++-----
 6 files changed, 35 insertions(+), 33 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index ce88755..3ca53c6 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -825,7 +825,7 @@ static void super_written(struct bio *bio, int error)
 		printk("md: super_written gets error=%d, uptodate=%d\n",
 		       error, test_bit(BIO_UPTODATE, &bio->bi_flags));
 		WARN_ON(test_bit(BIO_UPTODATE, &bio->bi_flags));
-		md_error(mddev, rdev);
+		md_error(mddev, rdev, 1);
 	}
 
 	if (atomic_dec_and_test(&mddev->pending_writes))
@@ -1785,7 +1785,7 @@ static void super_1_sync(struct mddev *mddev, struct md_rdev *rdev)
 		/* Nothing to do for bad blocks*/ ;
 	else if (sb->bblog_offset == 0)
 		/* Cannot record bad blocks on this device */
-		md_error(mddev, rdev);
+		md_error(mddev, rdev, 0);
 	else {
 		struct badblocks *bb = &rdev->badblocks;
 		u64 *bbp = (u64 *)page_address(rdev->bb_page);
@@ -2367,7 +2367,7 @@ repeat:
 			list_for_each_entry(rdev, &mddev->disks, same_set) {
 				if (rdev->badblocks.changed) {
 					md_ack_all_badblocks(&rdev->badblocks);
-					md_error(mddev, rdev);
+					md_error(mddev, rdev, 0);
 				}
 				clear_bit(Blocked, &rdev->flags);
 				clear_bit(BlockedBadBlocks, &rdev->flags);
@@ -2592,7 +2592,7 @@ state_store(struct md_rdev *rdev, const char *buf, size_t len)
 	 */
 	int err = -EINVAL;
 	if (cmd_match(buf, "faulty") && rdev->mddev->pers) {
-		md_error(rdev->mddev, rdev);
+		md_error(rdev->mddev, rdev, 1);
 		if (test_bit(Faulty, &rdev->flags))
 			err = 0;
 		else
@@ -2623,7 +2623,7 @@ state_store(struct md_rdev *rdev, const char *buf, size_t len)
 			/* metadata handler doesn't understand badblocks,
 			 * so we need to fail the device
 			 */
-			md_error(rdev->mddev, rdev);
+			md_error(rdev->mddev, rdev, 1);
 		}
 		clear_bit(Blocked, &rdev->flags);
 		clear_bit(BlockedBadBlocks, &rdev->flags);
@@ -6069,7 +6069,7 @@ static int set_disk_faulty(struct mddev *mddev, dev_t dev)
 	if (!rdev)
 		return -ENODEV;
 
-	md_error(mddev, rdev);
+	md_error(mddev, rdev, 1);
 	if (!test_bit(Faulty, &rdev->flags))
 		return -EBUSY;
 	return 0;
@@ -6524,7 +6524,7 @@ void md_unregister_thread(struct md_thread **threadp)
 	kfree(thread);
 }
 
-void md_error(struct mddev *mddev, struct md_rdev *rdev)
+void md_error(struct mddev *mddev, struct md_rdev *rdev, int force)
 {
 	if (!mddev) {
 		MD_BUG();
@@ -6536,7 +6536,7 @@ void md_error(struct mddev *mddev, struct md_rdev *rdev)
 
 	if (!mddev->pers || !mddev->pers->error_handler)
 		return;
-	mddev->pers->error_handler(mddev,rdev);
+	mddev->pers->error_handler(mddev, rdev, force);
 	if (mddev->degraded)
 		set_bit(MD_RECOVERY_RECOVER, &mddev->recovery);
 	sysfs_notify_dirent_safe(rdev->sysfs_state);
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 44c63df..457885a 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -437,7 +437,7 @@ struct md_personality
 	/* error_handler must set ->faulty and clear ->in_sync
 	 * if appropriate, and should abort recovery if needed 
 	 */
-	void (*error_handler)(struct mddev *mddev, struct md_rdev *rdev);
+	void (*error_handler)(struct mddev *mddev, struct md_rdev *rdev, int force);
 	int (*hot_add_disk) (struct mddev *mddev, struct md_rdev *rdev);
 	int (*hot_remove_disk) (struct mddev *mddev, struct md_rdev *rdev);
 	int (*spare_active) (struct mddev *mddev);
@@ -579,7 +579,7 @@ extern void md_check_recovery(struct mddev *mddev);
 extern void md_write_start(struct mddev *mddev, struct bio *bi);
 extern void md_write_end(struct mddev *mddev);
 extern void md_done_sync(struct mddev *mddev, int blocks, int ok);
-extern void md_error(struct mddev *mddev, struct md_rdev *rdev);
+extern void md_error(struct mddev *mddev, struct md_rdev *rdev, int force);
 
 extern int mddev_congested(struct mddev *mddev, int bits);
 extern void md_flush_request(struct mddev *mddev, struct bio *bio);
diff --git a/drivers/md/multipath.c b/drivers/md/multipath.c
index a222f51..e626567 100644
--- a/drivers/md/multipath.c
+++ b/drivers/md/multipath.c
@@ -97,7 +97,7 @@ static void multipath_end_request(struct bio *bio, int error)
 		 * oops, IO error:
 		 */
 		char b[BDEVNAME_SIZE];
-		md_error (mp_bh->mddev, rdev);
+		md_error (mp_bh->mddev, rdev, 0);
 		printk(KERN_ERR "multipath: %s: rescheduling sector %llu\n", 
 		       bdevname(rdev->bdev,b), 
 		       (unsigned long long)bio->bi_sector);
@@ -184,12 +184,12 @@ static int multipath_congested(void *data, int bits)
 /*
  * Careful, this can execute in IRQ contexts as well!
  */
-static void multipath_error (struct mddev *mddev, struct md_rdev *rdev)
+static void multipath_error(struct mddev *mddev, struct md_rdev *rdev, int force)
 {
 	struct mpconf *conf = mddev->private;
 	char b[BDEVNAME_SIZE];
 
-	if (conf->raid_disks - mddev->degraded <= 1) {
+	if (conf->raid_disks - mddev->degraded <= 1 && !force) {
 		/*
 		 * Uh oh, we can do nothing if this is our last path, but
 		 * first check if this is a queued request for a device
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index a0b225e..cb04d56 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1188,7 +1188,7 @@ static void status(struct seq_file *seq, struct mddev *mddev)
 }
 
 
-static void error(struct mddev *mddev, struct md_rdev *rdev)
+static void error(struct mddev *mddev, struct md_rdev *rdev, int force)
 {
 	char b[BDEVNAME_SIZE];
 	struct r1conf *conf = mddev->private;
@@ -1200,6 +1200,7 @@ static void error(struct mddev *mddev, struct md_rdev *rdev)
 	 * else mark the drive as failed
 	 */
 	if (test_bit(In_sync, &rdev->flags)
+	    && !force
 	    && (conf->raid_disks - mddev->degraded) == 1) {
 		/*
 		 * Don't fail the drive, act as though we were just a
@@ -1518,7 +1519,7 @@ static int r1_sync_page_io(struct md_rdev *rdev, sector_t sector,
 	}
 	/* need to record an error - either for the block or the device */
 	if (!rdev_set_badblocks(rdev, sector, sectors, 0))
-		md_error(rdev->mddev, rdev);
+		md_error(rdev->mddev, rdev, 0);
 	return 0;
 }
 
@@ -1819,7 +1820,7 @@ static void fix_read_error(struct r1conf *conf, int read_disk,
 			/* Cannot read from anywhere - mark it bad */
 			struct md_rdev *rdev = conf->mirrors[read_disk].rdev;
 			if (!rdev_set_badblocks(rdev, sect, s, 0))
-				md_error(mddev, rdev);
+				md_error(mddev, rdev, 0);
 			break;
 		}
 		/* write it back and re-read */
@@ -1972,7 +1973,7 @@ static void handle_sync_write_finished(struct r1conf *conf, struct r1bio *r1_bio
 		if (!test_bit(BIO_UPTODATE, &bio->bi_flags) &&
 		    test_bit(R1BIO_WriteError, &r1_bio->state)) {
 			if (!rdev_set_badblocks(rdev, r1_bio->sector, s, 0))
-				md_error(conf->mddev, rdev);
+				md_error(conf->mddev, rdev, 0);
 		}
 	}
 	put_buf(r1_bio);
@@ -1996,7 +1997,7 @@ static void handle_write_finished(struct r1conf *conf, struct r1bio *r1_bio)
 			 */
 			if (!narrow_write_error(r1_bio, m)) {
 				md_error(conf->mddev,
-					 conf->mirrors[m].rdev);
+					 conf->mirrors[m].rdev, 0);
 				/* an I/O failed, we can't clear the bitmap */
 				set_bit(R1BIO_Degraded, &r1_bio->state);
 			}
@@ -2032,7 +2033,7 @@ static void handle_read_error(struct r1conf *conf, struct r1bio *r1_bio)
 			       r1_bio->sector, r1_bio->sectors);
 		unfreeze_array(conf);
 	} else
-		md_error(mddev, conf->mirrors[r1_bio->read_disk].rdev);
+		md_error(mddev, conf->mirrors[r1_bio->read_disk].rdev, 0);
 
 	bio = r1_bio->bios[r1_bio->read_disk];
 	bdevname(bio->bi_bdev, b);
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 1a19c96..1497cd6 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -430,7 +430,7 @@ static void raid10_end_write_request(struct bio *bio, int error)
 			/* Never record new bad blocks to replacement,
 			 * just fail it.
 			 */
-			md_error(rdev->mddev, rdev);
+			md_error(rdev->mddev, rdev, 1);
 		else {
 			set_bit(WriteErrorSeen,	&rdev->flags);
 			if (!test_and_set_bit(WantReplacement, &rdev->flags))
@@ -1352,7 +1352,7 @@ static int enough(struct r10conf *conf, int ignore)
 	return 1;
 }
 
-static void error(struct mddev *mddev, struct md_rdev *rdev)
+static void error(struct mddev *mddev, struct md_rdev *rdev, int force)
 {
 	char b[BDEVNAME_SIZE];
 	struct r10conf *conf = mddev->private;
@@ -1364,6 +1364,7 @@ static void error(struct mddev *mddev, struct md_rdev *rdev)
 	 * else mark the drive as failed
 	 */
 	if (test_bit(In_sync, &rdev->flags)
+	    && !force
 	    && !enough(conf, rdev->raid_disk))
 		/*
 		 * Don't fail the drive, just return an IO error.
@@ -1687,7 +1688,7 @@ static void end_sync_write(struct bio *bio, int error)
 
 	if (!uptodate) {
 		if (repl)
-			md_error(mddev, rdev);
+			md_error(mddev, rdev, 1);
 		else {
 			set_bit(WriteErrorSeen, &rdev->flags);
 			if (!test_and_set_bit(WantReplacement, &rdev->flags))
@@ -2019,7 +2020,7 @@ static int r10_sync_page_io(struct md_rdev *rdev, sector_t sector,
 	}
 	/* need to record an error - either for the block or the device */
 	if (!rdev_set_badblocks(rdev, sector, sectors, 0))
-		md_error(rdev->mddev, rdev);
+		md_error(rdev->mddev, rdev, 0);
 	return 0;
 }
 
@@ -2063,7 +2064,7 @@ static void fix_read_error(struct r10conf *conf, struct mddev *mddev, struct r10
 		printk(KERN_NOTICE
 		       "md/raid10:%s: %s: Failing raid device\n",
 		       mdname(mddev), b);
-		md_error(mddev, conf->mirrors[d].rdev);
+		md_error(mddev, conf->mirrors[d].rdev, 0);
 		r10_bio->devs[r10_bio->read_slot].bio = IO_BLOCKED;
 		return;
 	}
@@ -2119,7 +2120,7 @@ static void fix_read_error(struct r10conf *conf, struct mddev *mddev, struct r10
 				    r10_bio->devs[r10_bio->read_slot].addr
 				    + sect,
 				    s, 0)) {
-				md_error(mddev, rdev);
+				md_error(mddev, rdev, 0);
 				r10_bio->devs[r10_bio->read_slot].bio
 					= IO_BLOCKED;
 			}
@@ -2423,7 +2424,7 @@ static void handle_write_completed(struct r10conf *conf, struct r10bio *r10_bio)
 					    rdev,
 					    r10_bio->devs[m].addr,
 					    r10_bio->sectors, 0))
-					md_error(conf->mddev, rdev);
+					md_error(conf->mddev, rdev, 0);
 			}
 			rdev = conf->mirrors[dev].replacement;
 			if (r10_bio->devs[m].repl_bio == NULL)
@@ -2439,7 +2440,7 @@ static void handle_write_completed(struct r10conf *conf, struct r10bio *r10_bio)
 					    rdev,
 					    r10_bio->devs[m].addr,
 					    r10_bio->sectors, 0))
-					md_error(conf->mddev, rdev);
+					md_error(conf->mddev, rdev, 0);
 			}
 		}
 		put_buf(r10_bio);
@@ -2457,7 +2458,7 @@ static void handle_write_completed(struct r10conf *conf, struct r10bio *r10_bio)
 			} else if (bio != NULL &&
 				   !test_bit(BIO_UPTODATE, &bio->bi_flags)) {
 				if (!narrow_write_error(r10_bio, m)) {
-					md_error(conf->mddev, rdev);
+					md_error(conf->mddev, rdev, 0);
 					set_bit(R10BIO_Degraded,
 						&r10_bio->state);
 				}
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 99b2bbf..d3b2fbf 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -1738,7 +1738,7 @@ static void raid5_end_read_request(struct bio * bi, int error)
 		else {
 			clear_bit(R5_ReadError, &sh->dev[i].flags);
 			clear_bit(R5_ReWrite, &sh->dev[i].flags);
-			md_error(conf->mddev, rdev);
+			md_error(conf->mddev, rdev, 0);
 		}
 	}
 	rdev_dec_pending(rdev, conf->mddev);
@@ -1786,7 +1786,7 @@ static void raid5_end_write_request(struct bio *bi, int error)
 
 	if (replacement) {
 		if (!uptodate)
-			md_error(conf->mddev, rdev);
+			md_error(conf->mddev, rdev, 0);
 		else if (is_badblock(rdev, sh->sector,
 				     STRIPE_SECTORS,
 				     &first_bad, &bad_sectors))
@@ -1835,7 +1835,7 @@ static void raid5_build_block(struct stripe_head *sh, int i, int previous)
 	dev->sector = compute_blocknr(sh, i, previous);
 }
 
-static void error(struct mddev *mddev, struct md_rdev *rdev)
+static void error(struct mddev *mddev, struct md_rdev *rdev, int force)
 {
 	char b[BDEVNAME_SIZE];
 	struct r5conf *conf = mddev->private;
@@ -2383,7 +2383,7 @@ handle_failed_stripe(struct r5conf *conf, struct stripe_head *sh,
 					    rdev,
 					    sh->sector,
 					    STRIPE_SECTORS, 0))
-					md_error(conf->mddev, rdev);
+					md_error(conf->mddev, rdev, 0);
 				rdev_dec_pending(rdev, conf->mddev);
 			}
 		}
@@ -3550,7 +3550,7 @@ finish:
 				rdev = conf->disks[i].rdev;
 				if (!rdev_set_badblocks(rdev, sh->sector,
 							STRIPE_SECTORS, 0))
-					md_error(conf->mddev, rdev);
+					md_error(conf->mddev, rdev, 0);
 				rdev_dec_pending(rdev, conf->mddev);
 			}
 			if (test_and_clear_bit(R5_MadeGood, &dev->flags)) {


