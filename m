Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B59E5227;
	Sun,  1 Jun 2025 01:37:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748741835; cv=none; b=JLj45JAr+Fx/ryeUcIcOFAvuuXHQEfKbbOW1eALpHqIQLmzZfY5zywY/5YLHAMx1N+Z2ZpvOSrdK8LZqcVv4sL7w4l/8j8rxs3H9thl8A+iLb1dGIfTXBxxwRB0QFX+n8LnDhsuTQJZskDfFdsmFJuAM2+ms3JqqFDvXLWHfpsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748741835; c=relaxed/simple;
	bh=SU1V6GH+cr+xNkrqU4FFiFCmgkjJw11YhcIIe0O03WQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=oVBtIBQQQ1NEE7LXBsDp/HP0hJ93r0ZMn25yIn5+tEhhtr0vydWUq9yM/dbDlALPoKToZWrUdt4fWxRUg4PPIB57/7nG+OPaf9JR/G47dPQDcVk/n1JqhY4IWYMTAHzJMGnDo9dNleSNfEUL4VsG1k6XOq+Vna29ZZE3NnkwhLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hzvIWJK5; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hzvIWJK5"
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-74264d1832eso3542618b3a.0;
        Sat, 31 May 2025 18:37:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1748741833; x=1749346633; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=XBB8Z08DBWj20sNytHiHW4XlRZp1zln91yg7EAs9rLE=;
        b=hzvIWJK5EB6gS62Pk0FTZwEfiHiJ4rp3fyMxy6IdvfEQmkCsgZyPcIv6VlV4JhZNdT
         LGEF1wdf8+bPH+CH2RF5Q+Plf9j1S+t7c848rp0OBkVpaqF80OPBzZLTIpiKqupZeJC3
         8gr8cU9SAK5hu5a8vMcOJBYTMK1Sv+XxMxjqrajFRzYnxu0SeyNXz2BM6ZhklXLfm390
         NaP9zR1Db/b1s/xOguJfnlSYOf7sL+xLNHTTxgxfZ/U31QBgAjngMG2HN+eYOXk1AmTS
         1PWJQz5kPYQXW80zhIpoRg6B1LDiTt07TXfEe0yZQEpERc9Oy/8XJjlBtEdEh+HWOM+R
         XRFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748741833; x=1749346633;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XBB8Z08DBWj20sNytHiHW4XlRZp1zln91yg7EAs9rLE=;
        b=PbA4Xzns2WMgg5GMndXJ4vUMOWhId9mA01SsOw9VrAx07lfYoJBeA+9wj8Oj2yrVj9
         wwxIxBW4OdYntmzXN8AQo5xaVbec9OSWQticsrTaGvucVaKzUMTGfvYuPxsMAeI2Mog4
         eBUrB3aseUToQWNFCO+BVQbS7PEdC6tAD2OFgc/VxhmpbE16+qkJE0Yho0pufjReM2S6
         UgvjB44/L3tZtuocWuQHbmUVsUyNgZw2y9m31ZwbgDVmx8soYkuYo3yhJRDyheWXKPvb
         6C1+jhwPT2VGFpqPSwJ0gfffupe+lqnq5SsEsjAyXAxFHKGIt4hmLruS77J+yjOFWrER
         WF3g==
X-Forwarded-Encrypted: i=1; AJvYcCVbAOsvojaKw6VmV/9qldtglVkSwmlnRo4bDcp2X8QiUf500ogdHwhvZjtzZU9c/pZ1BqT/E/tV+XVnh0g=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywsl8AExAZHK+oREJnQtdNCcM+4nSo1DDA9xYMSaR2g5j0B5PDL
	YkV0kwwHwhPYJbDq3+3j1gDQeoAoxnFNCW8aRBhB5gvAjMjSAhOW0UoH
X-Gm-Gg: ASbGncv3h+NplVDTpJasCsXNd/laa7Elc7x2KfyM1+pENnLAUooPz8yFNbtUWLHtBA8
	bSMRknELfPjLhSlxTke7rR2y4VdptSfNcVFleuyq+WV3w2B24Jf7AA+jS80Cu7p0fIty9GvktpA
	+wZXy8mq3eVkFrkhWZEGQKxiVYr9AKejBIqbZnhLIuK4I9mUdQYYR/h3ac/62L8Y6Dbu+TaF2C0
	AXq8n9bLbTiSfR5vaijLPjet84muD5PyKqGNJK3ZHGuGRpROQZ6L1hIXilfds9GXNSDuRvVOC0w
	u3wZRPBktoDq1DHTIdAKysGWXdZQauSYDHjfoyp8gSVNBqImNFCRA7bqnGrPxALiupT4Rlh6Uf2
	3PtHCqPq5s31PqhHStC5zQWLXwz0OVaBHB9b+arSWIBMRWQ==
X-Google-Smtp-Source: AGHT+IGhx/KSq0fLsLPm9zYiCvrPZDGjHwix0dY0/zcU2GP7D9ngkYx9ICorIlxi50lJ16Wi94OgQw==
X-Received: by 2002:a05:6a00:3e0d:b0:742:b3a6:db16 with SMTP id d2e1a72fcca58-747d1ab9db2mr4697888b3a.20.1748741832858;
        Sat, 31 May 2025 18:37:12 -0700 (PDT)
Received: from DESKTOP-NBGHJ1C.localdomain (p12284229-ipxg45101marunouchi.tokyo.ocn.ne.jp. [60.39.60.229])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-747affadf5asm5186202b3a.115.2025.05.31.18.37.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 May 2025 18:37:12 -0700 (PDT)
From: Ryo Takakura <ryotkkr98@gmail.com>
To: song@kernel.org,
	yukuai3@huawei.com,
	tj@kernel.org
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Ryo Takakura <ryotkkr98@gmail.com>
Subject: [PATCH] md/raid5: unset WQ_CPU_INTENSIVE for raid5 unbound workqueue
Date: Sun,  1 Jun 2025 10:37:02 +0900
Message-Id: <20250601013702.64640-1-ryotkkr98@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When specified with WQ_CPU_INTENSIVE, the workqueue doesn't
participate in concurrency management. This behaviour is already
accounted for WQ_UNBOUND workqueues given that they are assigned
to their own worker threads.

Unset WQ_CPU_INTENSIVE as the use of flag has no effect when
used with WQ_UNBOUND.

Signed-off-by: Ryo Takakura <ryotkkr98@gmail.com>
---

Hi!

My understanding is that unbound wqs are served by non concurrency
managed worker threads and is not tracked by wq_cpu_intensive_report(),
so this should have no change in behaviour.

Sincerely,
Ryo Takakura

---
 drivers/md/raid5.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 638938316..8f3b45161 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -9048,7 +9048,7 @@ static int __init raid5_init(void)
 	int ret;
 
 	raid5_wq = alloc_workqueue("raid5wq",
-		WQ_UNBOUND|WQ_MEM_RECLAIM|WQ_CPU_INTENSIVE|WQ_SYSFS, 0);
+		WQ_UNBOUND|WQ_MEM_RECLAIM|WQ_SYSFS, 0);
 	if (!raid5_wq)
 		return -ENOMEM;
 
-- 
2.34.1

