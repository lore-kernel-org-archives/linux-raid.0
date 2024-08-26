Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26E8E155A30;
	Mon, 26 Aug 2024 07:50:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724658604; cv=none; b=lCyigx+js/Zj+Xti8eHGpetNQ7PwLkIwtvpLxQxPA/LZN3QkDHZybqqbxEe5X2oKTaFwN1L2IUpvM0F0mx6UylpNE+yB5F4jQYYxymxqK1UZx5MxesRK6CsdIbrzqA2NCTRpWtGzcm7PIj9o0Ob5aSf7RQNUGK/4+HFkkSdGaNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724658604; c=relaxed/simple;
	bh=dloyJYvjzMaO08n2Ow6LAgJAH6KRRtmGl4+SO3GM22I=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=RfSB9Fsg18Kn9S78w5bFQikdogmk9sNcf8CyPPyUqf/rB5Q73GRuUvnkhLF7HreXlOJx+Pimp7vb75VVe4cCEeb+L1Cj8Eg2CKu5Kk57L7Z1Gs0dcDv2r4UwVgWT5SmfaTA1uod5jU5qoWE/sFcma9rFm3PqTuA29DBzM0Ts844=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=none smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4WsjWK35Jnz4f3jk1;
	Mon, 26 Aug 2024 15:49:49 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 4A6321A0568;
	Mon, 26 Aug 2024 15:49:59 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgAHL4WaM8xmWWIECw--.13849S30;
	Mon, 26 Aug 2024 15:49:59 +0800 (CST)
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
Subject: [PATCH md-6.12 v2 26/42] md/md-bitmap: remove the parameter 'aborted' for md_bitmap_end_sync()
Date: Mon, 26 Aug 2024 15:44:36 +0800
Message-Id: <20240826074452.1490072-27-yukuai1@huaweicloud.com>
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
X-CM-TRANSID:gCh0CgAHL4WaM8xmWWIECw--.13849S30
X-Coremail-Antispam: 1UD129KBjvJXoW3WFW3ury8KF17tFyUJw1xuFg_yoW7WF4kpa
	yDJFy3G345WFW3X3WUA3yDCFyFyas7tr9rtFyfW3s3uFy8WFnxGF48Ga4jq3WqkF13AFs0
	qwn8JrW5CFyUXFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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

For internal callers, aborted are always set to false, while for
external callers, aborted are always set to true.

Hence there is no need to always pass in true for exported api.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/md-bitmap.c | 15 +++++++++++----
 drivers/md/md-bitmap.h |  3 ++-
 drivers/md/raid1.c     |  4 ++--
 drivers/md/raid10.c    |  4 ++--
 drivers/md/raid5.c     |  2 +-
 5 files changed, 18 insertions(+), 10 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index 57a4bae50e9c..7e810fc2852e 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -1634,7 +1634,8 @@ static bool bitmap_start_sync(struct mddev *mddev, sector_t offset,
 	return rv;
 }
 
-void md_bitmap_end_sync(struct bitmap *bitmap, sector_t offset, sector_t *blocks, int aborted)
+static void __bitmap_end_sync(struct bitmap *bitmap, sector_t offset,
+			      sector_t *blocks, bool aborted)
 {
 	bitmap_counter_t *bmc;
 	unsigned long flags;
@@ -1663,6 +1664,12 @@ void md_bitmap_end_sync(struct bitmap *bitmap, sector_t offset, sector_t *blocks
  unlock:
 	spin_unlock_irqrestore(&bitmap->counts.lock, flags);
 }
+
+void md_bitmap_end_sync(struct bitmap *bitmap, sector_t offset,
+			sector_t *blocks)
+{
+	__bitmap_end_sync(bitmap, offset, blocks, true);
+}
 EXPORT_SYMBOL(md_bitmap_end_sync);
 
 void md_bitmap_close_sync(struct bitmap *bitmap)
@@ -1676,7 +1683,7 @@ void md_bitmap_close_sync(struct bitmap *bitmap)
 	if (!bitmap)
 		return;
 	while (sector < bitmap->mddev->resync_max_sectors) {
-		md_bitmap_end_sync(bitmap, sector, &blocks, 0);
+		__bitmap_end_sync(bitmap, sector, &blocks, false);
 		sector += blocks;
 	}
 }
