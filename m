Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F76C126BF1;
	Mon, 30 Jun 2025 06:11:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751263872; cv=none; b=AyvDPc/nb4Dyv9+nOtAo5Gs/0VY/UqZANRBzVRKT7NU8lVxleFBJm/MnLHQuoZTKLgF0GPkydKh9mZE3oGSMrKObHvqrhs7Rgm6aYKFMGShpVHBDMdcIPT/g9dY+Ei6mSqHjiqatCi2yUrOdNIaAJHXBjcrpEQbgihySMeEgtHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751263872; c=relaxed/simple;
	bh=Ryeg9tPQjRBtqEzhFgMzg9idJt4MwCNx+MOV14qyfRk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=euKrUSDxgovcKs02QJuEPdWP8b9aRO6LhdQ14V4rSM1F1HNQay5LBBcXT3cGiX/MMq7InS40rsRUP6VNWQYvjNFAPmKxQH1XJa1lrBdEEYMDmbUTx5SIyUWC6KlSQ6DYDM7lNwQo225SGyi69Lwc+uuWCrhQ2nbJosRP6E7WeHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MuX3CY1y; arc=none smtp.client-ip=209.85.216.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MuX3CY1y"
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-313bb9b2f5bso4190066a91.3;
        Sun, 29 Jun 2025 23:11:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751263869; x=1751868669; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mXWSUNDVrwzgye8WrpUxYrs0RsEUEhkGlaf8Xirky+w=;
        b=MuX3CY1y4YuLqnBgM1cTEBgwugXuIyPe7nhovXYrgaJ8I0Bvy/X6PoiWl2urU5kUFo
         W5VccUEXsTRIKKp1FZLk0WBSHgxgCeLkP6+jVPkd1Se+NU0yZZbmCVR0wVe2BZMD8ubu
         IROuIKneQFoyxdrD5JvXRk0FOd4Vt9d9nLqtk8+IhpBCHC/N+Y0KJ3NHt3JyaIk1wNcl
         HeRcShbroq0/GhjExhunVoUBT5eN3wuzBzDL6Hw4eymI7DTdHzVy/Y0VVerpYQ0MNY9l
         EvxFF1Gzl17QqVa+LEvBzCrs/tCnTfTsdi4TafzjQpiidZV+jiQt/OZpoGNXt38DtmO9
         PTOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751263869; x=1751868669;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mXWSUNDVrwzgye8WrpUxYrs0RsEUEhkGlaf8Xirky+w=;
        b=b4dWbm1ETpM8zX94MnpZ4I4LfU4Db+srBNnw1AAoIlA2rwPExGBOszk+t8vun7pRad
         i7PAA2O80ruIAQo9DsGUHZv2LwHF336EMDJDgDf79I3yQ2T0Ln3asjjMyCjHScLui86U
         43u0a3NY1lqMuQJ+nrr8cKhT36YjidGvP785Rp16nQqhZZZMu9MZejkmNJMEy/miMgCi
         CG8CyYD3lPA8+lbPOAFZBSjfvLj3/xn2vcQU6p1qeLFNpYXH3uY5sALmOP6lChLXQzBE
         oTk+4mAktdJ96CW2dbLwY4KyFwPHh3doTpuleSjNLz1hLTbkWGm/j12HrjOh49Y6VBhI
         kcOw==
X-Forwarded-Encrypted: i=1; AJvYcCWCgtC6/NtBaACPnJCmScfCTlXMiyuBF92U0WOLLPxJKEPKDnw8dZpctSicwj/Ci0vx36yLoZOCwLCaL+0=@vger.kernel.org
X-Gm-Message-State: AOJu0YxxpIh1utgbEQ6W56BdePvfXFLfu1Ayx4yHsa/649o7HPKn0YJK
	MnGT+3gPpNRVvNnYoLa2/uztc68t9A7hAG6o+5SKki1Bj0VckNDF6VBo
