From: NeilBrown <neilb@suse.com>
Subject: [md PATCH 14/14] MD: use per-cpu counter for writes_pending
Date: Thu, 16 Feb 2017 15:39:03 +1100
Message-ID: <148721994322.7521.3431105903303667812.stgit@noble>
References: <148721992248.7521.17160361058957519076.stgit@noble>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <148721992248.7521.17160361058957519076.stgit@noble>
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

So we replace the atomic counter with a per-cpu array of
'long' counters. Incrementing and decrementing is normally
much cheaper, testing for zero is more expensive.

To meaningfully be able to test for zero we need to be able
to block further updates.  This is done by forcing the
"increment" step to take a spinlock in the rare case that
another thread is checking if the count is zero.  This is
done using a new field: "checkers".  "checkers" is the
number of threads that are currently checking whether the
count is zero.  It is usually 0, occasionally 1, and it is
not impossible that it could be higher, though this would be
rare.

If, within an rcu_read_locked section, checkers is seen to
be zero, then the local-cpu counter can be incremented
freely.  If checkers is not zero, mddev->lock must be taken
before the increment is allowed.  A decrement is always
allowed.

To test for zero, a thread must increment "checkers", call
synchronize_rcu(), then take mddev->lock.  Once this is done
no new increments can happen.  A thread may choose to
perform a quick test-for-zero by summing all the counters
without holding a lock.  If this is non-zero, the the total
count is non-zero, or was non-zero very recently, so it is
safe to assume that it isn't zero.  If the quick check does
report a zero sum, then it is worth performing the locking
protocol.

When the counter is decremented, it is no longer possible to
immediately test if the result is zero
(atmic_dec_and_test()).  We don't even really want to
perform the "quick" tests as that sums over all cpus and is
work that will most often bring no benefit.

In the "safemode==2" case, when we want to mark the array as
"clean" immediately when there are no writes, we perform the
quick test anyway, and possibly wake the md thread to do the
full test.  "safemode==2" is only used during shutdown so
the cost is not problematic.

When safemode!=2 we always set the timer, rather than only
when the counter reaches zero.

If mod_timer() is called to set the timeout to the value it
already has, mod_timer() has low overhead with no atomic
operations.  So at worst it will have a noticeable cost once
per jiffie.  To further reduce the otherhead, we round the
requests delay to a multiple of ->safemode_delay.  This
might increase the delay until the timer fires a little, but
will reduce the overhead of calling mod_timer()
significantly.  If lots of requests are completing, the
timer will be updated every 200 milliseconds (by default)
and never fire.  When it does eventually fire, it will
schedule the md thread to perform the full test for
writes_pending==0, and this is quite likely to find '0'.

Signed-off-by: NeilBrown <neilb@suse.com>
---
 drivers/md/md.c |  107 +++++++++++++++++++++++++++++++++++++++++++++++--------
 drivers/md/md.h |    3 +-
 2 files changed, 93 insertions(+), 17 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index f856c95ee7d5..47bbd22e2865 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -64,6 +64,8 @@
 #include <linux/raid/md_p.h>
 #include <linux/raid/md_u.h>
 #include <linux/slab.h>
+#include <linux/percpu.h>
+
 #include <trace/events/block.h>
 #include "md.h"
 #include "bitmap.h"
@@ -2250,21 +2252,52 @@ static void export_array(struct mddev *mddev)
 	mddev->major_version = 0;
 }
 
