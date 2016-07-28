From: ZhengYuan Liu <liuzhengyuan@kylinos.cn>
Subject: [PATCH] raid5: fix incorrectly counter of conf->empty_inactive_list_nr
Date: Thu, 28 Jul 2016 14:22:14 +0800
Message-ID: <1469686934-1937-1-git-send-email-liuzhengyuan@kylinos.cn>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.com
Cc: shli@kernel.org, liuzhengyuang521@gmail.com, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, ZhengYuan Liu <liuzhengyuan@kylinos.cn>
List-Id: linux-raid.ids

The counter conf->empty_inactive_list_nr is only used for determine if the
raid5 is congested which is deal with in function raid5_congested().
It was increased in get_free_stripe() when conf->inactive_list got to be
empty and decreased in release_inactive_stripe_list() when splice
temp_inactive_list to conf->inactive_list. However, this may have a
problem when raid5_get_active_stripe or stripe_add_to_batch_list was called,
because these two functions may call list_del_init(&sh->lru) to delete sh from
"conf->inactive_list + hash" which may cause "conf->inactive_list + hash" to
be empty when atomic_inc_not_zero(&sh->count) got false. So a check should be
done at these two point and increase empty_inactive_list_nr accordingly.
Otherwise the counter may get to be negative number which would influence
async readahead from VFS.

Signed-off-by: ZhengYuan Liu <liuzhengyuan@kylinos.cn>
---
 drivers/md/raid5.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 7c53861..1656c44 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -659,6 +659,7 @@ raid5_get_active_stripe(struct r5conf *conf, sector_t sector,
 {
 	struct stripe_head *sh;
 	int hash = stripe_hash_locks_hash(sector);
+	int inc_empty_inactive_list_flag;
 
 	pr_debug("get_stripe, sector %llu\n", (unsigned long long)sector);
 
@@ -703,7 +704,12 @@ raid5_get_active_stripe(struct r5conf *conf, sector_t sector,
 					atomic_inc(&conf->active_stripes);
 				BUG_ON(list_empty(&sh->lru) &&
 				       !test_bit(STRIPE_EXPANDING, &sh->state));
+				inc_empty_inactive_list_flag = 0;
+				if (!list_empty(conf->inactive_list + hash))
+					inc_empty_inactive_list_flag = 1;
 				list_del_init(&sh->lru);
+				if (list_empty(conf->inactive_list + hash) && inc_empty_inactive_list_flag)
+					atomic_inc(&conf->empty_inactive_list_nr);
 				if (sh->group) {
 					sh->group->stripes_cnt--;
 					sh->group = NULL;
@@ -762,6 +768,7 @@ static void stripe_add_to_batch_list(struct r5conf *conf, struct stripe_head *sh
 	sector_t head_sector, tmp_sec;
 	int hash;
 	int dd_idx;
+	int inc_empty_inactive_list_flag;
 
 	if (!stripe_can_batch(sh))
 		return;
@@ -781,7 +788,11 @@ static void stripe_add_to_batch_list(struct r5conf *conf, struct stripe_head *sh
 				atomic_inc(&conf->active_stripes);
 			BUG_ON(list_empty(&head->lru) &&
 			       !test_bit(STRIPE_EXPANDING, &head->state));
+			if (!list_empty(conf->inactive_list + hash))
+				inc_empty_inactive_list_flag = 1;
 			list_del_init(&head->lru);
+			if (list_empty(conf->inactive_list + hash) && inc_empty_inactive_list_flag)
+				atomic_inc(&conf->empty_inactive_list_nr);
 			if (head->group) {
 				head->group->stripes_cnt--;
 				head->group = NULL;
-- 
1.9.1




