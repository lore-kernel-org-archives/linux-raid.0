From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH md 005 of 7] Use kthread infrastructure in md
Date: Mon, 29 Aug 2005 17:33:39 +1000
Message-ID: <E1E9e9D-0003Wn-HB@notabene.cse.unsw.edu.au>
References: <20050829172936.12848.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Switch MD to use the kthread infrastructure, to simplify the code and
get rid of tasklist_lock abuse in md_unregister_thread.  

Also don't flush signals in md_thread, as the called thread will
always do that.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Neil Brown <neilb@cse.unsw.edu.au>

### Diffstat output
 ./drivers/md/md.c |   48 ++++++++++--------------------------------------
 1 file changed, 10 insertions(+), 38 deletions(-)

diff ./drivers/md/md.c~current~ ./drivers/md/md.c
--- ./drivers/md/md.c~current~	2005-08-29 16:37:35.000000000 +1000
+++ ./drivers/md/md.c	2005-08-29 16:37:40.000000000 +1000
@@ -34,6 +34,7 @@
 
 #include <linux/module.h>
 #include <linux/config.h>
+#include <linux/kthread.h>
 #include <linux/linkage.h>
 #include <linux/raid/md.h>
 #include <linux/raid/bitmap.h>
@@ -3049,18 +3050,6 @@ static int md_thread(void * arg)
 {
 	mdk_thread_t *thread = arg;
 
-	lock_kernel();
-
-	/*
-	 * Detach thread
-	 */
-
-	daemonize(thread->name, mdname(thread->mddev));
-
-	current->exit_signal = SIGCHLD;
-	allow_signal(SIGKILL);
-	thread->tsk = current;
-
 	/*
 	 * md_thread is a 'system-thread', it's priority should be very
 	 * high. We avoid resource deadlocks individually in each
@@ -3072,14 +3061,14 @@ static int md_thread(void * arg)
 	 * bdflush, otherwise bdflush will deadlock if there are too
 	 * many dirty RAID5 blocks.
 	 */
-	unlock_kernel();
 
 	complete(thread->event);
-	while (thread->run) {
+	while (!kthread_should_stop()) {
 		void (*run)(mddev_t *);
 
 		wait_event_interruptible_timeout(thread->wqueue,
-						 test_bit(THREAD_WAKEUP, &thread->flags),
+						 test_bit(THREAD_WAKEUP, &thread->flags)
+						 || kthread_should_stop(),
 						 thread->timeout);
 		try_to_freeze();
 
@@ -3088,11 +3077,8 @@ static int md_thread(void * arg)
 		run = thread->run;
 		if (run)
 			run(thread->mddev);
-
-		if (signal_pending(current))
-			flush_signals(current);
 	}
-	complete(thread->event);
+
 	return 0;
 }
 
@@ -3109,11 +3095,9 @@ mdk_thread_t *md_register_thread(void (*
 				 const char *name)
 {
 	mdk_thread_t *thread;
-	int ret;
 	struct completion event;
 
-	thread = (mdk_thread_t *) kmalloc
-				(sizeof(mdk_thread_t), GFP_KERNEL);
+	thread = kmalloc(sizeof(mdk_thread_t), GFP_KERNEL);
 	if (!thread)
 		return NULL;
 
@@ -3126,8 +3110,8 @@ mdk_thread_t *md_register_thread(void (*
 	thread->mddev = mddev;
 	thread->name = name;
 	thread->timeout = MAX_SCHEDULE_TIMEOUT;
-	ret = kernel_thread(md_thread, thread, 0);
-	if (ret < 0) {
+	thread->tsk = kthread_run(md_thread, thread, mdname(thread->mddev));
+	if (IS_ERR(thread->tsk)) {
 		kfree(thread);
 		return NULL;
 	}
@@ -3137,21 +3121,9 @@ mdk_thread_t *md_register_thread(void (*
 
 void md_unregister_thread(mdk_thread_t *thread)
 {
-	struct completion event;
-
-	init_completion(&event);
-
-	thread->event = &event;
-
-	/* As soon as ->run is set to NULL, the task could disappear,
-	 * so we need to hold tasklist_lock until we have sent the signal
-	 */
 	dprintk("interrupting MD-thread pid %d\n", thread->tsk->pid);
-	read_lock(&tasklist_lock);
-	thread->run = NULL;
-	send_sig(SIGKILL, thread->tsk, 1);
-	read_unlock(&tasklist_lock);
-	wait_for_completion(&event);
+
+	kthread_stop(thread->tsk);
 	kfree(thread);
 }
 
