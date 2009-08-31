From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH v2 4/9] md/raid6: asynchronous handle_stripe_fill6
Date: Mon, 31 Aug 2009 09:41:24 -0700
Message-ID: <20090831164124.1696.9610.stgit@dwillia2-linux.ch.intel.com>
References: <20090831163914.1696.55782.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090831163914.1696.55782.stgit@dwillia2-linux.ch.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, Ilya Yanok <yanok@emcraft.com>, Yuri Tikhonov <yur@emcraft.com>
List-Id: linux-raid.ids

From: Yuri Tikhonov <yur@emcraft.com>

Modify handle_stripe_fill6 to work asynchronously by introducing
fetch_block6 as the raid6 analog of fetch_block5 (schedule compute
operations for missing/out-of-sync disks).

[dan.j.williams@intel.com: compute D+Q in one pass]
Signed-off-by: Yuri Tikhonov <yur@emcraft.com>
Signed-off-by: Ilya Yanok <yanok@emcraft.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/md/raid5.c |  143 ++++++++++++++++++++++++++++++++++------------------
 1 files changed, 93 insertions(+), 50 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index a1245cf..49da6f7 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -2520,61 +2520,104 @@ static void handle_stripe_fill5(struct stripe_head *sh,
 	set_bit(STRIPE_HANDLE, &sh->state);
 }
 
