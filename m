From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH] md - 8 of 13 - Improve code for deciding whether to skip an IO in raid5
Date: Thu, 22 Aug 2002 10:34:17 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <E17hfvV-00050P-00@notabene.cse.unsw.edu.au>
Return-path: <linux-raid-owner@vger.kernel.org>
To: Linus Torvalds <torvalds@transmeta.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


### Comments for ChangeSet

Instread of the 'skip' variable, just test if rdev is NULL or not.


 ----------- Diffstat output ------------
 ./drivers/md/raid5.c |   13 ++++++-------
 1 files changed, 6 insertions(+), 7 deletions(-)

--- ./drivers/md/raid5.c	2002/08/21 23:11:27	1.7
+++ ./drivers/md/raid5.c	2002/08/21 23:12:26	1.8
@@ -1139,23 +1139,22 @@ static void handle_stripe(struct stripe_
 	for (i=disks; i-- ;) 
 		if (action[i]) {
 			struct bio *bi = &sh->dev[i].req;
-			int skip = 0;
-			mdk_rdev_t *rdev = NULL;
+			mdk_rdev_t *rdev ;
+
 			if (action[i] == READ+1)
 				bi->bi_end_io = raid5_end_read_request;
 			else
 				bi->bi_end_io = raid5_end_write_request;
 
 			spin_lock_irq(&conf->device_lock);
-			if (conf->disks[i].operational)
-				rdev = conf->disks[i].rdev;
-			else skip=1;
+			rdev = conf->disks[i].rdev;
+			if (!conf->disks[i].operational)
+				rdev = NULL;
 			if (rdev)
 				atomic_inc(&rdev->nr_pending);
-			else	skip=1;
 			spin_unlock_irq(&conf->device_lock);
 
-			if (!skip) {
+			if (rdev) {
 				bi->bi_bdev = rdev->bdev;
 				PRINTK("for %ld schedule op %d on disc %d\n", sh->sector, action[i]-1, i);
 				atomic_inc(&sh->count);
