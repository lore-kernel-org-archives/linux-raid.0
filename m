Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FB33433BD2
	for <linux-raid@vger.kernel.org>; Fri, 10 Jul 2026 13:23:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783689835; cv=none; b=qmeb9Lj8aFMp0Tk5qFg8jX5ROMSuiAOj4xaji1lDtPJ1TSuq5T0LP52o1h28rO/7RFLIaAP/Nk2P/z3lbWJlvYKpN0RsuVhclB6goh8n8dB4sqB9dKfj1wtD3JzOMZOEowWbOVfT2CAtI6R3NsY3KkbMv23C5BxnMlz08zziupA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783689835; c=relaxed/simple;
	bh=xfG9Yh6PdxwCZ5amhCuAqaFey7nfqtmMZOG3tAoItOg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WyAPbVkg52WdwDwE6jAj921rDtnwM7a5+ReyokwJkexjt+Qi5V2N4Em0FYlkvi4VAngjE/Ot0Xc5tmMBAhfyX4kJKDHQyv2WOhosLnxSWpCrqng07zZPDsws6egAhrCBlurFWuQD0tx2JdbFSS/FqgiSgOjKdn+SLhze1uSS+IY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=f7iaJFTa; arc=none smtp.client-ip=209.85.215.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="f7iaJFTa"
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-c96bfabc8d4so581998a12.3
        for <linux-raid@vger.kernel.org>; Fri, 10 Jul 2026 06:23:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783689833; x=1784294633; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=LhRaXJfW0MEUnElMB0BBQ14vfwzvxCxOVpgUd+6T/XY=;
        b=f7iaJFTa7ua19T/tvI/pSamQdIsm5NoSuaibx6cSN+6bCaplxAY1ZfxQpGkua3FzU9
         tP0TYOsUT7DutNG6MihKf1PXOuvuiedi7pCLR0oXRWPP41A/zPdbviddTdg7rfpIPImV
         Y5H6ihJYXmsZty2R+OXVSjkD7+YIgYLFVRff7D49wpcCo2caCaa4IW5ea/8ZiEZVpVfn
         kLH/K8yyZXooJKSHpUF0UIbDBm6GrOTPLDn5Bk9FAkKD/CDJMlApd+NmgM+ZpdA1Mkd6
         lEq+DMy03FPF2vFNjRJvL8z3B89NTbMU2ncTptSH1DOgdFzferuyC/51QT5/97ZMJWCy
         GbPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783689833; x=1784294633;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=LhRaXJfW0MEUnElMB0BBQ14vfwzvxCxOVpgUd+6T/XY=;
        b=Gw6aH5qSYj9Lb46fUYz7IIgE/XqcHr0DD/QSWVqW2JvIGmpDfm5SXyehUEssRpQm4Z
         8dtmowgk1b5lvLXt9V0fUuR0uwGPcohKRJJxfiNkv0NgSHkM4KzvUesgV1IvbJUKgbus
         V6HEQYJO5wv7NAtGeRn/n1OhPe6quEuKOTJAwY15KFObm2i7ThP+zmnXx4Ch2srW0Uud
         63nPWH//m4FOYs+LYCdxqYJFOOrhlLZBoWocduUycJpxR8RjMhVXTEMjwX7q9SMxEIon
         RnnZgAvBPSsZ4Pjzj18PLmBf+5fbOxmgPcOyzrhI/qyHLR/G8CSfAp6mkpsvUQIWLkDP
         98Sw==
X-Forwarded-Encrypted: i=1; AHgh+RoFNWTCM03gOJbFEQDMj/u09DabfDi8H51bC2Ujr1T4SJBAWoQ5pt3bmCwf9bf26K26BHzihrtyVTg+@vger.kernel.org
X-Gm-Message-State: AOJu0YxJVUgbS0CTHgZ4s7cfU9MtAfxBscZHKkAFFJvm4nJUkvDO01PM
	IsAxIx3L+GkfAsnhv03QrV8xV3nSdXTwybw9HiooGJa4adqfC3fBNVev
