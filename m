Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC08835AC13
	for <linux-raid@vger.kernel.org>; Sun,  6 Sep 2026 17:37:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788716264; cv=none; b=aEVyAzKQyN4kjt4bjOc+1x0K4uZ730JhObTpns/ev1lsYv3PAemNiXDDzOXy/NiryxddK6yqhFBW8GA0hEAHtA+sQt6BhVfleid1bKw7tY7LBvDlxHJVQxMLFGkhDn4Wl5M0ykXXnm62ZDNZ9TH/E5DpfkZ496zg63h+jNZmSfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788716264; c=relaxed/simple;
	bh=BaNpnanrjgbdSZKgIxI5TIOIZm3kDLtIvvcL+9R7TZA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R/lmBENTVWvfyLgKIqLL9u0ZnwLvWcSVxEpl/HGrQEqOMdhkdhZy+Olp0DF4wWcTVpND3+uUlx6TjAbUbNi5JgKu6T9BWjwk86732ho477ifrTUCDqjJCocT65Je0px7Mf4Jul8lO+3j6TclRSmwqF8FnRMeF0vJefVkgl+oBxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SZZTKBFR; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SZZTKBFR"
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-8520161fdb9so3001295b3a.3
        for <linux-raid@vger.kernel.org>; Sun, 06 Sep 2026 10:37:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788716260; x=1789321060; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=fATElZat+q7upA4tOibt7iYKQOftj7DVW6WQFIGNTcg=;
        b=SZZTKBFRAxhI9n/U3xxoxZGfiXf1hkq5qBLxGdqo00hrnJn0M59wFbYXO1gFcrC33G
         oBoKOL5yH1A8x6SRQM96cil+tUrpB3whx7oTCHIOk/kCcXwN3vCeQHhJUBhjwN17VXO4
         48VeO+dOV/7DKAZS4kgAUqwUScBbgt8WFpYeoHsrIjZyJFk4YHI7GNrbqujdkFGo8qdG
         SLbY53ryl/Ymj6clqG4jTuhKnDcNNAkRY3H50Iz/fEM2NEiKgmm/9De8RQbP4bLiNAaI
         yO7exLRywIH8l+IoNJJmeqi/TlZVRQ/iryuLug0ec5cw56jA5s0cexO6AZ6gFGoYHqsB
         lNyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788716260; x=1789321060;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=fATElZat+q7upA4tOibt7iYKQOftj7DVW6WQFIGNTcg=;
        b=juYC0++4hbC/7OkZ8L50UqLqleUGSa+3gn2gudZDYGJYQalB06NpPcRp/bVMXpsR7E
         vHtHkMovg9xtUjbKfdCysXBoVyCw7cnqlr+m600mO7rwRX8g912zz0uz6HRydIaeDnxt
         h8u8b3ElcEfA0/p6BCUoS/WDN/NqydrPz+rf/jwVdZjnWO2lHMtU81f52U43GF79mHL4
         VTqHVe6NgdQcIV2EM1PcaGrt7aYiCmIve7QtoACN1HeO4Im+bIHKzoOcZ5wEqHhzgZYp
         78J2F1GF+Jl+N87DiEGY2grW1xt+pWRgEWijk6G8v7NQ3r3drTzwVlkxkHCfdylVw+f3
         zeKA==
X-Forwarded-Encrypted: i=1; AKwUvBzFqHXpDnh1iEoZba4VdzBVJkGbHJp6tZaZ0YUcHpG6v3TRQucCxC9IDDnxUYCdOXUTA7eia076mVbK@vger.kernel.org
X-Gm-Message-State: AFuF++mE1KEnoHXpaicsheXrTVDjuWUrknaj+7UkZaSeaSZYByTsdB+Z
	bzyYycxqAnKSaRAwXGwMICJ1XztYA2m5bji2GZA8Sz56/fnRYW/HuWDF
X-Gm-Gg: AYBFou2GPPMcD3DAaj7jM/TUbLqqDWqoTV9KsHFBkMmxcQo8QWGsV9okemajnOwyfCM
	H5355h5zWBU3CzCi233UmIEDKKOA57k02ghoUV+jBImN/qJoBb3DPERzPAnz+0ICiHtJZ2NHWEP
	QKEhOuQAwae3nlgOEZoSsDeR2NTD7f2XawkGPdlbNf1ALM0KSjbmhzjxvbElmkBNyRnUXL2RgJB
	t+x/2exXDFC6KhcAHI6T7k25Mb0TfCzZDc1NenD3rUHUeUe/Tgg6jxf5pXoYtSsyOl3rEW3jOR+
	XIVwq54FMa6JF24h9x/W3Fdsd3mop4VoAXF5w+tZzbYpFW5B9g7/PcY+pTLHc29qZqVZ5TcxEhE
	Ee1RJdy4WvsVG/RJWulBx3w0CQw9/3f5v4WHOFkDxhn6SUCYxuW8NXjGs0MtqfnLaIVFTLd+A5N
	OY0/AzZzPsADs/rkNQdqziCJVw0SfUbxb+Oaj7lEFwg7UQ3laImKJJf3ZSN01uYLOOGps9
X-Received: by 2002:aa7:914d:0:b0:848:8715:c2d9 with SMTP id d2e1a72fcca58-86169676ac8mr27235730b3a.2.1788716259998;
        Sun, 06 Sep 2026 10:37:39 -0700 (PDT)
Received: from TheRealOne ([2409:40e1:42a:44b:2da:f86:5ccf:57e1])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8614f873cb6sm3323780b3a.1.2026.09.06.10.37.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Sep 2026 10:37:39 -0700 (PDT)
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
Date: Sun,  6 Sep 2026 23:07:23 +0530
Message-ID: <20260906173723.99768-1-chandradhar.2003@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260906143928.105165-1-chandradhar.2003@gmail.com>
References: <20260906143928.105165-1-chandradhar.2003@gmail.com>
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

