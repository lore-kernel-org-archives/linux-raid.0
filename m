From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 02/26] md/raid5: separate large if clause out of
 fetch_block().
Date: Wed, 04 Feb 2015 08:42:28 +1100
Message-ID: <20150203214228.3448.76818.stgit@notabene.brown>
References: <20150203213948.3448.80258.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150203213948.3448.80258.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

fetch_block() has a very large and hard to read 'if' condition.

Separate it into its own function so that it can be
made more readable.

Signed-off-by: NeilBrown <neilb@suse.de>
---
 drivers/md/raid5.c |   19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 274db1834d43..5a980fe7c982 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -2895,14 +2895,14 @@ static int want_replace(struct stripe_head *sh, int disk_idx)
  * Returns 1 when no more member devices need to be checked, otherwise returns
  * 0 to tell the loop in handle_stripe_fill to continue
  */
-static int fetch_block(struct stripe_head *sh, struct stripe_head_state *s,
-		       int disk_idx, int disks)
+
+static int need_this_block(struct stripe_head *sh, struct stripe_head_state *s,
+			   int disk_idx, int disks)
 {
 	struct r5dev *dev = &sh->dev[disk_idx];
 	struct r5dev *fdev[2] = { &sh->dev[s->failed_num[0]],
 				  &sh->dev[s->failed_num[1]] };
 
-	/* is the data in this block needed, and can we get it? */
 	if (!test_bit(R5_LOCKED, &dev->flags) &&
 	    !test_bit(R5_UPTODATE, &dev->flags) &&
 	    (dev->toread ||
@@ -2919,7 +2919,18 @@ static int fetch_block(struct stripe_head *sh, struct stripe_head_state *s,
 	      && s->failed && s->to_write &&
 	      (s->to_write - s->non_overwrite <
 	       sh->raid_conf->raid_disks - sh->raid_conf->max_degraded) &&
-	      (!test_bit(R5_Insync, &dev->flags) || test_bit(STRIPE_PREREAD_ACTIVE, &sh->state))))) {
+	      (!test_bit(R5_Insync, &dev->flags) || test_bit(STRIPE_PREREAD_ACTIVE, &sh->state)))))
+		return 1;
+	return 0;
+}
+
+static int fetch_block(struct stripe_head *sh, struct stripe_head_state *s,
+		       int disk_idx, int disks)
+{
+	struct r5dev *dev = &sh->dev[disk_idx];
+
+	/* is the data in this block needed, and can we get it? */
+	if (need_this_block(sh, s, disk_idx, disks)) {
 		/* we would like to get this block, possibly by computing it,
 		 * otherwise read it if the backing disk is insync
 		 */


