Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0F5A2D5C7A
	for <linux-raid@vger.kernel.org>; Mon, 24 Nov 2025 23:48:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764028105; cv=none; b=GVQ7VYfLEn6QPyMF4KRtNHpYByVjRenAmehzhUM26RcD3vkBlYerrAPA9zE7KqyzpSSVbY5fp1+mqq4OFdPCTEeQuQ6MiUGnumbB+4Gas3fFHUca6RkoskBSkatVpAA3aEfLE85emzapQ4QsnlQ3ibjipKwkliuUEAl6ubZuIKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764028105; c=relaxed/simple;
	bh=O/JUDf1xQdyUKKqPMxOm/ySwho1/juV+ixb/yhr4OcA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=PDboGCFA8WNoq4/K/fXZIZEUcHLP4J7T521TRshimn8F+YiIeahwSEcF8UB6bBopkjT1oNTRGYTnY9rzW2ypO7DNcNXJ6ogHXXRPvR7ysybY8nQYAqHhAuDF0lPlM3j9MffvNjnevpQhD8L4cqitX+biFL8mqbris4tcOHZaaMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fyRvwB0P; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fyRvwB0P"
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-7b86e0d9615so5846199b3a.0
        for <linux-raid@vger.kernel.org>; Mon, 24 Nov 2025 15:48:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764028103; x=1764632903; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YcqbQ5S4JXXbau3fgh6ZbMU20qGzRcIfkGSPAKTqhkc=;
        b=fyRvwB0PwJyRFVMmj9BwngRdyh1FxB+k80U4l3kSgDZisjLtKwedeBZ3WsHlXzv4LW
         smguUguTqO4ye5EUVlnlvpwehhBTfYAqQ/x5sNJHqkipIoz1rFFOO/xvS/2DbnpZKGWU
         NT7VSCuaOqINYCuFj77EXlZa539ZIvO0qNkghSekpJ5G0ksAQiFu5ykpDGTAVN31tJfk
         64rRkgLXr7NPb8V3l2WHWDXRrJhsD4fRRbJez9GqQhUbppDygfJEiz8/8/j6tRnC4bcU
         2SvXeNYZLlS+Zu8IJeuLKXeJkDs+fSU0LrJknD6fbkf69ZraKuFmm52FKSe5bUPXEgYv
         Qv0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764028103; x=1764632903;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=YcqbQ5S4JXXbau3fgh6ZbMU20qGzRcIfkGSPAKTqhkc=;
        b=X16Svhws5uJUY5wGhtX/2CvuahCoEJL/BpUdxVdqSUMvZn25w+tQfksiv1CKLJRM27
         pGUiqaLYLhbtfnz26Qi6VE+8JIBM4XnKfSen9DJpKqYOBBYBi0Vc9TuU1YgW+Rv+8laG
         soqTfXmOZ5b5ZFibWb8bx/TZ8IVUfoMN+0ZclBbERcQGEvOsI9lu8N1IR9T/9P6+v7Jv
         uA1AB0MEu2KUTtMTFc0bQxNf5Z2AK+2/Hu967Jtn5ZAxsCbdaWC0S42qq070jMyhbSsc
         GaTsP7vxrds6TDi3s9jifRUg6HsTUm+9kOFpvJxypwk2C81gGGktzKmRn4orn63nMW0A
         SavA==
X-Forwarded-Encrypted: i=1; AJvYcCVvBRSAl/oGO05bMUv1/lsVpZVIkdh2baUh09mgUrE0Nf5jaHycbZ5BSseQHVaR+pCd5TN0vGRKVRrU@vger.kernel.org
X-Gm-Message-State: AOJu0Yy43SiGoxZ5T2tdPYU6FekTWM4fN/2z16BrGn94yW1Kb17ENfEQ
	uyPG7eyetUehxI6MrzQpnOcJ2vCaH4LyqyEkHJMclnFGNr5GtpVNYHph
