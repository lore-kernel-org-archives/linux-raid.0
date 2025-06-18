Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA04C276059;
	Wed, 18 Jun 2025 11:41:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750246890; cv=none; b=H/PjE3VRZBTTvUpXmW0jULf2UTguWNISZ+5GxWs9W4oqXtDRxX7rtIWKIr7WNecdBQ9qjLtLTsoQ3cLbnhyXDpjtVdAuYMH1VqYyxaMcAW/SRj4idt9BpX76tRTeQAjHOt3fq4BxTPuSr5qo8pYs1eJVPmDGNu5xmzHs2/JdO4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750246890; c=relaxed/simple;
	bh=tPKwCKLsH/uUR7qtKCo4ij9SiSEcvRPx3aqpnWQnJys=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=cIsVN+abAAbYljyOz+djesckj3LtC5waFRaauRtfEUPQYsn4y3ZPVEZnlexxzrGBgDoM1YA4+F0HsIGwPC5OpSes5gPnBw4BrpPZKR8i/yVjAI5V0iB5rFiGkOwK5Nf9Xe86A/wZA8jOB/B5wQTpcSFj3BwZZvtNw+VM//42oo8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kjLvooZo; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kjLvooZo"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-235e1d4cba0so61969355ad.2;
        Wed, 18 Jun 2025 04:41:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750246887; x=1750851687; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=WHO/1ZrcSY8MzfWKm46uPjtYme/ycb9AH5YOiYbzy04=;
        b=kjLvooZohSs1XWThcxg2jmMR/68DuShsQlZgFhOc5hqxOhTjLjoM4bM/uzr/RRo/bp
         a3DsZYqtArxRWWfOdZX+x+m7oKii4x/u2Fw9F3UQHkOAzvukerCNF8Zu9iD9kR78F2ze
         dTep7WC1ohxpnFV8InFQTaZexl1Zv9ugSVcnZgPBkhjLjQPpt2ORtO+B7r80JvUKmRG4
         clvIfXokpKYTfT8b979v8Fc1nSZ4jNNwrTUdLwS04ek6CLcZOHOqDUTVruMFJ6nycl0z
         BzwEf4m/Y6er7fUM4XAplPp8DX+VyTK9jXIlm5i+zS5ViTD4XlLG8lepDiR7/ZCAeBHy
         jqRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750246887; x=1750851687;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WHO/1ZrcSY8MzfWKm46uPjtYme/ycb9AH5YOiYbzy04=;
        b=NKuvkaBCzNrebuMHnjc0VZ6bUt/1X17hQSrLBo7KE7D6OMVZ0kEGAOUPubIJJ0U3aK
         JTm+eMtPdhTQ21Vl5g8Tnx/U8pUvKNFbVBZ/GFPsA0cRWM4PsTCVSxtx6sfg3vshI9iQ
         Q5mViePxWLLK8u3EpFHtuwOtN0JHs6hqkWyMDe69ki3qCdiIyB4+cnsR38CWuLRGGRGX
         Hs4dz22ci9KFwKjEfr3ePcziOd/4iZxWMe7a6Ll+ftoKNv6OqtscUZKi3X6q1uZd43P5
         Uw939cY9xQV5oOK1dYVJqM5eas8tKvDO2RBocfTkGXb3fHWq0mIRuNI0M+wJarWQLKaK
         TCYA==
X-Forwarded-Encrypted: i=1; AJvYcCU85kdA5h8EXiD8KiNUzTSMSf+VL60cjeJfdFH9Dt6SDBAPHaBTbWIMo7JizNcd+D8PgRCbTT0Of1Zc2g==@vger.kernel.org, AJvYcCUx3H7F6ND1d4tEpoe6HJ78KWbVfJOUglP2/x47F8W5q3ecXl1NKgRSk16TXOM0mO8jyFRvWuZ0wu+/deE=@vger.kernel.org
X-Gm-Message-State: AOJu0YyqQMK0BaeTGVZgAJ4p1LvcCzIvC2zYAtIdpOqzgXDwukrhV3o7
	vVt4l4UleJSeO4jBtEZFO1u6p0L/5f4+tpao0IWm5EFumBpcGENErUfs
