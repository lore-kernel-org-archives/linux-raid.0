Received: from mail-ej2-f12.google.com (mail-ej2-f12.google.com [74.125.228.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE69D4E8DE0
	for <linux-raid@vger.kernel.org>; Mon,  7 Sep 2026 13:39:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788788380; cv=none; b=fu6TTVJHn3jwr61gpS2R5ez+0q8QYM1Cdg88uLGNsfAOj9QIlQ4y/sOAUXdJnsFcVfwOS82YtBd1GRSaMp8LfxXYuQiK5Q4xcz3Z7aF8t5cf2PeiEaxxufR570rr5kedpo8mVUAksbIibYmfMTuXlmq3Oe6CWQT1x323KHnlT9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788788380; c=relaxed/simple;
	bh=j1qQhW/DMga9//Ebbmvtda5D1XA/aQWh2EDKH/0LM2Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BIFnRhubCzSfIN4J9B8lLOhJubWoW5cJUeGGK8VPgokLR9Gvsznr5p/4/wiY/c9zbpHKp/cS0sX9HyI5Jm0cIqjOPiXonDa/t32lSud6HcKGwrQ6jHIPY3wZB97Ehp4l/RSiDnK1w/8pOh9O4JMXJcoilgaH8nWVJ3nshFinVHI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ionos.com; spf=pass smtp.mailfrom=ionos.com; dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b=gkqhCZIZ; arc=none smtp.client-ip=74.125.228.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b="gkqhCZIZ"
Received: by mail-ej2-f12.google.com with SMTP id a640c23a62f3a-c2507a0a21fso27738666b.3
        for <linux-raid@vger.kernel.org>; Mon, 07 Sep 2026 06:39:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1788788377; x=1789393177; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=G+X7Aa1PtynLQRsIRhDWSLMhkCeEiNsDSsNbut1hjAs=;
        b=gkqhCZIZRlnPMXRltd6zez8wMjALrsemQCpiQl0OWgMtke6I9Kxu2FVXwpzoYljRlJ
         ODMhOqJXgyzbO29kCM4Q4cNhrUWEsCvprHlyPyYkMMbF+6QiUoj3VRRSb7m4pnSnBwAh
         pDFHgKkgsxjxUnhCAwQHP5g4MDCnfaNAATEcSRqdnea6Xif5bn+83D4BzQA0U/o1oig3
         OMcqhtRewqs6OPmNr3NSpFpt/XG3GPh6A1rG5RzFD7m8I9QVQLjjFg/yUzGb1ZTSyriK
         818QpeORuOwSA3alBsNd5MFPL2qcscoptIT+XDLhLx0L1uOxGiY+x66K1bAgs1Wsjiht
         ox2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788788377; x=1789393177;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=G+X7Aa1PtynLQRsIRhDWSLMhkCeEiNsDSsNbut1hjAs=;
        b=gBH3vq5ssTvbiH/orYdMw0KzmNIw7ZYGHcCYVeM4lDetAOJoh2JKg50Yevv3C42JAx
         kb1mtdxzREFUVaX9DkQmGxJytbxyjkAl+OqHWvpRU201wyXD5antjowMuRz9eEKbVPih
         vKX31zF1GzOSW/kY8LwGoGlpJmZvybXFsSPutyGtIdZuKYOsqMvAw0Ib3fNk6m9yBU1U
         BWDrYUQjGdpxPFY4XuZq4a1y4NcZLcaKloyrsRLM3AlAuXZAADyyzM7foJmeDzUihWMT
         +/heOCYRTN+0TL9l1fVhHQLu3nMcufx1GGQzXkguHym7TzBxUzEUcP01vE0TL1rhNfcU
         yf7g==
X-Gm-Message-State: AFuF++kIVp+PDAUn70kq/oSN8HH2kbdTQABMl3zTqMy7weKjA1LGm5yO
	fnvHZX3bNKfcF30QbOiLvH4N1ceRg32LamoxUVRXcQTwZmb8phPpN2n2uzvnZxQ8rrQ=
X-Gm-Gg: AYBFou3ZsteWra54Cq7xdoQ3o3BA/dvrtUogC59Jq4GENJMo0Kpb6w0WHUajJbgubLU
	P27+P+IVoy7r0ZfapZIhjwxhq0CSSvXv26uaabq9xphRKYsuQc+ujZY9n3/5ekY0OU4lSICezXM
	m7usQ18O+iPIRCt1w6cmTusGRC9TwzfO8r2hyzJ8U9aCpFEWL1G7c7UsQk2l+GNvHjzLr6mKx/y
	TzXjQnvTaCjgyVIJHFhSnuN6XZeobRqLnKr2j1P1/lxJ+Nd/7cDeCLTCvGySKdyh466Rl7FlSxD
	1hI3c1Ai/cIsB2J/LdQNilfKBGWCv/Z3Vt5mEiShbnDw+uDJsi8F1kn9ixggsQV+JZlAcB5nhk1
	EnUX+eA+4YUmBlolhLhMR3xj2gM0e/mcyt8ZKWNNa/gL/bKnmowyhnNLAGDhj0chRX6VswwVEjt
	q2oDg/+Hfc2DKDIwMtKnU+yah4pBraQxBhdbKJF2fuqVT/FwYf+lmLGvHtAdlmI2pib/7IKKAW0
	gbrP3bMWVhzy6grxt7za6bNN6c+c56YK1F4NlfLzL3p
X-Received: by 2002:a17:907:3fa7:b0:c1f:4754:d87b with SMTP id a640c23a62f3a-c2624f0a4f6mr557429666b.1.1788788377056;
        Mon, 07 Sep 2026 06:39:37 -0700 (PDT)
Received: from jwang-ThinkPad-T14-Gen-6.fkb.profitbricks.net ([212.227.34.98])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c262c770678sm314301866b.53.2026.09.07.06.39.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2026 06:39:36 -0700 (PDT)
From: Jack Wang <jinpu.wang@ionos.com>
To: Nilay Shroff <nilay@linux.ibm.com>,
	abd.masalkhi@gmail.com
Cc: linux-raid <linux-raid@vger.kernel.org>,
	linux-block <linux-block@vger.kernel.org>,
	Song Liu <song@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Yu Kuai <yukuai@fygo.io>,
	tom.leiming@gmail.com,
	Jack Wang <jinpu.wang@cloud.ionos.com>
Subject: [PATCH 4/6] md: pass a queue_limits through the rdev sysfs stores
Date: Mon,  7 Sep 2026 15:39:27 +0200
Message-ID: <20260907133929.1081540-5-jinpu.wang@ionos.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260907133929.1081540-1-jinpu.wang@ionos.com>
References: <20260907133929.1081540-1-jinpu.wang@ionos.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jack Wang <jinpu.wang@cloud.ionos.com>

state_store() and slot_store() can add a leg, which stacks its queue
limits, and the caller has to own that update because q->limits_lock
must be taken before the array is locked and suspended.

Give the rdev sysfs store callback a queue_limits argument.
rdev_attr_store() passes NULL, so no functional change; the user
follows.

Assisted-by: Claude:claude-opus-5
Signed-off-by: Jack Wang <jinpu.wang@ionos.com>
---
 drivers/md/md.c | 45 ++++++++++++++++++++++++++++++++-------------
 1 file changed, 32 insertions(+), 13 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index c7d1f9813f5d..8ad6fe178e96 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -3033,7 +3033,13 @@ static int cmd_match(const char *cmd, const char *str)
 struct rdev_sysfs_entry {
 	struct attribute attr;
 	ssize_t (*show)(struct md_rdev *, char *);
-	ssize_t (*store)(struct md_rdev *, const char *, size_t);
+	/*
+	 * @lim: a queue limits update the caller owns, or NULL.  Stores that
+	 * can add a leg to the array must stack into it rather than take
+	 * q->limits_lock themselves, see md_start_sync().
+	 */
+	ssize_t (*store)(struct md_rdev *rdev, const char *page, size_t len,
+			 struct queue_limits *lim);
 };
 
 static ssize_t
@@ -3079,7 +3085,8 @@ state_show(struct md_rdev *rdev, char *page)
 }
 
 static ssize_t
-state_store(struct md_rdev *rdev, const char *buf, size_t len)
+state_store(struct md_rdev *rdev, const char *buf, size_t len,
+	    struct queue_limits *lim)
 {
 	/* can write
 	 *  faulty  - simulates an error
@@ -3257,7 +3264,8 @@ errors_show(struct md_rdev *rdev, char *page)
 }
 
 static ssize_t
-errors_store(struct md_rdev *rdev, const char *buf, size_t len)
+errors_store(struct md_rdev *rdev, const char *buf, size_t len,
+	     struct queue_limits *lim)
 {
 	unsigned int n;
 	int rv;
@@ -3283,7 +3291,8 @@ slot_show(struct md_rdev *rdev, char *page)
 }
 
 static ssize_t
-slot_store(struct md_rdev *rdev, const char *buf, size_t len)
+slot_store(struct md_rdev *rdev, const char *buf, size_t len,
+	   struct queue_limits *lim)
 {
 	int slot;
 	int err;
@@ -3378,7 +3387,8 @@ offset_show(struct md_rdev *rdev, char *page)
 }
 
 static ssize_t
-offset_store(struct md_rdev *rdev, const char *buf, size_t len)
+offset_store(struct md_rdev *rdev, const char *buf, size_t len,
+	     struct queue_limits *lim)
 {
 	unsigned long long offset;
 	if (kstrtoull(buf, 10, &offset) < 0)
@@ -3404,7 +3414,8 @@ static ssize_t new_offset_show(struct md_rdev *rdev, char *page)
 }
 
 static ssize_t new_offset_store(struct md_rdev *rdev,
-				const char *buf, size_t len)
+				const char *buf, size_t len,
+				struct queue_limits *lim)
 {
 	unsigned long long new_offset;
 	struct mddev *mddev = rdev->mddev;
@@ -3511,7 +3522,8 @@ static int strict_blocks_to_sectors(const char *buf, sector_t *sectors)
 }
 
 static ssize_t
-rdev_size_store(struct md_rdev *rdev, const char *buf, size_t len)
+rdev_size_store(struct md_rdev *rdev, const char *buf, size_t len,
+		struct queue_limits *lim)
 {
 	struct mddev *my_mddev = rdev->mddev;
 	sector_t oldsectors = rdev->sectors;
@@ -3573,7 +3585,8 @@ static ssize_t recovery_start_show(struct md_rdev *rdev, char *page)
 	return sprintf(page, "%llu\n", recovery_start);
 }
 
-static ssize_t recovery_start_store(struct md_rdev *rdev, const char *buf, size_t len)
+static ssize_t recovery_start_store(struct md_rdev *rdev, const char *buf, size_t len,
+				    struct queue_limits *lim)
 {
 	unsigned long long recovery_start;
 
@@ -3612,7 +3625,9 @@ static ssize_t bb_show(struct md_rdev *rdev, char *page)
 {
 	return badblocks_show(&rdev->badblocks, page, 0);
 }
-static ssize_t bb_store(struct md_rdev *rdev, const char *page, size_t len)
+
+static ssize_t bb_store(struct md_rdev *rdev, const char *page, size_t len,
+			struct queue_limits *lim)
 {
 	int rv = badblocks_store(&rdev->badblocks, page, len, 0);
 	/* Maybe that ack was all we needed */
@@ -3627,7 +3642,9 @@ static ssize_t ubb_show(struct md_rdev *rdev, char *page)
 {
 	return badblocks_show(&rdev->badblocks, page, 1);
 }
-static ssize_t ubb_store(struct md_rdev *rdev, const char *page, size_t len)
+
+static ssize_t ubb_store(struct md_rdev *rdev, const char *page, size_t len,
+			 struct queue_limits *lim)
 {
 	return badblocks_store(&rdev->badblocks, page, len, 1);
 }
@@ -3641,7 +3658,8 @@ ppl_sector_show(struct md_rdev *rdev, char *page)
 }
 
 static ssize_t
-ppl_sector_store(struct md_rdev *rdev, const char *buf, size_t len)
+ppl_sector_store(struct md_rdev *rdev, const char *buf, size_t len,
+		 struct queue_limits *lim)
 {
 	unsigned long long sector;
 
@@ -3680,7 +3698,8 @@ ppl_size_show(struct md_rdev *rdev, char *page)
 }
 
 static ssize_t
-ppl_size_store(struct md_rdev *rdev, const char *buf, size_t len)
+ppl_size_store(struct md_rdev *rdev, const char *buf, size_t len,
+	       struct queue_limits *lim)
 {
 	unsigned int size;
 
@@ -3766,7 +3785,7 @@ rdev_attr_store(struct kobject *kobj, struct attribute *attr,
 		if (rdev->mddev == NULL)
 			rv = -ENODEV;
 		else
-			rv = entry->store(rdev, page, length);
+			rv = entry->store(rdev, page, length, NULL);
 		suspend ? mddev_unlock_and_resume(mddev) : mddev_unlock(mddev);
 	}
 
-- 
2.43.0

