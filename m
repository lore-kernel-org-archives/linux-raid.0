From: JackieLiu <liuyun01@kylinos.cn>
Subject: [PATCH] md/raid5-cache: removes unnecessary write-through mode judgments
Date: Tue, 13 Dec 2016 13:55:27 +0800
Message-ID: <20161213055527.3306-1-liuyun01@kylinos.cn>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: songliubraving@fb.com
Cc: shli@kernel.org, linux-raid@vger.kernel.org, JackieLiu <liuyun01@kylinos.cn>
List-Id: linux-raid.ids

The write-through mode has been returned in front of the function,
do not need to do it again.

Signed-off-by: JackieLiu <liuyun01@kylinos.cn>
---
 drivers/md/raid5-cache.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index 6d1a150..4dd8e4e 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -2418,9 +2418,6 @@ void r5c_finish_stripe_write_out(struct r5conf *conf,
 	if (do_wakeup)
 		wake_up(&conf->wait_for_overlap);
 
-	if (conf->log->r5c_journal_mode == R5C_JOURNAL_MODE_WRITE_THROUGH)
-		return;
-
 	spin_lock_irq(&conf->log->stripe_in_journal_lock);
 	list_del_init(&sh->r5c);
 	spin_unlock_irq(&conf->log->stripe_in_journal_lock);
-- 
2.10.2



