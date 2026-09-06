Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5DF037FF75
	for <linux-raid@vger.kernel.org>; Sun,  6 Sep 2026 18:44:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788720259; cv=none; b=NWGfD9xmKzAqPmBfTXSIZLc3TeTlAJwaSEXGOj9QrC3FerJYxcVx+rZ8f9c75RDEEbfBo200ugyG4RS14ZwUCRScGhq4EfOp/oAjPBqB0hDQat+LL7kphYqWk8B9M8CIEkq3xd+oToPIgGltZvZShwGV6u3lbxip3VBkl2r8QMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788720259; c=relaxed/simple;
	bh=BaNpnanrjgbdSZKgIxI5TIOIZm3kDLtIvvcL+9R7TZA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=bdtPlAfNcdCbSguuBaJaEu21Q5uMVE71wQ7Pg0Mg2NSYlMhdWD5I81jekXaKhYSIs/DechX2wfb/4WdnPiYvA47aWkSadpewkIMIEhKGecK1FKEZ24EfqAE7B5+nVPWrZOXTpIQ1Tm4EjSVNB8NwMmvv1JBwzOL/dtXeACIbpoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=m5gU8oRB; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="m5gU8oRB"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2d5335cf904so27364025ad.2
        for <linux-raid@vger.kernel.org>; Sun, 06 Sep 2026 11:44:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788720258; x=1789325058; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=fATElZat+q7upA4tOibt7iYKQOftj7DVW6WQFIGNTcg=;
        b=m5gU8oRBAuN52eaGGCnQJX/9oA1fNKHojXWzmGMpOf17exQQdwsEFkdA8qWJ8877Kr
         bk50gx/YvFvzxwosdjOwaAl5y0JN698F0OnFcsIGNOJXV5NfxkBz+hTsxpEmef6Vus8W
         eGmnxynb5OOyGy7zgVTas8tRnK3H1WwIa0BEreicBcQqypwQcW7gn51nXFmbEmEmM1Yp
         nVdN0V6oEU+Q3D+o9e0ofH/1yWY4CNsagVbqXLQApYcNDliYpl98dAjmO6NFjvlnzA7F
         aFplzIHFDCBTziuYtx7oBTThcGggQMsWaiY2eH5SKmfNhStLQVnpLJ+6tCct1jeiFnZN
         DfZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788720258; x=1789325058;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=fATElZat+q7upA4tOibt7iYKQOftj7DVW6WQFIGNTcg=;
        b=fRaV6BvdOdTixqmcoPvDVstIas/orf/GBKYqsx0xeYSNiWybcPJHXiXYRKksmb3Dqk
         fPDb3lZcBKi8r4jXiMo/PQmY5XSZ46KJb45JAxCpWSzvgyGNCrBPu1RO2A02LzzMb7tH
         yJi0Y8BjR3C0LxEXIn4jJKCVvuAiZGV4n50ykfQGdJtNA9YrAlliKVi8JjzBvHZHDZLH
         unzA+tNx222dYoxHArsjLno9AEKhbmurWcM7dwv+zvE6plJBHFzwCX66aQKs2zZMaZKI
         Ckr+1HlPcEZ9N3eAEJhotPAcej5zsE8hBFXLptj4Via4IUbz//yDyU1u2QYLHGe+PvTY
         bM7g==
X-Forwarded-Encrypted: i=1; AKwUvBwjE6qgPUE7E9PBpLLvZaY330dTwrHzgkR2Ny4Kb3B96HkQSr+MQjBCMCig8/7nVh9/2TwtHVjYtdK3@vger.kernel.org
X-Gm-Message-State: AFuF++lkBC6XTVpXxCDnZ6d0Axp6zSp9Y9JSPDuuNobCgZIXn9bvzDFV
	BJ0PUu2qENbVNG1VhS9yT7d5QL0VlCCn/MsZ7hu5yoKcZoCJPX2uC3vQ
