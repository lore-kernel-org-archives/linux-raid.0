Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D8B8223336;
	Mon, 15 Dec 2025 03:15:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765768546; cv=none; b=dcEYeGHZmw6TI8BAUFmNVBj5MB5YLx+kPNMk2/QT+advwLrzNPCVbY0ikfDe+3bOrxXFNGbJYCy7davUHpNL8GZGk3XWTUBGw5m2zLyvE67RsZwsCxyYNwDm9FTbjbi4mrnPXflX7K/ISHHBW3toysKEuAUNepIV33oUtxknK6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765768546; c=relaxed/simple;
	bh=gybHw2IprBp5g1AYsIKGzuuWWC7pYA62pR2C145dhEQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=jccqP+gpTo16GAONvjt0domGr/TjEufnpjwgrTZXxQ+9CdpUkV3gZ61D231aErJJoSXSothEQmZzkv7EgARuUFGxT26Th9aiRt1EYFOOk5BGqRC6X82h4ZVmNrSKPu4Qpc8ta8v0YqpZrKHoH9QDuN3d+Cd39NdxfwMmfrN0GLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4dV4v636sCzKHMNq;
	Mon, 15 Dec 2025 11:15:30 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id DA6CA1A0359;
	Mon, 15 Dec 2025 11:15:35 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.87.129])
	by APP4 (Coremail) with SMTP id gCh0CgAXd_dUfT9p8AnuAA--.53622S9;
	Mon, 15 Dec 2025 11:15:35 +0800 (CST)
From: linan666@huaweicloud.com
To: song@kernel.org,
	yukuai@fnnas.com,
	neil@brown.name,
	namhyung@gmail.com
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	k@mgml.me,
	linan666@huaweicloud.com,
	yangerkun@huawei.com,
	yi.zhang@huawei.com
Subject: [PATCH v3 05/13] md/raid1,raid10: support narrow_write_error when badblocks is disabled
Date: Mon, 15 Dec 2025 11:04:36 +0800
Message-Id: <20251215030444.1318434-6-linan666@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20251215030444.1318434-1-linan666@huaweicloud.com>
References: <20251215030444.1318434-1-linan666@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgAXd_dUfT9p8AnuAA--.53622S9
X-Coremail-Antispam: 1UD129KBjvJXoW7uF1xGrWxAr13WFyfWrW3KFg_yoW8Kr4xpa
	s7GFyfJ3yruFy0va17A34j93WFv34fGFWUArW7Z3sruryxGrZ7GF4kXry5WFyjqFnxKF9F
	q3WUCrW7C3WkGaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUHa14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
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
	c2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUCVW8JwCI42IY6xIIjxv20xvEc7CjxVAFwI
	0_Cr0_Gr1UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8
	JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjfUOPfHDU
	UUU
X-CM-SenderInfo: polqt0awwwqx5xdzvxpfor3voofrz/

From: Li Nan <linan122@huawei.com>

When badblocks.shift < 0 (badblocks disabled), narrow_write_error()
return false, preventing write error handling. Since narrow_write_error()
only splits IO into smaller sizes and re-submits, it can work with
badblocks disabled.

Adjust to use the logical block size for block_sectors when badblocks is
disabled, allowing narrow_write_error() to function in this case.

Signed-off-by: Li Nan <linan122@huawei.com>
Reviewed-by: Yu Kuai <yukuai@fnnas.com>
---
 drivers/md/raid1.c  | 8 ++++----
 drivers/md/raid10.c | 8 ++++----
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index bd63cf039381..8e0312fad3a2 100644
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
index db6fbd423726..e1f63f4f1384 100644
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