X-Gm-Gg: ASbGncsXWJkK65KlM3SHnojhDzsoYpyFT/lOzUKhuSp4SKR9PgCpd7rXNlw5I1mhcry
	0oapBL1LAigDhdvDfpwsgfvgHr3ziMK83VuAOOf40flrBwDVyfDLq5SxpR4biz1p/czix9aFSOm
	HJ9axulmaBt3kp4HWaE5QPXgPzlbvVG0bBdfhvNvtFAjt4/pBvz/3foDLS5diAtvi/atXkUNKCx
	4N9gFpdJqFrB355si6BomTE0YComW1XRy/2HzCazg4pM9/6iYzS59HSmx9Lx6tj5/eofHExRw5G
	G9PZR/sCXvpmp21x7cOn7947ZHBeCwHBnoInDhDRtQS3n5kAomx5J6tSA+uLRmXt6+qE1TYaiJe
	be7wShV1Ge+GlKEFynYQTQhv1f1CU
X-Google-Smtp-Source: AGHT+IEswSytuhmQ+YEegBCFz35d0mEST/hj6Ec+OA/gQDbzB2DBNjCGGiFWV+cPtZmqAbUgTBJMcQ==
X-Received: by 2002:a17:90b:1fc5:b0:311:ad7f:329c with SMTP id 98e67ed59e1d1-318c92ec020mr20097603a91.18.1751263869459;
        Sun, 29 Jun 2025 23:11:09 -0700 (PDT)
Received: from localhost.localdomain ([114.242.33.243])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-315f5382e87sm13343443a91.8.2025.06.29.23.11.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Jun 2025 23:11:09 -0700 (PDT)
From: Wang Jinchao <wangjinchao600@gmail.com>
To: Song Liu <song@kernel.org>,
	Yu Kuai <yukuai3@huawei.com>
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Wang Jinchao <wangjinchao600@gmail.com>
Subject: [PATCH v4 2/2] md/raid1: remove struct pool_info and related code
Date: Mon, 30 Jun 2025 14:10:43 +0800
Message-ID: <20250630061051.741660-3-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250630061051.741660-2-wangjinchao600@gmail.com>
References: <20250630061051.741660-1-wangjinchao600@gmail.com>
 <20250630061051.741660-2-wangjinchao600@gmail.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The struct pool_info was originally introduced mainly to support reshape
operations, serving as a parameter for mempool_init() when raid_disks
changes. Now that mempool_create_kmalloc_pool() is sufficient for this
purpose, struct pool_info and its related code are no longer needed.

Remove struct pool_info and all associated code.

Signed-off-by: Wang Jinchao <wangjinchao600@gmail.com>
---
 drivers/md/raid1.c | 49 +++++++++++++---------------------------------
 drivers/md/raid1.h | 20 -------------------
 2 files changed, 14 insertions(+), 55 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 66726448d97c..90ac305971ee 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -127,10 +127,9 @@ static inline struct r1bio *get_resync_r1bio(struct bio *bio)
 	return get_resync_pages(bio)->raid_bio;
 }
 
