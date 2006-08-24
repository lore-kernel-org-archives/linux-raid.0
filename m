From: NeilBrown <neilb@suse.de>
Subject: [PATCH 004 of 4] md: Remove unnecessary variable x in stripe_to_pdidx().
Date: Thu, 24 Aug 2006 17:41:18 +1000
Message-ID: <1060824074118.19171@suse.de>
References: <20060824173647.19026.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids


From : Coywolf Qi Hunt <qiyong@freeforge.net>

Signed-off-by: Coywolf Qi Hunt <qiyong@freeforge.net>


Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/raid5.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff .prev/drivers/md/raid5.c ./drivers/md/raid5.c
--- .prev/drivers/md/raid5.c	2006-08-24 17:09:42.000000000 +1000
+++ ./drivers/md/raid5.c	2006-08-24 17:24:17.000000000 +1000
@@ -1350,10 +1350,9 @@ static int page_is_zero(struct page *p)
 static int stripe_to_pdidx(sector_t stripe, raid5_conf_t *conf, int disks)
 {
 	int sectors_per_chunk = conf->chunk_size >> 9;
-	sector_t x = stripe;
 	int pd_idx, dd_idx;
-	int chunk_offset = sector_div(x, sectors_per_chunk);
-	stripe = x;
+	int chunk_offset = sector_div(stripe, sectors_per_chunk);
+
 	raid5_compute_sector(stripe*(disks-1)*sectors_per_chunk
 			     + chunk_offset, disks, disks-1, &dd_idx, &pd_idx, conf);
 	return pd_idx;
