From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH] md - 4 of 4 - Fix another two bug in raid5
Date: Thu, 07 Nov 2002 11:56:16 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <E189ay0-0008JX-00@notabene.cse.unsw.edu.au>
Return-path: <linux-raid-owner@vger.kernel.org>
To: Linus Torvalds <torvalds@transmeta.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


### Comments for ChangeSet

 A partial block write over a block on a failed device
 would need to pre-read that block, which means pre-read all
 blocks in stripe and generate that block.  But the generate-block
 code never checked for this possibility, so it wouldn't happen.





 ----------- Diffstat output ------------
 ./drivers/md/raid5.c |   18 +++++++++++++++---
 1 files changed, 15 insertions(+), 3 deletions(-)

--- ./drivers/md/raid5.c	2002/11/06 23:05:40	1.2
+++ ./drivers/md/raid5.c	2002/11/06 23:07:44	1.3
@@ -836,6 +836,7 @@ static void handle_stripe(struct stripe_
 	int i;
 	int syncing;
 	int locked=0, uptodate=0, to_read=0, to_write=0, failed=0, written=0;
+	int non_overwrite = 0;
 	int failed_num=0;
 	struct r5dev *dev;
 
@@ -883,7 +884,11 @@ static void handle_stripe(struct stripe_
 
 		
 		if (dev->toread) to_read++;
-		if (dev->towrite) to_write++;
+		if (dev->towrite) {
+			to_write++;
+			if (!test_bit(R5_OVERWRITE, &dev->flags))
+				non_overwrite++;
+		}
 		if (dev->written) written++;
 		rdev = conf->disks[i].rdev; /* FIXME, should I be looking rdev */
 		if (!rdev || !rdev->in_sync) {
@@ -975,12 +980,19 @@ static void handle_stripe(struct stripe_
 
 	/* Now we might consider reading some blocks, either to check/generate
 	 * parity, or to satisfy requests
+	 * or to load a block that is being partially written.
 	 */
-	if (to_read || (syncing && (uptodate+failed < disks))) {
+	if (to_read || non_overwrite || (syncing && (uptodate+failed < disks))) {
 		for (i=disks; i--;) {
 			dev = &sh->dev[i];
 			if (!test_bit(R5_LOCKED, &dev->flags) && !test_bit(R5_UPTODATE, &dev->flags) &&
-			    (dev->toread || syncing || (failed && sh->dev[failed_num].toread))) {
+			    (dev->toread ||
+			     (dev->towrite && !test_bit(R5_OVERWRITE, &dev->flags)) ||
+			     syncing ||
+			     (failed && (sh->dev[failed_num].toread ||
+					 (sh->dev[failed_num].towrite && !test_bit(R5_OVERWRITE, &sh->dev[failed_num].flags))))
+				    )
+				) {
 				/* we would like to get this block, possibly
 				 * by computing it, but we might not be able to
 				 */
