Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFBD9AD5A;
	Wed, 14 Aug 2024 07:15:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723619747; cv=none; b=iAeY5ges8tsMqSiVdwRpapLR87fVEtKKYS8YxOfgBjwGLBp1gFwswjK52n9Wve+1qxG7ts/mEEG9tRx12Kl4/DKban6/+7O4dKuIbrYjF5+QRt7CJ3t7bZ/51mLFHyWPsqMli/g4cgoCRRfKK2EDC+L/umbVe2il58LN1d4Mniw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723619747; c=relaxed/simple;
	bh=D8q8VYcdwVlrbcXn9fu6FM10cCGgpWBTQW3OCHplV0w=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=hkyvNBMykoC48K5GgaNEzAIBD09a3ULaQkiPo+grkwVtNXUjO7yBvn8aKqyRX+6mv3nHy+AIV+8rfVDgwkP7AsOoTmcf66cxdq0jYs1i7y7AJ2ZDg9LacSbdd8orBM24mTZY6E0+egqebEZQ/9YuizxGQ/EPM2DxgB/xZQKj7ag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4WkKKJ3tRvz4f3jZL;
	Wed, 14 Aug 2024 15:15:32 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id D92911A07B6;
	Wed, 14 Aug 2024 15:15:41 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgBHboSLWbxmIxKbBg--.47745S43;
	Wed, 14 Aug 2024 15:15:41 +0800 (CST)
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
Subject: [PATCH RFC -next v2 39/41] md/md-bitmap: merge md_bitmap_wait_behind_writes() into bitmap_operations
Date: Wed, 14 Aug 2024 15:11:11 +0800
Message-Id: <20240814071113.346781-40-yukuai1@huaweicloud.com>
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
X-CM-TRANSID:gCh0CgBHboSLWbxmIxKbBg--.47745S43
X-Coremail-Antispam: 1UD129KBjvJXoWxZFW8Cr48Gr1rWF15Cr1fCrg_yoW5tw1fpF
	ZFqF1Ykr45tFWaqw4UAFykuFySyF1kKrZrtryxCw1ruFy3ArnxGF4FgFWDt3s8Cay3AFs8
	Za1YyryUWw10qFUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUP014x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
	kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
	z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Cr1j6r
	xdM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s0D
	M2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjx
	v20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1l
	F7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7MxkF7I0En4kS14v26r1q6r
	43MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_
	Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x
	0EwIxGrwCI42IY6xIIjxv20xvE14v26ryj6F1UMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8
	Jr0_Cr1UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVW8JVWxJw
	CI42IY6I8E87Iv6xkF7I0E14v26r4UJVWxJrUvcSsGvfC2KfnxnUUI43ZEXa7VUbPC7UUU
	UUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

So that the implementation won't be exposed, and it'll be possible
to invent a new bitmap by replacing bitmap_operations.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/md-bitmap.c | 6 +++---
 drivers/md/md-bitmap.h | 4 +---
 drivers/md/md.c        | 2 +-
 drivers/md/raid1.c     | 2 +-
 4 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index eb7c5e552acf..c6826cb28ed2 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -1863,7 +1863,7 @@ static void md_bitmap_free(struct bitmap *bitmap)
 	kfree(bitmap);
 }
 
-void md_bitmap_wait_behind_writes(struct mddev *mddev)
+static void bitmap_wait_behind_writes(struct mddev *mddev)
 {
 	struct bitmap *bitmap = mddev->bitmap;
 
@@ -1876,7 +1876,6 @@ void md_bitmap_wait_behind_writes(struct mddev *mddev)
 			   atomic_read(&bitmap->behind_writes) == 0);
 	}
 }
-EXPORT_SYMBOL_GPL(md_bitmap_wait_behind_writes);
 
 static void bitmap_destroy(struct mddev *mddev)
 {
@@ -1885,7 +1884,7 @@ static void bitmap_destroy(struct mddev *mddev)
 	if (!bitmap) /* there was no bitmap */
 		return;
 
-	md_bitmap_wait_behind_writes(mddev);
+	bitmap_wait_behind_writes(mddev);
 	if (!mddev->serialize_policy)
 		mddev_destroy_serial_pool(mddev, NULL);
 
@@ -2752,6 +2751,7 @@ static struct bitmap_operations bitmap_ops = {
 	.dirty_bits		= bitmap_dirty_bits,
 	.unplug			= bitmap_unplug,
 	.daemon_work		= bitmap_daemon_work,
+	.wait_behind_writes	= bitmap_wait_behind_writes,
 
 	.startwrite		= bitmap_startwrite,
 	.endwrite		= bitmap_endwrite,
diff --git a/drivers/md/md-bitmap.h b/drivers/md/md-bitmap.h
index d0037665a4dc..b232ac57c0dc 100644
--- a/drivers/md/md-bitmap.h
+++ b/drivers/md/md-bitmap.h
@@ -258,6 +258,7 @@ struct bitmap_operations {
 			   unsigned long e);
 	void (*unplug)(struct mddev *mddev, bool sync);
 	void (*daemon_work)(struct mddev *mddev);
+	void (*wait_behind_writes)(struct mddev *mddev);
 
 	int (*startwrite)(struct mddev *mddev, sector_t offset,
 			  unsigned long sectors, bool behind);
@@ -285,9 +286,6 @@ struct bitmap_operations {
 /* the bitmap API */
 void mddev_set_bitmap_ops(struct mddev *mddev);
 
-/* these are exported */
-void md_bitmap_wait_behind_writes(struct mddev *mddev);
-
 static inline u64 md_bitmap_events_cleared(struct mddev *mddev)
 {
 	struct md_bitmap_stats stats;
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 4bdfe23a565d..6800888152d0 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -6484,7 +6484,7 @@ EXPORT_SYMBOL_GPL(md_stop_writes);
 
 static void mddev_detach(struct mddev *mddev)
 {
-	md_bitmap_wait_behind_writes(mddev);
+	mddev->bitmap_ops->wait_behind_writes(mddev);
 	if (mddev->pers && mddev->pers->quiesce && !is_md_suspended(mddev)) {
 		mddev->pers->quiesce(mddev, 1);
 		mddev->pers->quiesce(mddev, 0);
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index e285f01e3ef6..17b1965fec56 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1384,7 +1384,7 @@ static void raid1_read_request(struct mddev *mddev, struct bio *bio,
 		 * over-take any writes that are 'behind'
 		 */
 		mddev_add_trace_msg(mddev, "raid1 wait behind writes");
-		md_bitmap_wait_behind_writes(mddev);
+		mddev->bitmap_ops->wait_behind_writes(mddev);
 	}
 
 	if (max_sectors < bio_sectors(bio)) {
-- 
2.39.2

