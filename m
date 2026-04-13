Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8BA63DA7C2
	for <linux-raid@vger.kernel.org>; Mon, 13 Apr 2026 14:18:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776089893; cv=none; b=CUQzOUaC3KNwYa3Ytpq574iDlaw2MN5b6hhJGDw9nfKXQlnvvVYT6m1XZ259fbXhrKuUI0lc/fUXsFU4c3KT3uUwNHTcMp+YWOfbD4Lr5cIeoFbcwJ6gyE4xBFD11NDBneyVddMgKPkxh8nWocGCGl6wYVkgOAJDJYjoSbXNURs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776089893; c=relaxed/simple;
	bh=52DKUzSfxH+6to29E7Q2NvM2A03f/yaUTaPX88jYODY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=G92FDhq+kVL3p7Bg+aP3b6FgK0FhZvvoEmdV+zTGCFwixfGWZrMV49E8NPuKKGEcdivlmEcWMGUcaqgRj+QxdCrr+hHrDCSzDodbEnAmCx8UckSVBPs54hBVc5XcYcRo/8cOHrfJA2M6q3aFtFbGyt4XLFyAd88b9/UkzkUYelo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WWkJp4jQ; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WWkJp4jQ"
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-82cebbdab08so3387094b3a.2
        for <linux-raid@vger.kernel.org>; Mon, 13 Apr 2026 07:18:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776089891; x=1776694691; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=MfCfEoCQ1xm5a/h4AZyKBHqio5jzH+2E+QVtjsmZ74I=;
        b=WWkJp4jQSPraWUxImI3DQxRZZvH5Ll/waxg5q30om+fk2RR+qVSGqqANLLcPXZ4pCd
         wmfFPw7qqi1J42IeXz71VlekiEU0h97v02gEqjaB1z3OxlH/GNzITnkzJBM/ocCsaPhf
         +YN6q7Wpvcqw/ZEITXtD6VCdBB4y8M7i046QYdff5Ewu41hsdGKm3SqkDobWizNLJMTU
         6TyT+Cl6U1jZ7Ko9FcIntsTPSTRr8ykVlBTaKanWc2o/sxBBmJjjpKSOj73FNdlUlN0h
         /GFYCzPLmtLgI46Ywf0S6gmO0/P6eUyw/9qOtbS5VwzB1tGUczdCfIhM4+VdrEL8OqpZ
         zF2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776089891; x=1776694691;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MfCfEoCQ1xm5a/h4AZyKBHqio5jzH+2E+QVtjsmZ74I=;
        b=A6lGikcsU6bnTkmHRheFJA5RKzYUI6junkPXMXRqW5iH0r6l0lDPR/3bELxwX/sH3e
         D8YfC+5fvrNEEkOgisbpFpvagVY74xne0vIbjvnGLAvzobakH5fMysMjQlqikUruWQCP
         el16lnpS9vvSFQEYt417mTs03c6+jDGDJm+sEG+DGSXikgsb15qhjUBsfikXqS7m8HIM
         CQGTzX1nXXkquB8J0nL2+hFaEhkHM0CjHv0J8clUUkedxDUoDfJHqxGRgw3+fz9c8VeD
         UeYrm7cxoJ6c1Bv9gZ4Qj6g8KgS62OeyeJ8qWAnsAACJeCpmEQGqFcGnG2RlpyHJaP3a
         XItg==
X-Forwarded-Encrypted: i=1; AFNElJ8IwamhRCPu3uSLpNaLU0RxFjXe8SU/Oa+tTKmpR6nBs/iI+meQZwHNDhZihYHZC4BU+cKPaF+Rawyy@vger.kernel.org
X-Gm-Message-State: AOJu0Yww6mwHvbMHZcorKx8NoJRPWduNaN+Ey5nbu+B3XwSAdfanKmE4
	15BdotMrr3ZBn7k5ReJ58PrQ3PcXgVKAywb/IaPrbHzLJGZ0eT76b2PD
X-Gm-Gg: AeBDiesWUnzev2XxSPpsozXrR9r4dcSRLUxMqFefqhp/enqvL9t80Y/EBuZ7OUo+yJX
	DjBL2Ze7JbroBC/Sku7BrhD1GyMFAKjorELXaYWEZ45OQ/qLlgdB2DOG5TVvgLijEEuHPA5Wh3k
	Q/oV2AV7me88qa2EgK7PyBEJDfhP1dGzwavJp3MmCaEAw5/NwkH7qTO7qQZKwOVq5pGiTcB1vLK
	nHTG+f0gmp9WTC/SWW9Y6s7Rit+kV0y05v6NSuJA7szf5PQUv4/rxgtVWDb0f1LKoZt2KVZphx3
	57Yy7RbYKuxEsS+AX4YZeVZVEWZz2UDHgJGgwJQPzpMIVr9EfCIPNdORSpylawFoWlLqPHLjmhT
	S6J9aJUp7U9TH6SKsJCUY7vi97NoMKgLtEsRJVFlcwzFMHvi/wVC8ep9uxScFdzMCHXaO2HDlrl
	jsqp+W+kjycHEW6fGAXfbXEOPftR4FS+o=
X-Received: by 2002:a05:6a00:a116:b0:82c:e0d7:2682 with SMTP id d2e1a72fcca58-82f0c2a72dcmr15538886b3a.25.1776089891310;
        Mon, 13 Apr 2026 07:18:11 -0700 (PDT)
Received: from lgs.. ([2409:893d:1188:142d:6c67:74e8:5200:1f39])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82f0c377318sm10978531b3a.26.2026.04.13.07.18.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Apr 2026 07:18:10 -0700 (PDT)
From: Guangshuo Li <lgs201920130244@gmail.com>
To: Song Liu <song@kernel.org>,
	Yu Kuai <yukuai@fnnas.com>,
	Greg Kroah-Hartman <gregkh@suse.de>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Guangshuo Li <lgs201920130244@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH v2] md: fix kobject reference leak in md_import_device()
Date: Mon, 13 Apr 2026 22:17:59 +0800
Message-ID: <20260413141759.2970973-1-lgs201920130244@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

md_import_device() initializes rdev->kobj with kobject_init() before
checking the device size and loading the superblock.

When one of the later checks fails, the error path still frees rdev
directly with kfree(). This bypasses the kobject release path and leaves
the kobject reference unbalanced.

The issue was identified by a static analysis tool I developed and
confirmed by manual review.

After kobject_init(), release rdev through kobject_put() instead of
kfree().

Fixes: f9cb074bff8e ("Kobject: rename kobject_init_ng() to kobject_init()")
Cc: stable@vger.kernel.org
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
---
v2:
  - note that the issue was identified by my static analysis tool
  - and confirmed by manual review

 drivers/md/md.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 6d73f6e196a9..4ce7512dc834 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -3871,6 +3871,9 @@ static struct md_rdev *md_import_device(dev_t newdev, int super_format, int supe
 
 out_blkdev_put:
 	fput(rdev->bdev_file);
+	md_rdev_clear(rdev);
+	kobject_put(&rdev->kobj);
+	return ERR_PTR(err);
 out_clear_rdev:
 	md_rdev_clear(rdev);
 out_free_rdev:
-- 
2.43.0

