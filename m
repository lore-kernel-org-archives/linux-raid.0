Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C71515AD96;
	Wed, 14 Aug 2024 07:15:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723619744; cv=none; b=WDjL30TsGcZzWdO5dLMQNmXMLouAe1nNsnjGFs75jOpt2EbXy8oooXrHQDCo9ksJQliOuTZJ2fGN3rHFOiGIwjx2u0qgjdepqP1vPB5RCUu+rytMO+qBkKs7XD4rdddNOjP2b42cA6qnm/PeB5Y6ZgMKFq5EmaoKopcWiLibmDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723619744; c=relaxed/simple;
	bh=kfPUOBX5myP5ZAJ7cMLo81iumeHhKtPIn3/NgRLmBdM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ZrikbMHQSCeauV1yyuCqq17aTlALqeBzKdyKRaga4cuzK/Ddc1G+MiMoZgAS+u/OUBOM2vGRpUy6hcuiW6BnUfrsZR4LA1qG0i+P+AP5Y/XcT4IGFEPdYsBGPfn38RNAFzW1leD6cwvkF3QxTZctiyfDL2mNBaskCcgUJwV1eFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4WkKK94sWrz4f3jMs;
	Wed, 14 Aug 2024 15:15:25 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 6CCD31A018D;
	Wed, 14 Aug 2024 15:15:39 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgBHboSLWbxmIxKbBg--.47745S37;
	Wed, 14 Aug 2024 15:15:39 +0800 (CST)
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
Subject: [PATCH RFC -next v2 33/41] md/md-bitmap: pass in mddev directly for md_bitmap_resize()
Date: Wed, 14 Aug 2024 15:11:05 +0800
Message-Id: <20240814071113.346781-34-yukuai1@huaweicloud.com>
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
X-CM-TRANSID:gCh0CgBHboSLWbxmIxKbBg--.47745S37
X-Coremail-Antispam: 1UD129KBjvJXoW3GFy5KFW3Zw45Wr18WF4xCrg_yoWxuw4Dpa
	y7JF9xCry5GrW5Ww15ZFykuFyFq34Dtr9rtryxu34ruFy7WF9xAF4rWFy0qF1UWa4rJF45
	Xan8JrWUCF1kXF7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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

And move the condition "if (mddev->bitmap)" into md_bitmap_resize() as
well, on the one hand make code cleaner, on the other hand try not to
access bitmap directly.

Since we are here, also change the parameter 'init' from int to bool.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/dm-raid.c    |  2 +-
 drivers/md/md-bitmap.c  | 10 +++++++---
 drivers/md/md-bitmap.h  |  4 ++--
 drivers/md/md-cluster.c |  4 ++--
 drivers/md/raid1.c      | 12 +++++++-----
 drivers/md/raid10.c     | 17 +++++++++--------
 drivers/md/raid5.c      | 11 ++++++-----
 7 files changed, 34 insertions(+), 26 deletions(-)

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index c3e201fde4c5..cc071fcd7a04 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -4068,7 +4068,7 @@ static int raid_preresume(struct dm_target *ti)
 	       mddev->bitmap_info.chunksize != to_bytes(rs->requested_bitmap_chunk_sectors)))) {
 		int chunksize = to_bytes(rs->requested_bitmap_chunk_sectors) ?: mddev->bitmap_info.chunksize;
 
-		r = md_bitmap_resize(mddev->bitmap, mddev->dev_sectors, chunksize, 0);
+		r = md_bitmap_resize(mddev, mddev->dev_sectors, chunksize, false);
 		if (r)
 			DMERR("Failed to resize bitmap");
 	}
diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index a1f57f751b55..04f32f18e734 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -1975,7 +1975,7 @@ static struct bitmap *__bitmap_create(struct mddev *mddev, int slot)
 		goto error;
 
 	bitmap->daemon_lastrun = jiffies;
-	err = md_bitmap_resize(bitmap, blocks, mddev->bitmap_info.chunksize, 1);
+	err = md_bitmap_resize(mddev, blocks, mddev->bitmap_info.chunksize, true);
 	if (err)
 		goto error;
 
@@ -2160,8 +2160,8 @@ static int bitmap_get_stats(struct bitmap *bitmap, struct md_bitmap_stats *stats
 	return 0;
 }
 
