From: Zhengyuan Liu <liuzhengyuan@kylinos.cn>
Subject: [PATCH 2/2] md/r5cache: set journal mode according to log content
Date: Sun,  4 Dec 2016 16:49:45 +0800
Message-ID: <1480841385-21180-2-git-send-email-liuzhengyuan@kylinos.cn>
References: <1480841385-21180-1-git-send-email-liuzhengyuan@kylinos.cn>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1480841385-21180-1-git-send-email-liuzhengyuan@kylinos.cn>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Currently, we choice write-through mode as the default journal mode.
If there is data-only stripes, we'd rewrite it and add it into raid5d
release list. However, raid5d thread wouldn't put those stripes into
cache(full/partial) list but inactive list instead since the journal
mode is write-through. More futher, later read request would get data
from raid disk directly instead of cache stripe, that's not we want too.

Signed-off-by: Zhengyuan Liu <liuzhengyuan@kylinos.cn>
---
 drivers/md/raid5-cache.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index 07bce0e..0473b33 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -2606,7 +2606,6 @@ int r5l_init_log(struct r5conf *conf, struct md_rdev *rdev)
 
 	INIT_WORK(&log->deferred_io_work, r5l_submit_io_async);
 
-	log->r5c_journal_mode = R5C_JOURNAL_MODE_WRITE_THROUGH;
 	INIT_LIST_HEAD(&log->stripe_in_journal_list);
 	spin_lock_init(&log->stripe_in_journal_lock);
 	atomic_set(&log->stripe_in_journal_count, 0);
@@ -2614,6 +2613,11 @@ int r5l_init_log(struct r5conf *conf, struct md_rdev *rdev)
 	if (r5l_load_log(log))
 		goto error;
 
+	if (log->last_checkpoint == log->next_checkpoint)
+		log->r5c_journal_mode = R5C_JOURNAL_MODE_WRITE_THROUGH;
+	else
+		log->r5c_journal_mode = R5C_JOURNAL_MODE_WRITE_BACK;
+
 	rcu_assign_pointer(conf->log, log);
 	set_bit(MD_HAS_JOURNAL, &conf->mddev->flags);
 	return 0;
-- 
2.7.4



