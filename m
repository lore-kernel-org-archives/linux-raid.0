From: Yufen Yu <yuyufen@huawei.com>
Subject: [PATCH] md/raid5: use do_div() for 64 bit divisions
Date: Wed, 22 Jul 2020 23:29:05 -0400
Message-ID: <20200723032905.864569-1-yuyufen@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: song@kernel.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 32-bit architectures (e.g. m68k):

  ERROR: modpost: "__udivdi3" [drivers/md/raid456.ko] undefined!

Since 'sync_blocks' is defined as 64bit, we should use do_div() to
fix this error.

Signed-off-by: Yufen Yu <yuyufen@huawei.com>
---
 drivers/md/raid5.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 40961dd1777b..a6ff6e1e039b 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -6104,7 +6104,7 @@ static inline sector_t raid5_sync_request(struct mddev *mddev, sector_t sector_n
 	    !md_bitmap_start_sync(mddev->bitmap, sector_nr, &sync_blocks, 1) &&
 	    sync_blocks >= RAID5_STRIPE_SECTORS(conf)) {
 		/* we can skip this block, and probably more */
-		sync_blocks /= RAID5_STRIPE_SECTORS(conf);
+		do_div(sync_blocks, RAID5_STRIPE_SECTORS(conf));
 		*skipped = 1;
 		/* keep things rounded to whole stripes */
 		return sync_blocks * RAID5_STRIPE_SECTORS(conf);
-- 
2.25.4
