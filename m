From: Yuanhan Liu <yuanhan.liu@linux.intel.com>
Subject: [PATCH 1/2] md/raid5: split wait_for_stripe and introduce wait_for_quiesce
Date: Fri, 24 Apr 2015 21:39:03 +0800
Message-ID: <1429882744-22655-1-git-send-email-yuanhan.liu@linux.intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, Yuanhan Liu <yuanhan.liu@linux.intel.com>
List-Id: linux-raid.ids

If I read code correctly, current wait_for_stripe actually has 2 usage:

- wait for there is enough free stripe cache, triggered when
  get_free_stripe() failed. This is what wait_for_stripe intend
  for literally.

- wait for quiesce == 0 or
           active_aligned_reads == 0 && active_stripes == 0

  It has nothing to do with wait_for_stripe literally, and releasing
  an active stripe won't actually wake them up. On the contrary, wake_up
  from under this case won't actually wake up the process waiting for
  an free stripe being available.

Hence, we'd better split wait_for_stripe, and here I introduce
wait_for_quiesce for the second usage. The name may not well taken, or
even taken wrongly. Feel free to correct me then.

This is also a prepare patch for next patch: make wait_for_stripe
exclusive.

Signed-off-by: Yuanhan Liu <yuanhan.liu@linux.intel.com>
---
 drivers/md/raid5.c | 13 +++++++------
 drivers/md/raid5.h |  1 +
 2 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 9716319..b7e385f 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -667,7 +667,7 @@ get_active_stripe(struct r5conf *conf, sector_t sector,
 	spin_lock_irq(conf->hash_locks + hash);
 
 	do {
-		wait_event_lock_irq(conf->wait_for_stripe,
+		wait_event_lock_irq(conf->wait_for_quiesce,
 				    conf->quiesce == 0 || noquiesce,
 				    *(conf->hash_locks + hash));
 		sh = __find_stripe(conf, sector, conf->generation - previous);
@@ -4725,7 +4725,7 @@ static void raid5_align_endio(struct bio *bi, int error)
 					 raid_bi, 0);
 		bio_endio(raid_bi, 0);
 		if (atomic_dec_and_test(&conf->active_aligned_reads))
-			wake_up(&conf->wait_for_stripe);
+			wake_up(&conf->wait_for_quiesce);
 		return;
 	}
 
@@ -4820,7 +4820,7 @@ static int chunk_aligned_read(struct mddev *mddev, struct bio * raid_bio)
 		align_bi->bi_iter.bi_sector += rdev->data_offset;
 
 		spin_lock_irq(&conf->device_lock);
-		wait_event_lock_irq(conf->wait_for_stripe,
+		wait_event_lock_irq(conf->wait_for_quiesce,
 				    conf->quiesce == 0,
 				    conf->device_lock);
 		atomic_inc(&conf->active_aligned_reads);
@@ -5659,7 +5659,7 @@ static int  retry_aligned_read(struct r5conf *conf, struct bio *raid_bio)
 		bio_endio(raid_bio, 0);
 	}
 	if (atomic_dec_and_test(&conf->active_aligned_reads))
-		wake_up(&conf->wait_for_stripe);
+		wake_up(&conf->wait_for_quiesce);
 	return handled;
 }
 
@@ -6390,6 +6390,7 @@ static struct r5conf *setup_conf(struct mddev *mddev)
 		goto abort;
 	spin_lock_init(&conf->device_lock);
 	seqcount_init(&conf->gen_lock);
+	init_waitqueue_head(&conf->wait_for_quiesce);
 	init_waitqueue_head(&conf->wait_for_stripe);
 	init_waitqueue_head(&conf->wait_for_overlap);
 	INIT_LIST_HEAD(&conf->handle_list);
@@ -7413,7 +7414,7 @@ static void raid5_quiesce(struct mddev *mddev, int state)
 		 * active stripes can drain
 		 */
 		conf->quiesce = 2;
-		wait_event_cmd(conf->wait_for_stripe,
+		wait_event_cmd(conf->wait_for_quiesce,
 				    atomic_read(&conf->active_stripes) == 0 &&
 				    atomic_read(&conf->active_aligned_reads) == 0,
 				    unlock_all_device_hash_locks_irq(conf),
@@ -7427,7 +7428,7 @@ static void raid5_quiesce(struct mddev *mddev, int state)
 	case 0: /* re-enable writes */
 		lock_all_device_hash_locks_irq(conf);
 		conf->quiesce = 0;
-		wake_up(&conf->wait_for_stripe);
+		wake_up(&conf->wait_for_quiesce);
 		wake_up(&conf->wait_for_overlap);
 		unlock_all_device_hash_locks_irq(conf);
 		break;
diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
index 7dc0dd8..fab53a3 100644
--- a/drivers/md/raid5.h
+++ b/drivers/md/raid5.h
@@ -508,6 +508,7 @@ struct r5conf {
 	struct list_head	inactive_list[NR_STRIPE_HASH_LOCKS];
 	atomic_t		empty_inactive_list_nr;
 	struct llist_head	released_stripes;
+	wait_queue_head_t	wait_for_quiesce;
 	wait_queue_head_t	wait_for_stripe;
 	wait_queue_head_t	wait_for_overlap;
 	unsigned long		cache_state;
-- 
1.9.0
