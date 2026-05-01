Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9528B39D6C5
	for <linux-raid@vger.kernel.org>; Fri,  1 May 2026 11:47:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777636035; cv=none; b=LW6UNhZlzscODzFll+fwW+WTm/s6KQRhEW5UakXaSGFDVRmZkvXz0PnxxO+vOBl8zAWBU6BNdNM9qcEWUVkLGLlIQfxH8Eu48hf79iWn+DUy6KuBBDrIbvuzZ2rfV0+SiYgyqKXcWSh1WS8i/sJtzb5VKqfusM8BHEAL5ch2CYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777636035; c=relaxed/simple;
	bh=nI2K72PB2NtpPwpeuHNMfMbO44D3urEqQcaji0c1x9g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SKLENZeT+uiYItwzgwxr5mwbj3YP7X8z7Em3cZ2XTZkrkyFx68sh0rZGU4A/eOsRoh4J3so4E42vPW7FCDLrff9kIHnI8D8TJLKFeX4pAogqH4yB6lX4y1lTC9uuQMY9quyHKzz1PKd9hrWvOusXAQYImGQG5EmV6+mxav/zLR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Szv3CjAA; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Szv3CjAA"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-488b0e1b870so29949285e9.2
        for <linux-raid@vger.kernel.org>; Fri, 01 May 2026 04:47:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777636032; x=1778240832; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yycJU3roRGwzwJP1s3LivQySTtrdat7N1ahieeEDuNU=;
        b=Szv3CjAA86gjhYxztaP1m0bD6JaEAoljxXf7HIXVBUc8xykDHxQ7e+Up0+t20HOWBF
         4MgwktfS/JasUvywqjhyuaGupGGg0NhKkz2gMu8HHsvRTrFttTHTTRcpDdfg7iLO1fAk
         g0lMrgRxO/MCfslbRVslCVF2/RVjpzFgqBOx7FS4kIHX+s9LbiCg795mFajwcmgXFORY
         6NWmAi8ooKXbEk1JsguKpnOIGa6VJncu8wQGBKXBeVp2uPnSEpqe2e9yoFVZZsjqw7Om
         KbCdKv5FHo0w/0eRc77wIpuHsnZNV9lXCqXwF0r5Aji4Avvel2s6UaLHGIZjPEZKjaD5
         A5Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777636032; x=1778240832;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=yycJU3roRGwzwJP1s3LivQySTtrdat7N1ahieeEDuNU=;
        b=sdfcGylVSeZg4uXoAsvDiVBcb4FNVjiBZ2gp3UnpL6rvyY9r6MsyBwq7rsW4XeMK7e
         jVJklmS14u+g+0LSr6QbcgDAZp1z0Z+VTf7pH8vK+Vky8Wz8AlNHKTGM03vHDHiGDrN/
         KTMXuj7YvvrBPGU4APQ/CyGTbTjG7AbizIciTzqUzBL2HEoOSYUhZCyOdGW0eVfvBrJY
         u/O6tMI73S+kt9IVkv4xFdg8+Ka5Sp1T3efhBuSWO9OEUrj7N1mwRepP/6JLJLaKik0M
         NkjOZ10kcXoJ67TiG3sooF4j+qWJ9vQZvywR1N5jmtIyVCOL9OtZltlGqzo4KTn7NZUW
         HcMA==
X-Gm-Message-State: AOJu0Yy8VGFv3az4JfNl+Z+IzeLPyKbqDb1St+e2Zuu1a0fwfd2o41wb
	GnkmRypKHdcdndTF8kUN8LY/l1C5M5o9h5dYCG9LBFrfY7YyLH+Fqj8z
X-Gm-Gg: AeBDiesP6QJQi3GRGvYEgKgNdSDa0tcAHEnvacpPpp1QqIq/IICFq0287eSnGwGlPKT
	GThsVTSx+tmqMoW8AXBPxOHVdp7TMP9r+hkxDVc8dF2V4KJe3W6g+F0cqzD0FGnYfwP8wLL8ACe
	mK6ZoPu7lhIrlXajFC1zLov2cu0wQDjG1KqdGqEunQ0uu8bAcJZw7zlH3pqXwPmk0CvKwtrgEkz
	3u0UkzfK8popZnSbZBTb0TjLfgaQ6BIX3kEee3rl4hBIG8H+//zl53f+F3FbdXTNIdR9uI6SLj9
	K94Jz8YWysRll7uh/SsF6EZW58z0KDsLCLBVRJd8+2PzKBUfQh4O1Z7NA6SzpFXMK7pLdt63dfq
	DuvU2bT0X0ZF33hQ0uywfOp6JI7KPuf/LsR7Q68YOBcVkL2wZD+C8kOcmGyJw7Dw47yUxXyHWVm
	aY7Wi8wXVnAZ4/vvGT1UtJ+z6NdfywC6YR9Q==
