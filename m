Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7263F42EEB7
	for <linux-raid@vger.kernel.org>; Fri, 10 Jul 2026 13:23:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783689833; cv=none; b=KMJLYDO0WjXb3/Lwb36Zx/Izyx3FcJ9nR07MoGLNzeDTkGv/hVjnyF6StmMwQ3gj4TVCgo7mxo1v07icHWy9leq99Z2KwPkuvUgoNmrnq3/1riGtNPn+WgMZBLR8N8gQubjrCWnTvCnlmAlgpSDyzcZ4Bdu9QV7ApyS7MiZvUw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783689833; c=relaxed/simple;
	bh=H2iRr6ILDIgFumit3VZJYsy+ldVBTtRu55uUxa9F72M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CCl0j51/FEVmMtMg0HFngWTPT/ZWHYRL/vedNmTzBbf1q6LdaWOOu3bJhngOYwEOPS2vi1asMJAY9/yld0YHnhtL58zL5fG8H98/97p0nsTWnmFXVoLiD4T0uRUU/F5gAfd6dUIpxR9/6asm3FMTFUdj3rLmPagInxwwycn2S/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=oddf5zWf; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="oddf5zWf"
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-8487b7b3fc7so366481b3a.0
        for <linux-raid@vger.kernel.org>; Fri, 10 Jul 2026 06:23:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783689831; x=1784294631; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=k8JosTKbT9z0L9W2GugeG9EbSEFdtCe4Jb+90xWifAo=;
        b=oddf5zWfdtABGcJwgWVe8e0vX0Gy5GoJBPAqWzARRF8Os2D7Ci1L44GInVncP49NvA
         cDTtWwGXag3oxGOF9LLYljVSrpPSRja2g+ZDwu2GBI8LyDCFhKadPa3O8TGx4NXa//uu
         8OOimbLPDE1/wb2I8EqoPNbL4PXVf8kc6DdW63GPzPuhmkUn88455+BinOWRCmMpLzeT
         rO/RsISsaSDowdvrvo4tZtKiV43X5ByLC8toCvGtzbT/bL0TtFyzFfLZa7rMEviLdj6J
         UEMIpGuSj9x8tStbrfe57lNbdAgrzOKGqk/ZeWok7IUSyorseOpLn7/gCD5/egujXUQF
         e8KQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783689831; x=1784294631;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=k8JosTKbT9z0L9W2GugeG9EbSEFdtCe4Jb+90xWifAo=;
        b=McUr9qTogH6KkUPoHznyrcb3K+gFMsy5QqM+vC/geWV4X+XRg7J1XfaF99xrUKxkhi
         m2gILWxkSl1mnEjo7WHIQHJyBFxBpmhpjZ+aO8h7sWXjOqS5GBZU+yYWCn+B+YPARMc9
         FSY9VUrSwccI1vY3Xm/9CTfnx987xOC9/GvpnVopQ+zjYEEJtrvQtQ2+TwDkhuQWEu18
         jt+P7J3czpyOoltkCm2Gk5AhQyCBAHwvYQoC+UnnLwaVaI9P5cqR3nyrX7CkMV69YN0I
         sdQcrM8Luu2OtBS9PK3tgekTOf6GNzz+Tac7vNpr8Bsi2Bh3T+qNH8e2AmcmZVHL3brv
         OpCg==
X-Forwarded-Encrypted: i=1; AHgh+RqXqX6090//wqoIiLZuxO2oY+de8VgzDA/cul+XsoHhEhOQ+/5t36+MahdXm5gdNIRns3hOMNELoEry@vger.kernel.org
X-Gm-Message-State: AOJu0YyplJolqJCE5dF8F8t6sp/PCt3fvoVe7vCALw/g5rwj4aKAlQti
	hyu6Z57dJVJysTVwWhEe9hKx6EQ2kfMmBsjrLKatHulPU4nOBTN2imBF
