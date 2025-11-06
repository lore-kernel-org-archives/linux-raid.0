Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74728327202;
	Thu,  6 Nov 2025 12:08:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762430892; cv=none; b=sDgAbco+jpOyJR+aASUxFwzuLSpAfdDgomFXv0iYiQ9uxNbL70QFCJWEGSoTGK35g8ZPsjT554cTe3qtEihQxEOus29RX9uWz3yyKq/eVT3hqviTQPFmedjrntZepwispO2ps9J/RvLNn9w94gLbUsnEcYHZVkfvl+OM1t6efCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762430892; c=relaxed/simple;
	bh=ZPRCQhuHwzTiYW6GrduHjYvkDNuFWGV5jc0LNVDKGAA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ZpHwiLooTAAwp+OzU/YCb1TfkfQtPFzcodN3JG29nvgf1JBOnImVqIAw2IGHgiLM7VOs1BRDJJcRB0BbzkCEW117J7N0xQGf9SGKuUq7hspHt12lVjR2tAmqlRjjTeoIsb7CQyNinBsRWCGexoOIBCPOkcFwaQdWLxzFf7Hrvi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4d2LYP19BGzKHMmR;
	Thu,  6 Nov 2025 20:07:53 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.75])
	by mail.maildlp.com (Postfix) with ESMTP id D19791A1191;
	Thu,  6 Nov 2025 20:08:01 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.87.129])
	by APP2 (Coremail) with SMTP id Syh0CgCH3UWfjwxpEbabCw--.33933S8;
	Thu, 06 Nov 2025 20:08:01 +0800 (CST)
From: linan666@huaweicloud.com
To: song@kernel.org,
	yukuai@fnnas.com,
	neil@brown.name,
	namhyung@gmail.com
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	xni@redhat.com,
	k@mgml.me,
	linan666@huaweicloud.com,
	yangerkun@huawei.com,
	yi.zhang@huawei.com
Subject: [PATCH v2 04/11] md/raid1,raid10: support narrow_write_error when badblocks is disabled
Date: Thu,  6 Nov 2025 19:59:28 +0800
Message-Id: <20251106115935.2148714-5-linan666@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20251106115935.2148714-1-linan666@huaweicloud.com>
References: <20251106115935.2148714-1-linan666@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:Syh0CgCH3UWfjwxpEbabCw--.33933S8
X-Coremail-Antispam: 1UD129KBjvJXoW7uF1xGrWxAr13WFyfXF4xJFb_yoW8Kr4rpa
	s7GryfJ3yruFy0va17A34j93WFv3yfGFWUArW7Z39rur97GrZ7GF4vq345WF1jqFnxKF9F
	q3WUCrWUZF1kGFJanT9S1TB71UUUUUDqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUHS14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
	kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
	z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F
	4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq
	3wAac4AC62xK8xCEY4vEwIxC4wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0V
	AKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUXVWUAwAv7VC2z280aVAFwI0_Gr1j6F4U
	JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20V
	AGYxC7M4IIrI8v6xkF7I0E8cxan2IY04v7M4kE6xkIj40Ew7xC0wCY1x0262kKe7AKxVWU
	tVW8ZwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14
	v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkG
	c2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI
	0_Cr0_Gr1UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVW8JVWx
	JwCI42IY6I8E87Iv6xkF7I0E14v26r4UJVWxJrUvcSsGvfC2KfnxnUUI43ZEXa7VUbQeOt
	UUUUU==
X-CM-SenderInfo: polqt0awwwqx5xdzvxpfor3voofrz/

From: Li Nan <linan122@huawei.com>

When badblocks.shift < 0 (badblocks disabled), narrow_write_error()
return false, preventing write error handling. Since narrow_write_error()
only splits IO into smaller sizes and re-submits, it can work with
badblocks disabled.

Adjust to use the logical block size for block_sectors when badblocks is
disabled, allowing narrow_write_error() to function in this case.

Suggested-by: Kenta Akagi <k@mgml.me>
Signed-off-by: Li Nan <linan122@huawei.com>
---
 drivers/md/raid1.c  | 8 ++++----
 drivers/md/raid10.c | 8 ++++----
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 090fe8f71224..86df18df45e5 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -2503,17 +2503,17 @@ static bool narrow_write_error(struct r1bio *r1_bio, int i)
 	 * We currently own a reference on the rdev.
 	 */
 
-	int block_sectors;
+	int block_sectors, lbs = bdev_logical_block_size(rdev->bdev) >> 9;
 	sector_t sector;
 	int sectors;
 	int sect_to_write = r1_bio->sectors;
 	bool ok = true;
 
 	if (rdev->badblocks.shift < 0)
-		return false;
+		block_sectors = lbs;
+	else
+		block_sectors = roundup(1 << rdev->badblocks.shift, lbs);
 
-	block_sectors = roundup(1 << rdev->badblocks.shift,
-				bdev_logical_block_size(rdev->bdev) >> 9);
 	sector = r1_bio->sector;
 	sectors = ((sector + block_sectors)
 		   & ~(sector_t)(block_sectors - 1))
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 9c43c380d7e8..fffc2c95660b 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -2790,17 +2790,17 @@ static bool narrow_write_error(struct r10bio *r10_bio, int i)
 	 * We currently own a reference to the rdev.
 	 */
 
-	int block_sectors;
+	int block_sectors, lbs = bdev_logical_block_size(rdev->bdev) >> 9;
 	sector_t sector;
 	int sectors;
 	int sect_to_write = r10_bio->sectors;
 	bool ok = true;
 
 	if (rdev->badblocks.shift < 0)
-		return false;
+		block_sectors = lbs;
+	else
+		block_sectors = roundup(1 << rdev->badblocks.shift, lbs);
 
-	block_sectors = roundup(1 << rdev->badblocks.shift,
-				bdev_logical_block_size(rdev->bdev) >> 9);
 	sector = r10_bio->sector;
 	sectors = ((r10_bio->sector + block_sectors)
 		   & ~(sector_t)(block_sectors - 1))
-- 
2.39.2

