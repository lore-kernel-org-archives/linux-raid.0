From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: PATCH - md - Fix a typo in a recent patchset for raid5
Date: Fri, 30 Aug 2002 15:23:27 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <15727.335.408702.697283@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: Linus Torvalds <torvalds@transmeta.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



 ----------- Diffstat output ------------
 ./drivers/md/raid5.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

--- ./drivers/md/raid5.c	2002/08/30 02:56:35	1.1
+++ ./drivers/md/raid5.c	2002/08/30 05:20:51	1.2
@@ -937,7 +937,7 @@ static void handle_stripe(struct stripe_
 	    for (i=disks; i--; )
 		if (sh->dev[i].written) {
 		    dev = &sh->dev[i];
-		    if (!test_bit(R5_Insync, &dev->flags) &&
+		    if (!test_bit(R5_Insync, &sh->dev[sh->pd_idx].flags) &&
 			(!test_bit(R5_LOCKED, &dev->flags) && test_bit(R5_UPTODATE, &dev->flags)) ) {
 			/* maybe we can return some write requests */
 			    struct bio *wbi, *wbi2;