X-Gm-Gg: AfdE7cmSo/8BFFHgf+CygnVQGesHNalvqEPHFIqeQph9h+U7hRXPOhtiOhsBoXDLG/a
	rljwxvS7+ccHU0rcBzSVYxLhs9lAWIZcGCqiBcsdGVOdZgSMyTNg54Bq9R4w8vqoLyt53944NcR
	u0kVaC9QB00JcTt7JPNbxMEGiR+Tp3jnLXOTB9U+Hl6oPRxz7Zv4ALzGdmZxbDy3NsHhuEuRt7J
	n2Q+CXVQ22naa7Zmk4nx1AxiEyYATC8dKj+xUfaFFzB1FBhLfcG+2bx6Uh0NrWqA+IBWorX4wAk
	STUDsYMITIZfjMWidCQav+G5zsvcM2H+rJjsaFQhihhmYkfqaAqP3D0Cb8EFIKh12EFxNWvPMuO
	HoN+7ELtDX6MhYyKPb1rmZIUZ2ikqIEFvoBlufdmfDhFnSRZqODgOI92eO4W8UxIzGHsq98Jft0
	rWOM9GQ9AtcrtBF3wbB4Sk8kCMqb0x88rb06jdAJsu8WdQhkCpcnw/NcKQqx52p/evFCq97PXXa
	Co9hCQ=
X-Received: by 2002:a05:6a00:94a3:b0:848:48e7:438f with SMTP id d2e1a72fcca58-84848e747f6mr8691326b3a.64.1783689830768;
        Fri, 10 Jul 2026 06:23:50 -0700 (PDT)
Received: from research02.. ([2601:1c1:8700:f5b:fe34:97ff:fea3:c147])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-ca5b3b251eesm4903776a12.31.2026.07.10.06.23.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jul 2026 06:23:50 -0700 (PDT)
From: Hiroshi Nishida <nishidafmly@gmail.com>
To: Song Liu <song@kernel.org>,
	Yu Kuai <yukuai@fygo.io>
Cc: Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Hiroshi Nishida <nishidafmly@gmail.com>
Subject: [PATCH 2/6] md/raid5: size stripe-cache hash locks from the CPU count
Date: Fri, 10 Jul 2026 06:23:42 -0700
Message-ID: <20260710132346.7295-3-nishidafmly@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260710132346.7295-1-nishidafmly@gmail.com>
References: <20260710132346.7295-1-nishidafmly@gmail.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The stripe cache hash is striped across NR_STRIPE_HASH_LOCKS spinlocks
(see stripe_hash_locks_hash()).  The count has been a fixed 8 since the
per-hash locking was introduced.  On many-core servers 8 buckets is
small: stripe cache lookup and allocation contend on the same few locks
once the CPU count greatly exceeds the bucket count.  Simply raising the
compile-time constant, however, would grow three per-array arrays in
struct r5conf (hash_locks, inactive_list, temp_inactive_list) for every
array unconditionally, spending memory on small systems that see no
benefit from the extra buckets.

Make the count a per-array value, sized when the array is created and
selected by a new nr_stripe_hash_locks module parameter:

  - 0 (the default) auto-sizes the count from the online CPU count,
    rounded up to a power of two and clamped to the range
    [NR_STRIPE_HASH_LOCKS_DEFAULT (8), NR_STRIPE_HASH_LOCKS_MAX (32)].
    A machine with 8 or fewer CPUs therefore keeps the historical 8 and
    the historical memory footprint; wider machines stripe the locks
    further with no user action and no recompile.

  - A non-zero value overrides the heuristic (still rounded up to a
    power of two and capped at 32), for administrators who want to pin
    it.

  - The maximum is 32 because raid5_quiesce() takes every hash lock plus
    device_lock at once via lock_all_device_hash_locks_irq(); that holds
    nr_hash_locks + 1 locks simultaneously, which must stay below
    MAX_LOCK_DEPTH (48) so the held-lock array does not overflow when
    lockdep is enabled.

  - The three per-array arrays are now sized with kcalloc(nr_hash_locks)
    when the array is created, so a system that ends up with 8 locks uses
    no more memory than before.  The embedded and on-stack
    temp_inactive_list arrays (r5worker, raid5_plug_cb) are sized to the
    NR_STRIPE_HASH_LOCKS_MAX upper bound; only nr_hash_locks entries are
    ever initialised or used.

The value is resolved when an array is created, so existing arrays keep
their lock count and a value written later applies only to arrays
created afterwards.

