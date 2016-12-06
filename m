From: JackieLiu <liuyun01@kylinos.cn>
Subject: [PATCH] md/raid5-cache: no recovery is required when create super-block
Date: Tue,  6 Dec 2016 14:13:17 +0800
Message-ID: <20161206061317.4388-1-liuyun01@kylinos.cn>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: songliubraving@fb.com
Cc: liuzhengyuan@kylinos.cn, shli@fb.com, linux-raid@vger.kernel.org, JackieLiu <liuyun01@kylinos.cn>
List-Id: linux-raid.ids

When create the super-block information, We do not need to do this
recovery stage, only need to initialize some variables.
---
 drivers/md/raid5-cache.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index c3b3124..96f25df 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -2545,7 +2545,13 @@ static int r5l_load_log(struct r5l_log *log)
 
 	__free_page(page);
 
-	ret = r5l_recovery_log(log);
+	if (create_super) {
+		log->log_start = r5l_ring_add(log, cp, BLOCK_SECTORS);
+		log->seq = log->last_cp_seq + 1;
+		log->next_checkpoint = cp;
+	} else
+		ret = r5l_recovery_log(log);
+
 	r5c_update_log_state(log);
 	return ret;
 ioerr:
-- 
2.10.2



