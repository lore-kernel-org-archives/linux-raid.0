From: "majianpeng" <majianpeng@gmail.com>
Subject: [PATCH] md/raid1:Using 1 instead of update.
Date: Sun, 1 Apr 2012 10:36:32 +0800
Message-ID: <201204011036292188169@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

From 6991dc532e4d655fb509ba1dbe7a9869b0cd33d9 Mon Sep 17 00:00:00 2001
From: majianpeng <majianpeng@gmail.com>
Date: Sun, 1 Apr 2012 10:31:52 +0800
Subject: [PATCH] md/raid1:Using 1 instead of update. 
If update == 0 and then  set R1BIO_WriteError,so did not exec md_do_sync().


Signed-off-by: majianpeng <majianpeng@gmail.com>
---
 drivers/md/raid1.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 4a40a20..def1ed1 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1554,7 +1554,7 @@ static void end_sync_write(struct bio *bio, int error)
 			reschedule_retry(r1_bio);
 		else {
 			put_buf(r1_bio);
-			md_done_sync(mddev, s, uptodate);
+			md_done_sync(mddev, s, 1);
 		}
 	}
 }
-- 
1.7.5.4

 				
--------------
majianpeng
2012-04-01

