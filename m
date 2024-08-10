Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EB6515AF6;
	Sat, 10 Aug 2024 02:12:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723255979; cv=none; b=QCZ6aanz5MlFYo0FTPd1+WyZSLto5GZpbvJnUVLMqtsLcmtzI8/Kaj6jf9/jm2E/1dTlpn4I7g99dnGCBI1+luPaYGf36TlWIiEwFVtcUWsb2tfFvWbzVC1aknTYuNjLXUwsAsBCZFqi+VP0bj3WL+n2Ur5HN45cS/cEMyumYd4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723255979; c=relaxed/simple;
	bh=eKGwyrAMYPtZUn2NsyA0r0xUoBi2jEpGkrTzT6P3kWs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=T4cqL1AShxbicdbnfObzx20nlkNeVu1/D0QM6CNxwgqAF0298naQSrOf5/8hQrxB2OxsI/dYWSpe259sdSbj6PoaIhxeiRILb6hNCMAOi5ECp7i/ysEso0zX3JpZDdIwh4jFcMeAJPaLEb6GqMo/7LQ1cIQuah4tt0wtx/uN9kY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4Wgknf5QvBz4f3jLc;
	Sat, 10 Aug 2024 10:12:38 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 3EB691A1718;
	Sat, 10 Aug 2024 10:12:53 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgAHL4WizLZmErwLBQ--.1937S6;
	Sat, 10 Aug 2024 10:12:53 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: song@kernel.org
Cc: linux-kernel@vger.kernel.org,
	linux-raid@vger.kernel.org,
	yukuai3@huawei.com,
	yukuai1@huaweicloud.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com
Subject: [PATCH RFC -next 02/26] md/md-bitmap: merge md_bitmap_create() into bitmap_operations
Date: Sat, 10 Aug 2024 10:08:30 +0800
Message-Id: <20240810020854.797814-3-yukuai1@huaweicloud.com>
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
X-CM-TRANSID:gCh0CgAHL4WizLZmErwLBQ--.1937S6
X-Coremail-Antispam: 1UD129KBjvJXoWxur47Jw1rKFyrur4Duw4kWFg_yoW5Jw4rpF
	s7tas8C3y3JrWSgr1UZFWqka4Fqr1vqrZrKryfCw1ruF9rJFnxGF4rWF12y34rGa43JFsx
	Xw15KryUCr1xXrUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUBl14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_Jryl82xGYIkIc2
	x26xkF7I0E14v26r4j6ryUM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0
	Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Cr0_Gr1UM2
	8EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s0DM2AI
	xVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20x
	vE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xv
	r2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7MxkF7I0En4kS14v26r126r1DMx
	AIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_
	Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUAVWUtwCIc40Y0x0EwI
	xGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWx
	JwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcV
	C2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7VUUApnJUUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

So that the implementation won't be exposed, and it'll be possible
to invent a new bitmap by replacing bitmap_operations.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/md-bitmap.c |  7 ++++---
 drivers/md/md-bitmap.h | 10 +++++++++-
 2 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index d9838fbcc9d7..d731f7d4bbbb 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -1878,7 +1878,7 @@ void md_bitmap_destroy(struct mddev *mddev)
  * if this returns an error, bitmap_destroy must be called to do clean up
  * once mddev->bitmap is set
  */
-struct bitmap *md_bitmap_create(struct mddev *mddev, int slot)
+static struct bitmap *bitmap_create(struct mddev *mddev, int slot)
 {
 	struct bitmap *bitmap;
 	sector_t blocks = mddev->resync_max_sectors;
@@ -2029,7 +2029,7 @@ struct bitmap *get_bitmap_from_slot(struct mddev *mddev, int slot)
 	int rv = 0;
 	struct bitmap *bitmap;
 
-	bitmap = md_bitmap_create(mddev, slot);
+	bitmap = bitmap_create(mddev, slot);
 	if (IS_ERR(bitmap)) {
 		rv = PTR_ERR(bitmap);
 		return ERR_PTR(rv);
@@ -2404,7 +2404,7 @@ location_store(struct mddev *mddev, const char *buf, size_t len)
 			}
 
 			mddev->bitmap_info.offset = offset;
-			bitmap = md_bitmap_create(mddev, -1);
+			bitmap = bitmap_create(mddev, -1);
 			if (IS_ERR(bitmap)) {
 				rv = PTR_ERR(bitmap);
 				goto out;
@@ -2709,6 +2709,7 @@ const struct attribute_group md_bitmap_group = {
 };
 
 static struct bitmap_operations bitmap_ops = {
+	.create			= bitmap_create,
 };
 
 void mddev_set_bitmap_ops(struct mddev *mddev)
diff --git a/drivers/md/md-bitmap.h b/drivers/md/md-bitmap.h
index 992feaf66d47..a7cbf0c692fc 100644
--- a/drivers/md/md-bitmap.h
+++ b/drivers/md/md-bitmap.h
@@ -235,13 +235,21 @@ struct bitmap {
 };
 
 struct bitmap_operations {
+	struct bitmap* (*create)(struct mddev *mddev, int slot);
 };
 
 /* the bitmap API */
 void mddev_set_bitmap_ops(struct mddev *mddev);
 
 /* these are used only by md/bitmap */
-struct bitmap *md_bitmap_create(struct mddev *mddev, int slot);
+static inline struct bitmap *md_bitmap_create(struct mddev *mddev, int slot)
+{
+	if (!mddev->bitmap_ops->create)
+		return ERR_PTR(-EOPNOTSUPP);
+
+	return mddev->bitmap_ops->create(mddev, slot);
+}
+
 int md_bitmap_load(struct mddev *mddev);
 void md_bitmap_flush(struct mddev *mddev);
 void md_bitmap_destroy(struct mddev *mddev);
-- 
2.39.2

