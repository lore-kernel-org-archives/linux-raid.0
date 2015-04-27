From: Yuanhan Liu <yuanhan.liu@linux.intel.com>
Subject: [PATCH 2/3 v2] md/raid5: split wait_for_stripe and introduce wait_for_quiescent
Date: Mon, 27 Apr 2015 12:51:02 +0800
Message-ID: <1430110263-23977-2-git-send-email-yuanhan.liu@linux.intel.com>
References: <1430110263-23977-1-git-send-email-yuanhan.liu@linux.intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1430110263-23977-1-git-send-email-yuanhan.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, Yuanhan Liu <yuanhan.liu@linux.intel.com>
List-Id: linux-raid.ids

I noticed heavy spin lock contention at get_active_stripe(), introduced
at being wake up stage, where a bunch of processes try to re-hold the
spin lock again.

After giving some thoughts on this issue, I found the lock could be
relieved(and even avoided) if we turn the wait_for_stripe to per
waitqueue for each lock hash and make the wake up exclusive: wake up
one process each time, which avoids the lock contention naturally.

Before go hacking with wait_for_stripe, I found it actually has 2
usages: for the array to enter or leave the quiescent state, and also
to wait for an available stripe in each of the hash lists.

So this patch splits the first usage off into a separate wait_queue,
wait_for_quiescent, and the next patch will turn the second usage into
one waitqueue for each hash value, and make it exclusive, to relieve
the lock contention.

v2: wake_up(wait_for_quiescent) when (active_stripes == 0)
    Commit log refactor suggestion from Neil.

Signed-off-by: Yuanhan Liu <yuanhan.liu@linux.intel.com>
---
 drivers/md/raid5.c | 15 +++++++++------
 drivers/md/raid5.h |  1 +
 2 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 77dfd72..64d5bea 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -374,6 +374,8 @@ static void release_inactive_stripe_list(struct r5conf *conf,
 
 	if (do_wakeup) {
 		wake_up(&conf->wait_for_stripe);
+		if (atomic_read(&conf->active_stripes) == 0)
+			wake_up(&conf->wait_for_quiescent);
 		if (conf->retry_read_aligned)
 			md_wakeup_thread(conf->mddev->thread);
 	}
@@ -667,7 +669,7 @@ get_active_stripe(struct r5conf *conf, sector_t sector,
 	spin_lock_irq(conf->hash_locks + hash);
 
 	do {
-		wait_event_lock_irq(conf->wait_for_stripe,
+		wait_event_lock_irq(conf->wait_for_quiescent,
 				    conf->quiesce == 0 || noquiesce,
 				    *(conf->hash_locks + hash));
 		sh = __find_stripe(conf, sector, conf->generation - previous);
@@ -4729,7 +4731,7 @@ static void raid5_align_endio(struct bio *bi, int error)
 					 raid_bi, 0);
 		bio_endio(raid_bi, 0);
 		if (atomic_dec_and_test(&conf->active_aligned_reads))
-			wake_up(&conf->wait_for_stripe);
+			wake_up(&conf->wait_for_quiescent);
 		return;
 	}
 
@@ -4824,7 +4826,7 @@ static int chunk_aligned_read(struct mddev *mddev, struct bio * raid_bio)
 		align_bi->bi_iter.bi_sector += rdev->data_offset;
 
 		spin_lock_irq(&conf->device_lock);
-		wait_event_lock_irq(conf->wait_for_stripe,
+		wait_event_lock_irq(conf->wait_for_quiescent,
 				    conf->quiesce == 0,
 				    conf->device_lock);
 		atomic_inc(&conf->active_aligned_reads);
@@ -5668,7 +5670,7 @@ static int  retry_aligned_read(struct r5conf *conf, struct bio *raid_bio)
 		bio_endio(raid_bio, 0);
 	}
 	if (atomic_dec_and_test(&conf->active_aligned_reads))
-		wake_up(&conf->wait_for_stripe);
+		wake_up(&conf->wait_for_quiescent);
 	return handled;
 }
 
@@ -6399,6 +6401,7 @@ static struct r5conf *setup_conf(struct mddev *mddev)
 		goto abort;
 	spin_lock_init(&conf->device_lock);
 	seqcount_init(&conf->gen_lock);
+	init_waitqueue_head(&conf->wait_for_quiescent);
 	init_waitqueue_head(&conf->wait_for_stripe);
 	init_waitqueue_head(&conf->wait_for_overlap);
 	INIT_LIST_HEAD(&conf->handle_list);
@@ -7422,7 +7425,7 @@ static void raid5_quiesce(struct mddev *mddev, int state)
 		 * active stripes can drain
 		 */
 		conf->quiesce = 2;
-		wait_event_cmd(conf->wait_for_stripe,
+		wait_event_cmd(conf->wait_for_quiescent,
 				    atomic_read(&conf->active_stripes) == 0 &&
 				    atomic_read(&conf->active_aligned_reads) == 0,
 				    unlock_all_device_hash_locks_irq(conf),
@@ -7436,7 +7439,7 @@ static void raid5_quiesce(struct mddev *mddev, int state)
 	case 0: /* re-enable writes */
 		lock_all_device_hash_locks_irq(conf);
 		conf->quiesce = 0;
-		wake_up(&conf->wait_for_stripe);
+		wake_up(&conf->wait_for_quiescent);
 		wake_up(&conf->wait_for_overlap);
 		unlock_all_device_hash_locks_irq(conf);
 		break;
diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
index 7dc0dd8..4cc05ec 100644
--- a/drivers/md/raid5.h
+++ b/drivers/md/raid5.h
@@ -508,6 +508,7 @@ struct r5conf {
 	struct list_head	inactive_list[NR_STRIPE_HASH_LOCKS];
 	atomic_t		empty_inactive_list_nr;
 	struct llist_head	released_stripes;
+	wait_queue_head_t	wait_for_quiescent;
 	wait_queue_head_t	wait_for_stripe;
 	wait_queue_head_t	wait_for_overlap;
 	unsigned long		cache_state;
-- 
1.9.0
