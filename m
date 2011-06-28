From: Namhyung Kim <namhyung@gmail.com>
Subject: [PATCH 2/3] md/raid5: move rdev->corrected_errors counting
Date: Wed, 29 Jun 2011 01:47:25 +0900
Message-ID: <1309279646-4950-3-git-send-email-namhyung@gmail.com>
References: <1309279646-4950-1-git-send-email-namhyung@gmail.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1309279646-4950-1-git-send-email-namhyung@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Read errors are considered to corrected if write-back and re-read
cycle is finished without further problems. Thus moving the rdev->
corrected_errors counting after the re-reading looks more reasonable
IMHO.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 drivers/md/raid5.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index c9eb0555f321..59acc9b4deb3 100644
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
@@ -1588,6 +1584,7 @@ static void raid5_end_read_request(struct bio * bi, int error)
 					   (unsigned long long)(sh->sector
 								+ rdev->data_offset),
 					   bdevname(rdev->bdev, b));
+			atomic_add(STRIPE_SECTORS, &rdev->corrected_errors);
 			clear_bit(R5_ReadError, &sh->dev[i].flags);
 			clear_bit(R5_ReWrite, &sh->dev[i].flags);
 		}
-- 
1.7.6