-static void * r1bio_pool_alloc(gfp_t gfp_flags, void *data)
+static void *r1bio_pool_alloc(gfp_t gfp_flags, struct r1conf *conf)
 {
-	struct pool_info *pi = data;
-	int size = offsetof(struct r1bio, bios[pi->raid_disks]);
+	int size = offsetof(struct r1bio, bios[conf->raid_disks * 2]);
 
 	/* allocate a r1bio with room for raid_disks entries in the bios array */
 	return kzalloc(size, gfp_flags);
@@ -145,18 +144,18 @@ static void * r1bio_pool_alloc(gfp_t gfp_flags, void *data)
 
 static void * r1buf_pool_alloc(gfp_t gfp_flags, void *data)
 {
-	struct pool_info *pi = data;
+	struct r1conf *conf = data;
 	struct r1bio *r1_bio;
 	struct bio *bio;
 	int need_pages;
 	int j;
 	struct resync_pages *rps;
 
-	r1_bio = r1bio_pool_alloc(gfp_flags, pi);
+	r1_bio = r1bio_pool_alloc(gfp_flags, conf);
 	if (!r1_bio)
 		return NULL;
 
-	rps = kmalloc_array(pi->raid_disks, sizeof(struct resync_pages),
+	rps = kmalloc_array(conf->raid_disks * 2, sizeof(struct resync_pages),
 			    gfp_flags);
 	if (!rps)
 		goto out_free_r1bio;
@@ -164,7 +163,7 @@ static void * r1buf_pool_alloc(gfp_t gfp_flags, void *data)
 	/*
 	 * Allocate bios : 1 for reading, n-1 for writing
 	 */
-	for (j = pi->raid_disks ; j-- ; ) {
+	for (j = conf->raid_disks * 2; j-- ; ) {
 		bio = bio_kmalloc(RESYNC_PAGES, gfp_flags);
 		if (!bio)
 			goto out_free_bio;
@@ -177,11 +176,11 @@ static void * r1buf_pool_alloc(gfp_t gfp_flags, void *data)
 	 * If this is a user-requested check/repair, allocate
 	 * RESYNC_PAGES for each bio.
 	 */
-	if (test_bit(MD_RECOVERY_REQUESTED, &pi->mddev->recovery))
-		need_pages = pi->raid_disks;
+	if (test_bit(MD_RECOVERY_REQUESTED, &conf->mddev->recovery))
+		need_pages = conf->raid_disks * 2;
 	else
 		need_pages = 1;
-	for (j = 0; j < pi->raid_disks; j++) {
+	for (j = 0; j < conf->raid_disks * 2; j++) {
 		struct resync_pages *rp = &rps[j];
 
 		bio = r1_bio->bios[j];
@@ -207,7 +206,7 @@ static void * r1buf_pool_alloc(gfp_t gfp_flags, void *data)
 		resync_free_pages(&rps[j]);
 
 out_free_bio:
-	while (++j < pi->raid_disks) {
+	while (++j < conf->raid_disks * 2) {
 		bio_uninit(r1_bio->bios[j]);
 		kfree(r1_bio->bios[j]);
 	}
@@ -220,12 +219,12 @@ static void * r1buf_pool_alloc(gfp_t gfp_flags, void *data)
 
 static void r1buf_pool_free(void *__r1_bio, void *data)
 {
-	struct pool_info *pi = data;
+	struct r1conf *conf = data;
 	int i;
 	struct r1bio *r1bio = __r1_bio;
 	struct resync_pages *rp = NULL;
 
-	for (i = pi->raid_disks; i--; ) {
+	for (i = conf->raid_disks * 2; i--; ) {
 		rp = get_resync_pages(r1bio->bios[i]);
 		resync_free_pages(rp);
 		bio_uninit(r1bio->bios[i]);
@@ -2745,7 +2744,7 @@ static int init_resync(struct r1conf *conf)
 	BUG_ON(mempool_initialized(&conf->r1buf_pool));
 
 	return mempool_init(&conf->r1buf_pool, buffs, r1buf_pool_alloc,
-			    r1buf_pool_free, conf->poolinfo);
+			    r1buf_pool_free, conf);
 }
 
 static struct r1bio *raid1_alloc_init_r1buf(struct r1conf *conf)
@@ -2755,7 +2754,7 @@ static struct r1bio *raid1_alloc_init_r1buf(struct r1conf *conf)
 	struct bio *bio;
 	int i;
 
-	for (i = conf->poolinfo->raid_disks; i--; ) {
+	for (i = conf->raid_disks * 2; i--; ) {
 		bio = r1bio->bios[i];
 		rps = bio->bi_private;
 		bio_reset(bio, NULL, 0);
@@ -3119,11 +3118,6 @@ static struct r1conf *setup_conf(struct mddev *mddev)
 	if (!conf->tmppage)
 		goto abort;
 
-	conf->poolinfo = kzalloc(sizeof(*conf->poolinfo), GFP_KERNEL);
-	if (!conf->poolinfo)
-		goto abort;
-	conf->poolinfo->raid_disks = mddev->raid_disks * 2;
-
 	conf->r1bio_pool = mempool_create_kmalloc_pool(NR_RAID_BIOS,
 				offsetof(struct r1bio, bios[mddev->raid_disks * 2]));
 	if (!conf->r1bio_pool)
@@ -3133,8 +3127,6 @@ static struct r1conf *setup_conf(struct mddev *mddev)
 	if (err)
 		goto abort;
 
-	conf->poolinfo->mddev = mddev;
-
 	err = -EINVAL;
 	spin_lock_init(&conf->device_lock);
 	conf->raid_disks = mddev->raid_disks;
@@ -3200,7 +3192,6 @@ static struct r1conf *setup_conf(struct mddev *mddev)
 		mempool_destroy(conf->r1bio_pool);
 		kfree(conf->mirrors);
 		safe_put_page(conf->tmppage);
-		kfree(conf->poolinfo);
 		kfree(conf->nr_pending);
 		kfree(conf->nr_waiting);
 		kfree(conf->nr_queued);
@@ -3313,7 +3304,6 @@ static void raid1_free(struct mddev *mddev, void *priv)
 	mempool_destroy(conf->r1bio_pool);
 	kfree(conf->mirrors);
 	safe_put_page(conf->tmppage);
-	kfree(conf->poolinfo);
 	kfree(conf->nr_pending);
 	kfree(conf->nr_waiting);
 	kfree(conf->nr_queued);
@@ -3367,7 +3357,6 @@ static int raid1_reshape(struct mddev *mddev)
 	 * devices have the higher raid_disk numbers.
 	 */
 	mempool_t *newpool, *oldpool;
-	struct pool_info *newpoolinfo;
 	struct raid1_info *newmirrors;
 	struct r1conf *conf = mddev->private;
 	int cnt, raid_disks;
@@ -3398,23 +3387,15 @@ static int raid1_reshape(struct mddev *mddev)
 			return -EBUSY;
 	}
 
-	newpoolinfo = kmalloc(sizeof(*newpoolinfo), GFP_KERNEL);
-	if (!newpoolinfo)
-		return -ENOMEM;
-	newpoolinfo->mddev = mddev;
-	newpoolinfo->raid_disks = raid_disks * 2;
-
 	newpool = mempool_create_kmalloc_pool(NR_RAID_BIOS,
 			offsetof(struct r1bio, bios[raid_disks * 2]));
 	if (!newpool) {
-		kfree(newpoolinfo);
 		return -ENOMEM;
 	}
 	newmirrors = kzalloc(array3_size(sizeof(struct raid1_info),
 					 raid_disks, 2),
 			     GFP_KERNEL);
 	if (!newmirrors) {
-		kfree(newpoolinfo);
 		mempool_destroy(newpool);
 		return -ENOMEM;
 	}
@@ -3440,8 +3421,6 @@ static int raid1_reshape(struct mddev *mddev)
 	}
 	kfree(conf->mirrors);
 	conf->mirrors = newmirrors;
-	kfree(conf->poolinfo);
-	conf->poolinfo = newpoolinfo;
 
 	spin_lock_irqsave(&conf->device_lock, flags);
 	mddev->degraded += (raid_disks - conf->raid_disks);
diff --git a/drivers/md/raid1.h b/drivers/md/raid1.h
index 652c347b1a70..d236ef179cfb 100644
--- a/drivers/md/raid1.h
+++ b/drivers/md/raid1.h
@@ -49,22 +49,6 @@ struct raid1_info {
 	sector_t	seq_start;
 };
 
-/*
- * memory pools need a pointer to the mddev, so they can force an unplug
- * when memory is tight, and a count of the number of drives that the
- * pool was allocated for, so they know how much to allocate and free.
- * mddev->raid_disks cannot be used, as it can change while a pool is active
- * These two datums are stored in a kmalloced struct.
- * The 'raid_disks' here is twice the raid_disks in r1conf.
- * This allows space for each 'real' device can have a replacement in the
- * second half of the array.
- */
-
-struct pool_info {
-	struct mddev *mddev;
-	int	raid_disks;
-};
-
 struct r1conf {
 	struct mddev		*mddev;
 	struct raid1_info	*mirrors;	/* twice 'raid_disks' to
@@ -114,10 +98,6 @@ struct r1conf {
 	 */
 	int			recovery_disabled;
 
-	/* poolinfo contains information about the content of the
-	 * mempools - it changes when the array grows or shrinks
-	 */
-	struct pool_info	*poolinfo;
 	mempool_t		*r1bio_pool;
 	mempool_t		r1buf_pool;
 
-- 
2.43.0

