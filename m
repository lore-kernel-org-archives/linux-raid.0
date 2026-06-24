Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08DE93DB63D
	for <linux-raid@vger.kernel.org>; Wed, 24 Jun 2026 15:55:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782316510; cv=none; b=TlyRLmoeTyMFqhU0NuC+/BoACvK/lLhNPqg2YiP/hQ5LqFRjF2wFKuKO9uvfjxhb3cdMPeojpaGze3KtT8NZ2Inv2A6+CvZpGJa9S4HWE/eXG46OggPQpfZ1NwAMCDIm5ChoHzmWssM6jF9ufCYDowxRV/QMRq0CpbqvO8MkHec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782316510; c=relaxed/simple;
	bh=rmhFnH6qUtH7P4dQaBCQE8wzJowsuY7XIcV375tB8yQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZBhu/j9ZdsevVBundC/jAWf/ahywQBYwoguk1w2LqlLjT9JP/aHV1eMVtMzBdWCAqecQZpJSlCKvHD6HvazrtF72hCJu3YjuiOJSWIiO7L4xaiWCceIy4r+9mLUG7o+NskDCQv4rOElZIxuuiMQVVUTUlhszWMo8qorJi5uR9sk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jVnxoh1Z; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jVnxoh1Z"
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-84232e83ca9so610551b3a.2
        for <linux-raid@vger.kernel.org>; Wed, 24 Jun 2026 08:55:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782316508; x=1782921308; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=D1DfBuQ6LwVx+aQ8eh36/EaM+LVnwq74Gn6ZmOpG+6k=;
        b=jVnxoh1ZRcJLEV4+i2NrzX4OHEaNb33IgwcJLk8RSrhK09epTHV4+IVQ6fyYuehCZb
         Lsg3dTnxnp6MwIv/P9b9QspZWs37h2EF/e5/kv3UJJSpGmuHVkZw90XnHV9EuyiYrZR5
         peug7uF+rifqZzlM8ZT1qJ2fNZzfp/UbdxvU3HVJCw8QIbjHuPE0LyDyXKTaGny4vSEL
         JQO6uThx15nRGi07nnS+qilTPyTtiDoe7+QfkG57A4G6ZSvUzvNGBmWduYUjW9075Yli
         sHd7KQYqcDfIIThGQ5yeP8XiGoCBXuF40/CMofAU2hG6x9iWghBamNhEVh+MdHT+dkUI
         djZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782316508; x=1782921308;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=D1DfBuQ6LwVx+aQ8eh36/EaM+LVnwq74Gn6ZmOpG+6k=;
        b=DZeZiVS4M7GECXXPK4N7P9g0LTl+IfVG6YVc43fL/XTZSup4/2XbixlysTKucd1e2J
         jTkh6nLZjz9g5rmuSdwYVpfbAChYnEUxaxjgtVGAFOqfsHhRDGWHu22RZamn4WHQ7hfF
         w+mCf9bK6VZbW7eq74QXQ8Ehrt4rV3oy/OhrkrGzDwdQ63XiUw6fbNHbKH0YlvxnZ/C0
         sQ761ZE+nh/ZgLrRMqNKl0CsfU1UMMPixPz2E+zn/6yemUEFxWAFHSx1U0t78wSs1xRj
         j+gI+caqvPbjLKX/w0m60m/Gn+CaRtFae0/aibg7ifPvc8CWV9RDERvSnGPIXM8sVkWg
         9rmw==
X-Forwarded-Encrypted: i=1; AFNElJ8RxV8qgWqqMMVDXDAn0jk5hFYcOHKcxaDfKGIS+yAPTwy3eTbq671HX3skEB1uZxF8757MPKtmoiqp@vger.kernel.org
X-Gm-Message-State: AOJu0YxzOPlnSFuDmk2ufXiPtwCAP3GKJ0Qn7j9C2vYy9rOFsTmu81mc
	WcAuN6UUqpoi/FYGxFaqKxSYwyFAn88RrijvRIaeuQuD+2sKdUkGZmYl
X-Gm-Gg: AfdE7cngPbV16IEGRWnB4dTQ6bgVlIn9mCLcOzRMRw3Gw1fxBTrKY3Jy/lCcTngNAge
	an2ymdsCCXiTwpu1eX78qcllEYglbWcCKbbkJTDIsobuCy38ZcvlVLOgZcuUZX0M2zMMZx9fOQL
	6iZL3/trBS9XLcuvyELjsA4Y82Ry1ZuFJsDUaTzq4jFSAxGBdm7ya7q2gH7H3TrhFAFdy4XIu83
	ApqiT0HdzeRrWRDJlkjz+lume8KPQmpFNixxC67f3NevDanJz2WruuC1RpqO9GPO76SSehq+13z
	ruiO+9pGgbIOTgmWRuTxaHBVfyjiblO4iavECewx1a0SNyUKl8vYmcAEyWMOi0eUMzxEQxlX1wG
	tSvt106XuP2dQGZl+c2tPU2IijeBh6bvQbv04bqjnJSAtwILGAfIG/15o8CWUMD/Yx13ueLxsrI
	knl8JpL+zJV5E3lFxTMitpzMG56GDL2p013v/DReP1AwkJpb7us0j6LcYX30TuBQv2hLKTtv3fr
	ufOlQE=
