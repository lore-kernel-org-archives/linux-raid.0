Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 446D01F16B;
	Thu, 22 Aug 2024 02:52:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724295129; cv=none; b=XlZCO8klLrI/gKxRzlStheBzl1I0ZcYS1lofgwsA9aFI596aFORZKdC1AYo2bf2Co4O7CQLGYHZw6+sdNH7BdKRJ7/byCZJNRO9j4JS5cdPm+PtUtcPwSenaS5tMuuwg8yP4xbi9v/lJ4noN3LfGEH8X6dP9OuPOTCZ3tgHu/58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724295129; c=relaxed/simple;
	bh=aMg0D1L2FDO5tJBJElv5MZ6uxUbRC8lz3qHploltyDI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=snOI+9INaYSO2uBnsxRbkrVFNoV8kvFJV+Bx73++Rarm5otx6UYG+YTCosKh8I10cGHyWxPUJXUpVhHJMcT40Q2wbL7E5jGQP0dV52jKgTRfz4P+vPX/qg89lkpmrKuHoOh157QEp6GDF6LTXIO8VuyjoDkZgevSWBg+DCZUCco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4Wq75P6yTbz4f3kp7;
	Thu, 22 Aug 2024 10:51:53 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id A71BA1A13E9;
	Thu, 22 Aug 2024 10:52:03 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgAXPoTNp8ZmyXl2CQ--.42363S12;
	Thu, 22 Aug 2024 10:52:03 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: song@kernel.org,
	mariusz.tkaczyk@linux.intel.com,
	l@damenly.org,
	xni@redhat.com
Cc: linux-kernel@vger.kernel.org,
	linux-raid@vger.kernel.org,
	yukuai3@huawei.com,
	yukuai1@huaweicloud.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com
Subject: [PATCH md-6.12 08/41] md/md-cluster: use helper md_bitmap_get_stats() to get pages in resize_bitmaps()
Date: Thu, 22 Aug 2024 10:46:45 +0800
Message-Id: <20240822024718.2158259-9-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240822024718.2158259-1-yukuai1@huaweicloud.com>
References: <20240822024718.2158259-1-yukuai1@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgAXPoTNp8ZmyXl2CQ--.42363S12
X-Coremail-Antispam: 1UD129KBjvJXoW7ZF4fGr18tryrXr1xWF1UGFg_yoW8ur1fpF
	47KayakrWrXrW3XwsrWrykCFyaqw1ktrZrtryfG34fGFnrtFnIgF4rGFyUtr4UCFy5JFn0
	qws8Kr4UurW8XaUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUm214x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
	kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
	z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Cr1j6r
	xdM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s0D
	M2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjx
	v20xvE14v26r106r15McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1l
	F7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7M4IIrI8v6xkF7I0E8cxan2
	IY04v7MxkF7I0En4kS14v26r1q6r43MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY
	6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17
	CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1I6r4UMIIF
	0xvE2Ix0cI8IcVCY1x0267AKxVWxJVW8Jr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMI
	IF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVF
	xhVjvjDU0xZFpf9x0JUWMKtUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

Use the existed helper instead of open coding it, avoid dereferencing
bitmap directly to prepare inventing a new bitmap.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/md-cluster.c | 20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
index e3faf752f0b1..76febdc5d7f6 100644
--- a/drivers/md/md-cluster.c
+++ b/drivers/md/md-cluster.c
@@ -1143,13 +1143,16 @@ static int update_bitmap_size(struct mddev *mddev, sector_t size)
 
 static int resize_bitmaps(struct mddev *mddev, sector_t newsize, sector_t oldsize)
 {
-	struct bitmap_counts *counts;
-	char str[64];
-	struct dlm_lock_resource *bm_lockres;
 	struct bitmap *bitmap = mddev->bitmap;
-	unsigned long my_pages = bitmap->counts.pages;
+	struct md_bitmap_stats stats;
+	unsigned long my_pages;
 	int i, rv;
 
+	rv = md_bitmap_get_stats(bitmap, &stats);
+	if (rv)
+		return rv;
+
+	my_pages = stats.pages;
 	/*
 	 * We need to ensure all the nodes can grow to a larger
 	 * bitmap size before make the reshaping.
@@ -1159,6 +1162,10 @@ static int resize_bitmaps(struct mddev *mddev, sector_t newsize, sector_t oldsiz
 		return rv;
 
 	for (i = 0; i < mddev->bitmap_info.nodes; i++) {
+		struct dlm_lock_resource *bm_lockres;
+		struct bitmap_counts *counts;
+		char str[64];
+
 		if (i == md_cluster_ops->slot_number(mddev))
 			continue;
 
@@ -1170,6 +1177,9 @@ static int resize_bitmaps(struct mddev *mddev, sector_t newsize, sector_t oldsiz
 		}
 		counts = &bitmap->counts;
 
+		rv = md_bitmap_get_stats(bitmap, &stats);
+		if (rv)
+			goto out;
 		/*
 		 * If we can hold the bitmap lock of one node then
 		 * the slot is not occupied, update the pages.
@@ -1186,7 +1196,7 @@ static int resize_bitmaps(struct mddev *mddev, sector_t newsize, sector_t oldsiz
 			counts->pages = my_pages;
 		lockres_free(bm_lockres);
 
-		if (my_pages != counts->pages)
+		if (my_pages != stats.pages)
 			/*
 			 * Let's revert the bitmap size if one node
 			 * can't resize bitmap
-- 
2.39.2

