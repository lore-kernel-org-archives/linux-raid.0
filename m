Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 423BA13A3F3;
	Mon, 26 Aug 2024 07:49:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724658596; cv=none; b=CNiBgR+RWsGinCbEEu6WL3y9+sHNo6QpYs4+YLfrLSrjKGyhX87OzvZ5ADKFdKyOTzSxFdhXEOM4YI2x21J+mxQfI0w7/NwRpvIODShUEuJVUU6R75/Apxdz0fUkE7FAF6NFuO/cDm/E6lwsdqQELEMAzI9DjcPEfY+mvIpg3b0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724658596; c=relaxed/simple;
	bh=HEekdMr2NRkWKDULvAT/5ndj3dYwmYDdV/li/tl7suo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ebAPYvsQpIa75Xt13MyxHarPCAdYAfbsvg25CRi+ra+vbLNk3uRjfMz38meybwTGzsc/bHawEw/JGdW/iamy1HWX0gTWIJEGkU+sXBMiezfu202cAn5CGaFKHjzNWYqEDtsctzvDCrx5XaHNkvTv+tIZqx9gvfc16m/cCUEahy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=none smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4WsjW942P0z4f3jYx;
	Mon, 26 Aug 2024 15:49:41 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 6DF031A1679;
	Mon, 26 Aug 2024 15:49:51 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgAHL4WaM8xmWWIECw--.13849S11;
	Mon, 26 Aug 2024 15:49:51 +0800 (CST)
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
Subject: [PATCH md-6.12 v2 07/42] md/md-bitmap: add 'file_pages' into struct md_bitmap_stats
Date: Mon, 26 Aug 2024 15:44:17 +0800
Message-Id: <20240826074452.1490072-8-yukuai1@huaweicloud.com>
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
X-CM-TRANSID:gCh0CgAHL4WaM8xmWWIECw--.13849S11
X-Coremail-Antispam: 1UD129KBjvJXoWxur1UJF1kGF1kAr47ur47twb_yoW5WryDpa
	yUJa45ur4rXw45Xw17Xry8ZFyrX3ZxKFZrKF93C3s8ua4jyF9xWFW8GFWUAwn8CFWUAFsr
	Zwn8trWUCr10gaUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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

There are no functional changes, avoid dereferencing bitmap directly to
prepare inventing a new bitmap.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/md-bitmap.c |  7 +++++--
 drivers/md/md-bitmap.h |  1 +
 drivers/md/md.c        | 17 +++++++++++------
 3 files changed, 17 insertions(+), 8 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index 33812543d984..ba83b99d6185 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -2096,6 +2096,7 @@ EXPORT_SYMBOL_GPL(md_bitmap_copy_from_slot);
 
 int md_bitmap_get_stats(struct bitmap *bitmap, struct md_bitmap_stats *stats)
 {
+	struct bitmap_storage *storage;
 	struct bitmap_counts *counts;
 	bitmap_super_t *sb;
 
@@ -2110,9 +2111,11 @@ int md_bitmap_get_stats(struct bitmap *bitmap, struct md_bitmap_stats *stats)
 	stats->missing_pages = counts->missing_pages;
 	stats->pages = counts->pages;
 
-	stats->events_cleared = bitmap->events_cleared;
-	stats->file = bitmap->storage.file;
+	storage = &bitmap->storage;
+	stats->file_pages = storage->file_pages;
+	stats->file = storage->file;
 
+	stats->events_cleared = bitmap->events_cleared;
 	return 0;
 }
 EXPORT_SYMBOL_GPL(md_bitmap_get_stats);
diff --git a/drivers/md/md-bitmap.h b/drivers/md/md-bitmap.h
index a43a75575769..870125670087 100644
--- a/drivers/md/md-bitmap.h
+++ b/drivers/md/md-bitmap.h
@@ -237,6 +237,7 @@ struct bitmap {
 struct md_bitmap_stats {
 	u64		events_cleared;
 	unsigned long	missing_pages;
+	unsigned long	file_pages;
 	unsigned long	sync_size;
 	unsigned long	pages;
 	struct file	*file;
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 5e1dd3009092..53e10dc28f72 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -2335,7 +2335,6 @@ super_1_allow_new_offset(struct md_rdev *rdev,
 			 unsigned long long new_offset)
 {
 	/* All necessary checks on new >= old have been done */
-	struct bitmap *bitmap;
 	if (new_offset >= rdev->data_offset)
 		return 1;
 
@@ -2352,11 +2351,17 @@ super_1_allow_new_offset(struct md_rdev *rdev,
 	 */
 	if (rdev->sb_start + (32+4)*2 > new_offset)
 		return 0;
-	bitmap = rdev->mddev->bitmap;
-	if (bitmap && !rdev->mddev->bitmap_info.file &&
-	    rdev->sb_start + rdev->mddev->bitmap_info.offset +
-	    bitmap->storage.file_pages * (PAGE_SIZE>>9) > new_offset)
-		return 0;
+
+	if (!rdev->mddev->bitmap_info.file) {
+		struct md_bitmap_stats stats;
+		int err;
+
+		err = md_bitmap_get_stats(rdev->mddev->bitmap, &stats);
+		if (!err && rdev->sb_start + rdev->mddev->bitmap_info.offset +
+		    stats.file_pages * (PAGE_SIZE >> 9) > new_offset)
+			return 0;
+	}
+
 	if (rdev->badblocks.sector + rdev->badblocks.size > new_offset)
 		return 0;
 
-- 
2.39.2

