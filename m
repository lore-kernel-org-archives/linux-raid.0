From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 07/16] md/raid5: raid5.h cleanup
Date: Wed, 26 Oct 2011 12:43:01 +1100
Message-ID: <20111026014301.21110.19740.stgit@notabene.brown>
References: <20111026014240.21110.28487.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111026014240.21110.28487.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Remove some #defines that are no longer used, and replace some
others with an enum.
And remove an unused field.

Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/raid5.h |   27 +++++++++------------------
 1 files changed, 9 insertions(+), 18 deletions(-)

diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
index 43106f0..4cfd801 100644
--- a/drivers/md/raid5.h
+++ b/drivers/md/raid5.h
@@ -27,7 +27,7 @@
  * The possible state transitions are:
  *
  *  Empty -> Want   - on read or write to get old data for  parity calc
- *  Empty -> Dirty  - on compute_parity to satisfy write/sync request.(RECONSTRUCT_WRITE)
+ *  Empty -> Dirty  - on compute_parity to satisfy write/sync request.
  *  Empty -> Clean  - on compute_block when computing a block for failed drive
  *  Want  -> Empty  - on failed read
  *  Want  -> Clean  - on successful completion of read request
@@ -284,15 +284,6 @@ enum r5dev_flags {
 	R5_MadeGoodRepl,/* A bad block on the replacement device has been
 			 * fixed by writing to it */
 };
-/*
- * Write method
- */
-#define RECONSTRUCT_WRITE	1
-#define READ_MODIFY_WRITE	2
-/* not a write method, but a compute_parity mode */
-#define	CHECK_PARITY		3
-/* Additional compute_parity mode -- updates the parity w/o LOCKING */
-#define UPDATE_PARITY		4
 
 /*
  * Stripe state
@@ -320,13 +311,14 @@ enum {
 /*
  * Operation request flags
  */
-#define STRIPE_OP_BIOFILL	0
-#define STRIPE_OP_COMPUTE_BLK	1
-#define STRIPE_OP_PREXOR	2
-#define STRIPE_OP_BIODRAIN	3
-#define STRIPE_OP_RECONSTRUCT	4
-#define STRIPE_OP_CHECK	5
-
+enum {
+	STRIPE_OP_BIOFILL,
+	STRIPE_OP_COMPUTE_BLK,
+	STRIPE_OP_PREXOR,
+	STRIPE_OP_BIODRAIN,
+	STRIPE_OP_RECONSTRUCT,
+	STRIPE_OP_CHECK,
+};
 /*
  * Plugging:
  *
@@ -359,7 +351,6 @@ struct disk_info {
 struct r5conf {
 	struct hlist_head	*stripe_hashtbl;
 	struct mddev		*mddev;
-	struct disk_info	*spare;
 	int			chunk_sectors;
 	int			level, algorithm;
 	int			max_degraded;


