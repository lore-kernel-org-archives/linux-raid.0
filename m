Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C98E253953;
	Wed, 11 Jun 2025 09:02:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749632538; cv=none; b=jm4YSvIiqKoxu+o5I4YuE+UhoptdMy8wUnp+03GzRtP1jFkiu2LkTjYrgV6isrM9lX8FGOLM6Hi6OKdhxQXiOaGdTVfn8D4czjXyd2WhsGvoVIVQA/zLgi4I+cRkCisfGE8qfW7dwpKFozOOYDXMGWzBAg7D4Dri74WXJoCU964=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749632538; c=relaxed/simple;
	bh=69jCf82ldxpTA0F6lOOd9iI+ILINtCcpDowM6KFnYV4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Krc9D4lU8kYl/zp0QqmLVc3QlXuA1OXOVamYwvFZ/F661I+1haVrI+6YsPxE4QlSYmQko9jioJHMdq643CVxMbMa/W8cwxNRPf4RlY5mo4vusZjHpNN3nscNG1ZrrrAMWq45FSMTh8yrU14poX+whDPlJ0dw3fhqSFNYILcmU1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mZjStcvB; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mZjStcvB"
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-74267c68c11so5149083b3a.0;
        Wed, 11 Jun 2025 02:02:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749632536; x=1750237336; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=KVumx6ANM4ofeoun5RGa9xF2pUD3YLPwVEfUhUeDdMM=;
        b=mZjStcvB22KqMzyGIjnpbPy6czqzMOoJ5itSbiBxoEano9e0xdj3ITJEGHYNLDhPCh
         +rV98ZJgshhbHWRlrqWJ/iH5OdAEr/V2YUtBBDLcjydRZL4T76etL8VQVFV2NrNIbis0
         vFGJiEecHS0n2TU6VxRn5a2vrxFF/9XYsf+J0Z7JcC4LSzorlJQ/rC+S+VozHQVF9mw3
         jJ0RoHhOedzfuXigzF1wgKin4tqLKJSNA2Er5D+vR8P44ZIb1COLwFxb1IyqT+z9yhn3
         P9her3Y76T5IntUNVazwuS7MCWucn+HDLQF1DPuhgcCQZmQwJovYk0pqWSiBKznvDG+9
         AL4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749632536; x=1750237336;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KVumx6ANM4ofeoun5RGa9xF2pUD3YLPwVEfUhUeDdMM=;
        b=AkJhQpwaptM1EserU8qm3669+Lvc1ImdYIe9Ezv7hyYVhvXYYBhffno5RHNcqFlsji
         UMnGsB0ouIGDPaj/4+XZH/lUoPUPwzvpxT5AS2qAAuGMXuSakT+x7ruFHOY8kv+ljvPO
         gaqyTBzHSlE0ChRsEYS35GdzZtkKT3HK011+YtP2u5dJwWfwIbrlqoEvxfoS8yf3AnOV
         fff7famdjlEe2uX6lvuqKA4JhSUOmi3PW4DBSq/dhR8GxnYwYE+niSi+qPB9xqzKj4ic
         Sohu//UFILn7MYe34mGIbscsUJkSeNgI5Ejo1+XhASMkuazrGq9fmdtBZSeXoprwKDk0
         KSyw==
X-Forwarded-Encrypted: i=1; AJvYcCUqp3byDX92wQZHct96oaymCP5b5QoQIabOfYpANYkqm3/qRCPO17VWfl/UlK2/LTPxsZeEqJp/jyCZoA==@vger.kernel.org, AJvYcCVZZw0MKzYVF99Z2G+DUzI9s4sloGuTp6BlRPlSIgaatjJRucbZJqmjPBL29zUWT/u1dsHXPneqPILq/tk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyks7Ubg6k09hLbpyZ9xJqzSjO7wUUNLZi1sLuC3NOslpZTYq9Z
	j03mJ16k7sw4iqGgYOcUb1JDALie+hKxs+JVImAs1aloM4zGrKjLDaY9
X-Gm-Gg: ASbGncssUYxeVpFi5ogI8wkXKxvtSeOHCO7pLkB86csE9R+wpaQAqqW+V9ofBrTWAyV
	w8MAZyA0dzOuWB/DF2q2S1FXemJefzqJqTTZRJs1P838nxWzVPryKhZrJ8o/dHA9wPc1xgMpb+1
	QQY0xgoCan0CuUyYwkGvx7Kv+Q08W4roycmg30BU5ka9Qeh/gIA0clzm/s1l8p9PpGrysmc8EWY
	CVg0QAN/z4hIcsas52EkejQuL8blcpEM5/QEjGIPCcR/lbdlP6+m0Fp9VmTE7utm2FM2YuEGxbF
	SYy96x7BE7IQLAJ+73+nhI8zsQ08D9cbQ48Wc3TI7wPoWNqOtRhFJlbpjxVp9lpg6vuxTc7Mv4x
	IeCyG3w==
