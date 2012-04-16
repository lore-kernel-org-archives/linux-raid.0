From: "majianpeng" <majianpeng@gmail.com>
Subject: [PATCH] md/raid10:Memleak fix if allocate rep1_bio failed in  function want_replacement().
Date: Mon, 16 Apr 2012 19:24:13 +0800
Message-ID: <201204161924086710486@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

From cb391c87d24a32b211d9f0a9df942987bf8e0ac4 Mon Sep 17 00:00:00 2001
From: majianpeng <majianpeng@gmail.com>
Date: Mon, 16 Apr 2012 19:19:53 +0800
Subject: [PATCH] md/raid10:Memleak fix if allocate rep1_bio failed in
 function want_replacement().
 Reported by kmemleak.

Signed-off-by: majianpeng <majianpeng@gmail.com>
---
 drivers/md/raid10.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index c8dbb84..19e9af1 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -165,10 +165,11 @@ out_free_pages:
 	while (j--)
 		for (i = 0; i < RESYNC_PAGES ; i++)
 			safe_put_page(r10_bio->devs[j].bio->bi_io_vec[i].bv_page);
-	j = -1;
+	j = 0;
 out_free_bio:
-	while (++j < nalloc) {
-		bio_put(r10_bio->devs[j].bio);
+	for ( ; j < nalloc; j++) {
+		if (r10_bio->devs[j].bio)
+			bio_put(r10_bio->devs[j].bio);
 		if (r10_bio->devs[j].repl_bio)
 			bio_put(r10_bio->devs[j].repl_bio);
 	}
-- 
1.7.5.4

 				
--------------
majianpeng
2012-04-16

