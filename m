From: JackieLiu <liuyun01@kylinos.cn>
Subject: [PATCH] md/raid5: use bool instead of int for some flags
Date: Tue, 27 Sep 2016 09:40:20 +0800
Message-ID: <20160927014020.7209-1-liuyun01@kylinos.cn>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: shli@fb.com
Cc: linux-raid@vger.kernel.org, JackieLiu <liuyun01@kylinos.cn>
List-Id: linux-raid.ids

For flags, bool is a little better more or less than int.

Signed-off-by: JackieLiu <liuyun01@kylinos.cn>
---
 drivers/md/raid5.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index ee7fc37..2861c3f 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -659,7 +659,7 @@ raid5_get_active_stripe(struct r5conf *conf, sector_t sector,
 {
 	struct stripe_head *sh;
 	int hash = stripe_hash_locks_hash(sector);
-	int inc_empty_inactive_list_flag;
+	bool inc_empty_inactive_list_flag;
 
 	pr_debug("get_stripe, sector %llu\n", (unsigned long long)sector);
 
@@ -704,9 +704,9 @@ raid5_get_active_stripe(struct r5conf *conf, sector_t sector,
 					atomic_inc(&conf->active_stripes);
 				BUG_ON(list_empty(&sh->lru) &&
 				       !test_bit(STRIPE_EXPANDING, &sh->state));
-				inc_empty_inactive_list_flag = 0;
+				inc_empty_inactive_list_flag = false;
 				if (!list_empty(conf->inactive_list + hash))
-					inc_empty_inactive_list_flag = 1;
+					inc_empty_inactive_list_flag = true;
 				list_del_init(&sh->lru);
 				if (list_empty(conf->inactive_list + hash) && inc_empty_inactive_list_flag)
 					atomic_inc(&conf->empty_inactive_list_nr);
@@ -768,7 +768,7 @@ static void stripe_add_to_batch_list(struct r5conf *conf, struct stripe_head *sh
 	sector_t head_sector, tmp_sec;
 	int hash;
 	int dd_idx;
-	int inc_empty_inactive_list_flag;
+	bool inc_empty_inactive_list_flag;
 
 	/* Don't cross chunks, so stripe pd_idx/qd_idx is the same */
 	tmp_sec = sh->sector;
@@ -786,9 +786,9 @@ static void stripe_add_to_batch_list(struct r5conf *conf, struct stripe_head *sh
 				atomic_inc(&conf->active_stripes);
 			BUG_ON(list_empty(&head->lru) &&
 			       !test_bit(STRIPE_EXPANDING, &head->state));
-			inc_empty_inactive_list_flag = 0;
+			inc_empty_inactive_list_flag = false;
 			if (!list_empty(conf->inactive_list + hash))
-				inc_empty_inactive_list_flag = 1;
+				inc_empty_inactive_list_flag = true;
 			list_del_init(&head->lru);
 			if (list_empty(conf->inactive_list + hash) && inc_empty_inactive_list_flag)
 				atomic_inc(&conf->empty_inactive_list_nr);
@@ -905,7 +905,7 @@ static void ops_run_io(struct stripe_head *sh, struct stripe_head_state *s)
 		return;
 	for (i = disks; i--; ) {
 		int op, op_flags = 0;
-		int replace_only = 0;
+		bool replace_only = false;
 		struct bio *bi, *rbi;
 		struct md_rdev *rdev, *rrdev = NULL;
 
@@ -921,7 +921,7 @@ static void ops_run_io(struct stripe_head *sh, struct stripe_head_state *s)
 		else if (test_and_clear_bit(R5_WantReplace,
 					    &sh->dev[i].flags)) {
 			op = REQ_OP_WRITE;
-			replace_only = 1;
+			replace_only = true;
 		} else
 			continue;
 		if (test_and_clear_bit(R5_SyncIO, &sh->dev[i].flags))
-- 
2.10.0



