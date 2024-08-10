Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0153614265F;
	Sat, 10 Aug 2024 02:13:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723255985; cv=none; b=NQ7UoPjFuPNOtcoxzp+Ws3UNxSgXK/CIJlOKVVVZy7KRRmZGcP5QOhmX4GnL4pSkpXu/GBx71D4HIMqiISkZS5nxq4ZznmYJsDvqD3UbHjpS0xljBSOMddWuyJ8m2sPdiOhvsnm7IBbinWtMEpaG+ikS+x6JxxSlJoxUwK7mTsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723255985; c=relaxed/simple;
	bh=0c7LxUUaBa7OPsP91Q71xnibTX2ZAre8LY2EEVElqcE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=er3qBl7y4/SesznberfnhYGff9O4/3OfUuTSvGX/NVVr9yIyBM+Gsrgu55qsCmarXM6aTAsXzUlck6wO0F6nzk4kxDyqZ74qJt0LP9j4SMOMV1T4JfMGu2NONoKD9jwhJWmVsp+h0axXdtgJvxBbxM/quCXOdnQRBXEFgweGcdM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4Wgknv1VrXz4f3jk1;
	Sat, 10 Aug 2024 10:12:51 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 569631A018D;
	Sat, 10 Aug 2024 10:13:00 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgAHL4WizLZmErwLBQ--.1937S27;
	Sat, 10 Aug 2024 10:13:00 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: song@kernel.org
Cc: linux-kernel@vger.kernel.org,
	linux-raid@vger.kernel.org,
	yukuai3@huawei.com,
	yukuai1@huaweicloud.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com
Subject: [PATCH RFC -next 23/26] md/md-bitmap: merge md_bitmap_wait_behind_writes() into bitmap_operations
Date: Sat, 10 Aug 2024 10:08:51 +0800
Message-Id: <20240810020854.797814-24-yukuai1@huaweicloud.com>
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
X-CM-TRANSID:gCh0CgAHL4WizLZmErwLBQ--.1937S27
X-Coremail-Antispam: 1UD129KBjvJXoWxur4xCw1UCr17Xw15Ar47Jwb_yoW5Zw43pF
	WDt3Z0kr15tFW3Xw4UAFWkAF1Fyr1ktr9rtryfGwn5uF1DJrnxKF4FgF1Utw15Ary3JFs8
	Zan5tryrCr18XF7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUPY14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
	kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
	z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F
	4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq
	3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7
	IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4U
	M4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCY1x0262kKe7AKxVWUAV
	WUtwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v2
	6r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1lIxkGc2
	Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVW5JVW7JwCI42IY6xIIjxv20xvEc7CjxVAFwI0_
	Gr1j6F4UJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Gr0_Cr
	1lIxAIcVC2z280aVCY1x0267AKxVW8Jr0_Cr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUvYLPU
	UUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

So that the implementation won't be exposed, and it'll be possible
to invent a new bitmap by replacing bitmap_operations.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/md-bitmap.c | 11 +++++------
 drivers/md/md-bitmap.h | 11 +++++++++--
 2 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index 99c496a32e94..87e192d172fb 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -1825,14 +1825,12 @@ static void __bitmap_free(struct bitmap *bitmap)
 	kfree(bitmap);
 }
 
-void md_bitmap_wait_behind_writes(struct mddev *mddev)
+static void bitmap_wait_behind_writes(struct bitmap *bitmap)
 {
-	struct bitmap *bitmap = mddev->bitmap;
-
 	/* wait for behind writes to complete */
-	if (bitmap && atomic_read(&bitmap->behind_writes) > 0) {
+	if (atomic_read(&bitmap->behind_writes) > 0) {
 		pr_debug("md:%s: behind writes in progress - waiting to stop.\n",
-			 mdname(mddev));
+			 mdname(bitmap->mddev));
 		/* need to kick something here to make sure I/O goes? */
 		wait_event(bitmap->behind_wait,
 			   atomic_read(&bitmap->behind_writes) == 0);
@@ -1846,7 +1844,7 @@ static void bitmap_destroy(struct mddev *mddev)
 	if (!bitmap) /* there was no bitmap */
 		return;
 
-	md_bitmap_wait_behind_writes(mddev);
+	bitmap_wait_behind_writes(bitmap);
 	if (!mddev->serialize_policy)
 		mddev_destroy_serial_pool(mddev, NULL);
 
@@ -2705,6 +2703,7 @@ static struct bitmap_operations bitmap_ops = {
 	.end_sync		= bitmap_end_sync,
 	.close_sync		= bitmap_close_sync,
 	.cond_end_sync		= bitmap_cond_end_sync,
+	.wait_behind_writes	= bitmap_wait_behind_writes,
 
 	.update_sb		= bitmap_update_sb,
 	.resize			= bitmap_resize,
diff --git a/drivers/md/md-bitmap.h b/drivers/md/md-bitmap.h
index b5836e5ff1e3..090d4f11f3cd 100644
--- a/drivers/md/md-bitmap.h
+++ b/drivers/md/md-bitmap.h
@@ -253,6 +253,7 @@ struct bitmap_operations {
 			 sector_t *blocks, int aborted);
 	void (*close_sync)(struct bitmap *bitmap);
 	void (*cond_end_sync)(struct bitmap *bitmap, sector_t sector, bool force);
+	void (*wait_behind_writes)(struct bitmap *bitmap);
 
 	void (*update_sb)(struct bitmap *bitmap);
 	int (*resize)(struct bitmap *bitmap, sector_t blocks, int chunksize,
@@ -395,6 +396,14 @@ static inline void md_bitmap_cond_end_sync(struct mddev *mddev, sector_t sector,
 	mddev->bitmap_ops->cond_end_sync(mddev->bitmap, sector, force);
 }
 
+static inline void md_bitmap_wait_behind_writes(struct mddev *mddev)
+{
+	if (!mddev->bitmap || !mddev->bitmap_ops->wait_behind_writes)
+		return;
+
+	mddev->bitmap_ops->wait_behind_writes(mddev->bitmap);
+}
+
 static inline int md_bitmap_resize(struct mddev *mddev, sector_t blocks,
 				   int chunksize, int init)
 {
@@ -446,8 +455,6 @@ void md_bitmap_unplug(struct bitmap *bitmap);
 void md_bitmap_unplug_async(struct bitmap *bitmap);
 void md_bitmap_daemon_work(struct mddev *mddev);
 
-void md_bitmap_wait_behind_writes(struct mddev *mddev);
-
 static inline bool md_bitmap_enabled(struct bitmap *bitmap)
 {
 	return bitmap && bitmap->storage.filemap &&
-- 
2.39.2

