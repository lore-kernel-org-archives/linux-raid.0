From: Shaohua Li <shli@fb.com>
Subject: [PATCH 2/3] md/raid5-cache: bump flush stripe batch size
Date: Fri, 17 Feb 2017 15:32:25 -0800
Message-ID: <52a5e6f8924b9a19d4ec4ad73f6e7087f36f139d.1487373517.git.shli@fb.com>
References: <cover.1487373517.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <cover.1487373517.git.shli@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.com, songliubraving@fb.com, kernel-team@fb.com
List-Id: linux-raid.ids

Bump the flush stripe batch size to 2048. For my 12 disks raid
array, the stripes takes:
12 * 4k * 2048 = 96MB

This is still quite small. A hardware raid card generally has 1GB size,
which we suggest the raid5-cache has similar cache size.

The advantage of a big batch size is we can dispatch a lot of IO in the
same time, then we can do some scheduling to make better IO pattern.

Last patch prioritizes stripes, so we don't worry about a big flush
stripe batch will starve normal stripes.

Signed-off-by: Shaohua Li <shli@fb.com>
---
 drivers/md/raid5-cache.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index 3f307be..b25512c 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -43,7 +43,7 @@
 /* wake up reclaim thread periodically */
 #define R5C_RECLAIM_WAKEUP_INTERVAL (30 * HZ)
 /* start flush with these full stripes */
-#define R5C_FULL_STRIPE_FLUSH_BATCH 256
+#define R5C_FULL_STRIPE_FLUSH_BATCH 2048
 /* reclaim stripes in groups */
 #define R5C_RECLAIM_STRIPE_GROUP (NR_STRIPE_HASH_LOCKS * 2)
 
-- 
2.9.3

