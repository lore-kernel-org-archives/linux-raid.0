From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH] md - 4 of 12 - Opencode flush_curr_signals in md.c
Date: Wed, 12 Mar 2003 14:59:37 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <E18sxOz-0004pq-00@notabene.cse.unsw.edu.au>
Return-path: <linux-raid-owner@vger.kernel.org>
To: Linus Torvalds <torvalds@transmeta.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


### Comments for ChangeSet

It is (now) too trivial to even have an inline.


 ----------- Diffstat output ------------
 ./drivers/md/md.c |   14 ++++----------
 1 files changed, 4 insertions(+), 10 deletions(-)

diff ./drivers/md/md.c~current~ ./drivers/md/md.c
--- ./drivers/md/md.c~current~	2003-03-12 09:49:42.000000000 +1100
+++ ./drivers/md/md.c	2003-03-12 09:56:22.000000000 +1100
@@ -2473,12 +2473,6 @@ static struct block_device_operations md
 	.ioctl		= md_ioctl,
 };
 
-
-static inline void flush_curr_signals(void)
-{
-	flush_signals(current);
-}
-
 int md_thread(void * arg)
 {
 	mdk_thread_t *thread = arg;
@@ -2525,7 +2519,7 @@ int md_thread(void * arg)
 			blk_run_queues();
 		}
 		if (signal_pending(current))
-			flush_curr_signals();
+			flush_signals(current);
 	}
 	complete(thread->event);
 	return 0;
@@ -2945,7 +2939,7 @@ void md_handle_safemode(mddev_t *mddev)
 	if (signal_pending(current)) {
 		printk(KERN_INFO "md: md%d in safe mode\n",mdidx(mddev));
 		mddev->safemode= 1;
-		flush_curr_signals();
+		flush_signals(current);
 	}
 	if (mddev->safemode)
 		md_enter_safemode(mddev);
@@ -2996,7 +2990,7 @@ static void md_do_sync(void *data)
 				}
 				if (wait_event_interruptible(resync_wait,
 							     mddev2->curr_resync < mddev->curr_resync)) {
-					flush_curr_signals();
+					flush_signals(current);
 					err = -EINTR;
 					mddev_put(mddev2);
 					goto skip;
@@ -3079,7 +3073,7 @@ static void md_do_sync(void *data)
 			 * got a signal, exit.
 			 */
 			printk(KERN_INFO "md: md_do_sync() got signal ... exiting\n");
-			flush_curr_signals();
+			flush_signals(current);
 			err = -EINTR;
 			goto out;
 		}