X-Gm-Gg: AfdE7cmrBRaMVrG52HM8As+hVdaXIrjw7ddEZa4XPXUwWIzZeIf82hdhkGCVfCrnryT
	4TUiciDKj+MLgyynf6cWTDLVMjNzpoxTNKBLsnEZQ38nx9w9/X5un6WecPmzhhlg4lDUvKAK6fB
	ZDnres4Eo/aAElaJZYUKz1sQk2yueg15GtUWmEgFux8oFnR3tkTczlJpPTk8qJdXf4+ep7p7FJV
	kwDrqkj6w+C6KX+tDRl98d1XZ+xxE+8VH+oehA6QGCFwNMVxqeusERcO4IAR2CJvCZZZVcwxHdH
	Ak9aJeCxXLu5gNExc5/W0uSoHsptaji0HYPjEBmS4sz/xZay2ZAdaLJLgKXXB4jNlGBtiuTnFN+
	VQtfLlKcv5pn+6LI2emLzCREZAKIDUZPFWPFK6P+dA2Rs2UJXdr3zyLu+zMsQ/EgVtVs598EhBh
	Ej9MfHuSF6Hk4Lc9K0YiTwi4U9ObLWZlUHiskfZgLjAmSho5BiCDhhvBfEBtHKny8slNrPP8Lxw
	i7Nyf8=
X-Received: by 2002:a05:6a21:e083:b0:3b3:486f:f2d1 with SMTP id adf61e73a8af0-3c0bceb6df6mr13539932637.3.1783689832543;
        Fri, 10 Jul 2026 06:23:52 -0700 (PDT)
Received: from research02.. ([2601:1c1:8700:f5b:fe34:97ff:fea3:c147])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-ca5b3b251eesm4903776a12.31.2026.07.10.06.23.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jul 2026 06:23:52 -0700 (PDT)
From: Hiroshi Nishida <nishidafmly@gmail.com>
To: Song Liu <song@kernel.org>,
	Yu Kuai <yukuai@fygo.io>
Cc: Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Hiroshi Nishida <nishidafmly@gmail.com>
Subject: [PATCH 5/6] md/raid5: scale the default stripe cache size with system memory
Date: Fri, 10 Jul 2026 06:23:45 -0700
Message-ID: <20260710132346.7295-6-nishidafmly@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260710132346.7295-1-nishidafmly@gmail.com>
References: <20260710132346.7295-1-nishidafmly@gmail.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

setup_conf() starts every array with min_nr_stripes = NR_STRIPES (256),
about 12MB of stripe cache on a 12-disk array.  That fixed default was
chosen for small systems and is never revisited: a server with hundreds
of GB of RAM backing a wide array still creates its arrays with the same
256 stripes, and only benefits from more after an administrator writes
stripe_cache_size by hand.

Auto-size the initial count from memory when the new
stripe_cache_size_default module parameter is 0 (the default): keep the
historical NR_STRIPES up to RAID5_CACHE_DEFAULT_BASE_GB (8GB) of RAM, then
grow the count using about 1/512 of the RAM above that baseline, capped at
RAID5_CACHE_DEFAULT_MAX (4096).  A system with 8GB or less is therefore
unchanged -- same count, same footprint -- while larger ones scale up
smoothly (no jump at the baseline) to a bounded maximum.  A non-zero
stripe_cache_size_default sets a fixed initial size for administrators who
want one; existing arrays are unaffected, and a reshape still forces at
least its window's worth of stripes.

Signed-off-by: Hiroshi Nishida <nishidafmly@gmail.com>
---
 drivers/md/raid5.c | 44 +++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 41 insertions(+), 3 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 5f0825c5effe..8e1c2eba4241 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -83,6 +83,11 @@ module_param(max_stripe_batch, uint, 0644);
 MODULE_PARM_DESC(max_stripe_batch,
 		 "Number of stripes a worker thread handles per device_lock acquisition, 1-32 (default 8).  Larger values amortise the lock over more stripes on busy multi-threaded arrays at some latency cost.  Read when an array is created");
 
