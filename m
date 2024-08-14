Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A85B615B143;
	Wed, 14 Aug 2024 07:15:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723619746; cv=none; b=UOw0y31i6nGer+nX6hqlGMp75NsK8Ad5M5Ni131jV7nm9Id2g+0A/PKDnC0R8QhEaaZzFWZO/IbxI5h6WZGnlWEaOTPUX5rvJhfepXqbg2FbdJbbxvaPfvZ5MWtW5A1Vrq/gQVrCsx2Xn68SH8vSePWoHLKp9bpgTERNb1DukkE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723619746; c=relaxed/simple;
	bh=GQVz2V4nQivFlHCPiVLRvXPPPmW4VhHG3R/MlabDpdo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=XmNk1sXiotoov1Sb8iOqd0+sVGtAwo8mZOZKsMLqCRjdjuPYdi+GSQf03bme1BUz6H4T1FHAxxB3fWbIJOYll2mspFl+/yHYnD8PLt1wmJ6r84mu4mh64O9wULtKaPPFJxkC/Jq7mteKlFDRwpsglNvoO2dZfzQ0h51nyEwVMkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4WkKKB0bs9z4f3jMx;
	Wed, 14 Aug 2024 15:15:26 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id CF7B81A0359;
	Wed, 14 Aug 2024 15:15:39 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgBHboSLWbxmIxKbBg--.47745S38;
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
Subject: [PATCH RFC -next v2 34/41] md/md-bitmap: merge md_bitmap_resize() into bitmap_operations
Date: Wed, 14 Aug 2024 15:11:06 +0800
Message-Id: <20240814071113.346781-35-yukuai1@huaweicloud.com>
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
X-CM-TRANSID:gCh0CgBHboSLWbxmIxKbBg--.47745S38
X-Coremail-Antispam: 1UD129KBjvJXoWxKw4kury8XrW3AF43KrWkCrg_yoWxCrWfpa
	17ta43Cry3GrW5Wa1UZFykuFyFqw1ktr9rtryxC34fWF9rXF9xuF4rWFW0qF1UKa45XFsx
	Xan8trW5CF1xXF7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/dm-raid.c    |  3 ++-
 drivers/md/md-bitmap.c  | 11 +++++++----
 drivers/md/md-bitmap.h  |  5 +++--
 drivers/md/md-cluster.c |  5 +++--
 drivers/md/raid1.c      |  2 +-
 drivers/md/raid10.c     | 10 +++++-----
 drivers/md/raid5.c      |  2 +-
 7 files changed, 22 insertions(+), 16 deletions(-)

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index cc071fcd7a04..63682d27fc8d 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -4068,7 +4068,8 @@ static int raid_preresume(struct dm_target *ti)
 	       mddev->bitmap_info.chunksize != to_bytes(rs->requested_bitmap_chunk_sectors)))) {
 		int chunksize = to_bytes(rs->requested_bitmap_chunk_sectors) ?: mddev->bitmap_info.chunksize;
 
-		r = md_bitmap_resize(mddev, mddev->dev_sectors, chunksize, false);
+		r = mddev->bitmap_ops->resize(mddev, mddev->dev_sectors,
+					      chunksize, false);
 		if (r)
 			DMERR("Failed to resize bitmap");
 	}
diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index 04f32f18e734..4dc48055b18f 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -32,6 +32,9 @@
 #include "md.h"
 #include "md-bitmap.h"
 
