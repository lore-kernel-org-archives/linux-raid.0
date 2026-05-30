Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08FE42F8EAD
	for <linux-raid@vger.kernel.org>; Sat, 30 May 2026 15:14:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780154058; cv=none; b=G1YpNHd8bbvWxoaiojbUVpQvECD3HOhMSIp7Iz/v5Y7lVQOo+kotsrIjh5VkhA8fALqFALsaf1cytvAE1Ur4Nz74kAIraTIIOgxgwMfrWjreyjc++GplWe78Zx6RPTz/JG/ZmUGN8ITMS+0n5UzMI6CFtLByNcIkfDGoUHMpTe4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780154058; c=relaxed/simple;
	bh=DXWVCZysxKD9gfXEdslRTOa4j3AnF6pQmITytnjmAb4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=rrNhYxwlMLQKSkNnLnlnyfOIW6AoMVZtj3l+kQqNRSGSp94t0+68XkqXfZMxT4WeLQWkevCOfvvmMGrjkTndGCmIMgK5U8d4QTJGn7Qj0n0clqbHa1kizbNJVU0hPaSY81wK2T2dTTwG1osMJ1bK3LxkKFqYdC5hAUyOrqX5kfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=rLw40wt0; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rLw40wt0"
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-45eedcdaeaaso1772393f8f.3
        for <linux-raid@vger.kernel.org>; Sat, 30 May 2026 08:14:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780154055; x=1780758855; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=+5ipmyFXNMCUBMZJUA0wkXx6dJbNhAJkRdCthVvgCPQ=;
        b=rLw40wt0syxzHw7Es+3eBz1HvoHdAkE5xgH89nZSMNRjGQlm0vKT+lkxeuR8N8p7Hy
         8WQjEq9WbAso2xdQB6m7z5ig/yg+bWbiwynyy8EvYFM/fMFGl9BRo4BehG+vUd85zeJH
         E4zrfV7MlyEMMm1ow2cQj4mC9PyNbnLse9XCDwqvt8glD+qSV5mMsNwyLuUj6ytYypDl
         pjLAs4LtLuul2cfIqJpjB+XQKUOB3B6LG0/JBtp1HLEbiN6dchWc1Q3/LATr4NwZuc1g
         tEnA3C5/Es+K8zqKlPlvKfy48+8XaWmCR0HuqCWvxUjtndVq8bRn3LOCRC6ZQNsgWQxS
         CweQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780154055; x=1780758855;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+5ipmyFXNMCUBMZJUA0wkXx6dJbNhAJkRdCthVvgCPQ=;
        b=skjBL/cpuJLM2P6CSfuFudlCCA36usIHrPtUqlFZKQbiDuOBbmqUweVqt9Bb0o4DxD
         ADuZVZLUAqjyg0at512mLF40uggQO7qbGbYNz+dUuhbt44sHZ5uePxPal0PQru/8KIC7
         BI+sDrLCa/6ubtFQ36ggmxXx6tnngSzRF+o//cYYpjr6WuLxSnUs+O+YPS4esxF8/A7b
         rtCPc72m/FQ0uBzC4BGhG5MkIGuWCXxuZnovnnLc8o+4DFZZ3Bw6dAfJXvthSnGp0Tli
         +klpT6BNBgw0Ar6Q9E0AgMUiC9xdqZfk8+u9gk+96l7lyP/EO1jiJ2WTQwBiNtWGNEhX
         VRmw==
X-Gm-Message-State: AOJu0Yyps1av/dInhl6FXSIeEGTXrtJswu96oVyg7ATnRebtBCwVhDyL
	jTS4omlN5ktLl5dpHKpLHeMckvQfBlT8gTUUa3CW7OPEuCoVMuDTgk2W
X-Gm-Gg: Acq92OEueg1yI1SALeeoL0mnsYUfPm43RsQddUgg0smHMKJA02A/XDuR85PHzfGQvHH
	ony4kSOOgsm87xbQi1lwC2v3H7a3/ydNwrO39UYLnC1Hc4FeaENHzFKAZurnj8/SbtJyNxvqWAh
	5GGtzH/fXVxWh9ZgJyMhfXXuHQnFUHI204tOjygyf2/ixqZVtFZGwCCDPIsvjFd+sYx9gpqDCH7
	/dLdk1gAdrnoRNelz8Lh2aO/dp3bli7bTZey3qvY1bhb8gO3Uy4XASIi52BvJPr4BY/tqkyyBat
	IC50ywJhsaZ+6ktJuF8q8uDPwkarfy0f+/tjpqWvTXDIG8j3O3sPrtD+vFGYcgokaZa6az3tN7h
	rnb17uuTRtp12WMqACP6+bzXtlR/w9ceV4Ma22AEj+1zEpEAe2A3ZEjRyzs+XDqQ8z5q7bVOo9m
	u2g8Uc4uqPdemZ2xEHxZcPEHQ2YTxhScNiOX60yVFOZQvYqGXZUUhIZpCf8xniTbRdTn/X8i2kl
	GMl7z+7fDU=
X-Received: by 2002:adf:e84c:0:b0:45e:ec17:430a with SMTP id ffacd0b85a97d-45ef6afbf37mr6298090f8f.11.1780154055307;
        Sat, 30 May 2026 08:14:15 -0700 (PDT)
Received: from yocto.. (dynamic-176-007-201-005.176.7.pool.telefonica.de. [176.7.201.5])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45ef35874b7sm11878817f8f.35.2026.05.30.08.14.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 30 May 2026 08:14:14 -0700 (PDT)
From: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
To: song@kernel.org,
	yukuai@fnnas.com,
	linan122@huawei.com,
	john.g.garry@oracle.com,
	martin.petersen@oracle.com,
	axboe@kernel.dk
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
Subject: [PATCH] raid1: fix nr_pending leak in REQ_ATOMIC bad-block error path
Date: Sat, 30 May 2026 15:14:11 +0000
Message-ID: <20260530151411.4119-1-abd.masalkhi@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In raid1_write_request(), each per-mirror loop iteration begins by
incrementing rdev->nr_pending. If a REQ_ATOMIC write encounters a
badblock within the requested range, the code jumps to err_handle
without dropping the reference taken for the current mirror.

err_handle's cleanup loop will only decrements for k < i and
r1_bio->bios[k] is non-NULL. The current slot is therefore skipped,
leaving its nr_pending reference leaked permanently. The reference
prevents the rdev from ever being removed, since raid1_remove_conf()
refuses to remove an rdev with nr_pending > 0.

Fix this by calling rdev_dec_pending() before jumping to err_handle.

Fixes: f2a38abf5f1c ("md/raid1: Atomic write support")
Signed-off-by: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
---
 drivers/md/raid1.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 181400e147c0..0084bbc24076 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1580,8 +1580,10 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
 				 * complexity of supporting that is not worth
 				 * the benefit.
 				 */
-				if (bio->bi_opf & REQ_ATOMIC)
+				if (bio->bi_opf & REQ_ATOMIC) {
+					rdev_dec_pending(rdev, mddev);
 					goto err_handle;
+				}
 
 				good_sectors = first_bad - r1_bio->sector;
 				if (good_sectors < max_sectors)
-- 
2.43.0

