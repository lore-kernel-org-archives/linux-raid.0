Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E5F73AA4F9
	for <linux-raid@vger.kernel.org>; Wed,  8 Jul 2026 10:13:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783505638; cv=none; b=rvdUTw4E/KSzTjwy1dzTHEH1fvQawKRvW33rJ2a4obw0wH7D1wGZWW/xGZrGmOmD7CZPWwcNLtgtFyZOdNTd5+dJliznHLg8eJftvmg58CxelchoEGp18LRFypOGb/fhYhm+vVjkVu+e1Lkr2x/tpDpfB4lNa9v7YBttsYO5xdw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783505638; c=relaxed/simple;
	bh=K2psfWBbOFvFkQey/irFjqTputj+LlAcJSSQpa68qT0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fNBaBA8WW073hBtgb4/ZvX7LAWSoTKio7xjWmmdonY31GCG89IWpOIlp19gxlZsU/JT1pU2K1UH/BHdQiUSCNt3fpe43czkHEXt3VbUvhxbeawQFFbshMyRrtd36uSYCFtgQFIFY7+dplUHMoet9aUD/1ns5bokw7J1Q8oyzRQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Cbdue1GU; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Cbdue1GU"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-493c1950518so10395095e9.1
        for <linux-raid@vger.kernel.org>; Wed, 08 Jul 2026 03:13:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783505635; x=1784110435; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+3fSrcC9d8AfD632267ZB8B1c2KfzJbJhVQgSNVF2bo=;
        b=Cbdue1GUrUYCYscXwItO8TR2DGp7htF0t23sevqzTGkIUXWbE75/MLc7lvck9LPbOU
         Q0SdNkv+2wIOanKc1m9rNQL1ChC7ieT14nEX+319lLYUYeTIUJGjvQAww+Qm8Pw+QW+c
         5s4In5h+Owu+/bI7Nal3E6jMC9OTuRa03wkfecLy2WVOGPIVyalRQAXCxOMsmm/ULz10
         dmgOnwLbXW7EWQb+zMYgQG7jZbZkwGhd96EukiLiCalPuFhaICysbTdXKGZLSMbI7GQf
         MjTvLfyBDPMt8R91iwr54dEU5o86ws7BC0aYLwwysP4VQLzIDsPpmIJm0lZlyz9Mr7C2
         CL5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783505635; x=1784110435;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=+3fSrcC9d8AfD632267ZB8B1c2KfzJbJhVQgSNVF2bo=;
        b=VlkMEtb/00XgDNLt7B7u9vW0+AS2h11DQBlwl7FWjSPY4+RM/RbkyAdewyXsAXzH/y
         TSOF+/OtZNk6nU3WE90MsLUi0Dko9W9Eo8j3r8KwptL98NMI3RVxk91xaTKbNH/ztqPW
         BwqLA+6s9rclA7s3Klkf2RCikTDOKY/njdN5vcIO/oiDGhFNZBwneNh+t8AZ+hHOo/WY
         zUMp4ty1opU8DKParS0V/Kd9Xbn5vponD8fZDVXrblV9X2KQAZc+h1AkpA+xrSUHNtwq
         OCaiqGZyH7Vok4buguRVH9NCYzvOt91n9lFKUYH6nT3XoDvolM/WP5oaiNqVbIK+Flwp
         BR/Q==
X-Gm-Message-State: AOJu0YyMOJ4EXv/1LKbXfWE1qIxDTT/eqVlINfSlrYiqPIRJzZWRET8R
	XjrP35QL2XDmy7mUA1lSHj+3n50MS3oe3N9m+pgjARm5aGd/Cv/LOTTn