+static unsigned int stripe_cache_size_default;
+module_param(stripe_cache_size_default, uint, 0644);
+MODULE_PARM_DESC(stripe_cache_size_default,
+		 "Initial stripe_cache_size for newly created arrays.  0 (the default) auto-sizes it from system memory: the historical 256 on small hosts, scaling up with RAM to a capped maximum on larger ones.  A non-zero value sets a fixed initial size.  Existing arrays are unaffected");
+
 static bool devices_handle_discard_safely = false;
 module_param(devices_handle_discard_safely, bool, 0644);
 MODULE_PARM_DESC(devices_handle_discard_safely,
@@ -7568,6 +7573,17 @@ static unsigned long raid5_cache_count(struct shrinker *shrink,
 	return max_stripes - min_stripes;
 }
 
+/*
+ * Auto-sizing of the initial stripe cache (stripe_cache_size_default == 0):
+ * stay at the historical NR_STRIPES up to RAID5_CACHE_DEFAULT_BASE_GB of RAM,
+ * then grow the count using about 1/512 of the RAM above that base, capped at
+ * RAID5_CACHE_DEFAULT_MAX.  So a system at or below the base is unchanged and
+ * keeps the historical footprint, while larger ones scale.
+ */
+#define RAID5_CACHE_DEFAULT_BASE_GB	8	/* unchanged at or below this much RAM */
+#define RAID5_CACHE_DEFAULT_RAM_SHIFT	9	/* above it: ~1/512 of the extra RAM */
+#define RAID5_CACHE_DEFAULT_MAX		4096
+
 static struct r5conf *setup_conf(struct mddev *mddev)
 {
 	struct r5conf *conf;
@@ -7801,15 +7817,37 @@ static struct r5conf *setup_conf(struct mddev *mddev)
 		conf->prev_algo = conf->algorithm;
 	}
 
-	conf->min_nr_stripes = NR_STRIPES;
+	/*
+	 * Choose the initial stripe cache size.  stripe_cache_size_default
+	 * selects it: 0 (the default) auto-sizes from memory -- the historical
+	 * NR_STRIPES up to RAID5_CACHE_DEFAULT_BASE_GB of RAM, then scaling up
+	 * to at most RAID5_CACHE_DEFAULT_MAX -- and a non-zero value sets it
+	 * directly.  A reshape still forces at least enough stripes for its
+	 * window, below.
+	 */
+	if (stripe_cache_size_default) {
+		conf->min_nr_stripes = clamp_t(unsigned long,
+					stripe_cache_size_default, 16, INT_MAX);
+	} else {
+		unsigned long per_stripe = sizeof(struct stripe_head) +
+			max_disks * (sizeof(struct bio) + PAGE_SIZE);
+		unsigned long ram = totalram_pages() << PAGE_SHIFT;
+		unsigned long base = (unsigned long)RAID5_CACHE_DEFAULT_BASE_GB << 30;
+		unsigned long extra = ram > base ?
+			((ram - base) >> RAID5_CACHE_DEFAULT_RAM_SHIFT) / per_stripe : 0;
+
+		conf->min_nr_stripes = clamp_t(unsigned long, NR_STRIPES + extra,
+					       NR_STRIPES, RAID5_CACHE_DEFAULT_MAX);
+	}
 	if (mddev->reshape_position != MaxSector) {
 		int stripes = max_t(int,
 			((mddev->chunk_sectors << 9) / RAID5_STRIPE_SIZE(conf)) * 4,
 			((mddev->new_chunk_sectors << 9) / RAID5_STRIPE_SIZE(conf)) * 4);
-		conf->min_nr_stripes = max(NR_STRIPES, stripes);
-		if (conf->min_nr_stripes != NR_STRIPES)
+		if (stripes > conf->min_nr_stripes) {
+			conf->min_nr_stripes = stripes;
 			pr_info("md/raid:%s: force stripe size %d for reshape\n",
 				mdname(mddev), conf->min_nr_stripes);
+		}
 	}
 	memory = conf->min_nr_stripes * (sizeof(struct stripe_head) +
 		 max_disks * ((sizeof(struct bio) + PAGE_SIZE))) / 1024;
-- 
2.43.0

