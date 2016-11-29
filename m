From: JackieLiu <liuyun01@kylinos.cn>
Subject: [PATCH] md/raid5-cache: remove the unnecessary next_cp_seq field from the r5l_log
Date: Tue, 29 Nov 2016 11:13:20 +0800
Message-ID: <20161129031320.9025-1-liuyun01@kylinos.cn>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: shli@fb.com
Cc: songliubraving@fb.com, liuzhengyuan@kylinos.cn, linux-raid@vger.kernel.org, JackieLiu <liuyun01@kylinos.cn>
List-Id: linux-raid.ids

The next_cp_seq field is useless, remove it.

Signed-off-by: JackieLiu <liuyun01@kylinos.cn>
---
 drivers/md/raid5-cache.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index 5f817bd..95bd51e 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -113,7 +113,6 @@ struct r5l_log {
 	u64 seq;			/* log head sequence */
 
 	sector_t next_checkpoint;
-	u64 next_cp_seq;
 
 	struct mutex io_mutex;
 	struct r5l_io_unit *current_io;	/* current io_unit accepting new data */
@@ -1075,7 +1074,6 @@ static bool r5l_complete_finished_ios(struct r5l_log *log)
 			break;
 
 		log->next_checkpoint = io->log_start;
-		log->next_cp_seq = io->seq;
 
 		list_del(&io->log_sibling);
 		mempool_free(io, log->io_pool);
-- 
2.10.2



