From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: PATCH - md - Make sure yielding thread actually yields cpu when waiting for turn at reconstruct.
Date: Tue, 17 Dec 2002 13:07:56 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <15870.34556.308506.746842@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: Linus Torvalds <torvalds@transmeta.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



When two md arrays on the same physical devices want to resync, they
must take turns, and currently the one that chooses to yield may end
up stealing all the CPU (on a uni-processor) and not give the other a
chance to get started.
This patches adds an explicit 'yield()' to avoid the problem.


 ----------- Diffstat output ------------
 ./drivers/md/md.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletion(-)

diff ./drivers/md/md.c~current~ ./drivers/md/md.c
--- ./drivers/md/md.c~current~	2002-12-09 15:47:05.000000000 +1100
+++ ./drivers/md/md.c	2002-12-09 15:47:05.000000000 +1100
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
