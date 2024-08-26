Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E35817C98A;
	Mon, 26 Aug 2024 07:50:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724658609; cv=none; b=HF6oE0f0EwWoaN3NxFHSG8wspeCBwKYKTs56jna1se1zeHwj/4JiwGCsafaXw1mzIHiP3BY+WKbnnCJ2NAPrKw+WiP+4k0SWZErMF4S/PmAx9RRMaIx9h5V1RevBxSUHVxnK2rOo/GNlYcqAb7yFxXLNNFAGFL5f9w3g65sd6ss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724658609; c=relaxed/simple;
	bh=s6J/oLgUfbBLMa78aRRSg8yI7VO0lEPIa1k5Z1QiywI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=XrydoGcAWvtxGcVKNUR+iL1TfCGynAF6XEQR2LZ7QhiOxQGEvfajjoaON63Cv6kC/tT5xqTHEQLz2NPa3McIv64KgpUdsEqo8EPWyET9KMpB3ZUk267+LZkpzPshvyiwyuNHp6DeTTHOY07GJh5GieHYu9OBWf/o70q+NZuP9HA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4WsjWJ10rdz4f3jMs;
	Mon, 26 Aug 2024 15:49:48 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 9457B1A0359;
	Mon, 26 Aug 2024 15:50:02 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgAHL4WaM8xmWWIECw--.13849S38;
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
Subject: [PATCH md-6.12 v2 34/42] md/md-bitmap: pass in mddev directly for md_bitmap_resize()
Date: Mon, 26 Aug 2024 15:44:44 +0800
Message-Id: <20240826074452.1490072-35-yukuai1@huaweicloud.com>
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
X-CM-TRANSID:gCh0CgAHL4WaM8xmWWIECw--.13849S38
X-Coremail-Antispam: 1UD129KBjvJXoW3GFy5KFW3ury3tr15tF1kXwb_yoW3Gry7pa
	y7tF9xGry5GrW5Ww15ZFykuFyFq34ktr9rtryxu34ruFy7WF9xAF4rWFy0q3WUWa45JF45
	Xan8JrWUCF1kXF7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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

And move the condition "if (mddev->bitmap)" into md_bitmap_resize() as
well, on the one hand make code cleaner, on the other hand try not to
access bitmap directly.

Since we are here, also change the parameter 'init' from int to bool.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/dm-raid.c    |  2 +-
 drivers/md/md-bitmap.c  | 21 ++++++++++++++++++---
 drivers/md/md-bitmap.h  |  4 ++--
 drivers/md/md-cluster.c |  4 ++--
 drivers/md/raid1.c      | 12 +++++++-----
 drivers/md/raid10.c     | 17 +++++++++--------
 drivers/md/raid5.c      | 11 ++++++-----
 7 files changed, 45 insertions(+), 26 deletions(-)

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
index efe928849c94..c2292546d6ce 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -32,6 +32,9 @@
 #include "md.h"
 #include "md-bitmap.h"
 
+static int __bitmap_resize(struct bitmap *bitmap, sector_t blocks,
+			   int chunksize, bool init);
+
 static inline char *bmname(struct bitmap *bitmap)
 {
 	return bitmap->mddev ? mdname(bitmap->mddev) : "mdX";
@@ -1975,7 +1978,8 @@ static struct bitmap *__bitmap_create(struct mddev *mddev, int slot)
 		goto error;
 
 	bitmap->daemon_lastrun = jiffies;
-	err = md_bitmap_resize(bitmap, blocks, mddev->bitmap_info.chunksize, 1);
+	err = __bitmap_resize(bitmap, blocks, mddev->bitmap_info.chunksize,
+			      true);
 	if (err)
 		goto error;
 
@@ -2163,8 +2167,8 @@ static int bitmap_get_stats(struct bitmap *bitmap, struct md_bitmap_stats *stats
 	return 0;
 }
 
-int md_bitmap_resize(struct bitmap *bitmap, sector_t blocks,
-		  int chunksize, int init)
+static int __bitmap_resize(struct bitmap *bitmap, sector_t blocks,
+			   int chunksize, bool init)
 {
 	/* If chunk_size is 0, choose an appropriate chunk size.
 	 * Then possibly allocate new storage space.
@@ -2369,6 +2373,17 @@ int md_bitmap_resize(struct bitmap *bitmap, sector_t blocks,
 err:
 	return ret;
 }
+
+int md_bitmap_resize(struct mddev *mddev, sector_t blocks, int chunksize,
+		     bool init)
+{
+	struct bitmap *bitmap = mddev->bitmap;
+
+	if (!bitmap)
+		return 0;
+
+	return __bitmap_resize(bitmap, blocks, chunksize, init);
+}
 EXPORT_SYMBOL_GPL(md_bitmap_resize);
 
 static ssize_t
diff --git a/drivers/md/md-bitmap.h b/drivers/md/md-bitmap.h
index 065b36c0c43a..4610e50548eb 100644
--- a/drivers/md/md-bitmap.h
+++ b/drivers/md/md-bitmap.h
@@ -280,8 +280,8 @@ void mddev_set_bitmap_ops(struct mddev *mddev);
 
 /* these are exported */
 
-int md_bitmap_resize(struct bitmap *bitmap, sector_t blocks,
-		     int chunksize, int init);
+int md_bitmap_resize(struct mddev *mddev, sector_t blocks, int chunksize,
+		     bool init);
 struct bitmap *get_bitmap_from_slot(struct mddev *mddev, int slot);
 int md_bitmap_copy_from_slot(struct mddev *mddev, int slot,
 			     sector_t *lo, sector_t *hi, bool clear_bits);
diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
index 55feabe14ad3..a7e5ead71c2f 100644
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
index fe893bdd2c0a..bf20a90c1d17 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -3310,14 +3310,16 @@ static int raid1_resize(struct mddev *mddev, sector_t sectors)
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
index c79f374668dd..4512d285b76a 100644
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

