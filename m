From: "majianpeng" <majianpeng@gmail.com>
Subject: [PATCH] md/raid1:using else-if instead if.
Date: Sun, 1 Apr 2012 10:29:14 +0800
Message-ID: <201204011029101719694@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

From 798f3fce3d077db049a44d0d2434261c937796e9 Mon Sep 17 00:00:00 2001
From: majianpeng <majianpeng@gmail.com>
Date: Sun, 1 Apr 2012 10:23:56 +0800
Subject: [PATCH] md/raid1:using else-if instead if.


Signed-off-by: majianpeng <majianpeng@gmail.com>
---
 drivers/md/raid1.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 4a40a20..a9de970 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -2024,8 +2024,7 @@ static void handle_sync_write_finished(struct r1conf *conf, struct r1bio *r1_bio
 		if (test_bit(BIO_UPTODATE, &bio->bi_flags) &&
 		    test_bit(R1BIO_MadeGood, &r1_bio->state)) {
 			rdev_clear_badblocks(rdev, r1_bio->sector, s);
-		}
-		if (!test_bit(BIO_UPTODATE, &bio->bi_flags) &&
+		} else if (!test_bit(BIO_UPTODATE, &bio->bi_flags) &&
 		    test_bit(R1BIO_WriteError, &r1_bio->state)) {
 			if (!rdev_set_badblocks(rdev, r1_bio->sector, s, 0))
 				md_error(conf->mddev, rdev);
-- 
1.7.5.4

 				
--------------
majianpeng
2012-04-01

