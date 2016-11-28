From: JackieLiu <liuyun01@kylinos.cn>
Subject: [PATCH 2/4] md/raid5-cache: use ring add to prevent overflow
Date: Mon, 28 Nov 2016 16:19:19 +0800
Message-ID: <20161128081921.5641-2-liuyun01@kylinos.cn>
References: <20161128081921.5641-1-liuyun01@kylinos.cn>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20161128081921.5641-1-liuyun01@kylinos.cn>
Sender: linux-raid-owner@vger.kernel.org
To: songliubraving@fb.com
Cc: liuzhengyuan@kylinos.cn, linux-raid@vger.kernel.org, JackieLiu <liuyun01@kylinos.cn>
List-Id: linux-raid.ids

'write_pos' must be protected with 'r5l_ring_add', or it may overflow

Signed-off-by: JackieLiu <liuyun01@kylinos.cn>
---
 drivers/md/raid5-cache.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index 576c88d..6d2b1da 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -2086,7 +2086,7 @@ r5c_recovery_rewrite_data_only_stripes(struct r5l_log *log,
 						     ctx->pos, ctx->seq);
 		mb = page_address(page);
 		offset = le32_to_cpu(mb->meta_size);
-		write_pos = ctx->pos + BLOCK_SECTORS;
+		write_pos = r5l_ring_add(log, ctx->pos, BLOCK_SECTORS);
 
 		for (i = sh->disks; i--; ) {
 			struct r5dev *dev = &sh->dev[i];
-- 
2.7.4



