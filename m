From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: PATCH - md 7 of 22 - Use wait_event_interuptible in md_thread
Date: Wed, 19 Jun 2002 10:51:06 +1000 (EST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <15631.54650.987308.141340@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: Linus Torvalds <torvalds@transmeta.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids




It currently has several lines of code where one will do.



 ----------- Diffstat output ------------
 ./drivers/md/md.c |   13 +++----------
 1 files changed, 3 insertions(+), 10 deletions(-)

--- ./drivers/md/md.c	2002/06/18 03:34:17	1.6
+++ ./drivers/md/md.c	2002/06/18 03:37:06	1.7
@@ -2929,17 +2929,10 @@
 	complete(thread->event);
 	while (thread->run) {
 		void (*run)(void *data);
-		DECLARE_WAITQUEUE(wait, current);
 
-		add_wait_queue(&thread->wqueue, &wait);
-		set_task_state(current, TASK_INTERRUPTIBLE);
-		if (!test_bit(THREAD_WAKEUP, &thread->flags)) {
-			dprintk("md: thread %p went to sleep.\n", thread);
-			schedule();
-			dprintk("md: thread %p woke up.\n", thread);
-		}
-		current->state = TASK_RUNNING;
-		remove_wait_queue(&thread->wqueue, &wait);
+		wait_event_interruptible(thread->wqueue,
+					 test_bit(THREAD_WAKEUP, &thread->flags));
+
 		clear_bit(THREAD_WAKEUP, &thread->flags);
 
 		run = thread->run;
