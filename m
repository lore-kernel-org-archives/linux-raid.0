Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 408F01D556;
	Thu, 22 Aug 2024 02:52:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724295129; cv=none; b=A5uNDIGMBb5C795fYPMAjYiISExoBJoekjCyQaDVjXAUa7yU/q8KB/m/Ad+yV6VX9VCDgOMondBs9cqHHKBce/BrTsqTyTdYHjKgZrZrGoH+Oi9OZJdEEsc2qpnZ1tA3S1ZZmNzMp31WBDZaWBWvm8QV+pfynY9Ia4GCDeNya0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724295129; c=relaxed/simple;
	bh=Q7SkfTQXxWr6QrJyEz4+56fT5Aw+t0GfLN+J4+XvkHA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=XRRKnNN7zqVBe66qkDQsKhGuBPqpVOalXFF2iLo+sDfeDgqlbVXlc1jg2PJC5buH8B3GXP2Mwb6/3vfMOj2r9HikJiwfezocQwIvJBXxGkepI94aRaytnx13ScKr8szvt5wlKJwuq6VzHHvGdoIZ8IBMA0VCC7Rh6UN50RxD/f0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4Wq75H4Y7zz4f3nJd;
	Thu, 22 Aug 2024 10:51:47 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id BDBA91A0568;
	Thu, 22 Aug 2024 10:52:02 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgAXPoTNp8ZmyXl2CQ--.42363S10;
	Thu, 22 Aug 2024 10:52:02 +0800 (CST)
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
Subject: [PATCH md-6.12 06/41] md/md-bitmap: add 'file_pages' into struct md_bitmap_stats
Date: Thu, 22 Aug 2024 10:46:43 +0800
Message-Id: <20240822024718.2158259-7-yukuai1@huaweicloud.com>
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
X-CM-TRANSID:gCh0CgAXPoTNp8ZmyXl2CQ--.42363S10
X-Coremail-Antispam: 1UD129KBjvJXoWxur1UJF1kGF1kAr47ur47twb_yoW5WryDpa
	yUJa45urWrXw45Xw17Xry8ZFyrXwnxKFZrKF93C3s8ua4jyF9xWFW8GFWUAwn8GFWUAFsr
	Zws8trWUCr10gaUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUm214x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
	kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
	z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Cr1j6r
	xdM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s0D
	M2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjx
	v20xvE14v26r106r15McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1l
	F7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7M4IIrI8v6xkF7I0E8cxan2
	IY04v7MxkF7I0En4kS14v26r1q6r43MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY
	6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17
	CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1I6r4UMIIF
	0xvE2Ix0cI8IcVCY1x0267AKxVWxJVW8Jr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMI
	IF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVF
	xhVjvjDU0xZFpf9x0JUWMKtUUUUU=
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
index 105778cc34ed..82b31a46caa1 100644
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

