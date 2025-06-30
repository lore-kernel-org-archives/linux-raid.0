Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83CCE1E7C24;
	Mon, 30 Jun 2025 06:11:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751263869; cv=none; b=YHF+UUnpMjFoCTm+Iwq5rExLz0sloE4fT8aHN0+RvTSZUos+PcXjeBU6TArnQlOssGVPet1+oOuhotGOwDT422ejTrP2Ek6/OF4Lc2tIf+mbY/UBeLCAsptI0piV0/eUS9OK1XG+/8qItsHagAApaoC8RjDliZHxZxRRbPgu6DU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751263869; c=relaxed/simple;
	bh=37qarNAdEfxZ5j1sAUyS2vFni1rH5bajyciJflWlc90=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=syEDoNdxexIGcr1DODqNHO8MkIoJo1MdZVgatwTVXnj5Mgf2gBbJ0sS07ANiYNyph4qlJlp0f9hq16XGGbIcmDu7IGldXvL41NqEelfUyEEGT91KsHNMVRG0ZFoO/VOOSVC+FXlXubPrYC6Z/Hkl7PtYG6LeaUTjLZpaA0h0fJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ePi00a43; arc=none smtp.client-ip=209.85.216.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ePi00a43"
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-3138e64b42aso4561613a91.0;
        Sun, 29 Jun 2025 23:11:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751263867; x=1751868667; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=79acPDEhZKtGsy1Sqe9GF4uQZ/aCim1pfoiX7780Cag=;
        b=ePi00a43PnvYfkiE9cWrvNFLzWRRiVCCtvetyMYvOfabgP72afJ+a46oZShRv16ujA
         fcIPxv0heD7e9tNFWwgX84LLfX/satAO7eaEenVcrc+9RrFtmgVplTwcOY5DM05jwd0T
         ywfohAqECrHST4/izyj1qp1Kg3XTuXIxW0CFAdxGLbPe5HgbYuBNCeohFdkDaGvqjgpy
         87vL1jCiEfcMQ62AOJLENEDw00Q5QwN9UFL1nbj8F/WIcgBxBXPPcp29t4jP+YDqkGY1
         +y8wzs8ReQBcof3oN+bNGYZ3hnQyQBHQaBtgf8Ii+cCoMlt53KbAfIoJjCF9fP+v4xPJ
         18yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751263867; x=1751868667;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=79acPDEhZKtGsy1Sqe9GF4uQZ/aCim1pfoiX7780Cag=;
        b=xHtG5czr+5DIhZmu5R1njqcWKqS6lTPlsjs3UzEh+KQYQyPW9yiD5pVKrqNnsJ38Pb
         J471vAZeCNYDN1FWjQEMGXS2M8O0m5+8nnVdcAu57ew7yZJL+p//9eCIEkxhCjE7GDgh
         t5NBLrpPpB3jSSsWWtjQcN1kpjevjdYhGURRQW+6J1zDx/AFXZQVsjzcneflUzWGwEuD
         x9+8FQsPDguhsNzHCPQOg4TPkouE0Y8Hx8wgdpp1mqT9RKoN9Cg92hEgSpid/LQRoKTg
         OoG0/hPHgqDTOKMNRrm4OJTWCMHcbKx2uUbXsqozyztZ6jSKrJvkRGYbVz00YWfOpFHZ
         iXiQ==
X-Forwarded-Encrypted: i=1; AJvYcCVxF6jINUoBtzhs6VgqkG5Yxl5qpcukpHH4fqb1t2YintKgmBVrZwAwXc5GbZoiXQOT03XQP10aTnPQWiM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz0j9XFbG86N2ibAt72JfpZMTf2KaiEAwd7fGzI3fdaNAQMssoO
	IDZP7gkerwqLRZehVfcDXLux6vQRtbcmB8LHKftu4U0RC3Uu2SBPgyAQ
