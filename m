Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEA4342A8B;
	Sat, 10 Aug 2024 02:12:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723255979; cv=none; b=Y6nKA3GS8MOvmzXTBGpsRWdj2XlOj15QJXEfVqFy7xwXXsxGF1gGag4G9vjc/871TBvnmwDTBaWFDsX2fb/zR1Slb/dxrhfzEpydfIWm9Q2DOPjw7UqAFI4IAbrxgnQZkiuHoDFf9bY9W+I3GzhaTvumM9sIT2qArlKZkc+brN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723255979; c=relaxed/simple;
	bh=ooiZMn8kzVM9qRH0lDITvlMgCw+H3sH/aBSPrBbzu7w=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=dWO924NfXfTYB2U6TTMiEcE7XYy+eEyaMBSZ915tNZBxH35v0EnzknYs5cFG/A5ukRKTYHuHpyv00wOqBB3b2wN6BMBPwRJsvByHGAeT8z3iS0u258kKguYzEv03gyC+rBesq+HEu9S3gq2tqDe+hI/jeGZBJDSpzdybDZZevb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4Wgknm33jLz4f3jk7;
	Sat, 10 Aug 2024 10:12:44 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 8DBFD1A1382;
	Sat, 10 Aug 2024 10:12:53 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgAHL4WizLZmErwLBQ--.1937S7;
	Sat, 10 Aug 2024 10:12:53 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: song@kernel.org
Cc: linux-kernel@vger.kernel.org,
	linux-raid@vger.kernel.org,
	yukuai3@huawei.com,
	yukuai1@huaweicloud.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com
Subject: [PATCH RFC -next 03/26] md/md-bitmap: merge md_bitmap_load() into bitmap_operations
Date: Sat, 10 Aug 2024 10:08:31 +0800
Message-Id: <20240810020854.797814-4-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240810020854.797814-1-yukuai1@huaweicloud.com>
References: <20240810020854.797814-1-yukuai1@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgAHL4WizLZmErwLBQ--.1937S7
X-Coremail-Antispam: 1UD129KBjvJXoW7Kr4rtr1DXF47GrW7uryxGrg_yoW8KF15pF
	sFqa45Cr43JrWagr1UuFWkua4Yqr1vqr9rtrWxGw1S9F9xXFnxGF4rWF42yw1rGa43JFsx
	Xw15KFyrCr1xXr7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUBl14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JrWl82xGYIkIc2
	x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0
	Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Cr0_Gr1UM2
	8EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s0DM2AI
	xVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20x
	vE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xv
	r2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7MxkF7I0En4kS14v26r126r1DMx
	AIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_
	Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUAVWUtwCIc40Y0x0EwI
	xGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWx
	JwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcV
	C2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7VUbTUDJUUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

So that the implementation won't be exposed, and it'll be possible
to invent a new bitmap by replacing bitmap_operations.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/md-bitmap.c |  6 +++---
 drivers/md/md-bitmap.h | 10 +++++++++-
 2 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index d731f7d4bbbb..9a9f0fe3ebd0 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -1965,7 +1965,7 @@ static struct bitmap *bitmap_create(struct mddev *mddev, int slot)
 	return ERR_PTR(err);
 }
 
-int md_bitmap_load(struct mddev *mddev)
+static int bitmap_load(struct mddev *mddev)
 {
 	int err = 0;
 	sector_t start = 0;
@@ -2021,7 +2021,6 @@ int md_bitmap_load(struct mddev *mddev)
 out:
 	return err;
 }
-EXPORT_SYMBOL_GPL(md_bitmap_load);
 
 /* caller need to free returned bitmap with md_bitmap_free() */
 struct bitmap *get_bitmap_from_slot(struct mddev *mddev, int slot)
@@ -2411,7 +2410,7 @@ location_store(struct mddev *mddev, const char *buf, size_t len)
 			}
 
 			mddev->bitmap = bitmap;
-			rv = md_bitmap_load(mddev);
+			rv = bitmap_load(mddev);
 			if (rv) {
 				mddev->bitmap_info.offset = 0;
 				md_bitmap_destroy(mddev);
@@ -2710,6 +2709,7 @@ const struct attribute_group md_bitmap_group = {
 
 static struct bitmap_operations bitmap_ops = {
 	.create			= bitmap_create,
+	.load			= bitmap_load,
 };
 
 void mddev_set_bitmap_ops(struct mddev *mddev)
diff --git a/drivers/md/md-bitmap.h b/drivers/md/md-bitmap.h
index a7cbf0c692fc..de7fbe5903dd 100644
--- a/drivers/md/md-bitmap.h
+++ b/drivers/md/md-bitmap.h
@@ -236,6 +236,7 @@ struct bitmap {
 
 struct bitmap_operations {
 	struct bitmap* (*create)(struct mddev *mddev, int slot);
+	int (*load)(struct mddev *mddev);
 };
 
 /* the bitmap API */
@@ -250,7 +251,14 @@ static inline struct bitmap *md_bitmap_create(struct mddev *mddev, int slot)
 	return mddev->bitmap_ops->create(mddev, slot);
 }
 
-int md_bitmap_load(struct mddev *mddev);
+static inline int md_bitmap_load(struct mddev *mddev)
+{
+	if (!mddev->bitmap_ops->load)
+		return -EOPNOTSUPP;
+
+	return mddev->bitmap_ops->load(mddev);
+}
+
 void md_bitmap_flush(struct mddev *mddev);
 void md_bitmap_destroy(struct mddev *mddev);
 
-- 
2.39.2