X-Gm-Gg: ASbGncuPDuv5j+jhT/6Zrfl0rt1Ufr5gv9uTCYGYs1weMgL2wZdcPWheDwAi4TqP0v8
	zNobjmnadFddLa5invwgQ4iJ8637oLlf8XvN94jlgf3OgRJRktUXXNbAiwoQyWclQPJ6LGHq+sc
	je29/FoeIYHfASV2dFTs9zju1dEYj3CG9RaQRQCDHUHzYOzE+W1fwccIFDKCdN2m9KLA0zrOuvQ
	xxc+BUCIitwpaafR/0Knu1pMp4uQD0YWb0KHRuY7kp6fc+j5KQqJ5wk8bmIaza9RpGL8gf0q1LI
	p2nSNFQ0QqYRzVFICZbjvCKN1r1TKfe534t+PfkvJRQzskMdAbNj0cg8ea6pztplVAOvojTy2Wa
	KHe3V8Bg=
X-Google-Smtp-Source: AGHT+IHmvDU9mvjECIrfRIhGA0Lasf+p4c/hD1IDAv3zQPehBQksk9qIcZr8pMJYOZI/tovdU5bgMg==
X-Received: by 2002:a17:903:94c:b0:235:f70:fd37 with SMTP id d9443c01a7336-2366b006110mr258304005ad.19.1750246887029;
        Wed, 18 Jun 2025 04:41:27 -0700 (PDT)
Received: from localhost.localdomain ([123.113.104.194])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2365deb0fc2sm97209045ad.180.2025.06.18.04.41.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Jun 2025 04:41:26 -0700 (PDT)
From: Wang Jinchao <wangjinchao600@gmail.com>
To: Song Liu <song@kernel.org>,
	Yu Kuai <yukuai3@huawei.com>
Cc: Wang Jinchao <wangjinchao600@gmail.com>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] md/raid1: change r1conf->r1bio_pool to a pointer type
Date: Wed, 18 Jun 2025 19:41:15 +0800
Message-ID: <20250618114120.130584-1-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
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
replace mempool_init() with mempool_create() to
avoid referencing a stack-based wait queue.

Signed-off-by: Wang Jinchao <wangjinchao600@gmail.com>
---
 drivers/md/raid1.c | 31 +++++++++++++------------------
 drivers/md/raid1.h |  2 +-
 2 files changed, 14 insertions(+), 19 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index fd4ce2a4136f..4d4833915b5f 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -255,7 +255,7 @@ static void free_r1bio(struct r1bio *r1_bio)
 	struct r1conf *conf = r1_bio->mddev->private;
 
 	put_all_bios(conf, r1_bio);
-	mempool_free(r1_bio, &conf->r1bio_pool);
+	mempool_free(r1_bio, conf->r1bio_pool);
 }
 
 static void put_buf(struct r1bio *r1_bio)
@@ -1305,7 +1305,7 @@ alloc_r1bio(struct mddev *mddev, struct bio *bio)
 	struct r1conf *conf = mddev->private;
 	struct r1bio *r1_bio;
 
-	r1_bio = mempool_alloc(&conf->r1bio_pool, GFP_NOIO);
+	r1_bio = mempool_alloc(conf->r1bio_pool, GFP_NOIO);
 	/* Ensure no bio records IO_BLOCKED */
 	memset(r1_bio->bios, 0, conf->raid_disks * sizeof(r1_bio->bios[0]));
 	init_r1bio(r1_bio, mddev, bio);
@@ -3124,9 +3124,9 @@ static struct r1conf *setup_conf(struct mddev *mddev)
 	if (!conf->poolinfo)
 		goto abort;
 	conf->poolinfo->raid_disks = mddev->raid_disks * 2;
-	err = mempool_init(&conf->r1bio_pool, NR_RAID_BIOS, r1bio_pool_alloc,
-			   rbio_pool_free, conf->poolinfo);
-	if (err)
+	conf->r1bio_pool = mempool_create(NR_RAID_BIOS, r1bio_pool_alloc,
+					  rbio_pool_free, conf->poolinfo);
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
+	newpool = mempool_create(NR_RAID_BIOS, r1bio_pool_alloc,
 			   rbio_pool_free, newpoolinfo);
-	if (ret) {
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