X-Gm-Gg: ASbGncsYHVwsEUbjyp77l7RLAdvBpUuUrB+SiC6I0WLwD2PgZlCFii/SgWC7RxyXgNj
	pTAr337u1SXPor4+Ftyezz8Ih4cksaSs7ad84ezYzuBGK9orFIiXPANenndjERJhpV++PKbW5Kn
	+l8QOSHZnS+/PGYskohDP+x/ntYeCjZkvXmo7aiO8ey4EXWDV6sT0fOQ5SDhJkJrd2nqqjjX43s
	HG5w7anYG4F65tief4tBx2oNZerYP3VXNUDsNmTItOrKFeuTA3AMYgD2crHvWpu9UCQobHmyKW4
	zOEbcHDrNC+MIzcYvNQVoPp5Z6405PsVGVvrwUI7+y3g4NS/ugXvX9YtvzIs3Uq4uKz63AwCTce
	zHnR6a2Trk1S502w57jdBCFJ+TMDw
X-Google-Smtp-Source: AGHT+IGImri2dgNuUY/Pt+54qvsi1LpfyMQE1caLF1NyPoqTyJ7PSXhdwTzMclSM/Z6WylnIfrRxtw==
X-Received: by 2002:a17:90a:f944:b0:311:9c1f:8516 with SMTP id 98e67ed59e1d1-318c90f75a9mr17697957a91.15.1751263866621;
        Sun, 29 Jun 2025 23:11:06 -0700 (PDT)
Received: from localhost.localdomain ([114.242.33.243])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-315f5382e87sm13343443a91.8.2025.06.29.23.11.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Jun 2025 23:11:06 -0700 (PDT)
From: Wang Jinchao <wangjinchao600@gmail.com>
To: Song Liu <song@kernel.org>,
	Yu Kuai <yukuai3@huawei.com>
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Wang Jinchao <wangjinchao600@gmail.com>
Subject: [PATCH v4 1/2] md/raid1: change r1conf->r1bio_pool to a pointer type
Date: Mon, 30 Jun 2025 14:10:42 +0800
Message-ID: <20250630061051.741660-2-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250630061051.741660-1-wangjinchao600@gmail.com>
References: <20250630061051.741660-1-wangjinchao600@gmail.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In raid1_reshape(), newpool is a stack variable.
mempool_init() initializes newpool->wait with the stack address.
After assigning newpool to conf->r1bio_pool, the wait queue
need to be reinitialized, which is not ideal.

Change raid1_conf->r1bio_pool to a pointer type and
replace mempool_init() with mempool_create_kmalloc_pool() to
avoid referencing a stack-based wait queue.

Signed-off-by: Wang Jinchao <wangjinchao600@gmail.com>
---
 drivers/md/raid1.c | 37 ++++++++++++++++---------------------
 drivers/md/raid1.h |  2 +-
 2 files changed, 17 insertions(+), 22 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index fd4ce2a4136f..66726448d97c 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -255,7 +255,7 @@ static void free_r1bio(struct r1bio *r1_bio)
 	struct r1conf *conf = r1_bio->mddev->private;
 
 	put_all_bios(conf, r1_bio);
-	mempool_free(r1_bio, &conf->r1bio_pool);
+	mempool_free(r1_bio, conf->r1bio_pool);
 }
 
 static void put_buf(struct r1bio *r1_bio)
@@ -1305,9 +1305,8 @@ alloc_r1bio(struct mddev *mddev, struct bio *bio)
 	struct r1conf *conf = mddev->private;
 	struct r1bio *r1_bio;
 
-	r1_bio = mempool_alloc(&conf->r1bio_pool, GFP_NOIO);
-	/* Ensure no bio records IO_BLOCKED */
-	memset(r1_bio->bios, 0, conf->raid_disks * sizeof(r1_bio->bios[0]));
+	r1_bio = mempool_alloc(conf->r1bio_pool, GFP_NOIO);
+	memset(r1_bio, 0, offsetof(struct r1bio, bios[conf->raid_disks * 2]));
 	init_r1bio(r1_bio, mddev, bio);
 	return r1_bio;
 }
@@ -3124,9 +3123,10 @@ static struct r1conf *setup_conf(struct mddev *mddev)
 	if (!conf->poolinfo)
 		goto abort;
 	conf->poolinfo->raid_disks = mddev->raid_disks * 2;
