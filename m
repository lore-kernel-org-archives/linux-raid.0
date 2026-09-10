Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6336E42125D
	for <linux-raid@vger.kernel.org>; Thu, 10 Sep 2026 08:11:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789027885; cv=none; b=ukLynttSQwZJYx36hXqOChVQDJkBnbgd5mfI3PCKqg4JHEX7Ms4Kjoat5nKGrnXW+4czQm3UEvc/DhCqcEYZV0uiqxB8RPAVeQ6htIPNRn6YnCNuREIISZaoEAnk4tnFug8Wx0CcLrO1Qu3dhZUfl3MBE/ggLRBwEhWHP8kUzH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789027885; c=relaxed/simple;
	bh=K9IfShwLc/c5Al3z8c+Rt6NM850R3QuamoNvpA0sKPQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UcMq1aVefuSIE7RgmW0LRvS4K2orNbo9OAyjhPMW+jLSr7SJ4Z/GlXB37xEjslvHIMro/Qmv0FW3QBY7mpRbVe1hSny2jOrwJtKUZ49P8lu8YE1cj96cUpT27eSXDhwksj/HZduavMnmgJ0RCcCJDr2O4JhXKmeYLbx7yYX6/Zg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ionos.com; spf=pass smtp.mailfrom=ionos.com; dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b=VX3oo+i6; arc=none smtp.client-ip=74.125.225.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b="VX3oo+i6"
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49b4ba7fe26so2624235e9.2
        for <linux-raid@vger.kernel.org>; Thu, 10 Sep 2026 01:11:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1789027880; x=1789632680; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=cgHwrkYbfZz0Oniv9vK94zADT2EQaqVt5Nm8OKIDVDc=;
        b=VX3oo+i6Z4fZYW5psAswbvCbxzhUG6RDy9AqWQDdZKltJvF+g1aGYC/sOFsUR76iLa
         +USCVZSfKPQWf/ceE/xpUx24XikmuzxvVRpFPrd+MYOqRIiFvIiGRVgpqTIeEV8cdk7h
         KzfbrB/+Rxe+J5mlhjw/pb+Nmz/WjrqxDJ6JTgHpj0cOM0cgVRwehs4Poi1/EiActOYU
         L7Uwu1Rq/Khu2XrIby/rGDDdGd8QiSmlnd/4z5zeAH0OUqGYbHWQFGndRuo89k19qm/4
         Bm/AMpFU1r1elCR2sy48lfYV2mBH9FK3AwoFc9QquCgeWiNoYhylRzPR/s2/7G6E9jjn
         Spfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789027880; x=1789632680;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=cgHwrkYbfZz0Oniv9vK94zADT2EQaqVt5Nm8OKIDVDc=;
        b=jsskPZk0dHFEdKQM62qakluwKlh7SGxSbTQA4D0ow8Jj2i4d7JIK94RhYB3yCuNBZB
         cVvGZb2T6oENf7THMqKAbiMDiuNHf0c3j9jTxsTJiMEHrBMMyBD6mP5CTLzxKgbliYEM
         BJq1fTigj5t6VLxtbEm/xkyts2gaCgwY3Yy5INDZlMNFfhnCrkYEmw8/6uidyi0snByh
         ZFJjxitnWZ9R1BsWGmCPSggMa+FATj4uzr0mfb/7BuhwySUHrSzyB4IxbhOfguAmYgE5
         GPae/pNyTpjaQlXxO1LG2AJtvoecQmXmP7U2wtL1jpz8iCyQuSE28969c8pQmMwJTpFz
         PHcg==
