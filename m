From: Ming Lei <tom.leiming@gmail.com>
Subject: [PATCH v1 06/14] md: raid1: simplify r1buf_pool_free()
Date: Fri, 24 Feb 2017 23:42:43 +0800
Message-ID: <1487950971-1131-7-git-send-email-tom.leiming@gmail.com>
References: <1487950971-1131-1-git-send-email-tom.leiming@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1487950971-1131-1-git-send-email-tom.leiming@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>, Jens Axboe <axboe@fb.com>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
Cc: Ming Lei <tom.leiming@gmail.com>
List-Id: linux-raid.ids

This patch gets each page's reference of each bio for resync,
then r1buf_pool_free() gets simplified a lot.

The same policy has been taken in raid10's buf pool allocation/free
too.

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
---
 drivers/md/raid1.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 2013e5870761..2de0bd69d8da 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -139,9 +139,12 @@ static void * r1buf_pool_alloc(gfp_t gfp_flags, void *data)
 	/* If not user-requests, copy the page pointers to all bios */
 	if (!test_bit(MD_RECOVERY_REQUESTED, &pi->mddev->recovery)) {
 		for (i=0; i<RESYNC_PAGES ; i++)
-			for (j=1; j<pi->raid_disks; j++)
-				r1_bio->bios[j]->bi_io_vec[i].bv_page =
+			for (j=1; j<pi->raid_disks; j++) {
+				struct page *page =
 					r1_bio->bios[0]->bi_io_vec[i].bv_page;
+				get_page(page);
+				r1_bio->bios[j]->bi_io_vec[i].bv_page = page;
+			}
 	}
 
 	r1_bio->master_bio = NULL;
@@ -166,12 +169,8 @@ static void r1buf_pool_free(void *__r1_bio, void *data)
 	struct r1bio *r1bio = __r1_bio;
 
 	for (i = 0; i < RESYNC_PAGES; i++)
-		for (j = pi->raid_disks; j-- ;) {
-			if (j == 0 ||
-			    r1bio->bios[j]->bi_io_vec[i].bv_page !=
-			    r1bio->bios[0]->bi_io_vec[i].bv_page)
-				safe_put_page(r1bio->bios[j]->bi_io_vec[i].bv_page);
-		}
+		for (j = pi->raid_disks; j-- ;)
+			safe_put_page(r1bio->bios[j]->bi_io_vec[i].bv_page);
 	for (i=0 ; i < pi->raid_disks; i++)
 		bio_put(r1bio->bios[i]);
 
-- 
2.7.4