X-Gm-Gg: AfdE7cnB9LeUngc5+Cq7scv2vMrxI8EkgH5M+/yefHekke7wT+Ol69XB8ATH26B8UzF
	vd/3xajdwi+AOyqAMwix+Wg1RohV+yZliwdDIqaHeDDJvz0U9vCr3vAXpBFgq5OS7IF7Hf4GNmX
	dvRQv6osxMowEb60S5mxnR8syZ1FK3YoK3dbibZEaLzgl6BPXs3KAjHKGDRbKcFPgnOBba/gxgH
	ouhPT4SMHS+wOUmldfUd8ZXEZ7tuLILYKk9VLb+FnqsqPj3DBPa/OCAaexFvfvcIhZlwj48VGMf
	syJxRsH3A3k/SnbE1db+CmKRwJXIRRgFbyyR16B1B+YGeDTJ2wMpibHzcV1PbMf8vVkXJHdXl1l
	7vYs8voXiJAJ5AovYVORNiZOhfiZT5t5RSNEi9efYk3o5QRdt6HRw0vyfGGmh6lp9Cq6ZcwOsNs
	BUgcz9g/AZLE0IplUc1QM=
X-Received: by 2002:a05:600c:a012:b0:493:d117:18a8 with SMTP id 5b1f17b1804b1-493e6393a36mr18577165e9.9.1783505635143;
        Wed, 08 Jul 2026 03:13:55 -0700 (PDT)
Received: from yocto.. ([195.72.110.74])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-493e0faee30sm108987515e9.10.2026.07.08.03.13.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jul 2026 03:13:53 -0700 (PDT)
From: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
To: song@kernel.org,
	yukuai@fygo.io,
	magiclinan@didiglobal.com,
	xiao@kernel.org,
	axboe@kernel.dk,
	vverma@digitalocean.com,
	john.g.garry@oracle.com,
	martin.petersen@oracle.com,
	abd.masalkhi@gatech.edu,
	linux-kernel@vger.kernel.org
Cc: linux-raid@vger.kernel.org,
	Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
Subject: [PATCH v3 4/7] md/raid10: remove unnecessary barrier around bio_submit_split_bioset()
Date: Wed,  8 Jul 2026 10:13:38 +0000
Message-ID: <20260708101341.473750-5-abd.masalkhi@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260708101341.473750-1-abd.masalkhi@gmail.com>
References: <20260708101341.473750-1-abd.masalkhi@gmail.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

raid10_write_request() drops the barrier before calling
bio_submit_split_bioset() and reacquires it afterwards. This is no
longer necessary because the split bio cannot re-enter
raid10_write_request() while the barrier is held.

The allow_barrier()/wait_barrier() pair was introduced by commit
e820d55cb99d ("md: fix raid10 hang issue caused by barrier") when
submit_flushes() called md_handle_request() directly, allowing re-entry
into raid10_write_request(). Since v5.2, submit_flushes() has instead
gone through submit_bio(), eliminating that recursion. submit_flushes()
was later removed entirely by commit b75197e86e6d ("md: Remove flush
handling").

Currently, raid10_write_request() is only entered from the bio
submission path, so the split bio submitted by bio_submit_split_bioset()
cannot recurse back into wait_barrier().

Remove the redundant allow_barrier()/wait_barrier() pair around
bio_submit_split_bioset().

Signed-off-by: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
---
Changes in v3:
 - No changes.
 - Link to v2: https://lore.kernel.org/linux-raid/20260628142420.1051027-5-abd.masalkhi@gmail.com/

Changes in v2:
 - Expand the commit message to explain why the
   allow_barrier()/wait_barrier() pair is no longer needed.
 - Link to v1: https://lore.kernel.org/linux-raid/20260623072456.333437-5-abd.masalkhi@gmail.com/
---
 drivers/md/raid10.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 3480fc7907f0..2574f60dd771 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1487,10 +1487,8 @@ static bool raid10_write_request(struct mddev *mddev, struct bio *bio,
 		if (atomic)
 			goto err_handle;
 
-		allow_barrier(conf);
 		bio = bio_submit_split_bioset(bio, r10_bio->sectors,
 					      &conf->bio_split);
-		wait_barrier(conf, false);
 		if (!bio) {
 			set_bit(R10BIO_Returned, &r10_bio->state);
 			goto err_handle;
-- 
2.43.0

