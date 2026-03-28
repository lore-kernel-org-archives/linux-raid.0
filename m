Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B28E433AD
	for <linux-raid@vger.kernel.org>; Sat, 28 Mar 2026 19:35:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774726530; cv=none; b=eKZ3EKBV9l8rVCHeV3KnYqXYCb0ecqpYwxJaZma/q7IJNbkrE5nsbxNwlqgQyZO687KrRFVlUBi1X5hY30jPLp9HiKPT6zLRGG1QoIfI15UIYG/l8ig9qftYFt8nWVwiwvqIkt84BgR/JshF/55gnZ45vNBd0EJ9ZY21MrYHRrk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774726530; c=relaxed/simple;
	bh=zZIVRuY1Ti5TOfuBmLVXC0uqUcO1Y7sB2zFaeCrQqcE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=iqP1MVqJt41Cnh6DF9zEyjhhmcd/Nez2ABBQN1cvFrN2LZ25P6ScVGkOhUZFbudwxEvbimO+0z387ie82VMGQamp2iWi6l7J7CppSwZivudHFMngJ4qjMgqMoZuLd5f1FEIJ0BW5QXvGyJoFEtcZrKom9aPp7hXbUJRxEyOEp/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kmdGaU/U; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kmdGaU/U"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4852e9ca034so31396485e9.2
        for <linux-raid@vger.kernel.org>; Sat, 28 Mar 2026 12:35:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774726527; x=1775331327; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=73MU/FvCqpDphP66y3Z+gzezbZIs09cTmBy/S2GIzIA=;
        b=kmdGaU/UqQefQGU+dMDVz47mC+40v4a1T16Ce8sFbeGMudGagihdAM1p3+7INxJRp7
         fNrL58KhyLc5NwIxogB86TiQ3qrZWR9Dm7D6coBf42Y/JQvC3IrcTsS8oH5ZDd2MzX8W
         G/e0S1Tk7mvPQmY7nZLk+4oY7hov4Ytr0tvCQq/pxWWR8MEEXWA16WuRoFgJDX+llZz8
         rszHOAuyQYW19hNyM+sSBwsOxVg7PruzlMpUlNFjGRca58KX3MqOHEnCctqWcpKa2T+e
         POJZbwvxX0cLyOU0BlPpSp7D1O5W7WvEyj/NQk/atlhpNXeRkknMgBwQOZoBa24wAfc9
         XAEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774726527; x=1775331327;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=73MU/FvCqpDphP66y3Z+gzezbZIs09cTmBy/S2GIzIA=;
        b=fytB82sTSFatJJM1oXa/UGrXncjlGTadjHlVlE6tlDuDKRWO7xKJCKvq217bWdZLcM
         G2nErc/sUpZ4DOt7ToT/B4tFhgvRtnwIuViV4qkVeiOI7Bkk8n8x87bQwxycY2CliD1N
         2AGNox6gKj9+B/pCjBawafYI+aUGoVTCFp/T057Fa9lENJA6WqTT7i2zTLHtvlextL1V
         EqRe98mlV94bda0a/7KlXOdz6qV4iVY89QwkFw2/iQnhQq7OHTSagdhwOQ3/E8L7fdY8
         YwGmq6FykGFd95Hgo4d1mhs/cyJ8r+ZMFUQnfJezuqUjHYaTzeVlTz/9gQ490WrKMQw5
         /llw==
X-Forwarded-Encrypted: i=1; AJvYcCV9PK/zptRl/0CqftlPMYJSZ1RQI5Glnd7O9pcqSTq6o8qtSoL+ZIqm5zNlYZrii3MDlmdZ9TBTM5OS@vger.kernel.org
X-Gm-Message-State: AOJu0Yzc2n4u5UbXP4TJ2NW5UMGRdcbje6DUo9Ux3PJSsAu2rQzZm3CX
	wafg+Q9T8tA3J1C0xXsOS+dEweol6dLYaD4bJ5/1mP996iQPg8gW/cchbVNmwA==
X-Gm-Gg: ATEYQzxzs7e7YEbi3X01/jxX6Ue13d6+gV5Bu8h2wkOF3msn241HLKGdlT2Wetbr78c
	GnQkMzYFZ7zhTrbgnNwzzekMw7NRsz9NsIDp+eLk5agl+4mrIS/NDGomVzg/wzuErVRcj5ZUbeG
	DeWMonuYZmhMNA3RhEZ8VRBZxQEc8MbhKDAdBg9ojXODo5GFFOos0vFxX2fJt4QPATvkOOIZ+VP
	9GlV+Nnk1wqa0NQCHSsch69cE3ArIUXx9bwL3SrVUCFc9P2bZoRqFPzKe0hSQaThXTqFmdnxgXk
	QFvPYzCX94Tl2rS+MsPduY/m5N8V7bMwqfI+E+VLAVoKhd9tvJzbqRPC7JYWAM/xRxscCTgDa5J
	rek96Wq0VOonB6Kt2R1gll3C/eslQXn/GX6L2TiTlkVelbiCAXEORvffpG4x3CdqswcJUgxykqr
	NZUr2A4V12u0mJUv56CrQFywVg
X-Received: by 2002:a05:600c:8215:b0:485:3dfc:569 with SMTP id 5b1f17b1804b1-48727f5fe53mr109675045e9.16.1774726526738;
        Sat, 28 Mar 2026 12:35:26 -0700 (PDT)
Received: from masalkhi ([2a02:3037:603:38f9:9a24:c56a:2585:bd97])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48722c6b4d0sm166876475e9.3.2026.03.28.12.35.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Mar 2026 12:35:26 -0700 (PDT)
From: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
To: song@kernel.org,
	yukuai@fnnas.com,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
Subject: [PATCH] md: remove unused static md_wq workqueue
Date: Sat, 28 Mar 2026 20:35:22 +0100
Message-ID: <20260328193522.3624-1-abd.masalkhi@gmail.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The md_wq workqueue is defined as static and initialized in md_init(),
but it is not used anywhere within md.c.

All asynchronous and deferred work in this file is handled via
md_misc_wq or dedicated md threads.

Fixes: b75197e86e6d3 ("md: Remove flush handling")
Signed-off-by: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
---
 drivers/md/md.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index ac71640ff3a8..64bf08f16c0e 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -84,7 +84,6 @@ static DEFINE_XARRAY(md_submodule);
 static const struct kobj_type md_ktype;
 
 static DECLARE_WAIT_QUEUE_HEAD(resync_wait);
-static struct workqueue_struct *md_wq;
 
 /*
  * This workqueue is used for sync_work to register new sync_thread, and for
@@ -10495,10 +10494,6 @@ static int __init md_init(void)
 		goto err_bitmap;
 
 	ret = -ENOMEM;
-	md_wq = alloc_workqueue("md", WQ_MEM_RECLAIM, 0);
-	if (!md_wq)
-		goto err_wq;
-
 	md_misc_wq = alloc_workqueue("md_misc", 0, 0);
 	if (!md_misc_wq)
 		goto err_misc_wq;
@@ -10523,8 +10518,6 @@ static int __init md_init(void)
 err_md:
 	destroy_workqueue(md_misc_wq);
 err_misc_wq:
-	destroy_workqueue(md_wq);
-err_wq:
 	md_llbitmap_exit();
 err_bitmap:
 	md_bitmap_exit();
@@ -10833,7 +10826,6 @@ static __exit void md_exit(void)
 	spin_unlock(&all_mddevs_lock);
 
 	destroy_workqueue(md_misc_wq);
-	destroy_workqueue(md_wq);
 	md_bitmap_exit();
 }
 
-- 
2.51.0

