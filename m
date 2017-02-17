From: Shaohua Li <shli@fb.com>
Subject: [PATCH 3/3] md/raid5: sort bios
Date: Fri, 17 Feb 2017 15:32:26 -0800
Message-ID: <01c6067566d787a815fc29aa07b36ad4dd0280f0.1487373517.git.shli@fb.com>
References: <cover.1487373517.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <cover.1487373517.git.shli@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.com, songliubraving@fb.com, kernel-team@fb.com
List-Id: linux-raid.ids

Previous patch (raid5: only dispatch IO from raid5d for harddisk raid)
defers IO dispatching. The goal is to create better IO pattern. At that
time, we don't sort the deffered IO and hope the block layer can do IO
merge and sort. Now the raid5-cache writeback could create large amount
of bios. And if we enable muti-thread for stripe handling, we can't
control when to dispatch IO to raid disks. In a lot of time, we are
dispatching IO which block layer can't do merge effectively.

This patch moves further for the IO dispatching defer. We accumulate
bios, but we don't dispatch all the bios after a threshold is met. This
'dispatch partial portion of bios' stragety allows bios coming in a
large time window are sent to disks together. At the dispatching time,
there is large chance the block layer can merge the bios. To make this
more effective, we dispatch IO in ascending order. This increases
request merge chance and reduces disk seek.

Signed-off-by: Shaohua Li <shli@fb.com>
---
 drivers/md/raid5.c | 141 ++++++++++++++++++++++++++++++++++++++++++++---------
 drivers/md/raid5.h |  11 ++++-
 2 files changed, 127 insertions(+), 25 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index d7c90da..fe6232f 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -56,6 +56,7 @@
 #include <linux/nodemask.h>
 #include <linux/flex_array.h>
 #include <trace/events/block.h>
+#include <linux/sort.h>
 
 #include "md.h"
 #include "raid5.h"
@@ -876,41 +877,121 @@ static int use_new_offset(struct r5conf *conf, struct stripe_head *sh)
 	return 1;
 }
 
-static void flush_deferred_bios(struct r5conf *conf)
+static void dispatch_bio_list(struct bio_list *tmp)
 {
-	struct bio_list tmp;
 	struct bio *bio;
 
+	while ((bio = bio_list_pop(tmp)))
+		generic_make_request(bio);
+}
+
+static int cmp_sh(const void *a, const void *b)
+{
+	const struct r5pending_data *da = a;
+	const struct r5pending_data *db = b;
+
+	if (da->sector > db->sector)
+		return 1;
+	if (da->sector < db->sector)
+		return -1;
+	return 0;
+}
+
+static void dispatch_defer_bios(struct r5conf *conf, int target,
+				struct bio_list *list)
+{
+	int start = 0;
+	int end = conf->pending_data_cnt - 1;
+	int mid;
+	int cnt = 0;
+
+	if (conf->pending_data_cnt == 0)
+		return;
+	sort(conf->pending_data, conf->pending_data_cnt,
+		sizeof(struct r5pending_data), cmp_sh, NULL);
+
+	while (start <= end) {
+		mid = (start + end) / 2;
+		if (conf->pending_data[mid].sector > conf->last_bio_pos)
+			end = mid - 1;
+		else if (conf->pending_data[mid].sector < conf->last_bio_pos)
+			start = mid + 1;
+		else {
+			start = mid;
+			break;
+		}
+	}
+
+	end = conf->pending_data_cnt - 1;
+	for (mid = start; mid <= end; mid++) {
+		conf->last_bio_pos = conf->pending_data[mid].sector;
+		bio_list_merge(list, &conf->pending_data[mid].bios);
+
+		cnt++;
+		if (cnt >= target) {
+			mid++;
+			break;
+		}
+	}
+	conf->pending_data_cnt -= cnt;
+	BUG_ON(conf->pending_data_cnt < 0);
+	if (mid <= end) {
+		memmove(&conf->pending_data[start], &conf->pending_data[mid],
+			(end - mid + 1) * sizeof(struct r5pending_data));
+		return;
+	}
+
+	for (mid = 0; mid < start; mid++) {
+		conf->last_bio_pos = conf->pending_data[mid].sector;
+		bio_list_merge(list, &conf->pending_data[mid].bios);
+
+		cnt++;
+		if (cnt >= target) {
+			mid++;
+			break;
+		}
+	}
+
+	conf->pending_data_cnt -= mid;
+	BUG_ON(conf->pending_data_cnt < 0);
+	if (mid == start) {
+		BUG_ON(conf->pending_data_cnt);
+		return;
+	}
+	memmove(&conf->pending_data[0], &conf->pending_data[mid],
+			(start - mid) * sizeof(struct r5pending_data));
+}
+
+static void flush_deferred_bios(struct r5conf *conf)
+{
+	struct bio_list tmp = BIO_EMPTY_LIST;
+
 	if (!conf->batch_bio_dispatch || !conf->group_cnt)
 		return;
 
-	bio_list_init(&tmp);
 	spin_lock(&conf->pending_bios_lock);
-	bio_list_merge(&tmp, &conf->pending_bios);
-	bio_list_init(&conf->pending_bios);
+	dispatch_defer_bios(conf, conf->pending_data_cnt, &tmp);
 	spin_unlock(&conf->pending_bios_lock);
 
-	while ((bio = bio_list_pop(&tmp)))
-		generic_make_request(bio);
+	dispatch_bio_list(&tmp);
 }
 
