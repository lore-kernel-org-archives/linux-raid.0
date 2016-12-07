From: Song Liu <songliubraving@fb.com>
Subject: [PATCH 1/3] md/raid5-cache: fix crc in rewrite_data_only_stripes()
Date: Wed, 7 Dec 2016 09:42:05 -0800
Message-ID: <20161207174207.3685260-1-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.com, shli@fb.com, kernel-team@fb.com, dan.j.williams@intel.com, hch@infradead.org, liuzhengyuan@kylinos.cn, liuyun01@kylinos.cn, Song Liu <songliubraving@fb.com>
List-Id: linux-raid.ids

r5l_recovery_create_empty_meta_block() creates crc for the empty
metablock. After the metablock is updated, we need clear the
checksum before recalculate it.

Signed-off-by: Song Liu <songliubraving@fb.com>
---
 drivers/md/raid5-cache.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index c3b3124..875f963 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -2117,7 +2117,9 @@ r5c_recovery_rewrite_data_only_stripes(struct r5l_log *log,
 			}
 		}
 		mb->meta_size = cpu_to_le32(offset);
-		mb->checksum = crc32c_le(log->uuid_checksum, mb, PAGE_SIZE);
+		mb->checksum = 0;
+		mb->checksum = cpu_to_le32(crc32c_le(log->uuid_checksum,
+						     mb, PAGE_SIZE));
 		sync_page_io(log->rdev, ctx->pos, PAGE_SIZE, page,
 			     REQ_OP_WRITE, WRITE_FUA, false);
 		sh->log_start = ctx->pos;
-- 
2.9.3

