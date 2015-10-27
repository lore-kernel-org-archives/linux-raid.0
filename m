From: Shaohua Li <shli@fb.com>
Subject: [PATCH] raid5-cache: use crc32c checksum
Date: Tue, 27 Oct 2015 16:48:20 -0700
Message-ID: <05c660271fe0d5f42bc053ef89c5e20ff57cf955.1445989535.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Kernel-team@fb.com, songliubraving@fb.com, hch@infradead.org, bart.vanassche@sandisk.com, neilb@suse.de
List-Id: linux-raid.ids

crc32c has lower overhead with cpu acceleration. It's a shame I didn't
use it in first post, sorry. This changes disk format, but we are still
ok in current stage.

Signed-off-by: Shaohua Li <shli@fb.com>
---
 drivers/md/raid5-cache.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index 0c398ad..e61f4de 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -16,7 +16,7 @@
 #include <linux/blkdev.h>
 #include <linux/slab.h>
 #include <linux/raid/md_p.h>
-#include <linux/crc32.h>
+#include <linux/crc32c.h>
 #include <linux/random.h>
 #include "md.h"
 #include "raid5.h"
@@ -242,7 +242,7 @@ static void r5l_submit_current_io(struct r5l_log *log)
 
 	block = page_address(io->meta_page);
 	block->meta_size = cpu_to_le32(io->meta_offset);
-	crc = crc32_le(log->uuid_checksum, (void *)block, PAGE_SIZE);
+	crc = crc32c_le(log->uuid_checksum, (void *)block, PAGE_SIZE);
 	block->checksum = cpu_to_le32(crc);
 
 	log->current_io = NULL;
@@ -448,7 +448,7 @@ int r5l_write_stripe(struct r5l_log *log, struct stripe_head *sh)
 		if (test_bit(STRIPE_LOG_TRAPPED, &sh->state))
 			continue;
 		addr = kmap_atomic(sh->dev[i].page);
-		sh->dev[i].log_checksum = crc32_le(log->uuid_checksum,
+		sh->dev[i].log_checksum = crc32c_le(log->uuid_checksum,
 						   addr, PAGE_SIZE);
 		kunmap_atomic(addr);
 	}
@@ -839,7 +839,7 @@ static int r5l_read_meta_block(struct r5l_log *log,
 	    le64_to_cpu(mb->position) != ctx->pos)
 		return -EINVAL;
 
-	crc = crc32_le(log->uuid_checksum, (void *)mb, PAGE_SIZE);
+	crc = crc32c_le(log->uuid_checksum, (void *)mb, PAGE_SIZE);
 	if (stored_crc != crc)
 		return -EINVAL;
 
@@ -914,7 +914,7 @@ static int r5l_recovery_flush_one_stripe(struct r5l_log *log,
 		if (!test_bit(R5_Wantwrite, &sh->dev[disk_index].flags))
 			continue;
 		addr = kmap_atomic(sh->dev[disk_index].page);
-		checksum = crc32_le(log->uuid_checksum, addr, PAGE_SIZE);
+		checksum = crc32c_le(log->uuid_checksum, addr, PAGE_SIZE);
 		kunmap_atomic(addr);
 		if (checksum != sh->dev[disk_index].log_checksum)
 			goto error;
@@ -1004,7 +1004,7 @@ static int r5l_log_write_empty_meta_block(struct r5l_log *log, sector_t pos,
 	mb->meta_size = cpu_to_le32(sizeof(struct r5l_meta_block));
 	mb->seq = cpu_to_le64(seq);
 	mb->position = cpu_to_le64(pos);
-	crc = crc32_le(log->uuid_checksum, (void *)mb, PAGE_SIZE);
+	crc = crc32c_le(log->uuid_checksum, (void *)mb, PAGE_SIZE);
 	mb->checksum = cpu_to_le32(crc);
 
 	if (!sync_page_io(log->rdev, pos, PAGE_SIZE, page, WRITE_FUA, false)) {
@@ -1095,7 +1095,7 @@ static int r5l_load_log(struct r5l_log *log)
 	}
 	stored_crc = le32_to_cpu(mb->checksum);
 	mb->checksum = 0;
-	expected_crc = crc32_le(log->uuid_checksum, (void *)mb, PAGE_SIZE);
+	expected_crc = crc32c_le(log->uuid_checksum, (void *)mb, PAGE_SIZE);
 	if (stored_crc != expected_crc) {
 		create_super = true;
 		goto create;
@@ -1144,7 +1144,7 @@ int r5l_init_log(struct r5conf *conf, struct md_rdev *rdev)
 
 	log->need_cache_flush = (rdev->bdev->bd_disk->queue->flush_flags != 0);
 
-	log->uuid_checksum = crc32_le(~0, (void *)rdev->mddev->uuid,
+	log->uuid_checksum = crc32c_le(~0, (void *)rdev->mddev->uuid,
 				      sizeof(rdev->mddev->uuid));
 
 	mutex_init(&log->io_mutex);
-- 
2.4.6

