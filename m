From: Song Liu <songliubraving@fb.com>
Subject: [PATCH 2/6] md/r5cache: assign conf->log before r5l_load_log()
Date: Wed, 14 Dec 2016 15:38:02 -0800
Message-ID: <20161214233806.4137850-2-songliubraving@fb.com>
References: <20161214233806.4137850-1-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20161214233806.4137850-1-songliubraving@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.com, shli@fb.com, kernel-team@fb.com, dan.j.williams@intel.com, hch@infradead.org, liuzhengyuan@kylinos.cn, liuyun01@kylinos.cn, Song Liu <songliubraving@fb.com>
List-Id: linux-raid.ids

r5l_load_log() calls functions that requires a proper conf->log,
for example, r5c_is_writeback(). Therefore, we should set
conf->log before calling r5l_load_log(). If r5l_load_log() fails,
conf->log is set back to NULL.

Signed-off-by: Song Liu <songliubraving@fb.com>
---
 drivers/md/raid5-cache.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index 0f5e6a2..b4f2b82 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -2636,14 +2636,16 @@ int r5l_init_log(struct r5conf *conf, struct md_rdev *rdev)
 	spin_lock_init(&log->stripe_in_journal_lock);
 	atomic_set(&log->stripe_in_journal_count, 0);
 
+	rcu_assign_pointer(conf->log, log);
+
 	if (r5l_load_log(log))
 		goto error;
 
-	rcu_assign_pointer(conf->log, log);
 	set_bit(MD_HAS_JOURNAL, &conf->mddev->flags);
 	return 0;
 
 error:
+	rcu_assign_pointer(conf->log, NULL);
 	md_unregister_thread(&log->reclaim_thread);
 reclaim_thread:
 	mempool_destroy(log->meta_pool);
-- 
2.9.3

