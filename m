Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E356113C918;
	Wed, 14 Aug 2024 07:15:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723619742; cv=none; b=crNlJNCfJo72/OafIz5AdqYDIPSWb1e+4PJqkABMZTzVZV7iQCp95nLZipQRBjGmWfEk10CjBw5h2D7SwUDfu3esxpgZRKIHy7WBv/w9gEYI4qu70zVzeSmDM0dvAttHoZzM0M82j7perdCw0ZfIwqGWLZ+KwTqucnpAZ2NWK+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723619742; c=relaxed/simple;
	bh=mBBI6Geq5cxIQGZ8bIeTFWXUgZ0D3CJJ0aeiwHIkk1Y=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=CJ4PKxF1I93TK6T9vHdo3tSKKV16Cc5oXYrtZCliJjZdpHeuWrNqSQClM8662zvtvF8y7FKiS+LcwOA/5fA56it1UE5iEtv3QUD73Fn1la9wpTd52hX9dULCxT+otwnM/2adKVR3SzbomTDsWsmSwF67m0UUVMRhWKsZgoq9InU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4WkKKC4fRpz4f3jZL;
	Wed, 14 Aug 2024 15:15:27 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 002281A018D;
	Wed, 14 Aug 2024 15:15:36 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgBHboSLWbxmIxKbBg--.47745S31;
	Wed, 14 Aug 2024 15:15:36 +0800 (CST)
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
Subject: [PATCH RFC -next v2 27/41] md/md-bitmap: merge md_bitmap_close_sync() into bitmap_operations
Date: Wed, 14 Aug 2024 15:10:59 +0800
Message-Id: <20240814071113.346781-28-yukuai1@huaweicloud.com>
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
X-CM-TRANSID:gCh0CgBHboSLWbxmIxKbBg--.47745S31
X-Coremail-Antispam: 1UD129KBjvJXoWxXFykAFyDAFW8Jr1rKFWrGrg_yoWrZF1kpa
	1DJFy3C345WFW3Xa4UA34Dua4Fvas7tr9rKryfW3s3WFykXF9xGF4rGa4jq3WqgF13AFs8
	Zwn8trW5CryUXFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUPY14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
	kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
	z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F
	4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq
	3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7
	IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4U
	M4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCY1x0262kKe7AKxVWUtV
	W8ZwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v2
	6r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2
	Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVW5JVW7JwCI42IY6xIIjxv20xvEc7CjxVAFwI0_
	Gr1j6F4UJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Gr0_Cr
	1lIxAIcVC2z280aVCY1x0267AKxVW8Jr0_Cr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUQFxUU
	UUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

So that the implementation won't be exposed, and it'll be possible
to invent a new bitmap by replacing bitmap_operations.

Also change the parameter from bitmap to mddev, to avoid access
bitmap outside md-bitmap.c as much as possible.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/md-bitmap.c | 9 ++++++---
 drivers/md/md-bitmap.h | 2 +-
 drivers/md/raid1.c     | 2 +-
 drivers/md/raid10.c    | 2 +-
 drivers/md/raid5.c     | 2 +-
 5 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index b3649f1d1200..ed814bcb1933 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -1671,7 +1671,7 @@ static void bitmap_end_sync(struct mddev *mddev, sector_t offset,
 	__bitmap_end_sync(mddev->bitmap, offset, blocks, true);
 }
 
-void md_bitmap_close_sync(struct bitmap *bitmap)
+static void bitmap_close_sync(struct mddev *mddev)
 {
 	/* Sync has finished, and any bitmap chunks that weren't synced
 	 * properly have been aborted.  It remains to us to clear the
@@ -1679,14 +1679,16 @@ void md_bitmap_close_sync(struct bitmap *bitmap)
 	 */
 	sector_t sector = 0;
 	sector_t blocks;
+	struct bitmap *bitmap = mddev->bitmap;
+
 	if (!bitmap)
 		return;
+
 	while (sector < bitmap->mddev->resync_max_sectors) {
 		__bitmap_end_sync(bitmap, sector, &blocks, false);
 		sector += blocks;
 	}
 }
-EXPORT_SYMBOL(md_bitmap_close_sync);
 
 void md_bitmap_cond_end_sync(struct bitmap *bitmap, sector_t sector, bool force)
 {
@@ -2017,7 +2019,7 @@ static int bitmap_load(struct mddev *mddev)
 		bitmap_start_sync(mddev, sector, &blocks, false);
 		sector += blocks;
 	}
-	md_bitmap_close_sync(bitmap);
+	bitmap_close_sync(mddev);
 
 	if (mddev->degraded == 0
 	    || bitmap->events_cleared == mddev->events)
@@ -2742,6 +2744,7 @@ static struct bitmap_operations bitmap_ops = {
 	.endwrite		= bitmap_endwrite,
 	.start_sync		= bitmap_start_sync,
 	.end_sync		= bitmap_end_sync,
+	.close_sync		= bitmap_close_sync,
 
 	.update_sb		= bitmap_update_sb,
 	.get_stats		= bitmap_get_stats,
diff --git a/drivers/md/md-bitmap.h b/drivers/md/md-bitmap.h
index ff0ca61147e9..47e157d9f6be 100644
--- a/drivers/md/md-bitmap.h
+++ b/drivers/md/md-bitmap.h
@@ -261,6 +261,7 @@ struct bitmap_operations {
 	bool (*start_sync)(struct mddev *mddev, sector_t offset,
 			   sector_t *blocks, bool degraded);
 	void (*end_sync)(struct mddev *mddev, sector_t offset, sector_t *blocks);
+	void (*close_sync)(struct mddev *mddev);
 
 	void (*update_sb)(struct bitmap *bitmap);
 	int (*get_stats)(struct bitmap *bitmap, struct md_bitmap_stats *stats);
@@ -270,7 +271,6 @@ struct bitmap_operations {
 void mddev_set_bitmap_ops(struct mddev *mddev);
 
 /* these are exported */
-void md_bitmap_close_sync(struct bitmap *bitmap);
 void md_bitmap_cond_end_sync(struct bitmap *bitmap, sector_t sector, bool force);
 void md_bitmap_sync_with_cluster(struct mddev *mddev,
 				 sector_t old_lo, sector_t old_hi,
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index e7e9e52db795..fffd94119f0a 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -2789,7 +2789,7 @@ static sector_t raid1_sync_request(struct mddev *mddev, sector_t sector_nr,
 		else /* completed sync */
 			conf->fullsync = 0;
 
-		md_bitmap_close_sync(mddev->bitmap);
+		mddev->bitmap_ops->close_sync(mddev);
 		close_sync(conf);
 
 		if (mddev_is_clustered(mddev)) {
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 694522fb5584..10df08394ebb 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -3222,7 +3222,7 @@ static sector_t raid10_sync_request(struct mddev *mddev, sector_t sector_nr,
 			}
 			conf->fullsync = 0;
 		}
-		md_bitmap_close_sync(mddev->bitmap);
+		mddev->bitmap_ops->close_sync(mddev);
 		close_sync(conf);
 		*skipped = 1;
 		return sectors_skipped;
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 89ae149bf28e..d2b8d2517abf 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -6501,7 +6501,7 @@ static inline sector_t raid5_sync_request(struct mddev *mddev, sector_t sector_n
 						    &sync_blocks);
 		else /* completed sync */
 			conf->fullsync = 0;
-		md_bitmap_close_sync(mddev->bitmap);
+		mddev->bitmap_ops->close_sync(mddev);
 
 		return 0;
 	}
-- 
2.39.2

