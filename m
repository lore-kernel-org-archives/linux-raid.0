From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH] md - 1 of 3 - Make sure yielding thread actually yields cpu when waiting for turn at reconstruct.
Date: Mon, 06 Jan 2003 11:42:49 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <E18VLLt-00036C-00@notabene.cse.unsw.edu.au>
Return-path: <linux-raid-owner@vger.kernel.org>
To: Linus Torvalds <torvalds@transmeta.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


### Comments for ChangeSet


 ----------- Diffstat output ------------
 ./drivers/md/md.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletion(-)

diff ./drivers/md/md.c~current~ ./drivers/md/md.c
--- ./drivers/md/md.c~current~	2003-01-06 11:11:06.000000000 +1100
+++ ./drivers/md/md.c	2003-01-06 11:11:06.000000000 +1100
@@ -2815,8 +2815,10 @@ static void md_do_sync(void *data)
 				printk(KERN_INFO "md: delaying resync of md%d until md%d "
 				       "has finished resync (they share one or more physical units)\n",
 				       mdidx(mddev), mdidx(mddev2));
-				if (mddev < mddev2) /* arbitrarily yield */
+				if (mddev < mddev2) {/* arbitrarily yield */
 					mddev->curr_resync = 1;
+					yield();
+				}
 				if (wait_event_interruptible(resync_wait,
 							     mddev2->curr_resync < 2)) {
 					flush_curr_signals();