+/*
+ * The percpu writes_pending counters are linked with ->checkers and
+ * ->lock.  If ->writes_pending can always be decremented without a
+ * lock.  It can only be incremented without a lock if ->checkers is 0
+ * and the test+incr happen in a rcu_readlocked region.
+ * ->checkers can only be changed under ->lock protection.
+ * To determine if ->writes_pending is totally zero, a quick sum without
+ * locks can be performed. If this is non-zero, then the result is final.
+ * Otherwise ->checkers must be incremented and synchronize_rcu() called.
+ * Then a sum calculated under ->lock, and the result is final until the
+ * ->checkers is decremented, or the lock is dropped.
+ *
+ */
+
+static bool __writes_pending(struct mddev *mddev)
+{
+	long cnt = 0;
+	int i;
+
+	for_each_possible_cpu(i)
+		cnt += *per_cpu_ptr(mddev->writes_pending_percpu, i);
+	return cnt != 0;
+}
+
 static bool set_in_sync(struct mddev *mddev)
 {
 	bool ret = false;
 
 	WARN_ON_ONCE(!spin_is_locked(&mddev->lock));
-	if (atomic_read(&mddev->writes_pending) == 0) {
-		if (mddev->in_sync == 0) {
+	if (!__writes_pending(mddev) && !mddev->in_sync) {
+		mddev->checkers++;
+		spin_unlock(&mddev->lock);
+		synchronize_rcu();
+		spin_lock(&mddev->lock);
+		if (!mddev->in_sync &&
+		    !__writes_pending(mddev)) {
 			mddev->in_sync = 1;
+			/*
+			 * Ensure in_sync is visible before ->checkers
+			 * is decremented
+			 */
 			smp_mb();
-			if (atomic_read(&mddev->writes_pending))
-				/* lost a race with md_write_start() */
-				mddev->in_sync = 0;
 			set_bit(MD_SB_CHANGE_CLEAN, &mddev->sb_flags);
 			sysfs_notify_dirent_safe(mddev->sysfs_state);
 		}
+		mddev->checkers--;
 		ret = true;
 	}
 	if (mddev->safemode == 1)
@@ -2272,6 +2305,29 @@ static bool set_in_sync(struct mddev *mddev)
 	return ret;
 }
 
+static void inc_writes_pending(struct mddev *mddev)
+{
+	rcu_read_lock();
+	if (mddev->checkers == 0) {
+		__this_cpu_inc(*mddev->writes_pending_percpu);
+		rcu_read_unlock();
+		return;
+	}
+	rcu_read_unlock();
+	/* Need that spinlock */
+	spin_lock(&mddev->lock);
+	this_cpu_inc(*mddev->writes_pending_percpu);
+	spin_unlock(&mddev->lock);
+}
+
+static void zero_writes_pending(struct mddev *mddev)
+{
+	int i;
+
+	for_each_possible_cpu(i)
+		*per_cpu_ptr(mddev->writes_pending_percpu, i) = 0;
+}
+
 static void sync_sbs(struct mddev *mddev, int nospares)
 {
 	/* Update each superblock (in-memory image), but
@@ -5000,6 +5056,8 @@ static void md_free(struct kobject *ko)
 		del_gendisk(mddev->gendisk);
 		put_disk(mddev->gendisk);
 	}
+	if (mddev->writes_pending_percpu)
+		free_percpu(mddev->writes_pending_percpu);
 
 	kfree(mddev);
 }
@@ -5076,6 +5134,13 @@ static int md_alloc(dev_t dev, char *name)
 	blk_queue_make_request(mddev->queue, md_make_request);
 	blk_set_stacking_limits(&mddev->queue->limits);
 
+	mddev->writes_pending_percpu = alloc_percpu(long);
+	if (!mddev->writes_pending_percpu) {
+		blk_cleanup_queue(mddev->queue);
+		mddev->queue = NULL;
+		goto abort;
+	}
+
 	disk = alloc_disk(1 << shift);
 	if (!disk) {
 		blk_cleanup_queue(mddev->queue);
@@ -5159,7 +5224,7 @@ static void md_safemode_timeout(unsigned long data)
 {
 	struct mddev *mddev = (struct mddev *) data;
 
-	if (!atomic_read(&mddev->writes_pending)) {
+	if (!__writes_pending(mddev)) {
 		mddev->safemode = 1;
 		if (mddev->external)
 			sysfs_notify_dirent_safe(mddev->sysfs_state);
@@ -5365,7 +5430,7 @@ int md_run(struct mddev *mddev)
 	} else if (mddev->ro == 2) /* auto-readonly not meaningful */
 		mddev->ro = 0;
 
-	atomic_set(&mddev->writes_pending,0);
+	zero_writes_pending(mddev);
 	atomic_set(&mddev->max_corr_read_errors,
 		   MD_DEFAULT_MAX_CORRECTED_READ_ERRORS);
 	mddev->safemode = 0;
@@ -7774,11 +7839,13 @@ void md_write_start(struct mddev *mddev, struct bio *bi)
 		md_wakeup_thread(mddev->sync_thread);
 		did_change = 1;
 	}
-	atomic_inc(&mddev->writes_pending);
+	rcu_read_lock();
+	inc_writes_pending(mddev);
 	smp_mb(); /* Match smp_mb in set_in_sync() */
 	if (mddev->safemode == 1)
 		mddev->safemode = 0;
-	if (mddev->in_sync) {
+	if (mddev->in_sync || mddev->checkers) {
+		rcu_read_unlock();
 		spin_lock(&mddev->lock);
 		if (mddev->in_sync) {
 			mddev->in_sync = 0;
@@ -7788,7 +7855,9 @@ void md_write_start(struct mddev *mddev, struct bio *bi)
 			did_change = 1;
 		}
 		spin_unlock(&mddev->lock);
-	}
+	} else
+		rcu_read_unlock();
+
 	if (did_change)
 		sysfs_notify_dirent_safe(mddev->sysfs_state);
 	wait_event(mddev->sb_wait,
@@ -7798,12 +7867,18 @@ EXPORT_SYMBOL(md_write_start);
 
 void md_write_end(struct mddev *mddev)
 {
-	if (atomic_dec_and_test(&mddev->writes_pending)) {
-		if (mddev->safemode == 2)
+	this_cpu_dec(*mddev->writes_pending_percpu);
+	if (mddev->safemode == 2) {
+		if (!__writes_pending(mddev))
 			md_wakeup_thread(mddev->thread);
-		else if (mddev->safemode_delay)
-			mod_timer(&mddev->safemode_timer, jiffies + mddev->safemode_delay);
-	}
+	} else if (mddev->safemode_delay)
+		/* The roundup() ensure this only performs locking once
+		 * every ->safemode_delay jiffies
+		 */
+		mod_timer(&mddev->safemode_timer,
+			  roundup(jiffies, mddev->safemode_delay) +
+			  mddev->safemode_delay);
+
 }
 EXPORT_SYMBOL(md_write_end);
 
@@ -8406,7 +8481,7 @@ void md_check_recovery(struct mddev *mddev)
 		test_bit(MD_RECOVERY_DONE, &mddev->recovery) ||
 		test_bit(MD_RELOAD_SB, &mddev->flags) ||
 		(mddev->external == 0 && mddev->safemode == 1) ||
-		(mddev->safemode == 2 && ! atomic_read(&mddev->writes_pending)
+		(mddev->safemode == 2 && !__writes_pending(mddev)
 		 && !mddev->in_sync && mddev->recovery_cp == MaxSector)
 		))
 		return;
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 2a514036a83d..7e41f882d33d 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -404,7 +404,8 @@ struct mddev {
 							 */
 	unsigned int			safemode_delay;
 	struct timer_list		safemode_timer;
-	atomic_t			writes_pending;
+	long				*writes_pending_percpu;
+	int				checkers;	/* # of threads checking writes_pending */
 	struct request_queue		*queue;	/* for plugging ... */
 
 	struct bitmap			*bitmap; /* the bitmap for the device */