X-Gm-Gg: AYBFou1CnRVMd4q7TGaAZekW2nkc8U23EPN6835UMCyO800kPLTFknz5QF64Tvcly9W
	HheH4uAwx3lnSLEzTQII9jjzBJJ8wzttAqQrPpZrgwjMGHIf0hN+J5Wi61lTKPb8Yc/hh3SRgbn
	SHwoRH8/2/9wpTp+RLyzm2U6pdDHwmRtmLwvJtsbQA3dyueUImjvQyKx8x66Q9CKZKukx/aFPuB
	Lx4wT5t4qIVZN6CFilrKhBIK+Id/WcMEyh1h/5vGyUJjjfMYzwf50zOEzxzsQhOSFnKgMqoqiiq
	mqH6hKwt/sPp3Mu+JMJSdcsmQzxuC/zHN3xdDAMS84lyIxkN0K/+uIsOhbyNniJ2obIXql6Ze+u
	qgwCWQnkK+/CIpWASWGrKxD7JjdPGWSfNu/T/ZzfvYx7BeG85ZebfGj3Nmigm2SyHjhKZ5BrMdF
	E2Rq6kkR2qK5N9Uaijq2/6ZqKKNkmw00TXUKH4Q/o9ELDyR7/SxoZgYzv8T0ZSSTKpgM+eTg==
X-Received: by 2002:a17:90a:e7c2:b0:398:9be8:ea66 with SMTP id 98e67ed59e1d1-39b261da126mr27194570a91.19.1788720257917;
        Sun, 06 Sep 2026 11:44:17 -0700 (PDT)
Received: from TheRealOne ([2409:40e1:15:4732:db5a:76f6:6f7d:3814])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39ae8e0b117sm8219320a91.3.2026.09.06.11.44.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Sep 2026 11:44:17 -0700 (PDT)
From: Chandradhar Kumar <chandradhar.2003@gmail.com>
To: song@kernel.org,
	yukuai@fygo.io,
	linux-raid@vger.kernel.org
Cc: magiclinan@didiglobal.com,
	xiao@kernel.org,
	linux-kernel@vger.kernel.org,
	Chandradhar Kumar <chandradhar.2003@gmail.com>,
	syzbot+a32ff75e417c0f49a8e9@syzkaller.appspotmail.com
Subject: [PATCH v2] md/raid0: validate device count before allocating devlist
Date: Mon,  7 Sep 2026 00:14:06 +0530
Message-ID: <20260906184406.2141-1-chandradhar.2003@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

create_strip_zones() allocates conf->devlist based on mddev->raid_disks
before verifying that enough devices are present. Validate the number of
member devices before allocating devlist to reject invalid
configurations early.

The existing validation later in the function already rejects this
condition, but it occurs after the potentially excessive allocation.

Reported-by: syzbot+a32ff75e417c0f49a8e9@syzkaller.appspotmail.com
Closes: https://syzbot.org/bug?extid=a32ff75e417c0f49a8e9
Signed-off-by: Chandradhar Kumar <chandradhar.2003@gmail.com>

v2:
- Reject non-positive raid-disks values, which can bypass the device
  count validation and result in an oversized allocation.
---
 drivers/md/raid0.c | 20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index 35e103f0c2c3..8eaf078606d6 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -69,7 +69,7 @@ static int create_strip_zones(struct mddev *mddev, struct r0conf **private_conf)
 	sector_t curr_zone_end, sectors;
 	struct md_rdev *smallest, *rdev1, *rdev2, *rdev, **dev;
 	struct strip_zone *zone;
-	int cnt;
+	int cnt, nr_devs;
 	struct r0conf *conf = kzalloc_obj(*conf);
 	unsigned int blksize = 512;
 
@@ -79,7 +79,10 @@ static int create_strip_zones(struct mddev *mddev, struct r0conf **private_conf)
 	*private_conf = ERR_PTR(-ENOMEM);
 	if (!conf)
 		return -ENOMEM;
+
+	nr_devs = 0;
 	rdev_for_each(rdev1, mddev) {
+		nr_devs++;
 		pr_debug("md/raid0:%s: looking at %pg\n",
 			 mdname(mddev),
 			 rdev1->bdev);
@@ -144,6 +147,21 @@ static int create_strip_zones(struct mddev *mddev, struct r0conf **private_conf)
 	}
 
 	err = -ENOMEM;
+
+	if (mddev->raid_disks <= 0) {
+		pr_warn("md/raid0:%s: invalid number of disks %d - aborting!\n",
+			mdname(mddev), mddev->raid_disks);
+		err = -EINVAL;
+		goto abort;
+	}
+
+	if (nr_devs < mddev->raid_disks) {
+		pr_warn("md/raid0:%s: too few disks (%d of %d) - aborting!\n",
+			mdname(mddev), nr_devs, mddev->raid_disks);
+		err = -EINVAL;
+		goto abort;
+	}
+
 	conf->strip_zone = kvzalloc_objs(struct strip_zone, conf->nr_strip_zones);
 	if (!conf->strip_zone)
 		goto abort;
-- 
2.55.0

