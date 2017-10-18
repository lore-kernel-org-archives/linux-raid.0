From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] md: use TASK_IDLE instead of blocking signals
Date: Wed, 18 Oct 2017 19:01:11 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1710181858530.32003@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@fb.com>, NeilBrown <neilb@suse.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi - I submit this patch for the next merge window:


Some times ago, I made a patch f9c79bc05a2a that blocks signals around the
schedule() calls in MD. The MD subsystem needs to do an uninterruptible
sleep that is not accounted in load average - so we block signals and use
interruptible sleep.

The kernel has a special TASK_IDLE state for this purpose, so we can use
it instead of blocking signals. This patch doesn't fix any bug, it just
makes the code simpler.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/raid1.c |    7 +------
 drivers/md/raid5.c |    7 +------
 2 files changed, 2 insertions(+), 12 deletions(-)

Index: linux-2.6/drivers/md/raid1.c
===================================================================
--- linux-2.6.orig/drivers/md/raid1.c
+++ linux-2.6/drivers/md/raid1.c
@@ -37,7 +37,6 @@
 #include <linux/module.h>
 #include <linux/seq_file.h>
 #include <linux/ratelimit.h>
-#include <linux/sched/signal.h>
 
 #include <trace/events/block.h>
 
@@ -1322,9 +1321,8 @@ static void raid1_write_request(struct m
 		 */
 		DEFINE_WAIT(w);
 		for (;;) {
-			sigset_t full, old;
 			prepare_to_wait(&conf->wait_barrier,
-					&w, TASK_INTERRUPTIBLE);
+					&w, TASK_IDLE);
 			if (bio_end_sector(bio) <= mddev->suspend_lo ||
 			    bio->bi_iter.bi_sector >= mddev->suspend_hi ||
 			    (mddev_is_clustered(mddev) &&
@@ -1332,10 +1330,7 @@ static void raid1_write_request(struct m
 				     bio->bi_iter.bi_sector,
 				     bio_end_sector(bio))))
 				break;
-			sigfillset(&full);
-			sigprocmask(SIG_BLOCK, &full, &old);
 			schedule();
-			sigprocmask(SIG_SETMASK, &old, NULL);
 		}
 		finish_wait(&conf->wait_barrier, &w);
 	}
Index: linux-2.6/drivers/md/raid5.c
===================================================================
--- linux-2.6.orig/drivers/md/raid5.c
+++ linux-2.6/drivers/md/raid5.c
@@ -55,7 +55,6 @@
 #include <linux/ratelimit.h>
 #include <linux/nodemask.h>
 #include <linux/flex_array.h>
-#include <linux/sched/signal.h>
 
 #include <trace/events/block.h>
 #include <linux/list_sort.h>
@@ -5691,14 +5690,10 @@ static bool raid5_make_request(struct md
 				 * wait.
 				 */
 				prepare_to_wait(&conf->wait_for_overlap,
-						&w, TASK_INTERRUPTIBLE);
+						&w, TASK_IDLE);
 				if (logical_sector >= mddev->suspend_lo &&
 				    logical_sector < mddev->suspend_hi) {
-					sigset_t full, old;
-					sigfillset(&full);
-					sigprocmask(SIG_BLOCK, &full, &old);
 					schedule();
-					sigprocmask(SIG_SETMASK, &old, NULL);
 					do_prepare = true;
 				}
 				goto retry;
