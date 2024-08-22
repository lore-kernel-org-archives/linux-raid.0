Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CF0B17DFE3;
	Thu, 22 Aug 2024 02:52:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724295138; cv=none; b=fmKu+tA+/bBVa3pfFseCt03jsPUIMLR27PwtWSJJz4rWzFmvHi4PTbBoR9ASuCLEajJomHJJu2gHM4g06DuNEA6I2/8uOyudRQSjcugorS1RZdI1Wu8yFrqp3Bj5/yBPvSi35L6RVCUkiMYSnBo2ARmVSyCBodeW+NWBlUBOAQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724295138; c=relaxed/simple;
	bh=wzXivTOXG2mKjb494or2y7/KQvX1MyyszHXwV3tFccU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=haSvA90ncGPmdMHcTUpwPYiMNVkhk3U4uhqUKFMO7Wm/IVoQlOqoTBSKXEN4PccKeq5vmOIJMEt6gWNbEXUXx4FkxtrIqEOrfkAQBiWolvdfco5R8GwKKtHEFMAwd1/J4ExvFQ7qmSP1jyOgg8aEKkCcx/e3SzCkv5V/LfQiGSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4Wq75V00xHz4f3nJd;
	Thu, 22 Aug 2024 10:51:57 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 23D1F1A0E9A;
	Thu, 22 Aug 2024 10:52:13 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgAXPoTNp8ZmyXl2CQ--.42363S33;
	Thu, 22 Aug 2024 10:52:12 +0800 (CST)
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
Subject: [PATCH md-6.12 29/41] md/md-bitmap: merge md_bitmap_sync_with_cluster() into bitmap_operations
Date: Thu, 22 Aug 2024 10:47:06 +0800
Message-Id: <20240822024718.2158259-30-yukuai1@huaweicloud.com>
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
X-CM-TRANSID:gCh0CgAXPoTNp8ZmyXl2CQ--.42363S33
X-Coremail-Antispam: 1UD129KBjvJXoWxur4xXF17Ww4rZw17JFy5urg_yoW5Zr1xpF
	WUta43Cry3JFZxXw1UZFyDua4Fy34ktrZrtryxW34ruFyqqrnxGF4rGasFyrWkGF15JFsI
	vw15KFW5ur1kXr7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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

So that the implementation won't be exposed, and it'll be possible
to invent a new bitmap by replacing bitmap_operations.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/md-bitmap.c  | 9 +++++----
 drivers/md/md-bitmap.h  | 8 ++++----
 drivers/md/md-cluster.c | 4 ++--
 3 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index 729cc7e2bb59..ebf80580ffc9 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -1721,9 +1721,9 @@ static void bitmap_cond_end_sync(struct mddev *mddev, sector_t sector,
 	sysfs_notify_dirent_safe(bitmap->mddev->sysfs_completed);
 }
 
-void md_bitmap_sync_with_cluster(struct mddev *mddev,
-			      sector_t old_lo, sector_t old_hi,
-			      sector_t new_lo, sector_t new_hi)
+static void bitmap_sync_with_cluster(struct mddev *mddev,
+				     sector_t old_lo, sector_t old_hi,
+				     sector_t new_lo, sector_t new_hi)
 {
 	struct bitmap *bitmap = mddev->bitmap;
 	sector_t sector, blocks = 0;
@@ -1740,7 +1740,6 @@ void md_bitmap_sync_with_cluster(struct mddev *mddev,
 	}
 	WARN((blocks > new_hi) && old_hi, "alignment is not correct for hi\n");
 }
-EXPORT_SYMBOL(md_bitmap_sync_with_cluster);
 
 static void md_bitmap_set_memory_bits(struct bitmap *bitmap, sector_t offset, int needed)
 {
@@ -2753,6 +2752,8 @@ static struct bitmap_operations bitmap_ops = {
 
 	.update_sb		= bitmap_update_sb,
 	.get_stats		= bitmap_get_stats,
+
+	.sync_with_cluster	= bitmap_sync_with_cluster,
 };
 
 void mddev_set_bitmap_ops(struct mddev *mddev)
diff --git a/drivers/md/md-bitmap.h b/drivers/md/md-bitmap.h
index 027de097f96a..0953ac73735c 100644
--- a/drivers/md/md-bitmap.h
+++ b/drivers/md/md-bitmap.h
@@ -267,16 +267,16 @@ struct bitmap_operations {
 
 	void (*update_sb)(struct bitmap *bitmap);
 	int (*get_stats)(struct bitmap *bitmap, struct md_bitmap_stats *stats);
+
+	void (*sync_with_cluster)(struct mddev *mddev,
+				  sector_t old_lo, sector_t old_hi,
+				  sector_t new_lo, sector_t new_hi);
 };
 
 /* the bitmap API */
 void mddev_set_bitmap_ops(struct mddev *mddev);
 
 /* these are exported */
-void md_bitmap_sync_with_cluster(struct mddev *mddev,
-				 sector_t old_lo, sector_t old_hi,
-				 sector_t new_lo, sector_t new_hi);
-
 void md_bitmap_unplug(struct bitmap *bitmap);
 void md_bitmap_unplug_async(struct bitmap *bitmap);
 void md_bitmap_daemon_work(struct mddev *mddev);
diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
index a5f1135cc1fa..55feabe14ad3 100644
--- a/drivers/md/md-cluster.c
+++ b/drivers/md/md-cluster.c
@@ -497,8 +497,8 @@ static void process_suspend_info(struct mddev *mddev,
 	 * we don't want to trigger lots of WARN.
 	 */
 	if (sb && !(le32_to_cpu(sb->feature_map) & MD_FEATURE_RESHAPE_ACTIVE))
-		md_bitmap_sync_with_cluster(mddev, cinfo->sync_low,
-					    cinfo->sync_hi, lo, hi);
+		mddev->bitmap_ops->sync_with_cluster(mddev, cinfo->sync_low,
+						     cinfo->sync_hi, lo, hi);
 	cinfo->sync_low = lo;
 	cinfo->sync_hi = hi;
 
-- 
2.39.2

