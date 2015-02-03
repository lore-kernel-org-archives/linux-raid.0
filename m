From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 03/26] md/raid5: separate out the easy conditions in
 need_this_block.
Date: Wed, 04 Feb 2015 08:42:28 +1100
Message-ID: <20150203214228.3448.37737.stgit@notabene.brown>
References: <20150203213948.3448.80258.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150203213948.3448.80258.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Some of the conditions in need_this_block have very straight
forward motivation.  Separate those out and document them.

Signed-off-by: NeilBrown <neilb@suse.de>
---
 drivers/md/raid5.c |   38 +++++++++++++++++++++++++++++---------
 1 file changed, 29 insertions(+), 9 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 5a980fe7c982..21c1e796a0d6 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -2903,14 +2903,34 @@ static int need_this_block(struct stripe_head *sh, struct stripe_head_state *s,
 	struct r5dev *fdev[2] = { &sh->dev[s->failed_num[0]],
 				  &sh->dev[s->failed_num[1]] };
 
-	if (!test_bit(R5_LOCKED, &dev->flags) &&
-	    !test_bit(R5_UPTODATE, &dev->flags) &&
-	    (dev->toread ||
-	     (dev->towrite && !test_bit(R5_OVERWRITE, &dev->flags)) ||
-	     s->syncing || s->expanding ||
-	     (s->replacing && want_replace(sh, disk_idx)) ||
-	     (s->failed >= 1 && fdev[0]->toread) ||
-	     (s->failed >= 2 && fdev[1]->toread) ||
+
+	if (test_bit(R5_LOCKED, &dev->flags) ||
+	    test_bit(R5_UPTODATE, &dev->flags))
+		/* No point reading this as we already have it or have
+		 * decided to get it.
+		 */
+		return 0;
+
+	if (dev->toread ||
+	    (dev->towrite && !test_bit(R5_OVERWRITE, &dev->flags)))
+		/* We need this block to directly satisfy a request */
+		return 1;
+
+	if (s->syncing || s->expanding ||
+	    (s->replacing && want_replace(sh, disk_idx)))
+		/* When syncing, or expanding we read everything.
+		 * When replacing, we need the replaced block.
+		 */
+		return 1;
+
+	if ((s->failed >= 1 && fdev[0]->toread) ||
+	    (s->failed >= 2 && fdev[1]->toread))
+		/* If we want to read from a failed device, then
+		 * we need to actually read every other device.
+		 */
+		return 1;
+
+	if (
 	     (sh->raid_conf->level <= 5 && s->failed && fdev[0]->towrite &&
 	      (!test_bit(R5_Insync, &dev->flags) || test_bit(STRIPE_PREREAD_ACTIVE, &sh->state)) &&
 	      !test_bit(R5_OVERWRITE, &fdev[0]->flags)) ||
@@ -2919,7 +2939,7 @@ static int need_this_block(struct stripe_head *sh, struct stripe_head_state *s,
 	      && s->failed && s->to_write &&
 	      (s->to_write - s->non_overwrite <
 	       sh->raid_conf->raid_disks - sh->raid_conf->max_degraded) &&
-	      (!test_bit(R5_Insync, &dev->flags) || test_bit(STRIPE_PREREAD_ACTIVE, &sh->state)))))
+	      (!test_bit(R5_Insync, &dev->flags) || test_bit(STRIPE_PREREAD_ACTIVE, &sh->state))))
 		return 1;
 	return 0;
 }


