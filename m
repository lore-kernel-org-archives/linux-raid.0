Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56F113B0ACE
	for <linux-raid@vger.kernel.org>; Sun, 28 Jun 2026 14:24:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782656684; cv=none; b=MU8i5T+gLeQYiWUZlasmy6hBNGM2AGYwOIEQchG4uLLQkVZ5Tn5mtZg570yLiDAx0G+GhZpvjtrypb1ObEEqYlba9hN7ypW53TgzadIOEJc3mZcxCgRgffSwFUPlUBd7JteBuCaVYjTHPl9GnWLMBYzvIbjPQG9zoJWdgxQu3CI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782656684; c=relaxed/simple;
	bh=EO0m0K8rSa2tELZjUwjg8KLl/9gugHSGHFuoAdJrprM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ceYLTJIBj1h1e6daMJDyYIYvudN2KpsG0BgH8RcBA+HjIGPkcctGCjYTl8rG6wvYWgZgW4WuYas+zpsmPsrZ/1nqA7h2MEtp+BGQ0Zf41CVmx9sivwYD6myQmi+Z8NzyAc3cTolhaxXJyjvtQ6tYceOTvD67lE4oqS4S2v8mjAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jQ3IGYRu; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jQ3IGYRu"
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-472493849a3so600024f8f.2
        for <linux-raid@vger.kernel.org>; Sun, 28 Jun 2026 07:24:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782656679; x=1783261479; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TKuyCmWs2E7JDEkin4R0TGEGqQzvyk1q20RzvcOKT5c=;
        b=jQ3IGYRuMeu21ISwyAxRKZebVZZD6gyiyhGOVYHzRWJyZ/Dg7gAoAqqxjz/Tyh03+n
         SS5zxtuYvDUASOnEPOCQ6D71d6gfQvd84ZFDA3PU4rgyQadPqq1u3rOltnUwjvcTNkT6
         WXsn0YO3inQk5lQTk9OtyuYd9N0m1YqpKBZdEI5NleCu3DMysmGyhHMenInmE/k/tkj8
         3rod8d9vxRMlxFzKT1xG8Hwzr/baOZgCgH5Lzr1ixkI5+JzA6HSgywmUep2S2Vs5O70o
         RcFXj657EX17tnTC9blORMMXLjVV5H/OgTKULmWqx7ecjWJO+rSGur+8ISAT7nMaGNd2
         3TpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782656679; x=1783261479;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=TKuyCmWs2E7JDEkin4R0TGEGqQzvyk1q20RzvcOKT5c=;
        b=GhEORl95IwiCoaG1M0N/ct0A4s8L/VWbXRQOIt7TB4GJ4vwnNPc9/zBWogLNApGbkx
         AXFvGLt9y4XsjNP3NacRNlVVqLc00g2xvfKvfD3xm6hbD5ujKW5eAumEJhozCsLFOIUT
         nteL53Gg5jtPO0RhMyXwv2yyLLbMCCuy67JSkTwbeUysEhHTBbKlAWM2ICUnywGn88if
         vrrJTYEkGLcfx219BpM9BmA5gFBEz2IfhKmR2ifGibcHyUoOpav7GxOVYhLJtQmOIQmf
         KfQ76OaN/aDFEFxNkn8z70o9IL0ZfslVrPnBNCD23EZlA/01GgMtBQQxGjzMjom4OGtw
         qsxA==
X-Gm-Message-State: AOJu0Yy0CVGTXBpsttwyQ8bd1yBt9tRT3FzOdRy/vCsif8tjKKAtx5Le
	BJpVFkSbsj+5300tSK6NUU9HtO9MmMcm24r6Dpnvxfx62o7pIYCwlegG
