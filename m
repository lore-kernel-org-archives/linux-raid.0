Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35EFE183CCE;
	Thu, 22 Aug 2024 02:52:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724295140; cv=none; b=rAaVRLqzwbzTsLX5ZaL0Iv0iA1vhUhDrnm++xSlkAJ7Lz0vB/6AtwExJ+46LBmgVI17ET1adIwE7i/bM3OYRL9n2WMlrmx/aOWpvwg5zB615CBqUocT0H5TA1Oo1oOHYfUg+SDbnYp+1EhxBoZZqwaYBtyFpFjsgdxQALNStvmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724295140; c=relaxed/simple;
	bh=flwhlDuQk1SYS6JY37ZMVHFL066yKLExs8l6tOaNVKY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=HzBwDwjjZxxj1CddZWSqup06MfWgvcs8IBMvijxrCs3ZDWBH5rhh1L1uPBfpHcGczod387S0PWPcmivnQOQGVZ+/YuaTcI5+zQMCZode81sIcAaOCa2w1QTcNfo5xtMdAjMOpUfH7qK8UAN/2LzOxi5X+ZwK2qVB00SjIfZcCP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4Wq75Y1KVfz4f3jsJ;
	Thu, 22 Aug 2024 10:52:01 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 64F2F1A018D;
	Thu, 22 Aug 2024 10:52:15 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgAXPoTNp8ZmyXl2CQ--.42363S38;
	Thu, 22 Aug 2024 10:52:15 +0800 (CST)
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
Subject: [PATCH md-6.12 34/41] md/md-bitmap: merge md_bitmap_resize() into bitmap_operations
Date: Thu, 22 Aug 2024 10:47:11 +0800
Message-Id: <20240822024718.2158259-35-yukuai1@huaweicloud.com>
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
X-CM-TRANSID:gCh0CgAXPoTNp8ZmyXl2CQ--.42363S38
X-Coremail-Antispam: 1UD129KBjvJXoWxKw4kury8XF1UWFWUurWkXrb_yoWxCrWfpa
	17ta43C345GrW5Wa1UXFykuFyFqw1ktr9rtryxC34fuF9rXF9xZF4rWFW0qF1UGa45XFsx
	Xan8JrW5CF1xXF7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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
index 4925b685c546..160b0bd54de8 100644
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
 
@@ -2163,8 +2166,8 @@ static int bitmap_get_stats(struct bitmap *bitmap, struct md_bitmap_stats *stats
 	return 0;
 }
 
-int md_bitmap_resize(struct mddev *mddev, sector_t blocks, int chunksize,
-		     bool init)
+static int bitmap_resize(struct mddev *mddev, sector_t blocks, int chunksize,
+			 bool init)
 {
 	/* If chunk_size is 0, choose an appropriate chunk size.
 	 * Then possibly allocate new storage space.
@@ -2373,7 +2376,6 @@ int md_bitmap_resize(struct mddev *mddev, sector_t blocks, int chunksize,
 err:
 	return ret;
 }
-EXPORT_SYMBOL_GPL(md_bitmap_resize);
 
 static ssize_t
 location_show(struct mddev *mddev, char *page)
@@ -2752,6 +2754,7 @@ const struct attribute_group md_bitmap_group = {
 
 static struct bitmap_operations bitmap_ops = {
 	.create			= bitmap_create,
+	.resize			= bitmap_resize,
 	.load			= bitmap_load,
 	.destroy		= bitmap_destroy,
 	.flush			= bitmap_flush,
diff --git a/drivers/md/md-bitmap.h b/drivers/md/md-bitmap.h
index 4610e50548eb..d05fc2f1451e 100644
--- a/drivers/md/md-bitmap.h
+++ b/drivers/md/md-bitmap.h
@@ -248,6 +248,9 @@ struct md_bitmap_stats {
 
 struct bitmap_operations {
 	int (*create)(struct mddev *mddev, int slot);
+	int (*resize)(struct mddev *mddev, sector_t blocks, int chunksize,
+		      bool init);
+
 	int (*load)(struct mddev *mddev);
 	void (*destroy)(struct mddev *mddev);
 	void (*flush)(struct mddev *mddev);
@@ -280,8 +283,6 @@ void mddev_set_bitmap_ops(struct mddev *mddev);
 
 /* these are exported */
 
-int md_bitmap_resize(struct mddev *mddev, sector_t blocks, int chunksize,
-		     bool init);
 struct bitmap *get_bitmap_from_slot(struct mddev *mddev, int slot);
 int md_bitmap_copy_from_slot(struct mddev *mddev, int slot,
 			     sector_t *lo, sector_t *hi, bool clear_bits);
diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
index a7e5ead71c2f..21cf0f38cbf8 100644
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
index bf20a90c1d17..c3bdc819e5e8 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -3316,7 +3316,7 @@ static int raid1_resize(struct mddev *mddev, sector_t sectors)
 	    mddev->array_sectors > newsize)
 		return -EINVAL;
 
-	ret = md_bitmap_resize(mddev, newsize, 0, false);
+	ret = mddev->bitmap_ops->resize(mddev, newsize, 0, false);
 	if (ret)
 		return ret;
 
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 4512d285b76a..f3bf1116794a 100644
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

