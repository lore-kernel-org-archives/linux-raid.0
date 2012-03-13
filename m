From: "majianpeng" <majianpeng@gmail.com>
Subject: md:Add break if find.
Date: Tue, 13 Mar 2012 13:28:12 +0800
Message-ID: <201203131328071710700@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

From 6e04c2374db7fc34ccbf9f37f85e735a349c816c Mon Sep 17 00:00:00 2001
From: majianpeng <majianpeng@gmail.com>
Date: Tue, 13 Mar 2012 13:26:25 +0800
Subject: [PATCH] md:Add break if find.


Signed-off-by: majianpeng <majianpeng@gmail.com>
---
 drivers/md/raid5.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 360f2b9..e05d9e5 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -4369,8 +4369,10 @@ static inline sector_t sync_request(struct mddev *mddev, sector_t sector_nr, int
 	 * recovery aborts.
 	 */
 	for (i = 0; i < conf->raid_disks; i++)
-		if (conf->disks[i].rdev == NULL)
+		if (conf->disks[i].rdev == NULL) {
 			still_degraded = 1;
+			break;
+		}
 
 	bitmap_start_sync(mddev->bitmap, sector_nr, &sync_blocks, still_degraded);
 
-- 
1.7.5.4

 				
--------------
majianpeng
2012-03-13

