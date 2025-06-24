Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3624921771B;
	Tue, 24 Jun 2025 01:56:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750730188; cv=none; b=mxuhXyn0jxe9t1KXuN36J+qRjmQ6ftbNfwGSL+Y2AAMbEZ1ow7UKO+e8joo8binmuR7366xLsOzL/QGgSgSfkB1SfKLFYvENKTcBtcBRPLdXWoqcE05o+hSz3Gdw5oXodi3fE39G3dP/UcvCcB2HP8AU/6CzhWbXgyOqg+qbjJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750730188; c=relaxed/simple;
	bh=Gh3awMoUBZrCo6y1ZgQnPQG9Q97cAv+FdkcqhK9kW7I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oBL7ALlhEMMP+aqFDABKR4tywH0mTArwawqbYBIGLIijQyhl4d52PML8ZxXRXN/fs2cBbAILRXDwMCxXc9RCFfOQ1vdeqXjtcN3DcZhhIzqpMFWpIMokQ5sgnc95gDrbeGErAmxFkPbWjhfdHNQmADjw4+BA7oBMxyiyeNyTPdQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Zf/A5xOH; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Zf/A5xOH"
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-747fc7506d4so3794607b3a.0;
        Mon, 23 Jun 2025 18:56:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750730187; x=1751334987; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nGECGDsw74tlByp4P/V/QPSzg4+M8giVC83gWOdTac4=;
        b=Zf/A5xOH1bxIeW9tdHYIyHiLTeh+10Eer0vmiZISYzZCgTg5OO+kqY54gy/ij2Bj42
         pOVONOGwYGxVLHFCtAcrthV+8yiF9RwFoPmFeWPh7n5HodPgUv2/QIQX0Qi3D2gP3Hep
         ZpaHcRXGmuuJ+7IpFaVxcOfT8q9l+Y8gihyrhwlxhQyN43XSVfIV8xw61GCxzsqIO/rU
         ZF2XoBriq5p2ylIyMFi1U/kjqXew0VVn03CGf9WJE5D1Li36Oe0TsAfjQpIufiz/APh9
         CC6EjGR/lHWxCzZPKOQh3p+e+tJbM3kkhmODfe+hov5B9HcPLpUIMoXf+yFAIRv1Pisp
         5W4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750730187; x=1751334987;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nGECGDsw74tlByp4P/V/QPSzg4+M8giVC83gWOdTac4=;
        b=C+DIYGPcSDchhCIkVgfuoCaRGTpgPDq1IKny6ZuD5y6dAvxuMQt2J6swTGuw+YymyU
         /FPxWZsgmBlQtdUmwvRkGbrVgLNZgoXZGqtBXkGo+j6NYirZqo1PUdEJ4Qa/dRR5aEMN
         Hi+O4gbiL09niYNuat6xLvbp314KAERCMhu8iMLJZs33+JEeDq0rOgsnsT0LXzYWpAnH
         1mKe+LkH2T7M4CnXk1ExifG5ZxsBdVPk7rmB3FtpLNpIbeTJdyKK9F3oiyn60iXI029y
         eLRJhrjtoxr3wO0x447iNK2uLPqhI9xIBs0R6XhFRr1vUZY1G7ng+EzfrKgpgIisOta1
         cQJQ==
X-Forwarded-Encrypted: i=1; AJvYcCVcqsRUzOUc89Osvmub9ROlVWiwfYSSaAX6Z+SKkQXbCFpsNn5iGyKb9eGdNgX5fzhtjNI/+XHxI+QPlqU=@vger.kernel.org, AJvYcCXA/wsFzMKloRgQ0Cv+Nrj/wd71pu0tI0XNjY5QW/pWMPFBE4aVi/c2bSFvTbrxhP+acVdfZFouSqKn7A==@vger.kernel.org
X-Gm-Message-State: AOJu0YzOMR5kuKIkrodT8I5qEey6OKZ7OrS6TAKN6GW7CCcGg26WF+gd
	9oG83idIeyzNpeaclIy30QkeW0obMuDtd3Zb17b1x5+73cdqX3hxkmCseJHXQWJ2
X-Gm-Gg: ASbGncuHrG+7CDPPGy3xkyAnCNh3dw81bX26ma66IecgLuupLsaj56MQjJ0a4A5ZF3h
	AW63+52qr8gzssptDqwFV6xpkxLh69u+iuYYXG5WYrSYpYwRLpfjIilY5BYZ7S+C2zINiCgF7M4
	UymcjIlL9/gZtJVVfTRQBzR7uEC1qlbi1+q9O+cf6y/1mK4B9nkizFh1xs8VMmTDxg/C7HX4LwI
	5yRem50V3BNkmNS1DcXoVRQG0Fv7P43rCxI9KXKOQdExBCm9vVaekJL95lEUQU21Naoxk5Gh3ky
	mf+azovgWhmH8vmLKgcFhKldTFqZuoGoBbMyDl5Qdsy/LMjDDBXlBdPmvWJRmZKT6eO0qfqFfYN
	aLlNVwa08y8dIrn1C8+B5O4ovgjJKx+5r+/fxjtQ=
