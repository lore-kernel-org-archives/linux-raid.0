Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AB5D13C9C0;
	Wed, 14 Aug 2024 07:15:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723619742; cv=none; b=nAWVgWycxeK05zkFhITRMCNdHdjtqnBM6UeUvwPCtamL6Owi4ws4kbLnKcw+YdoyYkJdoAAdjSt4DfAz37Q0ou63zZ5YIOqzMl1pz4VkfNhfsxqcSRMmYuAkXTONJj+FKPWlwNdumGoVVSjUFNcxc5Hv2kviLuoiLEjf9HUq4NE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723619742; c=relaxed/simple;
	bh=5K7azbrJYlitnn4LJDn0zCqSWplEAwPRkur+FJyME58=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=aI4SG02q8TphBbiHod7jFtshmLgmi5IuwCSs+dja7g+xMmh85jKDQlaxnMu8bppMf6jzdhEbVKND/w9p8pO51kjnbWR5rZmC+yZU/qyE8v+PSyYUXTx4PiPFA4x9KozFW3gmcaNCL2zbEmASatwz5242MF6dqUgXSPYPoIqia0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4WkKKD3Fvgz4f3jjn;
	Wed, 14 Aug 2024 15:15:28 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id C52EA1A18D2;
	Wed, 14 Aug 2024 15:15:37 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgBHboSLWbxmIxKbBg--.47745S33;
	Wed, 14 Aug 2024 15:15:37 +0800 (CST)
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
Subject: [PATCH RFC -next v2 29/41] md/md-bitmap: merge md_bitmap_sync_with_cluster() into bitmap_operations
Date: Wed, 14 Aug 2024 15:11:01 +0800
Message-Id: <20240814071113.346781-30-yukuai1@huaweicloud.com>
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
X-CM-TRANSID:gCh0CgBHboSLWbxmIxKbBg--.47745S33
X-Coremail-Antispam: 1UD129KBjvJXoWxur4xXF17Ww4rZw17JFy5urg_yoW5Zr1xpF
	WUta43Cry3JFZxX3WUZFyDua4Fy34ktrZrtryxW34ruFyqqrnxGF4rGasFyrWkGF15JFs0
	vw15KFW5ur1kXr7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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
 drivers/md/md-bitmap.c  | 9 +++++----
 drivers/md/md-bitmap.h  | 8 ++++----
 drivers/md/md-cluster.c | 4 ++--
 3 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index b92b8f997fc8..a9bf9ad71ba6 100644
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
@@ -2750,6 +2749,8 @@ static struct bitmap_operations bitmap_ops = {
 
 	.update_sb		= bitmap_update_sb,
 	.get_stats		= bitmap_get_stats,
+
+	.sync_with_cluster	= bitmap_sync_with_cluster,
 };
 
 void mddev_set_bitmap_ops(struct mddev *mddev)
diff --git a/drivers/md/md-bitmap.h b/drivers/md/md-bitmap.h
index 34c70abe8795..d933b603fce9 100644
--- a/drivers/md/md-bitmap.h
+++ b/drivers/md/md-bitmap.h
@@ -266,16 +266,16 @@ struct bitmap_operations {
 
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
index 31108832dd9b..b36b9f449f9d 100644
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

