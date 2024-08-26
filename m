Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAE5913A3F0;
	Mon, 26 Aug 2024 07:49:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724658596; cv=none; b=XNOu8On3jTwOmIg1GcjN722r3mB1PwgidMQXv1Wo9GJN8eejxSRtbpjKv5cBe6/60QmYXUSIEHBK7TBzsUxwYmK3Wyexb914TiGR7DpEfRPCH2+dzYeevAzilKWyATJHvvV2ZeMyRIX+U7W8MuINI+t17hTtEHuMObMg7Gnwkbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724658596; c=relaxed/simple;
	bh=hswkThS4FKlcX2QZOMK4MbT1KffK2h7xycVFTHWnu1o=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ddmg+OHhRIPL2ZYf0uJV83pGumeCw1N3curp4RebSrVOjWdVq4HGvwA9YG+LlZRwHQjRUgNLDX299Y3l3twze5MPMdyB0GJ0N6DTXiAcW9e4Ehbst1/iEa+2lOgXECK/jiFziFkj6oPJRkpQDDavnupvstvcmqcIQVD+9fFvDU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4WsjW444y7z4f3jMW;
	Mon, 26 Aug 2024 15:49:36 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 0C5F61A1127;
	Mon, 26 Aug 2024 15:49:51 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgAHL4WaM8xmWWIECw--.13849S10;
	Mon, 26 Aug 2024 15:49:50 +0800 (CST)
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
Subject: [PATCH md-6.12 v2 06/42] md/md-bitmap: add 'sync_size' into struct md_bitmap_stats
Date: Mon, 26 Aug 2024 15:44:16 +0800
Message-Id: <20240826074452.1490072-7-yukuai1@huaweicloud.com>
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
X-CM-TRANSID:gCh0CgAHL4WaM8xmWWIECw--.13849S10
X-Coremail-Antispam: 1UD129KBjvJXoWxXF1UGryrZr4UtrWDCr4UJwb_yoW5Kw47pF
	4UZ343Cr45XFW3Xr17XrWkZFyrt34Dtr9rKFyfC34ruF9FyFnxZF48GFyDA3sI9ry5JFsx
	X3s8GFs5ur18Ww7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUP014x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
	kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
	z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F
	4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq
	3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7
	IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4U
	M4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCY1x0262kKe7AKxVWUtV
	W8ZwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v2
	6r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2
	Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUCVW8JwCI42IY6xIIjxv20xvEc7CjxVAFwI0_
	Cr0_Gr1UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVW8JVWxJw
	CI42IY6I8E87Iv6xkF7I0E14v26r4UJVWxJrUvcSsGvfC2KfnxnUUI43ZEXa7VUbPC7UUU
	UUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

To avoid dereferencing bitmap directly in md-cluster to prepare
inventing a new bitmap.

BTW, also fix following checkpatch warnings:

WARNING: Deprecated use of 'kmap_atomic', prefer 'kmap_local_page' instead
WARNING: Deprecated use of 'kunmap_atomic', prefer 'kunmap_local' instead

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/md-bitmap.c  |  6 ++++++
 drivers/md/md-bitmap.h  |  1 +
 drivers/md/md-cluster.c | 34 ++++++++++++++++++++--------------
 3 files changed, 27 insertions(+), 14 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index 95afc22bd255..33812543d984 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -2097,10 +2097,15 @@ EXPORT_SYMBOL_GPL(md_bitmap_copy_from_slot);
 int md_bitmap_get_stats(struct bitmap *bitmap, struct md_bitmap_stats *stats)
 {
 	struct bitmap_counts *counts;
+	bitmap_super_t *sb;
 
 	if (!bitmap)
 		return -ENOENT;
 
+	sb = kmap_local_page(bitmap->storage.sb_page);
+	stats->sync_size = le64_to_cpu(sb->sync_size);
+	kunmap_local(sb);
+
 	counts = &bitmap->counts;
 	stats->missing_pages = counts->missing_pages;
 	stats->pages = counts->pages;
@@ -2110,6 +2115,7 @@ int md_bitmap_get_stats(struct bitmap *bitmap, struct md_bitmap_stats *stats)
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(md_bitmap_get_stats);
 
 int md_bitmap_resize(struct bitmap *bitmap, sector_t blocks,
 		  int chunksize, int init)
diff --git a/drivers/md/md-bitmap.h b/drivers/md/md-bitmap.h
index 751dca2366c3..a43a75575769 100644
--- a/drivers/md/md-bitmap.h
+++ b/drivers/md/md-bitmap.h
@@ -237,6 +237,7 @@ struct bitmap {
 struct md_bitmap_stats {
 	u64		events_cleared;
 	unsigned long	missing_pages;
+	unsigned long	sync_size;
 	unsigned long	pages;
 	struct file	*file;
 };
diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
index e642361b6526..e3faf752f0b1 100644
--- a/drivers/md/md-cluster.c
+++ b/drivers/md/md-cluster.c
@@ -1207,18 +1207,21 @@ static int resize_bitmaps(struct mddev *mddev, sector_t newsize, sector_t oldsiz
  */
 static int cluster_check_sync_size(struct mddev *mddev)
 {
-	int i, rv;
-	bitmap_super_t *sb;
-	unsigned long my_sync_size, sync_size = 0;
-	int node_num = mddev->bitmap_info.nodes;
 	int current_slot = md_cluster_ops->slot_number(mddev);
+	int node_num = mddev->bitmap_info.nodes;
 	struct bitmap *bitmap = mddev->bitmap;
-	char str[64];
 	struct dlm_lock_resource *bm_lockres;
+	struct md_bitmap_stats stats;
+	unsigned long sync_size = 0;
+	unsigned long my_sync_size;
+	char str[64];
+	int i, rv;
 
-	sb = kmap_atomic(bitmap->storage.sb_page);
-	my_sync_size = le64_to_cpu(sb->sync_size);
-	kunmap_atomic(sb);
+	rv = md_bitmap_get_stats(bitmap, &stats);
+	if (rv)
+		return rv;
+
+	my_sync_size = stats.sync_size;
 
 	for (i = 0; i < node_num; i++) {
 		if (i == current_slot)
@@ -1247,15 +1250,18 @@ static int cluster_check_sync_size(struct mddev *mddev)
 			md_bitmap_update_sb(bitmap);
 		lockres_free(bm_lockres);
 
-		sb = kmap_atomic(bitmap->storage.sb_page);
-		if (sync_size == 0)
-			sync_size = le64_to_cpu(sb->sync_size);
-		else if (sync_size != le64_to_cpu(sb->sync_size)) {
-			kunmap_atomic(sb);
+		rv = md_bitmap_get_stats(bitmap, &stats);
+		if (rv) {
+			md_bitmap_free(bitmap);
+			return rv;
+		}
+
+		if (sync_size == 0) {
+			sync_size = stats.sync_size;
+		} else if (sync_size != stats.sync_size) {
 			md_bitmap_free(bitmap);
 			return -1;
 		}
-		kunmap_atomic(sb);
 		md_bitmap_free(bitmap);
 	}
 
-- 
2.39.2

