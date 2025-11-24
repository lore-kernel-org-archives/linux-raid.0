Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50E38296BBF
	for <linux-raid@vger.kernel.org>; Mon, 24 Nov 2025 02:57:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763953068; cv=none; b=paGMrKjsoM6y/Rvy7A7GBy8YPuNAG5QeJK1cUasUs5FDkm/9noJ6ZMl3/eCYPGo1KUMhNquktYViJBFiSwyTjoc9HorKrGyom4HroSlEDZJlN9Vr3JIYSEgjlYLANlCO6yybPlRfYIfkHFxR2HB39YqqO3GIOYOtfU+tJcOHzDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763953068; c=relaxed/simple;
	bh=W39EvEsOKZnDPgVc3vjL1URC280/rs9OxMSKpDWz+C0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=fF5a6aFRJHiK85qyFNGOqd4V+xK8+uF8PPiTfkUu4Nzj1fCICJ/iLbJ2oIqOjuL4el0HZMVCDgpaGpQPv3aaGMIunV2iK1yapxAuqoyPjyOQFc78nd7lQplvonhFe47HG9YQTTz8b5Prucod3XrFVAHBGp5R4oJZcmDcdVawUgE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=es3r2e5j; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="es3r2e5j"
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-7bab7c997eeso4126266b3a.0
        for <linux-raid@vger.kernel.org>; Sun, 23 Nov 2025 18:57:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763953064; x=1764557864; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RkWhYF4f1lhsSHEbmYsrWUEDoM/XD4r0C+XpnxkiI8c=;
        b=es3r2e5jxI9XJcfPMggIH8P8nNDiDjsJ0Me9LddzgHyb1i3TMSJtaOT3/jRq3q83mZ
         O5R7VNra46ae/nXXcqHGRvbakFLvXVvWpqHttaumyNkJLv4Zb+XqcrO9csRKskEcZyrv
         zhSoSAEjliIrWF/OsSQq/t/1hosJJam+Butbg/YZhSj6E8yc6gSq1lWWg4Cw3sBgkg1M
         0we5vkxSFzU1RmteCbQwkMDswnkYpujwZsa6/YCxINQBoGxFgr5FFGrfPMRUG/vSjZ0o
         ASgA9iSHxvsS2dFmSUo1PjqiW7Utmp9ZrcYM66hXfsmuMnrQrO8uuH6nB0cm7EDVLIdt
         ImsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763953064; x=1764557864;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=RkWhYF4f1lhsSHEbmYsrWUEDoM/XD4r0C+XpnxkiI8c=;
        b=G2oVHvNJa23dm/YfFMI1UHHlmDvjaO4prmeKoJ0/ldSxkxrvrewQv7SdH3grH5crHM
         AjDIX9XQRk/kCp3Of2jwKPXAZFwahq9ZOEGRO0DzC3N1VFXv/7o5lX/yPs3Gc8YqQkmd
         znzaDLzFbzLJrfvv0D98GK8KwtDvzjpp+nt2VhaRwqF0Mn7+JiFJahKfLCMh6vP+KvoI
         1eyRInJ1s6ADgFentfJoS30Lk7n6zgShqi8GU31THZTds3JclNfz+m6FOLW3jG6A6YuP
         GzY/lFyrcpkvjNn95LLEEZXV1PchE6dl1rlaz6puv8TuYbeQByvXGDgimZc2B1rPdIxS
         ibAw==
X-Forwarded-Encrypted: i=1; AJvYcCVsd5ug8L7vq8TNp5gM5ARHse4KFG7ZTiXoqvBQFxPIwNJ0RF75YYsEyh23WQKa+UYzhh9q6kUlBat+@vger.kernel.org
X-Gm-Message-State: AOJu0YxPabjKhIAg9vpeJL5iMiXjyb97brxvu8YVCjJdvte0twZLRj5A
	PpTEcr+ejZBtUsAC2xqbgEeREPUoWFaplb83zKGba9d1Iesoc+v/cKIe
