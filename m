From: Guoqing Jiang <gqjiang@suse.com>
Subject: [PATCH 1/3] md/raid1: remove unnecessary BUG_ON
Date: Mon, 14 Mar 2016 17:01:37 +0800
Message-ID: <1457946099-1878-2-git-send-email-gqjiang@suse.com>
References: <1457946099-1878-1-git-send-email-gqjiang@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1457946099-1878-1-git-send-email-gqjiang@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: shli@fb.com
Cc: linux-raid@vger.kernel.org, Guoqing Jiang <gqjiang@suse.com>
List-Id: linux-raid.ids

Since bitmap_start_sync will not return until
sync_blocks is not less than PAGE_SIZE>>9, so
the BUG_ON is not needed anymore.

Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
---
 drivers/md/raid1.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 4e3843f..d1d5363 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -2695,7 +2695,6 @@ static sector_t raid1_sync_request(struct mddev *mddev, sector_t sector_nr,
 			    !conf->fullsync &&
 			    !test_bit(MD_RECOVERY_REQUESTED, &mddev->recovery))
 				break;
-			BUG_ON(sync_blocks < (PAGE_SIZE>>9));
 			if ((len >> 9) > sync_blocks)
 				len = sync_blocks<<9;
 		}
-- 
2.6.2

