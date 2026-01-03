Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A85E30DED8
	for <linux-raid@vger.kernel.org>; Sat,  3 Jan 2026 15:46:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767455172; cv=none; b=ogvYUs9Nz4lDc+jRruC/W7tZQz3naS1Z9HpV+OCXBUagOu/UtZt9ke8CnstYqTBrcyhVUUlNUHyNNPA3PUIShvJs2+4fvAoL1HDnkDaC1FUemv8JVAY8xclC8Sn1UhblmfvbnWSNJj1y/OR3NUjD7DBdTseIRfev+GarKFDkguQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767455172; c=relaxed/simple;
	bh=+xdsYJZ0I1NLiTnpjyjJ//XH0UJo+0qR4RG89be5J2M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nAhw3sRYLbLVkjL9ZcSxl6w+C35rTCt1Nseba7ozOebewFYLujWZns6Y8OCNrMZGrne9GyrHh6Hi/v310tS7IIQmsRxGX0uWEBEmqMR39w/lBATofrKA84v8oCfphzL9/CVKWTZPUEgwn7xZo0NEquWYhec34CF4hFtO/dDFgRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF470C113D0;
	Sat,  3 Jan 2026 15:46:06 +0000 (UTC)
From: Yu Kuai <yukuai@fnnas.com>
To: linux-raid@vger.kernel.org
Cc: yukuai@fnnas.com,
	colyli@fnnas.com,
	linan122@huawei.com
Subject: [PATCH v2 04/11] md/raid5: use mempool to allocate stripe_request_ctx
Date: Sat,  3 Jan 2026 23:45:36 +0800
Message-ID: <20260103154543.832844-5-yukuai@fnnas.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260103154543.832844-1-yukuai@fnnas.com>
References: <20260103154543.832844-1-yukuai@fnnas.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On the one hand, stripe_request_ctx is 72 bytes, and it's a bit huge for
a stack variable.

On the other hand, the bitmap sectors_to_do is a fixed size, result in
max_hw_sector_kb of raid5 array is at most 256 * 4k = 1Mb, and this will
make full stripe IO impossible for the array that chunk_size * data_disks
is bigger. Allocate ctx during runtime will make it possible to get rid
of this limit.

Signed-off-by: Yu Kuai <yukuai@fnnas.com>
---
 drivers/md/md.h       |  4 +++
 drivers/md/raid1-10.c |  5 ----
 drivers/md/raid5.c    | 62 ++++++++++++++++++++++++++++---------------
 drivers/md/raid5.h    |  2 ++
 4 files changed, 46 insertions(+), 27 deletions(-)

diff --git a/drivers/md/md.h b/drivers/md/md.h
index 6ee18045f41c..b8c5dec12b62 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -22,6 +22,10 @@
 #include <trace/events/block.h>
 
 #define MaxSector (~(sector_t)0)
+/*
+ * Number of guaranteed raid bios in case of extreme VM load:
+ */
+#define	NR_RAID_BIOS 256
 
 enum md_submodule_type {
 	MD_PERSONALITY = 0,
diff --git a/drivers/md/raid1-10.c b/drivers/md/raid1-10.c
index 521625756128..c33099925f23 100644
--- a/drivers/md/raid1-10.c
+++ b/drivers/md/raid1-10.c
@@ -3,11 +3,6 @@
 #define RESYNC_BLOCK_SIZE (64*1024)
 #define RESYNC_PAGES ((RESYNC_BLOCK_SIZE + PAGE_SIZE-1) / PAGE_SIZE)
 
-/*
- * Number of guaranteed raid bios in case of extreme VM load:
- */
-#define	NR_RAID_BIOS 256
-
 /* when we get a read error on a read-only array, we redirect to another
  * device without failing the first device, or trying to over-write to
  * correct the read error.  To keep track of bad blocks on a per-bio
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 2294d00953af..86677519a4b5 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -6084,13 +6084,13 @@ static sector_t raid5_bio_lowest_chunk_sector(struct r5conf *conf,
 static bool raid5_make_request(struct mddev *mddev, struct bio * bi)
 {
 	DEFINE_WAIT_FUNC(wait, woken_wake_function);
-	bool on_wq;
 	struct r5conf *conf = mddev->private;
-	sector_t logical_sector;
-	struct stripe_request_ctx ctx = {};
 	const int rw = bio_data_dir(bi);
+	struct stripe_request_ctx *ctx;
+	sector_t logical_sector;
 	enum stripe_result res;
 	int s, stripe_cnt;
+	bool on_wq;
 
 	if (unlikely(bi->bi_opf & REQ_PREFLUSH)) {
 		int ret = log_handle_flush_request(conf, bi);
@@ -6102,11 +6102,6 @@ static bool raid5_make_request(struct mddev *mddev, struct bio * bi)
 				return true;
 		}
 		/* ret == -EAGAIN, fallback */
-		/*
-		 * if r5l_handle_flush_request() didn't clear REQ_PREFLUSH,
-		 * we need to flush journal device
-		 */
-		ctx.do_flush = bi->bi_opf & REQ_PREFLUSH;
 	}
 
 	md_write_start(mddev, bi);
@@ -6129,16 +6124,25 @@ static bool raid5_make_request(struct mddev *mddev, struct bio * bi)
 	}
 
 	logical_sector = bi->bi_iter.bi_sector & ~((sector_t)RAID5_STRIPE_SECTORS(conf)-1);
-	ctx.first_sector = logical_sector;
-	ctx.last_sector = bio_end_sector(bi);
 	bi->bi_next = NULL;
 
