From: NeilBrown <neilb@suse.com>
Subject: [md PATCH 15/15] MD: use per-cpu counter for writes_pending
Date: Wed, 15 Mar 2017 14:05:14 +1100
Message-ID: <148954711465.18641.8222940807591984069.stgit@noble>
References: <148954692173.18641.1294690639716682540.stgit@noble>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <148954692173.18641.1294690639716682540.stgit@noble>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org, hch@lst.de
List-Id: linux-raid.ids

The 'writes_pending' counter is used to determine when the
array is stable so that it can be marked in the superblock
as "Clean".  Consequently it needs to be updated frequently
but only checked for zero occasionally.  Recent changes to
raid5 cause the count to be updated even more often - once
per 4K rather than once per bio.  This provided
justification for making the updates more efficient.

So we replace the atomic counter a percpu-refcount.
This can be incremented and decremented cheaply most of the
time, and can be switched to "atomic" mode when more
precise counting is needed.  As it is possible for multiple
threads to want a precise count, we introduce a
"sync_checker" counter to count the number of threads
in "set_in_sync()", and only switch the refcount back
to percpu mode when that is zero.

We need to be careful about races between set_in_sync()
setting ->in_sync to 1, and md_write_start() setting it
to zero.  md_write_start() holds the rcu_read_lock()
while checking if the refcount is in percpu mode.  If
it is, then we know a switch to 'atomic' will not happen until
after we call rcu_read_unlock(), in which case set_in_sync()
will see the elevated count, and not set in_sync to 1.
If it is not in percpu mode, we take the mddev->lock to
ensure proper synchronization.

It is no longer possible to quickly check if the count is zero, which
we previously did to update a timer or to schedule the md_thread.
So now we do these every time we decrement that counter, but make
sure they are fast.

mod_timer() already optimizes the case where the timeout value doesn't
actually change.  We leverage that further by always rounding off the
jiffies to the timeout value.  This may delay the marking of 'clean'
slightly, but ensure we only perform atomic operation here when absolutely
needed.

md_wakeup_thread() current always calls wake_up(), even if
THREAD_WAKEUP is already set.  That too can be optimised to avoid
calls to wake_up().

Signed-off-by: NeilBrown <neilb@suse.com>
---
 drivers/md/md.c |   70 +++++++++++++++++++++++++++++++++++++------------------
 drivers/md/md.h |    3 ++
 2 files changed, 49 insertions(+), 24 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index c33ec97b23d4..adf2b5bdfd67 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -65,6 +65,8 @@
 #include <linux/raid/md_p.h>
 #include <linux/raid/md_u.h>
 #include <linux/slab.h>
+#include <linux/percpu-refcount.h>
+
 #include <trace/events/block.h>
 #include "md.h"
 #include "bitmap.h"
@@ -2255,16 +2257,24 @@ static void export_array(struct mddev *mddev)
 static bool set_in_sync(struct mddev *mddev)
 {
 	WARN_ON_ONCE(!spin_is_locked(&mddev->lock));
-	if (atomic_read(&mddev->writes_pending) == 0) {
-		if (mddev->in_sync == 0) {
+	if (!mddev->in_sync) {
+		mddev->sync_checkers++;
+		spin_unlock(&mddev->lock);
+		percpu_ref_switch_to_atomic_sync(&mddev->writes_pending);
+		spin_lock(&mddev->lock);
+		if (!mddev->in_sync &&
+		    percpu_ref_is_zero(&mddev->writes_pending)) {
 			mddev->in_sync = 1;
+			/*
+			 * Ensure in_sync is visible before switch back
+			 * to percpu
+			 */
 			smp_mb();
-			if (atomic_read(&mddev->writes_pending))
-				/* lost a race with md_write_start() */
-				mddev->in_sync = 0;
 			set_bit(MD_SB_CHANGE_CLEAN, &mddev->sb_flags);
 			sysfs_notify_dirent_safe(mddev->sysfs_state);
 		}
+		if (--mddev->sync_checkers == 0)
+			percpu_ref_switch_to_percpu(&mddev->writes_pending);
 	}
 	if (mddev->safemode == 1)
 		mddev->safemode = 0;
@@ -5120,6 +5130,7 @@ static void md_free(struct kobject *ko)
 		del_gendisk(mddev->gendisk);
 		put_disk(mddev->gendisk);
 	}
+	percpu_ref_exit(&mddev->writes_pending);
 
 	kfree(mddev);
 }
@@ -5145,6 +5156,8 @@ static void mddev_delayed_delete(struct work_struct *ws)
 	kobject_put(&mddev->kobj);
 }
 
