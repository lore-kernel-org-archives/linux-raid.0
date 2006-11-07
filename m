From: NeilBrown <neilb@suse.de>
Subject: [PATCH 009 of 9] md: Enable bypassing cache for reads.
Date: Wed, 8 Nov 2006 09:10:07 +1100
Message-ID: <1061107221007.12586@suse.de>
References: <20061108085917.12064.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, "Raz Ben-Jehuda(caro)" <raziebe@gmail.com>
List-Id: linux-raid.ids


From: "Raz Ben-Jehuda(caro)" <raziebe@gmail.com>

Call the chunk_aligned_read where appropriate.

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/raid5.c |    5 +++++
 1 file changed, 5 insertions(+)

diff .prev/drivers/md/raid5.c ./drivers/md/raid5.c
--- .prev/drivers/md/raid5.c	2006-11-06 11:29:14.000000000 +1100
+++ ./drivers/md/raid5.c	2006-11-06 11:29:14.000000000 +1100
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
