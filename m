From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 05/26] md/raid5: need_this_block: tidy/fix last condition.
Date: Wed, 04 Feb 2015 08:42:28 +1100
Message-ID: <20150203214228.3448.70867.stgit@notabene.brown>
References: <20150203213948.3448.80258.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150203213948.3448.80258.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

That last condition is unclear and over cautious.

There are two related issues here.

If a partial write is destined for a missing device, then
either RMW or RCW can work.  We must read all the available
block.  Only then can the missing blocks be calculated, and
then the parity update performed.

If RMW is not an option, then there is a complication even
without partial writes.  If we would need to read a missing
device to perform the reconstruction, then we must first read every
block so the missing device data can be computed.
This is the case for RAID6 (Which currently does not support
RMW) and for times when we don't trust the parity (after a crash)
and so are in the process of resyncing it.

So make these two cases more clear and separate, and perform
the relevant tests more  thoroughly.

Signed-off-by: NeilBrown <neilb@suse.de>
---
 drivers/md/raid5.c |   42 ++++++++++++++++++++++++++++++++----------
 1 file changed, 32 insertions(+), 10 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index bb42551c1a42..a03cf2d889bf 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -2902,6 +2902,7 @@ static int need_this_block(struct stripe_head *sh, struct stripe_head_state *s,
 	struct r5dev *dev = &sh->dev[disk_idx];
 	struct r5dev *fdev[2] = { &sh->dev[s->failed_num[0]],
 				  &sh->dev[s->failed_num[1]] };
+	int i;
 
 
 	if (test_bit(R5_LOCKED, &dev->flags) ||
@@ -2949,16 +2950,37 @@ static int need_this_block(struct stripe_head *sh, struct stripe_head_state *s,
 		 * and there is no need to delay that.
 		 */
 		return 0;
-	if (
-	     (sh->raid_conf->level <= 5 && fdev[0]->towrite &&
-	      !test_bit(R5_OVERWRITE, &fdev[0]->flags)) ||
-	     ((sh->raid_conf->level == 6 ||
-	       sh->sector >= sh->raid_conf->mddev->recovery_cp)
-	      &&
-	      (s->to_write - s->non_overwrite <
-	       sh->raid_conf->raid_disks - sh->raid_conf->max_degraded)
-	      ))
-		return 1;
+
+	for (i = 0; i < s->failed; i++) {
+		if (fdev[i]->towrite &&
+		    !test_bit(R5_UPTODATE, &fdev[i]->flags) &&
+		    !test_bit(R5_OVERWRITE, &fdev[i]->flags))
+			/* If we have a partial write to a failed
+			 * device, then we will need to reconstruct
+			 * the content of that device, so all other
+			 * devices must be read.
+			 */
+			return 1;
+	}
+
+	/* If we are forced to do a reconstruct-write, either because
+	 * the current RAID6 implementation only supports that, or
+	 * or because parity cannot be trusted and we are currently
+	 * recovering it, there is extra need to be careful.
+	 * If one of the devices that we would need to read, because
+	 * it is not being overwritten (and maybe not written at all)
+	 * is missing/faulty, then we need to read everything we can.
+	 */
+	if (sh->raid_conf->level != 6 &&
+	    sh->sector < sh->raid_conf->mddev->recovery_cp)
+		/* reconstruct-write isn't being forced */
+		return 0;
+	for (i = 0; i < s->failed; i++) {
+		if (!test_bit(R5_UPTODATE, &fdev[i]->flags) &&
+		    !test_bit(R5_OVERWRITE, &fdev[i]->flags))
+			return 1;
+	}
+
 	return 0;
 }
 


