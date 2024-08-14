Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3362313C9C4;
	Wed, 14 Aug 2024 07:15:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723619734; cv=none; b=gmtEifWlCgWkMg3dFfX2mmRgsWJs381xvzynOiKy071Rmz+3q/3xJtutYPRi9y4VBVVI6w+UJuITCy1HKHvMSdM9YYl4I7D8bG3GBCnLyDDSPHsDBuoGhyM8ggGRlMwDQP41MHZ1XPEz6TkgL0Pf3ySryZQO4TUSJIubhP4MSlc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723619734; c=relaxed/simple;
	bh=48wrPcLj8soZOL4rHDXFr9wW7/PWVZSBAeoj7HllNX4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=S2qmrlOIzp5iFavKkGKpg6RFVsSHy28RwTqq01IutW+fex1UV+PFwjQGBgecNySGKqVzfuyKIC13KWDxkV7kpfrVBQSciQAyYklOwb0ssfXtrJjQsMBmM2JnafJQKK8IsUpi95hxUahq2IhlORnsH+QPoeCQIFuL13juwUPb4O0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4WkKK36STbz4f3jZL;
	Wed, 14 Aug 2024 15:15:19 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 3CC9B1A0359;
	Wed, 14 Aug 2024 15:15:29 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgBHboSLWbxmIxKbBg--.47745S12;
	Wed, 14 Aug 2024 15:15:29 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: mariusz.tkaczyk@linux.intel.com,
	hch@infradead.org,
	song@kernel.org
Cc: linux-kernel@vger.kernel.org,
	linux-raid@vger.kernel.org,
	yukuai3@huawei.com,
	yukuai1@huaweicloud.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com
Subject: [PATCH RFC -next v2 08/41] md/md-cluster: use helper md_bitmap_get_stats() to get pages in resize_bitmaps()
Date: Wed, 14 Aug 2024 15:10:40 +0800
Message-Id: <20240814071113.346781-9-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240814071113.346781-1-yukuai1@huaweicloud.com>
References: <20240814071113.346781-1-yukuai1@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgBHboSLWbxmIxKbBg--.47745S12
X-Coremail-Antispam: 1UD129KBjvJXoW7ZF43tF4UuFy5Zr1rXrWxtFb_yoW8AF1xpF
	47Kayakw4SqrW3XwsFgrykCFyYqw1kKrZrtryfG34fGFnrtFnIgF4rGFyUtw1UCFy5XFn0
	qws8Kr45urZ5XaUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUPj14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
	kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
	z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F
	4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq
	3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7
	IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4U
	M4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCY1x0262kKe7AKxVWUtV
	W8ZwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v2
	6r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2
	Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUCVW8JwCI42IY6xIIjxv20xvEc7CjxVAFwI0_
	Cr0_Gr1UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8Jw
	CI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjfUOyIUUUUU
	U
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

Use the existed helper instead of open coding it, avoid dereferencing
bitmap directly to prepare inventing a new bitmap.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/md-cluster.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
index 9d87c215f094..e4ad8efdc63b 100644
--- a/drivers/md/md-cluster.c
+++ b/drivers/md/md-cluster.c
@@ -1144,12 +1144,18 @@ static int update_bitmap_size(struct mddev *mddev, sector_t size)
 static int resize_bitmaps(struct mddev *mddev, sector_t newsize, sector_t oldsize)
 {
 	struct bitmap_counts *counts;
-	char str[64];
 	struct dlm_lock_resource *bm_lockres;
 	struct bitmap *bitmap = mddev->bitmap;
-	unsigned long my_pages = bitmap->counts.pages;
+	struct md_bitmap_stats stats;
+	unsigned long my_pages;
+	char str[64];
 	int i, rv;
 
+	rv = md_bitmap_get_stats(bitmap, &stats);
+	if (rv)
+		return rv;
+
+	my_pages = stats.pages;
 	/*
 	 * We need to ensure all the nodes can grow to a larger
 	 * bitmap size before make the reshaping.
@@ -1170,6 +1176,9 @@ static int resize_bitmaps(struct mddev *mddev, sector_t newsize, sector_t oldsiz
 		}
 		counts = &bitmap->counts;
 
+		rv = md_bitmap_get_stats(bitmap, &stats);
+		if (rv)
+			goto out;
 		/*
 		 * If we can hold the bitmap lock of one node then
 		 * the slot is not occupied, update the pages.
@@ -1186,7 +1195,7 @@ static int resize_bitmaps(struct mddev *mddev, sector_t newsize, sector_t oldsiz
 			counts->pages = my_pages;
 		lockres_free(bm_lockres);
 
-		if (my_pages != counts->pages)
+		if (my_pages != stats.pages)
 			/*
 			 * Let's revert the bitmap size if one node
 			 * can't resize bitmap
-- 
2.39.2