X-Forwarded-Encrypted: i=1; AKwUvBwPkxdnc9NmaSOLYqFivtoAGlI/5/gofuCJDIiwsgwMguphqZrpCorfqlvi77IrPsPJ25S4M56932Vs@vger.kernel.org
X-Gm-Message-State: AFuF++nm4TGz/1NZ9bwJtqJI8EZoZ/BBKo+48tZ49RjNzw/AiRmRPXzy
	gLHRnky/iZGMTKTAGiFPjJzxLVI2BZ7sxHB3P7J3gCEQD1VurVameftIiJi/yvXAwxAqvgwrdrQ
	sxhKNfLI=
X-Gm-Gg: AYBFou1GrF8JgcGLtY4OseSyZAa6BkNAxRBE93Dz0l3r0SqL6EIjs1KhH7fazKzmFy6
	oGcM5cCYqV7BoiavIrYE1cT/uwSxmQYXxgxp0Ng2Be3tLY/8N9Oq0raTStqhK+OhvVpcFg/Wp+u
	cdZnkfLV3Xxu6RAapgdlQoui+P15WAODeKRbOFE5JMe0sEutZY2IvQLWYeqfD6w8TrB4j6fdgNq
	1GqwQEXMKT2D4r8pwDT6shzNCDw2sF3aQIZ8505DZhj603TQRfR4A5tDa/VQOT/r+cAZ9hq2002
	yhRueg8LmN8qEPgSTy34NQMzDEVD4JhagfaxOS6W2mWwme1kZAzbWxJXnJH3gbGOAPmWKqdfgz+
	fkc3Z57TZ/GE7yXO9q4rRQ7M4TsZVivx3vCJhGblTK5bZ0bJ1ywZymHMjk/XG13K4i2gh+sOrlx
	0hgiuEe8iqdpvdmLFYriqDN0bLfYiHVoHzgOfeK8qBnAr/FMMzD3afrNt4D9/SZYjJpKB6uO9A9
	vrwttWtogUVXHmd0l/ZA1nPX8/ptVoXhj2GVc/pSHAbsvGAooBJPQo=
X-Received: by 2002:a05:600c:474a:b0:49c:ff81:e062 with SMTP id 5b1f17b1804b1-49d276628c8mr26060515e9.2.1789027880278;
        Thu, 10 Sep 2026 01:11:20 -0700 (PDT)
Received: from jwang-ThinkPad-T14-Gen-6.fkb.profitbricks.net ([212.227.34.98])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49d20fc1be3sm55261135e9.4.2026.09.10.01.11.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Sep 2026 01:11:19 -0700 (PDT)
From: Jack Wang <jinpu.wang@ionos.com>
To: Song Liu <song@kernel.org>,
	Yu Kuai <yukuai@fygo.io>,
	linux-raid@vger.kernel.org,
	Nilay Shroff <nilay@linux.ibm.com>,
	abd.masalkhi@gmail.com
Cc: linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Ming Lei <tom.leiming@gmail.com>,
	Xiao Ni <xiao@kernel.org>,
	Li Nan <magiclinan@didiglobal.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Jack Wang <jinpu.wang@cloud.ionos.com>
Subject: [PATCH v2 3/8] md: pass a queue_limits through the rdev sysfs stores
Date: Thu, 10 Sep 2026 10:11:08 +0200
Message-ID: <20260910081114.1605746-4-jinpu.wang@ionos.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260910081114.1605746-1-jinpu.wang@ionos.com>
References: <20260910081114.1605746-1-jinpu.wang@ionos.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jack Wang <jinpu.wang@cloud.ionos.com>

state_store() and slot_store() can add a leg back to the array, which
stacks its limits, and q->limits_lock has to be taken before the array
is locked and suspended.

Give the rdev sysfs store callback a struct queue_limits argument.
rdev_attr_store() passes NULL, so there is no functional change; the
user follows.

Assisted-by: LLM
Signed-off-by: Jack Wang <jinpu.wang@cloud.ionos.com>
---
 drivers/md/md.c | 45 ++++++++++++++++++++++++++++++++-------------
 1 file changed, 32 insertions(+), 13 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index e60dc2c7eb90..3067ea05ba27 100644
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

