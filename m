Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9B5119AD89;
	Sat, 24 May 2025 06:18:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748067499; cv=none; b=Ks6mMWq7A/4CIjO5oIc24GWg6v7Nq8RDuekfIXA1C4UVYfP0Tgkf9EjED67LagYWkNq/WFPwHZd4zyX6+SqD9VmGpq2lo6B+qHxBykiyRtbwfWieIYjfu/L2tlU4DovY7hzqvIzBbcamANEoQ+cDwqR5bHpAbR/aq+yPN/nIOCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748067499; c=relaxed/simple;
	bh=LSPYQFonDbezcCTBN2zNPcIZyZmI8b/19oJroc7tKbE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=aIQCkDIQLiAnkQosXMzG7o9eN2r0N3BdBCFJzISaUI1HdCQgrujPbBcbNfz9g6JcathtNahcopPQxfpvYk0OLVLIteMaZz6Tsr1gkX3veI0sOdClsUo6sVjdrZ4B+1Z01OXf+yHTspImT0Vh+AaE0yc0tkGIt0NdCLbCs7N6hw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4b4Bf25wQdz4f3jXL;
	Sat, 24 May 2025 14:17:46 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id EF7751A140F;
	Sat, 24 May 2025 14:18:11 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgCnCl+dZDFo3etkNQ--.42979S5;
	Sat, 24 May 2025 14:18:11 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: hch@lst.de,
	xni@redhat.com,
	colyli@kernel.org,
	song@kernel.org,
	yukuai3@huawei.com
Cc: linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-raid@vger.kernel.org,
	yukuai1@huaweicloud.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com,
	johnny.chenyi@huawei.com
Subject: [PATCH 01/23] md: add a new parameter 'offset' to md_super_write()
Date: Sat, 24 May 2025 14:12:58 +0800
Message-Id: <20250524061320.370630-2-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250524061320.370630-1-yukuai1@huaweicloud.com>
References: <20250524061320.370630-1-yukuai1@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgCnCl+dZDFo3etkNQ--.42979S5
X-Coremail-Antispam: 1UD129KBjvJXoWxXF1UtFW3Xr45tr4ruw1xZrb_yoWrur1rpa
	yIvFyfJrWakrWjqw1UJFyDua4Fq34DKrZ7try3u34xu3W7KrykKF45JFy8Ar98uF9xCrs0
	qw4UCFW7uw1xWr7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUm014x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_Jr4l82xGYIkIc2
	x26xkF7I0E14v26r4j6ryUM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0
	Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJw
	A2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq3wAS
	0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2
	IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0
	Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2kIc2
	xKxwCY1x0262kKe7AKxVWUtVW8ZwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWU
	JVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67
	kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY
	6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0x
	vEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVj
	vjDU0xZFpf9x0JU4OJ5UUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

The parameter is always set to 0 for now, following patches will use
this helper to write llbitmap to underlying disks, allow writing
dirty sectors instead of the whole page.

Also rename md_super_write to md_write_metadata since there is nothing
super-block specific.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/md-bitmap.c |  3 ++-
 drivers/md/md.c        | 28 ++++++++++++++--------------
 drivers/md/md.h        |  5 +++--
 3 files changed, 19 insertions(+), 17 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index 431a3ab2e449..168eea6595b3 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -470,7 +470,8 @@ static int __write_sb_page(struct md_rdev *rdev, struct bitmap *bitmap,
 			return -EINVAL;
 	}
 
-	md_super_write(mddev, rdev, sboff + ps, (int)min(size, bitmap_limit), page);
+	md_write_metadata(mddev, rdev, sboff + ps, (int)min(size, bitmap_limit),
+			  page, 0);
 	return 0;
 }
 
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 32b997dfe6f4..18e03f651f6b 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -1021,8 +1021,9 @@ static void super_written(struct bio *bio)
 		wake_up(&mddev->sb_wait);
 }
 
