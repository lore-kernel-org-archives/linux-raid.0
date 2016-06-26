From: Alexander Lyakas <alex.bolshoy@gmail.com>
Subject: [PATCH RFC] md/raid1: fix deadlock between freeze_array() and wait_barrier().
Date: Sun, 26 Jun 2016 22:18:39 +0300
Message-ID: <CAGRgLy6RcG0_DYbd89LK0fWSJkMgqmDYn8ug7pYn+4uRqDRGqg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>, =?UTF-8?B?6ams5bu65pyL?= <majianpeng@gmail.com>, linux-raid <linux-raid@vger.kernel.org>
Cc: Jes Sorensen <jes.sorensen@redhat.com>
List-Id: linux-raid.ids

When we call wait_barrier, we might have some bios waiting
in current->bio_list, which prevents the array_freeze call to
complete. Those can only be internal READs, which have already
passed the wait_barrier call (thus incrementing nr_pending), but
still were not submitted to the lower level, due to generic_make_request
logic to avoid recursive calls. In such case, we have a deadlock:
- array_frozen is already set to 1, so wait_barrier unconditionally waits, so
- internal READ bios will not be submitted, thus freeze_array will
never completes

This problem was originally fixed in commit:
d6b42dc md/raid1,raid10: avoid deadlock during resync/recovery.

But then it was broken in commit:
b364e3d raid1: Add a field array_frozen to indicate whether raid in
freeze state.

Notes:

- the problem cannot happen for WRITEs, because when a WRITE is
submitted to MD, there are two cases:
    - calling thread has a plug: in that case, when this thread will
go to sleep in wait_barrier (or anywhere else), all the plugged IOs
will be flushed via:
schedule()=>sched_submit_work()=>blk_schedule_flush_plug()
    - calling thread is not plugged: in that case internal WRITEs are
handed off to raid1d, which     doesn't have current->bio_list issues

- current->bio_list may contains an internal READ bio from a different
MD! This can happen, for example, when two or more MDs are under
dm-stripe.

- the commit causing the issue mentioned above, also made
freeze_array() call non-reentrant, because array_frozen can be 0 or 1
only. Thus if two threads call freeze_array() in parallel (and it may
happen), the first thread that calls unfreeze_array() sets
array_frozen=0, but the second thread still thinks array is frozen.
This patch does not address this problem, it only adds a warning.

This patch demonstrates a rudimentary fix, which fixes the issue for me.
The patch is based on kernel 3.18.
---
 drivers/md/raid1.c | 128 ++++++++++++++++++++++++++++++++++++++++++++++++++++-
 drivers/md/raid1.h |   1 +
 2 files changed, 127 insertions(+), 2 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 3c8ada4..92541b4 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -59,20 +59,27 @@
 #define IO_MADE_GOOD ((struct bio *)2)

 #define BIO_SPECIAL(bio) ((unsigned long)bio <= 2)

 /* When there are this many requests queue to be written by
  * the raid1 thread, we become 'congested' to provide back-pressure
  * for writeback.
  */
 static int max_queued_requests = 1024;

+/* see wait_barrier_rescue */
+struct workqueue_struct *g_freeze_array_rescue_wq;
+struct work_struct g_freeze_array_rescue_work;
+struct bio_list g_bios_to_rescue;
+spinlock_t g_rescue_lock;
+
+
 static void allow_barrier(struct r1conf *conf, sector_t start_next_window,
               sector_t bi_sector);
 static void lower_barrier(struct r1conf *conf);

 static void * r1bio_pool_alloc(gfp_t gfp_flags, void *data)
 {
     struct pool_info *pi = data;
     int size = offsetof(struct r1bio, bios[pi->raid_disks]);

     /* allocate a r1bio with room for raid_disks entries in the bios array */
@@ -883,26 +890,112 @@ static bool need_to_wait_for_sync(struct r1conf
*conf, struct bio *bio)
             (conf->next_resync + NEXT_NORMALIO_DISTANCE
              <= bio->bi_iter.bi_sector))
             wait = false;
         else
             wait = true;
     }

     return wait;
 }

