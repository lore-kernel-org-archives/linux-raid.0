From: NeilBrown <neilb@suse.de>
Subject: [PATCH md ] Three one-liners in md.c
Date: Tue, 18 Oct 2005 10:38:42 +1000
Message-ID: <1051018003842.3181@suse.de>
References: <20051018103524.2617.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This patch against anything since 2.6.14-rc1 (I think) fixes three md
bugs.  If there is to be another 2.6.14-rc, it would be nice for it to
go in that, but if not, it isn't critial.
The main problem fixes is that in certain situations stopping md arrays 
may take longer than you expect, or may require multiple attempts.  This 
would only happen when resync/recovery is happening.

### Comments for Changeset

This patch fixes three vaguely related bugs.

1/ The recent change to use kthreads got the setting of the 
   process name wrong.  This fixes it.
2/ The recent change to use kthreads lost the ability for
   md threads to be signalled with SIG_KILL.  This restores that.
3/ There is a long standing bug in that if:
    - An array needs recovery (onto a hot-spare) and
    - The recovery is being blocked because some other array being
       recovered shares a physical device and
    - The recovery thread is killed with SIG_KILL
   Then the recovery will appear to have completed with no IO being
   done, which can cause data corruption.
   This patch makes sure that incomplete recovery will be treated as
   incomplete.

Note that any kernel affected by bug 2 will not suffer the problem of
bug 3, as the signal can never be delivered.  Thus the current
2.6.14-rc kernels are not susceptible to data corruption.
Note also that if arrays are shutdown (with "mdadm -S" or "raidstop")
then the problem doesn't occur.  It only happens if a SIGKILL is
independently delivered as done by 'init' when shutting down.Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/md.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff ./drivers/md/md.c~current~ ./drivers/md/md.c
--- ./drivers/md/md.c~current~	2005-10-17 16:38:57.000000000 +1000
+++ ./drivers/md/md.c	2005-10-17 17:19:58.000000000 +1000
@@ -3420,6 +3420,7 @@ static int md_thread(void * arg)
 	 * many dirty RAID5 blocks.
 	 */
 
+	allow_signal(SIGKILL);
 	complete(thread->event);
 	while (!kthread_should_stop()) {
 		void (*run)(mddev_t *);
@@ -3468,7 +3469,7 @@ mdk_thread_t *md_register_thread(void (*
 	thread->mddev = mddev;
 	thread->name = name;
 	thread->timeout = MAX_SCHEDULE_TIMEOUT;
-	thread->tsk = kthread_run(md_thread, thread, mdname(thread->mddev));
+	thread->tsk = kthread_run(md_thread, thread, name, mdname(thread->mddev));
 	if (IS_ERR(thread->tsk)) {
 		kfree(thread);
 		return NULL;
@@ -3926,6 +3927,7 @@ static void md_do_sync(mddev_t *mddev)
 	try_again:
 		if (signal_pending(current)) {
 			flush_signals(current);
+			set_bit(MD_RECOVERY_INTR, &mddev->recovery);
 			goto skip;
 		}
 		ITERATE_MDDEV(mddev2,tmp) {
