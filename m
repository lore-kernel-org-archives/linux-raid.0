Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B34BB17CA02;
	Mon, 26 Aug 2024 07:50:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724658610; cv=none; b=EH4B+1lnDqzdGP2NqjGrqACXm8P37f4eWOSKDpIDJqFJv9A0hPx1W7MGkaXVqo6HVTPdPcGwkHMiD+H5Tnflx0jCKcZ023s2dDB7/7vb+8bj4PSpc5V/WomRCCuTBUbLBxnTWJ7Dw6v4lXb1D5ZbyR6KRr6MCoEZgrjphkijlHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724658610; c=relaxed/simple;
	bh=/uRr+LNt7Mu9JuTv7IyVvLSqNX+/K893VkWgmeLpbMs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=M9vcnm4G2RGZDuGnO2J/GLQLqS2G83BMq3ZXHnej6xWSz7tski04oL7gBhnFUrjO4qDH2hqGO9qh+hmaoPf3d/v+iteZmi4/BwL/6Cu+G9XiidVCKbB2TsHWgRyu+53BjXH7WRsMi3YXmGI6tXNV0VHJMChmfbGGHLGh94Xef2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4WsjWJ3xGYz4f3jQv;
	Mon, 26 Aug 2024 15:49:48 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 04B661A0359;
	Mon, 26 Aug 2024 15:50:03 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgAHL4WaM8xmWWIECw--.13849S39;
	Mon, 26 Aug 2024 15:50:02 +0800 (CST)
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
Subject: [PATCH md-6.12 v2 35/42] md/md-bitmap: merge md_bitmap_resize() into bitmap_operations
Date: Mon, 26 Aug 2024 15:44:45 +0800
Message-Id: <20240826074452.1490072-36-yukuai1@huaweicloud.com>
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
X-CM-TRANSID:gCh0CgAHL4WaM8xmWWIECw--.13849S39
X-Coremail-Antispam: 1UD129KBjvJXoW3JFWfKFyrGFyUJw1xXryfCrg_yoWxJr4Upa
	17tFy3C345GrW5Wa1UXFykuFyrtw1ktr9rtryxC34fWF9rXF9rZF4rWFW0qF1UKa45XFnx
	Xan8trW5uF1xXF7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/dm-raid.c    |  3 ++-
 drivers/md/md-bitmap.c  |  6 +++---
 drivers/md/md-bitmap.h  |  5 +++--
 drivers/md/md-cluster.c |  5 +++--
 drivers/md/raid1.c      |  2 +-
 drivers/md/raid10.c     | 10 +++++-----
 drivers/md/raid5.c      |  2 +-
 7 files changed, 18 insertions(+), 15 deletions(-)

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
index c2292546d6ce..0506b54f6322 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -2374,8 +2374,8 @@ static int __bitmap_resize(struct bitmap *bitmap, sector_t blocks,
 	return ret;
 }
 
-int md_bitmap_resize(struct mddev *mddev, sector_t blocks, int chunksize,
-		     bool init)
+static int bitmap_resize(struct mddev *mddev, sector_t blocks, int chunksize,
+			 bool init)
 {
 	struct bitmap *bitmap = mddev->bitmap;
 
@@ -2384,7 +2384,6 @@ int md_bitmap_resize(struct mddev *mddev, sector_t blocks, int chunksize,
 
 	return __bitmap_resize(bitmap, blocks, chunksize, init);
 }
-EXPORT_SYMBOL_GPL(md_bitmap_resize);
 
 static ssize_t
 location_show(struct mddev *mddev, char *page)
@@ -2763,6 +2762,7 @@ const struct attribute_group md_bitmap_group = {
 
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

