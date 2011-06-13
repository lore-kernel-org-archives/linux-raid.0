From: Namhyung Kim <namhyung@gmail.com>
Subject: [PATCH 2/3] md/raid5: fix FUA request handling in ops_run_io()
Date: Mon, 13 Jun 2011 23:48:23 +0900
Message-ID: <1307976504-10215-2-git-send-email-namhyung@gmail.com>
References: <1307976504-10215-1-git-send-email-namhyung@gmail.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1307976504-10215-1-git-send-email-namhyung@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
List-Id: linux-raid.ids

Commit e9c7469bb4f5 ("md: implment REQ_FLUSH/FUA support")
introduced R5_WantFUA flag and set rw to WRITE_FUA in that case.
However remaining code still checks whether rw is exactly same
as WRITE or not, so FUAed-write ends up with being treated as
READ. Fix it.

Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 drivers/md/raid5.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index fa6ac70dc72f..026452bbb030 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -514,7 +514,7 @@ static void ops_run_io(struct stripe_head *sh, struct stripe_head_state *s)
 		bi = &sh->dev[i].req;
 
 		bi->bi_rw = rw;
-		if (rw == WRITE)
+		if (rw & WRITE)
 			bi->bi_end_io = raid5_end_write_request;
 		else
 			bi->bi_end_io = raid5_end_read_request;
@@ -548,13 +548,13 @@ static void ops_run_io(struct stripe_head *sh, struct stripe_head_state *s)
 			bi->bi_io_vec[0].bv_offset = 0;
 			bi->bi_size = STRIPE_SIZE;
 			bi->bi_next = NULL;
-			if (rw == WRITE &&
+			if (rw & WRITE &&
 			    test_bit(R5_ReWrite, &sh->dev[i].flags))
 				atomic_add(STRIPE_SECTORS,
 					&rdev->corrected_errors);
 			generic_make_request(bi);
 		} else {
-			if (rw == WRITE)
+			if (rw & WRITE)
 				set_bit(STRIPE_DEGRADED, &sh->state);
 			pr_debug("skip op %ld on disc %d for sector %llu\n",
 				bi->bi_rw, i, (unsigned long long)sh->sector);
-- 
1.7.5.2

