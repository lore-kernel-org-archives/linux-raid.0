From: Coly Li <colyli@suse.de>
Subject: [PATCH] [RFC] md raid10: use rcu to avoid NULL dereference in raid10d()
Date: Wed, 18 Oct 2017 00:36:37 +0800
Message-ID: <20171017163637.17132-1-colyli@suse.de>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: shli@kernel.org, neilb@suse.com, linux-raid@vger.kernel.org
Cc: Coly Li <colyli@suse.de>
List-Id: linux-raid.ids

We have a bug report about NULL dereference in md raid10 code. The
operations are,
 - Create a raid10 device
 - add a spare disk
 - disconnect one of the online disks from the raid10 device
 - wait to the recovery happens on the spare disk
 - remove the spare disk which is recovering
And sometimes a kernel oops of NULL dereference in md raid10 module can
be observed, and crash tool reports the following information:
> (gdb) list *(raid10d+0xad6)
> 0x5de6 is in raid10d (../drivers/md/raid10.c:2300).
> 2295		 * the latter is free to free wbio2.
> 2296		 */
> 2297		if (wbio2 && !wbio2->bi_end_io)
> 2298			wbio2 = NULL;
> 2299		if (wbio->bi_end_io) {
> 2300			atomic_inc(&conf->mirrors[d].rdev->nr_pending);
> 2301			md_sync_acct(conf->mirrors[d].rdev->bdev, bio_sectors(wbio));
> 2302			generic_make_request(wbio);
> 2303		}
> 2304		if (wbio2) {
At line 2300, conf->mirrors[d].rdev is NULL, this causes a NULL pointer
dereference to conf->mirrors[d].rdev->nr_pending. After reading previous
raid10 patches, I find conf->mirrors[d].rdev can be NULL at any point
unless,
 - a counted reference is held
 - ->reconfig_mutex is held, or
 - rcu_read_lock() is held
In context of kernel thread raid10d, non of the above conditions happens,
therefore using rcu to protect the access to conf->mirrors[].rdev and
conf->mirrors[].replacement pointers is necessary.

This patch is an effort to add rcu protection in raid10d() code path,
which including the following sub-routines,
 - handle_write_completed()
 - reshape_request_write()
 - sync_request_write()
 - recovery_request_write() 

Because the reported issue can not be always reproduced, I am still
working on verification. This RFC patch is sent out for early feedback
in case there is something I missed in the fix.

Thanks in advance for the review and comments.

Signed-off-by: Coly Li <colyli@suse.de>
Reported-by: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
---
 drivers/md/raid10.c | 99 +++++++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 80 insertions(+), 19 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 374df5796649..fe9ce25ffc08 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -2041,13 +2041,25 @@ static void sync_request_write(struct mddev *mddev, struct r10bio *r10_bio)
 
 		tpages = get_resync_pages(tbio)->pages;
 		d = r10_bio->devs[i].devnum;
-		rdev = conf->mirrors[d].rdev;
+		rcu_read_lock();
+		rdev = rcu_dereference(conf->mirrors[d].rdev);
+		if (rdev == NULL) {
+			rcu_read_unlock();
+			continue;
+		}
+
 		if (!r10_bio->devs[i].bio->bi_status) {
 			/* We know that the bi_io_vec layout is the same for
 			 * both 'first' and 'i', so we just compare them.
 			 * All vec entries are PAGE_SIZE;
 			 */
 			int sectors = r10_bio->sectors;
+
+			/*
+			 * rdev is not referenced here, don't need rcu lock
+			 * any more.
+			 */
+			rcu_read_unlock();
 			for (j = 0; j < vcnt; j++) {
 				int len = PAGE_SIZE;
 				if (sectors < (len / 512))
@@ -2067,8 +2079,10 @@ static void sync_request_write(struct mddev *mddev, struct r10bio *r10_bio)
 		} else if (test_bit(FailFast, &rdev->flags)) {
 			/* Just give up on this device */
 			md_error(rdev->mddev, rdev);
+			rcu_read_unlock();
 			continue;
 		}
+		rcu_read_unlock();
 		/* Ok, we need to write this bio, either to correct an
 		 * inconsistency or to correct an unreadable block.
 		 * First we need to fixup bv_offset, bv_len and
@@ -2087,14 +2101,21 @@ static void sync_request_write(struct mddev *mddev, struct r10bio *r10_bio)
 
 		bio_copy_data(tbio, fbio);
 
-		atomic_inc(&conf->mirrors[d].rdev->nr_pending);
+		rcu_read_lock();
+		rdev = rcu_dereference(conf->mirrors[d].rdev);
+		if (rdev == NULL) {
+			rcu_read_unlock();
+			continue;
+		}
+		atomic_inc(&rdev->nr_pending);
 		atomic_inc(&r10_bio->remaining);
-		md_sync_acct(conf->mirrors[d].rdev->bdev, bio_sectors(tbio));
+		md_sync_acct(rdev->bdev, bio_sectors(tbio));
 
-		if (test_bit(FailFast, &conf->mirrors[d].rdev->flags))
+		if (test_bit(FailFast, &rdev->flags))
 			tbio->bi_opf |= MD_FAILFAST;
-		tbio->bi_iter.bi_sector += conf->mirrors[d].rdev->data_offset;
-		bio_set_dev(tbio, conf->mirrors[d].rdev->bdev);
+		tbio->bi_iter.bi_sector += rdev->data_offset;
+		bio_set_dev(tbio, rdev->bdev);
+		rcu_read_unlock();
 		generic_make_request(tbio);
 	}
 
@@ -2222,6 +2243,7 @@ static void recovery_request_write(struct mddev *mddev, struct r10bio *r10_bio)
 	struct r10conf *conf = mddev->private;
 	int d;
 	struct bio *wbio, *wbio2;
+	struct md_rdev *rdev, *replacement;
 
 	if (!test_bit(R10BIO_Uptodate, &r10_bio->state)) {
 		fix_recovery_read_error(r10_bio);
@@ -2236,6 +2258,8 @@ static void recovery_request_write(struct mddev *mddev, struct r10bio *r10_bio)
 	d = r10_bio->devs[1].devnum;
 	wbio = r10_bio->devs[1].bio;
 	wbio2 = r10_bio->devs[1].repl_bio;
+
+
 	/* Need to test wbio2->bi_end_io before we call
 	 * generic_make_request as if the former is NULL,
 	 * the latter is free to free wbio2.
@@ -2243,15 +2267,25 @@ static void recovery_request_write(struct mddev *mddev, struct r10bio *r10_bio)
 	if (wbio2 && !wbio2->bi_end_io)
 		wbio2 = NULL;
 	if (wbio->bi_end_io) {
-		atomic_inc(&conf->mirrors[d].rdev->nr_pending);
-		md_sync_acct(conf->mirrors[d].rdev->bdev, bio_sectors(wbio));
-		generic_make_request(wbio);
+		rcu_read_lock();
+		rdev = rcu_dereference(conf->mirrors[d].rdev);
+		if (rdev) {
+			atomic_inc(&rdev->nr_pending);
+			md_sync_acct(rdev->bdev, bio_sectors(wbio));
+			generic_make_request(wbio);
+		}
+		rcu_read_unlock();
 	}
 	if (wbio2) {
-		atomic_inc(&conf->mirrors[d].replacement->nr_pending);
-		md_sync_acct(conf->mirrors[d].replacement->bdev,
+		rcu_read_lock();
+		replacement = rcu_dereference(conf->mirrors[d].replacement);
+		if (replacement) {
+			atomic_inc(&replacement->nr_pending);
+			md_sync_acct(replacement->bdev,
 			     bio_sectors(wbio2));
-		generic_make_request(wbio2);
+			generic_make_request(wbio2);
+		}
+		rcu_read_unlock();
 	}
 }
 
@@ -2620,9 +2654,17 @@ static void handle_write_completed(struct r10conf *conf, struct r10bio *r10_bio)
 	    test_bit(R10BIO_IsRecover, &r10_bio->state)) {
 		for (m = 0; m < conf->copies; m++) {
 			int dev = r10_bio->devs[m].devnum;
-			rdev = conf->mirrors[dev].rdev;
-			if (r10_bio->devs[m].bio == NULL)
+
+			rcu_read_lock();
+			rdev = rcu_dereference(conf->mirrors[dev].rdev);
+			if (rdev == NULL) {
+				rcu_read_unlock();
+				continue;
+			}
+			if (r10_bio->devs[m].bio == NULL) {
+				rcu_read_unlock();
 				continue;
+			}
 			if (!r10_bio->devs[m].bio->bi_status) {
 				rdev_clear_badblocks(
 					rdev,
@@ -2635,9 +2677,16 @@ static void handle_write_completed(struct r10conf *conf, struct r10bio *r10_bio)
 					    r10_bio->sectors, 0))
 					md_error(conf->mddev, rdev);
 			}
-			rdev = conf->mirrors[dev].replacement;
-			if (r10_bio->devs[m].repl_bio == NULL)
+
+			rdev = rcu_dereference(conf->mirrors[dev].replacement);
+			if (rdev == NULL) {
+				rcu_read_unlock();
 				continue;
+			}
+			if (r10_bio->devs[m].repl_bio == NULL) {
+				rcu_read_unlock();
+				continue;
+			}
 
 			if (!r10_bio->devs[m].repl_bio->bi_status) {
 				rdev_clear_badblocks(
@@ -2651,6 +2700,7 @@ static void handle_write_completed(struct r10conf *conf, struct r10bio *r10_bio)
 					    r10_bio->sectors, 0))
 					md_error(conf->mddev, rdev);
 			}
+			rcu_read_unlock();
 		}
 		put_buf(r10_bio);
 	} else {
@@ -2658,7 +2708,13 @@ static void handle_write_completed(struct r10conf *conf, struct r10bio *r10_bio)
 		for (m = 0; m < conf->copies; m++) {
 			int dev = r10_bio->devs[m].devnum;
 			struct bio *bio = r10_bio->devs[m].bio;
-			rdev = conf->mirrors[dev].rdev;
+
+			rcu_read_lock();
+			rdev = rcu_dereference(conf->mirrors[dev].rdev);
+			if (rdev == NULL) {
+				rcu_read_unlock();
+				continue;
+			}
 			if (bio == IO_MADE_GOOD) {
 				rdev_clear_badblocks(
 					rdev,
@@ -2675,14 +2731,19 @@ static void handle_write_completed(struct r10conf *conf, struct r10bio *r10_bio)
 				rdev_dec_pending(rdev, conf->mddev);
 			}
 			bio = r10_bio->devs[m].repl_bio;
-			rdev = conf->mirrors[dev].replacement;
-			if (rdev && bio == IO_MADE_GOOD) {
+			rdev = rcu_dereference(conf->mirrors[dev].replacement);
+			if (rdev == NULL) {
+				rcu_read_unlock();
+				continue;
+			}
+			if (bio == IO_MADE_GOOD) {
 				rdev_clear_badblocks(
 					rdev,
 					r10_bio->devs[m].addr,
 					r10_bio->sectors, 0);
 				rdev_dec_pending(rdev, conf->mddev);
 			}
+			rcu_read_unlock();
 		}
 		if (fail) {
 			spin_lock_irq(&conf->device_lock);
-- 
2.13.6