+/*
+ * When we call wait_barrier, we might have some bios waiting
+ * in current->bio_list, which prevents the array_freeze call to
+ * complete. Those can only be internal READs, which have already
+ * passed the wait_barrier call (thus incrementing nr_pending), but
+ * still were not submitted to the lower level, due to generic_make_request
+ * logic to avoid recursive calls. In such case, we have a deadlock:
+ * - array_frozen is already set to 1, so wait_barrier
unconditionally waits, so
+ * - internal READ bios will not be submitted, thus freeze_array will
never completes
+ *
+ * This problem was originally fixed in commit:
+ * d6b42dc md/raid1,raid10: avoid deadlock during resync/recovery.
+ *
+ * But then was broken in commit:
+ * b364e3d raid1: Add a field array_frozen to indicate whether raid
in freeze state.
+ *
+ * Notes:
+ * - the problem cannot happen for WRITEs, because when a WRITE is
submitted to MD, there are two cases:
+ *   - calling thread has a plug: in that case, when this thread will
go to sleep in wait_barrier (or anywhere elese),
+ *     all the plugged IOs will be flushed via:
schedule()=>sched_submit_work()=>blk_schedule_flush_plug()
+ *   - calling thread is not plugged: in that case internal WRITEs
are handed off to raid1d, which
+ *     doesn't have current->bio_list issues
+ * - note that current->bio_list may contains an internal READ bio
from a different MD! This can
+ *   happen, for example, when two or more MDs are under dm-stripe.
+ */
+static void wait_barrier_rescue(struct r1conf *conf)
+{
+    struct bio_list bios_to_rescue;
+    struct bio *bio = NULL;
+
+    assert_spin_locked(&conf->resync_lock);
+
+    if (current->bio_list == NULL)
+        return;
+    if (!(conf->array_frozen && !conf->array_frozen_done))
+        return;
+
+    bio_list_init(&bios_to_rescue);
+
+    /* grab the whole current->bio_list locally */
+    bio = bio_list_get(current->bio_list);
+
+    /* iterate over the local list */
+    while (bio) {
+        struct bio *next = bio->bi_next;
+        bio->bi_next = NULL;
+
+        if (bio->bi_end_io == raid1_end_read_request)
+            /* this is a problematic bio, set it aside */
+            bio_list_add(&bios_to_rescue, bio);
+        else
+            /* return this bio back to current->bio_list */
+            bio_list_add(current->bio_list, bio);
+
+        bio = next;
+    }
+
+    /* do we have any bios to rescue? */
+    if (bios_to_rescue.head != NULL) {
+        spin_lock(&g_rescue_lock);
+        bio_list_merge(&g_bios_to_rescue, &bios_to_rescue);
+        spin_unlock(&g_rescue_lock);
+        queue_work(g_freeze_array_rescue_wq, &g_freeze_array_rescue_work);
+    }
+}
+
+static void raid1_rescue_work(struct work_struct *work)
+{
+    struct bio *bio = NULL;
+
+    spin_lock(&g_rescue_lock);
+    bio = bio_list_get(&g_bios_to_rescue);
+    spin_unlock(&g_rescue_lock);
+
+    while (bio) {
+        struct bio *next = bio->bi_next;
+
+        bio->bi_next = NULL;
+
+        generic_make_request(bio);
+
+        bio = next;
+    }
+}
+
 static sector_t wait_barrier(struct r1conf *conf, struct bio *bio)
 {
     sector_t sector = 0;

     spin_lock_irq(&conf->resync_lock);
     if (need_to_wait_for_sync(conf, bio)) {
+        wait_barrier_rescue(conf);
         conf->nr_waiting++;
         /* Wait for the barrier to drop.
          * However if there are already pending
          * requests (preventing the barrier from
          * rising completely), and the
          * per-process bio queue isn't empty,
          * then don't wait, as we need to empty
          * that queue to allow conf->start_next_window
          * to increase.
          */
@@ -978,32 +1071,35 @@ static void freeze_array(struct r1conf *conf, int extra)
      * We wait until nr_pending match nr_queued+extra
      * This is called in the context of one normal IO request
      * that has failed. Thus any sync request that might be pending
      * will be blocked by nr_pending, and we need to wait for
      * pending IO requests to complete or be queued for re-try.
      * Thus the number queued (nr_queued) plus this request (extra)
      * must match the number of pending IOs (nr_pending) before
      * we continue.
      */
     spin_lock_irq(&conf->resync_lock);
+    WARN(conf->array_frozen, "%s-R1 re-enterting freeze_array!!!",
mdname(conf->mddev));
     conf->array_frozen = 1;
     wait_event_lock_irq_cmd(conf->wait_barrier,
                 conf->nr_pending == conf->nr_queued+extra,
                 conf->resync_lock,
                 flush_pending_writes(conf));
+    conf->array_frozen_done = 1;
     spin_unlock_irq(&conf->resync_lock);
 }
 static void unfreeze_array(struct r1conf *conf)
 {
     /* reverse the effect of the freeze */
     spin_lock_irq(&conf->resync_lock);
     conf->array_frozen = 0;
+    conf->array_frozen_done = 0;
     wake_up(&conf->wait_barrier);
     spin_unlock_irq(&conf->resync_lock);
 }

 /* duplicate the data pages for behind I/O
  */
 static void alloc_behind_pages(struct bio *bio, struct r1bio *r1_bio)
 {
     int i;
     struct bio_vec *bvec;
@@ -3162,23 +3258,25 @@ static void *raid1_takeover(struct mddev *mddev)
 {
     /* raid1 can take over:
      *  raid5 with 2 devices, any layout or chunk size
      */
     if (mddev->level == 5 && mddev->raid_disks == 2) {
         struct r1conf *conf;
         mddev->new_level = 1;
         mddev->new_layout = 0;
         mddev->new_chunk_sectors = 0;
         conf = setup_conf(mddev);
-        if (!IS_ERR(conf))
+        if (!IS_ERR(conf)) {
             /* Array must appear to be quiesced */
             conf->array_frozen = 1;
+            conf->array_frozen_done = 1;
+        }
         return conf;
     }
     return ERR_PTR(-EINVAL);
 }

 static struct md_personality raid1_personality =
 {
     .name        = "raid1",
     .level        = 1,
     .owner        = THIS_MODULE,
@@ -3193,25 +3291,51 @@ static struct md_personality raid1_personality =
     .sync_request    = sync_request,
     .resize        = raid1_resize,
     .size        = raid1_size,
     .check_reshape    = raid1_reshape,
     .quiesce    = raid1_quiesce,
     .takeover    = raid1_takeover,
 };

 static int __init raid_init(void)
 {
-    return register_md_personality(&raid1_personality);
+    int ret = 0;
+
+    bio_list_init(&g_bios_to_rescue);
+    spin_lock_init(&g_rescue_lock);
+
+    INIT_WORK(&g_freeze_array_rescue_work, raid1_rescue_work);
+
+    /* we have only one work item, so we need only one active work at a time */
+    g_freeze_array_rescue_wq = alloc_workqueue("raid1_rescue_wq",
+            WQ_UNBOUND | WQ_MEM_RECLAIM | WQ_SYSFS,
+            1/*max_active*/);
+    if (g_freeze_array_rescue_wq == NULL) {
+        pr_err("alloc_workqueue(zraid1_rescue_wq) failed");
+        ret =-ENOMEM;
+        goto out;
+    }
+
+    ret = register_md_personality(&raid1_personality);
+    if (ret != 0)
+        goto free_wq;
+
+free_wq:
+    destroy_workqueue(g_freeze_array_rescue_wq);
+out:
+    return ret;
 }

 static void raid_exit(void)
 {
+    flush_workqueue(g_freeze_array_rescue_wq);
+    destroy_workqueue(g_freeze_array_rescue_wq);
     unregister_md_personality(&raid1_personality);
 }

 module_init(raid_init);
 module_exit(raid_exit);
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("RAID1 (mirroring) personality for MD");
 MODULE_ALIAS("md-personality-3"); /* RAID1 */
 MODULE_ALIAS("md-raid1");
 MODULE_ALIAS("md-level-1");
diff --git a/drivers/md/raid1.h b/drivers/md/raid1.h
index 33bda55..a7d0bd4 100644
--- a/drivers/md/raid1.h
+++ b/drivers/md/raid1.h
@@ -72,20 +72,21 @@ struct r1conf {
      * is no other IO.  So when either is active, the other has to wait.
      * See more details description in raid1.c near raise_barrier().
      */
     wait_queue_head_t    wait_barrier;
     spinlock_t        resync_lock;
     int            nr_pending;
     int            nr_waiting;
     int            nr_queued;
     int            barrier;
     int            array_frozen;
+    int            array_frozen_done;

     /* Set to 1 if a full sync is needed, (fresh device added).
      * Cleared when a sync completes.
      */
     int            fullsync;

     /* When the same as mddev->recovery_disabled we don't allow
      * recovery to be attempted as we expect a read error.
      */
     int            recovery_disabled;
-- 
1.9.1
