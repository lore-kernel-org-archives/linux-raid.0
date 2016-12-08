From: JackieLiu <liuyun01@kylinos.cn>
Subject: [PATCH] md/raid5-cache: no recovery is required when create super-block
Date: Thu,  8 Dec 2016 08:47:39 +0800
Message-ID: <20161208004739.2889-1-liuyun01@kylinos.cn>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: shli@fb.com
Cc: songliubraving@fb.com, liuzhengyuan@kylinos.cn, linux-raid@vger.kernel.org, JackieLiu <liuyun01@kylinos.cn>
List-Id: linux-raid.ids

When create the super-block information, We do not need to do this
recovery stage, only need to initialize some variables.

Signed-off-by: JackieLiu <liuyun01@kylinos.cn>
---
 drivers/md/raid5-cache.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index c3b3124..7c732c5 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -2492,7 +2492,7 @@ static int r5l_load_log(struct r5l_log *log)
 	sector_t cp = log->rdev->journal_tail;
 	u32 stored_crc, expected_crc;
 	bool create_super = false;
-	int ret;
+	int ret = 0;
 
 	/* Make sure it's valid */
 	if (cp >= rdev->sectors || round_down(cp, BLOCK_SECTORS) != cp)
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