+static int bitmap_resize(struct mddev *mddev, sector_t blocks, int chunksize,
+			 bool init);
+
 static inline char *bmname(struct bitmap *bitmap)
 {
 	return bitmap->mddev ? mdname(bitmap->mddev) : "mdX";
@@ -1975,7 +1978,7 @@ static struct bitmap *__bitmap_create(struct mddev *mddev, int slot)
 		goto error;
 
 	bitmap->daemon_lastrun = jiffies;
-	err = md_bitmap_resize(mddev, blocks, mddev->bitmap_info.chunksize, true);
+	err = bitmap_resize(mddev, blocks, mddev->bitmap_info.chunksize, true);
 	if (err)
 		goto error;
 
@@ -2160,8 +2163,8 @@ static int bitmap_get_stats(struct bitmap *bitmap, struct md_bitmap_stats *stats
 	return 0;
 }
 
-int md_bitmap_resize(struct mddev *mddev, sector_t blocks, int chunksize,
-		     bool init)
+static int bitmap_resize(struct mddev *mddev, sector_t blocks, int chunksize,
+			 bool init)
 {
 	/* If chunk_size is 0, choose an appropriate chunk size.
 	 * Then possibly allocate new storage space.
@@ -2370,7 +2373,6 @@ int md_bitmap_resize(struct mddev *mddev, sector_t blocks, int chunksize,
 err:
 	return ret;
 }
-EXPORT_SYMBOL_GPL(md_bitmap_resize);
 
 static ssize_t
 location_show(struct mddev *mddev, char *page)
@@ -2749,6 +2751,7 @@ const struct attribute_group md_bitmap_group = {
 
 static struct bitmap_operations bitmap_ops = {
 	.create			= bitmap_create,
+	.resize			= bitmap_resize,
 	.load			= bitmap_load,
 	.destroy		= bitmap_destroy,
 	.flush			= bitmap_flush,
diff --git a/drivers/md/md-bitmap.h b/drivers/md/md-bitmap.h
index ffb6e027dfff..64ab063734c9 100644
--- a/drivers/md/md-bitmap.h
+++ b/drivers/md/md-bitmap.h
@@ -247,6 +247,9 @@ struct md_bitmap_stats {
 
 struct bitmap_operations {
 	int (*create)(struct mddev *mddev, int slot);
+	int (*resize)(struct mddev *mddev, sector_t blocks, int chunksize,
+		      bool init);
+
 	int (*load)(struct mddev *mddev);
 	void (*destroy)(struct mddev *mddev);
 	void (*flush)(struct mddev *mddev);
@@ -279,8 +282,6 @@ void mddev_set_bitmap_ops(struct mddev *mddev);
 
 /* these are exported */
 
-int md_bitmap_resize(struct mddev *mddev, sector_t blocks, int chunksize,
-		     bool init);
 struct bitmap *get_bitmap_from_slot(struct mddev *mddev, int slot);
 int md_bitmap_copy_from_slot(struct mddev *mddev, int slot,
 			     sector_t *lo, sector_t *hi, bool clear_bits);
diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
index d0f9ff7bd663..2250bd6dddb7 100644
--- a/drivers/md/md-cluster.c
+++ b/drivers/md/md-cluster.c
@@ -628,8 +628,9 @@ static int process_recvd_msg(struct mddev *mddev, struct cluster_msg *msg)
 		break;
 	case BITMAP_RESIZE:
 		if (le64_to_cpu(msg->high) != mddev->pers->size(mddev, 0, 0))
-			ret = md_bitmap_resize(mddev, le64_to_cpu(msg->high), 0,
-					       false);
+			ret = mddev->bitmap_ops->resize(mddev,
+							le64_to_cpu(msg->high),
+							0, false);
 		break;
 	default:
 		ret = -1;
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index ba5df105d735..e285f01e3ef6 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -3315,7 +3315,7 @@ static int raid1_resize(struct mddev *mddev, sector_t sectors)
 	    mddev->array_sectors > newsize)
 		return -EINVAL;
 
-	ret = md_bitmap_resize(mddev, newsize, 0, false);
+	ret = mddev->bitmap_ops->resize(mddev, newsize, 0, false);
 	if (ret)
 		return ret;
 
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 343c9bcc3104..a1e25c250d46 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -4210,7 +4210,7 @@ static int raid10_resize(struct mddev *mddev, sector_t sectors)
 	    mddev->array_sectors > size)
 		return -EINVAL;
 
-	ret = md_bitmap_resize(mddev, size, 0, false);
+	ret = mddev->bitmap_ops->resize(mddev, size, 0, false);
 	if (ret)
 		return ret;
 
@@ -4479,7 +4479,7 @@ static int raid10_start_reshape(struct mddev *mddev)
 		newsize = raid10_size(mddev, 0, conf->geo.raid_disks);
 
 		if (!mddev_is_clustered(mddev)) {
-			ret = md_bitmap_resize(mddev, newsize, 0, false);
+			ret = mddev->bitmap_ops->resize(mddev, newsize, 0, false);
 			if (ret)
 				goto abort;
 			else
@@ -4494,20 +4494,20 @@ static int raid10_start_reshape(struct mddev *mddev)
 
 		/*
 		 * some node is already performing reshape, and no need to
-		 * call md_bitmap_resize again since it should be called when
+		 * call bitmap_ops->resize again since it should be called when
 		 * receiving BITMAP_RESIZE msg
 		 */
 		if ((sb && (le32_to_cpu(sb->feature_map) &
 			    MD_FEATURE_RESHAPE_ACTIVE)) || (oldsize == newsize))
 			goto out;
 
-		ret = md_bitmap_resize(mddev, newsize, 0, false);
+		ret = mddev->bitmap_ops->resize(mddev, newsize, 0, false);
 		if (ret)
 			goto abort;
 
 		ret = md_cluster_ops->resize_bitmaps(mddev, newsize, oldsize);
 		if (ret) {
-			md_bitmap_resize(mddev, oldsize, 0, false);
+			mddev->bitmap_ops->resize(mddev, oldsize, 0, false);
 			goto abort;
 		}
 	}
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 47c89f7b1dfe..c84a7e0263cd 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -8323,7 +8323,7 @@ static int raid5_resize(struct mddev *mddev, sector_t sectors)
 	    mddev->array_sectors > newsize)
 		return -EINVAL;
 
-	ret = md_bitmap_resize(mddev, sectors, 0, false);
+	ret = mddev->bitmap_ops->resize(mddev, sectors, 0, false);
 	if (ret)
 		return ret;
 
-- 
2.39.2

