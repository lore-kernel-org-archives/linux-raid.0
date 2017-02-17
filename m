From: Shaohua Li <shli@fb.com>
Subject: [PATCH 1/3] md/raid5: prioritize stripes for writeback
Date: Fri, 17 Feb 2017 15:32:24 -0800
Message-ID: <b9e3986a466fffa2b901f6eff9c4ca6ec7398262.1487373517.git.shli@fb.com>
References: <cover.1487373517.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <cover.1487373517.git.shli@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.com, songliubraving@fb.com, kernel-team@fb.com
List-Id: linux-raid.ids

In raid5-cache writeback mode, we have two types of stripes to handle.
- stripes which aren't cached yet
- stripes which are cached and flushing out to raid disks

Upperlayer is more sensistive to latency of the first type of stripes
generally. But we only one handle list for all these stripes, where the
two types of stripes are mixed together. When reclaim flushes a lot of
stripes, the first type of stripes could be noticeably delayed. On the
other hand, if the log space is tight, we'd like to handle the second
type of stripes faster and free log space.

This patch destinguishes the two types stripes. They are added into
different handle list. When we try to get a stripe to handl, we prefer
the first type of stripes unless log space is tight.

This should have no impact for !writeback case.

Signed-off-by: Shaohua Li <shli@fb.com>
---
 drivers/md/raid5.c | 48 +++++++++++++++++++++++++++++++++++++++---------
 drivers/md/raid5.h |  2 ++
 2 files changed, 41 insertions(+), 9 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 7b7722bb2..d7c90da 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -174,6 +174,13 @@ static int stripe_operations_active(struct stripe_head *sh)
 	       test_bit(STRIPE_COMPUTE_RUN, &sh->state);
 }
 
+static bool stripe_is_lowprio(struct stripe_head *sh)
+{
+	return (test_bit(STRIPE_R5C_FULL_STRIPE, &sh->state) ||
+		test_bit(STRIPE_R5C_PARTIAL_STRIPE, &sh->state)) &&
+	       !test_bit(STRIPE_R5C_CACHING, &sh->state);
+}
+
 static void raid5_wakeup_stripe_thread(struct stripe_head *sh)
 {
 	struct r5conf *conf = sh->raid_conf;
@@ -189,7 +196,10 @@ static void raid5_wakeup_stripe_thread(struct stripe_head *sh)
 	if (list_empty(&sh->lru)) {
 		struct r5worker_group *group;
 		group = conf->worker_groups + cpu_to_group(cpu);
-		list_add_tail(&sh->lru, &group->handle_list);
+		if (stripe_is_lowprio(sh))
+			list_add_tail(&sh->lru, &group->loprio_list);
+		else
+			list_add_tail(&sh->lru, &group->handle_list);
 		group->stripes_cnt++;
 		sh->group = group;
 	}
@@ -252,7 +262,12 @@ static void do_release_stripe(struct r5conf *conf, struct stripe_head *sh,
 			clear_bit(STRIPE_DELAYED, &sh->state);
 			clear_bit(STRIPE_BIT_DELAY, &sh->state);
 			if (conf->worker_cnt_per_group == 0) {
-				list_add_tail(&sh->lru, &conf->handle_list);
+				if (stripe_is_lowprio(sh))
+					list_add_tail(&sh->lru,
+							&conf->loprio_list);
+				else
+					list_add_tail(&sh->lru,
+							&conf->handle_list);
 			} else {
 				raid5_wakeup_stripe_thread(sh);
 				return;
@@ -5169,19 +5184,27 @@ static struct bio *chunk_aligned_read(struct mddev *mddev, struct bio *raid_bio)
  */
 static struct stripe_head *__get_priority_stripe(struct r5conf *conf, int group)
 {
-	struct stripe_head *sh = NULL, *tmp;
+	struct stripe_head *sh, *tmp;
 	struct list_head *handle_list = NULL;
-	struct r5worker_group *wg = NULL;
+	struct r5worker_group *wg;
+	bool second_try = !r5c_is_writeback(conf->log);
+	bool try_loprio = test_bit(R5C_LOG_TIGHT, &conf->cache_state);
 
+again:
+	wg = NULL;
+	sh = NULL;
 	if (conf->worker_cnt_per_group == 0) {
-		handle_list = &conf->handle_list;
+		handle_list = try_loprio ? &conf->loprio_list :
+					&conf->handle_list;
 	} else if (group != ANY_GROUP) {
-		handle_list = &conf->worker_groups[group].handle_list;
+		handle_list = try_loprio ? &conf->worker_groups[group].loprio_list :
+				&conf->worker_groups[group].handle_list;
 		wg = &conf->worker_groups[group];
 	} else {
 		int i;
 		for (i = 0; i < conf->group_cnt; i++) {
-			handle_list = &conf->worker_groups[i].handle_list;
+			handle_list = try_loprio ? &conf->worker_groups[i].loprio_list :
+				&conf->worker_groups[i].handle_list;
 			wg = &conf->worker_groups[i];
 			if (!list_empty(handle_list))
 				break;
@@ -5232,8 +5255,13 @@ static struct stripe_head *__get_priority_stripe(struct r5conf *conf, int group)
 		wg = NULL;
 	}
 
-	if (!sh)
-		return NULL;
+	if (!sh) {
+		if (second_try)
+			return NULL;
+		second_try = true;
+		try_loprio = !try_loprio;
+		goto again;
+	}
 
 	if (wg) {
 		wg->stripes_cnt--;
@@ -6543,6 +6571,7 @@ static int alloc_thread_groups(struct r5conf *conf, int cnt,
 
 		group = &(*worker_groups)[i];
 		INIT_LIST_HEAD(&group->handle_list);
+		INIT_LIST_HEAD(&group->loprio_list);
 		group->conf = conf;
 		group->workers = workers + i * cnt;
 
@@ -6770,6 +6799,7 @@ static struct r5conf *setup_conf(struct mddev *mddev)
 	init_waitqueue_head(&conf->wait_for_stripe);
 	init_waitqueue_head(&conf->wait_for_overlap);
 	INIT_LIST_HEAD(&conf->handle_list);
+	INIT_LIST_HEAD(&conf->loprio_list);
 	INIT_LIST_HEAD(&conf->hold_list);
 	INIT_LIST_HEAD(&conf->delayed_list);
 	INIT_LIST_HEAD(&conf->bitmap_list);
diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
index 4bb27b9..6b9d2e8 100644
--- a/drivers/md/raid5.h
+++ b/drivers/md/raid5.h
@@ -542,6 +542,7 @@ struct r5worker {
 
 struct r5worker_group {
 	struct list_head handle_list;
+	struct list_head loprio_list;
 	struct r5conf *conf;
 	struct r5worker *workers;
 	int stripes_cnt;
@@ -608,6 +609,7 @@ struct r5conf {
 						  */
 
 	struct list_head	handle_list; /* stripes needing handling */
+	struct list_head	loprio_list; /* low priority stripes */
 	struct list_head	hold_list; /* preread ready stripes */
 	struct list_head	delayed_list; /* stripes that have plugged requests */
 	struct list_head	bitmap_list; /* stripes delaying awaiting bitmap update */
-- 
2.9.3

