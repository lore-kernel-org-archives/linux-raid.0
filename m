Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E473237B3F1
	for <linux-raid@vger.kernel.org>; Thu, 23 Apr 2026 10:13:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776939209; cv=none; b=M0VogFLqbrggnQsI2eYWcP+O8gLeMIUynjPkMcxnQYPMaPuVVrLFJdwiU+0cVJrYH8qvBtXz9EdAmkVrpsByWgrNltbrTm1Z34rP+2jXmGFNbibCu9gV0owNG0zauh59cCtIsNTpIDDTEqQ5B9Cl54+6xV9eoXApHeAeH7YMd1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776939209; c=relaxed/simple;
	bh=Cw61duZfFIwzmmP7y0PuI4JNe8BOIr1dpdcSwvCPyDU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RFTqz32UCs8UgYivHANPflSb555Fz4pkT+mlmrlCU7Xgamy1g12+q8Li9cBs1H284aft5NiBbD1DmtMFRSPZOWFDyvrnjDOM4TnRNWY1Um2qKmha3vZzqdcEocDSCvqHuo9IONh94y1Vt5inqJFhVI4zUXlpbbbSH0ybp5yII7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RA6ZV/3f; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RA6ZV/3f"
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-43cfce3a195so3777909f8f.2
        for <linux-raid@vger.kernel.org>; Thu, 23 Apr 2026 03:13:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776939206; x=1777544006; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pj86MgheDegBTfpeKib/dIuz8OT3FvkhbCKW6+m/FTg=;
        b=RA6ZV/3f13KpvpmCbAHtWXMSZgCiPXxpfYqgCNT42JVCwyEFJZIh2JnJ6Nup6+Fgfu
         mAemOMAY3CII0+D2/m3Q5DIyF8KtwtFoU3OwrKrP5MV1yVxTtmNJ3BDMVgQbOcXLNSV9
         Lzhn5ezJbZK50r7OjGQV+Zy6idacV1jNrbxdZ9FfbHq1KJWugfJd0NbgVORo8hLeVi54
         t4CJFcSWUJvp6I4BfQdWQgN5TbJwPfyYgwFnxI1apTjPbhiSNg3eNlbrZw70Oi17wt55
         6TPKSB19QGEeRuRFjBN93lUVP0JFyV/hR0CifEsQS5y3OS7xHbTq4iAfl/qhP1kexbpM
         ZasA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776939206; x=1777544006;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=pj86MgheDegBTfpeKib/dIuz8OT3FvkhbCKW6+m/FTg=;
        b=qU5SMbr7MwDTvmzR9kVL3NYzBbUzOH98p9hnKvVPpE0DsV1GAvy+fLsRtZ0kS8DB+j
         hOsU6MyAZarHQPzCplp9nlbgoPnQzJEIDCaNVM6u801GZZEeV0W2RGJsCzO93G4GwOxU
         VfX97QIAXvt2dxRCd3NgM3eAwT4LTH9m1CLBSUOJyVwnBdQeoP/hJRteJzc9jwvfFuiy
         is6HNpykJpv3elHOSeMJ0tAOWRyjdB45EQF8teVvhHxdl82TCpi2kqZB+MJ2dsgjl40I
         mckmNBHaVT7u6sR2AUAOXoC8bhcIoRVFVgTcvLZOTQH8uYelpqEu+SyD1DlQ/R9izCYf
         /dKQ==
X-Gm-Message-State: AOJu0YzN6b/rGY0oFrAhjZ9R5EQ7gadP5HAoCL3xgz7SS1TrDRTGABHn
	WyV9NRhlnWJmNb166OdOC+o7Q9YCeNWyyBLCtsBVU6Rm1GP+QeYfWQq/
X-Gm-Gg: AeBDiesNs/EJGHNko26TmmWNzlQ06oV6JTe1Iewe8SBXy0jpotAvVSStRMdeDpk+frN
	i/+nsf4aEcXNPW1t2dTEsvEf9G/Pr3Fw23ikJLywvLWPWuBTXMqMCIsjRZpXJIYUFz0uXyfwKBS
	9YA4xnGJQT+45wqaahDJ/EhDR8IeZS6YyxQ9wahOxDqRsi/kUlr/WQXv56k8XTHHT2dirAakefA
	XNFCQiHA+Ush3pK3OfOS2NBSJNZb3rDqyhPpfy40/4+ctinJrMyFQrQ1/RjIifd0n4vgPe1i41/
	6U1sNymKUTEAh4gWAHzXyJ8pYQykVaEuthpkMTrHC0vnzZui3FH66LytgNzEBTuAZWoS8JrShAO
	RNhruCRUT2H71C1UjzOmPntxSo8pzFFV3h8K0O1v56E63PkvaxsI8eq8aEbf8jIRRKMUkDo6hMQ
	qwNuAiNMwV0VHjst5T9hsi9IEJGzF9o/y5k1k/Bp1aXlmD
X-Received: by 2002:a05:6000:1a8c:b0:43e:b0f8:66f1 with SMTP id ffacd0b85a97d-43fe3e0b86emr40376264f8f.43.1776939205953;
        Thu, 23 Apr 2026 03:13:25 -0700 (PDT)
Received: from yocto.. ([2a02:3037:60e:ee7d:34af:34c4:890b:2c47])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43fe4e4d525sm49741217f8f.31.2026.04.23.03.13.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Apr 2026 03:13:25 -0700 (PDT)
From: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
To: song@kernel.org,
	yukuai@fnnas.com
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
Subject: [PATCH 2/3] md: use mddev_is_dm() instead of open-coding gendisk checks
Date: Thu, 23 Apr 2026 12:13:02 +0200
Message-ID: <20260423101303.48196-3-abd.masalkhi@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260423101303.48196-1-abd.masalkhi@gmail.com>
References: <20260423101303.48196-1-abd.masalkhi@gmail.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Replace direct checks on mddev->gendisk with mddev_is_dm() in
md_handle_request() and md_run().

Signed-off-by: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
---
 drivers/md/md.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index ac71640ff3a8..346d071c1b8e 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -417,7 +417,7 @@ bool md_handle_request(struct mddev *mddev, struct bio *bio)
 
 	if (!mddev->pers->make_request(mddev, bio)) {
 		percpu_ref_put(&mddev->active_io);
-		if (!mddev->gendisk && mddev->pers->prepare_suspend)
+		if (mddev_is_dm(mddev) && mddev->pers->prepare_suspend)
 			return false;
 		goto check_suspended;
 	}
@@ -6584,7 +6584,7 @@ int md_run(struct mddev *mddev)
 	}
 
 	/* dm-raid expect sync_thread to be frozen until resume */
-	if (mddev->gendisk)
+	if (!mddev_is_dm(mddev))
 		mddev->recovery = 0;
 
 	/* may be over-ridden by personality */
-- 
2.43.0

