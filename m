Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 193622E3366;
	Thu,  3 Apr 2025 01:59:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743645585; cv=none; b=HqJPFPBHJ9hiH0YOk/cVhGOiWAzTz/DthSQOpFvOGIKAFgB3v/b7MjC0J3t9V2LmHWPpRWJhiUM4TWPi14As/KIZCGxKYs5+AZsJ6G/hpYbpdKM91F5cBxHYrGZ1puN3m9SBaClS5esyRB7V0ubVA5HMdNWzC0VFPl11xbxZizM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743645585; c=relaxed/simple;
	bh=hV3GC0woSDzt9yhjUxK5aAWmtD0lNceZ7A/yFqQTY6A=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=j4IApXQpx4NnyK5J+sn3oHsin+JoQBWjAbN0yRonp7xBOGrjQaULv4Jkm6XtoUV2iKmz8PGtcMAO+e7CSVAUrH1D2sfITKe06SyNVqfFb52iMjFUWZJaTEnQTknn5SvPLhb3FGwNXLXZKu0UnExh3thchDwsT4Dz7QBiD7km70k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4ZSlKC1d6Rz4f3kng;
	Thu,  3 Apr 2025 09:59:11 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 6E6371A135B;
	Thu,  3 Apr 2025 09:59:34 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgD3W2CE6+1nGUxnIQ--.45685S4;
	Thu, 03 Apr 2025 09:59:34 +0800 (CST)
From: Zheng Qixing <zhengqixing@huaweicloud.com>
To: song@kernel.org,
	yukuai3@huawei.com
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	yi.zhang@huawei.com,
	yangerkun@huawei.com,
	zhengqixing@huawei.com
Subject: [PATCH V2] md/md-bitmap: fix stats collection for external bitmaps
Date: Thu,  3 Apr 2025 09:53:22 +0800
Message-Id: <20250403015322.2873369-1-zhengqixing@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgD3W2CE6+1nGUxnIQ--.45685S4
X-Coremail-Antispam: 1UD129KBjvJXoW7CF1xWF48ZFW3Wrykuw17Wrg_yoW8GrW5pr
	ZxG3WY9ryrJr4Fqr1UZry8ZFy5X3ZxtrZrKr95C3s5ua47AF9xKr48GFyj9asIyryrZF4q
	vrW5ta4UC34UuFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUyKb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JMxkF7I0En4kS14v26r126r1DMxAIw28IcxkI
	7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxV
	Cjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUAVWUtwCIc40Y0x0EwIxGrwCI42IY
	6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6x
	AIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY
	1x0267AKxVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvjxUwxhLUUUUU
X-CM-SenderInfo: x2kh0wptl0x03j6k3tpzhluzxrxghudrp/

From: Zheng Qixing <zhengqixing@huawei.com>

The bitmap_get_stats() function incorrectly returns -ENOENT for external
bitmaps.

Remove the external bitmap check as the statistics should be available
regardless of bitmap storage location.

Return -EINVAL only for invalid bitmap with no storage (neither in
superblock nor in external file).

Note: "bitmap_info.external" here refers to a bitmap stored in a separate
file (bitmap_file), not to external metadata.

Fixes: 8d28d0ddb986 ("md/md-bitmap: Synchronize bitmap_get_stats() with bitmap lifetime")
Signed-off-by: Zheng Qixing <zhengqixing@huawei.com>
---
 drivers/md/md-bitmap.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index 44ec9b17cfd3..37b08f26c62f 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -2357,9 +2357,8 @@ static int bitmap_get_stats(void *data, struct md_bitmap_stats *stats)
 
 	if (!bitmap)
 		return -ENOENT;
-	if (bitmap->mddev->bitmap_info.external)
-		return -ENOENT;
-	if (!bitmap->storage.sb_page) /* no superblock */
+	if (!bitmap->mddev->bitmap_info.external &&
+	    !bitmap->storage.sb_page)
 		return -EINVAL;
 	sb = kmap_local_page(bitmap->storage.sb_page);
 	stats->sync_size = le64_to_cpu(sb->sync_size);
-- 
2.39.2