-	stripe_cnt = DIV_ROUND_UP_SECTOR_T(ctx.last_sector - logical_sector,
+	ctx = mempool_alloc(conf->ctx_pool, GFP_NOIO);
+	memset(ctx, 0, sizeof(*ctx));
+	ctx->first_sector = logical_sector;
+	ctx->last_sector = bio_end_sector(bi);
+	/*
+	 * if r5l_handle_flush_request() didn't clear REQ_PREFLUSH,
+	 * we need to flush journal device
+	 */
+	if (unlikely(bi->bi_opf & REQ_PREFLUSH))
+		ctx->do_flush = true;
+
+	stripe_cnt = DIV_ROUND_UP_SECTOR_T(ctx->last_sector - logical_sector,
 					   RAID5_STRIPE_SECTORS(conf));
-	bitmap_set(ctx.sectors_to_do, 0, stripe_cnt);
+	bitmap_set(ctx->sectors_to_do, 0, stripe_cnt);
 
 	pr_debug("raid456: %s, logical %llu to %llu\n", __func__,
-		 bi->bi_iter.bi_sector, ctx.last_sector);
+		 bi->bi_iter.bi_sector, ctx->last_sector);
 
 	/* Bail out if conflicts with reshape and REQ_NOWAIT is set */
 	if ((bi->bi_opf & REQ_NOWAIT) &&
@@ -6146,6 +6150,7 @@ static bool raid5_make_request(struct mddev *mddev, struct bio * bi)
 		bio_wouldblock_error(bi);
 		if (rw == WRITE)
 			md_write_end(mddev);
+		mempool_free(ctx, conf->ctx_pool);
 		return true;
 	}
 	md_account_bio(mddev, &bi);
@@ -6164,10 +6169,10 @@ static bool raid5_make_request(struct mddev *mddev, struct bio * bi)
 		add_wait_queue(&conf->wait_for_reshape, &wait);
 		on_wq = true;
 	}
-	s = (logical_sector - ctx.first_sector) >> RAID5_STRIPE_SHIFT(conf);
+	s = (logical_sector - ctx->first_sector) >> RAID5_STRIPE_SHIFT(conf);
 
 	while (1) {
-		res = make_stripe_request(mddev, conf, &ctx, logical_sector,
+		res = make_stripe_request(mddev, conf, ctx, logical_sector,
 					  bi);
 		if (res == STRIPE_FAIL || res == STRIPE_WAIT_RESHAPE)
 			break;
@@ -6184,9 +6189,9 @@ static bool raid5_make_request(struct mddev *mddev, struct bio * bi)
 			 * raid5_activate_delayed() from making progress
 			 * and thus deadlocking.
 			 */
-			if (ctx.batch_last) {
-				raid5_release_stripe(ctx.batch_last);
-				ctx.batch_last = NULL;
+			if (ctx->batch_last) {
+				raid5_release_stripe(ctx->batch_last);
+				ctx->batch_last = NULL;
 			}
 
 			wait_woken(&wait, TASK_UNINTERRUPTIBLE,
@@ -6194,21 +6199,23 @@ static bool raid5_make_request(struct mddev *mddev, struct bio * bi)
 			continue;
 		}
 
-		s = find_next_bit_wrap(ctx.sectors_to_do, stripe_cnt, s);
+		s = find_next_bit_wrap(ctx->sectors_to_do, stripe_cnt, s);
 		if (s == stripe_cnt)
 			break;
 
-		logical_sector = ctx.first_sector +
+		logical_sector = ctx->first_sector +
 			(s << RAID5_STRIPE_SHIFT(conf));
 	}
 	if (unlikely(on_wq))
 		remove_wait_queue(&conf->wait_for_reshape, &wait);
 
-	if (ctx.batch_last)
-		raid5_release_stripe(ctx.batch_last);
+	if (ctx->batch_last)
+		raid5_release_stripe(ctx->batch_last);
 
 	if (rw == WRITE)
 		md_write_end(mddev);
+
+	mempool_free(ctx, conf->ctx_pool);
 	if (res == STRIPE_WAIT_RESHAPE) {
 		md_free_cloned_bio(bi);
 		return false;
@@ -7376,6 +7383,10 @@ static void free_conf(struct r5conf *conf)
 	bioset_exit(&conf->bio_split);
 	kfree(conf->stripe_hashtbl);
 	kfree(conf->pending_data);
+
+	if (conf->ctx_pool)
+		mempool_destroy(conf->ctx_pool);
+
 	kfree(conf);
 }
 
@@ -8059,6 +8070,13 @@ static int raid5_run(struct mddev *mddev)
 			goto abort;
 	}
 
+	conf->ctx_pool = mempool_create_kmalloc_pool(NR_RAID_BIOS,
+					sizeof(struct stripe_request_ctx));
+	if (!conf->ctx_pool) {
+		ret = -ENOMEM;
+		goto abort;
+	}
+
 	if (log_init(conf, journal_dev, raid5_has_ppl(conf)))
 		goto abort;
 
diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
index eafc6e9ed6ee..6e3f07119fa4 100644
--- a/drivers/md/raid5.h
+++ b/drivers/md/raid5.h
@@ -690,6 +690,8 @@ struct r5conf {
 	struct list_head	pending_list;
 	int			pending_data_cnt;
 	struct r5pending_data	*next_pending_data;
+
+	mempool_t		*ctx_pool;
 };
 
 #if PAGE_SIZE == DEFAULT_STRIPE_SIZE
-- 
2.51.0

