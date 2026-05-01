Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AF8F39E166
	for <linux-raid@vger.kernel.org>; Fri,  1 May 2026 11:47:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777636037; cv=none; b=E1uJmHrw5H4jVv/j0Az9YnWX14UwzwbuW6gWy/YS5/f26/B+50ED6PnmeAjwgrFIWx4aWUpAdgRKi6lRZkwPjLS/ZitaQVCGaJIwIwaTiy3GLRVcnzOQnomQ3JvXOBSSRuhgw6fDkWO/E+RCi6QgYQkKeEwtn7ov9NruhyGE5H4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777636037; c=relaxed/simple;
	bh=MY25n66b3XI8l9MKMDg8jxLtPtljlha3GqLPvC0cIFU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WNb9ZqZd6ZHdWxl7SUU7K5WDpoTU5MHgtu9D+23gWfsfSrnTqqoe/rW5Mq0O8aPWJ9hWdg+N/d6EN3/GdQ0QiQMl0QG3OD9yAjoaCbXB45OaXsYcB3ian0IjQvvaKtieagN44ifc+M/qljye1H1BuQlu1MoVdOutA/aOeO1cZ80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eQdC6Y8g; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eQdC6Y8g"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-48a7fe4f40bso18730865e9.0
        for <linux-raid@vger.kernel.org>; Fri, 01 May 2026 04:47:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777636035; x=1778240835; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=v3DoX980qHTT9loeDHHdIPh9j7EwwCIsT/UFKNqvCqA=;
        b=eQdC6Y8gQQWhVs481xZKRTrBy4Zu/M+7Scr/RsHrgzn9NuJvnFNpDh4bhLljc8II9V
         18dZK6VjoLlwSvFeMJ924G8F4n/rwPlT5WbKcla24SXOg05dnjGVp7v1O30HPC/a6W1V
         uknjSsdUlZSFkP9Fd66OPLJdhzBDK9bjCOakP3yTmpb2PZY1SWWFcDKTeOfIz/Z1w92J
         sxkbyDTAWZjO+Z+ikns+uRrPtzlW5pj9MDweo8ya3qUlYrqK2NbFpLxdRjm1rd/yU5Hy
         09Uibdh4iTZv617ZYlEIz2ydnZwYVQTSaGu9W3tUpJu98AIsbQbvKQA/9d9m12jk0cEj
         FMyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777636035; x=1778240835;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=v3DoX980qHTT9loeDHHdIPh9j7EwwCIsT/UFKNqvCqA=;
        b=cWd2s6QT65vbho9Gs9z6d4sl/880t2Fmp/h3ZUJvK97uVjd1XhvtxMwS3/6BK29vTm
         RHepksA0PoyVFPsA5Ou8rxzbXkLj/QPnwv0B0SXDrakWtOoucV7jHO8NP6UZmEwtnNic
         N9QEws2TreunfzMx264MNENgIrfKAIgQvXvafjXozl/pOTfxIX1nEtb/GuAOKv6nsfb7
         D615Au6D3z9KrhLxAjX1OpmmxYQds/LVMHIYeq8bb9uJHWq3ubtR87uTRFm6C553WoZH
         TpRY4vB8nLUNg7JkgF67hMQd3XlryXdVXw9x1k8gjUg5vu9Nc48AUDRvjpng2jJDjO/T
         b7TQ==
X-Gm-Message-State: AOJu0YyvJWk3N/sq4Yt0qPGHnzaupBSmRPOXdn9BASYgsgsgQGiFmZn3
	JspPpDL1Kx1qvgpdOnv5yISf/V7kIboWupn81JdsL1PIBftdlu4UNHAG
X-Gm-Gg: AeBDietkWWmQ7CagGvrBxP407HD01Q1giELHGlm33KRdZZRfncS9/NPvlDXj3OeFRFd
	wvs/xEchMett6kXK+8yZi09O3JS0G3/Csa0tQLXCJ4NLEgrzeP8cr70lVGUGD42tsDZLbk+YnGX
	DIxDuysQ0mDhmc7krHimeJNczVgcrQ76svVd9KRGjQYgJHlUMHHaqukMnIeNPhtqyqPfauDFvir
	J9seJ7JABxR1gUNimaT28ron4XP0lBRfDaSvXZ7+AJWFFWv/oP9ihKCJZyHWjRovNLOoSfHXQcF
	1w6PT/Qw1iNnle7tlQErx0hWq8tAzfEd7/ABWUktHMrPmBSDiMpQro5qvEZ46zE5qxEPeO7dkWv
	jE+BaDsLba+l5HKKUQAdYNoLeyJDyuG1WwXjBmH/9KospiZowhLhez8dSzNFaYktUzbN29eV+eJ
	GaC9JjAmc6UipkWyQDEJMssbUPhJRSpKbtyQ==
