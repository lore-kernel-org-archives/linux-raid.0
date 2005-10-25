From: NeilBrown <neilb@suse.de>
Subject: [PATCH] Make sure mdthreads will always respond to kthread_stop
Date: Tue, 25 Oct 2005 14:21:43 +1000
Message-ID: <1051025042143.30979@suse.de>
References: <20051025141735.30947.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>, Linus Torvalds <torvalds@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I know it's kinda-late but I just found another hiccup caused by the
changeover to kthreads in md.  There is another situation where it can
be hard to stop and md array because a thread doesn't respond to a
shutdown request properly.

If this patch, against 2.6.14-rc5-git4, could slip into 2.6.14, I'd
appreciate it, (if not, I expect 2.6.14.1 will be ok).

All it does is treat 'kthread_should_stop' the same as
'signal_pending', both of which mean "time to stop what you are doing.

Thanks,
NeilBrown


---

There are still a couple of cases where md threads (the
resync/recovery thread) is not interruptible since the change to use
kthreads.  All places there it tests "signal_pending", it should also
test kthread_should_stop, as with this patch.


Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/md.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff ./drivers/md/md.c~current~ ./drivers/md/md.c
--- ./drivers/md/md.c~current~	2005-10-25 13:58:44.000000000 +1000
+++ ./drivers/md/md.c	2005-10-25 13:59:03.000000000 +1000
@@ -3568,7 +3568,8 @@ static void md_do_sync(mddev_t *mddev)
 		mddev->curr_resync = 2;
 
 	try_again:
-		if (signal_pending(current)) {
+		if (signal_pending(current) ||
+		    kthread_should_stop()) {
 			flush_signals(current);
 			set_bit(MD_RECOVERY_INTR, &mddev->recovery);
 			goto skip;
@@ -3590,8 +3591,9 @@ static void md_do_sync(mddev_t *mddev)
 					 */
 					continue;
 				prepare_to_wait(&resync_wait, &wq, TASK_INTERRUPTIBLE);
-				if (!signal_pending(current)
-				    && mddev2->curr_resync >= mddev->curr_resync) {
+				if (!signal_pending(current) &&
+				    !kthread_should_stop() &&
+				    mddev2->curr_resync >= mddev->curr_resync) {
 					printk(KERN_INFO "md: delaying resync of %s"
 					       " until %s has finished resync (they"
 					       " share one or more physical units)\n",
@@ -3697,7 +3699,7 @@ static void md_do_sync(mddev_t *mddev)
 		}
 
 
-		if (signal_pending(current)) {
+		if (signal_pending(current) || kthread_should_stop()) {
 			/*
 			 * got a signal, exit.
 			 */