-int md_bitmap_resize(struct bitmap *bitmap, sector_t blocks,
-		  int chunksize, int init)
+int md_bitmap_resize(struct mddev *mddev, sector_t blocks, int chunksize,
+		     bool init)
 {
 	/* If chunk_size is 0, choose an appropriate chunk size.
 	 * Then possibly allocate new storage space.
@@ -2182,6 +2182,10 @@ int md_bitmap_resize(struct bitmap *bitmap, sector_t blocks,
 	int ret = 0;
 	long pages;
 	struct bitmap_page *new_bp;
+	struct bitmap *bitmap = mddev->bitmap;
+
+	if (!bitmap)
+		return 0;
 
 	if (bitmap->storage.file && !init) {
 		pr_info("md: cannot resize file-based bitmap\n");
diff --git a/drivers/md/md-bitmap.h b/drivers/md/md-bitmap.h
index b4c3e4faf288..ffb6e027dfff 100644
--- a/drivers/md/md-bitmap.h
+++ b/drivers/md/md-bitmap.h
@@ -279,8 +279,8 @@ void mddev_set_bitmap_ops(struct mddev *mddev);
 
 /* these are exported */
 
-int md_bitmap_resize(struct bitmap *bitmap, sector_t blocks,
-		     int chunksize, int init);
+int md_bitmap_resize(struct mddev *mddev, sector_t blocks, int chunksize,
+		     bool init);
 struct bitmap *get_bitmap_from_slot(struct mddev *mddev, int slot);
 int md_bitmap_copy_from_slot(struct mddev *mddev, int slot,
 			     sector_t *lo, sector_t *hi, bool clear_bits);
diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
index b36b9f449f9d..d0f9ff7bd663 100644
--- a/drivers/md/md-cluster.c
+++ b/drivers/md/md-cluster.c
@@ -628,8 +628,8 @@ static int process_recvd_msg(struct mddev *mddev, struct cluster_msg *msg)
 		break;
 	case BITMAP_RESIZE:
 		if (le64_to_cpu(msg->high) != mddev->pers->size(mddev, 0, 0))
-			ret = md_bitmap_resize(mddev->bitmap,
-					    le64_to_cpu(msg->high), 0, 0);
+			ret = md_bitmap_resize(mddev, le64_to_cpu(msg->high), 0,
+					       false);
 		break;
 	default:
 		ret = -1;
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 3dedb7fd74c4..ba5df105d735 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -3309,14 +3309,16 @@ static int raid1_resize(struct mddev *mddev, sector_t sectors)
 	 * worth it.
 	 */
 	sector_t newsize = raid1_size(mddev, sectors, 0);
+	int ret;
+
 	if (mddev->external_size &&
 	    mddev->array_sectors > newsize)
 		return -EINVAL;
-	if (mddev->bitmap) {
-		int ret = md_bitmap_resize(mddev->bitmap, newsize, 0, 0);
-		if (ret)
-			return ret;
-	}
+
+	ret = md_bitmap_resize(mddev, newsize, 0, false);
+	if (ret)
+		return ret;
+
 	md_set_array_sectors(mddev, newsize);
 	if (sectors > mddev->dev_sectors &&
 	    mddev->recovery_cp > mddev->dev_sectors) {
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 085a85945a42..343c9bcc3104 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -4196,6 +4196,7 @@ static int raid10_resize(struct mddev *mddev, sector_t sectors)
 	 */
 	struct r10conf *conf = mddev->private;
 	sector_t oldsize, size;
+	int ret;
 
 	if (mddev->reshape_position != MaxSector)
 		return -EBUSY;
@@ -4208,11 +4209,11 @@ static int raid10_resize(struct mddev *mddev, sector_t sectors)
 	if (mddev->external_size &&
 	    mddev->array_sectors > size)
 		return -EINVAL;
-	if (mddev->bitmap) {
-		int ret = md_bitmap_resize(mddev->bitmap, size, 0, 0);
-		if (ret)
-			return ret;
-	}
+
+	ret = md_bitmap_resize(mddev, size, 0, false);
+	if (ret)
+		return ret;
+
 	md_set_array_sectors(mddev, size);
 	if (sectors > mddev->dev_sectors &&
 	    mddev->recovery_cp > oldsize) {
@@ -4478,7 +4479,7 @@ static int raid10_start_reshape(struct mddev *mddev)
 		newsize = raid10_size(mddev, 0, conf->geo.raid_disks);
 
 		if (!mddev_is_clustered(mddev)) {
-			ret = md_bitmap_resize(mddev->bitmap, newsize, 0, 0);
+			ret = md_bitmap_resize(mddev, newsize, 0, false);
 			if (ret)
 				goto abort;
 			else
@@ -4500,13 +4501,13 @@ static int raid10_start_reshape(struct mddev *mddev)
 			    MD_FEATURE_RESHAPE_ACTIVE)) || (oldsize == newsize))
 			goto out;
 
-		ret = md_bitmap_resize(mddev->bitmap, newsize, 0, 0);
+		ret = md_bitmap_resize(mddev, newsize, 0, false);
 		if (ret)
 			goto abort;
 
 		ret = md_cluster_ops->resize_bitmaps(mddev, newsize, oldsize);
 		if (ret) {
-			md_bitmap_resize(mddev->bitmap, oldsize, 0, 0);
+			md_bitmap_resize(mddev, oldsize, 0, false);
 			goto abort;
 		}
 	}
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 91b610d11c6a..47c89f7b1dfe 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -8313,6 +8313,7 @@ static int raid5_resize(struct mddev *mddev, sector_t sectors)
 	 */
 	sector_t newsize;
 	struct r5conf *conf = mddev->private;
+	int ret;
 
 	if (raid5_has_log(conf) || raid5_has_ppl(conf))
 		return -EINVAL;
@@ -8321,11 +8322,11 @@ static int raid5_resize(struct mddev *mddev, sector_t sectors)
 	if (mddev->external_size &&
 	    mddev->array_sectors > newsize)
 		return -EINVAL;
-	if (mddev->bitmap) {
-		int ret = md_bitmap_resize(mddev->bitmap, sectors, 0, 0);
-		if (ret)
-			return ret;
-	}
+
+	ret = md_bitmap_resize(mddev, sectors, 0, false);
+	if (ret)
+		return ret;
+
 	md_set_array_sectors(mddev, newsize);
 	if (sectors > mddev->dev_sectors &&
 	    mddev->recovery_cp > mddev->dev_sectors) {
-- 
2.39.2

