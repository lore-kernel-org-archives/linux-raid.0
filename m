From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] md: don't use flush_signals in userspace processes
Date: Wed, 7 Jun 2017 19:05:31 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1706071834250.22850@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>, NeilBrown <neilb@suse.com>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
List-Id: linux-raid.ids

The function flush_signals clears all pending signals for the process. It
may be used by kernel threads when we need to prepare a kernel thread for
responding to signals. However using this function for an userspaces
processes is incorrect - clearing signals without the program expecting it
can cause misbehavior.

The raid1 and raid5 code uses flush_signals in its request routine because
it wants to prepare for an interruptible wait. This patch drops
flush_signals and uses sigprocmask instead to block all signals (including
SIGKILL) around the schedule() call. The signals are not lost, but the
schedule() call won't respond to them.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org

---
 drivers/md/raid1.c |    5 ++++-
 drivers/md/raid5.c |    5 ++++-
 2 files changed, 8 insertions(+), 2 deletions(-)

Index: linux-4.12-rc4/drivers/md/raid1.c
===================================================================
--- linux-4.12-rc4.orig/drivers/md/raid1.c
+++ linux-4.12-rc4/drivers/md/raid1.c
@@ -1335,7 +1335,7 @@ static void raid1_write_request(struct m
 		 */
 		DEFINE_WAIT(w);
 		for (;;) {
-			flush_signals(current);
+			sigset_t full, old;
 			prepare_to_wait(&conf->wait_barrier,
 					&w, TASK_INTERRUPTIBLE);
 			if (bio_end_sector(bio) <= mddev->suspend_lo ||
@@ -1345,7 +1345,10 @@ static void raid1_write_request(struct m
 				     bio->bi_iter.bi_sector,
 				     bio_end_sector(bio))))
 				break;
+			sigfillset(&full);
+			sigprocmask(SIG_BLOCK, &full, &old);
 			schedule();
+			sigprocmask(SIG_SETMASK, &old, NULL);
 		}
 		finish_wait(&conf->wait_barrier, &w);
 	}
Index: linux-4.12-rc4/drivers/md/raid5.c
===================================================================
--- linux-4.12-rc4.orig/drivers/md/raid5.c
+++ linux-4.12-rc4/drivers/md/raid5.c
@@ -5693,12 +5693,15 @@ static void raid5_make_request(struct md
 				 * userspace, we want an interruptible
 				 * wait.
 				 */
-				flush_signals(current);
 				prepare_to_wait(&conf->wait_for_overlap,
 						&w, TASK_INTERRUPTIBLE);
 				if (logical_sector >= mddev->suspend_lo &&
 				    logical_sector < mddev->suspend_hi) {
+					sigset_t full, old;
+					sigfillset(&full);
+					sigprocmask(SIG_BLOCK, &full, &old);
 					schedule();
+					sigprocmask(SIG_SETMASK, &old, NULL);
 					do_prepare = true;
 				}
 				goto retry;
