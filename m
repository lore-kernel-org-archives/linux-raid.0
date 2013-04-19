From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH] MD:  Do not increment resync_mismatches unless
 MD_RECOVERY_REQUESTED
Date: Fri, 19 Apr 2013 15:09:21 -0500
Message-ID: <1366402161.18514.1.camel@f16>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.de, jbrassow@redhat.com
List-Id: linux-raid.ids

MD:  Do not increment resync_mismatches unless MD_RECOVERY_REQUESTED

resync_mismatches is used to display the number of differences that
have been found or repaired during a scrubbing operation.  It is not
meant to count anything during resync or repair operations.  (How
much sense does it make to find resync_mismatches populated after an
initial synchronization of the array?  After cleaning-up an unclean
shutdown?  After [re]integrating a device into an existing array?)
The incrementing of the variable must be restricted to when the user
initiates a scrubbing operation (i.e. "check" or "repair").

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>

Index: linux-upstream/drivers/md/raid1.c
===================================================================
--- linux-upstream.orig/drivers/md/raid1.c
+++ linux-upstream/drivers/md/raid1.c
@@ -1878,7 +1878,8 @@ static int process_checks(struct r1bio *
 			}
 		} else
 			j = 0;
-		if (j >= 0)
+		if ((j >= 0) &&
+		    (test_bit(MD_RECOVERY_REQUESTED, &mddev->recovery)))
 			atomic64_add(r1_bio->sectors, &mddev->resync_mismatches);
 		if (j < 0 || (test_bit(MD_RECOVERY_CHECK, &mddev->recovery)
 			      && test_bit(BIO_UPTODATE, &sbio->bi_flags))) {
Index: linux-upstream/drivers/md/raid10.c
===================================================================
--- linux-upstream.orig/drivers/md/raid10.c
+++ linux-upstream/drivers/md/raid10.c
@@ -2071,7 +2071,10 @@ static void sync_request_write(struct md
 					break;
 			if (j == vcnt)
 				continue;
-			atomic64_add(r10_bio->sectors, &mddev->resync_mismatches);
+
+			if (test_bit(MD_RECOVERY_REQUESTED, &mddev->recovery))
+				atomic64_add(r10_bio->sectors,
+					     &mddev->resync_mismatches);
 			if (test_bit(MD_RECOVERY_CHECK, &mddev->recovery))
 				/* Don't fix anything. */
 				continue;
Index: linux-upstream/drivers/md/raid5.c
===================================================================
--- linux-upstream.orig/drivers/md/raid5.c
+++ linux-upstream/drivers/md/raid5.c
@@ -2989,7 +2989,10 @@ static void handle_parity_checks5(struct
 			 */
 			set_bit(STRIPE_INSYNC, &sh->state);
 		else {
-			atomic64_add(STRIPE_SECTORS, &conf->mddev->resync_mismatches);
+			if (test_bit(MD_RECOVERY_REQUESTED,
+				     &conf->mddev->recovery))
+				atomic64_add(STRIPE_SECTORS,
+					     &conf->mddev->resync_mismatches);
 			if (test_bit(MD_RECOVERY_CHECK, &conf->mddev->recovery))
 				/* don't try to repair!! */
 				set_bit(STRIPE_INSYNC, &sh->state);
@@ -3141,7 +3144,10 @@ static void handle_parity_checks6(struct
 				 */
 			}
 		} else {
-			atomic64_add(STRIPE_SECTORS, &conf->mddev->resync_mismatches);
+			if (test_bit(MD_RECOVERY_REQUESTED,
+				     &conf->mddev->recovery))
+				atomic64_add(STRIPE_SECTORS,
+					     &conf->mddev->resync_mismatches);
 			if (test_bit(MD_RECOVERY_CHECK, &conf->mddev->recovery))
 				/* don't try to repair!! */
 				set_bit(STRIPE_INSYNC, &sh->state);


