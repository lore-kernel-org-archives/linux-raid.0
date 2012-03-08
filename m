From: "kedacomkernel" <kedacomkernel@gmail.com>
Subject: md:Add judgement bb->unacked_exist in function
Date: Thu, 8 Mar 2012 17:37:45 +0800
Message-ID: <201203081737420934967@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

From 7054a9dcd23a721e3c3dd2ceb8f1243187ea5cc4 Mon Sep 17 00:00:00 2001
From: majianpeng <majianpeng@gmail.com>
Date: Thu, 8 Mar 2012 17:31:32 +0800
Subject: [PATCH] md:Add judgement bb->unacked_exist in function
 md_ack_all_badblocks().


Signed-off-by: majianpeng <majianpeng@gmail.com>
---
 drivers/md/md.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index ce88755..7c57d0f 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -8040,7 +8040,7 @@ void md_ack_all_badblocks(struct badblocks *bb)
 		return;
 	write_seqlock_irq(&bb->lock);
 
-	if (bb->changed == 0) {
+	if (bb->changed == 0 && bb->unacked_exist) {
 		u64 *p = bb->page;
 		int i;
 		for (i = 0; i < bb->count ; i++) {
-- 
1.7.5.4

 				
--------------
kedacomkernel
2012-03-08

