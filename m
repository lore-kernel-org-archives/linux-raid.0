From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH] md - 1 of 2 - Use "shedule_timeout(2)" instead of yield() as it seems to wait for less time.
Date: Fri, 05 Mar 2004 16:45:37 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <E1Az89R-0001su-00@notabene>
References: <20040305164342.7205.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


 ----------- Diffstat output ------------
 ./drivers/md/raid5.c     |    3 ++-
 ./drivers/md/raid6main.c |    3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff ./drivers/md/raid5.c~current~ ./drivers/md/raid5.c
--- ./drivers/md/raid5.c~current~	2004-03-05 16:43:07.000000000 +1100
+++ ./drivers/md/raid5.c	2004-03-05 16:43:07.000000000 +1100
@@ -1409,7 +1409,8 @@ static int sync_request (mddev_t *mddev,
 		/* make sure we don't swamp the stripe cache if someone else
 		 * is trying to get access 
 		 */
-		yield();
+		set_current_state(TASK_UNINTERRUPTIBLE);
+		schedule_timeout(2);
 	}
 	spin_lock(&sh->lock);	
 	set_bit(STRIPE_SYNCING, &sh->state);

diff ./drivers/md/raid6main.c~current~ ./drivers/md/raid6main.c
--- ./drivers/md/raid6main.c~current~	2004-03-05 16:43:07.000000000 +1100
+++ ./drivers/md/raid6main.c	2004-03-05 16:43:07.000000000 +1100
@@ -1571,7 +1571,8 @@ static int sync_request (mddev_t *mddev,
 		/* make sure we don't swamp the stripe cache if someone else
 		 * is trying to get access
 		 */
-		yield();
+		set_current_state(TASK_UNINTERRUPTIBLE);
+		schedule_timeout(2);
 	}
 	spin_lock(&sh->lock);
 	set_bit(STRIPE_SYNCING, &sh->state);