X-Received: by 2002:a05:6a00:3c91:b0:842:33f3:da68 with SMTP id d2e1a72fcca58-8459524c967mr9614751b3a.8.1782316508352;
        Wed, 24 Jun 2026 08:55:08 -0700 (PDT)
Received: from research02.. ([2601:1c1:8700:f5b:fe34:97ff:fea3:c147])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-845a40f55cesm2658387b3a.44.2026.06.24.08.55.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jun 2026 08:55:08 -0700 (PDT)
From: Hiroshi Nishida <nishidafmly@gmail.com>
To: Song Liu <song@kernel.org>,
	Yu Kuai <yukuai@fygo.io>
Cc: Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Hiroshi Nishida <nishidafmly@gmail.com>
Subject: [PATCH 2/8] md/raid5: raise stripe cache limit from 32768 to 262144
Date: Wed, 24 Jun 2026 08:54:46 -0700
Message-ID: <20260624155452.211646-3-nishidafmly@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260624155452.211646-1-nishidafmly@gmail.com>
References: <20260624155452.211646-1-nishidafmly@gmail.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Stripe cache memory is approximately max_nr_stripes * num_disks *
stripe_size, where stripe_size is 4KB (PAGE_SIZE).  The old hardcoded
ceiling of 32768 stripes therefore limits a 12-disk array to ~1.5GB of
stripe cache.  On servers with 256GB+ RAM backing wide arrays, a larger
cache reduces stalls on stripe-cache misses under heavy write workloads.

Define RAID5_MAX_NR_STRIPES = 262144 (256K) in raid5.h and use it in
raid5_set_cache_size() instead of the magic 32768 literal.  This allows
up to ~12GB of stripe cache on a 12-disk array.  The default stripe count
(NR_STRIPES = 256) is unchanged, so there is no memory impact unless the
administrator raises stripe_cache_size explicitly.

Also fix two local variables in raid5_cache_count() that were declared
as int but read from unsigned int fields; change to unsigned int to
avoid implicit sign-extension in the subtraction.

Tested: echo 262144 > /sys/block/md0/md/stripe_cache_size accepted;
262145 correctly returns EINVAL.

Assisted-by: Claude:claude-opus-4-8 [Claude Code]
Signed-off-by: Hiroshi Nishida <nishidafmly@gmail.com>
---
 drivers/md/raid5.c | 6 +++---
 drivers/md/raid5.h | 6 ++++++
 2 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 28828e083c2b..9cb4ed3bd85c 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -6923,7 +6923,7 @@ raid5_set_cache_size(struct mddev *mddev, int size)
 	int result = 0;
 	struct r5conf *conf = mddev->private;
 
-	if (size <= 16 || size > 32768)
+	if (size <= 16 || size > RAID5_MAX_NR_STRIPES)
 		return -EINVAL;
 
 	WRITE_ONCE(conf->min_nr_stripes, size);
@@ -7505,8 +7505,8 @@ static unsigned long raid5_cache_count(struct shrinker *shrink,
 				       struct shrink_control *sc)
 {
 	struct r5conf *conf = shrink->private_data;
-	int max_stripes = READ_ONCE(conf->max_nr_stripes);
-	int min_stripes = READ_ONCE(conf->min_nr_stripes);
+	unsigned int max_stripes = READ_ONCE(conf->max_nr_stripes);
+	unsigned int min_stripes = READ_ONCE(conf->min_nr_stripes);
 
 	if (max_stripes < min_stripes)
 		/* unlikely, but not impossible */
diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
index 5cd9d0f36b6e..57349737d393 100644
--- a/drivers/md/raid5.h
+++ b/drivers/md/raid5.h
@@ -479,6 +479,12 @@ struct disk_info {
  */
 
 #define NR_STRIPES		256
+/* Maximum user-settable stripe cache size, in stripes.  Stripe cache memory is
+ * roughly max_nr_stripes * num_disks * stripe_size (stripe_size = 4KB), so the
+ * old cap of 32768 limited a 12-disk array to ~1.5GB.  Raise to 262144 to allow
+ * larger caches on big-RAM systems; the default (NR_STRIPES) is unchanged.
+ */
+#define RAID5_MAX_NR_STRIPES	262144U
 
 #if PAGE_SIZE == DEFAULT_STRIPE_SIZE
 #define STRIPE_SIZE		PAGE_SIZE
-- 
2.43.0

