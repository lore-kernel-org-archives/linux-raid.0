Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C577519924E;
	Sat, 24 May 2025 06:18:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748067498; cv=none; b=mT9kBbSWN3dQ14NkUhYuKOAFYzfNJTkmwkjCll3bQkTsuaO+tPOey+luQcJUfSWmyPE9h5f3lIsPzLxUM3FVTb5k3xo/f+c9DEaJBuPNQCQ7MWz8Go2NMqgKcpWct0Mjz0SO+tTD+SXdm0MjwUCNwtB0LzKUT+vsQcUY/VrLUs0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748067498; c=relaxed/simple;
	bh=/wQrV/SlON4PEX2mOq+kSRCZRZMffzNxCwfovOnMJpM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=heuuGDbxi4QDv7tFlBgJp6fJ6d7k0cgJW6/lRltlcPZm4sMlGeKCbJRt4XfkJgWV4WrEcZmuAcNzCF8GQlMy1YZK5Ky2gtGiLouoIsig8q4XpRw8O97RonbRnq9s1+793JiwqjnQsdeUJQmoZ3cnisz3tD4knbKUvVyBMxTvnOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4b4BfZ2GNGzYQtvv;
	Sat, 24 May 2025 14:18:14 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 734591A0879;
	Sat, 24 May 2025 14:18:13 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgCnCl+dZDFo3etkNQ--.42979S8;
	Sat, 24 May 2025 14:18:13 +0800 (CST)
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
Subject: [PATCH 04/23] md/md-bitmap: support discard for bitmap ops
Date: Sat, 24 May 2025 14:13:01 +0800
Message-Id: <20250524061320.370630-5-yukuai1@huaweicloud.com>
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
X-CM-TRANSID:gCh0CgCnCl+dZDFo3etkNQ--.42979S8
X-Coremail-Antispam: 1UD129KBjvJXoWxXFyUCFWkCr1rXF47XrWDurg_yoWrGF1xpF
	ZFqFy3Gr43Xr4Yqa47Aa4DuFyrtw1ktrZrKFW7W345WFyxCFnxCF4Fga4qyw1DGFy3CFsx
	Zw4Fkr15Cr18XrJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUmI14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
	kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
	z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F
	4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq
	3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7
	IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4U
	M4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2
	kIc2xKxwCY1x0262kKe7AKxVWUtVW8ZwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkE
	bVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67
	AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI
	42IY6xIIjxv20xvEc7CjxVAFwI0_Cr0_Gr1UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCw
	CI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnI
	WIevJa73UjIFyTuYvjfUOyIUUUUUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

Use two new methods {start, end}_discard to handle discard IO, prepare
to support new md bitmap.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/md-bitmap.c |  3 +++
 drivers/md/md-bitmap.h | 12 ++++++++----
 drivers/md/md.c        | 15 +++++++++++----
 drivers/md/md.h        |  1 +
 4 files changed, 23 insertions(+), 8 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index 2997e09d463d..848626049dea 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -2991,6 +2991,9 @@ static struct bitmap_operations bitmap_ops = {
 
 	.start_write		= bitmap_start_write,
 	.end_write		= bitmap_end_write,
+	.start_discard		= bitmap_start_write,
+	.end_discard		= bitmap_end_write,
+
 	.start_sync		= bitmap_start_sync,
 	.end_sync		= bitmap_end_sync,
 	.cond_end_sync		= bitmap_cond_end_sync,
diff --git a/drivers/md/md-bitmap.h b/drivers/md/md-bitmap.h
index 9474e0d86fc6..4d804c07dbdd 100644
--- a/drivers/md/md-bitmap.h
+++ b/drivers/md/md-bitmap.h
@@ -70,6 +70,9 @@ struct md_bitmap_stats {
 	struct file	*file;
 };
 
+typedef void (md_bitmap_fn)(struct mddev *mddev, sector_t offset,
+			    unsigned long sectors);
+
 struct bitmap_operations {
 	struct md_submodule_head head;
 
@@ -90,10 +93,11 @@ struct bitmap_operations {
 	void (*end_behind_write)(struct mddev *mddev);
 	void (*wait_behind_writes)(struct mddev *mddev);
 
-	void (*start_write)(struct mddev *mddev, sector_t offset,
-			    unsigned long sectors);
-	void (*end_write)(struct mddev *mddev, sector_t offset,
-			  unsigned long sectors);
+	md_bitmap_fn *start_write;
+	md_bitmap_fn *end_write;
+	md_bitmap_fn *start_discard;
+	md_bitmap_fn *end_discard;
+
 	bool (*start_sync)(struct mddev *mddev, sector_t offset,
 			   sector_t *blocks, bool degraded);
 	void (*end_sync)(struct mddev *mddev, sector_t offset, sector_t *blocks);
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 04a659f40cd6..466087cef4f9 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -8845,18 +8845,24 @@ EXPORT_SYMBOL_GPL(md_submit_discard_bio);
 static void md_bitmap_start(struct mddev *mddev,
 			    struct md_io_clone *md_io_clone)
 {
+	md_bitmap_fn *fn = unlikely(md_io_clone->rw == STAT_DISCARD) ?
+			   mddev->bitmap_ops->start_discard :
+			   mddev->bitmap_ops->start_write;
+
 	if (mddev->pers->bitmap_sector)
 		mddev->pers->bitmap_sector(mddev, &md_io_clone->offset,
 					   &md_io_clone->sectors);
 
-	mddev->bitmap_ops->start_write(mddev, md_io_clone->offset,
-				       md_io_clone->sectors);
+	fn(mddev, md_io_clone->offset, md_io_clone->sectors);
 }
 
 static void md_bitmap_end(struct mddev *mddev, struct md_io_clone *md_io_clone)
 {
-	mddev->bitmap_ops->end_write(mddev, md_io_clone->offset,
-				     md_io_clone->sectors);
+	md_bitmap_fn *fn = unlikely(md_io_clone->rw == STAT_DISCARD) ?
+			   mddev->bitmap_ops->end_discard :
+			   mddev->bitmap_ops->end_write;
+
+	fn(mddev, md_io_clone->offset, md_io_clone->sectors);
 }
 
 static void md_end_clone_io(struct bio *bio)
@@ -8895,6 +8901,7 @@ static void md_clone_bio(struct mddev *mddev, struct bio **bio)
 	if (bio_data_dir(*bio) == WRITE && md_bitmap_enabled(mddev)) {
 		md_io_clone->offset = (*bio)->bi_iter.bi_sector;
 		md_io_clone->sectors = bio_sectors(*bio);
+		md_io_clone->rw = op_stat_group(bio_op(*bio));
 		md_bitmap_start(mddev, md_io_clone);
 	}
 
diff --git a/drivers/md/md.h b/drivers/md/md.h
index c241119e6ef3..13e3f9ce1b79 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -850,6 +850,7 @@ struct md_io_clone {
 	unsigned long	start_time;
 	sector_t	offset;
 	unsigned long	sectors;
+	enum stat_group	rw;
 	struct bio	bio_clone;
 };
 
-- 
2.39.2

