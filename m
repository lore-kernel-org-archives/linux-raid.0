From: Coywolf Qi Hunt <qiyong@freeforge.net>
Subject: [patch] stripe_to_pdidx() cleanup
Date: Tue, 2 May 2006 08:18:43 -0400
Message-ID: <20060502121843.GA24153@everest.sosdg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: akpm@osdl.org
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, neilb@suse.de
List-Id: linux-raid.ids

Hello,

Cleanup: Remove unnecessary variable x in stripe_to_pdidx().

Signed-off-by: Coywolf Qi Hunt <qiyong@freeforge.net>
---

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 3184360..7df6840 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -1033,13 +1033,12 @@ static void end_reshape(raid5_conf_t *co
 
 static int stripe_to_pdidx(sector_t stripe, raid5_conf_t *conf, int disks)
 {
-	int sectors_per_chunk = conf->chunk_size >> 9;
-	sector_t x = stripe;
 	int pd_idx, dd_idx;
-	int chunk_offset = sector_div(x, sectors_per_chunk);
-	stripe = x;
-	raid5_compute_sector(stripe*(disks-1)*sectors_per_chunk
-			     + chunk_offset, disks, disks-1, &dd_idx, &pd_idx, conf);
+	int sectors_per_chunk = conf->chunk_size >> 9;
+	int chunk_offset = sector_div(stripe, sectors_per_chunk);
+
+	raid5_compute_sector(stripe*(disks-1)*sectors_per_chunk + chunk_offset,
+				disks, disks-1, &dd_idx, &pd_idx, conf);
 	return pd_idx;
 }
 

-- 
Coywolf Qi Hunt
