From: "majianpeng" <majianpeng@gmail.com>
Subject: [PATCH] md/raid1:use bi->bv_len instead of PAGE_SIZE.
Date: Sat, 31 Mar 2012 16:05:35 +0800
Message-ID: <201203311605306405927@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

From 3d3a7eafc73f9de3eb6386ba4f30717412b6b255 Mon Sep 17 00:00:00 2001
From: majianpeng <majianpeng@gmail.com>
Date: Sat, 31 Mar 2012 16:01:58 +0800
Subject: [PATCH] md/raid1:use bi->bv_len instead of PAGE_SIZE. 
If bv_len is  less PAGE_SIZE,then memcpy will waste time.


Signed-off-by: majianpeng <majianpeng@gmail.com>
---
 drivers/md/raid1.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 4a40a20..a623f70 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1775,7 +1775,7 @@ static int process_checks(struct r1bio *r1_bio)
 			size -= PAGE_SIZE;
 			memcpy(page_address(bi->bv_page),
 			       page_address(pbio->bi_io_vec[j].bv_page),
-			       PAGE_SIZE);
+			       bi->bv_len);
 		}
 	}
 	return 0;
-- 
1.7.5.4

 				
--------------
majianpeng
2012-03-31

