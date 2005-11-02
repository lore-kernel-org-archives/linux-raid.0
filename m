From: NeilBrown <neilb@suse.de>
Subject: [PATCH md 008 of 10] Complete conversion of md to use kthreads.
Date: Wed, 2 Nov 2005 21:15:47 +1100
Message-ID: <1051102101547.23954@suse.de>
References: <20051102205640.22689.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


There are a few loose ends following the conversion of md
to use kthreads:
 - Some fields in mdk_thread_t that aren't needed (kthreads does
   it's own completion and manages it's own name).
 - thread->run is now never NULL, so no need to check
 - Some tests for signal_pending that aren't needed
    (As we don't use signals to stop threads any more)
 - Some flush_signals are not needed
 - Some waits are interruptible and don't need to be.

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/md.c           |   33 ++++++++++-----------------------
 ./include/linux/raid/md_k.h |    2 --
 2 files changed, 10 insertions(+), 25 deletions(-)

diff ./drivers/md/md.c~current~ ./drivers/md/md.c
--- ./drivers/md/md.c~current~	2005-11-02 17:33:29.000000000 +1100
+++ ./drivers/md/md.c	2005-11-02 17:33:34.000000000 +1100
@@ -3424,21 +3424,17 @@ static int md_thread(void * arg)
 	 */
 
 	allow_signal(SIGKILL);
-	complete(thread->event);
 	while (!kthread_should_stop()) {
-		void (*run)(mddev_t *);
 
-		wait_event_interruptible_timeout(thread->wqueue,
-						 test_bit(THREAD_WAKEUP, &thread->flags)
-						 || kthread_should_stop(),
-						 thread->timeout);
+		wait_event_timeout(thread->wqueue,
+				   test_bit(THREAD_WAKEUP, &thread->flags)
+				   || kthread_should_stop(),
+				   thread->timeout);
 		try_to_freeze();
 
 		clear_bit(THREAD_WAKEUP, &thread->flags);
 
-		run = thread->run;
-		if (run)
-			run(thread->mddev);
+		thread->run(thread->mddev);
 	}
 
 	return 0;
@@ -3457,7 +3453,6 @@ mdk_thread_t *md_register_thread(void (*
 				 const char *name)
 {
 	mdk_thread_t *thread;
-	struct completion event;
 
 	thread = kmalloc(sizeof(mdk_thread_t), GFP_KERNEL);
 	if (!thread)
@@ -3466,18 +3461,14 @@ mdk_thread_t *md_register_thread(void (*
 	memset(thread, 0, sizeof(mdk_thread_t));
 	init_waitqueue_head(&thread->wqueue);
 
-	init_completion(&event);
-	thread->event = &event;
 	thread->run = run;
 	thread->mddev = mddev;
-	thread->name = name;
 	thread->timeout = MAX_SCHEDULE_TIMEOUT;
 	thread->tsk = kthread_run(md_thread, thread, name, mdname(thread->mddev));
 	if (IS_ERR(thread->tsk)) {
 		kfree(thread);
 		return NULL;
 	}
-	wait_for_completion(&event);
 	return thread;
 }
 
@@ -3941,9 +3932,7 @@ static void md_do_sync(mddev_t *mddev)
 		mddev->curr_resync = 2;
 
 	try_again:
-		if (signal_pending(current) ||
-		    kthread_should_stop()) {
-			flush_signals(current);
+		if (kthread_should_stop()) {
 			set_bit(MD_RECOVERY_INTR, &mddev->recovery);
 			goto skip;
 		}
@@ -3963,9 +3952,8 @@ static void md_do_sync(mddev_t *mddev)
 					 * time 'round when curr_resync == 2
 					 */
 					continue;
-				prepare_to_wait(&resync_wait, &wq, TASK_INTERRUPTIBLE);
-				if (!signal_pending(current) &&
-				    !kthread_should_stop() &&
+				prepare_to_wait(&resync_wait, &wq, TASK_UNINTERRUPTIBLE);
+				if (!kthread_should_stop() &&
 				    mddev2->curr_resync >= mddev->curr_resync) {
 					printk(KERN_INFO "md: delaying resync of %s"
 					       " until %s has finished resync (they"
@@ -4074,13 +4062,12 @@ static void md_do_sync(mddev_t *mddev)
 		}
 
 
-		if (signal_pending(current) || kthread_should_stop()) {
+		if (kthread_should_stop()) {
 			/*
 			 * got a signal, exit.
 			 */
 			printk(KERN_INFO 
 				"md: md_do_sync() got signal ... exiting\n");
-			flush_signals(current);
 			set_bit(MD_RECOVERY_INTR, &mddev->recovery);
 			goto out;
 		}
@@ -4102,7 +4089,7 @@ static void md_do_sync(mddev_t *mddev)
 		if (currspeed > sysctl_speed_limit_min) {
 			if ((currspeed > sysctl_speed_limit_max) ||
 					!is_mddev_idle(mddev)) {
-				msleep_interruptible(250);
+				msleep(250);
 				goto repeat;
 			}
 		}

diff ./include/linux/raid/md_k.h~current~ ./include/linux/raid/md_k.h
--- ./include/linux/raid/md_k.h~current~	2005-11-02 17:32:28.000000000 +1100
+++ ./include/linux/raid/md_k.h	2005-11-02 17:33:34.000000000 +1100
@@ -334,10 +334,8 @@ typedef struct mdk_thread_s {
 	mddev_t			*mddev;
 	wait_queue_head_t	wqueue;
 	unsigned long           flags;
-	struct completion	*event;
 	struct task_struct	*tsk;
 	unsigned long		timeout;
-	const char		*name;
 } mdk_thread_t;
 
 #define THREAD_WAKEUP  0
