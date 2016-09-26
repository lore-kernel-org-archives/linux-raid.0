From: Song Liu <songliubraving@fb.com>
Subject: [PATCH v2 6/6] md/r5cache: decrease the counter after full-write stripe was reclaimed
Date: Mon, 26 Sep 2016 16:30:50 -0700
Message-ID: <20160926233050.3351081-7-songliubraving@fb.com>
References: <20160926233050.3351081-1-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20160926233050.3351081-1-songliubraving@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.com, shli@fb.com, kernel-team@fb.com, dan.j.williams@intel.com, hch@infradead.org, liuzhengyuang521@gmail.com, liuzhengyuan@kylinos.cn, Song Liu <songliubraving@fb.com>
List-Id: linux-raid.ids

From: ZhengYuan Liu <liuzhengyuan@kylinos.cn>

Once the data was written to cache device, r5c_handle_cached_data_endio would
be called to set dev->written with null and return the bio to up layer. As a
result, handle_stripe_clean_event has no chance to be called to decrease the
counter of conf->pending_full_writes when the stripe was written to raid disks
at reclaim stage. It should test the STRIPE_FULL_WRITE state and decrease the
counter at somewhere when the full-write stripe was reclaimed,
r5c_handle_stripe_written may be the right place to do that.

Signed-off-by: ZhengYuan Liu <liuzhengyuan@kylinos.cn>
Signed-off-by: Song Liu <songliubraving@fb.com>
---
 drivers/md/raid5-cache.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index a94585d..8a035da 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -2044,6 +2044,10 @@ void r5c_handle_stripe_written(struct r5conf *conf,
 		spin_unlock_irqrestore(&conf->log->stripe_in_cache_lock, flags);
 		sh->log_start = MaxSector;
 		clear_bit(STRIPE_R5C_PRIORITY, &sh->state);
+
+		if (test_and_clear_bit(STRIPE_FULL_WRITE, &sh->state))
+			if (atomic_dec_and_test(&conf->pending_full_writes))
+				md_wakeup_thread(conf->mddev->thread);
 	}
 
 	if (do_wakeup)
-- 
2.9.3

