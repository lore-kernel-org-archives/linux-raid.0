Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5A6013D882;
	Mon, 26 Aug 2024 07:49:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724658597; cv=none; b=HfTznBmnwXBslA+7SNjKNWEQd1voa9G0wlQ84MS/cSURHHMYl2XclLASOf921rdWzini17hMVpq9uA87qvPCGWtiJp4QHxMhyyxipMr1frfTTkWKV/Gtc5ePZg4RZW/dy9Aoblq+uZgJ9F8YitWM46iZwVACK+ebJ4TOylcmwrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724658597; c=relaxed/simple;
	bh=EKzlmTSStPG6axYh86HcupDRLZY1aFaE6jbc7t2+/TQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=jmxx+BaKzLh9lUXiHj5FDcqG3ka6dFsacri8ydPkvEv7UKRxKX8EPq50s3iHejowbNzSeAh/rYc6lE4/zYQtl5Q3vjDmt5fhsuvh/u1mopUAd34KXQBlswYfrd+strBqqRVmNWNFKqDgDHBU2oWNuuCsow8dEq6DTLna7WUwK5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4WsjW61g5Zz4f3jMW;
	Mon, 26 Aug 2024 15:49:38 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id AA3171A06D7;
	Mon, 26 Aug 2024 15:49:52 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgAHL4WaM8xmWWIECw--.13849S14;
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
Subject: [PATCH md-6.12 v2 10/42] md/md-bitmap: add a new helper md_bitmap_set_pages()
Date: Mon, 26 Aug 2024 15:44:20 +0800
Message-Id: <20240826074452.1490072-11-yukuai1@huaweicloud.com>
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
X-CM-TRANSID:gCh0CgAHL4WaM8xmWWIECw--.13849S14
X-Coremail-Antispam: 1UD129KBjvJXoWxJw48tF45tr4xtw1rAw48tFb_yoW5WrykpF
	Wjq343Cw45XrW3X3W7XrykCFy5tw1ktrZrtryfC395uFy2qF9xKF48Ga4jyw17GF13JFsI
	q3W5Gr15ur18XrJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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
	Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVW8JVW5JwCI42IY6xIIjxv20xvEc7CjxVAFwI0_
	Cr0_Gr1UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVW8JVWxJw
	CI42IY6I8E87Iv6xkF7I0E14v26r4UJVWxJrUvcSsGvfC2KfnxnUUI43ZEXa7VUbPC7UUU
	UUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

Currently md-cluster will set bitmap->counts.pages directly, add a
helper to do this to avoid dereferencing bitmap directly.

Noted that after this patch bitmap is not dereferenced directly anymore
and following patches will move the structure inside md-bitmap.c.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/md-bitmap.c  | 6 ++++++
 drivers/md/md-bitmap.h  | 1 +
 drivers/md/md-cluster.c | 4 +---
 3 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index 918510f36e33..015997b4b835 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -2094,6 +2094,12 @@ int md_bitmap_copy_from_slot(struct mddev *mddev, int slot,
 }
 EXPORT_SYMBOL_GPL(md_bitmap_copy_from_slot);
 
+void md_bitmap_set_pages(struct bitmap *bitmap, unsigned long pages)
+{
+	bitmap->counts.pages = pages;
+}
+EXPORT_SYMBOL_GPL(md_bitmap_set_pages);
+
 int md_bitmap_get_stats(struct bitmap *bitmap, struct md_bitmap_stats *stats)
 {
 	struct bitmap_storage *storage;
diff --git a/drivers/md/md-bitmap.h b/drivers/md/md-bitmap.h
index 909a661383c6..c4d64311c0e8 100644
--- a/drivers/md/md-bitmap.h
+++ b/drivers/md/md-bitmap.h
@@ -285,6 +285,7 @@ int md_bitmap_resize(struct bitmap *bitmap, sector_t blocks,
 struct bitmap *get_bitmap_from_slot(struct mddev *mddev, int slot);
 int md_bitmap_copy_from_slot(struct mddev *mddev, int slot,
 			     sector_t *lo, sector_t *hi, bool clear_bits);
+void md_bitmap_set_pages(struct bitmap *bitmap, unsigned long pages);
 void md_bitmap_free(struct bitmap *bitmap);
 void md_bitmap_wait_behind_writes(struct mddev *mddev);
 
diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
index 76febdc5d7f6..59f7fbca783b 100644
--- a/drivers/md/md-cluster.c
+++ b/drivers/md/md-cluster.c
@@ -1163,7 +1163,6 @@ static int resize_bitmaps(struct mddev *mddev, sector_t newsize, sector_t oldsiz
 
 	for (i = 0; i < mddev->bitmap_info.nodes; i++) {
 		struct dlm_lock_resource *bm_lockres;
-		struct bitmap_counts *counts;
 		char str[64];
 
 		if (i == md_cluster_ops->slot_number(mddev))
@@ -1175,7 +1174,6 @@ static int resize_bitmaps(struct mddev *mddev, sector_t newsize, sector_t oldsiz
 			bitmap = NULL;
 			goto out;
 		}
-		counts = &bitmap->counts;
 
 		rv = md_bitmap_get_stats(bitmap, &stats);
 		if (rv)
@@ -1193,7 +1191,7 @@ static int resize_bitmaps(struct mddev *mddev, sector_t newsize, sector_t oldsiz
 		bm_lockres->flags |= DLM_LKF_NOQUEUE;
 		rv = dlm_lock_sync(bm_lockres, DLM_LOCK_PW);
 		if (!rv)
-			counts->pages = my_pages;
+			md_bitmap_set_pages(bitmap, my_pages);
 		lockres_free(bm_lockres);
 
 		if (my_pages != stats.pages)
-- 
2.39.2

