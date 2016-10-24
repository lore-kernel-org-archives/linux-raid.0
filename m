From: Zhengyuan Liu <liuzhengyuan@kylinos.cn>
Subject: [PATCH] md/raid5: write an empty meta-block when creating log super-block
Date: Mon, 24 Oct 2016 16:15:59 +0800
Message-ID: <1477296959-20123-1-git-send-email-liuzhengyuan@kylinos.cn>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: shli@kernel.org
Cc: shli@fb.com, songliubraving@fb.com, linux-raid@vger.kernel.org, liuzhengyuang521@gmail.com
List-Id: linux-raid.ids

If superblock points to an invalid meta block, r5l_load_log will set
create_super with true and create an new superblock, this runtime path
would always happen if we do no writing I/O to this array since it was
created. Writing an empty meta block could avoid this unnecessary
action at the first time we created log superblock.

Another reason is for the corretness of log recovery. Currently we have
bellow code to guarantee log revocery to be correct.

        if (ctx.seq > log->last_cp_seq + 1) {
                int ret;

                ret = r5l_log_write_empty_meta_block(log, ctx.pos, ctx.seq + 10);
                if (ret)
                        return ret;
                log->seq = ctx.seq + 11;
                log->log_start = r5l_ring_add(log, ctx.pos, BLOCK_SECTORS);
                r5l_write_super(log, ctx.pos);
        } else {
                log->log_start = ctx.pos;
                log->seq = ctx.seq;
        }

If we just created a array with a journal device, log->log_start and
log->last_checkpoint should all be 0, then we write three meta block
which are valid except mid one and supposed crash happened. The ctx.seq
would equal to log->last_cp_seq + 1 and log->log_start would be set to
position of mid invalid meta block after we did a recovery, this will
lead to problems which could be avoided with this patch.

Signed-off-by: Zhengyuan Liu <liuzhengyuan@kylinos.cn>
---
 drivers/md/raid5-cache.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index 998ea00..981f855 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -1156,6 +1156,7 @@ create:
 	if (create_super) {
 		log->last_cp_seq = prandom_u32();
 		cp = 0;
+		r5l_log_write_empty_meta_block(log, cp, log->last_cp_seq);
 		/*
 		 * Make sure super points to correct address. Log might have
 		 * data very soon. If super hasn't correct log tail address,
-- 
2.7.4



