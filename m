From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 05/34] md/raid5: get rid of duplicated call to
 bio_data_dir()
Date: Thu, 21 Jul 2011 12:32:25 +1000
Message-ID: <20110721023225.6728.47422.stgit@notabene.brown>
References: <20110721022537.6728.90204.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110721022537.6728.90204.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Namhyung Kim <namhyung@gmail.com>
List-Id: linux-raid.ids

From: Namhyung Kim <namhyung@gmail.com>

In raid5::make_request(), once bio_data_dir(@bi) is detected
it never (and couldn't) be changed. Use the result always.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/raid5.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 0f71aa9..7148064 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -4014,7 +4014,7 @@ static int make_request(mddev_t *mddev, struct bio * bi)
 				}
 			}
 
-			if (bio_data_dir(bi) == WRITE &&
+			if (rw == WRITE &&
 			    logical_sector >= mddev->suspend_lo &&
 			    logical_sector < mddev->suspend_hi) {
 				release_stripe(sh);
@@ -4032,7 +4032,7 @@ static int make_request(mddev_t *mddev, struct bio * bi)
 			}
 
 			if (test_bit(STRIPE_EXPANDING, &sh->state) ||
-			    !add_stripe_bio(sh, bi, dd_idx, (bi->bi_rw&RW_MASK))) {
+			    !add_stripe_bio(sh, bi, dd_idx, rw)) {
 				/* Stripe is busy expanding or
 				 * add failed due to overlap.  Flush everything
 				 * and wait a while


