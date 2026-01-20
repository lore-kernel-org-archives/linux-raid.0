Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D88D63ECBD9
	for <linux-raid@vger.kernel.org>; Tue, 20 Jan 2026 10:24:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768904702; cv=none; b=tmGkMVnEjSYbqOWnh35jz3HJSvh2+yGSMvOFQdcT6uUippI5uAXKydv/frs9SRQw66Jo3O3ej06pe8+EeWnD27JtTsv1dZIGkoEQE1dcqRFWoZh9dQV1jkYD0cPao/j1NkW8jqrFB8ZSNHsmgKJuvsFLkMmaDcPy9y1S8ittEjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768904702; c=relaxed/simple;
	bh=Y/J5hmeY8P6xt+jICQZvf1Nb0NO15zApZvNqeWkA7GU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=osNelXXUuqQN37fcbDP7YN7c8Eh7LfnY4SsDkHSRncjJpt2FrHUNz470KA7KNvu4HzxexrsUoSJDFjkqqc/zOelKjbPOCGx7gummgWCKcLI62LwDZ3KXHhvWOGVCNv77ydnlLIyuquUuw1LpIvtQAYihP5y+6Po80yowj9T+P5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ionos.com; spf=pass smtp.mailfrom=ionos.com; dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b=dlVNhdu/; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b="dlVNhdu/"
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-b87d3bdedaaso28838666b.0
        for <linux-raid@vger.kernel.org>; Tue, 20 Jan 2026 02:24:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1768904697; x=1769509497; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=4QIb/Z+1VcMgY5q/jZtPEfXlsRsDdbkIp3UqDsbrZUc=;
        b=dlVNhdu/KMjR6xMGQl9qiMFHjx26MWDeA4wFATIMWm8FBRJbreW5QUD7H0Uoavp1hA
         db5ucaFmcCClpTtzlAKXJMZY/BlDaRRaF3voWjAzsIck3QVAEct351jMff+eIVSb9l7C
         UeAj5d+tJWXdiRre3bUQU+LcLyToeGyTCXyZmWenm3/umPPAv+IWhqZQzi3s/ZoPOiM1
         BhGutPrAF6w2rT/Saqhaaw/ESfrWxBTSWfx3lTsGUK6pcmzujiOm/LbyTTwC0j/H4OLM
         8jNQsSmNTQta/lWF5GFU/SGdmJbE5BIw5YH4rgDtmH0oSbuKkWoSx0yRsBIyxakb1uax
         ieKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768904697; x=1769509497;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4QIb/Z+1VcMgY5q/jZtPEfXlsRsDdbkIp3UqDsbrZUc=;
        b=DkIQKaxMoDqyeTra1HcrkqBmqsAS6rLgBLUQFjbeQ2MmIl8+LoSXcu9s1ehRaOQ1IE
         eZMs6kzddtpXZokek3ygqptYhByB1aCo4F84fCs/5+++73/QGeQptopnLIwgvc2o4RZm
         F00ue8x+kyKQ4sAfpwmpKUTIYzJh7swIlVu5rw1W+iU3qTeMJzDLinODpc7dFVHaYmJj
         ElIwM9nqMvMLPTx0a+BLKGNX8nWLWro37kK2jDijwnHf9W1ObJZq93GW8/jzlpAThFl9
         SIaC2BUwpb1os/xJX/5wo/JHy4QGntDlNWzAg2X6CnoGh1w50hG+Hb4BjFGq4ZuNNts8
         PZOg==
X-Forwarded-Encrypted: i=1; AJvYcCU560HweCqknVtgEUJm7ZgbwGgfC3VVf9/LfSFh6c0VJ4yyKKapvTlEW2yhJlCnInYdIQbXeZ/cnE9D@vger.kernel.org
X-Gm-Message-State: AOJu0YyMZ9nJ1e00jHeKigJNqBXjr0RQuhUkpFWwvqbrE6A22p2mhkeV
	jWDutLINhNLSuxGF1zEnafMCff594U4yn8qyjnE5HtCe1hXvNabMuxwbEgDpS5I/Osw=
