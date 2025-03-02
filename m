Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7B8C3594B
	for <linux-raid@vger.kernel.org>; Sun,  2 Mar 2025 04:39:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740890359; cv=none; b=VJzRlQbJxcP08keitCT3EaJU+dptR3q9eokCS4fAnLFnFt/E+A7Ic+E3B3oA+nLZGSFjwJZUJiMR/ygUYgh03JyW1sMMTaOlXkmpAngwODI2MqzLQEBMEL56U5FqWWerot1ayGmVlwa1Z7kQPUfNa7xf/nuyB7F4kzZlTQjJIWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740890359; c=relaxed/simple;
	bh=u0BEroduC++4ggseBW0wdEFqt5krIJfbusANI713Hfo=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=NybHNp/SdvmmbriUswWdIdrqBRlZd3kedW+cCVywieoPg0xe2g1bifR845MgRxceTVUvXGRlCTK90Bo0ZxLj3TKP++fHNiXwYiDLj6nSOTBsOEccGidkCsoTciFb4OyIz6oboeHPMPOZO17m4A5dWnpxQ+WtqhOztkeg4ApVikQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=c0PGu0/f; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="c0PGu0/f"
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-38f406e9f80so2687399f8f.2
        for <linux-raid@vger.kernel.org>; Sat, 01 Mar 2025 20:39:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1740890354; x=1741495154; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=MLNAco9QN/kY41Ceoewh3OyzysthpRVm7cVswo7AkSs=;
        b=c0PGu0/fv5/IslKM7fBjHI0lncA1h81An+iVX9rByBeGM2YzYkArYXIiM/MwzaQJKl
         nUZ2xL9HdpX77MPsBSVZEH8Hp4h1DgP66tmJ+a3/5vQORhBQooG+Etm+gMOffLQ/h4Jx
         64znSDb25GzEks24ykIBG4rUre/CMH0YHQuZEuHB/mEqSyJ+mcFPCld+ZYSDkM35T2mO
         6PC3Ew3oT5R80GkJ6X0NiELEWlKx3SBybCA8ESB3kIdnfWoizxfKcbFcz7yqfsssbynK
         syLSrUfqCtIgA8qgZXHtwFjaWqqr9kDf9DuEVmOoeiLGivL0AqOqFkr1RIR+wMZ3CMMN
         vDZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740890354; x=1741495154;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MLNAco9QN/kY41Ceoewh3OyzysthpRVm7cVswo7AkSs=;
        b=McqGjZf1hVPjXoJP/1IbN+bdtJ86b5OEx2IX2194K2GpNGdigRzsZcv7cN3SscCGrf
         flGwvNh2rwxGuS7TYGqoph6K3LdyO6cU6uuXoCmKAcIcO0lz/FEnvxbiVqtknTtygPCp
         1Sq/ytti37zoeeL1ZqPAMylMZOmeIhGAmnM1daC354ZO6t+pgnxACt90slcVUiOP89Qc
         7XyMKS5A86dhF8NawRIMm1hDL8MUInR62xUR7zN0M4BBg8LrOHjVDl4jx2YCFKeKy1CY
         drBnR6E1DQqksfuvfOf+3+O2mfnTX0zlhAsnvDp0jAqX1MuiVoYQ6nzRiC3yPJGz32VV
         lefw==
X-Gm-Message-State: AOJu0YwNxmpPFrkY63f4fgEhRVctLuAXlhUf02ZcqBrjrF6bWMnRdoo/
	l/WN1ZUjvqj2K0zNTIWDE7KyHykTzwPv6+IC+u5CDnrgihMgPPjIt+2eGilF1SmcAgmxSWIOB0J
	XqD0=
X-Gm-Gg: ASbGncuJhlokkV/k7fQ/g+9BLZx2XDAGRfdOCyQwHHYWa5JTsaGGlZQZXtPpcQEqiVh
	sZZNDQufVO4pUpe/15MDrWVG4dUYYJxxJfNCKDWA/Jg8HD/eVuRSWPYCThj7RwoDOsndWgDRVQs
	AhcS/hcEWvVIKkPTv8G4RIY0kSIL/FG6aQRp3ID5pWGOml+a3j1bMULLPlwb6omSaQLOq+vpXSe
	n0hc+9borRE4LrjwSr0qYWAdmmE2koYV+NZ8I9KCgHzhrZTVkokhupvI2MjOLqonzHFN28XkhP2
	fA/37qkwk+X9pfOKDclNQdmgV5cTokrZJXvzK3mNaIQO
X-Google-Smtp-Source: AGHT+IFqH2Zr9JEEGPEmYHLjUEgkJ2VJ9nEE0EePczHqkDDUA7X5Dv3rKS4KczQoT4b7JZUuZg3HsQ==
X-Received: by 2002:a5d:588d:0:b0:391:4f9:a047 with SMTP id ffacd0b85a97d-39104f9a660mr276312f8f.17.1740890354593;
        Sat, 01 Mar 2025 20:39:14 -0800 (PST)
Received: from MacBookPro.lan ([23.247.139.15])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7c36ff0f386sm449631585a.60.2025.03.01.20.39.09
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 01 Mar 2025 20:39:13 -0800 (PST)
From: Su Yue <glass.su@suse.com>
To: linux-raid@vger.kernel.org
Cc: hch@lst.de,
	ofir.gal@volumez.com,
	heming.zhao@suse.com,
	yukuai3@huawei.com,
	l@damenly.org,
	Su Yue <glass.su@suse.com>
Subject: [PATCH v2] md/md-bitmap: fix wrong bitmap_limit for clustermd when write sb
Date: Sun,  2 Mar 2025 12:39:05 +0800
Message-Id: <20250302043905.95887-1-glass.su@suse.com>
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

Here use (pg_index % bitmap->storage.file_pages) to calculation of
bitmap_limit correct.

Fixes: ab99a87542f1 ("md/md-bitmap: fix writing non bitmap pages")
Signed-off-by: Su Yue <glass.su@suse.com>
---
 drivers/md/md-bitmap.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index 23c09d22fcdb..9ae6cc8e30cb 100644
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
-- 
2.47.1

