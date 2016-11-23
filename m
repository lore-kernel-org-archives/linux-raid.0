From: Song Liu <songliubraving@fb.com>
Subject: [PATCH] md/r5cache: run_no_space_stripes() when R5C_LOG_CRITICAL == 0
Date: Wed, 23 Nov 2016 12:17:45 -0800
Message-ID: <20161123201745.972168-1-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.com, shli@fb.com, kernel-team@fb.com, dan.j.williams@intel.com, hch@infradead.org, liuzhengyuang521@gmail.com, liuzhengyuan@kylinos.cn, Song Liu <songliubraving@fb.com>
List-Id: linux-raid.ids

With writeback cache, we define log space critical as

   free_space < 2 * reclaim_required_space

So the deassert of R5C_LOG_CRITICAL could happen when
  1. free_space increases
  2. reclaim_required_space decreases

Currently, run_no_space_stripes() is called when 1 happens, but
not (always) when 2 happens.

With this patch, run_no_space_stripes() is call when
R5C_LOG_CRITICAL is cleared.

Signed-off-by: Song Liu <songliubraving@fb.com>
---
 drivers/md/raid5-cache.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index 8cb79fc..0e24aab 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -370,6 +370,7 @@ static inline void r5c_update_log_state(struct r5l_log *log)
 	struct r5conf *conf = log->rdev->mddev->private;
 	sector_t free_space;
 	sector_t reclaim_space;
+	bool wake_reclaim = false;
 
 	if (!r5c_is_writeback(log))
 		return;
@@ -379,12 +380,18 @@ static inline void r5c_update_log_state(struct r5l_log *log)
 	reclaim_space = r5c_log_required_to_flush_cache(conf);
 	if (free_space < 2 * reclaim_space)
 		set_bit(R5C_LOG_CRITICAL, &conf->cache_state);
-	else
+	else {
+		if (test_bit(R5C_LOG_CRITICAL, &conf->cache_state))
+			wake_reclaim = true;
 		clear_bit(R5C_LOG_CRITICAL, &conf->cache_state);
+	}
 	if (free_space < 3 * reclaim_space)
 		set_bit(R5C_LOG_TIGHT, &conf->cache_state);
 	else
 		clear_bit(R5C_LOG_TIGHT, &conf->cache_state);
+
+	if (wake_reclaim)
+		r5l_wake_reclaim(log, 0);
 }
 
 /*
@@ -1348,6 +1355,10 @@ static void r5c_do_reclaim(struct r5conf *conf)
 		spin_unlock(&conf->device_lock);
 		spin_unlock_irqrestore(&log->stripe_in_journal_lock, flags);
 	}
+
+	if (!test_bit(R5C_LOG_CRITICAL, &conf->cache_state))
+		r5l_run_no_space_stripes(log);
+
 	md_wakeup_thread(conf->mddev->thread);
 }
 
-- 
2.9.3

