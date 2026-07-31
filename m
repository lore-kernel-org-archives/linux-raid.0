Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E54FF23D283
	for <linux-raid@vger.kernel.org>; Fri, 31 Jul 2026 07:47:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785484071; cv=none; b=Ve8xIqF23erKYT922Gp/X2cxc9kO6rPGRVH3nfUh1c4xKUswAVhcBa8lK6LvTZMHKZIYvTPzCUlmLkmAbcW37ze5daCRa0iQjiqM9K6sgX16kWAhT7ul+jMryeC3qvzIXsXWnGflhVNNKC1gD9SxqLIDBn/KHslUCMtin8jq9ok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785484071; c=relaxed/simple;
	bh=CrfSAiQTm+9l2kmkpdxLChnMc2AcGN27cIsp6jok/Kg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=D9CaaDTeIOSSi0jwXFpsCQKUCH2WN3RYFnd/JiOTROdoi5jTTR3s7JcT3whVk+m+jFV8PJhJxdkdqqeL2mCWeQjZeyDYBt3OtpYwDOhYSE8SMzqpLSf6RrtJKEXWXV8SHhnR6uqDqG91m0mwYaAY4bp4C7XqrAEf5RX7qcFOIGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mEAb7k7R; arc=none smtp.client-ip=209.85.216.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mEAb7k7R"
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-38ea87caafeso591755a91.3
        for <linux-raid@vger.kernel.org>; Fri, 31 Jul 2026 00:47:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785484068; x=1786088868; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=i4EKoQwAohDgZtyKLA4brtmFYbJM5DYKnvOT/Lcdpp0=;
        b=mEAb7k7RzvdXLO+GutXEkBrapZa9MU3WuPuj/jy+Dxi9v0XAETIMeeuw2CU+ggNgZ8
         RPiH6N/ksLlva0mCOW7/RCwqw0E7yqKEHJ6zcqhzd4A93a/eVLMaDyAqVinvW6cC2p8m
         oqMLExCwUfEsGAdIjIkU/+qXie08MsxDbvMIZkMnD48KYOvKrPrsFZzKYENsd1VEterM
         L9mwaXihTVdR2rWCMiz3Yfwd0btm2zwKFG+5z8wziK2iKZAtxBa5Kdt5dIMuo0iuJCUs
         azVMtXqDBfoVQ7PnWm3IC6UCo6rhOm9yhkMiLW2XL3hQn+pk5Fe8XfVzr6Dy8LLI5ZQM
         uk8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785484068; x=1786088868;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=i4EKoQwAohDgZtyKLA4brtmFYbJM5DYKnvOT/Lcdpp0=;
        b=Ic1oZGMZa5oPfHNy4zFA7EzJ8/P0Bmmy39kg4L6TJyw22BCzCeODXRjaFlW9q+Oer1
         yU/VpQnDd6oV1pXxkEGX5H7OzS9AK630LOD4Ay/YedAffm37vl0+VpP6Capgcjn0lQXG
         P1sCuR+bAjOdPxpPBvd9hs5872gNbD9aV5ByowuAKe1Z8JOQ78Mp4iL5JxkeS+U+JXiR
         uQv1PjJbOdHDbCPlKYvVLXsH8lFouIyyCoAm3IYdaQjh6waH8p12vawaTBqQDwv0tmsT
         mHmIpVsfv/GfMnhXniw1yXJgNbO2gtTgBA+LUABTLgU+us1VbbgbOB8V/t08f9HMBacc
         JOwA==
X-Gm-Message-State: AOJu0YzNuRkbkk5hJK6+1n0jucLEe62WFBm7/KN+tnHgOPw4NDZHS+lM
	tnW2iAx4F2p7iOpnqQXVDTQN4NEiwPD+PygJ/tpz7eUDOIJANjltAy4W
X-Gm-Gg: AR+sD13Jb/flxK00WxXKRCjSKNxbzicery9keojY90JSlPibFm++u8ftB2XgLiyo+Qm
	C7jZaIbIcbgOjIuCn0DHR1HPtWIix9QiO7yE+pm1RHOZA1o+prfAV6gHwNjrJTUvq+nY8+HMuRC
	2X11pBkaYygcY59H2DmQXVx3n5QspMQtbDz07FojoL/ppe1WzCJkUmv6PBtINI+m4UcuW8Hq62a
	TMnLbc8afqZBKwo4KTOBjwJkop7aHKXVY6LgFXnHF6CluLg2NqaYy0f5ARkENGK7GQ0ymzGQ+D7
	5SFIxcvAGU9rYfVhwPwEEwOCfTtqrVSE2cHCoae2oZVmArfeNKOD7U5tiZ97M7fQ2KlP9oqdZEf
	1MowjadQ283yanErEZzFBOMPbiNSIHWbqy2o31YF7TEOsuA7fTI5Wls343+znz8Vodrbc9oGsM1
	TSM/Jjb30XF4gkzzn5FN25drJT7YT+BlHrESfPfT63UxO+If1Rw4kD/9jH0lPSu4KxJ4YuHnf+B
	SP7d58=
X-Received: by 2002:a17:90b:2d90:b0:383:f52b:d616 with SMTP id 98e67ed59e1d1-38fb116d6a6mr1052290a91.10.1785484068213;
        Fri, 31 Jul 2026 00:47:48 -0700 (PDT)
Received: from localhost.localdomain ([113.98.201.214])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-38fb295de28sm349941a91.1.2026.07.31.00.47.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jul 2026 00:47:47 -0700 (PDT)
From: Wale Zhang <wale.zhang.ftd@gmail.com>
To: song@kernel.org,
	yukuai@fygo.io,
	magiclinan@didiglobal.com,
	xiao@kernel.org
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Wale Zhang <wale.zhang.ftd@gmail.com>
Subject: [PATCH 1/1] md: skip discard on unsupported member devices
Date: Fri, 31 Jul 2026 03:47:29 -0400
Message-ID: <20260731074729.1885314-1-wale.zhang.ftd@gmail.com>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

blk_stack_limits() uses min_not_zero() when stacking discard limits.
Thus an array containing devices with different discard capabilities can
expose discard support as long as at least one member has a non-zero
discard limit.

raid0 and raid10 use md_submit_discard_bio() to submit a discard bio to
each member covered by the request.  The helper currently also submits
bios to members whose max_discard_sectors is zero.  The block layer
completes these bios with BLK_STS_NOTSUPP, and bio chaining propagates
that status to the original discard request.

Discard is optional, so skip members which do not support it.  Members that
do support discard continue to receive their portion of the request.

Signed-off-by: Wale Zhang <wale.zhang.ftd@gmail.com>
---
 drivers/md/md.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index d1465bcd86c8..77e6e6bd5460 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -9350,6 +9350,10 @@ void md_submit_discard_bio(struct mddev *mddev, struct md_rdev *rdev,
 {
 	struct bio *discard_bio = NULL;
 
+	/* Discard is optional, so silently skip members that do not support it. */
+	if (unlikely(!bdev_max_discard_sectors(rdev->bdev)))
+		return;
+
 	__blkdev_issue_discard(rdev->bdev, start, size, GFP_NOIO, &discard_bio);
 	if (!discard_bio)
 		return;
-- 
2.47.3

