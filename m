Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE74514A639;
	Wed, 14 Aug 2024 07:15:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723619739; cv=none; b=m5hCTbCIDVn+L/t4RPBw8pBfAZyZ2J+0KO6UpqIpAGsILaXLcIKZjRwmq5CG5spuQ8WKbo7RIeKDzVs9AgXyvcY/hkNRWIBD+A1pjvO0BADDxhD7oAB3wsBiVrH55/WrEpat50Lwu/LSPxG7vmPRYuuLMsGN01XIiGRp9uAVCR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723619739; c=relaxed/simple;
	bh=gQxDaqtjWm69TQSVNSixLCku5ciUQpnA7bheYuEXKHo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=hWjQ0M4t5nEDc5FeIkIv7tAzS72lvNvbmaMS7qkTlRu/P3dHIJN49ufi82bo371UxyBLGG6C8asqNOErG9u/zZ2RhLwlxATuUb+xWhSsA+EuCIt0Bu2pH2HJCaTX77zEyCiNWU6Qs4WdmdXuGQ/P2rqevR2+/1m5gBfc/DP4M+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=none smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4WkKK33BkGz4f3kv7;
	Wed, 14 Aug 2024 15:15:19 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 28B571A0568;
	Wed, 14 Aug 2024 15:15:34 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgBHboSLWbxmIxKbBg--.47745S24;
	Wed, 14 Aug 2024 15:15:33 +0800 (CST)
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
Subject: [PATCH RFC -next v2 20/41] md/md-bitmap: merge bitmap_write_all() into bitmap_operations
Date: Wed, 14 Aug 2024 15:10:52 +0800
Message-Id: <20240814071113.346781-21-yukuai1@huaweicloud.com>
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
X-CM-TRANSID:gCh0CgBHboSLWbxmIxKbBg--.47745S24
X-Coremail-Antispam: 1UD129KBjvJXoWxXFykAFyDAF4fuF1ktr1rCrg_yoW5AFyrpF
	W7Ka45ur45Jay3X3WUuFyDCFyY9w1ktrZrKrWfC34ruFyUAFnxKF1rWFWjywn5WFy3tFsx
	Zw45tryUWr48XF7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUPY14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
	kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
	z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F
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
 drivers/md/md-bitmap.c | 14 +++++++-------
 drivers/md/md-bitmap.h |  3 +--
 drivers/md/md.c        |  2 +-
 3 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index d4164f096d0c..3b52fa59a36d 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -1224,22 +1224,21 @@ static int md_bitmap_init_from_disk(struct bitmap *bitmap, sector_t start)
 	return ret;
 }
 
-void md_bitmap_write_all(struct bitmap *bitmap)
+/* just flag bitmap pages as needing to be written. */
+static void bitmap_write_all(struct mddev *mddev)
 {
-	/* We don't actually write all bitmap blocks here,
-	 * just flag them as needing to be written
-	 */
 	int i;
+	struct bitmap *bitmap = mddev->bitmap;
 
 	if (!bitmap || !bitmap->storage.filemap)
 		return;
+
+	/* Only one copy, so nothing needed */
 	if (bitmap->storage.file)
-		/* Only one copy, so nothing needed */
 		return;
 
 	for (i = 0; i < bitmap->storage.file_pages; i++)
-		set_page_attr(bitmap, i,
-			      BITMAP_PAGE_NEEDWRITE);
+		set_page_attr(bitmap, i, BITMAP_PAGE_NEEDWRITE);
 	bitmap->allclean = 0;
 }
 
@@ -2717,6 +2716,7 @@ static struct bitmap_operations bitmap_ops = {
 	.load			= bitmap_load,
 	.destroy		= bitmap_destroy,
 	.flush			= bitmap_flush,
+	.write_all		= bitmap_write_all,
 
 	.update_sb		= bitmap_update_sb,
 	.get_stats		= bitmap_get_stats,
diff --git a/drivers/md/md-bitmap.h b/drivers/md/md-bitmap.h
index b97c5df32848..70ca226036e1 100644
--- a/drivers/md/md-bitmap.h
+++ b/drivers/md/md-bitmap.h
@@ -250,6 +250,7 @@ struct bitmap_operations {
 	int (*load)(struct mddev *mddev);
 	void (*destroy)(struct mddev *mddev);
 	void (*flush)(struct mddev *mddev);
+	void (*write_all)(struct mddev *mddev);
 
 	void (*update_sb)(struct bitmap *bitmap);
 	int (*get_stats)(struct bitmap *bitmap, struct md_bitmap_stats *stats);
@@ -260,8 +261,6 @@ void mddev_set_bitmap_ops(struct mddev *mddev);
 
 /* these are used only by md/bitmap */
 
-void md_bitmap_write_all(struct bitmap *bitmap);
-
 void md_bitmap_dirty_bits(struct bitmap *bitmap, unsigned long s, unsigned long e);
 
 /* these are exported */
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 29dd6bc86f3f..bddc0ceb169a 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -9527,7 +9527,7 @@ static void md_start_sync(struct work_struct *ws)
 	 * stored on all devices. So make sure all bitmap pages get written.
 	 */
 	if (spares)
-		md_bitmap_write_all(mddev->bitmap);
+		mddev->bitmap_ops->write_all(mddev);
 
 	name = test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery) ?
 			"reshape" : "resync";
-- 
2.39.2

