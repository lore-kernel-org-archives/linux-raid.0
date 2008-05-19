From: NeilBrown <neilb@suse.de>
Subject: [PATCH 005 of 10] md: raid1: Fix restoration of bio between failed read and write.
Date: Mon, 19 May 2008 11:10:38 +1000
Message-ID: <1080519011038.7684@suse.de>
References: <20080519110910.7473.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, "Fairbanks, David" <David.Fairbanks@stratus.com>
List-Id: linux-raid.ids


When performing a "recovery" or "check" pass on a RAID1 array,
we read from each device and possible, if there is a difference or a
read error, write back to some devices.

We use the same 'bio' for both read and write, resetting
various fields between the two operations.

We forgot to reset bv_offset and bv_len however.
These are often left unchanged, but in the case where there is an
IO error one or two sectors into a page, they are changed.

This results in correctable errors not being corrected properly.
It does not result in any data corruption.

Cc: "Fairbanks, David" <David.Fairbanks@stratus.com>
Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/raid1.c |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff .prev/drivers/md/raid1.c ./drivers/md/raid1.c
--- .prev/drivers/md/raid1.c	2008-05-19 11:03:05.000000000 +1000
+++ ./drivers/md/raid1.c	2008-05-19 11:02:55.000000000 +1000
@@ -1284,6 +1284,7 @@ static void sync_request_write(mddev_t *
 					rdev_dec_pending(conf->mirrors[i].rdev, mddev);
 				} else {
 					/* fixup the bio for reuse */
+					int size;
 					sbio->bi_vcnt = vcnt;
 					sbio->bi_size = r1_bio->sectors << 9;
 					sbio->bi_idx = 0;
@@ -1297,10 +1298,20 @@ static void sync_request_write(mddev_t *
 					sbio->bi_sector = r1_bio->sector +
 						conf->mirrors[i].rdev->data_offset;
 					sbio->bi_bdev = conf->mirrors[i].rdev->bdev;
-					for (j = 0; j < vcnt ; j++)
-						memcpy(page_address(sbio->bi_io_vec[j].bv_page),
+					size = sbio->bi_size;
+					for (j = 0; j < vcnt ; j++) {
+						struct bio_vec *bi;
+						bi = &sbio->bi_io_vec[j];
+						bi->bv_offset = 0;
+						if (size > PAGE_SIZE)
+							bi->bv_len = PAGE_SIZE;
+						else
+							bi->bv_len = size;
+						size -= PAGE_SIZE;
+						memcpy(page_address(bi->bv_page),
 						       page_address(pbio->bi_io_vec[j].bv_page),
 						       PAGE_SIZE);
+					}
 
 				}
 			}