X-Gm-Gg: ASbGncvqEVjlvOSRlgoIVMOuopmQ3eBYSmSGVqaqc5oIb5jptnq7hBWZzCZDkkiXwnV
	jhVOL0X/aN6iLr+ihkpIw9mn2rgEopWBFWMoo3Fw5K7ZsO+HLArCbEjvck0FzQJJoK/MjMCmjNR
	XJtMApZW8Pmg4lg5dXUEez+yjf1EyvSPrRgmyo/wlarpU7l5DLTbQDUSmaliO8I89f0wzphQZ8K
	D+7oJeCkR+gABvFxYK4kGgbwbiK3XjMa+AQQEguKy8aJ8i7sx2Dk2zsT7yQ0QMrYDhSPISwBKmk
	j5GjCopSlq6fyFprqzXUmHVpYNu1IpMOGHEBJojUWB779cL4AWEBKmxX2O/dHic66HjoHBmQIEx
	ZKmv/rre9l8d36pxHj2W8lL/yU0UdskQhSjGEqeCZjdztWY0rpyw94iJ1Fbtu1Npz+aEE+i87le
	7MtDbwA19eqFut4zbNZvw0JUoamSG5o+6vDFC9lD0JAGLHkgI=
X-Google-Smtp-Source: AGHT+IH9F80PvdpBpbojg7Y02KngkDHXsfXBdGLUzofDSvSvFO71NKJ3uHp3bN/w9c26If04NsQEQQ==
X-Received: by 2002:a05:7022:d45:b0:11b:c1ab:bdd0 with SMTP id a92af1059eb24-11c9d863a0amr6183635c88.35.1764028102624;
        Mon, 24 Nov 2025 15:48:22 -0800 (PST)
Received: from localhost (ip70-175-132-216.oc.oc.cox.net. [70.175.132.216])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-11c93cd457dsm72215056c88.0.2025.11.24.15.48.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Nov 2025 15:48:22 -0800 (PST)
From: Chaitanya Kulkarni <ckulkarnilinux@gmail.com>
To: axboe@kernel.dk,
	agk@redhat.com,
	snitzer@kernel.org,
	mpatocka@redhat.com,
	song@kernel.org,
	yukuai@fnnas.com,
	hch@lst.de,
	sagi@grimberg.me,
	kch@nvidia.com,
	jaegeuk@kernel.org,
	chao@kernel.org,
	cem@kernel.org
Cc: linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	dm-devel@lists.linux.dev,
	linux-raid@vger.kernel.org,
	linux-nvme@lists.infradead.org,
	linux-f2fs-devel@lists.sourceforge.net,
	linux-xfs@vger.kernel.org,
	bpf@vger.kernel.org,
	Chaitanya Kulkarni <ckulkarnilinux@gmail.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH V3 1/6] block: ignore discard return value
Date: Mon, 24 Nov 2025 15:48:01 -0800
Message-Id: <20251124234806.75216-2-ckulkarnilinux@gmail.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20251124234806.75216-1-ckulkarnilinux@gmail.com>
References: <20251124234806.75216-1-ckulkarnilinux@gmail.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

__blkdev_issue_discard() always returns 0, making the error check
in blkdev_issue_discard() dead code.

In function blkdev_issue_discard() initialize ret = 0, remove ret
assignment from __blkdev_issue_discard(), rely on bio == NULL check to
call submit_bio_wait(), preserve submit_bio_wait() error handling, and
preserve -EOPNOTSUPP to 0 mapping.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Chaitanya Kulkarni <ckulkarnilinux@gmail.com>
---
 block/blk-lib.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/block/blk-lib.c b/block/blk-lib.c
index 3030a772d3aa..19e0203cc18a 100644
--- a/block/blk-lib.c
+++ b/block/blk-lib.c
@@ -87,11 +87,11 @@ int blkdev_issue_discard(struct block_device *bdev, sector_t sector,
 {
 	struct bio *bio = NULL;
 	struct blk_plug plug;
-	int ret;
+	int ret = 0;
 
 	blk_start_plug(&plug);
-	ret = __blkdev_issue_discard(bdev, sector, nr_sects, gfp_mask, &bio);
-	if (!ret && bio) {
+	__blkdev_issue_discard(bdev, sector, nr_sects, gfp_mask, &bio);
+	if (bio) {
 		ret = submit_bio_wait(bio);
 		if (ret == -EOPNOTSUPP)
 			ret = 0;
-- 
2.40.0

