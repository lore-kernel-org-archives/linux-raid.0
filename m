From: Zhengyuan Liu <liuzhengyuan@kylinos.cn>
Subject: [PATCH] md/raid5: initialize next_checkpoint field before use
Date: Mon, 24 Oct 2016 09:55:20 +0800
Message-ID: <1477274120-7236-1-git-send-email-liuzhengyuan@kylinos.cn>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: shli@kernel.org
Cc: shli@fb.com, songliubraving@fb.com, linux-raid@vger.kernel.org, liuzhengyuang521@gmail.com, Zhengyuan Liu <liuzhengyuan@kylinos.cn>
List-Id: linux-raid.ids

No initial operation was done to this field when we
load/recovery the log, it got assignment only when IO
to raid disk was finished. So r5l_quiesce may use wrong
next_checkpoint to reclaim log space, that would make
reclaimable space calculation confused.

Signed-off-by: Zhengyuan Liu <liuzhengyuan@kylinos.cn>
---
 drivers/md/raid5-cache.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index 1b1ab4a..998ea00 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -1096,6 +1096,8 @@ static int r5l_recovery_log(struct r5l_log *log)
 		log->seq = ctx.seq + 11;
 		log->log_start = r5l_ring_add(log, ctx.pos, BLOCK_SECTORS);
 		r5l_write_super(log, ctx.pos);
+		log->last_checkpoint = ctx.pos;
+		log->next_checkpoint = ctx.pos;
 	} else {
 		log->log_start = ctx.pos;
 		log->seq = ctx.seq;
@@ -1168,6 +1170,7 @@ create:
 	if (log->max_free_space > RECLAIM_MAX_FREE_SPACE)
 		log->max_free_space = RECLAIM_MAX_FREE_SPACE;
 	log->last_checkpoint = cp;
+	log->next_checkpoint = cp;
 
 	__free_page(page);
 
-- 
2.7.4



