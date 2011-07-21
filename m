From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 34/36] md/raid10: simplify read error handling during
 recovery.
Date: Thu, 21 Jul 2011 12:58:50 +1000
Message-ID: <20110721025850.8422.43827.stgit@notabene.brown>
References: <20110721024556.8422.99443.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110721024556.8422.99443.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

If a read error is detected during recovery the code currently
fails the read device.
This isn't really necessary.  recovery_request_write will signal
a write error to end_sync_write and it will record a write
error on the destination device which will record a bad block
there or kick it from the array.

So just remove this call to do md_error.

Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/raid10.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 0f120ac..f87c8d9 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1418,13 +1418,12 @@ static void end_sync_read(struct bio *bio, int error)
 
 	if (test_bit(BIO_UPTODATE, &bio->bi_flags))
 		set_bit(R10BIO_Uptodate, &r10_bio->state);
-	else {
+	else
+		/* The write handler will notice the lack of
+		 * R10BIO_Uptodate and record any errors etc
+		 */
 		atomic_add(r10_bio->sectors,
 			   &conf->mirrors[d].rdev->corrected_errors);
-		if (!test_bit(MD_RECOVERY_SYNC, &conf->mddev->recovery))
-			md_error(r10_bio->mddev,
-				 conf->mirrors[d].rdev);
-	}
 
 	/* for reconstruct, we always reschedule after a read.
 	 * for resync, only after all reads


