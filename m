From: NeilBrown <neilb@suse.de>
Subject: [PATCH md 002 of 2] Make md threads interruptible again.
Date: Tue, 15 Nov 2005 12:56:41 +1100
Message-ID: <1051115015641.9393@suse.de>
References: <20051115125442.9317.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Despite the fact that md threads don't need to be signalled, and won't
respond to signals anyway, we need to have an 'interruptible' wait,
else they stay in 'D' state and add to the load average.

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/md.c |   17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff ./drivers/md/md.c~current~ ./drivers/md/md.c
--- ./drivers/md/md.c~current~	2005-11-15 10:25:30.000000000 +1100
+++ ./drivers/md/md.c	2005-11-15 10:28:30.000000000 +1100
@@ -3437,10 +3437,19 @@ static int md_thread(void * arg)
 	allow_signal(SIGKILL);
 	while (!kthread_should_stop()) {
 
-		wait_event_timeout(thread->wqueue,
-				   test_bit(THREAD_WAKEUP, &thread->flags)
-				   || kthread_should_stop(),
-				   thread->timeout);
+		/* We need to wait INTERRUPTIBLE so that
+		 * we don't add to the load-average.
+		 * That means we need to be sure no signals are
+		 * pending
+		 */
+		if (signal_pending(current))
+			flush_signals(current);
+
+		wait_event_interruptible_timeout
+			(thread->wqueue,
+			 test_bit(THREAD_WAKEUP, &thread->flags)
+			 || kthread_should_stop(),
+			 thread->timeout);
 		try_to_freeze();
 
 		clear_bit(THREAD_WAKEUP, &thread->flags);
