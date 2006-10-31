From: NeilBrown <neilb@suse.de>
Subject: [PATCH 006 of 6] md: Enable bypassing cache for reads.
Date: Tue, 31 Oct 2006 17:01:14 +1100
Message-ID: <1061031060114.5111@suse.de>
References: <20061031164814.4884.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, "Raz Ben-Jehuda(caro)" <raziebe@gmail.com>
List-Id: linux-raid.ids


Call the chunk_aligned_read where appropriate.

cc:  "Raz Ben-Jehuda(caro)" <raziebe@gmail.com>
Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/raid5.c |    5 +++++
 1 file changed, 5 insertions(+)

diff .prev/drivers/md/raid5.c ./drivers/md/raid5.c
--- .prev/drivers/md/raid5.c	2006-10-31 16:42:30.000000000 +1100
+++ ./drivers/md/raid5.c	2006-10-31 16:47:53.000000000 +1100
@@ -2798,6 +2798,11 @@ static int make_request(request_queue_t 
 	disk_stat_inc(mddev->gendisk, ios[rw]);
 	disk_stat_add(mddev->gendisk, sectors[rw], bio_sectors(bi));
 
+	if ( bio_data_dir(bi) == READ &&
+	     mddev->reshape_position == MaxSector &&
+	     chunk_aligned_read(q,bi))
+            		return 0;
+
 	logical_sector = bi->bi_sector & ~((sector_t)STRIPE_SECTORS-1);
 	last_sector = bi->bi_sector + (bi->bi_size>>9);
 	bi->bi_next = NULL;