X-Received: by 2002:a05:600c:8010:b0:485:46fd:7887 with SMTP id 5b1f17b1804b1-48a8446d8a4mr111327165e9.13.1777636031973;
        Fri, 01 May 2026 04:47:11 -0700 (PDT)
Received: from yocto.. ([2a02:3037:621:7039:f080:d03a:2ee1:37d9])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48a8fee5033sm11797005e9.22.2026.05.01.04.47.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 May 2026 04:47:11 -0700 (PDT)
From: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
To: song@kernel.org,
	yukuai@fnnas.com,
	xni@redhat.com,
	neilb@suse.com,
	shli@fb.com
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
Subject: [PATCH v2 2/3] md/raid1,raid10: fix error-path detection with md_cloned_bio()
Date: Fri,  1 May 2026 13:46:50 +0200
Message-ID: <20260501114652.590037-3-abd.masalkhi@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260501114652.590037-1-abd.masalkhi@gmail.com>
References: <20260501114652.590037-1-abd.masalkhi@gmail.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Detect the error path using md_cloned_bio() instead of relying
on r1_bio in raid1 or r10_bio->read_slot in raid10, which may be
NULL or -1 after splitting and resubmitting a failed bio.

As a result, the error path may not be recognized and memory
allocations can incorrectly use GFP_NOIO instead of
(GFP_NOIO | __GFP_HIGH), which can lead to a deadlock under
memory pressure.

Fixes: 689389a06ce7 ("md/raid1: simplify handle_read_error().")
Fixes: 545250f24809 ("md/raid10: simplify handle_read_error()")
Signed-off-by: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
---
This patch depends on patch 1.

Changes in v2:
 - New patch.
---
 drivers/md/raid1.c  | 13 ++++++++++---
 drivers/md/raid10.c | 20 ++++++++++++++------
 2 files changed, 24 insertions(+), 9 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index cc9914bd15c1..c52ecd38c163 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1321,11 +1321,18 @@ static void raid1_read_request(struct mddev *mddev, struct bio *bio,
 	bool r1bio_existed = !!r1_bio;
 
 	/*
-	 * If r1_bio is set, we are blocking the raid1d thread
-	 * so there is a tiny risk of deadlock.  So ask for
+	 * An md cloned bio indicates we are in the error path.
+	 * This is more reliable than checking r1_bio, which might
+	 * be NULL even in the error path if a failed bio was split.
+	 */
+	bool err_path = md_cloned_bio(mddev, bio);
+
+	/*
+	 * If we are in the error path, we are blocking the raid1d
+	 * thread so there is a tiny risk of deadlock.  So ask for
 	 * emergency memory if needed.
 	 */
-	gfp_t gfp = r1_bio ? (GFP_NOIO | __GFP_HIGH) : GFP_NOIO;
+	gfp_t gfp = err_path ? (GFP_NOIO | __GFP_HIGH) : GFP_NOIO;
 
 	/*
 	 * Still need barrier for READ in case that whole
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 3a591e60a144..8c6fc398260e 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1155,7 +1155,20 @@ static void raid10_read_request(struct mddev *mddev, struct bio *bio,
 	char b[BDEVNAME_SIZE];
 	int slot = r10_bio->read_slot;
 	struct md_rdev *err_rdev = NULL;
-	gfp_t gfp = GFP_NOIO;
+
+	/*
+	 * An md cloned bio indicates we are in the error path.
+	 * This is more reliable than checking slot, which might
+	 * be -1 even in the error path if a failed bio was split.
+	 */
+	bool err_path = md_cloned_bio(mddev, bio);
+
+	/*
+	 * If we are in the error path, we are blocking the raid10d
+	 * thread so there is a tiny risk of deadlock.  So ask for
+	 * emergency memory if needed.
+	 */
+	gfp_t gfp = err_path ? (GFP_NOIO | __GFP_HIGH) : GFP_NOIO;
 
 	if (slot >= 0 && r10_bio->devs[slot].rdev) {
 		/*
@@ -1166,11 +1179,6 @@ static void raid10_read_request(struct mddev *mddev, struct bio *bio,
 		 * we lose the device name in error messages.
 		 */
 		int disk;
-		/*
-		 * As we are blocking raid10, it is a little safer to
-		 * use __GFP_HIGH.
-		 */
-		gfp = GFP_NOIO | __GFP_HIGH;
 
 		disk = r10_bio->devs[slot].devnum;
 		err_rdev = conf->mirrors[disk].rdev;
-- 
2.43.0