Signed-off-by: Hiroshi Nishida <nishidafmly@gmail.com>
---
 drivers/md/raid5-cache.c |  2 +-
 drivers/md/raid5.c       | 84 +++++++++++++++++++++++++++++-----------
 drivers/md/raid5.h       | 31 ++++++++++-----
 3 files changed, 84 insertions(+), 33 deletions(-)

diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index 7b7546bfa21f..9cf58a13250a 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -38,7 +38,7 @@
 /* start flush with these full stripes */
 #define R5C_FULL_STRIPE_FLUSH_BATCH(conf) (conf->max_nr_stripes / 4)
 /* reclaim stripes in groups */
-#define R5C_RECLAIM_STRIPE_GROUP (NR_STRIPE_HASH_LOCKS * 2)
+#define R5C_RECLAIM_STRIPE_GROUP (NR_STRIPE_HASH_LOCKS_DEFAULT * 2)
 
 /*
  * We only need 2 bios per I/O unit to make progress, but ensure we
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index d8807114a693..7f72981121fd 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -67,6 +67,11 @@
 
 #define RAID5_MAX_REQ_STRIPES 256
 
+static unsigned int nr_stripe_hash_locks;
+module_param(nr_stripe_hash_locks, uint, 0644);
+MODULE_PARM_DESC(nr_stripe_hash_locks,
+		 "Number of spinlocks the stripe cache hash is striped across, rounded up to a power of two and capped at 32.  0 (the default) auto-sizes it from the online CPU count (never below 8); a non-zero value overrides that.  Larger values reduce lock contention on many-core systems at a small per-array memory cost.  Read when an array is created");
+
 static bool devices_handle_discard_safely = false;
 module_param(devices_handle_discard_safely, bool, 0644);
 MODULE_PARM_DESC(devices_handle_discard_safely,
@@ -83,7 +88,7 @@ static inline struct hlist_head *stripe_hash(struct r5conf *conf, sector_t sect)
 
 static inline int stripe_hash_locks_hash(struct r5conf *conf, sector_t sect)
 {
-	return (sect >> RAID5_STRIPE_SHIFT(conf)) & STRIPE_HASH_LOCKS_MASK;
+	return (sect >> RAID5_STRIPE_SHIFT(conf)) & conf->hash_locks_mask;
 }
 
 static inline void lock_device_hash_lock(struct r5conf *conf, int hash)
@@ -105,7 +110,7 @@ static inline void lock_all_device_hash_locks_irq(struct r5conf *conf)
 {
 	int i;
 	spin_lock_irq(conf->hash_locks);
-	for (i = 1; i < NR_STRIPE_HASH_LOCKS; i++)
+	for (i = 1; i < conf->nr_hash_locks; i++)
 		spin_lock_nest_lock(conf->hash_locks + i, conf->hash_locks);
 	spin_lock(&conf->device_lock);
 }
@@ -115,7 +120,7 @@ static inline void unlock_all_device_hash_locks_irq(struct r5conf *conf)
 {
 	int i;
 	spin_unlock(&conf->device_lock);
-	for (i = NR_STRIPE_HASH_LOCKS - 1; i; i--)
+	for (i = conf->nr_hash_locks - 1; i; i--)
 		spin_unlock(conf->hash_locks + i);
 	spin_unlock_irq(conf->hash_locks);
 }
@@ -317,7 +322,7 @@ static void __release_stripe(struct r5conf *conf, struct stripe_head *sh,
 }
 
 /*
- * @hash could be NR_STRIPE_HASH_LOCKS, then we have a list of inactive_list
+ * @hash could be conf->nr_hash_locks, then we have a list of inactive_list
  *
  * Be careful: Only one task can add/delete stripes from temp_inactive_list at
  * given time. Adding stripes only takes device lock, while deleting stripes
@@ -331,9 +336,9 @@ static void release_inactive_stripe_list(struct r5conf *conf,
 	bool do_wakeup = false;
 	unsigned long flags;
 
-	if (hash == NR_STRIPE_HASH_LOCKS) {
-		size = NR_STRIPE_HASH_LOCKS;
-		hash = NR_STRIPE_HASH_LOCKS - 1;
+	if (hash == conf->nr_hash_locks) {
+		size = conf->nr_hash_locks;
+		hash = conf->nr_hash_locks - 1;
 	} else
 		size = 1;
 	while (size) {
@@ -2408,7 +2413,7 @@ static int grow_one_stripe(struct r5conf *conf, gfp_t gfp)
 		return 0;
 	}
 	sh->hash_lock_index =
-		conf->max_nr_stripes % NR_STRIPE_HASH_LOCKS;
+		conf->max_nr_stripes % conf->nr_hash_locks;
 	/* we just created an active stripe so... */
 	atomic_inc(&conf->active_stripes);
 