-static void defer_bio_issue(struct r5conf *conf, struct bio *bio)
+static void defer_issue_bios(struct r5conf *conf, sector_t sector,
+				struct bio_list *bios)
 {
-	/*
-	 * change group_cnt will drain all bios, so this is safe
-	 *
-	 * A read generally means a read-modify-write, which usually means a
-	 * randwrite, so we don't delay it
-	 */
-	if (!conf->batch_bio_dispatch || !conf->group_cnt ||
-	    bio_op(bio) == REQ_OP_READ) {
-		generic_make_request(bio);
-		return;
-	}
+	struct bio_list tmp = BIO_EMPTY_LIST;
+
 	spin_lock(&conf->pending_bios_lock);
-	bio_list_add(&conf->pending_bios, bio);
+	conf->pending_data[conf->pending_data_cnt].sector = sector;
+	bio_list_init(&conf->pending_data[conf->pending_data_cnt].bios);
+	bio_list_merge(&conf->pending_data[conf->pending_data_cnt].bios,
+		bios);
+	conf->pending_data_cnt++;
+	if (conf->pending_data_cnt >= PENDING_IO_MAX)
+		dispatch_defer_bios(conf, PENDING_IO_ONE_FLUSH, &tmp);
 	spin_unlock(&conf->pending_bios_lock);
-	md_wakeup_thread(conf->mddev->thread);
+
+	dispatch_bio_list(&tmp);
 }
 
 static void
@@ -923,6 +1004,8 @@ static void ops_run_io(struct stripe_head *sh, struct stripe_head_state *s)
 	struct r5conf *conf = sh->raid_conf;
 	int i, disks = sh->disks;
 	struct stripe_head *head_sh = sh;
+	struct bio_list pending_bios = BIO_EMPTY_LIST;
+	bool should_defer;
 
 	might_sleep();
 
@@ -939,6 +1022,8 @@ static void ops_run_io(struct stripe_head *sh, struct stripe_head_state *s)
 		}
 	}
 
+	should_defer = conf->batch_bio_dispatch && conf->group_cnt;
+
 	for (i = disks; i--; ) {
 		int op, op_flags = 0;
 		int replace_only = 0;
@@ -1093,7 +1178,10 @@ static void ops_run_io(struct stripe_head *sh, struct stripe_head_state *s)
 				trace_block_bio_remap(bdev_get_queue(bi->bi_bdev),
 						      bi, disk_devt(conf->mddev->gendisk),
 						      sh->dev[i].sector);
-			defer_bio_issue(conf, bi);
+			if (should_defer && op_is_write(op))
+				bio_list_add(&pending_bios, bi);
+			else
+				generic_make_request(bi);
 		}
 		if (rrdev) {
 			if (s->syncing || s->expanding || s->expanded
@@ -1138,7 +1226,10 @@ static void ops_run_io(struct stripe_head *sh, struct stripe_head_state *s)
 				trace_block_bio_remap(bdev_get_queue(rbi->bi_bdev),
 						      rbi, disk_devt(conf->mddev->gendisk),
 						      sh->dev[i].sector);
-			defer_bio_issue(conf, rbi);
+			if (should_defer && op_is_write(op))
+				bio_list_add(&pending_bios, rbi);
+			else
+				generic_make_request(rbi);
 		}
 		if (!rdev && !rrdev) {
 			if (op_is_write(op))
@@ -1156,6 +1247,9 @@ static void ops_run_io(struct stripe_head *sh, struct stripe_head_state *s)
 		if (sh != head_sh)
 			goto again;
 	}
+
+	if (should_defer && !bio_list_empty(&pending_bios))
+		defer_issue_bios(conf, head_sh->sector, &pending_bios);
 }
 
 static struct dma_async_tx_descriptor *
@@ -6808,7 +6902,6 @@ static struct r5conf *setup_conf(struct mddev *mddev)
 	atomic_set(&conf->active_stripes, 0);
 	atomic_set(&conf->preread_active_stripes, 0);
 	atomic_set(&conf->active_aligned_reads, 0);
-	bio_list_init(&conf->pending_bios);
 	spin_lock_init(&conf->pending_bios_lock);
 	conf->batch_bio_dispatch = true;
 	rdev_for_each(rdev, mddev) {
diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
index 6b9d2e8..eb6d5d5 100644
--- a/drivers/md/raid5.h
+++ b/drivers/md/raid5.h
@@ -572,6 +572,13 @@ enum r5_cache_state {
 				 */
 };
 
+#define PENDING_IO_MAX 512
+#define PENDING_IO_ONE_FLUSH 128
+struct r5pending_data {
+	sector_t sector; /* stripe sector */
+	struct bio_list bios;
+};
+
 struct r5conf {
 	struct hlist_head	*stripe_hashtbl;
 	/* only protect corresponding hash list and inactive_list */
@@ -689,9 +696,11 @@ struct r5conf {
 	int			worker_cnt_per_group;
 	struct r5l_log		*log;
 
-	struct bio_list		pending_bios;
 	spinlock_t		pending_bios_lock;
 	bool			batch_bio_dispatch;
+	struct r5pending_data	pending_data[PENDING_IO_MAX];
+	int			pending_data_cnt;
+	sector_t		last_bio_pos;
 };
 
 
-- 
2.9.3

