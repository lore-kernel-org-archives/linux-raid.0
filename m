Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BF127081E
	for <linux-raid@vger.kernel.org>; Sun,  2 Mar 2025 04:34:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740890077; cv=none; b=Hp7gJrFY9/QVoUTugKQbI/qrXxaEXr4cuqDSeIF++TO8Ozw1zxciEsQ23iLIK5Ot1JYI0jg1xZDmuIMu56U3Cd/Xf35/X6hmIDdzYnnEMkdkck9m8tYRsjpilbVd46SYyytQB4GtQaUaot+IHtWH+4mMDGH7JmFVeBm9+aL4fBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740890077; c=relaxed/simple;
	bh=C3WGGlRTxSb1tnDW0f/qxJkg5iowJEo0XnSraOnEi1w=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=tTXjXcNOLn1EoVXWFHxYipGvhRyMA6vCip1dcxSLO9Gl6QJg6R4ij0Ro4dx531NhLbh809y6y2yjaYCy+nj2exTQPiJi3Ll8FzB1DP5jQitI7FhxOQXWCmLCiW1PPtkwlusMsiuJxy3ZdfW2rzfs1dIs30+vHVDjGCacpj968pM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=LSl8A4Ad; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="LSl8A4Ad"
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-390fdaf2897so713090f8f.0
        for <linux-raid@vger.kernel.org>; Sat, 01 Mar 2025 20:34:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1740890073; x=1741494873; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Lmr653ji4i2Zla89mDeZ6pG8g1f7ojZcRsRpiIBeAXY=;
        b=LSl8A4AdcF3CoJMo7wrvc7vqOqqUl1IeIGQNzRa0XOBRmh21nZNYo8hNCc8zPLN2Jq
         /q0NC7jXTO60rm5oV4uQv6GJqttSRSWFoq4CfroeHlkVjuzFTSzeWpw0o+rpRqrr5O1A
         qvGVjkAvb5mM2uH2UIIU4lLcCsSw/snQbJ0s4EuoGdbazwL17O0Dja1jwbDRaOJZpgE0
         NmYAXELAin52gKyAu3WCjn74Pud+pUAlRqnNbCHOu9gfwweO3khjj3/zJGptGbiyZTbO
         egtHN0+DMKwr7wI3HCZ224OfrGNPD8gFqiDDOrmWAiiLLyHCVft3NVGOKCOpngIsSTW/
         L1JA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740890073; x=1741494873;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Lmr653ji4i2Zla89mDeZ6pG8g1f7ojZcRsRpiIBeAXY=;
        b=SkDo86i/SWbDTG2qJ0COBHHQUG+SZEcN1gTzoxAye2cUBsQ5DiawwyqA4PYGYXwg/Y
         fMHHibNtZFscZafWDCF+lA3VjmagL5NExg4v7bkDJZDQMnSlgJNj4GjYHBnqZyj22h4J
         tzXGsBqiTnLsRFryLM1QE9CNl0DBTwcVpKslptB3ySHa8qpgPwmsfYoMkohBec1GwOIx
         PHtHECHGLW73PIA9dm5I66niRQ6+MjJtZvM4iL6pxxCSxUkqdaC3q1OviNC8xfJnAkjM
         gfw/pJouP6uilO/1YKJ4m6aQoKKdQxKDGRjj309dVpJPagxwkJ9hTMx6jPiPpw7WGWNV
         2YAA==
X-Gm-Message-State: AOJu0YwrraX+/C6PcMnP6PuJNxzNoMwJRaz/gmt5AokynJStdMD5IVk3
	cj1Rm3SepsY80mAlfQoF7bWVIhf7WO4myL8IflzXVVBXP8/TTtwGt84AXyRy2GOajfCQJZ0uqJn
	0OwQ=
X-Gm-Gg: ASbGnctvjhdEQLLRyJJnM4yztLg2A3aGyDxiSkzBcOVm7zUiETQUFmSiuY3zXvjmFC3
	DcWuCm05PnvXRFyPDB77HB2XAzxLP4oaljNLQFko/8dccuGoGufcXR/FdPhBRoIu1FB/ecsngCw
	G8rd0ccz+dzTKh8yia6zOtvkXdRKNRazZWX5DjDsa5US9o9bIdCZU6DAP7NC5XcVskctTSx54gu
	6LvdyONI3E1GgRZ/Ih1nN9NCUeWN6UZsg5ImuyFQ22ebjDGIOu/FKppf8InbTUIDu02utI3nSnU
	PxORr6y/6+WLJ+KT63Zycrdkj8xCBK/b6ygnaXXW4zQD
