From: Namhyung Kim <namhyung@gmail.com>
Subject: [PATCH 5/5] md/raid5: get rid of duplicated call to bio_data_dir()
Date: Wed, 22 Jun 2011 13:50:30 +0900
Message-ID: <1308718230-2536-6-git-send-email-namhyung@gmail.com>
References: <1308718230-2536-1-git-send-email-namhyung@gmail.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1308718230-2536-1-git-send-email-namhyung@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

In raid5::make_request(), once bio_data_dir(@bi) is detected
it never (and couldn't) be changed. Use the result always.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 drivers/md/raid5.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 6b92e8549e9b..ccaa1102057d 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -4016,7 +4016,7 @@ static int make_request(mddev_t *mddev, struct bio * bi)
 				}
 			}
 
-			if (bio_data_dir(bi) == WRITE &&
+			if (rw == WRITE &&
 			    logical_sector >= mddev->suspend_lo &&
 			    logical_sector < mddev->suspend_hi) {
 				release_stripe(sh);
@@ -4034,7 +4034,7 @@ static int make_request(mddev_t *mddev, struct bio * bi)
 			}
 
 			if (test_bit(STRIPE_EXPANDING, &sh->state) ||
-			    !add_stripe_bio(sh, bi, dd_idx, (bi->bi_rw&RW_MASK))) {
+			    !add_stripe_bio(sh, bi, dd_idx, rw)) {
 				/* Stripe is busy expanding or
 				 * add failed due to overlap.  Flush everything
 				 * and wait a while
-- 
1.7.5.2

