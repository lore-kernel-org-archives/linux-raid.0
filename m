From: JackieLiu <liuyun01@kylinos.cn>
Subject: [PATCH] Restrict the use area of the log_offset variable
Date: Wed,  2 Nov 2016 17:02:39 +0800
Message-ID: <20161102090239.11137-1-liuyun01@kylinos.cn>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: shli@fb.com
Cc: liuzhengyuan@kylinos.cn, linux-raid@vger.kernel.org, JackieLiu <liuyun01@kylinos.cn>
List-Id: linux-raid.ids

We can calculate this offset by using ctx->meta_total_blocks,
without passing in from the function

Signed-off-by: JackieLiu <liuyun01@kylinos.cn>
---
 drivers/md/raid5-cache.c | 19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index 1b1ab4a..03267c3 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -895,7 +895,7 @@ static int r5l_read_meta_block(struct r5l_log *log,
 static int r5l_recovery_flush_one_stripe(struct r5l_log *log,
 					 struct r5l_recovery_ctx *ctx,
 					 sector_t stripe_sect,
-					 int *offset, sector_t *log_offset)
+					 int *offset)
 {
 	struct r5conf *conf = log->rdev->mddev->private;
 	struct stripe_head *sh;
@@ -904,6 +904,8 @@ static int r5l_recovery_flush_one_stripe(struct r5l_log *log,
 
 	sh = raid5_get_active_stripe(conf, stripe_sect, 0, 0, 0);
 	while (1) {
+		sector_t log_offset = r5l_ring_add(log, ctx->pos,
+				ctx->meta_total_blocks);
 		payload = page_address(ctx->meta_page) + *offset;
 
 		if (le16_to_cpu(payload->header.type) == R5LOG_PAYLOAD_DATA) {
@@ -911,16 +913,15 @@ static int r5l_recovery_flush_one_stripe(struct r5l_log *log,
 					     le64_to_cpu(payload->location), 0,
 					     &disk_index, sh);
 
-			sync_page_io(log->rdev, *log_offset, PAGE_SIZE,
+			sync_page_io(log->rdev, log_offset, PAGE_SIZE,
 				     sh->dev[disk_index].page, REQ_OP_READ, 0,
 				     false);
 			sh->dev[disk_index].log_checksum =
 				le32_to_cpu(payload->checksum[0]);
 			set_bit(R5_Wantwrite, &sh->dev[disk_index].flags);
-			ctx->meta_total_blocks += BLOCK_SECTORS;
 		} else {
 			disk_index = sh->pd_idx;
-			sync_page_io(log->rdev, *log_offset, PAGE_SIZE,
+			sync_page_io(log->rdev, log_offset, PAGE_SIZE,
 				     sh->dev[disk_index].page, REQ_OP_READ, 0,
 				     false);
 			sh->dev[disk_index].log_checksum =
@@ -930,7 +931,7 @@ static int r5l_recovery_flush_one_stripe(struct r5l_log *log,
 			if (sh->qd_idx >= 0) {
 				disk_index = sh->qd_idx;
 				sync_page_io(log->rdev,
-					     r5l_ring_add(log, *log_offset, BLOCK_SECTORS),
+					     r5l_ring_add(log, log_offset, BLOCK_SECTORS),
 					     PAGE_SIZE, sh->dev[disk_index].page,
 					     REQ_OP_READ, 0, false);
 				sh->dev[disk_index].log_checksum =
@@ -938,11 +939,9 @@ static int r5l_recovery_flush_one_stripe(struct r5l_log *log,
 				set_bit(R5_Wantwrite,
 					&sh->dev[disk_index].flags);
 			}
-			ctx->meta_total_blocks += BLOCK_SECTORS * conf->max_degraded;
 		}
 
-		*log_offset = r5l_ring_add(log, *log_offset,
-					   le32_to_cpu(payload->size));
+		ctx->meta_total_blocks += le32_to_cpu(payload->size);
 		*offset += sizeof(struct r5l_payload_data_parity) +
 			sizeof(__le32) *
 			(le32_to_cpu(payload->size) >> (PAGE_SHIFT - 9));
@@ -999,12 +998,10 @@ static int r5l_recovery_flush_one_meta(struct r5l_log *log,
 	struct r5l_payload_data_parity *payload;
 	struct r5l_meta_block *mb;
 	int offset;
-	sector_t log_offset;
 	sector_t stripe_sector;
 
 	mb = page_address(ctx->meta_page);
 	offset = sizeof(struct r5l_meta_block);
-	log_offset = r5l_ring_add(log, ctx->pos, BLOCK_SECTORS);
 
 	while (offset < le32_to_cpu(mb->meta_size)) {
 		int dd;
@@ -1013,7 +1010,7 @@ static int r5l_recovery_flush_one_meta(struct r5l_log *log,
 		stripe_sector = raid5_compute_sector(conf,
 						     le64_to_cpu(payload->location), 0, &dd, NULL);
 		if (r5l_recovery_flush_one_stripe(log, ctx, stripe_sector,
-						  &offset, &log_offset))
+						  &offset))
 			return -EINVAL;
 	}
 	return 0;
-- 
2.10.2