@@ -1704,7 +1711,7 @@ void md_bitmap_cond_end_sync(struct bitmap *bitmap, sector_t sector, bool force)
 	sector &= ~((1ULL << bitmap->counts.chunkshift) - 1);
 	s = 0;
 	while (s < sector && s < bitmap->mddev->resync_max_sectors) {
-		md_bitmap_end_sync(bitmap, s, &blocks, 0);
+		__bitmap_end_sync(bitmap, s, &blocks, false);
 		s += blocks;
 	}
 	bitmap->last_end_sync = jiffies;
@@ -1720,7 +1727,7 @@ void md_bitmap_sync_with_cluster(struct mddev *mddev,
 	sector_t sector, blocks = 0;
 
 	for (sector = old_lo; sector < new_lo; ) {
-		md_bitmap_end_sync(bitmap, sector, &blocks, 0);
+		__bitmap_end_sync(bitmap, sector, &blocks, false);
 		sector += blocks;
 	}
 	WARN((blocks > new_lo) && old_lo, "alignment is not correct for lo\n");
diff --git a/drivers/md/md-bitmap.h b/drivers/md/md-bitmap.h
index 67c8f22e8726..6691524bdc80 100644
--- a/drivers/md/md-bitmap.h
+++ b/drivers/md/md-bitmap.h
@@ -270,7 +270,8 @@ struct bitmap_operations {
 void mddev_set_bitmap_ops(struct mddev *mddev);
 
 /* these are exported */
-void md_bitmap_end_sync(struct bitmap *bitmap, sector_t offset, sector_t *blocks, int aborted);
+void md_bitmap_end_sync(struct bitmap *bitmap, sector_t offset,
+			sector_t *blocks);
 void md_bitmap_close_sync(struct bitmap *bitmap);
 void md_bitmap_cond_end_sync(struct bitmap *bitmap, sector_t sector, bool force);
 void md_bitmap_sync_with_cluster(struct mddev *mddev,
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 3e50f85852d0..dd7e3011a6e6 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -2039,7 +2039,7 @@ static void abort_sync_write(struct mddev *mddev, struct r1bio *r1_bio)
 
 	/* make sure these bits don't get cleared. */
 	do {
-		md_bitmap_end_sync(mddev->bitmap, s, &sync_blocks, 1);
+		md_bitmap_end_sync(mddev->bitmap, s, &sync_blocks);
 		s += sync_blocks;
 		sectors_to_go -= sync_blocks;
 	} while (sectors_to_go > 0);
@@ -2786,7 +2786,7 @@ static sector_t raid1_sync_request(struct mddev *mddev, sector_t sector_nr,
 		 */
 		if (mddev->curr_resync < max_sector) /* aborted */
 			md_bitmap_end_sync(mddev->bitmap, mddev->curr_resync,
-					   &sync_blocks, 1);
+					   &sync_blocks);
 		else /* completed sync */
 			conf->fullsync = 0;
 
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index d88878741ed4..33372d30fa99 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -3195,12 +3195,12 @@ static sector_t raid10_sync_request(struct mddev *mddev, sector_t sector_nr,
 		if (mddev->curr_resync < max_sector) { /* aborted */
 			if (test_bit(MD_RECOVERY_SYNC, &mddev->recovery))
 				md_bitmap_end_sync(mddev->bitmap, mddev->curr_resync,
-						   &sync_blocks, 1);
+						   &sync_blocks);
 			else for (i = 0; i < conf->geo.raid_disks; i++) {
 				sector_t sect =
 					raid10_find_virt(conf, mddev->curr_resync, i);
 				md_bitmap_end_sync(mddev->bitmap, sect,
-						   &sync_blocks, 1);
+						   &sync_blocks);
 			}
 		} else {
 			/* completed sync */
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 313904dd6555..3e9fed1e1153 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -6498,7 +6498,7 @@ static inline sector_t raid5_sync_request(struct mddev *mddev, sector_t sector_n
 
 		if (mddev->curr_resync < max_sector) /* aborted */
 			md_bitmap_end_sync(mddev->bitmap, mddev->curr_resync,
-					   &sync_blocks, 1);
+					   &sync_blocks);
 		else /* completed sync */
 			conf->fullsync = 0;
 		md_bitmap_close_sync(mddev->bitmap);
-- 
2.39.2