X-Google-Smtp-Source: AGHT+IGtr23sa68iAszhUDocoEeLvcc3jYEb/xSciH3gOWIBfRirmfC+n7brf1bZ5/jlTnZaIngeVA==
X-Received: by 2002:a05:6a00:b95:b0:740:9a4b:fb2a with SMTP id d2e1a72fcca58-7486fe7b34emr2915438b3a.20.1749632536109;
        Wed, 11 Jun 2025 02:02:16 -0700 (PDT)
Received: from localhost.localdomain ([114.242.33.243])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7482af3ab94sm8681447b3a.31.2025.06.11.02.02.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Jun 2025 02:02:15 -0700 (PDT)
From: Wang Jinchao <wangjinchao600@gmail.com>
To: Song Liu <song@kernel.org>,
	Yu Kuai <yukuai3@huawei.com>
Cc: Wang Jinchao <wangjinchao600@gmail.com>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2] md/raid1: Fix stack memory use after return in raid1_reshape
Date: Wed, 11 Jun 2025 16:55:47 +0800
Message-ID: <20250611090203.271488-1-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In the raid1_reshape function, newpool is
allocated on the stack and assigned to conf->r1bio_pool.
This results in conf->r1bio_pool.wait.head pointing
to a stack address.
Accessing this address later can lead to a kernel panic.

Example access path:

raid1_reshape()
{
	// newpool is on the stack
	mempool_t newpool, oldpool;
	// initialize newpool.wait.head to stack address
	mempool_init(&newpool, ...);
	conf->r1bio_pool = newpool;
}

raid1_read_request() or raid1_write_request()
{
	alloc_r1bio()
	{
		mempool_alloc()
		{
			// if pool->alloc fails
			remove_element()
			{
				--pool->curr_nr;
			}
		}
	}
}

mempool_free()
{
	if (pool->curr_nr < pool->min_nr) {
		// pool->wait.head is a stack address
		// wake_up() will try to access this invalid address
		// which leads to a kernel panic
		return;
		wake_up(&pool->wait);
	}
}

Fix:
The solution is to avoid using a stack-based newpool.
Instead, directly initialize conf->r1bio_pool.

Signed-off-by: Wang Jinchao <wangjinchao600@gmail.com>
---
v1 -> v2:
- change subject
- use mempool_init(&conf->r1bio_pool) instead of reinitializing the list on stack
---
 drivers/md/raid1.c | 34 +++++++++++++++++++---------------
 1 file changed, 19 insertions(+), 15 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 19c5a0ce5a40..f2436262092a 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -3366,7 +3366,7 @@ static int raid1_reshape(struct mddev *mddev)
 	 * At the same time, we "pack" the devices so that all the missing
 	 * devices have the higher raid_disk numbers.
 	 */
-	mempool_t newpool, oldpool;
+	mempool_t oldpool;
 	struct pool_info *newpoolinfo;
 	struct raid1_info *newmirrors;
 	struct r1conf *conf = mddev->private;
@@ -3375,9 +3375,6 @@ static int raid1_reshape(struct mddev *mddev)
 	int d, d2;
 	int ret;
 
-	memset(&newpool, 0, sizeof(newpool));
-	memset(&oldpool, 0, sizeof(oldpool));
-
 	/* Cannot change chunk_size, layout, or level */
 	if (mddev->chunk_sectors != mddev->new_chunk_sectors ||
 	    mddev->layout != mddev->new_layout ||
@@ -3408,26 +3405,33 @@ static int raid1_reshape(struct mddev *mddev)
 	newpoolinfo->mddev = mddev;
 	newpoolinfo->raid_disks = raid_disks * 2;
 
-	ret = mempool_init(&newpool, NR_RAID_BIOS, r1bio_pool_alloc,
-			   rbio_pool_free, newpoolinfo);
-	if (ret) {
-		kfree(newpoolinfo);
-		return ret;
-	}
 	newmirrors = kzalloc(array3_size(sizeof(struct raid1_info),
-					 raid_disks, 2),
-			     GFP_KERNEL);
+	raid_disks, 2),
+	GFP_KERNEL);
 	if (!newmirrors) {
 		kfree(newpoolinfo);
-		mempool_exit(&newpool);
 		return -ENOMEM;
 	}
 
+	/* stop everything before switching the pool */
 	freeze_array(conf, 0);
 
-	/* ok, everything is stopped */
+	/* backup old pool in case restore is needed */
 	oldpool = conf->r1bio_pool;
-	conf->r1bio_pool = newpool;
+
+	ret = mempool_init(&conf->r1bio_pool, NR_RAID_BIOS, r1bio_pool_alloc,
+			   rbio_pool_free, newpoolinfo);
+	if (ret) {
+		kfree(newpoolinfo);
+		kfree(newmirrors);
+		mempool_exit(&conf->r1bio_pool);
+		/* restore the old pool */
+		conf->r1bio_pool = oldpool;
+		unfreeze_array(conf);
+		pr_err("md/raid1:%s: cannot allocate r1bio_pool for reshape\n",
+			mdname(mddev));
+		return ret;
+	}
 
 	for (d = d2 = 0; d < conf->raid_disks; d++) {
 		struct md_rdev *rdev = conf->mirrors[d].rdev;
-- 
2.43.0

