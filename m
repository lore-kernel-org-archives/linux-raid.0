Received: from mail-dl1-f42.google.com (mail-dl1-f42.google.com [74.125.82.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5ADF2FA0DB
	for <linux-raid@vger.kernel.org>; Mon, 24 Nov 2025 23:48:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764028107; cv=none; b=lfjJcJPSWi3mSqMDuAEpzYB4w7kWEd3XeYonYAKy8G33i6D9JnU7ce2XMYsDGI3ZtQMK9XvUoah6PuTQ1u469VIU9MBt4wXIadhjfV9dAw+G+c2LJ+JI3j1J5Lg2zXAxukq507ux+FOTbNDmNXCPUJRbjPEWsSRcrPiXqstndOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764028107; c=relaxed/simple;
	bh=ZSqWbY8pVyhLaY6mUuy6f+COqFQf+G+FnHH6zSesNgY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=JBIqpTyz1zweSBuIHxwY5VFzRBpbCgfagO2DSXmCS9hojoTduqpCs1KrTnq2QZvz2bA3B3aybT+hvfDurLgma7gUhzcNl3rH/fmrJA2RUZ24ZlyIeWqk7IWlq+WrJfFE0cQg5gOr8u/H8q+5zkAeT/eZix6qSHxdWtUaSE74d14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Qb345Nfg; arc=none smtp.client-ip=74.125.82.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Qb345Nfg"
Received: by mail-dl1-f42.google.com with SMTP id a92af1059eb24-11beb0a7bd6so5763225c88.1
        for <linux-raid@vger.kernel.org>; Mon, 24 Nov 2025 15:48:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764028104; x=1764632904; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9hEyetpjb5QpX08wjji0bcnEJUxus+pp0XTDG4Zkk6c=;
        b=Qb345Nfgcp4/TxX2cohDRFWy4A7Z8bs6C7M20K9EPkPwIvIIqvJcVU5QcCx/pVLHI3
         +nhvatqStEz4oKY8azbMrTkKu3oSrZpEK5Ep0VUn2e2LA+//TqGUJQZ507mggj2l6Q8h
         2k2JC3xiaANHCMK93YTjPDulC/6vXvv/WCeAbIsdWXjd7eeVQs3amslApCRGHRF67apk
         mIDoYKUYSfblcY8ACgSg3xqpnfQ79aAxC/mH5xofaBHX61fKsqoUtGA44+Jfut+P3fn1
         ovfpu1tJJC1qqmeWtiozD/8WxYkFXA3pOrKSpv2x0jJJMl/7tfoY8LWsML2YZEJzoVfO
         F4+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764028104; x=1764632904;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=9hEyetpjb5QpX08wjji0bcnEJUxus+pp0XTDG4Zkk6c=;
        b=M58Zvm61B32+p/25KApzWeDmaNTmGbCxEz6tZ+PvbVc3xLkBKRUYrTNNnbuhPaoHM+
         wT4gt6COWLLZbbgcxmswQXpBunc1FwckZUPAwjKkW0YCIHsgZWdTr8EwHcYhgU7yBQyU
         hjoNJY32sj3VFVS/oLT4i4JkILFqjYSuHkQe/FgdMjiogax2wHscvtqouTmOkm483k0m
         bXbRrJXfRyphVWpqvH1U9VvaGpDmSzKgYdT0VJY2a3FJ6wHpj3m35OdRUn3PbZben3i8
         v0L0h0vCZeeHHjB61b+9qLIf5QYKSWPOGKF7cV7A8x8CYIsmLtJNHm+8dQBqqgoPwn77
         4wNg==
X-Forwarded-Encrypted: i=1; AJvYcCWwHRGrj/wptbzNPI/fYQCUrG6VcpgckHmKYTV1/4OoozZeWrtAtY+I3QmvqNmaIJmGM6TSYEojbzOw@vger.kernel.org
X-Gm-Message-State: AOJu0YxOJMkW5A73rqnHGyuQgLZizH6uQNsfi5WEOnJBh3ymsWzsptGT
	7GGXgN3PzC3H+XkTbT3MsQMOlHciUEDpiHBJjN8urOm14Trs81hzeZdc
X-Gm-Gg: ASbGncvQQtSJuQKsu84LXwxhjkADtfKNHKEC2odMdMcBwF7G8RBDeoIHz4xUZ2Wz9+u
	w/SScZRTAh2NZMDHfT2u4WFSs9E465IsmKtifBqUPVAKvqMnxWZR8Pipg68J5SsQObHcFpxhlL5
	uz/gzjhrPFw7od/uDph/M5i4W5VxVyn6A4U+3OPMwDw1wNDO9iIRU1vuNQ6HtqdLkMn8eOfBo74
	4cGIx73LG6REi7CmwDie1szwO9PiQhGZCMWdOURA6Ubi+c8LYVWH7vTNzHW4PVCZngUc7c4hUb3
	1pFn9vHMlFrBrqe5jjOvcguVZSH7QFrBoiqbwanHL1U1K9cl9/uk7GuTmTNIBMP5BwAc+32teaM
	c05mXzs+cu/UTcoFebi+W8jFH0DW12r9Fu18by2kbw3itqYgtVdcZCMlPn+YbIoCkUCVbvi6mOk
	/D7eXYNJP44PcZRa3kSkV6H+DzsdLjoUFDqIO6E3/jgukJ4ls=
X-Google-Smtp-Source: AGHT+IG0os1yUTB1U8y0wFQR2JhU9wfG8RKwx2eS9+a2sORTH4Ie8rtwmUzrvPIYkCFTBjjRJcm4Ew==
X-Received: by 2002:a05:7022:ec17:b0:11b:9386:a382 with SMTP id a92af1059eb24-11c9cabc4f0mr8878128c88.21.1764028103912;
        Mon, 24 Nov 2025 15:48:23 -0800 (PST)
Received: from localhost (ip70-175-132-216.oc.oc.cox.net. [70.175.132.216])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-11c93cd457dsm72215229c88.0.2025.11.24.15.48.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Nov 2025 15:48:23 -0800 (PST)
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
	Chaitanya Kulkarni <ckulkarnilinux@gmail.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH V3 2/6] md: ignore discard return value
Date: Mon, 24 Nov 2025 15:48:02 -0800
Message-Id: <20251124234806.75216-3-ckulkarnilinux@gmail.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20251124234806.75216-1-ckulkarnilinux@gmail.com>
References: <20251124234806.75216-1-ckulkarnilinux@gmail.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

__blkdev_issue_discard() always returns 0, making all error checking at
call sites dead code.

Simplify md to only check !discard_bio by ignoring the
__blkdev_issue_discard() value.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Chaitanya Kulkarni <ckulkarnilinux@gmail.com>
---
 drivers/md/md.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 7b5c5967568f..aeb62df39828 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -9132,8 +9132,8 @@ void md_submit_discard_bio(struct mddev *mddev, struct md_rdev *rdev,
 {
 	struct bio *discard_bio = NULL;
 
-	if (__blkdev_issue_discard(rdev->bdev, start, size, GFP_NOIO,
-			&discard_bio) || !discard_bio)
+	__blkdev_issue_discard(rdev->bdev, start, size, GFP_NOIO, &discard_bio);
+	if (!discard_bio)
 		return;
 
 	bio_chain(discard_bio, bio);
-- 
2.40.0

