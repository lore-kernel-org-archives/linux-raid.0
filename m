Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EB3F23C8A2;
	Mon, 23 Jun 2025 12:06:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750680397; cv=none; b=aH1pxe4+swiXlxiX9c7RN2xxMflytpxpwaBCBec2sNxpD4XpcgdvXpfhcA6zNV9t16fxC//D3l3eVzM7OANu4nblzywG+WjYip4OZKjCT+1gofX+QoKNg0zLsZk3Wgsm/cC9WhrmKPRe1bC4d/kkcS+et5HkdsI/JCDbShaNwEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750680397; c=relaxed/simple;
	bh=yYLfpznsNEVDA43DU+bEXXf+H2nXmX+758nNANmpQ/I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=izJp0OutKtKMfQG+Ga2wRwuKuw+ppzTXAtOLxihyv2V2YRCH51zPvGx6KpXtMoi3SRRj3UimshctHJBnSQzKNdXTXz32Fv2GbJ+FjwArVsK78fYDMHg3KqAbTwehscYwzx2linyTdbd4XZhjnjKKWxCehS0M8dbtiZkA9ZA2GIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kevazFk6; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kevazFk6"
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-7399a2dc13fso4653858b3a.2;
        Mon, 23 Jun 2025 05:06:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750680395; x=1751285195; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TZ+gF4Ks2gdgpitcA4ZGR74rZJVp8v6MsX0ZK8aCfqA=;
        b=kevazFk63Fp6OCJnWPECjoqdqMq7jVfJM/KVVOO7u0zFVx0pKSi41Yl4NxVKZeqJ/C
         pQEt5WVaVhhtzX7wF7xlBhqIU5VU8gN5XsPPOuQC3ShjWtd2Ua2wS5nsxgTU8AVuv4gh
         nrplrXkpW9DmuzW2kpriyAR6VIaHcKquy0G+2YTvFZui0s+/WkQqurNwpEsVTrKKU5FA
         v/vt/+FEnP5USDStxUgKai3bGyWAXPbn80gILK86sARWz7cyVZ+55jPYCA+xnl5ptPCC
         M+d4xtOKK4S4x9gmNen/Hs2l0WCf98BscZ2UA8G3SbMzAxP+GIKWoZsKjIe+Ak2LFqfg
         2Qpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750680395; x=1751285195;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TZ+gF4Ks2gdgpitcA4ZGR74rZJVp8v6MsX0ZK8aCfqA=;
        b=imGgZiC1WGGfWqpr4CHrPkmtaYDHAow4fT5//HziR+MvX1dUjKdezOyJJgR8N8Q6MO
         6XbuSs9iPXwqsV5DXxlnImYyuBS0ZjW3jwEAwRl4IYon4OUUDY1xZqXsDUYapRQNnwV6
         aouEAkvWuS/Mtc/4GZhHqEvzP99WjG8xRxwipou/5RcF2QDG1ogw5RZ1Qq/DPEQ1z9/+
         Q9VMVT9Y8euGTqmv50ijRZCwXJp7ztbAW/4kyJ1bjaC7MnGXajMyGxjyisK7wyWILyDN
         5srMCsdnWiUT3NhPEeMfWkno3aAlCT3rdWf0K2+eQCCcJYD+0IxiGJV2JGJc/AvFQxuy
         ZiSA==
X-Forwarded-Encrypted: i=1; AJvYcCUmNg6kvLmVRKlprz4DfRYn8AkOWvgzK7n4upHrrtmhjCMs9/cBw7ne9wH15Be9Zs0CUIUYGvLzaFKd9Q==@vger.kernel.org, AJvYcCX/dIdzFSajnCIpiB3mDc5hGNlRXuiRpS4xgxpTi04q+1B4SuWFuwSYVe/MPo7tuQdeARFsUTXO25MHS8s=@vger.kernel.org
X-Gm-Message-State: AOJu0YxY8L6wJddn+X0r3NRZYeiAur8DRiZXXNPWQhP6fTWzBJVEfavh
	cxZw805xi3+ZbDn/gi1lgzhJJbU6I0wv13ZIaFwhiIdPu9orvEUDdTY5
X-Gm-Gg: ASbGncsel5zpucVb3NLrmpnaZh018LTvsVlA1NE/BKe70pBO7SoMMYMnvC4cozMPYWD
	5qwRMkU4b3cfUjq6MfxY88HSjy7VdmKQsAyBNbON+enluzspzTT4VgzZDmo4KWWaWwitjD2EJru
	oadxu0h1lsN8c4/k5k88ZRKL4gMNVoeZ8ZEetnvw/j7LVhJSc/tC9VDOlVliCr4a13ecMkDVWnF
	hfUFSsYoO4EA/9znW6bTlqYMQFow6uhEgaDFT8U2bciyTFd2RXelYXqxTFUjeOpTW4xANpSUxTE
	wDtAlqa4yDh7sBkrIyfZyjsoprFVjYymyo48QEb+AKrVpdzKpnxh2MbPzYROtroGc4ogG+t6MXY
	nBR0IdOK/QLTmqqyvQCNnGoemdmFC
X-Google-Smtp-Source: AGHT+IGUFMmh6UlT8Sttlox7qHNb154UCnMpQqtd+4WuogLy3aeJFAu9uHN1kv/6qzxU1jFxjRus5Q==
X-Received: by 2002:a05:6a00:1804:b0:748:e38d:fed4 with SMTP id d2e1a72fcca58-7490d691e08mr19881544b3a.6.1750680395037;
        Mon, 23 Jun 2025 05:06:35 -0700 (PDT)
Received: from localhost.localdomain ([114.242.33.243])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7490a6ba142sm8133637b3a.167.2025.06.23.05.06.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Jun 2025 05:06:34 -0700 (PDT)
From: Wang Jinchao <wangjinchao600@gmail.com>
To: Song Liu <song@kernel.org>,
	Yu Kuai <yukuai3@huawei.com>
Cc: Wang Jinchao <wangjinchao600@gmail.com>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/2] md/raid1: change r1conf->r1bio_pool to a pointer type
Date: Mon, 23 Jun 2025 20:06:02 +0800
Message-ID: <20250623120613.543079-2-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250623120613.543079-1-wangjinchao600@gmail.com>
References: <20250623120613.543079-1-wangjinchao600@gmail.com>
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
index fd4ce2a4136f..7753010841b2 100644
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
+			offsetof(struct r1bio, bios[mddev->raid_disks *2]));
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
+ 	newpool = mempool_create_kmalloc_pool(NR_RAID_BIOS,
+			offsetof(struct r1bio, bios[raid_disks *2]));
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

