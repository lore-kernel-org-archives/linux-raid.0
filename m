From: Shaohua Li <shli@fb.com>
Subject: [PATCH] raid5: only dispatch IO from raid5d for harddisk raid
Date: Wed, 4 Jan 2017 09:57:45 -0800
Message-ID: <9e987c0d95c49224da7fb82477dd10fcacf4d794.1483552525.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Kernel-team@fb.com, NeilBrown <neilb@suse.com>, Song Liu <songliubraving@fb.com>
List-Id: linux-raid.ids

We made raid5 stripe handling multi-thread before. It works well for
SSD. But for harddisk, the multi-threading creates more disk seek, so
not always improve performance. For several hard disks based raid5,
multi-threading is required as raid5d becames a bottleneck especially
for sequential write.

To overcome the disk seek issue, we only dispatch IO from raid5d if the
array is harddisk based. Other threads can still handle stripes, but
can't dispatch IO.

Idealy, we should control IO dispatching order according to IO position
interrnally. Right now we still depend on block layer, which isn't very
efficient sometimes though.

My setup has 9 harddisks, each disk can do around 180M/s sequential
write. So in theory, the raid5 can do 180 * 8 = 1440M/s sequential
write. The test machine uses an ATOM CPU. I measure sequential write
with large iodepth bandwidth to raid array:

without patch: ~600M/s
without patch and group_thread_cnt=4: 750M/s
with patch and group_thread_cnt=4: 950M/s
with patch, group_thread_cnt=4, skip_copy=1: 1150M/s

We are pretty close to the maximum bandwidth in the large iodepth
iodepth case. The performance gap of small iodepth sequential write
between software raid and theory value is still very big though, because
we don't have an efficient pipeline.

Cc: NeilBrown <neilb@suse.com>
Cc: Song Liu <songliubraving@fb.com>
Signed-off-by: Shaohua Li <shli@fb.com>
---
 drivers/md/raid5.c | 53 +++++++++++++++++++++++++++++++++++++++++++++++++++--
 drivers/md/raid5.h |  4 ++++
 2 files changed, 55 insertions(+), 2 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 06d7279..81417cf 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -861,6 +861,43 @@ static int use_new_offset(struct r5conf *conf, struct stripe_head *sh)
 	return 1;
 }
 
+static void flush_deferred_bios(struct r5conf *conf)
+{
+	struct bio_list tmp;
+	struct bio *bio;
+
+	if (!conf->batch_bio_dispatch || !conf->group_cnt)
+		return;
+
+	bio_list_init(&tmp);
+	spin_lock(&conf->pending_bios_lock);
+	bio_list_merge(&tmp, &conf->pending_bios);
+	bio_list_init(&conf->pending_bios);
+	spin_unlock(&conf->pending_bios_lock);
+
+	while ((bio = bio_list_pop(&tmp)))
+		generic_make_request(bio);
+}
+
+static void defer_bio_issue(struct r5conf *conf, struct bio *bio)
+{
+	/*
+	 * change group_cnt will drain all bios, so this is safe
+	 *
+	 * A read generally means a read-modify-write, which usually means a
+	 * randwrite, so we don't delay it
+	 */
+	if (!conf->batch_bio_dispatch || !conf->group_cnt ||
+	    bio_op(bio) == REQ_OP_READ) {
+		generic_make_request(bio);
+		return;
+	}
+	spin_lock(&conf->pending_bios_lock);
+	bio_list_add(&conf->pending_bios, bio);
+	spin_unlock(&conf->pending_bios_lock);
+	md_wakeup_thread(conf->mddev->thread);
+}
+
 static void
 raid5_end_read_request(struct bio *bi);
 static void
@@ -1031,7 +1068,7 @@ static void ops_run_io(struct stripe_head *sh, struct stripe_head_state *s)
 				trace_block_bio_remap(bdev_get_queue(bi->bi_bdev),
 						      bi, disk_devt(conf->mddev->gendisk),
 						      sh->dev[i].sector);
-			generic_make_request(bi);
+			defer_bio_issue(conf, bi);
 		}
 		if (rrdev) {
 			if (s->syncing || s->expanding || s->expanded
@@ -1076,7 +1113,7 @@ static void ops_run_io(struct stripe_head *sh, struct stripe_head_state *s)
 				trace_block_bio_remap(bdev_get_queue(rbi->bi_bdev),
 						      rbi, disk_devt(conf->mddev->gendisk),
 						      sh->dev[i].sector);
-			generic_make_request(rbi);
+			defer_bio_issue(conf, rbi);
 		}
 		if (!rdev && !rrdev) {
 			if (op_is_write(op))
@@ -6057,6 +6094,8 @@ static void raid5d(struct md_thread *thread)
 		mutex_unlock(&conf->cache_size_mutex);
 	}
 
+	flush_deferred_bios(conf);
+
 	r5l_flush_stripe_to_raid(conf->log);
 
 	async_tx_issue_pending_all();
@@ -6642,6 +6681,16 @@ static struct r5conf *setup_conf(struct mddev *mddev)
 	atomic_set(&conf->active_stripes, 0);
 	atomic_set(&conf->preread_active_stripes, 0);
 	atomic_set(&conf->active_aligned_reads, 0);
+	bio_list_init(&conf->pending_bios);
+	spin_lock_init(&conf->pending_bios_lock);
+	conf->batch_bio_dispatch = true;
+	rdev_for_each(rdev, mddev) {
+		if (blk_queue_nonrot(bdev_get_queue(rdev->bdev))) {
+			conf->batch_bio_dispatch = false;
+			break;
+		}
+	}
+
 	conf->bypass_threshold = BYPASS_THRESHOLD;
 	conf->recovery_disabled = mddev->recovery_disabled - 1;
 
diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
index ed8e136..2af5bea 100644
--- a/drivers/md/raid5.h
+++ b/drivers/md/raid5.h
@@ -679,6 +679,10 @@ struct r5conf {
 	int			group_cnt;
 	int			worker_cnt_per_group;
 	struct r5l_log		*log;
+
+	struct bio_list		pending_bios;
+	spinlock_t		pending_bios_lock;
+	bool			batch_bio_dispatch;
 };
 
 
-- 
2.9.3

