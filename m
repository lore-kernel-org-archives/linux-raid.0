From: Kyungchan Koh <kkc6196@fb.com>
Subject: [PATCH] md: uuid debug statement now in processor byte order.
Date: Wed, 24 May 2017 10:16:27 -0700
Message-ID: <b8df852840a411e783200002c9dfb610-1a1976b0@d534dd3d68affa13903f5fb3ca3863d112c51930cd4dca1fc26760790e4487f4>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: shli@kernel.org, Kernel-team@fb.com
List-Id: linux-raid.ids

Previously, the uuid debug statements were printed in little-endian
format, which wasn't consistent in machines that might not be in
little-endian byte order. With this change, the output will be
consistent for all machines with different byte-ordering.

Signed-off-by: Kyungchan Koh <kkc6196@fb.com>
---
 drivers/md/bitmap.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
index bf7419a..f4eace5 100644
--- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@ -485,10 +485,10 @@ void bitmap_print_sb(struct bitmap *bitmap)
 	pr_debug("         magic: %08x\n", le32_to_cpu(sb->magic));
 	pr_debug("       version: %d\n", le32_to_cpu(sb->version));
 	pr_debug("          uuid: %08x.%08x.%08x.%08x\n",
-		 *(__u32 *)(sb->uuid+0),
-		 *(__u32 *)(sb->uuid+4),
-		 *(__u32 *)(sb->uuid+8),
-		 *(__u32 *)(sb->uuid+12));
+		 le32_to_cpu(*(__u32 *)(sb->uuid+0)),
+		 le32_to_cpu(*(__u32 *)(sb->uuid+4)),
+		 le32_to_cpu(*(__u32 *)(sb->uuid+8)),
+		 le32_to_cpu(*(__u32 *)(sb->uuid+12)));
 	pr_debug("        events: %llu\n",
 		 (unsigned long long) le64_to_cpu(sb->events));
 	pr_debug("events cleared: %llu\n",
-- 
2.9.3

