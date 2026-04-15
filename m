Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E29638AC7D
	for <linux-raid@vger.kernel.org>; Wed, 15 Apr 2026 08:19:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776241191; cv=none; b=HY2mk40t5Xoj/ieOl3sW2GlUjweSkvemI4qYU4TBdX64s0Z6JS4M5tZE7ueMLel8252kMNr3ee5V70TbRzIWhU3XYDOoAfB36Vcllk62kxWZb3MsDEmW2DBR+qUsoI4V7MeA9lHSeXpBN4aT0n6Uz8bCqBJxhiEB9CPv7l1mhmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776241191; c=relaxed/simple;
	bh=Fq2f3/OMKRW3fa1CVNaKIXzmF6VaI+1ROG0ymydBWxQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=plUic5iTe/tEWHNn1vG7/bz6/QGLKpH0vMxCv3iASs0yRqHRu9GZRj8BEUFOuLk1D3sMq5eUGv0e2FsgRw7lRR+SwrmdlgFUlrgBd6N48Ihk237YFspbcLAmkB1LUiRK8dXWBxW3KbT3XJkhT0A1cetxTcED7sgcNTBbT3pcZkI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WKjICHM8; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WKjICHM8"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-488af9fdaa7so44914495e9.1
        for <linux-raid@vger.kernel.org>; Wed, 15 Apr 2026 01:19:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776241185; x=1776845985; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=r5koYR+L4gIxQU644ql2ZqxdNKr3UkK315nrBFfTHmY=;
        b=WKjICHM8v123uJHbN7pE2TFdFwjUyrcBieL3Vi9eqe3ShxhcfZ/eOyszMjA7fRuAf8
         b6du+LS8nJJRbLTgQ87mI6pJUflBS0Sopu7+vwuo/BOL+HM5B+LFE3ZRgFItXhASmyrT
         IJLefPTbEs7NDTiEMz11/ap1OsZTSU7aQULEOrpW+m4PK7WmmcmUl2veYdDYe+nVPsvM
         V5l5jRg+p9ust1JeApbQLU+oL0PrLKvNb2FisXIj12QksQrBxZZpInKx7Py775ODD8/R
         BXvVUtrRwHnbO+ukApKti2pe9P8vgRlyejbWoZ4kpb7CSXgBDACT10sbZgJ0UiWQ/d/h
         oWAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776241185; x=1776845985;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=r5koYR+L4gIxQU644ql2ZqxdNKr3UkK315nrBFfTHmY=;
        b=LIf49U5V4VY/Rywhx0ZGiJ9ieGBsl0GEl3UiVXA6NG2FX1FrGjZB3A5sd9O17VYF6H
         kWmy1ybJUFEk2oStzqzLt5KSxC8QTzyxCBfT/UmgDJvO+zQVY1qN1PG7NO6sqHfQ8mUr
         5GVZ9w395s+HI93eVJ9gqC8fEBquhqYABqDIzgiRloU9ekifBAom+dVeRAINuIv/uTni
         yijDxjaWjiGv8Xe/nXuoETfsw/mFDlrdg+Xbt1U1s5D5J6xRjHvyyOs5FUWK4XVoyqvq
         mq4r2qhVP6cIgOiRYNtTbYH1I4WhZUuZXWQh5HntrO/QCjc5K/SXaOQOX8WyI9/bkKy9
         jG8g==
X-Gm-Message-State: AOJu0YxWfmZVeR8nxjYRNeUx9DBiaygrVTJzfItAYYge0pnwCdeTt4NZ
	31nJS+26NkALQaazGc+I4uZR3AJQUcHe0W+QAqfGdd0OcwxgYFzcHp/i
X-Gm-Gg: AeBDietK24gGk9r6orfXiXJ9lxg5LguubRSLp+ys5MYIYw56uAX9apFAWv0wNXBn7Yp
	1NDH1J09pjsBhDcZTF/RXs0HjsqdA1MIy5toVVW95wf0zdG0KwiDdq8Z4k73OT+/GMUYyZR1kdZ
	dStu8eKuZzgRmuYr7ThDXR3zBE11pfnPb78juI7nDjiFBPIdCT8yKvft8+QQlkvHfSxG3bXTJQ+
	AtTeCo/0TF3urIIzrKEegWokQ1KDexQefApxR6JRqZ1NwU0d/W5XV9+U6beIwgcv1H4iNbtDKgP
	tnRptCnxeepF0kIbt4bs4OOXnslNcKSRHGWkVPU+jac895qWbnYbW/5EPL/w0qEQJyf8ujeO8TU
	bKPY7bkknuc4qcHV4Ab7fe0J5+5e+Nkoj3LKa9i22SBd43yZryFSNJptLUY4TAtR5UJTldcJagy
	GosvPT1uRzF/7m/FHMuDeB18ybbKQU18ylVQ==
X-Received: by 2002:a05:600c:8591:b0:488:a824:fe04 with SMTP id 5b1f17b1804b1-488d6abe9e4mr206324965e9.26.1776241185169;
        Wed, 15 Apr 2026 01:19:45 -0700 (PDT)
Received: from yocto.. ([2a02:3037:600:3ec1:f5c2:c50d:98e3:e280])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43ead33d665sm3151299f8f.7.2026.04.15.01.19.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Apr 2026 01:19:44 -0700 (PDT)
From: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
To: song@kernel.org,
	yukuai@fnnas.com,
	linan666@huaweicloud.com
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
Subject: [PATCH v2] md: use md_free_cloned_bio() in md_end_clone_io()
Date: Wed, 15 Apr 2026 10:19:41 +0200
Message-ID: <20260415081941.352389-1-abd.masalkhi@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

md_end_clone_io() and md_free_cloned_bio() share identical teardown
logic. Use md_free_cloned_bio() in md_end_clone_io() for cleanup and
call bio_endio() afterwards.

Signed-off-by: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
---
Changes in v2:
 - Reuse md_free_cloned_bio() instead of introducing a new helper
 - Link to v1: https://lore.kernel.org/linux-raid/20260414103813.307601-1-abd.masalkhi@gmail.com
---
 drivers/md/md.c | 13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index ac71640ff3a8..8565566a447b 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -9212,20 +9212,9 @@ static void md_end_clone_io(struct bio *bio)
 {
 	struct md_io_clone *md_io_clone = bio->bi_private;
 	struct bio *orig_bio = md_io_clone->orig_bio;
-	struct mddev *mddev = md_io_clone->mddev;
-
-	if (bio_data_dir(orig_bio) == WRITE && md_bitmap_enabled(mddev, false))
-		md_bitmap_end(mddev, md_io_clone);
-
-	if (bio->bi_status && !orig_bio->bi_status)
-		orig_bio->bi_status = bio->bi_status;
-
-	if (md_io_clone->start_time)
-		bio_end_io_acct(orig_bio, md_io_clone->start_time);
 
-	bio_put(bio);
+	md_free_cloned_bio(bio);
 	bio_endio(orig_bio);
-	percpu_ref_put(&mddev->active_io);
 }
 
 static void md_clone_bio(struct mddev *mddev, struct bio **bio)
-- 
2.43.0

