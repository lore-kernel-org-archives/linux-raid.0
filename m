Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99FFA1F9F70;
	Tue, 24 Jun 2025 01:56:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750730186; cv=none; b=gSF1qeo4nV6MI3QO8hEeeEZy5cT0U4hx72BZNoObR9KsZ9XqwBZxlrd3HhfuVBLIA6i8MvJHnUJuhjUSLjVfrbj44i6B3IC5WkvUAuQWzv+1agbKkCgTFOnLF1N3llZ1+5fWlfsWrlZYhHxTODsFpJv4vDL796aw1P+eP5m0Jdk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750730186; c=relaxed/simple;
	bh=IXyJU8YIL2unBxTgczBS5oLpgmpqH6HH6+T3moNjiJU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GeQkX0Gk5SC8Yoqy4nA67ZU1kgxjMMUb4pYb/ZubV5KEzKISPy7pENRwFDnFFnZjhO2lVbSoFDyhs52VIfGHeGq0UozipHk6vFWspMkRzUR88fqk5shcEpFhCvUPuey+9jxG9NwKjtdXYJoTbiWo63syOBxkc8iaBa9taKUnRKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bWp0hNjL; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bWp0hNjL"
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-747ef5996edso3662439b3a.0;
        Mon, 23 Jun 2025 18:56:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750730184; x=1751334984; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=w+m1F/J6myOjO3Z7KnVsiSmxznZuD7QlKF6311hrfYw=;
        b=bWp0hNjLmyxgOf2FNVa+eV6wVyvzob1CjNw+yQxi5I+7H0lWazznwmCflvCOiPBaWX
         ZZvOU3Osslk3u5EEELJrzUog3pojOcWlXsRREw8Z44CAsXagN+D2KsZo41zzFJ+mr3b/
         fDfrKxemnfg+Oa6D2dkBGoQtHK5wFE7ptQNhmEPXWni84SvdmxIIPr9Y3cc4/l04ji3v
         iNTafedpsrBLk7XEUlpcPEPnbIsA6K9Gkmu6AhgkelP7efiX/4mgRu49Ha1u3zwWS5MH
         hhFGFI6DP08vsopmLBq5unRjoEe5hvbRbu6GovipPmxKCjNis5iCuV7G6C4WwLx8vKqq
         L2IQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750730184; x=1751334984;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=w+m1F/J6myOjO3Z7KnVsiSmxznZuD7QlKF6311hrfYw=;
        b=Qiz7eoVbxIlXjYDbzZ32hKOhwGdm60nAsaIx7UZibQN9CAWOagF+E6DMxcbsWPCf+U
         9cASF1v32mriLJJRaSlcIIM67fIjjRx2ULGRkUCYqYsD2Whjp/47hkIztQpsjv59lj9z
         vbgG/sKHQ1S/3exWHtTVHW38JZWZoa2VF/aMg4DcAnW5Oq188pX5cMs7Dgqep2E8OrTg
         kmX+8cRMhMOqJjuIVw8ltVdkUiFuToeLfVJ6avH9w+loGASU5+pH7CeeE7A9ekwxfVWe
         XeMvAJd1fHIWEfiBXOUlmIlml8imKbIkFQAaQw9ZfG+Mnm2H4wMcNqpAqh2RxY+9R3Qs
         oIXw==
X-Forwarded-Encrypted: i=1; AJvYcCUgs5OtxmjxvCotQ9VgzAvXJoVtKbtuGEOWaucwcIXoG7MFZkca2ejeSUjVJCdOf2ZIELyZmhQERrrO3A==@vger.kernel.org, AJvYcCVHTG09c3yRhukxVHKUbIh8jNMSRJDBEIxUK/LCQYM5I2rH7KdDWn/9vN0su9b66i7Wl//LXoMGtm79EkQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywj2Hdr8uxOfHD/IIkmGYAioy8LUSiH8jdticRiWa1Dl2Muqj+L
	HEAfrFA1wFk+0DqgO3GhGZP1iUPxuJGN7DX6AY1F7I1xvjDNdKm+U3iE8ds/2LuD
X-Gm-Gg: ASbGncvg7jHL5ZHOWK9KOQMm/CH7B9AymcnmMrai8DA6fBHkNZoBreGOjovV4Hg93ZW
	UxRXHdAiRkMHjYKLpduvN4NTAK1MsJdPh7frcUFOGlqwSs9YkTb5kFkBfnNRdBd6B/c8aIk5Zh/
	GZYG76lylr0731fJUWGiUmOnjz8rTT/hielQimfTU4O1V/5l+OYzhEZoY0t2EIShaxwm9IP/rTX
	KPQ3SB5BcCyoK9bPKy+4UdHEJv2kyXlt1dCChMRp1vlxHnYKcDpQukYECkAZGJ0/uk6sWnhD5xn
	JRlm7KnmgrhdviaTT2HlAZVGxwlwdw7JkbW5wqFQOauqO9cUlC4z+Pb9xwi6FSHiiY3SlEt3m39
	9WWjcmNBEwVEEfy9erQhikzJXfEUG
