Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BBCD156237
	for <linux-raid@vger.kernel.org>; Mon,  3 Mar 2025 03:39:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740973170; cv=none; b=D3613ZWTjZdYBBZFDXzr+KUV0X7hRWOEFT5X6dfDQ2/8NqtHhKjLq5cvoedFdzygvM6i99cbfO1Cjdzf6weJBlqAj5KLmGTO+ABnyB+ZWeOZMj7M2j/PANbhYzCLAh0bPdRVzXEhwHsftm8tLoYUAWdfs5XnLkRYarZrjf1UGoA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740973170; c=relaxed/simple;
	bh=BHWeGhjKPpVTdy9nZo2WztSVqj4lDN2g/U9VfOGm1Y4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=HtleollzYaJVRJjL/BujkpNj4oBN+RAAA6S+RzCxK8jICfeICzCk3HkUr3CQzgGP/4nwJRjP5t/EpSCcekPwmZBzjuJcCCdrb5l3uxrJMqnrRVJaXLp2thakHffX/wOWwLe5aYFnChNxsPOcr53Uomynz3+91SnKwX4AuR2plBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Fwk7b2Vz; arc=none smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Fwk7b2Vz"
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-5e50de0b5easo2223582a12.3
        for <linux-raid@vger.kernel.org>; Sun, 02 Mar 2025 19:39:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1740973166; x=1741577966; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=fdat9ZIOeg2C7juag4L/fQ2dOjVQgZZzsF6UQtUat+o=;
        b=Fwk7b2VzjOzD5jfXOgHusXrM5mdWC3ONUpxEJz7RjgnfkSa5EO7KHGiKggfcjVwNEz
         ol4JP0JJgvHrzxbsdoSHQBvdWEVeTW5NG+PzM3oIubxkamdG07VBVVdYJyg42ZqhtGK8
         1iyajiaaFRiy/HnLf+mtE+ZienTfWizowtWhlJOkEBr/n1GGpm+5vzzOQUJgBSb5+2k8
         sghBoQ0O8j0EET7kd+SnY/seCuesMqSm7K71YQcZxOxaKN18IskCv4C7e2/XGkjsKi7P
         jDXXeb6mlt1BkUw17kaM4s8qMsFQxtzh+aZjLGSGARoZVpGtAJwfoZqDtuAAHl3h1O9R
         eOig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740973166; x=1741577966;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fdat9ZIOeg2C7juag4L/fQ2dOjVQgZZzsF6UQtUat+o=;
        b=jrBOfeOpoJDTmPydPTGyY1gWhEByIZSQELSJOBMAAZyRANyUXS1/yf/DNzyftA4FaZ
         1UdKlu6GZ/gG6IDi9CiIXHlLGinx5/nORFRQIUcNORqTiGjvjEau+KpgFlZr7S1i0AkQ
         UuUBUHhZt6D1oEgtiq7Wx14knA7jEak30DqURJnaeX+xnt3JKNygjLGbjWDhvw+rw4x0
         V+Es0WCVYDWR0EklyuVAJVLDtAhEHUypo0G0tgC3vEaxc2C7R3wvZMBtTEzomf+doa81
         fI7aMqFiUqxN29zw3mPqqL49UIQf9pqR+fTsPQywYipODGkaUf5/syRU9IV/pJi+hm1w
         uWPQ==
X-Gm-Message-State: AOJu0YwNSGgPw6k+AuzlU7xcJL6cDhyip8AdugJ9NeTZ6wgPRxO+mjJ5
	GR9S+87pRaNhltG8PUNLSg97w5T3Axf6/01m3v7RU/q91/fwaqyrUR4u5Kbg3y155MH7MGdYXWP
	+UMlG7vGk
X-Gm-Gg: ASbGncupYZxNQjoHlNleRDgOVU6eR02Na5lDHnktNgFF7s+iCC38uoh9V060X2dYNy+
	8DemaDIyKnvacVY+G+y1BUnYw2D968xTNjhvhpuRCjGiGNsontoTCrl8RauN7EXriq5PYWYpI58
	ZjqQVfoYibhmL5DxAdwGAeSFrQ8TYgcqzP1dHN4lLzHGWgwwz7tjmu2Qytkct+z/YqCQBjgVuOv
	I2OVg1ARgAOFID/NnPohJo8evuuXfTJ+U+c9ll/jt9rN+vRBciDoWQqL4W4LJR68rfMat/R6yo1
	1uB1tm4v+yJlNRDyrI8LBZ239I8X80nTFFAU0rjehL6WXQ==
X-Google-Smtp-Source: AGHT+IFu+0kU9j0czD240kvcrWeVjrJ+AVZrencqaeTdzSxXRKTt48w+vJRo11qxGtiLaVHazFxFHA==
X-Received: by 2002:a05:6402:35cf:b0:5d4:1ac2:277f with SMTP id 4fb4d7f45d1cf-5e4d6ae82camr11055653a12.9.1740973166076;
        Sun, 02 Mar 2025 19:39:26 -0800 (PST)
Received: from MacBookPro.lan ([195.245.241.170])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7365b66255asm421357b3a.165.2025.03.02.19.39.23
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 02 Mar 2025 19:39:25 -0800 (PST)
From: Su Yue <glass.su@suse.com>
To: linux-raid@vger.kernel.org
Cc: hch@lst.de,
	ofir.gal@volumez.com,
	heming.zhao@suse.com,
	yukuai3@huawei.com,
	l@damenly.org,
	Su Yue <glass.su@suse.com>
Subject: [PATCH v3] md/md-bitmap: fix wrong bitmap_limit for clustermd when write sb
Date: Mon,  3 Mar 2025 11:39:18 +0800
Message-Id: <20250303033918.32136-1-glass.su@suse.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In clustermd, separate write-intent-bitmaps are used for each cluster
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
That means the first 4k sb area of node 1 will never be updated
through filemap_write_page().
This bug causes hang of mdadm/clustermd_tests/01r1_Grow_resize.

Here use (pg_index % bitmap->storage.file_pages) to make calculation
of bitmap_limit correct.

Fixes: ab99a87542f1 ("md/md-bitmap: fix writing non bitmap pages")
Signed-off-by: Su Yue <glass.su@suse.com>
---
Changelog:
v3:
    Amend commit message suggested by Heming.
v2:
    Remove unintended change calling md_super_write().
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