-static void handle_stripe_fill6(struct stripe_head *sh,
-			struct stripe_head_state *s, struct r6_state *r6s,
-			int disks)
+/* fetch_block6 - checks the given member device to see if its data needs
+ * to be read or computed to satisfy a request.
+ *
+ * Returns 1 when no more member devices need to be checked, otherwise returns
+ * 0 to tell the loop in handle_stripe_fill6 to continue
+ */
+static int fetch_block6(struct stripe_head *sh, struct stripe_head_state *s,
+			 struct r6_state *r6s, int disk_idx, int disks)
 {
-	int i;
-	for (i = disks; i--; ) {
-		struct r5dev *dev = &sh->dev[i];
-		if (!test_bit(R5_LOCKED, &dev->flags) &&
-		    !test_bit(R5_UPTODATE, &dev->flags) &&
-		    (dev->toread || (dev->towrite &&
-		     !test_bit(R5_OVERWRITE, &dev->flags)) ||
-		     s->syncing || s->expanding ||
-		     (s->failed >= 1 &&
-		      (sh->dev[r6s->failed_num[0]].toread ||
-		       s->to_write)) ||
-		     (s->failed >= 2 &&
-		      (sh->dev[r6s->failed_num[1]].toread ||
-		       s->to_write)))) {
-			/* we would like to get this block, possibly
-			 * by computing it, but we might not be able to
+	struct r5dev *dev = &sh->dev[disk_idx];
+	struct r5dev *fdev[2] = { &sh->dev[r6s->failed_num[0]],
+				  &sh->dev[r6s->failed_num[1]] };
+
+	if (!test_bit(R5_LOCKED, &dev->flags) &&
+	    !test_bit(R5_UPTODATE, &dev->flags) &&
+	    (dev->toread ||
+	     (dev->towrite && !test_bit(R5_OVERWRITE, &dev->flags)) ||
+	     s->syncing || s->expanding ||
+	     (s->failed >= 1 &&
+	      (fdev[0]->toread || s->to_write)) ||
+	     (s->failed >= 2 &&
+	      (fdev[1]->toread || s->to_write)))) {
+		/* we would like to get this block, possibly by computing it,
+		 * otherwise read it if the backing disk is insync
+		 */
+		BUG_ON(test_bit(R5_Wantcompute, &dev->flags));
+		BUG_ON(test_bit(R5_Wantread, &dev->flags));
+		if ((s->uptodate == disks - 1) &&
+		    (s->failed && (disk_idx == r6s->failed_num[0] ||
+				   disk_idx == r6s->failed_num[1]))) {
+			/* have disk failed, and we're requested to fetch it;
+			 * do compute it
 			 */
-			if ((s->uptodate == disks - 1) &&
-			    (s->failed && (i == r6s->failed_num[0] ||
-					   i == r6s->failed_num[1]))) {
-				pr_debug("Computing stripe %llu block %d\n",
-				       (unsigned long long)sh->sector, i);
-				compute_block_1(sh, i, 0);
-				s->uptodate++;
-			} else if ( s->uptodate == disks-2 && s->failed >= 2 ) {
-				/* Computing 2-failure is *very* expensive; only
-				 * do it if failed >= 2
-				 */
-				int other;
-				for (other = disks; other--; ) {
-					if (other == i)
-						continue;
-					if (!test_bit(R5_UPTODATE,
-					      &sh->dev[other].flags))
-						break;
-				}
-				BUG_ON(other < 0);
-				pr_debug("Computing stripe %llu blocks %d,%d\n",
-				       (unsigned long long)sh->sector,
-				       i, other);
-				compute_block_2(sh, i, other);
-				s->uptodate += 2;
-			} else if (test_bit(R5_Insync, &dev->flags)) {
-				set_bit(R5_LOCKED, &dev->flags);
-				set_bit(R5_Wantread, &dev->flags);
-				s->locked++;
-				pr_debug("Reading block %d (sync=%d)\n",
-					i, s->syncing);
+			pr_debug("Computing stripe %llu block %d\n",
+			       (unsigned long long)sh->sector, disk_idx);
+			set_bit(STRIPE_COMPUTE_RUN, &sh->state);
+			set_bit(STRIPE_OP_COMPUTE_BLK, &s->ops_request);
+			set_bit(R5_Wantcompute, &dev->flags);
+			sh->ops.target = disk_idx;
+			sh->ops.target2 = -1; /* no 2nd target */
+			s->req_compute = 1;
+			s->uptodate++;
+			return 1;
+		} else if (s->uptodate == disks-2 && s->failed >= 2) {
+			/* Computing 2-failure is *very* expensive; only
+			 * do it if failed >= 2
+			 */
+			int other;
+			for (other = disks; other--; ) {
+				if (other == disk_idx)
+					continue;
+				if (!test_bit(R5_UPTODATE,
+				      &sh->dev[other].flags))
+					break;
 			}
+			BUG_ON(other < 0);
+			pr_debug("Computing stripe %llu blocks %d,%d\n",
+			       (unsigned long long)sh->sector,
+			       disk_idx, other);
+			set_bit(STRIPE_COMPUTE_RUN, &sh->state);
+			set_bit(STRIPE_OP_COMPUTE_BLK, &s->ops_request);
+			set_bit(R5_Wantcompute, &sh->dev[disk_idx].flags);
+			set_bit(R5_Wantcompute, &sh->dev[other].flags);
+			sh->ops.target = disk_idx;
+			sh->ops.target2 = other;
+			s->uptodate += 2;
+			s->req_compute = 1;
+			return 1;
+		} else if (test_bit(R5_Insync, &dev->flags)) {
+			set_bit(R5_LOCKED, &dev->flags);
+			set_bit(R5_Wantread, &dev->flags);
+			s->locked++;
+			pr_debug("Reading block %d (sync=%d)\n",
+				disk_idx, s->syncing);
 		}
 	}
+
+	return 0;
+}
+
+/**
+ * handle_stripe_fill6 - read or compute data to satisfy pending requests.
+ */
+static void handle_stripe_fill6(struct stripe_head *sh,
+			struct stripe_head_state *s, struct r6_state *r6s,
+			int disks)
+{
+	int i;
+
+	/* look for blocks to read/compute, skip this if a compute
+	 * is already in flight, or if the stripe contents are in the
+	 * midst of changing due to a write
+	 */
+	if (!test_bit(STRIPE_COMPUTE_RUN, &sh->state) && !sh->check_state &&
+	    !sh->reconstruct_state)
+		for (i = disks; i--; )
+			if (fetch_block6(sh, s, r6s, i, disks))
+				break;
 	set_bit(STRIPE_HANDLE, &sh->state);
 }
 

