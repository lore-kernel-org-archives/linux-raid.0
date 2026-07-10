Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 223A6431E77
	for <linux-raid@vger.kernel.org>; Fri, 10 Jul 2026 13:23:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783689834; cv=none; b=ofqmB84JVHyogcHMB2ium/WG/GGzJ8VLU9Sip7tY/SOPAyoIZ2pOJKc6g6FzE0IBTDZxeDYQcEhCuqRpMo4Y5QdfPjL8zBScAUgvrKfx8EvQQfCR/mQPoRJELbxkM9CtPH/3t6weWsSfPMFeGaFGLV1lFnotaoSrw1GsOEzDKo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783689834; c=relaxed/simple;
	bh=h5a1Su9PjrEKsF0LuXoSVIdSjt3j29OkNIH0r9t+t9M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ID/TF72nAmNp4gNmtChoUCMReRfHqX3V7zaGtcfajqUmNUdxZfpI09wGOjvrxz2Jdwhr/z+VaxPcN/o3GSj6saM6XgJi04K65tYFz4zCCGyqVkXPeAkAJ37ELBkdnnSvdwaQeQ3CNjh/QDHhN7wVUzjYqGyGq0zFtADlMGpIrNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=oU4TnXBG; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="oU4TnXBG"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2cacb8416a1so7159855ad.1
        for <linux-raid@vger.kernel.org>; Fri, 10 Jul 2026 06:23:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783689831; x=1784294631; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=sDVSdr7r152gQiXZ3Vozdie+Fv1rp8S/dmZQcBepj3A=;
        b=oU4TnXBG4tlyGC9o7IVozmq7RPH6k18hxtBvKtisIaqj1q+XvqRs1FDiqQ29HcZLa5
         3fhXNgbCxBdmwyQSTJ/PWHPeZ0jTYQZqi3qd+LZ2p77bRXCcmFGzqQA1KfefuT4Bga11
         VJM5zxO1+RLOy2KN6FQLKUFFqv1U9uaweh0jaxMkutZ6pXMjwYFFZRHMYbW/6D17HGEA
         2SJhJzv2mwChfM1R5c34CKPx0QeegFad3AsVvXgF5v1KKNNPPr7rFUPqjCxEUK1oDoJR
         ConSQ8jssLSqpkjs96xWw9QLXs8lK6iQPQI/bQAkz3WXOQc/i6KemBNHepFp8RxGpmMa
         jg9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783689831; x=1784294631;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=sDVSdr7r152gQiXZ3Vozdie+Fv1rp8S/dmZQcBepj3A=;
        b=D/jMlCnYxUbIlue+fHBqs20zKCUGm0Wc4dl6lG5cGYHtMjqkjLguDvzWQf44TZh30J
         64nFhwQ4rgzqQeWMwJh6uWuOyRUUJYgJsYnkCV3bdulqyRQ3trO1lR1U+kQ2cyevaM2R
         pYIH5jwXffxAicXVG2fVaES9Yky7f8DHBuRwqXqUgU7HdPxYBREm/Lns6gWe/3Wlwjsr
         ATCx26QmIkvNPUWstWj8atqOoEAxGixXHiM7btV3tj8LjotY7I2KTXvZOgqdWKgh09BB
         qA2Tdj1SUx2MOTeQYMznt+zSBW7TohwewzpF+zBWQdLUwTPPzL+B5AEOqCnbbGYyQFCx
         bjeQ==
X-Forwarded-Encrypted: i=1; AHgh+RoXX63ZboR0yIN9yR2X65c2+7e/ldzFmlurmzA62ozBThBn6obkbLLLucDGUE8YStPYliYIelROWvsc@vger.kernel.org
X-Gm-Message-State: AOJu0YyMM9TeJylbiwrt/u9GOZWNJ1rK704diTqQZGDO2D2lyCRGqOaT
	dcgG8gyfpx30RgsQuYK3jF2kk6yEAxO2c+toy802V/MKR4e3V5fGFOYN
X-Gm-Gg: AfdE7cmCGKMHPnZdvKZ2lgPL39Qlz/lN/rgQdCI+QM7M5kIZpxYz61o4eGoU1+WFnKU
	WPY4G+C3kQTGC1slBebK+KkCImYfkw0HfacJ4Mu3RZp91Hn+H9UZGYlcro92aJnMfz6xMjg1COr
	IlOVpSFCbIiPF1+NP71/pRCwa6ZPzksLj9Att/BfpgJunnEaUvEFmQM68t3NzaCW1vmqAJ8XE8N
	olDYtP00fU3hfT190cSvt/Dx7AdtGz3OiAIEHxpVG/5QlYYdMqWgoN5iN3yUsg8YuCn2fAGAuoS
	nXr81ZcLh/ap6hRLpnZk1TuWGS17zt4vwL98KqL2CJygMPOoTDF9wp+IW4za8Aj0Js+po1KJla5
	3+Drgep5BBVHz5ZE6XqkGFXAno248UJyO5hesDp5VYWuZHPntcM4oZBnrIsuO95Lo1qJBrC2HGb
	zFwKQZ3oNRAhsil+D6KVudK2H1uzrNOpsyIwvm2xUy85caMde2CAFCHuiZV5fWNAneAa04SSVAj
	lmbYWg=
X-Received: by 2002:a05:6300:67c7:b0:3c0:9c1a:8952 with SMTP id adf61e73a8af0-3c0bd311c69mr13059970637.74.1783689831379;
        Fri, 10 Jul 2026 06:23:51 -0700 (PDT)