X-Google-Smtp-Source: AGHT+IHr1n8UAa82Jpy3IrsaZ9fGecSMDn6ABQzxE6IffovLN7VzpiFixj92eTRDYLBbbj12bTaSOQ==
X-Received: by 2002:a05:6a21:328c:b0:215:f6ab:cf77 with SMTP id adf61e73a8af0-22026f66c17mr22603736637.23.1750730186444;
        Mon, 23 Jun 2025 18:56:26 -0700 (PDT)
Received: from localhost.localdomain ([114.242.33.243])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-749c8872629sm425424b3a.164.2025.06.23.18.56.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Jun 2025 18:56:26 -0700 (PDT)
From: Wang Jinchao <wangjinchao600@gmail.com>
To: Song Liu <song@kernel.org>,
	Yu Kuai <yukuai3@huawei.com>
Cc: Wang Jinchao <wangjinchao600@gmail.com>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 2/2] md/raid1: remove struct pool_info and related code
Date: Tue, 24 Jun 2025 09:55:53 +0800
Message-ID: <20250624015604.70309-3-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250624015604.70309-2-wangjinchao600@gmail.com>
References: <20250624015604.70309-1-wangjinchao600@gmail.com>
 <20250624015604.70309-2-wangjinchao600@gmail.com>
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
index 8249cbb89fec..3a31e230727c 100644
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
@@ -3120,11 +3119,6 @@ static struct r1conf *setup_conf(struct mddev *mddev)
 	if (!conf->tmppage)
 		goto abort;
 
-	conf->poolinfo = kzalloc(sizeof(*conf->poolinfo), GFP_KERNEL);
-	if (!conf->poolinfo)
-		goto abort;
-	conf->poolinfo->raid_disks = mddev->raid_disks * 2;
-
 	r1bio_size = offsetof(struct r1bio, bios[mddev->raid_disks * 2]);
 	conf->r1bio_pool = mempool_create_kmalloc_pool(NR_RAID_BIOS, r1bio_size);
 	if (!conf->r1bio_pool)
@@ -3134,8 +3128,6 @@ static struct r1conf *setup_conf(struct mddev *mddev)
 	if (err)
 		goto abort;
 
-	conf->poolinfo->mddev = mddev;
-
 	err = -EINVAL;
 	spin_lock_init(&conf->device_lock);
 	conf->raid_disks = mddev->raid_disks;
@@ -3201,7 +3193,6 @@ static struct r1conf *setup_conf(struct mddev *mddev)
 		mempool_destroy(conf->r1bio_pool);
 		kfree(conf->mirrors);
 		safe_put_page(conf->tmppage);
-		kfree(conf->poolinfo);
 		kfree(conf->nr_pending);
 		kfree(conf->nr_waiting);
 		kfree(conf->nr_queued);
@@ -3314,7 +3305,6 @@ static void raid1_free(struct mddev *mddev, void *priv)
 	mempool_destroy(conf->r1bio_pool);
 	kfree(conf->mirrors);
 	safe_put_page(conf->tmppage);
-	kfree(conf->poolinfo);
 	kfree(conf->nr_pending);
 	kfree(conf->nr_waiting);
 	kfree(conf->nr_queued);
@@ -3368,7 +3358,6 @@ static int raid1_reshape(struct mddev *mddev)
 	 * devices have the higher raid_disk numbers.
 	 */
 	mempool_t *newpool, *oldpool;
-	struct pool_info *newpoolinfo;
 	size_t new_r1bio_size;
 	struct raid1_info *newmirrors;
 	struct r1conf *conf = mddev->private;
@@ -3400,23 +3389,15 @@ static int raid1_reshape(struct mddev *mddev)
 			return -EBUSY;
 	}
 
-	newpoolinfo = kmalloc(sizeof(*newpoolinfo), GFP_KERNEL);
-	if (!newpoolinfo)
-		return -ENOMEM;
-	newpoolinfo->mddev = mddev;
-	newpoolinfo->raid_disks = raid_disks * 2;
-
 	new_r1bio_size = offsetof(struct r1bio, bios[raid_disks * 2]);
 	newpool = mempool_create_kmalloc_pool(NR_RAID_BIOS, new_r1bio_size);
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
@@ -3442,8 +3423,6 @@ static int raid1_reshape(struct mddev *mddev)
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

