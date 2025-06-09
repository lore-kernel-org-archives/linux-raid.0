Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34E37382;
	Mon,  9 Jun 2025 12:02:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749470559; cv=none; b=FAekalHaiDplBXE2uWIUsYEBekHOxzPaJpeoIuqlGNTTt26BVZiRXCUsFsjrxs0pIuaRAn7uES7zra4c4+jLgbHCw69XaWgDe7aS6Dlquya7Jx3+JMfxOsQN4VgOEOBuZ2yZ7Z/v99jT6bGKn/6NUE9LW9dAIolCET8TiKZ86Yw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749470559; c=relaxed/simple;
	bh=hUI/7vtyq7Bx1Dgc9vhQlu8w98j7gJVUQLJ+EYtLyqw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=X3YmQM54WerpmT+C+d6ixOPRkRfrzg6G5FbjSXQgUVauL2l59AD+jnIfs+4a0YzrySXyePpIG/rPJwt5vBGzPHprxrwUcAUx+B3l8Uz2G6aZCmJaTzd+dhtyxud56GfkPnPgBvBTtm6F+RUxZm/zxhO26LwlkDZW8N25grIFTGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XfSgQNGa; arc=none smtp.client-ip=209.85.215.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XfSgQNGa"
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-879d2e419b9so3524043a12.2;
        Mon, 09 Jun 2025 05:02:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749470556; x=1750075356; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Gfd3Li4EbMS7Htafu1RturGqSahq6wn8ijbS0IChQm0=;
        b=XfSgQNGaDxeDong58Vk3XLFt44wmsnZiKZCwUgHzn87RTgqtuli1GIj4OiunT7jiSE
         5Mj63b13F01gCkWxKdefsAigWjhA6S4Vs2jijrXyltg12XK0QNFVugurOgbDGJ2+R9fJ
         6vMradn5ikyCL7JooaFpBPIzjh8bd3u+UXgJ67QnoX5rFE8bRRDOuL4zu9pqHeVcbqve
         6t0S6ImoLGkjMliGhO5QYUe43uH6/y4SV8ku/TaGdF4e92RAdRNsJN+gtP7inMEPGQ0j
         tdIdM/jZeLgjUrtugduq5by7KsVpL49iDKnr6PhwM2owVFcoT3YDHxtYEOqWzAfdupsg
         5qzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749470556; x=1750075356;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Gfd3Li4EbMS7Htafu1RturGqSahq6wn8ijbS0IChQm0=;
        b=Nbq0q+J83PEb3c4apOQfEO1SzbkbNngDWxyq4k4lof6CHEeh1C006yRtC5XPogF1ri
         X1us9lTMgHg3IgXLnL3E/0JMa5oUgizsPdeXjHTPXNZEIcv3BGwszRdYFGsoNYBIt+8M
         gnhDNQIkf5pyofrHd32Guuk85P/XfxFeEx90GQGeTuWhvvAfCepM6lHI2JpPcwwg0/4V
         /31+6Q3DVhPPBSKLZ1HjSYDIt+0R01W/OJkFSNX0w9OEAsiDpXqrrELoNITyjpV/f3BP
         6BGthwBES7/bCsfRzJuc9tDnnPCO3tAzJHCInFDMBvMBoN4bkAlxFw46Tm3uH3BsmPHz
         HRSQ==
X-Forwarded-Encrypted: i=1; AJvYcCUqnQyHItYikdR0QDwQqI6cxwiqFcac0+fD53vw+EV/FfdubaL9MivgIvrI3vzE8zX0GlUGbXACq0m0V5U=@vger.kernel.org, AJvYcCW05NDKijoFkrshK5bQQj3ZO3l3xBRnF3tbDCEaWRc7Nnomp/zpwGqzDW3vKBzTfsCPmCyfABvS/v4HqQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YwjSCQmUTYPVl3jq+qZLLg0+MjAm8sOh8cYugoJiEYRpZljWTSB
	ZH5++vVYRav9WDSBQHSD9aeCgVpYEVtUJ5ghbsqVdMHSAb4feFEoZxxRFEVBT6El1TQ=
X-Gm-Gg: ASbGncuSTu9mnULrScw+0uLC1pwPog/NOXDFDpltxqqQ07bmNAMnLX7kyMIjr/ftGhB
	C14FK8DD0wZmpHkptSzbb9zez7UM/xobjP9RP4gz56Ks565pj830xbZDlROlrnwOiU9ECSGET4O
	1W4X1vLL9Add86FAppYe2+FhMWmGFkLKFRfYMcrKPSmwlt0VJ1nLH0Ae/T8NShc4lURr4b+c1zn
	+LcGxMRIxTvBmDre5KWOJ4BUr33EqcLaBDtV6hjA4KKzTivPt7ksEfqv2WVKGnz16VMZ4z8azMl
	qvy+rltj3iyZAp9N5qgf6f2nMjQjV7B5xc0My5fpqokrq1LN+XXGf+zEx7x+rfNxAPua1asnAtr
	nhVIa788=
X-Google-Smtp-Source: AGHT+IEL7tIHavCXzwAN3npH/Dc4rjqnXrWw/qvTQbZU2xqJ8J9G8DBDEoGT8ZllwA5A3oPN7XrgPQ==
X-Received: by 2002:a17:90b:3b46:b0:312:29e:9ed5 with SMTP id 98e67ed59e1d1-3134705cdc1mr15610180a91.23.1749470556327;
        Mon, 09 Jun 2025 05:02:36 -0700 (PDT)
Received: from localhost.localdomain ([103.169.92.160])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-31349fdf5adsm5524780a91.34.2025.06.09.05.02.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Jun 2025 05:02:36 -0700 (PDT)
From: Wang Jinchao <wangjinchao600@gmail.com>
To: Song Liu <song@kernel.org>,
	Yu Kuai <yukuai3@huawei.com>
Cc: Wang Jinchao <wangjinchao600@gmail.com>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] md/raid1: Fix use-after-free in reshape pool wait queue
Date: Mon,  9 Jun 2025 20:01:33 +0800
Message-ID: <20250609120155.204802-1-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

During raid1 reshape operations, a use-after-free can occur in the mempool
wait queue when r1bio_pool->curr_nr drops below min_nr. This happens
because:

1. mempool_init() initializes wait queue head on stack
2. The stack-allocated wait queue is copied to conf->r1bio_pool through
   structure assignment
3. wake_up() on this invalid wait queue causes panic when accessing the
   stack memory that no longer exists

Fix this by properly reinitializing the mempool's wait queue using
init_waitqueue_head(), ensuring the wait queue structure remains valid
throughout the reshape operation.

Signed-off-by: Wang Jinchao <wangjinchao600@gmail.com>
---
 drivers/md/raid1.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 19c5a0ce5a40..fd4ce2a4136f 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -3428,6 +3428,7 @@ static int raid1_reshape(struct mddev *mddev)
 	/* ok, everything is stopped */
 	oldpool = conf->r1bio_pool;
 	conf->r1bio_pool = newpool;
+	init_waitqueue_head(&conf->r1bio_pool.wait);
 
 	for (d = d2 = 0; d < conf->raid_disks; d++) {
 		struct md_rdev *rdev = conf->mirrors[d].rdev;
-- 
2.43.0

