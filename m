From: Shaohua Li <shli@fb.com>
Subject: [PATCH 1/2] raid5-cache: suspend reclaim thread instead of shutdown
Date: Mon, 21 Nov 2016 10:29:18 -0800
Message-ID: <598ff2610261ffa745b682c311d5300fefeb2fcc.1479751751.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Kernel-team@fb.com, songliubraving@fb.com, neilb@suse.com
List-Id: linux-raid.ids

There is mechanism to suspend a kernel thread. Use it instead of playing
create/destroy game.

Signed-off-by: Shaohua Li <shli@fb.com>
---
 drivers/md/md.c          |  4 +++-
 drivers/md/raid5-cache.c | 18 +++++-------------
 2 files changed, 8 insertions(+), 14 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index d3cef77..f548469 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -7136,10 +7136,12 @@ static int md_thread(void *arg)
 		wait_event_interruptible_timeout
 			(thread->wqueue,
 			 test_bit(THREAD_WAKEUP, &thread->flags)
-			 || kthread_should_stop(),
+			 || kthread_should_stop() || kthread_should_park(),
 			 thread->timeout);
 
 		clear_bit(THREAD_WAKEUP, &thread->flags);
+		if (kthread_should_park())
+			kthread_parkme();
 		if (!kthread_should_stop())
 			thread->run(thread);
 	}
diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index 8cb79fc..5f817bd 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -19,6 +19,7 @@
 #include <linux/raid/md_p.h>
 #include <linux/crc32c.h>
 #include <linux/random.h>
+#include <linux/kthread.h>
 #include "md.h"
 #include "raid5.h"
 #include "bitmap.h"
@@ -1437,23 +1438,14 @@ void r5l_quiesce(struct r5l_log *log, int state)
 	struct mddev *mddev;
 	if (!log || state == 2)
 		return;
-	if (state == 0) {
-		/*
-		 * This is a special case for hotadd. In suspend, the array has
-		 * no journal. In resume, journal is initialized as well as the
-		 * reclaim thread.
-		 */
-		if (log->reclaim_thread)
-			return;
-		log->reclaim_thread = md_register_thread(r5l_reclaim_thread,
-					log->rdev->mddev, "reclaim");
-		log->reclaim_thread->timeout = R5C_RECLAIM_WAKEUP_INTERVAL;
-	} else if (state == 1) {
+	if (state == 0)
+		kthread_unpark(log->reclaim_thread->tsk);
+	else if (state == 1) {
 		/* make sure r5l_write_super_and_discard_space exits */
 		mddev = log->rdev->mddev;
 		wake_up(&mddev->sb_wait);
+		kthread_park(log->reclaim_thread->tsk);
 		r5l_wake_reclaim(log, MaxSector);
-		md_unregister_thread(&log->reclaim_thread);
 		r5l_do_reclaim(log);
 	}
 }
-- 
2.9.3

