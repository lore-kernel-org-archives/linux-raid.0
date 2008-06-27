From: NeilBrown <neilb@suse.de>
Subject: [PATCH 005 of 29] md: use bio_endio instead of a call to bi_end_io
Date: Fri, 27 Jun 2008 16:49:50 +1000
Message-ID: <1080627064950.10364@suse.de>
References: <20080627164503.9671.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, Mikulas Patocka <mpatocka@redhat.com>
List-Id: linux-raid.ids


Turn calls to bi->bi_end_io() into bio_endio(). Apparently bio_endio does
exactly the same error processing as is hardcoded at these places.

bio_endio() avoids recursion (or will soon), so it should be used.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/raid5.c |   16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

diff .prev/drivers/md/raid5.c ./drivers/md/raid5.c
--- .prev/drivers/md/raid5.c	2008-06-27 15:22:48.000000000 +1000
+++ ./drivers/md/raid5.c	2008-06-27 15:31:23.000000000 +1000
@@ -115,9 +115,7 @@ static void return_io(struct bio *return
 		return_bi = bi->bi_next;
 		bi->bi_next = NULL;
 		bi->bi_size = 0;
-		bi->bi_end_io(bi,
-			      test_bit(BIO_UPTODATE, &bi->bi_flags)
-			        ? 0 : -EIO);
+		bio_endio(bi, 0);
 		bi = return_bi;
 	}
 }
@@ -3700,9 +3698,7 @@ static int make_request(struct request_q
 		if ( rw == WRITE )
 			md_write_end(mddev);
 
-		bi->bi_end_io(bi,
-			      test_bit(BIO_UPTODATE, &bi->bi_flags)
-			        ? 0 : -EIO);
+		bio_endio(bi, 0);
 	}
 	return 0;
 }
@@ -4005,12 +4001,8 @@ static int  retry_aligned_read(raid5_con
 	spin_lock_irq(&conf->device_lock);
 	remaining = --raid_bio->bi_phys_segments;
 	spin_unlock_irq(&conf->device_lock);
-	if (remaining == 0) {
-
-		raid_bio->bi_end_io(raid_bio,
-			      test_bit(BIO_UPTODATE, &raid_bio->bi_flags)
-			        ? 0 : -EIO);
-	}
+	if (remaining == 0)
+		bio_endio(raid_bio, 0);
 	if (atomic_dec_and_test(&conf->active_aligned_reads))
 		wake_up(&conf->wait_for_stripe);
 	return handled;
