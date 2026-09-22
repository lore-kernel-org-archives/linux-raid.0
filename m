Received: from mail-pj2-f42.google.com (mail-pj2-f42.google.com [74.125.227.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99371380FF4
	for <linux-raid@vger.kernel.org>; Tue, 22 Sep 2026 04:46:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790052377; cv=none; b=PgWMFUbZYi1yTCvwhmb76kdyINX+XIB7RJP6jVbG0MjQ8rWGG2ppIJF9dSXj3KmUJLIS7ujh8MeOXtdxQjlxyRvZlvow6vftZLbVKRZAa4GzNOfA2JbTdlb8LrmmaGZpi7dsj9F1YorGcOD4aPTb1p3GyubR++RbSVnQwXoOoOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790052377; c=relaxed/simple;
	bh=LmqjBasxDWd9/DMzUXY/MJPkJcpcAJYfwEVP/qtHFmc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aKiiVccVgfc/hgc1G2bbNL2Yp0npFHWF0mP7dnnjamJL+niSUtz4JKQc51cwA0O+THDD2zsoRPcCsP40a0QR24+YKy/AKkj2pZh1H72Fkf8INjpKmf/n1Sna4mXl+fuqZYi2sLqiuUHrCYdXDmzkyfhs5lz6oddCuzPNoRqzmMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=p6TKSxS+; arc=none smtp.client-ip=74.125.227.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="p6TKSxS+"
Received: by mail-pj2-f42.google.com with SMTP id 98e67ed59e1d1-396ccda24afso2664211a91.3
        for <linux-raid@vger.kernel.org>; Mon, 21 Sep 2026 21:46:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790052373; x=1790657173; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=3E+ocT2Bhu1iX7K4xkDhu5H7aG48frP1ov4mPcFNMD8=;
        b=p6TKSxS+3n5KXKvQNMuj1ceiHogZzRt+Ix9wwUuBtRE6VKdXLY1K07u6E3k8FtSd/p
         lfiSIe8ZE/Hvvc/rThv38IX4jMepEQwojMu5p1MG3d6dFrZ17/yNmGIVuLH4wVhEFjpr
         dr2Dn/JCKsBYl31lFQ8u5M2p8qb5++wn9pkynZs65WZ7I7TqeLHJ3FH7U6uY9pB0fORT
         GU0tPU8y3cbXzLEr8J9QuTiP+iw7CFObuGTBPPjGGvIlXU7plTGIsH6TBEvENXulG6ef
         s6RCyFO0+l386GOYfzh7dRpDIhjb2X7EOPXRKRC5yLSM50CG6cWj61ra7HXRKnuwZA/4
         XySQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790052373; x=1790657173;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=3E+ocT2Bhu1iX7K4xkDhu5H7aG48frP1ov4mPcFNMD8=;
        b=PTu9Ezv+vMlSn7MAKnKQHmRRI5+9h0C7ozYjXoJE+6CQ1gx9Fpjm2F/fotAEmynizd
         To2huR5ldpydnnkMETMKL7/vIOim5LglmBtT8pxER8UO7rC0Z8mpreJz06amy6EbZ2nC
         EacgDzdCWzqIFdHedLVUdzdswDfesGZgPHFJsp7l0HtKAEkeV2tnWgNHkVWHHVCc963I
         mg1SpPBt9vRFcTVgStRbf3ckm6OKZd4n29ol5P4IQYtuKRz6ZDGeIxBK6GeyGfiWV5HL
         dN/xPOx4iT1Ihb1IVmZ4vMxi1gomjciAG4CSzfed131gGvbjkywUqlNBtTHsh+zv+z88
         f4DA==
X-Forwarded-Encrypted: i=1; AKwUvBzP902BnQmingLAkPvPNZahy8ODt7NttoZApp6TMmhJbCVukSvM+LMcXao/8S7UAzkHyLhWB7hhE0PY@vger.kernel.org
X-Gm-Message-State: AFuF++kv2O4sOO+nsebBI8cnG5PjMY+V+isJjZ7o4sBNNw4cZD4FO5XL
	LVDy+92CRqjI086y+1Z9QDOHX2TFdh5BEXeL8sJ1/cIy9XrOcbfQkOss
X-Gm-Gg: AYBFou3a3hNZOXky1DFNBJPh75+CB4lUpfU2WAziK7nkiEKnX7iHC5D6yHVji/ks43N
	kerhW91SvMyvD7lHDFJuFHKScHODDPEgjAe2EEOGsSrRDK+ifkGqURaBt5cWQZZv3hm/tUq27it
	eB3cRSGwC8fO1+0VUOZoahHRHxOUTO59Vj3J6Pq1Na1xSUOwtYvO676oxSZ7ITVrQOOfKSdg7OU
	qVC8ZyReR0HNAJxwazJZ+fbiQB4YK7M56sqn5i6iVt/dep2ygPtPr6Wh2XsARGdCbojBrpDw86s
	+pF5BssrGYEtJsIUbO0FuYoYpigijAdFT5Lv/sKFpJDxYfc9RxszpDJILvuD13toxhufa9iklox
	tz5VzZaG48OzwVvPeFXW0PZPWlqIf1zjHvodQ4Hedvb6UKTNstWvHwQxBuaFz2Vf5Rt498KfNZ0
	YvifuOmx5vwrDCWl6pem0Yrj3scbp1T5BDur3PkjVWJgunFVsxD69enmjzIuvIR/8J1AkmFIgBT
	VXgolpVjjbspn1doQvjYy1ynY+M8bIGkwSCY1k=
X-Received: by 2002:a17:90b:55d0:b0:39e:6a81:c921 with SMTP id 98e67ed59e1d1-39e6a81c9bbmr14597347a91.20.1790052373331;
        Mon, 21 Sep 2026 21:46:13 -0700 (PDT)
Received: from localhost.localdomain ([2409:8a1e:2e81:7320:3443:b4ea:307f:cc4a])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a06e570d9esm937101a91.10.2026.09.21.21.46.10
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 21 Sep 2026 21:46:13 -0700 (PDT)
From: Yuchao Zhang <ndaugoing@gmail.com>
To: Yu Kuai <yukuai@fygo.io>,
	Song Liu <song@kernel.org>
Cc: Xiao Ni <xni@redhat.com>,
	NeilBrown <neilb@suse.de>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Yuchao Zhang <ndaugoing@gmail.com>
Subject: [PATCH v2] md: validate bblog_size when loading v1.x badblocks metadata
Date: Tue, 22 Sep 2026 12:46:06 +0800
Message-ID: <20260922044606.30774-1-ndaugoing@gmail.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <fad92649-e362-443a-93ea-205b11247e6d@fygo.io>
References: <fad92649-e362-443a-93ea-205b11247e6d@fygo.io>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In super_1_load(), when the on-disk feature_map does not have
MD_FEATURE_BAD_BLOCKS set but sb->bblog_offset is non-zero,
rdev->badblocks.shift is initialized to 0 without validating
sb->bblog_size.  The same field is validated in the
MD_FEATURE_BAD_BLOCKS branch ("sectors > (PAGE_SIZE / 512)"), but this
branch bypasses that check.

A forged on-disk superblock (malicious storage device or crafted
image) can therefore carry an oversized sb->bblog_size.  When bad
blocks are later recorded, super_1_sync() sets bb->size from
sb->bblog_size and md_write_metadata() issues a bio larger than the
single rdev->bb_page, reading beyond the page and leaking kernel
memory contents to disk.

sb->bblog_size is never modified by the kernel between load and sync,
and the MD_FEATURE_BAD_BLOCKS branch already validates it, so checking
it in this branch is sufficient to cover both paths.

Fix this by rejecting an oversized sb->bblog_size with -EINVAL,
matching the existing check in the MD_FEATURE_BAD_BLOCKS branch.

Fixes: 2699b67223ac ("md: load/store badblock list from v1.x metadata")
Cc: stable@vger.kernel.org
Signed-off-by: Yuchao Zhang <ndaugoing@gmail.com>
---
 drivers/md/md.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 680b34a63cb3..1caa92b40f9a 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -1934,8 +1934,11 @@ static int super_1_load(struct md_rdev *rdev, struct md_rdev *refdev, int minor_
 			if (!badblocks_set(&rdev->badblocks, sector, count, 1))
 				return -EINVAL;
 		}
-	} else if (sb->bblog_offset != 0)
+	} else if (sb->bblog_offset != 0) {
+		if (le16_to_cpu(sb->bblog_size) > (PAGE_SIZE / 512))
+			return -EINVAL;
 		rdev->badblocks.shift = 0;
+	}
 
 	if ((le32_to_cpu(sb->feature_map) &
 	    (MD_FEATURE_PPL | MD_FEATURE_MULTIPLE_PPLS))) {
-- 
2.53.0

