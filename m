Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0150A1A9FA8
	for <linux-raid@vger.kernel.org>; Wed,  8 Jul 2026 10:13:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783505630; cv=none; b=uTweesZSwT2b4Lbgn4vvjLr4B+Mhnl8Eo4A/mdE9Fdl4q4URRf7pHQW2GRw5md7CU71wS0inn7wuJhV99dg9FmT/BHpzqYFOuB289y2whiTum4m9HB4aGI2QFIMJkwN9qGO2AeSFG5+zqfOFL17G8g8DDePuwtzp4qTAL2/cY1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783505630; c=relaxed/simple;
	bh=fPsMTWcB4QH1amVD5019DZv7UOAXGmrLlZijcW3E5CA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=koqqd2l6zDgzdd20aklWVk/1Vguu6Us+eWSOakuWXwAhowClAMjJFym+KV1OUfgizm2Bg4xCZ3Kn2HQZB6SqAaDHPlziM69fLHZta+arumZ34dVuK0cG+Yr8ttdbVHCFSdjOia+c7y6+H98tsvzjaU88tsx0vECb+IGfiOZBjao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IrlEVJdm; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IrlEVJdm"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4938d5f86f3so3129435e9.1
        for <linux-raid@vger.kernel.org>; Wed, 08 Jul 2026 03:13:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783505627; x=1784110427; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QTSLyDYUqKwuc6ZFj/fF/ZTPe91RSvx+oh/5nIT4BLE=;
        b=IrlEVJdmOMMfS808iC75fnjiYJa+iMb6MfQNouuxjc0y3qn6l5oYAvTDGO04clSlX7
         GBlRPIAVAnMVhtBX/oUG1Ayt/OQVy9wN0dUbQXsW9jb78poPzKmZYZDrsD6jF6TkXzbc
         Hpx5PoaABJc+UU3CycENeMijJwg/aZUbgqgCfFcDVFHBmeSjrl8F5tuSV8M5RgD6B5Vx
         F0BPsAnRaQHWnv18cope6+KnLysDV8jdvrtAol+qWqCq89u/fr/2HOKxSSn+QF4QnQ/9
         HOFsEjHB4NckOQ0IsCBg9ip8frxZDMf+Zl3PsXwIM4ZFqOi4bt6vB4rW38FFxlLxSBH8
         oQaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783505627; x=1784110427;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=QTSLyDYUqKwuc6ZFj/fF/ZTPe91RSvx+oh/5nIT4BLE=;
        b=qn5NvbQg9j/LGW158peqZEuLBl3w3d4XvUL2rUYkBDT6Hk2t9NQ4UGnMOIwEQfpypg
         Bs4llrJBwJG54IH7OcnIrq2+p1vVjuMIgXDEC6Cw+HLA0Xq2ZU+BUQmm6wzzYLkUiyUz
         KdLlXXkdRgM+mcTc/+pZKiXF8I29yXzgYGEH4gGABMyr8dQ2gbjuVXT0TM1qTLAZFfAF
         yblh3f6jX3u7lRdt8zDA7qIrcnND0efzxKWepiTU4KP4Z11H1U3v3yMhC4c+XizUXWG7
         +X3pUGpzeU8ruSAiZB4wnwL8vw75vQnp6RyO6LWJzgcpXhcyPVjo6ABHmZ1EeYNiWvL0
         Txyw==
X-Gm-Message-State: AOJu0YyVZP8JOSDn6u76eUvDZebXA/+uqbPyKe0aG6HtlJRtWD1DpBkw
	dzfID3OFgRYwnRxHcl/i7IMmSbKsUlWm8XZ0TwPO+hNSomovSM9andZA
X-Gm-Gg: AfdE7cm7zNXxtLiVUKbEUzYVfT/sr6v4FhRXutiPVQxd9hGOB17jSbpUZzjw5/wBU9Q
	fp7k38tsGD7aL8ngMciQEFLa7vnTxdADW3/JW1bQU8DJaVTueFPhDfrIveSBeKEAUOdqIzIVMGu
	hQSDzjftdOBYlbzOOQ0OA+1Q3wJMeaWH5oSerJDSxRdKlf/xqRg1XC/goHltoOwiaI9aBUxipTl
	SQtNtlE8bm7lMGZeikkPznjVBfIRnKX7k7jJm4Hdu6UkoZQO+1dinpW1AQHJXlnurCWiJc6gu/Z
	oOe9xbC4CX/8p7pluKxqk5YCxlvDKWcIYhpuVYR434w5jMOtYfTmdr0TUA4CZgetm5wJR74Tra6
	pmgnok/3S/UU5tJqU79wqbGyDs4l3mm4OHOmqlbtl9qiYA/POtY3leul1Uhir92OCyXkWsIPbd2
	rz5fNn3V1iuur0gR4bZFA=
X-Received: by 2002:a05:600c:4692:b0:493:e2c3:af25 with SMTP id 5b1f17b1804b1-493e6393963mr19702045e9.12.1783505627166;
        Wed, 08 Jul 2026 03:13:47 -0700 (PDT)
Received: from yocto.. ([195.72.110.74])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-493e0faee30sm108987515e9.10.2026.07.08.03.13.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jul 2026 03:13:46 -0700 (PDT)
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
	Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>,
	sashiko-bot <sashiko-bot@kernel.org>
Subject: [PATCH v3 1/7] md/raid10: fix r10bio leak in raid10_write_request() error paths
Date: Wed,  8 Jul 2026 10:13:35 +0000
Message-ID: <20260708101341.473750-2-abd.masalkhi@gmail.com>
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

When raid10_write_request() fails because REQ_NOWAIT is set, the
allocated r10_bio is not freed before returning, resulting in a memory
leak. Free r10_bio before returning from the REQ_NOWAIT error paths.

Fixes: c9aa889b035f ("md: raid10 add nowait support")
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/linux-raid/20260613184042.BCEC01F000E9@smtp.kernel.org/
Signed-off-by: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
---
Changes in v3:
 - No changes.
 - Link to v2: https://lore.kernel.org/linux-raid/20260628142420.1051027-2-abd.masalkhi@gmail.com/

Changes in v2:
 - No changes.
 - Link to v1: https://lore.kernel.org/linux-raid/20260623072456.333437-2-abd.masalkhi@gmail.com/
---
 drivers/md/raid10.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 0a3cfdd3f5df..bd322eccdc3f 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1365,6 +1365,7 @@ static bool raid10_write_request(struct mddev *mddev, struct bio *bio,
 		/* Bail out if REQ_NOWAIT is set for the bio */
 		if (bio->bi_opf & REQ_NOWAIT) {
 			bio_wouldblock_error(bio);
+			free_r10bio(r10_bio);
 			return false;
 		}
 		for (;;) {
@@ -1398,6 +1399,7 @@ static bool raid10_write_request(struct mddev *mddev, struct bio *bio,
 		if (bio->bi_opf & REQ_NOWAIT) {
 			allow_barrier(conf);
 			bio_wouldblock_error(bio);
+			free_r10bio(r10_bio);
 			return false;
 		}
 		mddev_add_trace_msg(conf->mddev,
-- 
2.43.0

