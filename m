From: "majianpeng" <majianpeng@gmail.com>
Subject: md:Fix a bug in function badblocks_show().
Date: Thu, 8 Mar 2012 14:46:52 +0800
Message-ID: <201203081446488121330@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

From 58d2ba381eee4b732fca99a7311b1dcf589f57c3 Mon Sep 17 00:00:00 2001
From: majianpeng <majianpeng@gmail.com>
Date: Thu, 8 Mar 2012 14:37:00 +0800
Subject: [PATCH] md:Fix a bug in function badblocks_show().

If unack==0, it will show all bad blocks include unacknowledged-bad-blocks.

Signed-off-by: majianpeng <majianpeng@gmail.com>
---
 drivers/md/md.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index ce88755..3f1b6e5 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -8091,7 +8091,7 @@ retry:
 		int ack = BB_ACK(p[i]);
 		i++;
 
-		if (unack && ack)
+		if ((unack ^ ack) == 0)
 			continue;
 
 		len += snprintf(page+len, PAGE_SIZE-len, "%llu %u\n",
-- 
1.7.5.4

 				
--------------
majianpeng
2012-03-08

