Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6968B1EFFA1
	for <linux-raid@vger.kernel.org>; Sun,  6 Sep 2026 14:41:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788705661; cv=none; b=XyhXqvFSgTNQC5mWPBNXgZVmyj1wLLOTeW+u0r6HLfZ5rnGtcY/4IJscDOowRqbIFFVkDS2dsUdeRIDdlEP8kZkAIi3jm1fRNqxJbUkokz7dpW0Lxw/Le8m6/0/mYE09emikP4mzTpoyb/LoqB1TRo1lLiqmAxFPwFThHgnpTMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788705661; c=relaxed/simple;
	bh=qSkze1wnDFxPe2Qp8CSDQ7kKZ1F5vdgOvkv/4UTabOQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=jIrsSXfdGQfcvkkSrU0p5aw7SEZv7ai4PZGSk5N7Zg/BumJcM3qagOPh7zFVvmLKOTJAkJ6ztNeFzSlhD+XJQSui6UObInJBnMWjLMGKPqxc4TG0oyXT5eeOvygS7a9KwFDkBfJoO24x6uwp7l9e6xklFAnw3T3gGjP4b3Zn8kk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=sOTY7hYB; arc=none smtp.client-ip=209.85.216.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="sOTY7hYB"
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-39b52169dacso498051a91.3
        for <linux-raid@vger.kernel.org>; Sun, 06 Sep 2026 07:41:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788705660; x=1789310460; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Y29ZXwt6eztTyx4fKyFoN65StSazZKPoWVgHCLODAmY=;
        b=sOTY7hYBDrrd+DpLGnmOg6hPtxP8PM1ibQyQJdFtIy44RFnbhHCE4yx2TItdKte3JV
         4zuzQTIAe0UxE1XTKc3ZZyXlBrnBrxepwPPR1tTD4kJDL9cz6oD97KBqhe/VrkbshUiw
         eqc/j7FSGOpVqAGYva3yBOF2vf+D+UE2kM3dJCHSDSdL4EoSNbMwfCGs5MNxtQX1aUuT
         2FrvoaGNRXT7h3puf4faaocePja7PfxEYPTegkgB1QBKFZ06ocLny1yhGJso4PVesyOm
         uBy/kY0tzsNTKu9HHbaVoP5km7GH9UoNOmE6PiivqJwE5DCDWE6znbo512sS6gNtKs0c
         ii6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788705660; x=1789310460;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Y29ZXwt6eztTyx4fKyFoN65StSazZKPoWVgHCLODAmY=;
        b=cOJUHfR7kdI6rirMT5bWGRV5JRqditfItLGyzi5RVy4kNXlASLErN8YcRL3XxDdmjd
         8/d7Fr+6ra6HlYzkkisez0dbOsKmnRMhPXokgWTPK/OZZ91100yBU5OEm6caknRU+l+I
         ufCI5vrHChRPxzRUKqzouGlAeFlU4upuqXBIdCYlQGDvLE7ofox5EDBKdJSVGEqp6Fnr
         8ZPzFkXBMFPa/t6zU5hmqmzEOksu4QOXwvv5y5yust4SKoVjn621AYxlz4lTjEH3SEKy
         amN3kFtAs6w1T4xejE1h4inQzpmYUUXiSCk6eG3TEN7aumLSAOsNqUPqA41z20khePKJ
         NOAQ==
X-Forwarded-Encrypted: i=1; AKwUvBzUANeTOt4rooJE8xIIqYbb5KBrQyU1/6kxKUM8sTSY5+tT05+2TOQOmKULFMaqoekOCu12JlmsYSq9@vger.kernel.org
X-Gm-Message-State: AFuF++k9hzquvWBQQhct2uZ9W9Sv9TRPJHyIhAMlwcOIgv5uiz1XYHpG
	Qsyi/cS1dQNZ30Q53UCcw+lPUsLpEFatZX1SMiVi0HEXJpe8zV8xXYJ5
X-Gm-Gg: AYBFou0+VywejWDpypVegSfyTt66gSx6hp3GbTWi3qklAAv6qwT0aPv4BdPbVOLsBj9
	CsvI5pSRetyGKVxWiPs5Yqkt23Iqw2eTkCHWMPrmpTy8NrTmtqk2/j+topR7/W/GPBLX43oZPHG
	e5QjR2DnzsA55mHdF7O9gSsDBxJLW/fBKlgaVPDhLJoqiIdTEb8cZ/epF2UJnJmkah0wWD6iSVd
	H/L2gcX/EpA5GD8yLf5GemURjmFqdnVa83FmaePLuZndm47klKTHNDD/Q7CB6brSYvdwgOhiCE+
	jB81hr773i4mENak0unbNkEwRe8z3QhPbO32Fpz2bbj3iaiwBYCvpIppVSERNL7QK1dJO30tBoS
	d6GdHJNhy2m3zm89YWDeec0kMRx1uCm70+/BP4f5KJRcyCjT83KnQqsBzUSMHHXBrSiJ1lvQHfC
	PuuXBTDQWVT1EnNezbi88J3tqMl4R/z8eEo9z+dwsZC9/gEF90Bx99EfpFECr3m7tqdhuzZc6k
X-Received: by 2002:a17:90a:d2c6:b0:395:4de4:92c7 with SMTP id 98e67ed59e1d1-39b260d2f07mr27672809a91.3.1788705659725;
        Sun, 06 Sep 2026 07:40:59 -0700 (PDT)
Received: from TheRealOne ([152.58.138.157])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39b260fdc1dsm15583678a91.7.2026.09.06.07.40.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Sep 2026 07:40:59 -0700 (PDT)
From: Chandradhar Kumar <chandradhar.2003@gmail.com>
To: Song Liu <song@kernel.org>,
	Yu Kuai <yukuai@fygo.io>,
	linux-raid@vger.kernel.org
Cc: Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	linux-kernel@vger.kernel.org,
	Chandradhar Kumar <chandradhar.2003@gmail.com>,
	syzbot+a32ff75e417c0f49a8e9@syzkaller.appspotmail.com
Subject: [PATCH] md/raid0: validate device count before allocating devlist
Date: Sun,  6 Sep 2026 20:09:28 +0530
Message-ID: <20260906143928.105165-1-chandradhar.2003@gmail.com>
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
---
 drivers/md/raid0.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index 35e103f0c2c3..586e3411f24c 100644
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
@@ -147,6 +150,14 @@ static int create_strip_zones(struct mddev *mddev, struct r0conf **private_conf)
 	conf->strip_zone = kvzalloc_objs(struct strip_zone, conf->nr_strip_zones);
 	if (!conf->strip_zone)
 		goto abort;
+
+	if (nr_devs < mddev->raid_disks) {
+		pr_warn("md/raid0:%s: too few disks (%d of %d) - aborting!\n",
+			mdname(mddev), nr_devs, mddev->raid_disks);
+		err = -EINVAL;
+		goto abort;
+	}
+
 	conf->devlist = kvzalloc(array3_size(sizeof(struct md_rdev *),
 					     conf->nr_strip_zones,
 					     mddev->raid_disks),
-- 
2.55.0

