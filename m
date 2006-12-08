From: NeilBrown <neilb@suse.de>
Subject: [PATCH 002 of 5] md: Return a non-zero error to bi_end_io as appropriate in raid5.
Date: Fri, 8 Dec 2006 12:05:37 +1100
Message-ID: <1061208010537.21307@suse.de>
References: <20061208120132.21203.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids


Currently raid5 depends on clearing the BIO_UPTODATE flag to signal an
error to higher levels.  While this should be sufficient, it is safer
to explicitly set the error code as well - less room for confusion.

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/raid5.c |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff .prev/drivers/md/raid5.c ./drivers/md/raid5.c
--- .prev/drivers/md/raid5.c	2006-12-07 15:33:40.000000000 +1100
+++ ./drivers/md/raid5.c	2006-12-07 15:44:41.000000000 +1100
@@ -1818,7 +1818,9 @@ static void handle_stripe5(struct stripe
 		return_bi = bi->bi_next;
 		bi->bi_next = NULL;
 		bi->bi_size = 0;
-		bi->bi_end_io(bi, bytes, 0);
+		bi->bi_end_io(bi, bytes,
+			      test_bit(BIO_UPTODATE, &bi->bi_flags)
+			        ? 0 : -EIO);
 	}
 	for (i=disks; i-- ;) {
 		int rw;
@@ -2359,7 +2361,9 @@ static void handle_stripe6(struct stripe
 		return_bi = bi->bi_next;
 		bi->bi_next = NULL;
 		bi->bi_size = 0;
-		bi->bi_end_io(bi, bytes, 0);
+		bi->bi_end_io(bi, bytes,
+			      test_bit(BIO_UPTODATE, &bi->bi_flags)
+			        ? 0 : -EIO);
 	}
 	for (i=disks; i-- ;) {
 		int rw;
@@ -2859,7 +2863,9 @@ static int make_request(request_queue_t 
 		if ( rw == WRITE )
 			md_write_end(mddev);
 		bi->bi_size = 0;
-		bi->bi_end_io(bi, bytes, 0);
+		bi->bi_end_io(bi, bytes,
+			      test_bit(BIO_UPTODATE, &bi->bi_flags)
+			        ? 0 : -EIO);
 	}
 	return 0;
 }
@@ -3127,7 +3133,9 @@ static int  retry_aligned_read(raid5_con
 		int bytes = raid_bio->bi_size;
 
 		raid_bio->bi_size = 0;
-		raid_bio->bi_end_io(raid_bio, bytes, 0);
+		raid_bio->bi_end_io(raid_bio, bytes,
+			      test_bit(BIO_UPTODATE, &raid_bio->bi_flags)
+			        ? 0 : -EIO);
 	}
 	if (atomic_dec_and_test(&conf->active_aligned_reads))
 		wake_up(&conf->wait_for_stripe);
