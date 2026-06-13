Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E723314B8F
	for <linux-raid@vger.kernel.org>; Sat, 13 Jun 2026 18:28:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781375308; cv=none; b=n5g9Qa6yfLn//nGNO7fEcmqfy1QKWFM32coCS69vrXvuftXul/4iVkZwdTdAFPpL7X1fDqRQm8A6rm33VeUrl5s0xPC25bAwkidCOrKb7uiRzBIip/DtMA6ywN7Ed7yiTvrgQNFnNzxckMEaFnaA7YWpqOxEnfnahFxMtJfQ8wA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781375308; c=relaxed/simple;
	bh=8ZkjyDCmBeMp6Lp8hhEHzHjFWd+c3fExX2yd98X/Alk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eLluN/uakkD4clz7Mg6fjdraBU4oLoqLsENLp8scV7xZ/E5TeiQGji7XX3C/NoudJTate0DQsb6pazvcyaYEZPYWTpdGZLZ1tdUnXgNxUryn1vzMtgr4MAXV58TAq+jMgBiaoaYGNUD38Ft+DlguqzZN+Yy4Sqa2hN/iT/U4998=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RC0xGOeU; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RC0xGOeU"
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-46013161068so936028f8f.2
        for <linux-raid@vger.kernel.org>; Sat, 13 Jun 2026 11:28:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781375304; x=1781980104; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zjWi+S6jDskwftAxrO6nheJGxPEoq3XczJr2SHMLRUU=;
        b=RC0xGOeU8Cl1Ijc7pv2ZyqdOCFmICuaXHXPh0lZ06h4Wuak4e88xr3jak3eFMF3VCn
         OLVBG4kICLB8KIhXSMARxqWpB2EHxk2pEmQe+3AiwV8H6QgaaTQwOEm3jh8IHc4zsof/
         ri+u69EDLVh13F1HsA4+LwVWGQ1SMIPQskrzZp9L8cYJSibeMbaFyBlwKFdqCpv7tl8n
         Ln4kWNWvLPreUdooipqEOxy54g0XwFP3gOqaI/TnRyLF7etc+oe1Uqz6Gxs7p1/LEjxH
         FEaNwQsdVNeUAq9Y0t/Ndtz9l4+UHIn+K8sF9NCtEHiUEHEQseCT6ul+rpJXbXM0yR3E
         pTFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781375304; x=1781980104;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=zjWi+S6jDskwftAxrO6nheJGxPEoq3XczJr2SHMLRUU=;
        b=oiDOfxsxWWLMGi2llbs3wAM4wCAQUBrzpbFP6XWTdeo7TNRkMX2xDhPMPdJNGTLsuQ
         DEgviZYXCDqBi/0iWFE9otptRcsvpFphiMhA+LIURPYPzJeCyUKYGh1KE4jqza5IjIU9
         am4mWSO13XhheTAmr6kwuoJAOTn7oHZs+i1FAa7lRytFL1nesrNb72Jw7mcggTQwSGdL
         C0jRD0GE5FB/myIinCVIIV4GsRBIANPDVPdC3nUIxII66fsIx+c0X6MyNi7+IQdiNHW0
         W+gZ3GQAnrb2puJsHr3TGiMzpCc+2xYQ1UCQA8mt9D2b3GbYYYnjr3TuI5bDNiygxqLH
         XdcQ==
X-Gm-Message-State: AOJu0Yw40fyJOEqJ9/FFO7qky+7QvSNmxLGLPLql2pWZOsuhmegJ0n2l
	zHrWX4mWBbp0E/qZBkwT+wQTz8QiEqKGHj2KdPrNIUOTm351opmKciWB