X-Gm-Gg: AZuq6aKfoGYXbDKpyrGOJqnOePMKkGvv1IiLMSKYQCdklLmZDAKx4vlBp46p830d+MN
	X+mwY946l/uF7CgtUs/+rGAOmIcix8wpsfWiXnGPeXj6VDFQxOa3bPy2fQaJ49BTRiF6agzZxtC
	MeSEzlJi6ueErGguxqgNgkBz8VZjXY1oPcHifh1N/+3ySXMSGKqO6EuTQVn2BlL5tGOI+B/mALp
	GtgwZ9UJ9jFMMo97cUYBHwN43Wc9uyod1kO2WdKiyBf3TmQPmTqlzcUh5A/sAgfqm+isu7HYQsS
	8NYL6q1fVCt1hE8DaZATtl7WtqkGUQ1ql44SMbn8ub6UvbXjKm0dmpX9nXwM5daaGjPcQUgiscN
	Jty0GjttZUuc2nBT4eEz+XfOlkCKgcTix0uMM19Td9oalJzIeL3VXW+jSv3mstOm1vBxUAxVUOR
	gtc3YiQzkMqmf1CkBHKQS9aKiGyXjTbSF2PdY=
X-Received: by 2002:a17:907:9706:b0:b73:59b0:34c6 with SMTP id a640c23a62f3a-b879302ebb7mr771796866b.4.1768904697155;
        Tue, 20 Jan 2026 02:24:57 -0800 (PST)
Received: from lb02065.fkb.profitbricks.net ([2001:9e8:147d:3700:2c77:8dc8:498a:7917])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b87959c9a08sm1355766466b.37.2026.01.20.02.24.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Jan 2026 02:24:56 -0800 (PST)
From: Jack Wang <jinpu.wang@ionos.com>
To: song@kernel.org,
	yukuai@fnnas.com,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org
Subject: [PATCH] md/bitmap: fix GPF in write_page caused by resize race
Date: Tue, 20 Jan 2026 11:24:56 +0100
Message-ID: <20260120102456.25169-1-jinpu.wang@ionos.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A General Protection Fault occurs in write_page() during array resize:
RIP: 0010:write_page+0x22b/0x3c0 [md_mod]

This is a use-after-free race between bitmap_daemon_work() and
__bitmap_resize(). The daemon iterates over `bitmap->storage.filemap`
without locking, while the resize path frees that storage via
md_bitmap_file_unmap(). `quiesce()` does not stop the md thread,
allowing concurrent access to freed pages.

Fix by holding `mddev->bitmap_info.mutex` during the bitmap update.

Closes: https://lore.kernel.org/linux-raid/CAMGffE=Mbfp=7xD_hYxXk1PAaCZNSEAVeQGKGy7YF9f2S4=NEA@mail.gmail.com/T/#u
Cc: stable@vger.kernel.org
Signed-off-by: Jack Wang <jinpu.wang@ionos.com>
---
 drivers/md/md-bitmap.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index 84b7e2af6dba..7bb56d0491a2 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -2453,6 +2453,7 @@ static int __bitmap_resize(struct bitmap *bitmap, sector_t blocks,
 		memcpy(page_address(store.sb_page),
 		       page_address(bitmap->storage.sb_page),
 		       sizeof(bitmap_super_t));
+	mutex_lock(&bitmap->mddev->bitmap_info.mutex);
 	spin_lock_irq(&bitmap->counts.lock);
 	md_bitmap_file_unmap(&bitmap->storage);
 	bitmap->storage = store;
@@ -2560,7 +2561,7 @@ static int __bitmap_resize(struct bitmap *bitmap, sector_t blocks,
 			set_page_attr(bitmap, i, BITMAP_PAGE_DIRTY);
 	}
 	spin_unlock_irq(&bitmap->counts.lock);
-
+	mutex_unlock(&bitmap->mddev->bitmap_info.mutex);
 	if (!init) {
 		__bitmap_unplug(bitmap);
 		bitmap->mddev->pers->quiesce(bitmap->mddev, 0);
-- 
2.43.0