X-Gm-Gg: AfdE7cmx6AcVnqRp/3Fec45geHEi6G50yUJCPZ6HASAdC4p7RBqWO4hi0gGeuEhQmVh
	SyRNsOVNV2R2RuiSGY+k4FaEsSamcdKkMTrPhZ8wZdTAlzvhk9UrTylg8JBN+ocs4AuP8EFklf9
	U0JGq3XCk3ZkmuVD421RdtB2EJQ0y8FUmvySDGq5GrXRtoQTKcUX+3RoHS5+IQfRIlzBrXAqTmM
	v8RVw64X8lbkeNbweKMjiwC5o6pYoDUrIDrNzaPSHa52jFUYsgAleHNhM65FNzm+XZINYVchfbU
	OToUA3lE1zz8mddXVhXWYCTEbZS7LF8Gv0O0soU7d3Pi6/rGj+uEU90JRTWGYGi52jWsGC8gkOF
	yqOYSLXy1hezoNAxDQxBzEUMUNh1eB0zk5rAX+8IQOgPKk+HLWAW568vSeW3hKqbbOBmspSjQjy
	JmlotN01xewKe2HeQgECr07WHYmsPbDjWdbYf8JfoxCJyE/BBxPWe4nchgfJ3pLuthkQsToHcrb
	JVfP+s=
X-Received: by 2002:adf:e183:0:b0:46c:f9fe:1e9e with SMTP id ffacd0b85a97d-46dc12e0128mr20202520f8f.31.1782656679371;
        Sun, 28 Jun 2026 07:24:39 -0700 (PDT)
Received: from yocto.rz.uni-frankfurt.de (cb-8021x-nat-134-108.net.uni-frankfurt.de. [141.2.134.108])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4728072189asm7819927f8f.30.2026.06.28.07.24.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Jun 2026 07:24:37 -0700 (PDT)
From: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
To: song@kernel.org,
	yukuai@fygo.io,
	magiclinan@didiglobal.com,
	xiao@kernel.org,
	axboe@kernel.dk,
	vverma@digitalocean.com,
	john.g.garry@oracle.com,
	martin.petersen@oracle.com,
	abd.masalkhi@gmail.com,
	linux-kernel@vger.kernel.org
Cc: linux-raid@vger.kernel.org
Subject: [PATCH v2 4/7] md/raid10: remove unnecessary barrier around bio_submit_split_bioset()
Date: Sun, 28 Jun 2026 14:24:17 +0000
Message-ID: <20260628142420.1051027-5-abd.masalkhi@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260628142420.1051027-1-abd.masalkhi@gmail.com>
References: <20260628142420.1051027-1-abd.masalkhi@gmail.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

raid10_write_request() drops the barrier before calling
bio_submit_split_bioset() and reacquires it afterwards. This is no
longer necessary because the split bio cannot re-enter
raid10_write_request() while the barrier is held.

The allow_barrier()/wait_barrier() pair was introduced by commit
e820d55cb99d ("md: fix raid10 hang issue caused by barrier") when
submit_flushes() called md_handle_request() directly, allowing re-entry
into raid10_write_request(). Since v5.2, submit_flushes() has instead
gone through submit_bio(), eliminating that recursion. submit_flushes()
was later removed entirely by commit b75197e86e6d ("md: Remove flush
handling").

Currently, raid10_write_request() is only entered from the bio
submission path, so the split bio submitted by bio_submit_split_bioset()
cannot recurse back into wait_barrier().

Remove the redundant allow_barrier()/wait_barrier() pair around
bio_submit_split_bioset().

Signed-off-by: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
---
Changes in v2:
 - Expand the commit message to explain why the
   allow_barrier()/wait_barrier() pair is no longer needed.
 - Link to v1: https://lore.kernel.org/linux-raid/20260623072456.333437-5-abd.masalkhi@gmail.com/
---
 drivers/md/raid10.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 3480fc7907f0..2574f60dd771 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1487,10 +1487,8 @@ static bool raid10_write_request(struct mddev *mddev, struct bio *bio,
 		if (atomic)
 			goto err_handle;
 
-		allow_barrier(conf);
 		bio = bio_submit_split_bioset(bio, r10_bio->sectors,
 					      &conf->bio_split);
-		wait_barrier(conf, false);
 		if (!bio) {
 			set_bit(R10BIO_Returned, &r10_bio->state);
 			goto err_handle;
-- 
2.43.0

