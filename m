From: "kedacomkernel" <kedacomkernel@gmail.com>
Subject: md/raid1:Fix a logic bug in fix_sync_read_error().
Date: Sat, 31 Mar 2012 10:38:01 +0800
Message-ID: <201203311037586565381@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

From 0fe15c8e1bd5e46234d37573f3322312d8da325d Mon Sep 17 00:00:00 2001
From: majianpeng <majianpeng@gmail.com>
Date: Sat, 31 Mar 2012 10:27:33 +0800
Subject: [PATCH] md/raid1:Fix a logic bug in fix_sync_read_error(). 
If  d==read_disk && success == 1 and then break, so d =
 read_disk. When exec this judgement: >>start = d; >>/*
 write it back and re-read */ >>while (d !=
 r1_bio->read_disk) { Because d == read_disk,so write and
 re-add did not exec.


Signed-off-by: majianpeng <majianpeng@gmail.com>
---
 drivers/md/raid1.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 4a40a20..3a133ff 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1618,7 +1618,6 @@ static int fix_sync_read_error(struct r1bio *r1_bio)
 						 bio->bi_io_vec[idx].bv_page,
 						 READ, false)) {
 					success = 1;
-					break;
 				}
 			}
 			d++;
-- 
1.7.5.4

kedacomkernel
2012-03-31

