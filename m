From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 08/16] md/raid5: remove redundant bio initialisations.
Date: Wed, 26 Oct 2011 12:43:01 +1100
Message-ID: <20111026014301.21110.69146.stgit@notabene.brown>
References: <20111026014240.21110.28487.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111026014240.21110.28487.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

We current initialise some fields of a bio when preparing a
stripe_head, and again just before submitting the request.

Remove the duplication by only setting the fields that lower level
devices don't touch in raid5_build_block, and only set the changeable
fields in ops_run_io.

Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/raid5.c |    9 +--------
 1 files changed, 1 insertions(+), 8 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index e6d10df..12e54c0 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -562,10 +562,7 @@ static void ops_run_io(struct stripe_head *sh, struct stripe_head_state *s)
 			atomic_inc(&sh->count);
 			bi->bi_sector = sh->sector + rdev->data_offset;
 			bi->bi_flags = 1 << BIO_UPTODATE;
-			bi->bi_vcnt = 1;
-			bi->bi_max_vecs = 1;
 			bi->bi_idx = 0;
-			bi->bi_io_vec = &sh->dev[i].vec;
 			bi->bi_io_vec[0].bv_len = STRIPE_SIZE;
 			bi->bi_io_vec[0].bv_offset = 0;
 			bi->bi_size = STRIPE_SIZE;
@@ -1708,12 +1705,8 @@ static void raid5_build_block(struct stripe_head *sh, int i, int previous)
 	dev->req.bi_io_vec = &dev->vec;
 	dev->req.bi_vcnt++;
 	dev->req.bi_max_vecs++;
-	dev->vec.bv_page = dev->page;
-	dev->vec.bv_len = STRIPE_SIZE;
-	dev->vec.bv_offset = 0;
-
-	dev->req.bi_sector = sh->sector;
 	dev->req.bi_private = sh;
+	dev->vec.bv_page = dev->page;
 
 	dev->flags = 0;
 	dev->sector = compute_blocknr(sh, i, previous);