X-Google-Smtp-Source: AGHT+IHdz4Z0RT0w1utQ/gsTOuhQCVmzunu0pBX7ImmNUY6pt0F34qBJetJg7Wf+yTYMWcGj053vBg==
X-Received: by 2002:a5d:6d09:0:b0:391:4f9:a048 with SMTP id ffacd0b85a97d-39104f9a5d5mr336489f8f.4.1740890072698;
        Sat, 01 Mar 2025 20:34:32 -0800 (PST)
Received: from MacBookPro.lan ([23.247.139.15])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4747242e3basm43317861cf.66.2025.03.01.20.34.28
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 01 Mar 2025 20:34:31 -0800 (PST)
From: Su Yue <glass.su@suse.com>
To: linux-raid@vger.kernel.org
Cc: hch@lst.de,
	ofir.gal@volumez.com,
	heming.zhao@suse.com,
	yukuai3@huawei.com,
	l@damenly.org,
	Su Yue <glass.su@suse.com>
Subject: [PATCH] md/md-bitmap: fix wrong bitmap_limit for clustermd when write sb
Date: Sun,  2 Mar 2025 12:34:23 +0800
Message-Id: <20250302043423.95503-1-glass.su@suse.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In clustermd, Separate write-intent-bitmaps are used for each cluster
node:

0                    4k                     8k                    12k
-------------------------------------------------------------------
| idle                | md super            | bm super [0] + bits |
| bm bits[0, contd]   | bm super[1] + bits  | bm bits[1, contd]   |
| bm super[2] + bits  | bm bits [2, contd]  | bm super[3] + bits  |
| bm bits [3, contd]  |                     |                     |

So in node 1, pg_index in __write_sb_page() could equal to
bitmap->storage.file_pages. Then bitmap_limit will be calculated to
0. md_super_write() will be called with 0 size.
That means node the first 4k sb area of node 1 will never be updated
through filemap_write_page().
This bug causes hang of mdadm/clustermd_tests/01r1_Grow_resize.

Here use (pg_index % num_pages) to calculate bitmap_limit to fix it.

Fixes: ab99a87542f1 ("md/md-bitmap: fix writing non bitmap pages")
Signed-off-by: Su Yue <glass.su@suse.com>
---
 drivers/md/md-bitmap.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index 23c09d22fcdb..e055cfac318c 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -426,8 +426,8 @@ static int __write_sb_page(struct md_rdev *rdev, struct bitmap *bitmap,
 	struct block_device *bdev;
 	struct mddev *mddev = bitmap->mddev;
 	struct bitmap_storage *store = &bitmap->storage;
-	unsigned int bitmap_limit = (bitmap->storage.file_pages - pg_index) <<
-		PAGE_SHIFT;
+	unsigned long num_pages = bitmap->storage.file_pages;
+	unsigned int bitmap_limit = (num_pages - pg_index % num_pages) << PAGE_SHIFT;
 	loff_t sboff, offset = mddev->bitmap_info.offset;
 	sector_t ps = pg_index * PAGE_SIZE / SECTOR_SIZE;
 	unsigned int size = PAGE_SIZE;
@@ -436,7 +436,7 @@ static int __write_sb_page(struct md_rdev *rdev, struct bitmap *bitmap,
 
 	bdev = (rdev->meta_bdev) ? rdev->meta_bdev : rdev->bdev;
 	/* we compare length (page numbers), not page offset. */
-	if ((pg_index - store->sb_index) == store->file_pages - 1) {
+	if ((pg_index - store->sb_index) == num_pages - 1) {
 		unsigned int last_page_size = store->bytes & (PAGE_SIZE - 1);
 
 		if (last_page_size == 0)
@@ -472,7 +472,7 @@ static int __write_sb_page(struct md_rdev *rdev, struct bitmap *bitmap,
 			return -EINVAL;
 	}
 
-	md_super_write(mddev, rdev, sboff + ps, (int)min(size, bitmap_limit), page);
+	md_super_write(mddev, rdev, sboff + ps, min(size, bitmap_limit), page);
 	return 0;
 }
 
-- 
2.47.1

