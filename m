From: Song Liu <songliubraving@fb.com>
Subject: [PATCH 1/2] md/r5cache: handle R5LOG_PAYLOAD_FLUSH in recovery
Date: Tue, 7 Mar 2017 17:44:21 -0800
Message-ID: <20170308014422.4019149-1-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: shli@fb.com, neilb@suse.com, kernel-team@fb.com, dan.j.williams@intel.com, hch@infradead.org, Song Liu <songliubraving@fb.com>
List-Id: linux-raid.ids

This patch adds handling of R5LOG_PAYLOAD_FLUSH in journal recovery.
Next patch will add logic that generate R5LOG_PAYLOAD_FLUSH on flush
finish.

When R5LOG_PAYLOAD_FLUSH is seen in recovery, pending data and parity
will be dropped from recovery. This will reduce the number of stripes
to replay, and thus accelerate the recovery process.

Signed-off-by: Song Liu <songliubraving@fb.com>
---
 drivers/md/raid5-cache.c | 47 +++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 41 insertions(+), 6 deletions(-)

diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index 0d744d5..e69f922 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -1957,6 +1957,7 @@ r5l_recovery_verify_data_checksum_for_mb(struct r5l_log *log,
 	sector_t log_offset = r5l_ring_add(log, ctx->pos, BLOCK_SECTORS);
 	struct page *page;
 	struct r5l_payload_data_parity *payload;
+	struct r5l_payload_flush *payload_flush;
 
 	page = alloc_page(GFP_KERNEL);
 	if (!page)
@@ -1964,6 +1965,7 @@ r5l_recovery_verify_data_checksum_for_mb(struct r5l_log *log,
 
 	while (mb_offset < le32_to_cpu(mb->meta_size)) {
 		payload = (void *)mb + mb_offset;
+		payload_flush = (void *)mb + mb_offset;
 
 		if (payload->header.type == R5LOG_PAYLOAD_DATA) {
 			if (r5l_recovery_verify_data_checksum(
@@ -1982,15 +1984,23 @@ r5l_recovery_verify_data_checksum_for_mb(struct r5l_log *log,
 						 BLOCK_SECTORS),
 				    payload->checksum[1]) < 0)
 				goto mismatch;
-		} else /* not R5LOG_PAYLOAD_DATA or R5LOG_PAYLOAD_PARITY */
+		} else if (payload->header.type == R5LOG_PAYLOAD_FLUSH) {
+			/* nothing to do for R5LOG_PAYLOAD_FLUSH here */
+		} else /* not R5LOG_PAYLOAD_DATA/PARITY/FLUSH */
 			goto mismatch;
 
-		log_offset = r5l_ring_add(log, log_offset,
-					  le32_to_cpu(payload->size));
+		if (payload->header.type == R5LOG_PAYLOAD_FLUSH) {
+			mb_offset += sizeof(struct r5l_payload_flush) +
+				le32_to_cpu(payload_flush->size);
+		} else {
+			/* DATA or PARITY payload */
+			log_offset = r5l_ring_add(log, log_offset,
+						  le32_to_cpu(payload->size));
+			mb_offset += sizeof(struct r5l_payload_data_parity) +
+				sizeof(__le32) *
+				(le32_to_cpu(payload->size) >> (PAGE_SHIFT - 9));
+		}
 
-		mb_offset += sizeof(struct r5l_payload_data_parity) +
-			sizeof(__le32) *
-			(le32_to_cpu(payload->size) >> (PAGE_SHIFT - 9));
 	}
 
 	put_page(page);
@@ -2018,6 +2028,7 @@ r5c_recovery_analyze_meta_block(struct r5l_log *log,
 	struct r5conf *conf = mddev->private;
 	struct r5l_meta_block *mb;
 	struct r5l_payload_data_parity *payload;
+	struct r5l_payload_flush *payload_flush;
 	int mb_offset;
 	sector_t log_offset;
 	sector_t stripe_sect;
@@ -2043,6 +2054,30 @@ r5c_recovery_analyze_meta_block(struct r5l_log *log,
 		int dd;
 
 		payload = (void *)mb + mb_offset;
+		payload_flush = (void *)mb + mb_offset;
+
+		if (payload->header.type == R5LOG_PAYLOAD_FLUSH) {
+			int i, count;
+
+			count = le32_to_cpu(payload_flush->size) / sizeof(__le64);
+			for (i = 0; i < count; ++i) {
+				stripe_sect = le64_to_cpu(payload_flush->flush_stripes[i]);
+				sh = r5c_recovery_lookup_stripe(cached_stripe_list,
+								stripe_sect);
+				if (sh) {
+					WARN_ON(test_bit(STRIPE_R5C_CACHING, &sh->state));
+					r5l_recovery_reset_stripe(sh);
+					list_del_init(&sh->lru);
+					raid5_release_stripe(sh);
+				}
+			}
+
+			mb_offset += sizeof(struct r5l_payload_flush) +
+				le32_to_cpu(payload_flush->size);
+			continue;
+		}
+
+		/* DATA or PARITY payload */
 		stripe_sect = (payload->header.type == R5LOG_PAYLOAD_DATA) ?
 			raid5_compute_sector(
 				conf, le64_to_cpu(payload->location), 0, &dd,
-- 
2.9.3

