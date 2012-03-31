From: "majianpeng" <majianpeng@gmail.com>
Subject: md/raid1:Remove unnecessary judgement.
Date: Sat, 31 Mar 2012 10:05:23 +0800
Message-ID: <201203311005202344147@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

From 033a0330eb210750ec09202ed95696b54d9afeba Mon Sep 17 00:00:00 2001
From: majianpeng <majianpeng@gmail.com>
Date: Sat, 31 Mar 2012 09:57:42 +0800
Subject: [PATCH] md/raid1:Remove unnecessary judgement. 
If success == 1 then  break the do{}while,so did not judge !success.


Signed-off-by: majianpeng <majianpeng@gmail.com>
---
 drivers/md/raid1.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 4a40a20..649941b 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1624,7 +1624,7 @@ static int fix_sync_read_error(struct r1bio *r1_bio)
 			d++;
 			if (d == conf->raid_disks * 2)
 				d = 0;
-		} while (!success && d != r1_bio->read_disk);
+		} while (d != r1_bio->read_disk);
 
 		if (!success) {
 			char b[BDEVNAME_SIZE];
-- 
1.7.5.4

 				
--------------
majianpeng
2012-03-31

