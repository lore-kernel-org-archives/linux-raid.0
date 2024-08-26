Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 300D413C695;
	Mon, 26 Aug 2024 07:49:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724658597; cv=none; b=bXFhaslBfLNBGnTrUhlSb1jB6KAep/pV5a+dexpjVPn+XYSNooleSYHQt9Rdase7nEkowbUswjCsZCxBX+BIquxcf/MaTtSbMWui+cNdj7nPmhwHA2LzT/K3v7UYXq/jBb9LKPlUMvCwI06J6MD2ZfLGdvBdHra+igABeR5UyRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724658597; c=relaxed/simple;
	bh=aMg0D1L2FDO5tJBJElv5MZ6uxUbRC8lz3qHploltyDI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ZKn6jYGzmhoI1vfIg/cUaz1VV3cMyGrv4j8hKHSc6cz0S5+MJC0wEv0RHA3yDJ/+IMLxmFLFNUAx0MPjzUv+Fg3z4AkH6mAuuBOl2VxpzrS2v2DXuEXr7s8Ul/XVDA8AnkJDhDeTc7V/DJTJ/BEVfKGKUI/ue+DO81ww9b9JSaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4WsjW46RLjz4f3lDF;
	Mon, 26 Aug 2024 15:49:36 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 445851A1752;
	Mon, 26 Aug 2024 15:49:52 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgAHL4WaM8xmWWIECw--.13849S13;
	Mon, 26 Aug 2024 15:49:52 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: mariusz.tkaczyk@linux.intel.com,
	xni@redhat.com,
	song@kernel.org
Cc: linux-kernel@vger.kernel.org,
	linux-raid@vger.kernel.org,
	yukuai3@huawei.com,
	yukuai1@huaweicloud.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com
Subject: [PATCH md-6.12 v2 09/42] md/md-cluster: use helper md_bitmap_get_stats() to get pages in resize_bitmaps()
Date: Mon, 26 Aug 2024 15:44:19 +0800
Message-Id: <20240826074452.1490072-10-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240826074452.1490072-1-yukuai1@huaweicloud.com>
References: <20240826074452.1490072-1-yukuai1@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgAHL4WaM8xmWWIECw--.13849S13
X-Coremail-Antispam: 1UD129KBjvJXoW7ZF4fGr18tryrXr1xWF1UGFg_yoW8ur1fpF
	47KayakrWrXrW3XwsrWrykCFyaqw1ktrZrtryfG34fGFnrtFnIgF4rGFyUtr4UCFy5JFn0
	qws8Kr4UurW8XaUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUP014x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
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
	Cr0_Gr1UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVW8JVWxJw
	CI42IY6I8E87Iv6xkF7I0E14v26r4UJVWxJrUvcSsGvfC2KfnxnUUI43ZEXa7VUbPC7UUU
	UUU==
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

