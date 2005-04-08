From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH md 001 of 2] Close a small race in md thread deregistration
Date: Fri, 08 Apr 2005 11:41:46 +1000
Message-ID: <E1DJiVG-0007B6-Bd@notabene.cse.unsw.edu.au>
References: <20050408113719.27541.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


There is a tiny race when de-registering an MD thread, in that the
thread could disappear before it is set a SIGKILL, causing
send_sig to have problems.  
This is most easily closed by holding tasklist_lock between
enabling the thread to exit (setting ->run to NULL) and telling 
it to exit.

Signed-off-by: Neil Brown <neilb@cse.unsw.edu.au>

### Diffstat output
 ./drivers/md/md.c |   20 ++++++++------------
 1 files changed, 8 insertions(+), 12 deletions(-)

diff ./drivers/md/md.c~current~ ./drivers/md/md.c
--- ./drivers/md/md.c~current~	2005-04-08 11:36:35.000000000 +1000
+++ ./drivers/md/md.c	2005-04-08 11:36:35.000000000 +1000
@@ -2840,16 +2840,6 @@ mdk_thread_t *md_register_thread(void (*
 	return thread;
 }
 
-static void md_interrupt_thread(mdk_thread_t *thread)
-{
-	if (!thread->tsk) {
-		MD_BUG();
-		return;
-	}
-	dprintk("interrupting MD-thread pid %d\n", thread->tsk->pid);
-	send_sig(SIGKILL, thread->tsk, 1);
-}
-
 void md_unregister_thread(mdk_thread_t *thread)
 {
 	struct completion event;
@@ -2857,9 +2847,15 @@ void md_unregister_thread(mdk_thread_t *
 	init_completion(&event);
 
 	thread->event = &event;
+
+	/* As soon as ->run is set to NULL, the task could disappear,
+	 * so we need to hold tasklist_lock until we have sent the signal
+	 */
+	dprintk("interrupting MD-thread pid %d\n", thread->tsk->pid);
+	read_lock(&tasklist_lock);
 	thread->run = NULL;
-	thread->name = NULL;
-	md_interrupt_thread(thread);
+	send_sig(SIGKILL, thread->tsk, 1);
+	read_unlock(&tasklist_lock);
 	wait_for_completion(&event);
 	kfree(thread);
 }