X-Gm-Gg: ASbGnct2FaDNFyRmtAvaawdDW8ylCFkKLNuflLoBfcfFudd8DwDZIxl3KzKpvdq/JBN
	a78l2J4hgheUXBWaeWV+MrORn8OnXenZw8oopcQRojHi+bkz3x6lUvlf5ymHZCoJO9tBSjM42G/
	WeB/as1gahsAJSWCd5ichFb8Sy6KfUEmM4EhNQ18CCb/C2k4lWpj4zDtyOe+XJjdUYcDpXYRzJI
	4ZIRI/12ghgJZR0ut3QlbndqoDwbEkrUCjnZz4KbmT9cgbUubmV2x3PbktLmgb4aaFqMhyjkNC0
	Pfu2i4LIKnddHhaarHulGrhYYUmXbYkrZkdAMJkimbn7T0+XXye+JqkzG9F72OUK3YELAyxjQSC
	4/wORCtb7j5WfjZFspNucqU3ollUS1LfAlKnOcuKddR1ZiwXuMvQJ3Miw4TC45aZkbb54C95aPS
	NoXuEOWLRc/2qA8Nu8aOdIZSv1Vg/TxRGCHhTci36pZiAUq30=
X-Google-Smtp-Source: AGHT+IH2vl9a4qHa0wFFFsUNbzMzey1IZwx6tJlzdt+jREZgI3T8WYYR2vo3qAu15ZJ2v/Ev109wPg==
X-Received: by 2002:a05:701b:2803:b0:11b:2138:476a with SMTP id a92af1059eb24-11c9d8539eamr4726588c88.27.1763953064432;
        Sun, 23 Nov 2025 18:57:44 -0800 (PST)
Received: from localhost (ip70-175-132-216.oc.oc.cox.net. [70.175.132.216])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-11c93e6dbc8sm65938624c88.10.2025.11.23.18.57.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Nov 2025 18:57:44 -0800 (PST)
From: Chaitanya Kulkarni <ckulkarnilinux@gmail.com>
To: axboe@kernel.dk,
	agk@redhat.com,
	snitzer@kernel.org,
	mpatocka@redhat.com,
	song@kernel.org,
	yukuai@fnnas.com,
	hch@lst.de,
	sagi@grimberg.me,
	kch@nvidia.com,
	jaegeuk@kernel.org,
	chao@kernel.org,
	cem@kernel.org
Cc: linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	dm-devel@lists.linux.dev,
	linux-raid@vger.kernel.org,
	linux-nvme@lists.infradead.org,
	linux-f2fs-devel@lists.sourceforge.net,
	linux-xfs@vger.kernel.org,
	bpf@vger.kernel.org,
	Chaitanya Kulkarni <ckulkarnilinux@gmail.com>
Subject: [PATCH V2 1/5] block: ignore discard return value
Date: Sun, 23 Nov 2025 18:57:33 -0800
Message-Id: <20251124025737.203571-2-ckulkarnilinux@gmail.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20251124025737.203571-1-ckulkarnilinux@gmail.com>
References: <20251124025737.203571-1-ckulkarnilinux@gmail.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

__blkdev_issue_discard() always returns 0, making the error check
in blkdev_issue_discard() dead code.

In function blkdev_issue_discard() initialize ret = 0, remove ret
assignment from __blkdev_issue_discard(), rely on bio == NULL check to
call submit_bio_wait(), preserve submit_bio_wait() error handling, and
preserve -EOPNOTSUPP to 0 mapping.

Signed-off-by: Chaitanya Kulkarni <ckulkarnilinux@gmail.com>
---
 block/blk-lib.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/block/blk-lib.c b/block/blk-lib.c
index 3030a772d3aa..19e0203cc18a 100644
--- a/block/blk-lib.c
+++ b/block/blk-lib.c
@@ -87,11 +87,11 @@ int blkdev_issue_discard(struct block_device *bdev, sector_t sector,
 {
 	struct bio *bio = NULL;
 	struct blk_plug plug;
-	int ret;
+	int ret = 0;
 
 	blk_start_plug(&plug);
-	ret = __blkdev_issue_discard(bdev, sector, nr_sects, gfp_mask, &bio);
-	if (!ret && bio) {
+	__blkdev_issue_discard(bdev, sector, nr_sects, gfp_mask, &bio);
+	if (bio) {
 		ret = submit_bio_wait(bio);
 		if (ret == -EOPNOTSUPP)
 			ret = 0;
-- 
2.40.0