Received: from research02.. ([2601:1c1:8700:f5b:fe34:97ff:fea3:c147])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-ca5b3b251eesm4903776a12.31.2026.07.10.06.23.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jul 2026 06:23:51 -0700 (PDT)
From: Hiroshi Nishida <nishidafmly@gmail.com>
To: Song Liu <song@kernel.org>,
	Yu Kuai <yukuai@fygo.io>
Cc: Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Hiroshi Nishida <nishidafmly@gmail.com>
Subject: [PATCH 3/6] md/raid5: scale the stripe_cache_size limit with system memory
Date: Fri, 10 Jul 2026 06:23:43 -0700
Message-ID: <20260710132346.7295-4-nishidafmly@gmail.com>
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

raid5_set_cache_size() caps how far the per-array stripe_cache_size sysfs
knob may be raised at a fixed 32768 stripes.  The stripe cache costs
roughly max_nr_stripes * (sizeof(stripe_head) + pool_size * (sizeof(bio) +
PAGE_SIZE)), so 32768 stripes is about 1.5GB on a 12-disk array.  That
fixed limit is wrong at both ends: a host with hundreds of GB of RAM
backing a wide array cannot grow the cache past ~1.5GB even though it has
the memory to spare, while on a small box 32768 stripes can already exceed
total RAM.

Derive the limit from memory instead.  When the new stripe_cache_size_max
module parameter is 0 (the default), the ceiling is the stripe count that
fits in at most 1/8 of RAM for this array's width, but never less than the
historical 32768 -- so the limit only ever grows relative to today and
small systems are unchanged.  A non-zero stripe_cache_size_max pins a fixed
ceiling for administrators who want one.

The default stripe count (256), and thus the default memory footprint, is
unchanged; this only changes how high an administrator may raise
stripe_cache_size.

Signed-off-by: Hiroshi Nishida <nishidafmly@gmail.com>
---
 drivers/md/raid5.c | 37 ++++++++++++++++++++++++++++++++++++-
 1 file changed, 36 insertions(+), 1 deletion(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 7f72981121fd..e41d3fc92dd0 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -44,6 +44,7 @@
 #include <linux/seq_file.h>
 #include <linux/cpu.h>
 #include <linux/slab.h>
+#include <linux/mm.h>
 #include <linux/ratelimit.h>
 #include <linux/nodemask.h>
 
@@ -72,6 +73,11 @@ module_param(nr_stripe_hash_locks, uint, 0644);
 MODULE_PARM_DESC(nr_stripe_hash_locks,
 		 "Number of spinlocks the stripe cache hash is striped across, rounded up to a power of two and capped at 32.  0 (the default) auto-sizes it from the online CPU count (never below 8); a non-zero value overrides that.  Larger values reduce lock contention on many-core systems at a small per-array memory cost.  Read when an array is created");
 
+static unsigned int stripe_cache_size_max;
+module_param(stripe_cache_size_max, uint, 0644);
+MODULE_PARM_DESC(stripe_cache_size_max,
+		 "Maximum the per-array stripe_cache_size may be raised to.  0 (the default) derives the limit from system memory (never below the historical 32768), so large-memory hosts can grow the stripe cache without a recompile while small ones are not offered a limit above what RAM can back.  A non-zero value sets a fixed limit");
+
 static bool devices_handle_discard_safely = false;
 module_param(devices_handle_discard_safely, bool, 0644);
 MODULE_PARM_DESC(devices_handle_discard_safely,
@@ -6922,13 +6928,42 @@ raid5_show_stripe_cache_size(struct mddev *mddev, char *page)
 	return ret;
 }
 
+/*
+ * Upper bound that the per-array stripe_cache_size may be raised to.  The
+ * stripe cache costs roughly max_nr_stripes * (sizeof(stripe_head) +
+ * pool_size * (sizeof(bio) + PAGE_SIZE)).  The limit was historically a fixed
+ * 32768 stripes, which both under-serves large-memory hosts backing wide
+ * arrays and, on a small box, still permits a cache larger than RAM.  Derive
+ * it from memory instead -- at most 1/8 of RAM -- but never below the
+ * historical 32768, so the limit only ever grows relative to today.  A
+ * non-zero stripe_cache_size_max module parameter overrides the heuristic.
+ */
+#define RAID5_CACHE_SIZE_FLOOR		32768
+#define RAID5_CACHE_SIZE_RAM_SHIFT	3	/* cap the cache at 1/8 of RAM */
+
+static unsigned long raid5_max_cache_size(struct r5conf *conf)
+{
+	unsigned long per_stripe, limit;
+
+	if (stripe_cache_size_max) {
+		limit = stripe_cache_size_max;
+	} else {
+		per_stripe = sizeof(struct stripe_head) +
+			     conf->pool_size * (sizeof(struct bio) + PAGE_SIZE);
+		limit = ((totalram_pages() << PAGE_SHIFT) >>
+			 RAID5_CACHE_SIZE_RAM_SHIFT) / per_stripe;
+		limit = max_t(unsigned long, limit, RAID5_CACHE_SIZE_FLOOR);
+	}
+	return min_t(unsigned long, limit, INT_MAX);
+}
+
 int
 raid5_set_cache_size(struct mddev *mddev, int size)
 {
 	int result = 0;
 	struct r5conf *conf = mddev->private;
 
-	if (size <= 16 || size > 32768)
+	if (size <= 16 || size > raid5_max_cache_size(conf))
 		return -EINVAL;
 
 	WRITE_ONCE(conf->min_nr_stripes, size);
-- 
2.43.0