@@ -2612,8 +2617,8 @@ static int resize_stripes(struct r5conf *conf, int newsize)
 		nsh->hash_lock_index = hash;
 		free_stripe(conf->slab_cache, osh);
 		cnt++;
-		if (cnt >= conf->max_nr_stripes / NR_STRIPE_HASH_LOCKS +
-		    !!((conf->max_nr_stripes % NR_STRIPE_HASH_LOCKS) > hash)) {
+		if (cnt >= conf->max_nr_stripes / conf->nr_hash_locks +
+		    !!((conf->max_nr_stripes % conf->nr_hash_locks) > hash)) {
 			hash++;
 			cnt = 0;
 		}
@@ -2697,7 +2702,7 @@ static int resize_stripes(struct r5conf *conf, int newsize)
 static int drop_one_stripe(struct r5conf *conf)
 {
 	struct stripe_head *sh;
-	int hash = (conf->max_nr_stripes - 1) & STRIPE_HASH_LOCKS_MASK;
+	int hash = (conf->max_nr_stripes - 1) & conf->hash_locks_mask;
 
 	spin_lock_irq(conf->hash_locks + hash);
 	sh = get_free_stripe(conf, hash);
@@ -5638,7 +5643,7 @@ static struct stripe_head *__get_priority_stripe(struct r5conf *conf, int group)
 struct raid5_plug_cb {
 	struct blk_plug_cb	cb;
 	struct list_head	list;
-	struct list_head	temp_inactive_list[NR_STRIPE_HASH_LOCKS];
+	struct list_head	temp_inactive_list[NR_STRIPE_HASH_LOCKS_MAX];
 };
 
 static void raid5_unplug(struct blk_plug_cb *blk_cb, bool from_schedule)
@@ -5674,7 +5679,7 @@ static void raid5_unplug(struct blk_plug_cb *blk_cb, bool from_schedule)
 		spin_unlock_irq(&conf->device_lock);
 	}
 	release_inactive_stripe_list(conf, cb->temp_inactive_list,
-				     NR_STRIPE_HASH_LOCKS);
+				     conf->nr_hash_locks);
 	if (!mddev_is_dm(mddev))
 		trace_block_unplug(mddev->gendisk->queue, cnt, !from_schedule);
 	kfree(cb);