X-Received: by 2002:a05:600c:c117:b0:489:6c22:e081 with SMTP id 5b1f17b1804b1-48a83d05535mr80606955e9.0.1777636034625;
        Fri, 01 May 2026 04:47:14 -0700 (PDT)
Received: from yocto.. ([2a02:3037:621:7039:f080:d03a:2ee1:37d9])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48a8fee5033sm11797005e9.22.2026.05.01.04.47.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 May 2026 04:47:14 -0700 (PDT)
From: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
To: song@kernel.org,
	yukuai@fnnas.com,
	xni@redhat.com,
	neilb@suse.com,
	shli@fb.com
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
Subject: [PATCH v2 3/3] md/raid1,raid10: fix bio accounting for split md cloned bios
Date: Fri,  1 May 2026 13:46:51 +0200
Message-ID: <20260501114652.590037-4-abd.masalkhi@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260501114652.590037-1-abd.masalkhi@gmail.com>
References: <20260501114652.590037-1-abd.masalkhi@gmail.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use md_cloned_bio() to control bio accounting instead of relying
on r1bio_existed in raid1 or the io_accounting flag in raid10.

The previous logic does not reliably reflect whether a bio is an
md cloned bio. When a failed bio is split and resubmitted via
bio_submit_split_bioset() on the error path, this can lead to either
double accounting for md cloned bios, or missing accounting for bios
returned from bio_submit_split_bioset()

Fix this by using md_cloned_bio() to detect md cloned bios and
skip accounting accordingly.

Fixes: bb2a9acefaf9 ("md/raid1: switch to use md_account_bio() for io accounting")
Fixes: 820455238366 ("md/raid10: switch to use md_account_bio() for io accounting")
Signed-off-by: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
---
This patch depends on patch 1.

Changes in v2:
 - New patch.
---
 drivers/md/raid1.c  | 2 +-
 drivers/md/raid10.c | 8 ++++----
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index c52ecd38c163..dfaf34141325 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1396,7 +1396,7 @@ static void raid1_read_request(struct mddev *mddev, struct bio *bio,
 	}
 
 	r1_bio->read_disk = rdisk;
-	if (!r1bio_existed) {
+	if (likely(!md_cloned_bio(mddev, bio))) {
 		md_account_bio(mddev, &bio);
 		r1_bio->master_bio = bio;
 	}
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 8c6fc398260e..93af7bbc9005 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1146,7 +1146,7 @@ static bool regular_request_wait(struct mddev *mddev, struct r10conf *conf,
 }
 
 static void raid10_read_request(struct mddev *mddev, struct bio *bio,
-				struct r10bio *r10_bio, bool io_accounting)
+				struct r10bio *r10_bio)
 {
 	struct r10conf *conf = mddev->private;
 	struct bio *read_bio;
@@ -1226,7 +1226,7 @@ static void raid10_read_request(struct mddev *mddev, struct bio *bio,
 	}
 	slot = r10_bio->read_slot;
 
-	if (io_accounting) {
+	if (likely(!md_cloned_bio(mddev, bio))) {
 		md_account_bio(mddev, &bio);
 		r10_bio->master_bio = bio;
 	}
@@ -1552,7 +1552,7 @@ static void __make_request(struct mddev *mddev, struct bio *bio, int sectors)
 			conf->geo.raid_disks);
 
 	if (bio_data_dir(bio) == READ)
-		raid10_read_request(mddev, bio, r10_bio, true);
+		raid10_read_request(mddev, bio, r10_bio);
 	else
 		raid10_write_request(mddev, bio, r10_bio);
 }
@@ -2872,7 +2872,7 @@ static void handle_read_error(struct mddev *mddev, struct r10bio *r10_bio)
 
 	rdev_dec_pending(rdev, mddev);
 	r10_bio->state = 0;
-	raid10_read_request(mddev, r10_bio->master_bio, r10_bio, false);
+	raid10_read_request(mddev, r10_bio->master_bio, r10_bio);
 	/*
 	 * allow_barrier after re-submit to ensure no sync io
 	 * can be issued while regular io pending.
-- 
2.43.0

