From: Paul Clements <Paul.Clements@SteelEye.com>
Subject: [PATCH] raid1: abort resync if there are no spare drives
Date: Wed, 25 Feb 2004 16:39:10 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <403D15FE.CAACDC4A@SteelEye.com>
References: <20040223024124.GA1590@psilocybus> <16441.33071.218049.163976@notabene.cse.unsw.edu.au> <403A30F9.D54AAC68@SteelEye.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------5BF60CB0208FD7E6A670FBEC"
Return-path: <linux-raid-owner@vger.kernel.org>
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is a multi-part message in MIME format.
--------------5BF60CB0208FD7E6A670FBEC
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

The attached patch makes sure that resync/recovery get aborted (and
status recorded correctly) when there are no spare drives left (due to
the failure of a spare during a resync). Previously, if a spare failed
during a resync, the resync would continue until completed (and would
appear to be successful). 

Also, there was an erroneous usage of master_bio->bi_bdev field (which
is not always properly set) that has been changed to the simpler
comparison vs. r1_bio->read_disk (as is done in raid1_end_request). I
think Neil has already addressed this issue in another patch that has
been pushed to Andrew...

Thanks,
Paul
--------------5BF60CB0208FD7E6A670FBEC
Content-Type: text/x-patch; charset=us-ascii;
 name="raid1_abort_sync_no_targets.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="raid1_abort_sync_no_targets.diff"

--- raid1.c.PRISTINE	Tue Feb 24 16:10:26 2004
+++ raid1.c	Wed Feb 25 16:22:34 2004
@@ -818,6 +818,8 @@ static void sync_request_write(mddev_t *
 		put_buf(r1_bio);
 		return;
 	}
+	/* assume failure until we find a drive to write this to */
+	clear_bit(R1BIO_Uptodate, &r1_bio->state);
 
 	spin_lock_irq(&conf->device_lock);
 	for (i = 0; i < disks ; i++) {
@@ -825,7 +827,7 @@ static void sync_request_write(mddev_t *
 		if (!conf->mirrors[i].rdev || 
 		    conf->mirrors[i].rdev->faulty)
 			continue;
-		if (conf->mirrors[i].rdev->bdev == bio->bi_bdev)
+		if (i == r1_bio->read_disk)
 			/*
 			 * we read from here, no need to write
 			 */
@@ -838,6 +840,8 @@ static void sync_request_write(mddev_t *
 			continue;
 		atomic_inc(&conf->mirrors[i].rdev->nr_pending);
 		r1_bio->write_bios[i] = bio;
+		/* we found a drive to write to */
+		set_bit(R1BIO_Uptodate, &r1_bio->state);
 	}
 	spin_unlock_irq(&conf->device_lock);
 
@@ -859,7 +863,8 @@ static void sync_request_write(mddev_t *
 	}
 
 	if (atomic_dec_and_test(&r1_bio->remaining)) {
-		md_done_sync(mddev, r1_bio->master_bio->bi_size >> 9, 1);
+		md_done_sync(mddev, r1_bio->master_bio->bi_size >> 9,
+				test_bit(R1BIO_Uptodate, &r1_bio->state));
 		put_buf(r1_bio);
 	}
 }

--------------5BF60CB0208FD7E6A670FBEC--

