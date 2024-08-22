Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B8261F959;
	Thu, 22 Aug 2024 02:52:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724295129; cv=none; b=KAaegIAAgoRr0CtTd+5gZ4PA0Lu0MPggVIe4CZlUoIoT4pRKwLur5MuDuk12wZnC2Vo6MoWmKIVPrsj3WIsUTrDdRdZgZFsXxFOXfhMVXrps0wRpl3uvqLKh+/uENVLRelq/Pqk/dxnRSw3nAZuKUbi1a+0zxzz/t68sKJuKMrc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724295129; c=relaxed/simple;
	bh=xh1yTjqQYBmcvevqJdKksQTiVxAc+U6Urx5aYW6z7hw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=PyOq4++u6Jal2dOhjGiOCsa0cyMYxqlQO9MIJI6jq4u0FJKAkzbdALO7Mfg/Hs72H9UReoER4uOUNbOJHt6uSqKn8J+wVHlfLASfGI+iS+60IVYRLqDWsCnw6H5t9GAtiWlxV3ZUZKzi0YsKemgHQAb+PIzDiwRmaTxsaForGWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4Wq75Q3393z4f3kp9;
	Thu, 22 Aug 2024 10:51:54 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 204BE1A0359;
	Thu, 22 Aug 2024 10:52:04 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgAXPoTNp8ZmyXl2CQ--.42363S13;
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
Subject: [PATCH md-6.12 09/41] md/md-bitmap: add a new helper md_bitmap_set_pages()
Date: Thu, 22 Aug 2024 10:46:46 +0800
Message-Id: <20240822024718.2158259-10-yukuai1@huaweicloud.com>
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
X-CM-TRANSID:gCh0CgAXPoTNp8ZmyXl2CQ--.42363S13
X-Coremail-Antispam: 1UD129KBjvJXoWxJw48tF45tr4xtw1rAr4xJFb_yoW5WrykpF
	Wjq343Cw45XrW3X3W7XrykCFy5tw1ktrZrtryfC3s5uFy2qF9xKF48Ga4jyw17GF13JFsI
	q3W5Gr1Uur18XrJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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
index ab349182e646..61132c82add7 100644
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

