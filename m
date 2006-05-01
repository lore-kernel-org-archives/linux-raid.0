From: NeilBrown <neilb@suse.de>
Subject: [PATCH 001 of 11] md: Reformat code in raid1_end_write_request to avoid goto
Date: Mon, 1 May 2006 15:30:03 +1000
Message-ID: <1060501053003.22913@suse.de>
References: <20060501152229.18367.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids


A recent change made this goto unnecessary, so reformat the
code to make it clearer what is happening.

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/raid1.c |   34 +++++++++++++++++-----------------
 1 file changed, 17 insertions(+), 17 deletions(-)

diff ./drivers/md/raid1.c~current~ ./drivers/md/raid1.c
--- ./drivers/md/raid1.c~current~	2006-05-01 15:09:20.000000000 +1000
+++ ./drivers/md/raid1.c	2006-05-01 15:10:00.000000000 +1000
@@ -374,26 +374,26 @@ static int raid1_end_write_request(struc
 	 * already.
 	 */
 	if (atomic_dec_and_test(&r1_bio->remaining)) {
-		if (test_bit(R1BIO_BarrierRetry, &r1_bio->state)) {
+		if (test_bit(R1BIO_BarrierRetry, &r1_bio->state))
 			reschedule_retry(r1_bio);
-			goto out;
+		else {
+			/* it really is the end of this request */
+			if (test_bit(R1BIO_BehindIO, &r1_bio->state)) {
+				/* free extra copy of the data pages */
+				int i = bio->bi_vcnt;
+				while (i--)
+					safe_put_page(bio->bi_io_vec[i].bv_page);
+			}
+			/* clear the bitmap if all writes complete successfully */
+			bitmap_endwrite(r1_bio->mddev->bitmap, r1_bio->sector,
+					r1_bio->sectors,
+					!test_bit(R1BIO_Degraded, &r1_bio->state),
+					behind);
+			md_write_end(r1_bio->mddev);
+			raid_end_bio_io(r1_bio);
 		}
-		/* it really is the end of this request */
-		if (test_bit(R1BIO_BehindIO, &r1_bio->state)) {
-			/* free extra copy of the data pages */
-			int i = bio->bi_vcnt;
-			while (i--)
-				safe_put_page(bio->bi_io_vec[i].bv_page);
-		}
-		/* clear the bitmap if all writes complete successfully */
-		bitmap_endwrite(r1_bio->mddev->bitmap, r1_bio->sector,
-				r1_bio->sectors,
-				!test_bit(R1BIO_Degraded, &r1_bio->state),
-				behind);
-		md_write_end(r1_bio->mddev);
-		raid_end_bio_io(r1_bio);
 	}
- out:
+
 	if (to_put)
 		bio_put(to_put);
 
