From: David Jeffery <djeffery@redhat.com>
Subject: [PATCH] md/raid1: release pending accounting for an I/O only after
 write-behind is also finished
Date: Mon, 27 Jan 2020 10:26:19 -0500
Message-ID: <20200127152619.GA3596@redhat>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Song Liu <song@kernel.org>
List-Id: linux-raid.ids

When using RAID1 and write-behind, md can deadlock when errors occur. With
write-behind, r1bio structs can be accounted by raid1 as queued but not
counted as pending. The pending count is dropped when the original bio is
returned complete but write-behind for the r1bio may still be active.

This breaks the accounting used in some conditions to know when the raid1
md device has reached an idle state. It can result in calls to
freeze_array deadlocking. freeze_array will never complete from a negative
"unqueued" value being calculated due to a queued count larger than the
pending count.

To properly account for write-behind, move the call to allow_barrier from
call_bio_endio to raid_end_bio_io. When using write-behind, md can call
call_bio_endio before all write-behind I/O is complete. Using
raid_end_bio_io for the point to call allow_barrier will release the
pending count at a point where all I/O for an r1bio, even write-behind, is
done.

Signed-off-by: David Jeffery <djeffery@redhat.com>
---

 raid1.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)


diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 201fd8aec59a..0196a9d9f7e9 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -279,22 +279,17 @@ static void reschedule_retry(struct r1bio *r1_bio)
 static void call_bio_endio(struct r1bio *r1_bio)
 {
 	struct bio *bio = r1_bio->master_bio;
-	struct r1conf *conf = r1_bio->mddev->private;
 
 	if (!test_bit(R1BIO_Uptodate, &r1_bio->state))
 		bio->bi_status = BLK_STS_IOERR;
 
 	bio_endio(bio);
-	/*
-	 * Wake up any possible resync thread that waits for the device
-	 * to go idle.
-	 */
-	allow_barrier(conf, r1_bio->sector);
 }
 
 static void raid_end_bio_io(struct r1bio *r1_bio)
 {
 	struct bio *bio = r1_bio->master_bio;
+	struct r1conf *conf = r1_bio->mddev->private;
 
 	/* if nobody has done the final endio yet, do it now */
 	if (!test_and_set_bit(R1BIO_Returned, &r1_bio->state)) {
@@ -305,6 +300,12 @@ static void raid_end_bio_io(struct r1bio *r1_bio)
 
 		call_bio_endio(r1_bio);
 	}
+	/*
+	 * Wake up any possible resync thread that waits for the device
+	 * to go idle.  All I/Os, even write-behind writes, are done.
+	 */
+	allow_barrier(conf, r1_bio->sector);
+
 	free_r1bio(r1_bio);
 }
 
