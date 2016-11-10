From: Song Liu <songliubraving@fb.com>
Subject: [PATCH v6 07/11] md/r5cache: refactoring journal recovery code
Date: Thu, 10 Nov 2016 12:46:19 -0800
Message-ID: <20161110204623.3484694-8-songliubraving@fb.com>
References: <20161110204623.3484694-1-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20161110204623.3484694-1-songliubraving@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.com, shli@fb.com, kernel-team@fb.com, dan.j.williams@intel.com, hch@infradead.org, liuzhengyuang521@gmail.com, liuzhengyuan@kylinos.cn, Song Liu <songliubraving@fb.com>
List-Id: linux-raid.ids

1. rename r5l_read_meta_block() as r5l_recovery_read_meta_block();
2. pull the code that initialize r5l_meta_block from
   r5l_log_write_empty_meta_block() to a separate function
   r5l_recovery_create_empty_meta_block(), so that we can reuse this
   piece of code.

Signed-off-by: Song Liu <songliubraving@fb.com>
---
 drivers/md/raid5-cache.c | 27 ++++++++++++++++++---------
 1 file changed, 18 insertions(+), 9 deletions(-)

diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index d2acb69..1058e81 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -1353,8 +1353,8 @@ struct r5l_recovery_ctx {
 	u64 seq;			/* recovery position seq */
 };
 
-static int r5l_read_meta_block(struct r5l_log *log,
-			       struct r5l_recovery_ctx *ctx)
+static int r5l_recovery_read_meta_block(struct r5l_log *log,
+					struct r5l_recovery_ctx *ctx)
 {
 	struct page *page = ctx->meta_page;
 	struct r5l_meta_block *mb;
@@ -1515,7 +1515,7 @@ static void r5l_recovery_flush_log(struct r5l_log *log,
 				   struct r5l_recovery_ctx *ctx)
 {
 	while (1) {
-		if (r5l_read_meta_block(log, ctx))
+		if (r5l_recovery_read_meta_block(log, ctx))
 			return;
 		if (r5l_recovery_flush_one_meta(log, ctx))
 			return;
@@ -1524,17 +1524,16 @@ static void r5l_recovery_flush_log(struct r5l_log *log,
 	}
 }
 
-static int r5l_log_write_empty_meta_block(struct r5l_log *log, sector_t pos,
-					  u64 seq)
+static void
+r5l_recovery_create_empty_meta_block(struct r5l_log *log,
+				     struct page *page,
+				     sector_t pos, u64 seq)
 {
-	struct page *page;
 	struct r5l_meta_block *mb;
 	u32 crc;
 
-	page = alloc_page(GFP_KERNEL | __GFP_ZERO);
-	if (!page)
-		return -ENOMEM;
 	mb = page_address(page);
+	clear_page(mb);
 	mb->magic = cpu_to_le32(R5LOG_MAGIC);
 	mb->version = R5LOG_VERSION;
 	mb->meta_size = cpu_to_le32(sizeof(struct r5l_meta_block));
@@ -1542,7 +1541,17 @@ static int r5l_log_write_empty_meta_block(struct r5l_log *log, sector_t pos,
 	mb->position = cpu_to_le64(pos);
 	crc = crc32c_le(log->uuid_checksum, mb, PAGE_SIZE);
 	mb->checksum = cpu_to_le32(crc);
+}
 
+static int r5l_log_write_empty_meta_block(struct r5l_log *log, sector_t pos,
+					  u64 seq)
+{
+	struct page *page;
+
+	page = alloc_page(GFP_KERNEL);
+	if (!page)
+		return -ENOMEM;
+	r5l_recovery_create_empty_meta_block(log, page, pos, seq);
 	if (!sync_page_io(log->rdev, pos, PAGE_SIZE, page, REQ_OP_WRITE,
 			  WRITE_FUA, false)) {
 		__free_page(page);
-- 
2.9.3