+static void no_op(struct percpu_ref *r) {}
+
 static int md_alloc(dev_t dev, char *name)
 {
 	static DEFINE_MUTEX(disks_mutex);
@@ -5196,6 +5209,10 @@ static int md_alloc(dev_t dev, char *name)
 	blk_queue_make_request(mddev->queue, md_make_request);
 	blk_set_stacking_limits(&mddev->queue->limits);
 
+	if (percpu_ref_init(&mddev->writes_pending, no_op, 0, GFP_KERNEL) < 0)
+		goto abort;
+	/* We want to start with the refcount at zero */
+	percpu_ref_put(&mddev->writes_pending);
 	disk = alloc_disk(1 << shift);
 	if (!disk) {
 		blk_cleanup_queue(mddev->queue);
@@ -5279,11 +5296,10 @@ static void md_safemode_timeout(unsigned long data)
 {
 	struct mddev *mddev = (struct mddev *) data;
 
-	if (!atomic_read(&mddev->writes_pending)) {
-		mddev->safemode = 1;
-		if (mddev->external)
-			sysfs_notify_dirent_safe(mddev->sysfs_state);
-	}
+	mddev->safemode = 1;
+	if (mddev->external)
+		sysfs_notify_dirent_safe(mddev->sysfs_state);
+
 	md_wakeup_thread(mddev->thread);
 }
 
@@ -5488,7 +5504,6 @@ int md_run(struct mddev *mddev)
 	} else if (mddev->ro == 2) /* auto-readonly not meaningful */
 		mddev->ro = 0;
 
-	atomic_set(&mddev->writes_pending,0);
 	atomic_set(&mddev->max_corr_read_errors,
 		   MD_DEFAULT_MAX_CORRECTED_READ_ERRORS);
 	mddev->safemode = 0;
@@ -7351,8 +7366,8 @@ void md_wakeup_thread(struct md_thread *thread)
 {
 	if (thread) {
 		pr_debug("md: waking up MD thread %s.\n", thread->tsk->comm);
-		set_bit(THREAD_WAKEUP, &thread->flags);
-		wake_up(&thread->wqueue);
+		if (!test_and_set_bit(THREAD_WAKEUP, &thread->flags))
+			wake_up(&thread->wqueue);
 	}
 }
 EXPORT_SYMBOL(md_wakeup_thread);
@@ -7886,6 +7901,7 @@ EXPORT_SYMBOL(md_done_sync);
  */
 void md_write_start(struct mddev *mddev, struct bio *bi)
 {
+	unsigned long __percpu *notused;
 	int did_change = 0;
 	if (bio_data_dir(bi) != WRITE)
 		return;
@@ -7899,11 +7915,12 @@ void md_write_start(struct mddev *mddev, struct bio *bi)
 		md_wakeup_thread(mddev->sync_thread);
 		did_change = 1;
 	}
-	atomic_inc(&mddev->writes_pending);
+	rcu_read_lock();
+	percpu_ref_get(&mddev->writes_pending);
 	smp_mb(); /* Match smp_mb in set_in_sync() */
 	if (mddev->safemode == 1)
 		mddev->safemode = 0;
-	if (mddev->in_sync) {
+	if (mddev->in_sync || !__ref_is_percpu(&mddev->writes_pending, &notused)) {
 		spin_lock(&mddev->lock);
 		if (mddev->in_sync) {
 			mddev->in_sync = 0;
@@ -7914,6 +7931,7 @@ void md_write_start(struct mddev *mddev, struct bio *bi)
 		}
 		spin_unlock(&mddev->lock);
 	}
+	rcu_read_unlock();
 	if (did_change)
 		sysfs_notify_dirent_safe(mddev->sysfs_state);
 	wait_event(mddev->sb_wait,
@@ -7934,19 +7952,25 @@ void md_write_inc(struct mddev *mddev, struct bio *bi)
 	if (bio_data_dir(bi) != WRITE)
 		return;
 	WARN_ON_ONCE(mddev->in_sync || mddev->ro);
-	atomic_inc(&mddev->writes_pending);
+	percpu_ref_get(&mddev->writes_pending);
 }
 EXPORT_SYMBOL(md_write_inc);
 
 void md_write_end(struct mddev *mddev)
 {
-	if (atomic_dec_and_test(&mddev->writes_pending)) {
-		if (mddev->safemode == 2)
-			md_wakeup_thread(mddev->thread);
-		else if (mddev->safemode_delay)
-			mod_timer(&mddev->safemode_timer, jiffies + mddev->safemode_delay);
-	}
+	percpu_ref_put(&mddev->writes_pending);
+
+	if (mddev->safemode == 2)
+		md_wakeup_thread(mddev->thread);
+	else if (mddev->safemode_delay)
+		/* The roundup() ensures this only performs locking once
+		 * every ->safemode_delay jiffies
+		 */
+		mod_timer(&mddev->safemode_timer,
+			  roundup(jiffies, mddev->safemode_delay) +
+			  mddev->safemode_delay);
 }
+
 EXPORT_SYMBOL(md_write_end);
 
 /* md_allow_write(mddev)
@@ -8547,7 +8571,7 @@ void md_check_recovery(struct mddev *mddev)
 		test_bit(MD_RECOVERY_NEEDED, &mddev->recovery) ||
 		test_bit(MD_RECOVERY_DONE, &mddev->recovery) ||
 		(mddev->external == 0 && mddev->safemode == 1) ||
-		(mddev->safemode == 2 && ! atomic_read(&mddev->writes_pending)
+		(mddev->safemode == 2
 		 && !mddev->in_sync && mddev->recovery_cp == MaxSector)
 		))
 		return;
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 0cd12721a536..7a7847d1cc39 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -409,7 +409,8 @@ struct mddev {
 							 */
 	unsigned int			safemode_delay;
 	struct timer_list		safemode_timer;
-	atomic_t			writes_pending;
+	struct percpu_ref		writes_pending;
+	int				sync_checkers;	/* # of threads checking writes_pending */
 	struct request_queue		*queue;	/* for plugging ... */
 
 	struct bitmap			*bitmap; /* the bitmap for the device */


