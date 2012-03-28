From: "majianpeng" <majianpeng@gmail.com>
Subject: md/raid1:remove unnecessary  set_bit(MD_RECOVERY_INTR,&mddev->recovery).
Date: Wed, 28 Mar 2012 20:04:46 +0800
Message-ID: <201203282004424064858@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

From 641d71c2c1acc15536c621e2aa9806fe42b9cb8a Mon Sep 17 00:00:00 2001
From: majianpeng <majianpeng@gmail.com>
Date: Wed, 28 Mar 2012 20:02:05 +0800
Subject: [PATCH] md/raid1:remove unnecessary  set_bit(MD_RECOVERY_INTR,&mddev->recovery).


Signed-off-by: majianpeng <majianpeng@gmail.com>
---
 drivers/md/raid1.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 4a40a20..81083f2 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1649,7 +1649,6 @@ static int fix_sync_read_error(struct r1bio *r1_bio)
 			if (abort) {
 				conf->recovery_disabled =
 					mddev->recovery_disabled;
-				set_bit(MD_RECOVERY_INTR, &mddev->recovery);
 				md_done_sync(mddev, r1_bio->sectors, 0);
 				put_buf(r1_bio);
 				return 0;
@@ -2403,7 +2402,6 @@ static sector_t sync_request(struct mddev *mddev, sector_t sector_nr, int *skipp
 			 * fail the really bad ones ???
 			 */
 			conf->recovery_disabled = mddev->recovery_disabled;
-			set_bit(MD_RECOVERY_INTR, &mddev->recovery);
 			return 0;
 		} else
 			return min_bad;
-- 
1.7.5.4

 				
--------------
majianpeng
2012-03-28