@@ -5698,7 +5703,7 @@ static void release_stripe_plug(struct mddev *mddev,
 	if (cb->list.next == NULL) {
 		int i;
 		INIT_LIST_HEAD(&cb->list);
-		for (i = 0; i < NR_STRIPE_HASH_LOCKS; i++)
+		for (i = 0; i < NR_STRIPE_HASH_LOCKS_MAX; i++)
 			INIT_LIST_HEAD(cb->temp_inactive_list + i);
 	}
 
@@ -6732,10 +6737,10 @@ static int handle_active_stripes(struct r5conf *conf, int group,
 		batch[batch_size++] = sh;
 
 	if (batch_size == 0) {
-		for (i = 0; i < NR_STRIPE_HASH_LOCKS; i++)
+		for (i = 0; i < conf->nr_hash_locks; i++)
 			if (!list_empty(temp_inactive_list + i))
 				break;
-		if (i == NR_STRIPE_HASH_LOCKS) {
+		if (i == conf->nr_hash_locks) {
 			spin_unlock_irq(&conf->device_lock);
 			log_flush_stripe_to_raid(conf);
 			spin_lock_irq(&conf->device_lock);
@@ -6746,7 +6751,7 @@ static int handle_active_stripes(struct r5conf *conf, int group,
 	spin_unlock_irq(&conf->device_lock);
 
 	release_inactive_stripe_list(conf, temp_inactive_list,
-				     NR_STRIPE_HASH_LOCKS);
+				     conf->nr_hash_locks);
 
 	r5l_flush_stripe_to_raid(conf->log);
 	if (release_inactive) {
@@ -7353,7 +7358,7 @@ static int alloc_thread_groups(struct r5conf *conf, int cnt, int *group_cnt,
 			worker->group = group;
 			INIT_WORK(&worker->work, raid5_do_work);
 
-			for (k = 0; k < NR_STRIPE_HASH_LOCKS; k++)
+			for (k = 0; k < conf->nr_hash_locks; k++)
 				INIT_LIST_HEAD(worker->temp_inactive_list + k);
 		}
 	}
@@ -7448,6 +7453,9 @@ static void free_conf(struct r5conf *conf)
 	kfree(conf->disks);
 	bioset_exit(&conf->bio_split);
 	kfree(conf->stripe_hashtbl);
+	kfree(conf->hash_locks);
+	kfree(conf->inactive_list);
+	kfree(conf->temp_inactive_list);
 	kfree(conf->pending_data);
 
 	mempool_destroy(conf->ctx_pool);
@@ -7565,6 +7573,38 @@ static struct r5conf *setup_conf(struct mddev *mddev)
 	if (conf == NULL)
 		goto abort;
 
+	/*
+	 * Size the stripe cache hash-lock striping per array.  The
+	 * nr_stripe_hash_locks module parameter selects the count: 0 (the
+	 * default) auto-sizes it from the online CPU count so busier machines
+	 * stripe the locks wider, while a non-zero value overrides that.  The
+	 * result is rounded up to a power of two (the hash uses it as a
+	 * bitmask) and capped at NR_STRIPE_HASH_LOCKS_MAX; the auto path also
+	 * keeps at least the historical NR_STRIPE_HASH_LOCKS_DEFAULT so small
+	 * systems are unchanged.  Allocating per array means an untuned system
+	 * uses no more memory than before.
+	 */
+	if (nr_stripe_hash_locks == 0)
+		conf->nr_hash_locks = clamp_t(unsigned int,
+				roundup_pow_of_two(num_online_cpus()),
+				NR_STRIPE_HASH_LOCKS_DEFAULT,
+				NR_STRIPE_HASH_LOCKS_MAX);
+	else
+		conf->nr_hash_locks = roundup_pow_of_two(
+				min_t(unsigned int, nr_stripe_hash_locks,
+				      NR_STRIPE_HASH_LOCKS_MAX));
+	conf->hash_locks_mask = conf->nr_hash_locks - 1;
+	conf->hash_locks = kcalloc(conf->nr_hash_locks,
+				   sizeof(*conf->hash_locks), GFP_KERNEL);
+	conf->inactive_list = kcalloc(conf->nr_hash_locks,
+				      sizeof(*conf->inactive_list), GFP_KERNEL);
+	conf->temp_inactive_list = kcalloc(conf->nr_hash_locks,
+					   sizeof(*conf->temp_inactive_list),
+					   GFP_KERNEL);
+	if (!conf->hash_locks || !conf->inactive_list ||
+	    !conf->temp_inactive_list)
+		goto abort;
+
 #if PAGE_SIZE != DEFAULT_STRIPE_SIZE
 	conf->stripe_size = DEFAULT_STRIPE_SIZE;
 	conf->stripe_shift = ilog2(DEFAULT_STRIPE_SIZE) - 9;
@@ -7646,13 +7686,13 @@ static struct r5conf *setup_conf(struct mddev *mddev)
 	 * lockdep that we know what we are doing.
 	 */
 	spin_lock_init(conf->hash_locks);
-	for (i = 1; i < NR_STRIPE_HASH_LOCKS; i++)
+	for (i = 1; i < conf->nr_hash_locks; i++)
 		spin_lock_init(conf->hash_locks + i);
 
-	for (i = 0; i < NR_STRIPE_HASH_LOCKS; i++)
+	for (i = 0; i < conf->nr_hash_locks; i++)
 		INIT_LIST_HEAD(conf->inactive_list + i);
 
-	for (i = 0; i < NR_STRIPE_HASH_LOCKS; i++)
+	for (i = 0; i < conf->nr_hash_locks; i++)
 		INIT_LIST_HEAD(conf->temp_inactive_list + i);
 
 	atomic_set(&conf->r5c_cached_full_stripes, 0);
@@ -7729,7 +7769,7 @@ static struct r5conf *setup_conf(struct mddev *mddev)
 	}
 	memory = conf->min_nr_stripes * (sizeof(struct stripe_head) +
 		 max_disks * ((sizeof(struct bio) + PAGE_SIZE))) / 1024;
-	atomic_set(&conf->empty_inactive_list_nr, NR_STRIPE_HASH_LOCKS);
+	atomic_set(&conf->empty_inactive_list_nr, conf->nr_hash_locks);
 	if (grow_stripes(conf, conf->min_nr_stripes)) {
 		pr_warn("md/raid:%s: couldn't allocate %dkB for buffers\n",
 			mdname(mddev), memory);
diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
index cb5feae04db2..10c45fa22955 100644
--- a/drivers/md/raid5.h
+++ b/drivers/md/raid5.h
@@ -492,18 +492,27 @@ struct disk_info {
 #define HASH_MASK		(NR_HASH - 1)
 #define MAX_STRIPE_BATCH	8
 
-/* NOTE NR_STRIPE_HASH_LOCKS must remain below 64.
- * This is because we sometimes take all the spinlocks
- * and creating that much locking depth can cause
- * problems.
+/*
+ * The stripe cache hash is striped across a power-of-two number of spinlocks,
+ * chosen per array from the nr_stripe_hash_locks module parameter and stored
+ * in r5conf->nr_hash_locks (with the mask in r5conf->hash_locks_mask).  Sizing
+ * the locks per array means systems that do not tune it pay no extra memory
+ * beyond the historical default.
+ *
+ * NR_STRIPE_HASH_LOCKS_DEFAULT is that historical value, used when the module
+ * parameter is left alone.  NR_STRIPE_HASH_LOCKS_MAX bounds the count: taking
+ * all the hash locks at once in lock_all_device_hash_locks_irq(), plus
+ * device_lock, must keep the held lock count below MAX_LOCK_DEPTH (48) with
+ * lockdep enabled, and it also sizes the embedded/on-stack temp_inactive_list
+ * arrays.
  */
-#define NR_STRIPE_HASH_LOCKS 8
-#define STRIPE_HASH_LOCKS_MASK (NR_STRIPE_HASH_LOCKS - 1)
+#define NR_STRIPE_HASH_LOCKS_DEFAULT	8
+#define NR_STRIPE_HASH_LOCKS_MAX	32
 
 struct r5worker {
 	struct work_struct work;
 	struct r5worker_group *group;
-	struct list_head temp_inactive_list[NR_STRIPE_HASH_LOCKS];
+	struct list_head temp_inactive_list[NR_STRIPE_HASH_LOCKS_MAX];
 	bool working;
 };
 
@@ -570,7 +579,9 @@ struct raid5_percpu {
 struct r5conf {
 	struct hlist_head	*stripe_hashtbl;
 	/* only protect corresponding hash list and inactive_list */
-	spinlock_t		hash_locks[NR_STRIPE_HASH_LOCKS];
+	spinlock_t		*hash_locks;
+	int			nr_hash_locks;	 /* power of two, <= NR_STRIPE_HASH_LOCKS_MAX */
+	int			hash_locks_mask; /* nr_hash_locks - 1 */
 	struct mddev		*mddev;
 	int			chunk_sectors;
 	int			level, algorithm, rmw_level;
@@ -650,7 +661,7 @@ struct r5conf {
 	 * Free stripes pool
 	 */
 	atomic_t		active_stripes;
-	struct list_head	inactive_list[NR_STRIPE_HASH_LOCKS];
+	struct list_head	*inactive_list;
 
 	atomic_t		r5c_cached_full_stripes;
 	struct list_head	r5c_full_stripe_list;
@@ -675,7 +686,7 @@ struct r5conf {
 	 * the new thread here until we fully activate the array.
 	 */
 	struct md_thread __rcu	*thread;
-	struct list_head	temp_inactive_list[NR_STRIPE_HASH_LOCKS];
+	struct list_head	*temp_inactive_list;
 	struct r5worker_group	*worker_groups;
 	int			group_cnt;
 	int			worker_cnt_per_group;
-- 
2.43.0

