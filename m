From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 06/16] md/raid5: allow each slot to have an extra
 replacement device
Date: Wed, 26 Oct 2011 12:43:01 +1100
Message-ID: <20111026014301.21110.82947.stgit@notabene.brown>
References: <20111026014240.21110.28487.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111026014240.21110.28487.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Just enhance data structures to record a second device per slot to be
used as a 'replacement' device, replacing the original.
We also have a second bio in each slot in each stripe_head.  This will
only be used when writing to the array - we need to write to both the
original and the replacement at the same time, so will need two bios.

For now, only try using the replacement drive for aligned-reads.
In this case, we prefer the replacement if it has been recovered far
enough, otherwise use the original.

This includes a small enhancement.  Previously we would only do
aligned reads if the target device was fully recovered.  Now we also
do them if it has recovered far enough.

Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/raid5.c |   15 ++++++++++++--
 drivers/md/raid5.h |   57 ++++++++++++++++++++++++++++++----------------------
 2 files changed, 46 insertions(+), 26 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 27056d3..e6d10df 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -3573,6 +3573,7 @@ static int chunk_aligned_read(struct mddev *mddev, struct bio * raid_bio)
 	int dd_idx;
 	struct bio* align_bi;
 	struct md_rdev *rdev;
+	sector_t end_sector;
 
 	if (!in_chunk_boundary(mddev, raid_bio)) {
 		pr_debug("chunk_aligned_read : non aligned\n");
@@ -3597,9 +3598,19 @@ static int chunk_aligned_read(struct mddev *mddev, struct bio * raid_bio)
 						    0,
 						    &dd_idx, NULL);
 
+	end_sector = align_bi->bi_sector + (align_bi->bi_size >>9);
 	rcu_read_lock();
-	rdev = rcu_dereference(conf->disks[dd_idx].rdev);
-	if (rdev && test_bit(In_sync, &rdev->flags)) {
+	rdev = rcu_dereference(conf->disks[dd_idx].replacement);
+	if (!rdev || test_bit(Faulty, &rdev->flags) ||
+	    rdev->recovery_offset < end_sector) {
+		rdev = rcu_dereference(conf->disks[dd_idx].rdev);
+		if (rdev &&
+		    (test_bit(Faulty, &rdev->flags) ||
+		    !(test_bit(In_sync, &rdev->flags) ||
+		      rdev->recovery_offset >= end_sector)))
+			rdev = NULL;
+	}
+	if (rdev) {
 		sector_t first_bad;
 		int bad_sectors;
 
diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
index e10c553..43106f0 100644
--- a/drivers/md/raid5.h
+++ b/drivers/md/raid5.h
@@ -226,8 +226,11 @@ struct stripe_head {
 		#endif
 	} ops;
 	struct r5dev {
-		struct bio	req;
-		struct bio_vec	vec;
+		/* rreq and rvec are used for the replacement device when
+		 * writing data to both devices.
+		 */
+		struct bio	req, rreq;
+		struct bio_vec	vec, rvec;
 		struct page	*page;
 		struct bio	*toread, *read, *towrite, *written;
 		sector_t	sector;			/* sector of this page */
@@ -252,29 +255,35 @@ struct stripe_head_state {
 	int handle_bad_blocks;
 };
 
-/* Flags */
-#define	R5_UPTODATE	0	/* page contains current data */
-#define	R5_LOCKED	1	/* IO has been submitted on "req" */
-#define	R5_OVERWRITE	2	/* towrite covers whole page */
+/* Flags for struct r5dev.flags */
+enum r5dev_flags {
+	R5_UPTODATE,	/* page contains current data */
+	R5_LOCKED,	/* IO has been submitted on "req" */
+	R5_OVERWRITE,	/* towrite covers whole page */
 /* and some that are internal to handle_stripe */
-#define	R5_Insync	3	/* rdev && rdev->in_sync at start */
-#define	R5_Wantread	4	/* want to schedule a read */
-#define	R5_Wantwrite	5
-#define	R5_Overlap	7	/* There is a pending overlapping request on this block */
-#define	R5_ReadError	8	/* seen a read error here recently */
-#define	R5_ReWrite	9	/* have tried to over-write the readerror */
+	R5_Insync,	/* rdev && rdev->in_sync at start */
+	R5_Wantread,	/* want to schedule a read */
+	R5_Wantwrite,
+	R5_Overlap,	/* There is a pending overlapping request
+			 * on this block */
+	R5_ReadError,	/* seen a read error here recently */
+	R5_ReWrite,	/* have tried to over-write the readerror */
 
-#define	R5_Expanded	10	/* This block now has post-expand data */
-#define	R5_Wantcompute	11	/* compute_block in progress treat as
-				 * uptodate
-				 */
-#define	R5_Wantfill	12	/* dev->toread contains a bio that needs
-				 * filling
-				 */
-#define	R5_Wantdrain	13	/* dev->towrite needs to be drained */
-#define	R5_WantFUA	14	/* Write should be FUA */
-#define	R5_WriteError	15	/* got a write error - need to record it */
-#define	R5_MadeGood	16	/* A bad block has been fixed by writing to it*/
+	R5_Expanded,	/* This block now has post-expand data */
+	R5_Wantcompute,	/* compute_block in progress treat as
+			 * uptodate
+			 */
+	R5_Wantfill,	/* dev->toread contains a bio that needs
+			 * filling
+			 */
+	R5_Wantdrain,	/* dev->towrite needs to be drained */
+	R5_WantFUA,	/* Write should be FUA */
+	R5_WriteError,	/* got a write error - need to record it */
+	R5_MadeGood,	/* A bad block has been fixed by writing to it */
+	R5_ReadRepl,	/* Will/did read from replacement rather than orig */
+	R5_MadeGoodRepl,/* A bad block on the replacement device has been
+			 * fixed by writing to it */
+};
 /*
  * Write method
  */
@@ -344,7 +353,7 @@ enum {
 
 
 struct disk_info {
-	struct md_rdev	*rdev;
+	struct md_rdev	*rdev, *replacement;
 };
 
 struct r5conf {


