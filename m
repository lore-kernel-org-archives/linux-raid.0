From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 19/36] md/raid5: write errors should be recorded as bad
 blocks if possible.
Date: Thu, 21 Jul 2011 12:58:49 +1000
Message-ID: <20110721025849.8422.21745.stgit@notabene.brown>
References: <20110721024556.8422.99443.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110721024556.8422.99443.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

When a write error is detected, don't mark the device as failed
immediately but rather record the fact for handle_stripe to deal with.

Handle_stripe then attempts to record a bad block.  Only if that fails
does the device get marked as faulty.

Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/raid5.c |   33 +++++++++++++++++++++++++++++++--
 drivers/md/raid5.h |   18 ++++++++++--------
 2 files changed, 41 insertions(+), 10 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index c34c97d..54e89d1 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -1658,8 +1658,10 @@ static void raid5_end_write_request(struct bio *bi, int error)
 		return;
 	}
 
-	if (!uptodate)
-		md_error(conf->mddev, conf->disks[i].rdev);
+	if (!uptodate) {
+		set_bit(WriteErrorSeen, &conf->disks[i].rdev->flags);
+		set_bit(R5_WriteError, &sh->dev[i].flags);
+	}
 
 	rdev_dec_pending(conf->disks[i].rdev, conf->mddev);
 	
@@ -3031,6 +3033,14 @@ static void analyse_stripe(struct stripe_head *sh, struct stripe_head_state *s)
 			if (sh->sector + STRIPE_SECTORS <= rdev->recovery_offset)
 				set_bit(R5_Insync, &dev->flags);
 		}
+		if (test_bit(R5_WriteError, &dev->flags)) {
+			clear_bit(R5_Insync, &dev->flags);
+			if (!test_bit(Faulty, &rdev->flags)) {
+				s->handle_bad_blocks = 1;
+				atomic_inc(&rdev->nr_pending);
+			} else
+				clear_bit(R5_WriteError, &dev->flags);
+		}
 		if (!test_bit(R5_Insync, &dev->flags)) {
 			/* The ReadError flag will just be confusing now */
 			clear_bit(R5_ReadError, &dev->flags);
@@ -3086,6 +3096,11 @@ static void handle_stripe(struct stripe_head *sh)
 
 	analyse_stripe(sh, &s);
 
+	if (s.handle_bad_blocks) {
+		set_bit(STRIPE_HANDLE, &sh->state);
+		goto finish;
+	}
+
 	if (unlikely(s.blocked_rdev)) {
 		if (s.syncing || s.expanding || s.expanded ||
 		    s.to_write || s.written) {
@@ -3283,6 +3298,20 @@ finish:
 	if (unlikely(s.blocked_rdev))
 		md_wait_for_blocked_rdev(s.blocked_rdev, conf->mddev);
 
+	if (s.handle_bad_blocks)
+		for (i = disks; i--; ) {
+			mdk_rdev_t *rdev;
+			struct r5dev *dev = &sh->dev[i];
+			if (test_and_clear_bit(R5_WriteError, &dev->flags)) {
+				/* We own a safe reference to the rdev */
+				rdev = conf->disks[i].rdev;
+				if (!rdev_set_badblocks(rdev, sh->sector,
+							STRIPE_SECTORS, 0))
+					md_error(conf->mddev, rdev);
+				rdev_dec_pending(rdev, conf->mddev);
+			}
+		}
+
 	if (s.ops_request)
 		raid_run_ops(sh, s.ops_request);
 
diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
index 719fc86..d4729f5 100644
--- a/drivers/md/raid5.h
+++ b/drivers/md/raid5.h
@@ -252,6 +252,7 @@ struct stripe_head_state {
 	struct bio *return_bi;
 	mdk_rdev_t *blocked_rdev;
 	int dec_preread_active;
+	int handle_bad_blocks;
 };
 
 /* Flags */
@@ -267,14 +268,15 @@ struct stripe_head_state {
 #define	R5_ReWrite	9	/* have tried to over-write the readerror */
 
 #define	R5_Expanded	10	/* This block now has post-expand data */
-#define	R5_Wantcompute	11 /* compute_block in progress treat as
-				    * uptodate
-				    */
-#define	R5_Wantfill	12 /* dev->toread contains a bio that needs
-				    * filling
-				    */
-#define R5_Wantdrain	13 /* dev->towrite needs to be drained */
-#define R5_WantFUA	14	/* Write should be FUA */
+#define	R5_Wantcompute	11	/* compute_block in progress treat as
+				 * uptodate
+				 */
+#define	R5_Wantfill	12	/* dev->toread contains a bio that needs
+				 * filling
+				 */
+#define	R5_Wantdrain	13	/* dev->towrite needs to be drained */
+#define	R5_WantFUA	14	/* Write should be FUA */
+#define	R5_WriteError	15	/* got a write error - need to record it */
 /*
  * Write method
  */


