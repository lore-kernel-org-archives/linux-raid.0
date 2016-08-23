From: Shaohua Li <shli@fb.com>
Subject: [PATCH 2/2] raid5: avoid unnecessary bio data set
Date: Mon, 22 Aug 2016 21:14:02 -0700
Message-ID: <491b687fd6df97eccf2aeb85340e3178642454cd.1471925425.git.shli@fb.com>
References: <4a00786c49856f37454376ddfc02c040c85ab14d.1471925425.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4a00786c49856f37454376ddfc02c040c85ab14d.1471925425.git.shli@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: yizhan@redhat.com, xni@redhat.com, jes.sorensen@redhat.com, jmoyer@redhat.com, Kernel-team@fb.com
List-Id: linux-raid.ids

bio_reset doesn't change bi_io_vec and bi_max_vecs, so we don't need to
set them every time. bi_private will be set before the bio is
dispatched.

Signed-off-by: Shaohua Li <shli@fb.com>
---
 drivers/md/raid5.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 52cf205..9b1a41f 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -2005,7 +2005,12 @@ static struct stripe_head *alloc_stripe(struct kmem_cache *sc, gfp_t gfp,
 			struct r5dev *dev = &sh->dev[i];
 
 			bio_init(&dev->req);
+			dev->req.bi_io_vec = &dev->vec;
+			dev->req.bi_max_vecs = 1;
+
 			bio_init(&dev->rreq);
+			dev->rreq.bi_io_vec = &dev->rvec;
+			dev->rreq.bi_max_vecs = 1;
 		}
 	}
 	return sh;
@@ -2507,14 +2512,6 @@ static void raid5_build_block(struct stripe_head *sh, int i, int previous)
 {
 	struct r5dev *dev = &sh->dev[i];
 
-	dev->req.bi_io_vec = &dev->vec;
-	dev->req.bi_max_vecs = 1;
-	dev->req.bi_private = sh;
-
-	dev->rreq.bi_io_vec = &dev->rvec;
-	dev->rreq.bi_max_vecs = 1;
-	dev->rreq.bi_private = sh;
-
 	dev->flags = 0;
 	dev->sector = raid5_compute_blocknr(sh, i, previous);
 }
-- 
2.8.0.rc2

