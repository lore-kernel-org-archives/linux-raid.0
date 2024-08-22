Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C100018594D;
	Thu, 22 Aug 2024 02:52:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724295142; cv=none; b=kRmqA5gZSQqY4maRuvI/OVKG4uZdHd/OFevcDEEM9tB+i+Ak7xQxcmD6HzF+FXDo3ldwk9rEQ/PxM0qA3tT7M4hScyxMNNzLs1f5GeJbrXWWRBeB3fFHdmfDYVNyZjx5+DiImDbwjOqg0bLgYkNPIY45qIOBPnjqDoTyFOQpaek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724295142; c=relaxed/simple;
	bh=561G7/AH37Z5dKLC7Y12rOuw21IkJthyT6uWKBJxTFQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=RABahCtiaDUg0vARnnCRUfAWxcV+7cvQUVi9KIzTHFhAClQAhFfANtXh15gG8cYD1PL1eYcCuuXV9mek/5OJ0ssvldbTKTcRnTwnoLzRnX0vNi6I1nEbYVpY+MEJsthouP9lFQxsJSdF4N10tbN8audIKbZac0xIy9KlFrCNRs4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4Wq75g0XRyz4f3kp5;
	Thu, 22 Aug 2024 10:52:07 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id BEF921A18E6;
	Thu, 22 Aug 2024 10:52:16 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgAXPoTNp8ZmyXl2CQ--.42363S41;
	Thu, 22 Aug 2024 10:52:16 +0800 (CST)
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
Subject: [PATCH md-6.12 37/41] md/md-bitmap: merge md_bitmap_set_pages() into struct bitmap_operations
Date: Thu, 22 Aug 2024 10:47:14 +0800
Message-Id: <20240822024718.2158259-38-yukuai1@huaweicloud.com>
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
X-CM-TRANSID:gCh0CgAXPoTNp8ZmyXl2CQ--.42363S41
X-Coremail-Antispam: 1UD129KBjvJXoWxur4xKrWkJr1kXFWrCr1xXwb_yoW5Gw18pF
	4jqasxC3y3JFZIq3WUXrWDCFyrtw1DtrZrKryfC395uFy7XF9xKF48Ga47tw18GFy3JFsI
	qw15KryUur18XFUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUma14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
	kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
	z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Cr1j6r
	xdM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s0D
	M2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjx
	v20xvE14v26r106r15McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1l
	F7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7M4IIrI8v6xkF7I0E8cxan2
	IY04v7MxkF7I0En4kS14v26r1q6r43MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY
	6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17
	CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26ryj6F1UMIIF
	0xvE2Ix0cI8IcVCY1x0267AKxVW8Jr0_Cr1UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCw
	CI42IY6I8E87Iv67AKxVW8JVWxJwCI42IY6I8E87Iv6xkF7I0E14v26r4UJVWxJrUvcSsG
	vfC2KfnxnUUI43ZEXa7VU1zpBDUUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

o that the implementation won't be exposed, and it'll be possible
o invent a new bitmap by replacing bitmap_operations.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/md-bitmap.c  | 4 ++--
 drivers/md/md-bitmap.h  | 2 +-
 drivers/md/md-cluster.c | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index 5e35e8a7a44a..fb4195c0dc8d 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -2131,11 +2131,10 @@ static int bitmap_copy_from_slot(struct mddev *mddev, int slot, sector_t *low,
 	return rv;
 }
 
-void md_bitmap_set_pages(struct bitmap *bitmap, unsigned long pages)
+static void bitmap_set_pages(struct bitmap *bitmap, unsigned long pages)
 {
 	bitmap->counts.pages = pages;
 }
-EXPORT_SYMBOL_GPL(md_bitmap_set_pages);
 
 static int bitmap_get_stats(struct bitmap *bitmap, struct md_bitmap_stats *stats)
 {
@@ -2774,6 +2773,7 @@ static struct bitmap_operations bitmap_ops = {
 	.sync_with_cluster	= bitmap_sync_with_cluster,
 	.get_from_slot		= bitmap_get_from_slot,
 	.copy_from_slot		= bitmap_copy_from_slot,
+	.set_pages		= bitmap_set_pages,
 };
 
 void mddev_set_bitmap_ops(struct mddev *mddev)
diff --git a/drivers/md/md-bitmap.h b/drivers/md/md-bitmap.h
index 94d9a6ae244a..7fee98e3d517 100644
--- a/drivers/md/md-bitmap.h
+++ b/drivers/md/md-bitmap.h
@@ -279,6 +279,7 @@ struct bitmap_operations {
 	struct bitmap *(*get_from_slot)(struct mddev *mddev, int slot);
 	int (*copy_from_slot)(struct mddev *mddev, int slot, sector_t *lo,
 			      sector_t *hi, bool clear_bits);
+	void (*set_pages)(struct bitmap *bitmap, unsigned long pages);
 };
 
 /* the bitmap API */
@@ -286,7 +287,6 @@ void mddev_set_bitmap_ops(struct mddev *mddev);
 
 /* these are exported */
 
-void md_bitmap_set_pages(struct bitmap *bitmap, unsigned long pages);
 void md_bitmap_free(struct bitmap *bitmap);
 void md_bitmap_wait_behind_writes(struct mddev *mddev);
 
diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
index 515f46983ace..3296925b8455 100644
--- a/drivers/md/md-cluster.c
+++ b/drivers/md/md-cluster.c
@@ -1192,7 +1192,7 @@ static int resize_bitmaps(struct mddev *mddev, sector_t newsize, sector_t oldsiz
 		bm_lockres->flags |= DLM_LKF_NOQUEUE;
 		rv = dlm_lock_sync(bm_lockres, DLM_LOCK_PW);
 		if (!rv)
-			md_bitmap_set_pages(bitmap, my_pages);
+			mddev->bitmap_ops->set_pages(bitmap, my_pages);
 		lockres_free(bm_lockres);
 
 		if (my_pages != stats.pages)
-- 
2.39.2