-void md_super_write(struct mddev *mddev, struct md_rdev *rdev,
-		   sector_t sector, int size, struct page *page)
+void md_write_metadata(struct mddev *mddev, struct md_rdev *rdev,
+		       sector_t sector, int size, struct page *page,
+		       unsigned int offset)
 {
 	/* write first size bytes of page to sector of rdev
 	 * Increment mddev->pending_writes before returning
@@ -1047,7 +1048,7 @@ void md_super_write(struct mddev *mddev, struct md_rdev *rdev,
 	atomic_inc(&rdev->nr_pending);
 
 	bio->bi_iter.bi_sector = sector;
-	__bio_add_page(bio, page, size, 0);
+	__bio_add_page(bio, page, size, offset);
 	bio->bi_private = rdev;
 	bio->bi_end_io = super_written;
 
@@ -1657,8 +1658,8 @@ super_90_rdev_size_change(struct md_rdev *rdev, sector_t num_sectors)
 	if ((u64)num_sectors >= (2ULL << 32) && rdev->mddev->level >= 1)
 		num_sectors = (sector_t)(2ULL << 32) - 2;
 	do {
-		md_super_write(rdev->mddev, rdev, rdev->sb_start, rdev->sb_size,
-		       rdev->sb_page);
+		md_write_metadata(rdev->mddev, rdev, rdev->sb_start,
+				  rdev->sb_size, rdev->sb_page, 0);
 	} while (md_super_wait(rdev->mddev) < 0);
 	return num_sectors;
 }
@@ -2306,8 +2307,8 @@ super_1_rdev_size_change(struct md_rdev *rdev, sector_t num_sectors)
 	sb->super_offset = cpu_to_le64(rdev->sb_start);
 	sb->sb_csum = calc_sb_1_csum(sb);
 	do {
-		md_super_write(rdev->mddev, rdev, rdev->sb_start, rdev->sb_size,
-			       rdev->sb_page);
+		md_write_metadata(rdev->mddev, rdev, rdev->sb_start,
+				  rdev->sb_size, rdev->sb_page, 0);
 	} while (md_super_wait(rdev->mddev) < 0);
 	return num_sectors;
 
@@ -2816,18 +2817,17 @@ void md_update_sb(struct mddev *mddev, int force_change)
 			continue; /* no noise on spare devices */
 
 		if (!test_bit(Faulty, &rdev->flags)) {
-			md_super_write(mddev,rdev,
-				       rdev->sb_start, rdev->sb_size,
-				       rdev->sb_page);
+			md_write_metadata(mddev, rdev, rdev->sb_start,
+					  rdev->sb_size, rdev->sb_page, 0);
 			pr_debug("md: (write) %pg's sb offset: %llu\n",
 				 rdev->bdev,
 				 (unsigned long long)rdev->sb_start);
 			rdev->sb_events = mddev->events;
 			if (rdev->badblocks.size) {
-				md_super_write(mddev, rdev,
-					       rdev->badblocks.sector,
-					       rdev->badblocks.size << 9,
-					       rdev->bb_page);
+				md_write_metadata(mddev, rdev,
+						  rdev->badblocks.sector,
+						  rdev->badblocks.size << 9,
+						  rdev->bb_page, 0);
 				rdev->badblocks.size = 0;
 			}
 
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 6eb5dfdf2f55..5ba4a9093a92 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -886,8 +886,9 @@ void md_account_bio(struct mddev *mddev, struct bio **bio);
 void md_free_cloned_bio(struct bio *bio);
 
 extern bool __must_check md_flush_request(struct mddev *mddev, struct bio *bio);
-extern void md_super_write(struct mddev *mddev, struct md_rdev *rdev,
-			   sector_t sector, int size, struct page *page);
+extern void md_write_metadata(struct mddev *mddev, struct md_rdev *rdev,
+			      sector_t sector, int size, struct page *page,
+			      unsigned int offset);
 extern int md_super_wait(struct mddev *mddev);
 extern int sync_page_io(struct md_rdev *rdev, sector_t sector, int size,
 		struct page *page, blk_opf_t opf, bool metadata_op);
-- 
2.39.2

