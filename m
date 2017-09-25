From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: [PATCH v4 1/7] md: Make md resync and reshape threads freezable
Date: Mon, 25 Sep 2017 13:29:18 -0700
Message-ID: <20170925202924.16603-2-bart.vanassche@wdc.com>
References: <20170925202924.16603-1-bart.vanassche@wdc.com>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170925202924.16603-1-bart.vanassche@wdc.com>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, Christoph Hellwig <hch@lst.de>, "Martin K . Petersen" <martin.petersen@oracle.com>, =Oleksandr Natalenko <oleksandr@natalenko.name>, Bart Van Assche <bart.vanassche@wdc.com>, Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org, Ming Lei <ming.lei@redhat.com>, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>
List-Id: linux-raid.ids

Some people use the md driver on laptops and use the suspend and
resume functionality. Since it is essential that submitting of
new I/O requests stops before device quiescing starts, make the
md resync and reshape threads freezable.

Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
Cc: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org
Cc: Ming Lei <ming.lei@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.com>
Cc: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/md/md.c | 21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 08fcaebc61bd..26a12bd0db65 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -66,6 +66,7 @@
 #include <linux/raid/md_u.h>
 #include <linux/slab.h>
 #include <linux/percpu-refcount.h>
+#include <linux/freezer.h>
 
 #include <trace/events/block.h>
 #include "md.h"
@@ -7424,6 +7425,7 @@ static int md_thread(void *arg)
 	 */
 
 	allow_signal(SIGKILL);
+	set_freezable();
 	while (!kthread_should_stop()) {
 
 		/* We need to wait INTERRUPTIBLE so that
@@ -7434,7 +7436,7 @@ static int md_thread(void *arg)
 		if (signal_pending(current))
 			flush_signals(current);
 
-		wait_event_interruptible_timeout
+		wait_event_freezable_timeout
 			(thread->wqueue,
 			 test_bit(THREAD_WAKEUP, &thread->flags)
 			 || kthread_should_stop() || kthread_should_park(),
@@ -8133,6 +8135,8 @@ void md_do_sync(struct md_thread *thread)
 		return;
 	}
 
+	set_freezable();
+
 	if (mddev_is_clustered(mddev)) {
 		ret = md_cluster_ops->resync_start(mddev);
 		if (ret)
@@ -8324,7 +8328,7 @@ void md_do_sync(struct md_thread *thread)
 		     mddev->curr_resync_completed > mddev->resync_max
 			    )) {
 			/* time to update curr_resync_completed */
-			wait_event(mddev->recovery_wait,
+			wait_event_freezable(mddev->recovery_wait,
 				   atomic_read(&mddev->recovery_active) == 0);
 			mddev->curr_resync_completed = j;
 			if (test_bit(MD_RECOVERY_SYNC, &mddev->recovery) &&
@@ -8342,10 +8346,10 @@ void md_do_sync(struct md_thread *thread)
 			 * to avoid triggering warnings.
 			 */
 			flush_signals(current); /* just in case */
-			wait_event_interruptible(mddev->recovery_wait,
-						 mddev->resync_max > j
-						 || test_bit(MD_RECOVERY_INTR,
-							     &mddev->recovery));
+			wait_event_freezable(mddev->recovery_wait,
+					     mddev->resync_max > j ||
+					     test_bit(MD_RECOVERY_INTR,
+						      &mddev->recovery));
 		}
 
 		if (test_bit(MD_RECOVERY_INTR, &mddev->recovery))
@@ -8421,7 +8425,7 @@ void md_do_sync(struct md_thread *thread)
 				 * Give other IO more of a chance.
 				 * The faster the devices, the less we wait.
 				 */
-				wait_event(mddev->recovery_wait,
+				wait_event_freezable(mddev->recovery_wait,
 					   !atomic_read(&mddev->recovery_active));
 			}
 		}
@@ -8433,7 +8437,8 @@ void md_do_sync(struct md_thread *thread)
 	 * this also signals 'finished resyncing' to md_stop
 	 */
 	blk_finish_plug(&plug);
-	wait_event(mddev->recovery_wait, !atomic_read(&mddev->recovery_active));
+	wait_event_freezable(mddev->recovery_wait,
+			     !atomic_read(&mddev->recovery_active));
 
 	if (!test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery) &&
 	    !test_bit(MD_RECOVERY_INTR, &mddev->recovery) &&
-- 
2.14.1