-	err = mempool_init(&conf->r1bio_pool, NR_RAID_BIOS, r1bio_pool_alloc,
-			   rbio_pool_free, conf->poolinfo);
-	if (err)
+
+	conf->r1bio_pool = mempool_create_kmalloc_pool(NR_RAID_BIOS,
+				offsetof(struct r1bio, bios[mddev->raid_disks * 2]));
+	if (!conf->r1bio_pool)
 		goto abort;
 
 	err = bioset_init(&conf->bio_split, BIO_POOL_SIZE, 0, 0);
@@ -3197,7 +3197,7 @@ static struct r1conf *setup_conf(struct mddev *mddev)
 
  abort:
 	if (conf) {
-		mempool_exit(&conf->r1bio_pool);
+		mempool_destroy(conf->r1bio_pool);
 		kfree(conf->mirrors);
 		safe_put_page(conf->tmppage);
 		kfree(conf->poolinfo);
@@ -3310,7 +3310,7 @@ static void raid1_free(struct mddev *mddev, void *priv)
 {
 	struct r1conf *conf = priv;
 
-	mempool_exit(&conf->r1bio_pool);
+	mempool_destroy(conf->r1bio_pool);
 	kfree(conf->mirrors);
 	safe_put_page(conf->tmppage);
 	kfree(conf->poolinfo);
@@ -3366,17 +3366,13 @@ static int raid1_reshape(struct mddev *mddev)
 	 * At the same time, we "pack" the devices so that all the missing
 	 * devices have the higher raid_disk numbers.
 	 */
-	mempool_t newpool, oldpool;
+	mempool_t *newpool, *oldpool;
 	struct pool_info *newpoolinfo;
 	struct raid1_info *newmirrors;
 	struct r1conf *conf = mddev->private;
 	int cnt, raid_disks;
 	unsigned long flags;
 	int d, d2;
-	int ret;
-
-	memset(&newpool, 0, sizeof(newpool));
-	memset(&oldpool, 0, sizeof(oldpool));
 
 	/* Cannot change chunk_size, layout, or level */
 	if (mddev->chunk_sectors != mddev->new_chunk_sectors ||
@@ -3408,18 +3404,18 @@ static int raid1_reshape(struct mddev *mddev)
 	newpoolinfo->mddev = mddev;
 	newpoolinfo->raid_disks = raid_disks * 2;
 
-	ret = mempool_init(&newpool, NR_RAID_BIOS, r1bio_pool_alloc,
-			   rbio_pool_free, newpoolinfo);
-	if (ret) {
+	newpool = mempool_create_kmalloc_pool(NR_RAID_BIOS,
+			offsetof(struct r1bio, bios[raid_disks * 2]));
+	if (!newpool) {
 		kfree(newpoolinfo);
-		return ret;
+		return -ENOMEM;
 	}
 	newmirrors = kzalloc(array3_size(sizeof(struct raid1_info),
 					 raid_disks, 2),
 			     GFP_KERNEL);
 	if (!newmirrors) {
 		kfree(newpoolinfo);
-		mempool_exit(&newpool);
+		mempool_destroy(newpool);
 		return -ENOMEM;
 	}
 
@@ -3428,7 +3424,6 @@ static int raid1_reshape(struct mddev *mddev)
 	/* ok, everything is stopped */
 	oldpool = conf->r1bio_pool;
 	conf->r1bio_pool = newpool;
-	init_waitqueue_head(&conf->r1bio_pool.wait);
 
 	for (d = d2 = 0; d < conf->raid_disks; d++) {
 		struct md_rdev *rdev = conf->mirrors[d].rdev;
@@ -3460,7 +3455,7 @@ static int raid1_reshape(struct mddev *mddev)
 	set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
 	md_wakeup_thread(mddev->thread);
 
-	mempool_exit(&oldpool);
+	mempool_destroy(oldpool);
 	return 0;
 }
 
diff --git a/drivers/md/raid1.h b/drivers/md/raid1.h
index 33f318fcc268..652c347b1a70 100644
--- a/drivers/md/raid1.h
+++ b/drivers/md/raid1.h
@@ -118,7 +118,7 @@ struct r1conf {
 	 * mempools - it changes when the array grows or shrinks
 	 */
 	struct pool_info	*poolinfo;
-	mempool_t		r1bio_pool;
+	mempool_t		*r1bio_pool;
 	mempool_t		r1buf_pool;
 
 	struct bio_set		bio_split;
-- 
2.43.0

