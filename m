From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH] md - 2 of 3 - Fix bug in raid5 AGAIN
Date: Wed, 11 Sep 2002 11:02:07 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1020911010207.4477@cse.unsw.edu.au>
Return-path: <linux-raid-owner@vger.kernel.org>
To: Linus Torvalds <torvalds@transmeta.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


### Comments for ChangeSet

That recent bug fix in raid5 just changed the bug, it didn't fix it.
I think that the original code was actually wrong, which didn't
help.
This time, the code actually matches the nearby comment, that has been expanded 
a bit, so I feel somewhat more confident that it is actually right.




 ----------- Diffstat output ------------
 ./drivers/md/raid5.c |   11 +++++++----
 1 files changed, 7 insertions(+), 4 deletions(-)

--- ./drivers/md/raid5.c	2002/09/11 00:37:46	1.1
+++ ./drivers/md/raid5.c	2002/09/11 00:38:33	1.2
@@ -933,13 +933,16 @@ static void handle_stripe(struct stripe_
 		test_bit(R5_UPTODATE, &dev->flags))
 	       || (failed == 1 && failed_num == sh->pd_idx))
 	    ) {
-	    /* any written block on an uptodate or failed drive can be returned */
+	    /* any written block on an uptodate or failed drive can be returned.
+	     * Note that if we 'wrote' to a failed drive, it will be UPTODATE, but 
+	     * never LOCKED, so we don't need to test 'failed' directly.
+	     */
 	    for (i=disks; i--; )
 		if (sh->dev[i].written) {
 		    dev = &sh->dev[i];
-		    if (!test_bit(R5_Insync, &sh->dev[sh->pd_idx].flags) &&
-			(!test_bit(R5_LOCKED, &dev->flags) && test_bit(R5_UPTODATE, &dev->flags)) ) {
-			/* maybe we can return some write requests */
+		    if (!test_bit(R5_LOCKED, &dev->flags) &&
+			 test_bit(R5_UPTODATE, &dev->flags) ) {
+			/* We can return any write requests */
 			    struct bio *wbi, *wbi2;
 			    PRINTK("Return write for disc %d\n", i);
 			    wbi = dev->written;
