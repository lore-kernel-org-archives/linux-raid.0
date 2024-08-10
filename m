Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88AAC140E22;
	Sat, 10 Aug 2024 02:13:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723255984; cv=none; b=hS2q+4i9gKlWHdjsofrgF8L57s16JFtMO4u0tQzrqTj9rQxdn3p2mey8Hn6gbHGq9n0xRm7s6yz98YGRPyYvQxTTuXD+6B2WpXfdrm9yWkRFkSFv37gSbCn20pd/MVfPM0+Li+2U66LYTNpdgIo8daMikjNoKofn2BtuKjiEh4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723255984; c=relaxed/simple;
	bh=kfyzLf4j4zTDCXEueW1t7qzELjN1/EPMb3+fZXgAFsw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=KmktVlu/73QAlwsVn2uDF8A8u3yFkxkirojQ/AedmDApV5LeDYw1PHrzmsrI4SGV3jdRaUj3XvewoJpOcdv8tdmq4kCpizx0bBvoYKtoPviXfsQ0qg5cEdEF3o7ZXmIgoBWzBM43VziQvsoUWu7REIe7FGGlLom9LCtpc5HQB1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=none smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4Wgknj0RCcz4f3jQv;
	Sat, 10 Aug 2024 10:12:41 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 8D2801A018D;
	Sat, 10 Aug 2024 10:12:54 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgAHL4WizLZmErwLBQ--.1937S10;
	Sat, 10 Aug 2024 10:12:54 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: song@kernel.org
Cc: linux-kernel@vger.kernel.org,
	linux-raid@vger.kernel.org,
	yukuai3@huawei.com,
	yukuai1@huaweicloud.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com
Subject: [PATCH RFC -next 06/26] md/md-bitmap: don't expose md_bitmap_print_sb()
Date: Sat, 10 Aug 2024 10:08:34 +0800
Message-Id: <20240810020854.797814-7-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240810020854.797814-1-yukuai1@huaweicloud.com>
References: <20240810020854.797814-1-yukuai1@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgAHL4WizLZmErwLBQ--.1937S10
X-Coremail-Antispam: 1UD129KBjvJXoW7WF18Aw1rWryxJFy5JF43KFg_yoW8WF17pr
	Z8Gwn8CrW5JF43X3W7Zry09FyrJw4Dtr9rKFyfC34ruFy7XFnxGr48K3Wqywn5Gr13JFsx
	Xwn8tryUGr18Xa7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUBE14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
	kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
	z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F
	4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq
	3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7
	IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4U
	M4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCY1x0262kKe7AKxVWUAV
	WUtwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v2
	6r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1lIxkGc2
	Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUCVW8JwCI42IY6xIIjxv20xvEc7CjxVAFwI0_
	Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMI
	IF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUvYLPUUUUU
	=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

md_bitmap_print_sb() is only used inside md-bitmap.c, hence make it
static, and also rename it to bitmap_print_sb().

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/md-bitmap.c | 4 ++--
 drivers/md/md-bitmap.h | 1 -
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index 33bcae5594e2..0ff733756043 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -513,7 +513,7 @@ void md_bitmap_update_sb(struct bitmap *bitmap)
 EXPORT_SYMBOL(md_bitmap_update_sb);
 
 /* print out the bitmap file superblock */
-void md_bitmap_print_sb(struct bitmap *bitmap)
+static void bitmap_print_sb(struct bitmap *bitmap)
 {
 	bitmap_super_t *sb;
 
@@ -760,7 +760,7 @@ static int md_bitmap_read_sb(struct bitmap *bitmap)
 			bitmap->mddev->bitmap_info.space > sectors_reserved)
 			bitmap->mddev->bitmap_info.space = sectors_reserved;
 	} else {
-		md_bitmap_print_sb(bitmap);
+		bitmap_print_sb(bitmap);
 		if (bitmap->cluster_slot < 0)
 			md_cluster_stop(bitmap->mddev);
 	}
diff --git a/drivers/md/md-bitmap.h b/drivers/md/md-bitmap.h
index 749351db04d3..935c5dc45b89 100644
--- a/drivers/md/md-bitmap.h
+++ b/drivers/md/md-bitmap.h
@@ -277,7 +277,6 @@ static inline void md_bitmap_flush(struct mddev *mddev)
 	mddev->bitmap_ops->flush(mddev);
 }
 
-void md_bitmap_print_sb(struct bitmap *bitmap);
 void md_bitmap_update_sb(struct bitmap *bitmap);
 void md_bitmap_status(struct seq_file *seq, struct bitmap *bitmap);
 
-- 
2.39.2

