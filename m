Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B86D6274B35;
	Mon,  5 Jan 2026 11:11:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767611502; cv=none; b=dX9vHcMou0bR/izovy2F5I2qWjTSIulX5OLBCyiQjHK47QJm1uJNR167zsw2gtaGG+Sp0hhm1AM9TQcE42WdHKuSUB3f7v1s1b95YoE8X7vf49qPVwTZns/6HR7NvTIxHV/uSfv9t9St8badk9kajTtORZb2ZCCe/BH2eSYV6Bc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767611502; c=relaxed/simple;
	bh=GXziCHixb8LcBXAByaS42ErFOh69zcKhB+jUJ2bIQZ4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=oioLzS2FQIEnqxQwNbkvfF2YCae3WFrCYjDYD6ZSn4scRblkiPKOk7WSACTyaJWGV5pJTFi1QabbiBXtUO8LTB1ASRfZM72p2XmXbjtx4vSnNQevwU2aQMjEjKJm5wrrfrGEm+XhJjZDKln9ZhRnQz4+1S0iJyxndS1kVXE8hX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4dlBRf4ygjzYQtxf;
	Mon,  5 Jan 2026 19:10:38 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 6D9324058C;
	Mon,  5 Jan 2026 19:11:37 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.87.129])
	by APP4 (Coremail) with SMTP id gCh0CgBXuPhmnFtp6EHbCg--.50545S7;
	Mon, 05 Jan 2026 19:11:37 +0800 (CST)
From: linan666@huaweicloud.com
To: song@kernel.org,
	yukuai@fnnas.com,
	neil@brown.name,
	namhyung@gmail.com
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linan666@huaweicloud.com,
	yangerkun@huawei.com,
	yi.zhang@huawei.com
Subject: [PATCH v4 03/12] md/raid1,raid10: support narrow_write_error when badblocks is disabled
Date: Mon,  5 Jan 2026 19:02:51 +0800
Message-Id: <20260105110300.1442509-4-linan666@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20260105110300.1442509-1-linan666@huaweicloud.com>
References: <20260105110300.1442509-1-linan666@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgBXuPhmnFtp6EHbCg--.50545S7
X-Coremail-Antispam: 1UD129KBjvJXoW7uF1xGrWxAr13WFyfWrW3KFg_yoW8Kr4xpa
	s7GFyfJ3yrury0va17X34j93WFv343GFWUCry7Z3sruryxGrZ7GF4kX345WFyjqFnxKF9F
	qa1UCrWUAF1DGaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUmC14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JrWl82xGYIkIc2
	x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0
	Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJw
	A2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq3wAa
	c4AC62xK8xCEY4vEwIxC4wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzV
	Aqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUXVWUAwAv7VC2z280aVAFwI0_Gr1j6F4UJwAm
	72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYx
	C7M4kE6xkIj40Ew7xC0wCY1x0262kKe7AKxVWUtVW8ZwCF04k20xvY0x0EwIxGrwCFx2Iq
	xVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r
	106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AK
	xVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7
	xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_
	Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUd5rcUUUUU=
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
index 90ad9455f74a..ef66ff4cab37 100644
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
index 40c31c00dc60..0700ed1dac60 100644
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

