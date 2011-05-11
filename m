From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 10/16] md/raid1: try fix_sync_read_error before
 process_checks.
Date: Wed, 11 May 2011 16:30:31 +1000
Message-ID: <20110511063031.21263.65690.stgit@notabene.brown>
References: <20110511062743.21263.72802.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110511062743.21263.72802.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

If we get a read error during resync/recovery we current repeat with
single-page reads to find out just where the error is, and possibly
read each page from a different device.

With check/repair we don't currently do that, we just fail.
However it is possible that while all devices fail on the large 64K
read, we might be able to satisfy each 4K from one device or another.

So call fix_sync_read_error before process_checks to maximise the
chance of finding good data and writing it out to the devices with
read errors.

For this to work, we need to set the 'uptodate' flags properly after
fix_sync_read_error has succeeded.

Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/raid1.c |   19 +++++--------------
 1 files changed, 5 insertions(+), 14 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 2b9e86c..b9d6da1 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1282,6 +1282,7 @@ static int fix_sync_read_error(r1bio_t *r1_bio)
 		idx ++;
 	}
 	set_bit(R1BIO_Uptodate, &r1_bio->state);
+	set_bit(BIO_UPTODATE, &bio->bi_flags);
 	return 1;
 }
 
@@ -1299,15 +1300,6 @@ static int process_checks(r1bio_t *r1_bio)
 	int primary;
 	int i;
 
-	if (!test_bit(R1BIO_Uptodate, &r1_bio->state)) {
-		for (i=0; i < conf->raid_disks; i++)
-			if (r1_bio->bios[i]->bi_end_io == end_sync_read)
-				md_error(mddev, conf->mirrors[i].rdev);
-
-		md_done_sync(mddev, r1_bio->sectors, 1);
-		put_buf(r1_bio);
-		return -1;
-	}
 	for (primary = 0; primary < conf->raid_disks; primary++)
 		if (r1_bio->bios[primary]->bi_end_io == end_sync_read &&
 		    test_bit(BIO_UPTODATE, &r1_bio->bios[primary]->bi_flags)) {
@@ -1385,15 +1377,14 @@ static void sync_request_write(mddev_t *mddev, r1bio_t *r1_bio)
 
 	bio = r1_bio->bios[r1_bio->read_disk];
 
-
-	if (test_bit(MD_RECOVERY_REQUESTED, &mddev->recovery))
-		if (process_checks(r1_bio) < 0)
-			return;
-
 	if (!test_bit(R1BIO_Uptodate, &r1_bio->state))
 		/* ouch - failed to read all of that. */
 		if (!fix_sync_read_error(r1_bio))
 			return;
+
+	if (test_bit(MD_RECOVERY_REQUESTED, &mddev->recovery))
+		if (process_checks(r1_bio) < 0)
+			return;
 	/*
 	 * schedule writes
 	 */


