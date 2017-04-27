From: Xiao Ni <xni@redhat.com>
Subject: [MD PATCH v2 1/1] Use a new variable to count flighting sync requests
Date: Thu, 27 Apr 2017 16:28:49 +0800
Message-ID: <1493281729-5366-1-git-send-email-xni@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: shli@kernel.org, colyli@suse.de, ncroxon@redhat.com
List-Id: linux-raid.ids

In new barrier codes, raise_barrier waits if conf->nr_pending[idx] is not zero.
After all the conditions are true, the resync request can go on be handled. But
it adds conf->nr_pending[idx] again. The next resync request hit the same bucket
idx need to wait the resync request which is submitted before. The performance
of resync/recovery is degraded.
So we should use a new variable to count sync requests which are in flight.

I did a simple test:
1. Without the patch, create a raid1 with two disks. The resync speed:
Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sdb               0.00     0.00  166.00    0.00    10.38     0.00   128.00     0.03    0.20    0.20    0.00   0.19   3.20
sdc               0.00     0.00    0.00  166.00     0.00    10.38   128.00     0.96    5.77    0.00    5.77   5.75  95.50
2. With the patch, the result is:
sdb            2214.00     0.00  766.00    0.00   185.69     0.00   496.46     2.80    3.66    3.66    0.00   1.03  79.10
sdc               0.00  2205.00    0.00  769.00     0.00   186.44   496.52     5.25    6.84    0.00    6.84   1.30 100.10

Suggested-by: Shaohua Li <shli@kernel.org>
Signed-off-by: Xiao Ni <xni@redhat.com>
---
 drivers/md/raid1.c | 5 +++--
 drivers/md/raid1.h | 1 +
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index a34f587..ff5ee53 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -869,7 +869,7 @@ static void raise_barrier(struct r1conf *conf, sector_t sector_nr)
 			     atomic_read(&conf->barrier[idx]) < RESYNC_DEPTH,
 			    conf->resync_lock);
 
-	atomic_inc(&conf->nr_pending[idx]);
+	atomic_inc(&conf->nr_sync_pending);
 	spin_unlock_irq(&conf->resync_lock);
 }
 
@@ -880,7 +880,7 @@ static void lower_barrier(struct r1conf *conf, sector_t sector_nr)
 	BUG_ON(atomic_read(&conf->barrier[idx]) <= 0);
 
 	atomic_dec(&conf->barrier[idx]);
-	atomic_dec(&conf->nr_pending[idx]);
+	atomic_dec(&conf->nr_sync_pending);
 	wake_up(&conf->wait_barrier);
 }
 
@@ -1017,6 +1017,7 @@ static int get_unqueued_pending(struct r1conf *conf)
 {
 	int idx, ret;
 
+	ret = atomic_read(&conf->nr_sync_pending);
 	for (ret = 0, idx = 0; idx < BARRIER_BUCKETS_NR; idx++)
 		ret += atomic_read(&conf->nr_pending[idx]) -
 			atomic_read(&conf->nr_queued[idx]);
diff --git a/drivers/md/raid1.h b/drivers/md/raid1.h
index dd22a37..1668f22 100644
--- a/drivers/md/raid1.h
+++ b/drivers/md/raid1.h
@@ -84,6 +84,7 @@ struct r1conf {
 	 */
 	wait_queue_head_t	wait_barrier;
 	spinlock_t		resync_lock;
+	atomic_t		nr_sync_pending;
 	atomic_t		*nr_pending;
 	atomic_t		*nr_waiting;
 	atomic_t		*nr_queued;
-- 
2.7.4

