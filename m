From: "majianpeng" <majianpeng@gmail.com>
Subject: md/raid5:Fix recover/replace stop and start repreatedly if handle stipe failed,because one disk had bad blocks.
Date: Tue, 20 Mar 2012 09:20:35 +0800
Message-ID: <201203200920297652730@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

From 759a61519343c64066a5a14bb97447878aa1297e Mon Sep 17 00:00:00 2001
From: majianpeng <majianpeng@gmail.com>
Date: Mon, 19 Mar 2012 15:59:04 +0800
Subject: [PATCH] md/raid5:Fix recover/replace stop and start repreatedly if
 handle stipe failed,because one disk had bad blocks.

When raid5 recovering,then failed because one disk had bad blocks.
The sync_request() return value which larger than 0 and set
MD_RECOVERY_INTR.Because the statement if (test_bit(MD_RECOVERY_INTR,
&mddev->recovery)) first call,so the mddev->curr_resync did not change.
After the sync done,the mddev->curr_resync did not change.So the
resync_thread will stop and start repeatedly.

Signed-off-by: majianpeng <majianpeng@gmail.com>
---
 drivers/md/md.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index ce88755..370c9d9 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -7261,11 +7261,12 @@ void md_do_sync(struct mddev *mddev)
 			atomic_add(sectors, &mddev->recovery_active);
 		}
 
-		if (test_bit(MD_RECOVERY_INTR, &mddev->recovery))
-			break;
 
 		j += sectors;
 		if (j>1) mddev->curr_resync = j;
+
+		if (test_bit(MD_RECOVERY_INTR, &mddev->recovery))
+			break;
 		mddev->curr_mark_cnt = io_sectors;
 		if (last_check == 0)
 			/* this is the earliest that rebuild will be
-- 
1.7.5.4

 				
--------------
majianpeng
2012-03-20

