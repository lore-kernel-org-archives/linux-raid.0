Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36F794317E;
	Thu, 22 Aug 2024 02:52:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724295132; cv=none; b=j82AHNIVDp/WGGOc9WA1uLRP//9TbKnoSuYYPIGAGZC13pmo6Pj672xWobuMz/BSK1gjFFqeAqcK4pcAgr2LEPfX0k+AoJYnhG2B58HwgzzW/QOXCNaVuobLmtQ7ev+3YSFRTqgbaav871wO3H8Z521Do4S8SqISLzdDsfNp6T0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724295132; c=relaxed/simple;
	bh=b34kaLuil4UTMuj1TFTYUPFNGgGKz3Y4UlsAYkWqghM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=VECcBwloekzxox0rThQavOlxyhWrb5kSO8US2gVMRsuDcW6oqNepdwv21mn18+CpHAdrlPvFg8qVf1pZYKxd4cMQ4q9BYGsAnya5r+mrQEG2i748Qo6NAqaXvj3u3wF3INo5Jci8APoylR5aOG+ha9x22JUgc/Q3JZ4hNOJKLXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4Wq75P0Q4xz4f3jsM;
	Thu, 22 Aug 2024 10:51:53 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 44E761A0359;
	Thu, 22 Aug 2024 10:52:07 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgAXPoTNp8ZmyXl2CQ--.42363S20;
	Thu, 22 Aug 2024 10:52:07 +0800 (CST)
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
Subject: [PATCH md-6.12 16/41] md/md-bitmap: make md_bitmap_print_sb() internal
Date: Thu, 22 Aug 2024 10:46:53 +0800
Message-Id: <20240822024718.2158259-17-yukuai1@huaweicloud.com>
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
X-CM-TRANSID:gCh0CgAXPoTNp8ZmyXl2CQ--.42363S20
X-Coremail-Antispam: 1UD129KBjvJXoW7WryfAr1kCw1rXFyrJr43KFg_yoW8WF1xpF
	98Gwn8G3y5JF43Xw1UZryvkFyrAwnrtrZrKFyfC34ruFyUXFnxGr48K3WDtwn5Gr13JFsx
	Zrn8tryUGr1xX3JanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUma14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
	kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
	z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Cr1j6r
	xdM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s0D
	M2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjx
	v20xvE14v26r106r15McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1l
	F7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7M4IIrI8v6xkF7I0E8cxan2
	IY04v7MxkF7I0En4kS14v26r1q6r43MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY
	6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17
	CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r4j6ryUMIIF
	0xvE2Ix0cI8IcVCY1x0267AKxVW8Jr0_Cr1UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCw
	CI42IY6I8E87Iv67AKxVW8JVWxJwCI42IY6I8E87Iv6xkF7I0E14v26r4UJVWxJrUvcSsG
	vfC2KfnxnUUI43ZEXa7VU1zpBDUUUUU==
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
index 324b676ac927..20f5fdd7396f 100644
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
index c0858665554e..5d5811c89b77 100644
--- a/drivers/md/md-bitmap.h
+++ b/drivers/md/md-bitmap.h
@@ -258,7 +258,6 @@ void mddev_set_bitmap_ops(struct mddev *mddev);
 
 /* these are used only by md/bitmap */
 
-void md_bitmap_print_sb(struct bitmap *bitmap);
 void md_bitmap_update_sb(struct bitmap *bitmap);
 int md_bitmap_get_stats(struct bitmap *bitmap, struct md_bitmap_stats *stats);
 
-- 
2.39.2