X-Gm-Gg: Acq92OHXQ/F5L3crAi5YgdPD+WGJKExTHOsPn0x/LQtUKHPN0yg6Yf7vAR2oYRrw+uz
	JuctFAHFI+i8EMqMvjOGel9eUY8mNC2wILni7M8VNVgz7EuPIX304pmnSLMQQjJwb1Sk0YFN3RJ
	jdyODjMO5fq0eH1SB4M0f3nwDV68KIbN8h2Oat3YGbsnsmHKKs4t07doDtlj8Og5x9pNTksPnEf
	ebKuIV4luXrjno3LeSnyIhab1ku7DNYMaOiHEOoaoi3OmU/VOWgNWVzQAQB7woIjetoGWx/DCqZ
	uvKcOssku0HxFtXx/MwItdgljQN/Bhc6+wzAKaeibiceyRZzO3X6XRjppZ7NWQTaib1TUhItdEW
	n3RlzLyaIjykGxY9yW4wkgIo9oipH1jfPco9D+unj9UCBK+UC19DlXKvBhOgB/Ei8uMaAzJlTsa
	wU72f7fyaFeoFUGnMOF5P4uY3IlgqkLbYh8Owt/AjQ4cb8MDSZDiPY3jsltCRWjGcmyZNJcp2/w
	uuNeprOQfVIKg==
X-Received: by 2002:a05:6000:288e:b0:460:ff2:63e5 with SMTP id ffacd0b85a97d-4606db99da6mr12112396f8f.18.1781375304257;
        Sat, 13 Jun 2026 11:28:24 -0700 (PDT)
Received: from yocto.. (dynamic-176-007-197-181.176.7.pool.telefonica.de. [176.7.197.181])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4606f2c3782sm15353944f8f.25.2026.06.13.11.28.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 Jun 2026 11:28:23 -0700 (PDT)
From: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
To: song@kernel.org,
	yukuai@fygo.io,
	magiclinan@didiglobal.com,
	xiao@kernel.org,
	axboe@kernel.dk,
	hare@suse.de,
	john.g.garry@oracle.com,
	martin.petersen@oracle.com,
	vverma@digitalocean.com
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
Subject: [PATCH v2 3/4] md/raid10: fix writes_pending and barrier reference leaks on discard failures
Date: Sat, 13 Jun 2026 18:28:09 +0000
Message-ID: <20260613182810.1317258-4-abd.masalkhi@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260613182810.1317258-1-abd.masalkhi@gmail.com>
References: <20260613182810.1317258-1-abd.masalkhi@gmail.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

raid10_make_request() acquires a writes_pending reference with
md_write_start() before calling raid10_handle_discard(). Several failure
paths in raid10_handle_discard() complete the bio and return without
releasing the corresponding reference, causing md_write_end() to be
skipped.

Call md_write_end() before returning from these failure paths to keep
writes_pending accounting balanced.

Additionally, discard split allocation failures can occur after
wait_barrier() succeeds. Those paths return without calling
allow_barrier(), leaking the associated barrier reference.

Release the barrier before returning from those paths.

Fixes: c9aa889b035f ("md: raid10 add nowait support")
Fixes: 4cf58d952909 ("md/raid10: Handle bio_split() errors")
Signed-off-by: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
---
Changes in v2:
 - new patch.
---
 drivers/md/raid10.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 5ad1b0c6207a..aacf160ee9f2 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1639,6 +1639,7 @@ static int raid10_handle_discard(struct mddev *mddev, struct bio *bio)
 
 	if (!wait_barrier(conf, bio->bi_opf & REQ_NOWAIT)) {
 		bio_wouldblock_error(bio);
+		md_write_end(mddev);
 		return 0;
 	}
 
@@ -1681,6 +1682,8 @@ static int raid10_handle_discard(struct mddev *mddev, struct bio *bio)
 		if (IS_ERR(split)) {
 			bio->bi_status = errno_to_blk_status(PTR_ERR(split));
 			bio_endio(bio);
+			md_write_end(mddev);
+			allow_barrier(conf);
 			return 0;
 		}
 
@@ -1698,6 +1701,8 @@ static int raid10_handle_discard(struct mddev *mddev, struct bio *bio)
 		if (IS_ERR(split)) {
 			bio->bi_status = errno_to_blk_status(PTR_ERR(split));
 			bio_endio(bio);
+			md_write_end(mddev);
+			allow_barrier(conf);
 			return 0;
 		}
 
-- 
2.43.0

