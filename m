Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D41D61428FA;
	Wed, 14 Aug 2024 07:15:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723619737; cv=none; b=E3+V+33bxJZWHMqPKHYKSP+NjykPQfzgWgW0GBruEym7UmMJYE16qm8rIRiAH4uRfu4iQNdH/llaQF5dWNd+/HB6wvKh3LyDvizrTZs52dDzjfyvm1wK7mz2Au4r+Ldme1RmJScPNN+QPZU673XSkI433LhoHlFOLbUzuu/2htM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723619737; c=relaxed/simple;
	bh=wLyErMMOpUuoqpjLrYC/xg7d2rgfhqYFBSy9JIFS4VI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=aoCK82NlujblgIxEwMsy9hN7R7nGo2TMIkegY6OgweAjg7GZhOd4MM2SukTqDHxaW3tmlgeZFCXbGBJvxzy+KfgzgqUFUdzj45hjN3LcwTyZhctk3g2eVqFmZN0g1xuvMjhwSONdiO0/p9YIfARnZPrO2+5+8Hwe8nnnio9h7w4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4WkKK10llqz4f3jHT;
	Wed, 14 Aug 2024 15:15:17 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id D41EA1A0359;
	Wed, 14 Aug 2024 15:15:30 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgBHboSLWbxmIxKbBg--.47745S16;
	Wed, 14 Aug 2024 15:15:30 +0800 (CST)
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
Subject: [PATCH RFC -next v2 12/41] md/md-bitmap: merge md_bitmap_create() into bitmap_operations
Date: Wed, 14 Aug 2024 15:10:44 +0800
Message-Id: <20240814071113.346781-13-yukuai1@huaweicloud.com>
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
X-CM-TRANSID:gCh0CgBHboSLWbxmIxKbBg--.47745S16
X-Coremail-Antispam: 1UD129KBjvJXoWxur47JFWfWr47uw4UJry8Grg_yoWrJw47pr
	s2qas8GrW3J3yfWw1UZFWq9a4Yqr1vgr9rtryxCw1ruFyDJFnxCF4rWF1jyw15Ca4fAFsx
	Xw45KF18CF4IqF7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUPY14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
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
	Gr1j6F4UJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Gr0_Cr
	1lIxAIcVC2z280aVCY1x0267AKxVW8Jr0_Cr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUQFxUU
	UUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

So that the implementation won't be exposed, and it'll be possible
to invent a new bitmap by replacing bitmap_operations.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/md-bitmap.c | 11 ++++++-----
 drivers/md/md-bitmap.h |  2 +-
 drivers/md/md.c        |  6 +++---
 3 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index 75e58da9a1a5..9606bcafb834 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -1879,7 +1879,7 @@ void md_bitmap_destroy(struct mddev *mddev)
  * if this returns an error, bitmap_destroy must be called to do clean up
  * once mddev->bitmap is set
  */
-static struct bitmap *bitmap_create(struct mddev *mddev, int slot)
+static struct bitmap *__bitmap_create(struct mddev *mddev, int slot)
 {
 	struct bitmap *bitmap;
 	sector_t blocks = mddev->resync_max_sectors;
@@ -1966,9 +1966,9 @@ static struct bitmap *bitmap_create(struct mddev *mddev, int slot)
 	return ERR_PTR(err);
 }
 
-int md_bitmap_create(struct mddev *mddev, int slot)
+static int bitmap_create(struct mddev *mddev, int slot)
 {
-	struct bitmap *bitmap = bitmap_create(mddev, slot);
+	struct bitmap *bitmap = __bitmap_create(mddev, slot);
 
 	if (IS_ERR(bitmap))
 		return PTR_ERR(bitmap);
@@ -2041,7 +2041,7 @@ struct bitmap *get_bitmap_from_slot(struct mddev *mddev, int slot)
 	int rv = 0;
 	struct bitmap *bitmap;
 
-	bitmap = bitmap_create(mddev, slot);
+	bitmap = __bitmap_create(mddev, slot);
 	if (IS_ERR(bitmap)) {
 		rv = PTR_ERR(bitmap);
 		return ERR_PTR(rv);
@@ -2418,7 +2418,7 @@ location_store(struct mddev *mddev, const char *buf, size_t len)
 			}
 
 			mddev->bitmap_info.offset = offset;
-			rv = md_bitmap_create(mddev, -1);
+			rv = bitmap_create(mddev, -1);
 			if (rv)
 				goto out;
 
@@ -2720,6 +2720,7 @@ const struct attribute_group md_bitmap_group = {
 };
 
 static struct bitmap_operations bitmap_ops = {
+	.create			= bitmap_create,
 };
 
 void mddev_set_bitmap_ops(struct mddev *mddev)
diff --git a/drivers/md/md-bitmap.h b/drivers/md/md-bitmap.h
index e187f9099f2e..4b9c22b66e65 100644
--- a/drivers/md/md-bitmap.h
+++ b/drivers/md/md-bitmap.h
@@ -246,13 +246,13 @@ struct md_bitmap_stats {
 };
 
 struct bitmap_operations {
+	int (*create)(struct mddev *mddev, int slot);
 };
 
 /* the bitmap API */
 void mddev_set_bitmap_ops(struct mddev *mddev);
 
 /* these are used only by md/bitmap */
-int md_bitmap_create(struct mddev *mddev, int slot);
 int md_bitmap_load(struct mddev *mddev);
 void md_bitmap_flush(struct mddev *mddev);
 void md_bitmap_destroy(struct mddev *mddev);
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 6e130f6c2abd..b32ab7ca7640 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -6211,7 +6211,7 @@ int md_run(struct mddev *mddev)
 	}
 	if (err == 0 && pers->sync_request &&
 	    (mddev->bitmap_info.file || mddev->bitmap_info.offset)) {
-		err = md_bitmap_create(mddev, -1);
+		err = mddev->bitmap_ops->create(mddev, -1);
 		if (err)
 			pr_warn("%s: failed to create bitmap (%d)\n",
 				mdname(mddev), err);
@@ -7269,7 +7269,7 @@ static int set_bitmap_file(struct mddev *mddev, int fd)
 	err = 0;
 	if (mddev->pers) {
 		if (fd >= 0) {
-			err = md_bitmap_create(mddev, -1);
+			err = mddev->bitmap_ops->create(mddev, -1);
 			if (!err)
 				err = md_bitmap_load(mddev);
 
@@ -7563,7 +7563,7 @@ static int update_array_info(struct mddev *mddev, mdu_array_info_t *info)
 				mddev->bitmap_info.default_offset;
 			mddev->bitmap_info.space =
 				mddev->bitmap_info.default_space;
-			rv = md_bitmap_create(mddev, -1);
+			rv = mddev->bitmap_ops->create(mddev, -1);
 			if (!rv)
 				rv = md_bitmap_load(mddev);
 
-- 
2.39.2