X-Google-Smtp-Source: AGHT+IHZGkwfDlvr8K49WqlKJnESmY0VjFpGL3iTHWcInPpL5AnkDzrVKLz7HXqW74w+dHotjbhCgA==
X-Received: by 2002:a05:6a21:68b:b0:21a:d061:2f84 with SMTP id adf61e73a8af0-22026fa63a8mr23987399637.30.1750730183726;
        Mon, 23 Jun 2025 18:56:23 -0700 (PDT)
Received: from localhost.localdomain ([114.242.33.243])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-749c8872629sm425424b3a.164.2025.06.23.18.56.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Jun 2025 18:56:23 -0700 (PDT)
From: Wang Jinchao <wangjinchao600@gmail.com>
To: Song Liu <song@kernel.org>,
	Yu Kuai <yukuai3@huawei.com>
Cc: Wang Jinchao <wangjinchao600@gmail.com>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 1/2] md/raid1: change r1conf->r1bio_pool to a pointer type
Date: Tue, 24 Jun 2025 09:55:52 +0800
Message-ID: <20250624015604.70309-2-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250624015604.70309-1-wangjinchao600@gmail.com>
References: <20250624015604.70309-1-wangjinchao600@gmail.com>
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
 drivers/md/raid1.c | 39 ++++++++++++++++++---------------------
 drivers/md/raid1.h |  2 +-
 2 files changed, 19 insertions(+), 22 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index fd4ce2a4136f..8249cbb89fec 100644
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
@@ -3084,6 +3083,7 @@ static struct r1conf *setup_conf(struct mddev *mddev)
 	int i;
 	struct raid1_info *disk;
 	struct md_rdev *rdev;
+	size_t r1bio_size;
 	int err = -ENOMEM;
 
 	conf = kzalloc(sizeof(struct r1conf), GFP_KERNEL);
@@ -3124,9 +3124,10 @@ static struct r1conf *setup_conf(struct mddev *mddev)
 	if (!conf->poolinfo)
 		goto abort;
 	conf->poolinfo->raid_disks = mddev->raid_disks * 2;
-	err = mempool_init(&conf->r1bio_pool, NR_RAID_BIOS, r1bio_pool_alloc,
-			   rbio_pool_free, conf->poolinfo);
-	if (err)
+
+	r1bio_size = offsetof(struct r1bio, bios[mddev->raid_disks * 2]);
+	conf->r1bio_pool = mempool_create_kmalloc_pool(NR_RAID_BIOS, r1bio_size);
+	if (!conf->r1bio_pool)
 		goto abort;
 
 	err = bioset_init(&conf->bio_split, BIO_POOL_SIZE, 0, 0);
@@ -3197,7 +3198,7 @@ static struct r1conf *setup_conf(struct mddev *mddev)
 
  abort:
 	if (conf) {
-		mempool_exit(&conf->r1bio_pool);
+		mempool_destroy(conf->r1bio_pool);
 		kfree(conf->mirrors);
 		safe_put_page(conf->tmppage);
 		kfree(conf->poolinfo);
@@ -3310,7 +3311,7 @@ static void raid1_free(struct mddev *mddev, void *priv)
 {
 	struct r1conf *conf = priv;
 
-	mempool_exit(&conf->r1bio_pool);
+	mempool_destroy(conf->r1bio_pool);
 	kfree(conf->mirrors);
 	safe_put_page(conf->tmppage);
 	kfree(conf->poolinfo);
@@ -3366,17 +3367,14 @@ static int raid1_reshape(struct mddev *mddev)
 	 * At the same time, we "pack" the devices so that all the missing
 	 * devices have the higher raid_disk numbers.
 	 */
-	mempool_t newpool, oldpool;
+	mempool_t *newpool, *oldpool;
 	struct pool_info *newpoolinfo;
+	size_t new_r1bio_size;
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
@@ -3408,18 +3406,18 @@ static int raid1_reshape(struct mddev *mddev)
 	newpoolinfo->mddev = mddev;
 	newpoolinfo->raid_disks = raid_disks * 2;
 
-	ret = mempool_init(&newpool, NR_RAID_BIOS, r1bio_pool_alloc,
-			   rbio_pool_free, newpoolinfo);
-	if (ret) {
+	new_r1bio_size = offsetof(struct r1bio, bios[raid_disks * 2]);
+	newpool = mempool_create_kmalloc_pool(NR_RAID_BIOS, new_r1bio_size);
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
 
@@ -3428,7 +3426,6 @@ static int raid1_reshape(struct mddev *mddev)
 	/* ok, everything is stopped */
 	oldpool = conf->r1bio_pool;
 	conf->r1bio_pool = newpool;
-	init_waitqueue_head(&conf->r1bio_pool.wait);
 
 	for (d = d2 = 0; d < conf->raid_disks; d++) {
 		struct md_rdev *rdev = conf->mirrors[d].rdev;
@@ -3460,7 +3457,7 @@ static int raid1_reshape(struct mddev *mddev)
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

