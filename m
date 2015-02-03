From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 04/26] md/raid5: need_this_block: start simplifying the
 last two conditions.
Date: Wed, 04 Feb 2015 08:42:28 +1100
Message-ID: <20150203214228.3448.56498.stgit@notabene.brown>
References: <20150203213948.3448.80258.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150203213948.3448.80258.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Both the last two cases are only relevant if something has failed and
something needs to be written (but not over-written), and if it is OK
to pre-read blocks at this point.  So factor out those tests and
explain them.

Signed-off-by: NeilBrown <neilb@suse.de>
---
 drivers/md/raid5.c |   28 +++++++++++++++++++++++-----
 1 file changed, 23 insertions(+), 5 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 21c1e796a0d6..bb42551c1a42 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -2930,16 +2930,34 @@ static int need_this_block(struct stripe_head *sh, struct stripe_head_state *s,
 		 */
 		return 1;
 
+	/* Sometimes neither read-modify-write nor reconstruct-write
+	 * cycles can work.  In those cases we read every block we
+	 * can.  Then the parity-update is certain to have enough to
+	 * work with.
+	 * This can only be a problem when we need to write something,
+	 * and some device has failed.  If either of those tests
+	 * fail we need look no further.
+	 */
+	if (!s->failed || !s->to_write)
+		return 0;
+
+	if (test_bit(R5_Insync, &dev->flags) &&
+	    !test_bit(STRIPE_PREREAD_ACTIVE, &sh->state))
+		/* Pre-reads at not permitted until after short delay
+		 * to gather multiple requests.  However if this
+		 * device is no Insync, the block could only be be computed
+		 * and there is no need to delay that.
+		 */
+		return 0;
 	if (
-	     (sh->raid_conf->level <= 5 && s->failed && fdev[0]->towrite &&
-	      (!test_bit(R5_Insync, &dev->flags) || test_bit(STRIPE_PREREAD_ACTIVE, &sh->state)) &&
+	     (sh->raid_conf->level <= 5 && fdev[0]->towrite &&
 	      !test_bit(R5_OVERWRITE, &fdev[0]->flags)) ||
 	     ((sh->raid_conf->level == 6 ||
 	       sh->sector >= sh->raid_conf->mddev->recovery_cp)
-	      && s->failed && s->to_write &&
+	      &&
 	      (s->to_write - s->non_overwrite <
-	       sh->raid_conf->raid_disks - sh->raid_conf->max_degraded) &&
-	      (!test_bit(R5_Insync, &dev->flags) || test_bit(STRIPE_PREREAD_ACTIVE, &sh->state))))
+	       sh->raid_conf->raid_disks - sh->raid_conf->max_degraded)
+	      ))
 		return 1;
 	return 0;
 }


