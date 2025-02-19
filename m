Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DA8C1C5F2F;
	Wed, 19 Feb 2025 08:38:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739954323; cv=none; b=Kzg3hZOj3XgdlYwirZlRFa31oVVjBGiqgeuMJ9D3aH4Mwg6OmkfTMwDkwkWMv1JzNbP+FpJKQJ7GDWP5EUIpWFUU0i5Q1FnVi0fWmVVbn9MHhMNaFanHD1EVMwL9oR2dUkvlRk3qYTnUap4/ga1CE308/m9dUrYUO01cPyOTQ7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739954323; c=relaxed/simple;
	bh=uAgYKtLDtJ4qk/CHvsbVzwUCiS/t70M//6BwbS9gDuE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=JPZBnCKZcbvX0DuDZDfBibKD0NfLAoxE0nMnE/6o7OyOMgYoLvTgEYCCI9ZwS2FyTw2oWtkXDpg0gEPyqXN13bTlIDudYpDz686DYSIInvZMRNSU1OGQIrvIqDjNLqxCRzqMyPfas+nSsNTJwFYpE6t4+mVRKoaQc3dS6xsUTrg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4YyVCV740Tz4f3kw2;
	Wed, 19 Feb 2025 16:38:14 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 00BDA1A0AD0;
	Wed, 19 Feb 2025 16:38:37 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgBXvGCImLVn4yQeEQ--.36560S7;
	Wed, 19 Feb 2025 16:38:37 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: song@kernel.org,
	yukuai3@huawei.com
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	yukuai1@huaweicloud.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com
Subject: [PATCH md-6.15 v4 03/11] md/md-bitmap: add md_bitmap_registered/enabled() helper
Date: Wed, 19 Feb 2025 16:34:48 +0800
Message-Id: <20250219083456.941760-4-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250219083456.941760-1-yukuai1@huaweicloud.com>
References: <20250219083456.941760-1-yukuai1@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgBXvGCImLVn4yQeEQ--.36560S7
X-Coremail-Antispam: 1UD129KBjvJXoWxur1UJF48KF47uFW5ur1ftFb_yoW5AFy3p3
	9rta43Cr45JFWSg3W7AFWkua4Yqwn7tr9rKryfC34ruFy3ZFs8GF4rWayUt3Z7t343AFsI
	vw45Kr4UCr1UWF7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUBG14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JrWl82xGYIkIc2
	x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0
	Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJw
	A2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq3wAS
	0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2
	IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0
	Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCY1x0262kKe7AKxVWUAVWUtw
	CF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j
	6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1lIxkGc2Ij64
	vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_
	Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0x
	vEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JU9J5rUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

There are no functional changes, prepare to handle the case that
mddev->bitmap_ops can be NULL, which is possible after introducing
CONFIG_MD_BITMAP.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/md-bitmap.c | 16 ++++------------
 drivers/md/md-bitmap.h | 19 ++++++++++++++++++-
 drivers/md/raid1-10.c  |  2 +-
 3 files changed, 23 insertions(+), 14 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index 4b698e7593af..2d306e5ad5b1 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -222,22 +222,14 @@ static inline char *bmname(struct bitmap *bitmap)
 	return bitmap->mddev ? mdname(bitmap->mddev) : "mdX";
 }
 
-static bool __bitmap_enabled(struct bitmap *bitmap)
+static bool bitmap_enabled(void *data)
 {
+	struct bitmap *bitmap = data;
+
 	return bitmap->storage.filemap &&
 	       !test_bit(BITMAP_STALE, &bitmap->flags);
 }
 
-static bool bitmap_enabled(struct mddev *mddev)
-{
-	struct bitmap *bitmap = mddev->bitmap;
-
-	if (!bitmap)
-		return false;
-
-	return __bitmap_enabled(bitmap);
-}
-
 /*
  * check a page and, if necessary, allocate it (or hijack it if the alloc fails)
  *
@@ -1234,7 +1226,7 @@ static void __bitmap_unplug(struct bitmap *bitmap)
 	int dirty, need_write;
 	int writing = 0;
 
-	if (!__bitmap_enabled(bitmap))
+	if (!bitmap_enabled(bitmap))
 		return;
 
 	/* look at each page to see if there are any set bits that need to be
diff --git a/drivers/md/md-bitmap.h b/drivers/md/md-bitmap.h
index 5a2aa1324df0..3b242ee10856 100644
--- a/drivers/md/md-bitmap.h
+++ b/drivers/md/md-bitmap.h
@@ -71,7 +71,7 @@ struct md_bitmap_stats {
 };
 
 struct bitmap_operations {
-	bool (*enabled)(struct mddev *mddev);
+	bool (*enabled)(void *data);
 	int (*create)(struct mddev *mddev, int slot);
 	int (*resize)(struct mddev *mddev, sector_t blocks, int chunksize);
 
@@ -116,4 +116,21 @@ struct bitmap_operations {
 /* the bitmap API */
 void mddev_set_bitmap_ops(struct mddev *mddev);
 
+static inline bool md_bitmap_registered(struct mddev *mddev)
+{
+	return mddev->bitmap_ops != NULL;
+}
+
+static inline bool md_bitmap_enabled(struct mddev *mddev)
+{
+	/* bitmap_ops must be registered before creating bitmap. */
+	if (!md_bitmap_registered(mddev))
+		return false;
+
+	if (!mddev->bitmap)
+		return false;
+
+	return mddev->bitmap_ops->enabled(mddev->bitmap);
+}
+
 #endif
diff --git a/drivers/md/raid1-10.c b/drivers/md/raid1-10.c
index 4a51b151a981..f3cb477d0b6a 100644
--- a/drivers/md/raid1-10.c
+++ b/drivers/md/raid1-10.c
@@ -140,7 +140,7 @@ static inline bool raid1_add_bio_to_plug(struct mddev *mddev, struct bio *bio,
 	 * If bitmap is not enabled, it's safe to submit the io directly, and
 	 * this can get optimal performance.
 	 */
-	if (!mddev->bitmap_ops->enabled(mddev)) {
+	if (!md_bitmap_enabled(mddev)) {
 		raid1_submit_write(bio);
 		return true;
 	}
-- 
2.39.2

