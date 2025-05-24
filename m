Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9BA119C54E;
	Sat, 24 May 2025 06:18:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748067498; cv=none; b=h1uO4QS1wNFqIEc6L0hgjvXuOafQQSUbtNZ4kQtyaVmqOt9fx/uhDew9apusqSUXTq34sUTukNDVQ3oWrfvXn8kYolJid5yOuGQwxyGSAHxKSIRKUTV39uFuUoc0Zo4FW3Ebm2IJo/rkbM/y9tlFg389nVm6Z29hyQuqBzJLbS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748067498; c=relaxed/simple;
	bh=IYg1L8SmETaoKCRGtjEfDiuelhBB8SOtR83HGJ+BK8E=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ABnvit33z81yGJ3TTrENNfQlhlCV/PjxstW9/5uanoNvKMP4EK3RaYCfU12x5RI7uw6PHgnGAT2iMdvw6CcNGhoN+C4sOA6+SJDZXyDoGeflxNqmiOye6xb51cHadkFArUny07h3kFQDiI/GzMo2ajxDvNbONJiK0s1Ihe3tERM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4b4Bf35n61z4f3jJ8;
	Sat, 24 May 2025 14:17:47 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id EB3C71A174B;
	Sat, 24 May 2025 14:18:12 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgCnCl+dZDFo3etkNQ--.42979S7;
	Sat, 24 May 2025 14:18:12 +0800 (CST)
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
Subject: [PATCH 03/23] md/md-bitmap: cleanup bitmap_ops->startwrite()
Date: Sat, 24 May 2025 14:13:00 +0800
Message-Id: <20250524061320.370630-4-yukuai1@huaweicloud.com>
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
X-CM-TRANSID:gCh0CgCnCl+dZDFo3etkNQ--.42979S7
X-Coremail-Antispam: 1UD129KBjvJXoWxur43Zw13Gr4UXFyxCF4rKrg_yoWrXr15pF
	ZFqFy3KrWaqFW5X3yUAFykuFyrtrn7tr9rtryxW3s5WFy0krn8GF4Fga40qw1UCFy3AFs8
	Zw4YyryUCr42qrJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUm014x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JrWl82xGYIkIc2
	x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0
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
	vjDU0xZFpf9x0JUHWlkUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

bitmap_startwrite() always return 0, and the caller doesn't check return
value as well, hence change the method to void.

Also rename startwrite/endwrite to start_write/end_write, which is more in
line with the usual naming convention.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/md-bitmap.c | 17 ++++++++---------
 drivers/md/md-bitmap.h |  6 +++---
 drivers/md/md.c        |  8 ++++----
 3 files changed, 15 insertions(+), 16 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index 168eea6595b3..2997e09d463d 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -1669,13 +1669,13 @@ __acquires(bitmap->lock)
 			&(bitmap->bp[page].map[pageoff]);
 }
 
-static int bitmap_startwrite(struct mddev *mddev, sector_t offset,
-			     unsigned long sectors)
+static void bitmap_start_write(struct mddev *mddev, sector_t offset,
+			       unsigned long sectors)
 {
 	struct bitmap *bitmap = mddev->bitmap;
 
 	if (!bitmap)
-		return 0;
+		return;
 
 	while (sectors) {
 		sector_t blocks;
@@ -1685,7 +1685,7 @@ static int bitmap_startwrite(struct mddev *mddev, sector_t offset,
 		bmc = md_bitmap_get_counter(&bitmap->counts, offset, &blocks, 1);
 		if (!bmc) {
 			spin_unlock_irq(&bitmap->counts.lock);
-			return 0;
+			return;
 		}
 
 		if (unlikely(COUNTER(*bmc) == COUNTER_MAX)) {
@@ -1721,11 +1721,10 @@ static int bitmap_startwrite(struct mddev *mddev, sector_t offset,
 		else
 			sectors = 0;
 	}
-	return 0;
 }
 
-static void bitmap_endwrite(struct mddev *mddev, sector_t offset,
-			    unsigned long sectors)
+static void bitmap_end_write(struct mddev *mddev, sector_t offset,
+			     unsigned long sectors)
 {
 	struct bitmap *bitmap = mddev->bitmap;
 
@@ -2990,8 +2989,8 @@ static struct bitmap_operations bitmap_ops = {
 	.end_behind_write	= bitmap_end_behind_write,
 	.wait_behind_writes	= bitmap_wait_behind_writes,
 
-	.startwrite		= bitmap_startwrite,
-	.endwrite		= bitmap_endwrite,
+	.start_write		= bitmap_start_write,
+	.end_write		= bitmap_end_write,
 	.start_sync		= bitmap_start_sync,
 	.end_sync		= bitmap_end_sync,
 	.cond_end_sync		= bitmap_cond_end_sync,
diff --git a/drivers/md/md-bitmap.h b/drivers/md/md-bitmap.h
index d3d50629af91..9474e0d86fc6 100644
--- a/drivers/md/md-bitmap.h
+++ b/drivers/md/md-bitmap.h
@@ -90,10 +90,10 @@ struct bitmap_operations {
 	void (*end_behind_write)(struct mddev *mddev);
 	void (*wait_behind_writes)(struct mddev *mddev);
 
-	int (*startwrite)(struct mddev *mddev, sector_t offset,
+	void (*start_write)(struct mddev *mddev, sector_t offset,
+			    unsigned long sectors);
+	void (*end_write)(struct mddev *mddev, sector_t offset,
 			  unsigned long sectors);
-	void (*endwrite)(struct mddev *mddev, sector_t offset,
-			 unsigned long sectors);
 	bool (*start_sync)(struct mddev *mddev, sector_t offset,
 			   sector_t *blocks, bool degraded);
 	void (*end_sync)(struct mddev *mddev, sector_t offset, sector_t *blocks);
diff --git a/drivers/md/md.c b/drivers/md/md.c
index b0468e795d94..04a659f40cd6 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -8849,14 +8849,14 @@ static void md_bitmap_start(struct mddev *mddev,
 		mddev->pers->bitmap_sector(mddev, &md_io_clone->offset,
 					   &md_io_clone->sectors);
 
-	mddev->bitmap_ops->startwrite(mddev, md_io_clone->offset,
-				      md_io_clone->sectors);
+	mddev->bitmap_ops->start_write(mddev, md_io_clone->offset,
+				       md_io_clone->sectors);
 }
 
 static void md_bitmap_end(struct mddev *mddev, struct md_io_clone *md_io_clone)
 {
-	mddev->bitmap_ops->endwrite(mddev, md_io_clone->offset,
-				    md_io_clone->sectors);
+	mddev->bitmap_ops->end_write(mddev, md_io_clone->offset,
+				     md_io_clone->sectors);
 }
 
 static void md_end_clone_io(struct bio *bio)
-- 
2.39.2

