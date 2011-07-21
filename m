From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 30/34] md/raid5: move rdev->corrected_errors counting
Date: Thu, 21 Jul 2011 12:32:28 +1000
Message-ID: <20110721023228.6728.7610.stgit@notabene.brown>
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

Read errors are considered to corrected if write-back and re-read
cycle is finished without further problems. Thus moving the rdev->
corrected_errors counting after the re-reading looks more reasonable
IMHO.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/raid5.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 3c67942..ee26f50 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -547,10 +547,6 @@ static void ops_run_io(struct stripe_head *sh, struct stripe_head_state *s)
 			bi->bi_io_vec[0].bv_offset = 0;
 			bi->bi_size = STRIPE_SIZE;
 			bi->bi_next = NULL;
-			if ((rw & WRITE) &&
-			    test_bit(R5_ReWrite, &sh->dev[i].flags))
-				atomic_add(STRIPE_SECTORS,
-					&rdev->corrected_errors);
 			generic_make_request(bi);
 		} else {
 			if (rw & WRITE)
@@ -1590,6 +1586,7 @@ static void raid5_end_read_request(struct bio * bi, int error)
 				(unsigned long long)(sh->sector
 						     + rdev->data_offset),
 				bdevname(rdev->bdev, b));
+			atomic_add(STRIPE_SECTORS, &rdev->corrected_errors);
 			clear_bit(R5_ReadError, &sh->dev[i].flags);
 			clear_bit(R5_ReWrite, &sh->dev[i].flags);
 		}


