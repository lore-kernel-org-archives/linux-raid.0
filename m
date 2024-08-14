Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 403411474D7;
	Wed, 14 Aug 2024 07:15:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723619738; cv=none; b=a27CctmbFO0FHZqWIhaclhE+K9xRUmY7Cf1PnTKoAxUkdWO1FWMHo8bM5NTpiVe4jT51hI9cr/vwAVTm+3+KgM6AwjYFyaFxpZ2xuKun4uQ9SVJI+JxhphCEYQwKzvojOB2A7DgsYhVWvJN5vSNj80NMNTFDO0EBq8KCdL671a4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723619738; c=relaxed/simple;
	bh=3aah0+BwmCN/5yWXlUjF4YBxX3vNfzagATMcgfrKwSs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Nnv0KPhf+rH2eLnlRBENVgA/Lx58dnV3y14buxmFObAyJnGFNNH4u0473twoQsZKTFK+uBSxofux0bpjF3+0kMNNbc0kyI7Wu4vzmermKivdNIueVViZNy6veDSHz+4EW6IrO2mXAC2Bwv7yMKLJ3qpvsXmGe+JtDU6CfTQi5h4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4WkKK25FYxz4f3jd9;
	Wed, 14 Aug 2024 15:15:18 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 7BBFF1A06D7;
	Wed, 14 Aug 2024 15:15:32 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgBHboSLWbxmIxKbBg--.47745S20;
	Wed, 14 Aug 2024 15:15:32 +0800 (CST)
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
Subject: [PATCH RFC -next v2 16/41] md/md-bitmap: make md_bitmap_print_sb() internal
Date: Wed, 14 Aug 2024 15:10:48 +0800
Message-Id: <20240814071113.346781-17-yukuai1@huaweicloud.com>
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
X-CM-TRANSID:gCh0CgBHboSLWbxmIxKbBg--.47745S20
X-Coremail-Antispam: 1UD129KBjvJXoW7WryfAr1kCw1rXr13WrWDCFg_yoW8WF1xpF
	98Gwn8CrW5JF43Xw1UZryv9FyrAwsrtrZrKFyfC34ruFyUXFnxGr48K3WDtwn5Wr13JFsx
	Zrn8tryUGw1xXFUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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
	Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVW8JVW5JwCI42IY6xIIjxv20xvEc7CjxVAFwI0_
	Gr1j6F4UJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Gr0_Cr
	1lIxAIcVC2z280aVCY1x0267AKxVW8Jr0_Cr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUQFxUU
	UUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

md_bitmap_print_sb() is only used inside md-bitmap.c, hence make it
static, also rename it to bitmap_print_sb.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/md-bitmap.c | 5 ++---
 drivers/md/md-bitmap.h | 1 -
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index d1b43bce5953..9d4bbcebb7b7 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -512,8 +512,7 @@ void md_bitmap_update_sb(struct bitmap *bitmap)
 }
 EXPORT_SYMBOL(md_bitmap_update_sb);
 
-/* print out the bitmap file superblock */
-void md_bitmap_print_sb(struct bitmap *bitmap)
+static void bitmap_print_sb(struct bitmap *bitmap)
 {
 	bitmap_super_t *sb;
 
@@ -760,7 +759,7 @@ static int md_bitmap_read_sb(struct bitmap *bitmap)
 			bitmap->mddev->bitmap_info.space > sectors_reserved)
 			bitmap->mddev->bitmap_info.space = sectors_reserved;
 	} else {
-		md_bitmap_print_sb(bitmap);
+		bitmap_print_sb(bitmap);
 		if (bitmap->cluster_slot < 0)
 			md_cluster_stop(bitmap->mddev);
 	}
diff --git a/drivers/md/md-bitmap.h b/drivers/md/md-bitmap.h
index 0212284c2b29..76bc90dccacc 100644
--- a/drivers/md/md-bitmap.h
+++ b/drivers/md/md-bitmap.h
@@ -257,7 +257,6 @@ void mddev_set_bitmap_ops(struct mddev *mddev);
 
 /* these are used only by md/bitmap */
 
-void md_bitmap_print_sb(struct bitmap *bitmap);
 void md_bitmap_update_sb(struct bitmap *bitmap);
 int md_bitmap_get_stats(struct bitmap *bitmap, struct md_bitmap_stats *stats);
 
-- 
2.39.2

