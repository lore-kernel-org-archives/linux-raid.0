From: Shaohua Li <shli@fb.com>
Subject: [PATCH 4/4] raid5: fix wakeup condition
Date: Thu, 28 May 2015 17:33:48 -0700
Message-ID: <de048e4f0889e59ffb452f8b5f704bd888fcc1c1.1432859513.git.shli@fb.com>
References: <a92a0c36813c740c5de65a95b75ef161c1f2ede1.1432859513.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <a92a0c36813c740c5de65a95b75ef161c1f2ede1.1432859513.git.shli@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.de
List-Id: linux-raid.ids

Since we have several stripe hash list, the conf->active_stripes doesn't
determine if there is free stripe in a specific hash list, so delete the
check. After this, the R5_INACTIVE_BLOCKED check is inappropriate. There
is no point not to wakeup a task if there is free stripe.

Signed-off-by: Shaohua Li <shli@fb.com>
---
 drivers/md/raid5.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 67626f3..4b5a03c 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -687,11 +687,7 @@ get_active_stripe(struct r5conf *conf, sector_t sector,
 					&conf->cache_state);
 				wait_event_lock_irq(
 					conf->wait_for_stripe,
-					!list_empty(conf->inactive_list + hash) &&
-					(atomic_read(&conf->active_stripes)
-					 < (conf->max_nr_stripes * 3 / 4)
-					 || !test_bit(R5_INACTIVE_BLOCKED,
-						      &conf->cache_state)),
+					!list_empty(conf->inactive_list + hash),
 					*(conf->hash_locks + hash));
 				clear_bit(R5_INACTIVE_BLOCKED,
 					  &conf->cache_state);
-- 
1.8.1

