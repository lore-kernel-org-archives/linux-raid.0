Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7687A1714AD;
	Mon, 26 Aug 2024 07:50:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724658606; cv=none; b=TCL2qL0aNWvEpIMs4+mmjZXPdniU3UMWCoYqTm9PAufXApRcJEC/yznjlRA50+KTvbcG34ogG6rW8kJhKq3E0C1EwNSzBay9Wz5U374mGL5bcJRuMGCZp3RgefPzVOZqpTHNS6NFUh5HP9NCrx7BhEFet8b6oM15VMDI2nTAQ+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724658606; c=relaxed/simple;
	bh=Me+sXLMAt0e4V9Aix/YjWYVNR7rJC9NjyBf9tW/U6ag=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=d7rcX7XeOn2BqyFGeFx2gbNfgaBqRBobIyBN4YlkTRThnizHkSo1wb6iqK7m4dNPNxJyz8SXsPAVi6zlmbxNFXGJMtl1zmALlTJoKXYXiPj4MzIpjz4A/y8gL0z9pKtB8meE5kDe1dPedZsOe1Go0iED+JY5AUkzKfGxRt9p0ZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4WsjWL4k5Dz4f3jkK;
	Mon, 26 Aug 2024 15:49:50 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 84CE11A07B6;
	Mon, 26 Aug 2024 15:50:00 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgAHL4WaM8xmWWIECw--.13849S33;
	Mon, 26 Aug 2024 15:50:00 +0800 (CST)
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
Subject: [PATCH md-6.12 v2 29/42] md/md-bitmap: mrege md_bitmap_cond_end_sync() into bitmap_operations
Date: Mon, 26 Aug 2024 15:44:39 +0800
Message-Id: <20240826074452.1490072-30-yukuai1@huaweicloud.com>
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
X-CM-TRANSID:gCh0CgAHL4WaM8xmWWIECw--.13849S33
X-Coremail-Antispam: 1UD129KBjvJXoWxXFykAFyDAw13Jry5JrWrKrg_yoWrZw1Dpa
	1DtFy3C345WFW5Xa4UA3yDCFyFy3s7trZrKryxu34fuFyqgrnrGF4rGFyjq3WDKF13JFZ0
	qwn8Kr45Crn8Xr7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUP014x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
	kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
	z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Cr1j6r
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

Also change the parameter from bitmap to mddev, to avoid access
bitmap outside md-bitmap.c as much as possible.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/md-bitmap.c | 6 ++++--
 drivers/md/md-bitmap.h | 2 +-
 drivers/md/raid1.c     | 6 +++---
 drivers/md/raid10.c    | 2 +-
 drivers/md/raid5.c     | 2 +-
 5 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index e1dceff2d9a5..2d9d9689f721 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -1690,10 +1690,12 @@ static void bitmap_close_sync(struct mddev *mddev)
 	}
 }
 
-void md_bitmap_cond_end_sync(struct bitmap *bitmap, sector_t sector, bool force)
+static void bitmap_cond_end_sync(struct mddev *mddev, sector_t sector,
+				 bool force)
 {
 	sector_t s = 0;
 	sector_t blocks;
+	struct bitmap *bitmap = mddev->bitmap;
 
 	if (!bitmap)
 		return;
@@ -1718,7 +1720,6 @@ void md_bitmap_cond_end_sync(struct bitmap *bitmap, sector_t sector, bool force)
 	bitmap->last_end_sync = jiffies;
 	sysfs_notify_dirent_safe(bitmap->mddev->sysfs_completed);
 }
-EXPORT_SYMBOL(md_bitmap_cond_end_sync);
 
 void md_bitmap_sync_with_cluster(struct mddev *mddev,
 			      sector_t old_lo, sector_t old_hi,
@@ -2747,6 +2748,7 @@ static struct bitmap_operations bitmap_ops = {
 	.endwrite		= bitmap_endwrite,
 	.start_sync		= bitmap_start_sync,
 	.end_sync		= bitmap_end_sync,
+	.cond_end_sync		= bitmap_cond_end_sync,
 	.close_sync		= bitmap_close_sync,
 
 	.update_sb		= bitmap_update_sb,
diff --git a/drivers/md/md-bitmap.h b/drivers/md/md-bitmap.h
index 5d919b530317..027de097f96a 100644
--- a/drivers/md/md-bitmap.h
+++ b/drivers/md/md-bitmap.h
@@ -262,6 +262,7 @@ struct bitmap_operations {
 	bool (*start_sync)(struct mddev *mddev, sector_t offset,
 			   sector_t *blocks, bool degraded);
 	void (*end_sync)(struct mddev *mddev, sector_t offset, sector_t *blocks);
+	void (*cond_end_sync)(struct mddev *mddev, sector_t sector, bool force);
 	void (*close_sync)(struct mddev *mddev);
 
 	void (*update_sb)(struct bitmap *bitmap);
@@ -272,7 +273,6 @@ struct bitmap_operations {
 void mddev_set_bitmap_ops(struct mddev *mddev);
 
 /* these are exported */
-void md_bitmap_cond_end_sync(struct bitmap *bitmap, sector_t sector, bool force);
 void md_bitmap_sync_with_cluster(struct mddev *mddev,
 				 sector_t old_lo, sector_t old_hi,
 				 sector_t new_lo, sector_t new_hi);
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 52ca5619d9b4..00174cacb1f4 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -2828,9 +2828,9 @@ static sector_t raid1_sync_request(struct mddev *mddev, sector_t sector_nr,
 	 * sector_nr + two times RESYNC_SECTORS
 	 */
 
-	md_bitmap_cond_end_sync(mddev->bitmap, sector_nr,
-		mddev_is_clustered(mddev) && (sector_nr + 2 * RESYNC_SECTORS > conf->cluster_sync_high));
-
+	mddev->bitmap_ops->cond_end_sync(mddev, sector_nr,
+		mddev_is_clustered(mddev) &&
+		(sector_nr + 2 * RESYNC_SECTORS > conf->cluster_sync_high));
 
 	if (raise_barrier(conf, sector_nr))
 		return 0;
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 5b1c86c368b1..5a7b19f48c45 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -3543,7 +3543,7 @@ static sector_t raid10_sync_request(struct mddev *mddev, sector_t sector_nr,
 		 * safety reason, which ensures curr_resync_completed is
 		 * updated in bitmap_cond_end_sync.
 		 */
-		md_bitmap_cond_end_sync(mddev->bitmap, sector_nr,
+		mddev->bitmap_ops->cond_end_sync(mddev, sector_nr,
 					mddev_is_clustered(mddev) &&
 					(sector_nr + 2 * RESYNC_SECTORS > conf->cluster_sync_high));
 
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index d2b8d2517abf..87b8d19ab601 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -6540,7 +6540,7 @@ static inline sector_t raid5_sync_request(struct mddev *mddev, sector_t sector_n
 		return sync_blocks * RAID5_STRIPE_SECTORS(conf);
 	}
 
-	md_bitmap_cond_end_sync(mddev->bitmap, sector_nr, false);
+	mddev->bitmap_ops->cond_end_sync(mddev, sector_nr, false);
 
 	sh = raid5_get_active_stripe(conf, NULL, sector_nr,
 				     R5_GAS_NOBLOCK);
-- 
2.39.2

