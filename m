From: Yuanhan Liu <yuanhan.liu@linux.intel.com>
Subject: [PATCH 1/2] md/raid5: avoid duplicate code
Date: Wed,  6 May 2015 17:45:49 +0800
Message-ID: <1430905550-6142-1-git-send-email-yuanhan.liu@linux.intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, Yuanhan Liu <yuanhan.liu@linux.intel.com>
List-Id: linux-raid.ids

Move the code that put one idle sh(hot in cache, but happens to be
zero referenced) back to active stage to __find_stripe(). Because
that's what need to do every time you invoke __find_stripe().

Moving it there avoids duplicate code, as well as makes a bit more
sense, IMO, as it tells a whole story now.

Signed-off-by: Yuanhan Liu <yuanhan.liu@linux.intel.com>
---
 drivers/md/raid5.c | 50 ++++++++++++++++++--------------------------------
 1 file changed, 18 insertions(+), 32 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 77dfd72..e7fa818 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -567,8 +567,25 @@ static struct stripe_head *__find_stripe(struct r5conf *conf, sector_t sector,
 
 	pr_debug("__find_stripe, sector %llu\n", (unsigned long long)sector);
 	hlist_for_each_entry(sh, stripe_hash(conf, sector), hash)
-		if (sh->sector == sector && sh->generation == generation)
+		if (sh->sector == sector && sh->generation == generation) {
+			if (!atomic_inc_not_zero(&sh->count)) {
+				spin_lock(&conf->device_lock);
+				if (!atomic_read(&sh->count)) {
+					if (!test_bit(STRIPE_HANDLE, &sh->state))
+						atomic_inc(&conf->active_stripes);
+					BUG_ON(list_empty(&sh->lru) &&
+					       !test_bit(STRIPE_EXPANDING, &sh->state));
+					list_del_init(&sh->lru);
+					if (sh->group) {
+						sh->group->stripes_cnt--;
+						sh->group = NULL;
+					}
+				}
+				atomic_inc(&sh->count);
+				spin_unlock(&conf->device_lock);
+			}
 			return sh;
+		}
 	pr_debug("__stripe %llu not in cache\n", (unsigned long long)sector);
 	return NULL;
 }
@@ -698,21 +715,6 @@ get_active_stripe(struct r5conf *conf, sector_t sector,
 				init_stripe(sh, sector, previous);
 				atomic_inc(&sh->count);
 			}
-		} else if (!atomic_inc_not_zero(&sh->count)) {
-			spin_lock(&conf->device_lock);
-			if (!atomic_read(&sh->count)) {
-				if (!test_bit(STRIPE_HANDLE, &sh->state))
-					atomic_inc(&conf->active_stripes);
-				BUG_ON(list_empty(&sh->lru) &&
-				       !test_bit(STRIPE_EXPANDING, &sh->state));
-				list_del_init(&sh->lru);
-				if (sh->group) {
-					sh->group->stripes_cnt--;
-					sh->group = NULL;
-				}
-			}
-			atomic_inc(&sh->count);
-			spin_unlock(&conf->device_lock);
 		}
 	} while (sh == NULL);
 
@@ -771,22 +773,6 @@ static void stripe_add_to_batch_list(struct r5conf *conf, struct stripe_head *sh
 	hash = stripe_hash_locks_hash(head_sector);
 	spin_lock_irq(conf->hash_locks + hash);
 	head = __find_stripe(conf, head_sector, conf->generation);
-	if (head && !atomic_inc_not_zero(&head->count)) {
-		spin_lock(&conf->device_lock);
-		if (!atomic_read(&head->count)) {
-			if (!test_bit(STRIPE_HANDLE, &head->state))
-				atomic_inc(&conf->active_stripes);
-			BUG_ON(list_empty(&head->lru) &&
-			       !test_bit(STRIPE_EXPANDING, &head->state));
-			list_del_init(&head->lru);
-			if (head->group) {
-				head->group->stripes_cnt--;
-				head->group = NULL;
-			}
-		}
-		atomic_inc(&head->count);
-		spin_unlock(&conf->device_lock);
-	}
 	spin_unlock_irq(conf->hash_locks + hash);
 
 	if (!head)
-- 
1.9.0
