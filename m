From: "majianpeng" <majianpeng@gmail.com>
Subject: [PATCH] md/raid10:using conf->chunk_mask instead "chunk_secotrs - 1"
Date: Tue, 17 Apr 2012 16:49:50 +0800
Message-ID: <201204171649462965325@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

From 2c637bca4e50e87f7b4e6b3abce27f8cd935fd92 Mon Sep 17 00:00:00 2001
From: majianpeng <majianpeng@gmail.com>
Date: Tue, 17 Apr 2012 16:47:07 +0800
Subject: [PATCH] md/raid10:using conf->chunk_mask instead "chunk_secotrs -
 1".


Signed-off-by: majianpeng <majianpeng@gmail.com>
---
 drivers/md/raid10.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index c8dbb84..5734d92 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -601,7 +601,7 @@ static int raid10_mergeable_bvec(struct request_queue *q,
 	unsigned int bio_sectors = bvm->bi_size >> 9;
 
 	if (conf->near_copies < conf->raid_disks) {
-		max = (chunk_sectors - ((sector & (chunk_sectors - 1))
+		max = (chunk_sectors - ((sector & conf->chunk_mask)
 					+ bio_sectors)) << 9;
 		if (max < 0)
 			/* bio_add cannot handle a negative return */
-- 
1.7.5.4

 				
--------------
majianpeng
2012-04-17

