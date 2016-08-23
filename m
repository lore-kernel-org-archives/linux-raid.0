From: Yi Zhang <yizhan@redhat.com>
Subject: Re: [PATCH 1/2] raid5: fix memory leak of bio integrity data
Date: Tue, 23 Aug 2016 05:10:09 -0400 (EDT)
Message-ID: <1747759060.3454375.1471943409683.JavaMail.zimbra@redhat.com>
References: <4a00786c49856f37454376ddfc02c040c85ab14d.1471925425.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4a00786c49856f37454376ddfc02c040c85ab14d.1471925425.git.shli@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@fb.com>
Cc: linux-raid@vger.kernel.org, xni@redhat.com, jes sorensen <jes.sorensen@redhat.com>, jmoyer@redhat.com, Kernel-team@fb.com
List-Id: linux-raid.ids

Cannot reproduce the OOM/panic bug after 100 times' test.

Thanks
Yi

----- Original Message -----
From: "Shaohua Li" <shli@fb.com>
To: linux-raid@vger.kernel.org
Cc: yizhan@redhat.com, xni@redhat.com, "jes sorensen" <jes.sorensen@redhat.com>, jmoyer@redhat.com, Kernel-team@fb.com
Sent: Tuesday, August 23, 2016 12:14:01 PM
Subject: [PATCH 1/2] raid5: fix memory leak of bio integrity data

Yi reported a memory leak of raid5 with DIF/DIX enabled disks. raid5
doesn't alloc/free bio, instead it reuses bios. There are two issues in
current code:
1. the code calls bio_init (from
init_stripe->raid5_build_block->bio_init) then bio_reset (ops_run_io).
The bio is reused, so likely there is integrity data attached. bio_init
will clear a pointer to integrity data and makes bio_reset can't release
the data
2. bio_reset is called before dispatching bio. After bio is finished,
it's possible we don't free bio's integrity data (eg, we don't call
bio_reset again)
Both issues will cause memory leak. The patch moves bio_init to stripe
creation and bio_reset to bio end io. This will fix the two issues.

Reported-by: Yi Zhang <yizhan@redhat.com>
Signed-off-by: Shaohua Li <shli@fb.com>
---
 drivers/md/raid5.c | 22 +++++++++++++++-------
 1 file changed, 15 insertions(+), 7 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 4f8f524..52cf205 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -1005,7 +1005,6 @@ static void ops_run_io(struct stripe_head *sh, struct stripe_head_state *s)
 
 			set_bit(STRIPE_IO_STARTED, &sh->state);
 
-			bio_reset(bi);
 			bi->bi_bdev = rdev->bdev;
 			bio_set_op_attrs(bi, op, op_flags);
 			bi->bi_end_io = op_is_write(op)
@@ -1057,7 +1056,6 @@ static void ops_run_io(struct stripe_head *sh, struct stripe_head_state *s)
 
 			set_bit(STRIPE_IO_STARTED, &sh->state);
 
-			bio_reset(rbi);
 			rbi->bi_bdev = rrdev->bdev;
 			bio_set_op_attrs(rbi, op, op_flags);
 			BUG_ON(!op_is_write(op));
@@ -1990,9 +1988,11 @@ static void raid_run_ops(struct stripe_head *sh, unsigned long ops_request)
 	put_cpu();
 }
 
-static struct stripe_head *alloc_stripe(struct kmem_cache *sc, gfp_t gfp)
+static struct stripe_head *alloc_stripe(struct kmem_cache *sc, gfp_t gfp,
+	int disks)
 {
 	struct stripe_head *sh;
+	int i;
 
 	sh = kmem_cache_zalloc(sc, gfp);
 	if (sh) {
@@ -2001,6 +2001,12 @@ static struct stripe_head *alloc_stripe(struct kmem_cache *sc, gfp_t gfp)
 		INIT_LIST_HEAD(&sh->batch_list);
 		INIT_LIST_HEAD(&sh->lru);
 		atomic_set(&sh->count, 1);
+		for (i = 0; i < disks; i++) {
+			struct r5dev *dev = &sh->dev[i];
+
+			bio_init(&dev->req);
+			bio_init(&dev->rreq);
+		}
 	}
 	return sh;
 }
@@ -2008,7 +2014,7 @@ static int grow_one_stripe(struct r5conf *conf, gfp_t gfp)
 {
 	struct stripe_head *sh;
 
-	sh = alloc_stripe(conf->slab_cache, gfp);
+	sh = alloc_stripe(conf->slab_cache, gfp, conf->pool_size);
 	if (!sh)
 		return 0;
 
@@ -2179,7 +2185,7 @@ static int resize_stripes(struct r5conf *conf, int newsize)
 	mutex_lock(&conf->cache_size_mutex);
 
 	for (i = conf->max_nr_stripes; i; i--) {
-		nsh = alloc_stripe(sc, GFP_KERNEL);
+		nsh = alloc_stripe(sc, GFP_KERNEL, newsize);
 		if (!nsh)
 			break;
 
@@ -2311,6 +2317,7 @@ static void raid5_end_read_request(struct bio * bi)
 		(unsigned long long)sh->sector, i, atomic_read(&sh->count),
 		bi->bi_error);
 	if (i == disks) {
+		bio_reset(bi);
 		BUG();
 		return;
 	}
@@ -2414,6 +2421,7 @@ static void raid5_end_read_request(struct bio * bi)
 	clear_bit(R5_LOCKED, &sh->dev[i].flags);
 	set_bit(STRIPE_HANDLE, &sh->state);
 	raid5_release_stripe(sh);
+	bio_reset(bi);
 }
 
 static void raid5_end_write_request(struct bio *bi)
@@ -2448,6 +2456,7 @@ static void raid5_end_write_request(struct bio *bi)
 		(unsigned long long)sh->sector, i, atomic_read(&sh->count),
 		bi->bi_error);
 	if (i == disks) {
+		bio_reset(bi);
 		BUG();
 		return;
 	}
@@ -2491,18 +2500,17 @@ static void raid5_end_write_request(struct bio *bi)
 
 	if (sh->batch_head && sh != sh->batch_head)
 		raid5_release_stripe(sh->batch_head);
+	bio_reset(bi);
 }
 
 static void raid5_build_block(struct stripe_head *sh, int i, int previous)
 {
 	struct r5dev *dev = &sh->dev[i];
 
-	bio_init(&dev->req);
 	dev->req.bi_io_vec = &dev->vec;
 	dev->req.bi_max_vecs = 1;
 	dev->req.bi_private = sh;
 
-	bio_init(&dev->rreq);
 	dev->rreq.bi_io_vec = &dev->rvec;
 	dev->rreq.bi_max_vecs = 1;
 	dev->rreq.bi_private = sh;
-- 
2.8.0.rc2

