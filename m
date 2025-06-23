Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE1952550A4;
	Mon, 23 Jun 2025 12:06:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750680400; cv=none; b=D0NYxhnQh5ddXAw0IbSpE9qdcS+AFb7+jo29+dYsRyXX8NSSzRmDy1+F1CSfqWkNBZK0+jaQhf7VsxDOveXjtJ5rcV9BmGkqRtmO9eERkkJGLa4M8V9rDoT9MkG5BmbnnUHZmrlv6/trPhM6HRBi/FquGmcpgCWXUiH2vy0gw8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750680400; c=relaxed/simple;
	bh=xQjVWw2c4d7dMWIj080c4MnJJ8GHOujkD0nOe+S6Ml8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZaIFzv9C+TMp3kxfG6/19BoRBmOnWRKcRWsJxDz9N+zzWWqVxdpHUgpHtVB1qb3uoLcE1UVAW78AUKDZULE89BAku9FxLXwINNPvmst26WpPNcLMLgFYXt6JG+CkRcrCiBbSjCpQ/FG1Rq6TmG9cs32k9a6X0otjItipIAykyzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jep7js21; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jep7js21"
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-7490cb9a892so1680573b3a.0;
        Mon, 23 Jun 2025 05:06:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750680398; x=1751285198; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=78wyx26ovDhxzLyYuDnhW5f1Y6E471SRtmIlOKvD4Tg=;
        b=jep7js21ERx0k8cM1kyOcA/x4FY9KaliMWVcDBT4V4tJdq1tN+tOqmIbIxves5V2a3
         chQ/hdDaU53A6oAsSclGBEKskMfPBPRSUgmhRUkKDPyZnyfC99eWly4yP8f/OXckvXyS
         HDfUWNb5B2HA9X3BMsDOgSydPqhiUxhGGWxK0uOYtnxLmbh42p+jNPoo4J5yKA9Og38U
         +Na3wkf9iBgjfGajRZGmmnYazXjIC+Iq/P4Mw9ZhA1E/14axu9aHIZc9rCSYSKT/39bQ
         24XMYSLNHPym6MnyvxOK61hKU3mfWnY9SkeyZQhTegU56OhLy1ldVNvl0YfHXlO7K/D+
         klbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750680398; x=1751285198;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=78wyx26ovDhxzLyYuDnhW5f1Y6E471SRtmIlOKvD4Tg=;
        b=eqBFS5n7efti3qP7uQSv5J4zXIvNTEk04S2/TnJugiYLwbA3h1vsOpLexPB8tEM98X
         zcCEHzDN4cY31z54ajFOqAhaSjMvYDNb080FbUkVgpP2PhRo1OTp916N8tGMjXfcUUin
         5VT0ybbeTH5l1sg7gaUcxQ8Ex39YPPdMoyVKRDWsmmEjbumWoKOQM54sJj3eA1gLQzbI
         Isepny64pCJGn2Bo6Lks+1AxaIA88TchKw1WeYJB3zZSrkBA9Vm1g151Mu6btFmW/Coa
         YgKU9gguIHZaAyW6SkO0vEaKgtbppi6VD8FMkozpWYPHb6xD01DzMe7Spn8SNA9IITmk
         IlxA==
X-Forwarded-Encrypted: i=1; AJvYcCU0OpVSGNrIRhDfm6KVnSYoxz+MCui4EaO8ZbXMqLJ9QdPCvgmhDo+NNFcVdn9RqEeeEGihwH4evz+4wAA=@vger.kernel.org, AJvYcCXmJPPbdZO/U11NikvLUOcMd2nWj44Z2b9aPncXMfu271k3OV5fDNQiK7OKOfKykAiM2B+0KwD1AldNbA==@vger.kernel.org
X-Gm-Message-State: AOJu0YwIhKWZwu6Tn4y0ps31373iQtp3R2osPkE/9M5bevgw442JtsBi
	IbbR3zzj1g9EaT6e/hn04OHwLWohN7aHCkJrO4noNdnesyzPARfIty2g
X-Gm-Gg: ASbGncsk2qjwiJ5KsqIgEMK3PJCYBZ9G4pBCqDTHjHQJe4MAjVfYTKtJeLOwsWyqyVc
	2HvExw+C26vhViR0G8PkLkg2NPT9Y6PQHahaVWM6RLXu3zDZR/wedZ1YS6bkYlFGftFkLU9FsqB
	f9hXvrPKND09wrjI9qymTUjlZxroMVE4p2VtlnjdeoKXPqpaPiXbwELJv68Cfz5flo22Idy+1iq
	9JpFcs81qDzhi7H92bLOdwemUB+mly/86L5X0jNjCu6ocFDHXDIzFBOk+oje4CJ0nLT7wP+DRHI
	srDR3pJ1vgeQB+UnYw2agy4vXSULLq6xowFhiXTHx0omLlMYo/ki6fYBoidWeGiSFMgRsxf94Wh
	8ej4h4pSllQ87Rjygae60gUTEbW0s
X-Google-Smtp-Source: AGHT+IGOnNlQhoeZPVsH2QvzRaagWBuqXmyC3C10PwarXg0c3/jSDHFV6fB3OsHaKGli5GtSz7U4aA==
X-Received: by 2002:a05:6a00:398f:b0:748:e4af:9c54 with SMTP id d2e1a72fcca58-7490d780fbemr17701103b3a.6.1750680397970;
        Mon, 23 Jun 2025 05:06:37 -0700 (PDT)
Received: from localhost.localdomain ([114.242.33.243])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7490a6ba142sm8133637b3a.167.2025.06.23.05.06.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Jun 2025 05:06:37 -0700 (PDT)
From: Wang Jinchao <wangjinchao600@gmail.com>
To: Song Liu <song@kernel.org>,
	Yu Kuai <yukuai3@huawei.com>
Cc: Wang Jinchao <wangjinchao600@gmail.com>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/2] md/raid1: remove struct pool_info and related code
Date: Mon, 23 Jun 2025 20:06:03 +0800
Message-ID: <20250623120613.543079-3-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250623120613.543079-2-wangjinchao600@gmail.com>
References: <20250623120613.543079-1-wangjinchao600@gmail.com>
 <20250623120613.543079-2-wangjinchao600@gmail.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The struct pool_info was originally introduced mainly to support reshape
operations, serving as a parameter for mempool_init() when raid_disks changes.
Now that mempool_create_kmalloc_pool() is sufficient for this purpose,
struct pool_info and its related code are no longer needed.

Remove struct pool_info and all associated code.

Signed-off-by: Wang Jinchao <wangjinchao600@gmail.com>
---
 drivers/md/raid1.c | 49 +++++++++++++---------------------------------
 drivers/md/raid1.h | 20 -------------------
 2 files changed, 14 insertions(+), 55 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 7753010841b2..0b7ff7b4a579 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -127,10 +127,9 @@ static inline struct r1bio *get_resync_r1bio(struct bio *bio)
 	return get_resync_pages(bio)->raid_bio;
 }
 
-static void * r1bio_pool_alloc(gfp_t gfp_flags, void *data)
+static void * r1bio_pool_alloc(gfp_t gfp_flags, struct r1conf *conf)
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
 			offsetof(struct r1bio, bios[mddev->raid_disks *2]));
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
 			offsetof(struct r1bio, bios[raid_disks *2]));
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

