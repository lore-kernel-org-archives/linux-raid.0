Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B08972905;
	Tue,  4 Mar 2025 12:51:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741092703; cv=none; b=qIxXlGDBXfIt+s2OQukaMEMzfL2GthbcSpH5DupjUtFa9exV7o7viHxw4bvecqmORl/lxqb62or6Y8Xnh/GhJrqtfR964znXeREsUW5+Wm6H/KsGvmHznmhvkKM4U4QSJHwKQ2UjdwMOZD5wDCJFZMmaCQ2FOqBiBq7SURuyCyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741092703; c=relaxed/simple;
	bh=hPH3Nbg7RGi+tPJtqUdaCGrseBM4At38KJ5rEf2MPsY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=qVGkcXPNQmnTeVaRA8gi3nsuHdzdP64SOyYVy9H6yr30MHTpI2NZ3+nXGBkXsHvAH3Ktm2UD3gbelO5QaASZq+H9Lu1Rda8tOuv0CquQaqBJWEQPS942a2SW3sareFtbH0JBE6UN3+xpCkn75r0IxS2nz3Ds02LkC/2h0p3LqVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4Z6ZbM2Dz0z4f3jt8;
	Tue,  4 Mar 2025 20:23:27 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 0C69E1A0DEA;
	Tue,  4 Mar 2025 20:23:44 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgB321_O8MZnFO8VFg--.52907S5;
	Tue, 04 Mar 2025 20:23:43 +0800 (CST)
From: linan666@huaweicloud.com
To: axboe@kernel.dk,
	song@kernel.org,
	yukuai3@huawei.com,
	hare@suse.de,
	martin.petersen@oracle.com
Cc: linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-raid@vger.kernel.org,
	linan666@huaweicloud.com,
	yangerkun@huawei.com,
	zhangxiaoxu5@huawei.com,
	wanghai38@huawei.com
Subject: [PATCH 1/4] block: factor out a helper to set logical/physical block size
Date: Tue,  4 Mar 2025 20:19:15 +0800
Message-Id: <20250304121918.3159388-2-linan666@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250304121918.3159388-1-linan666@huaweicloud.com>
References: <20250304121918.3159388-1-linan666@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgB321_O8MZnFO8VFg--.52907S5
X-Coremail-Antispam: 1UD129KBjvJXoWxKFWkZFy3trWxuFykWFWfXwb_yoW7XF4rp3
	Z7ZrZ7K3y8WFyIvay3Ar1fW3ZYg3yUGFWUArya9345KrZ2yr17GFn7JFy5WrWjqrsxuw47
	Z3Z8KFZ5C3WSgrUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUHj14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_Jr4l82xGYIkIc2
	x26xkF7I0E14v26r4j6ryUM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0
	Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJw
	A2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq3wAa
	c4AC62xK8xCEY4vEwIxC4wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzV
	Aqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUGVWUXwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S
	6xCaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxw
	ACI402YVCY1x02628vn2kIc2xKxwAKzVCY07xG64k0F24lc7CjxVAaw2AFwI0_Jw0_GFyl
	42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJV
	WUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAK
	I48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F
	4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY
	6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjfU0NtIUUUUU
X-CM-SenderInfo: polqt0awwwqx5xdzvxpfor3voofrz/

From: Li Nan <linan122@huawei.com>

There is no functional change.

Signed-off-by: Li Nan <linan122@huawei.com>
---
 include/linux/blkdev.h |  2 +
 block/blk-settings.c   | 85 ++++++++++++++++++++++++------------------
 2 files changed, 50 insertions(+), 37 deletions(-)

diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 248416ecd01c..516a7a8c0c3d 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -996,6 +996,8 @@ static inline void blk_queue_disable_write_zeroes(struct request_queue *q)
  */
 extern void blk_set_queue_depth(struct request_queue *q, unsigned int depth);
 extern void blk_set_stacking_limits(struct queue_limits *lim);
+extern int blk_set_block_size(struct queue_limits *t, unsigned int logical_block_size,
+		unsigned int physical_block_size);
 extern int blk_stack_limits(struct queue_limits *t, struct queue_limits *b,
 			    sector_t offset);
 void queue_limits_stack_bdev(struct queue_limits *t, struct block_device *bdev,
diff --git a/block/blk-settings.c b/block/blk-settings.c
index c44dadc35e1e..4a053c3d7c0a 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -645,6 +645,53 @@ static void blk_stack_atomic_writes_limits(struct queue_limits *t,
 	t->atomic_write_hw_boundary = 0;
 }
 
+int blk_set_block_size(struct queue_limits *t, unsigned int logical_block_size,
+		     unsigned int physical_block_size)
+{
+	int ret = 0;
+
+	t->logical_block_size = max(t->logical_block_size,
+				    logical_block_size);
+
+	t->physical_block_size = max(t->physical_block_size,
+				     physical_block_size);
+
+	/* Physical block size a multiple of the logical block size? */
+	if (t->physical_block_size & (t->logical_block_size - 1)) {
+		t->physical_block_size = t->logical_block_size;
+		t->flags |= BLK_FLAG_MISALIGNED;
+		ret = -1;
+	}
+
+	/* Minimum I/O a multiple of the physical block size? */
+	if (t->io_min & (t->physical_block_size - 1)) {
+		t->io_min = t->physical_block_size;
+		t->flags |= BLK_FLAG_MISALIGNED;
+		ret = -1;
+	}
+
+	/* Optimal I/O a multiple of the physical block size? */
+	if (t->io_opt & (t->physical_block_size - 1)) {
+		t->io_opt = 0;
+		t->flags |= BLK_FLAG_MISALIGNED;
+		ret = -1;
+	}
+
+	/* chunk_sectors a multiple of the physical block size? */
+	if ((t->chunk_sectors << 9) & (t->physical_block_size - 1)) {
+		t->chunk_sectors = 0;
+		t->flags |= BLK_FLAG_MISALIGNED;
+		ret = -1;
+	}
+
+	t->max_sectors = blk_round_down_sectors(t->max_sectors, t->logical_block_size);
+	t->max_hw_sectors = blk_round_down_sectors(t->max_hw_sectors, t->logical_block_size);
+	t->max_dev_sectors = blk_round_down_sectors(t->max_dev_sectors, t->logical_block_size);
+
+	return ret;
+}
+EXPORT_SYMBOL(blk_set_block_size);
+
 /**
  * blk_stack_limits - adjust queue_limits for stacked devices
  * @t:	the stacking driver limits (top device)
@@ -728,12 +775,6 @@ int blk_stack_limits(struct queue_limits *t, struct queue_limits *b,
 		}
 	}
 
-	t->logical_block_size = max(t->logical_block_size,
-				    b->logical_block_size);
-
-	t->physical_block_size = max(t->physical_block_size,
-				     b->physical_block_size);
-
 	t->io_min = max(t->io_min, b->io_min);
 	t->io_opt = lcm_not_zero(t->io_opt, b->io_opt);
 	t->dma_alignment = max(t->dma_alignment, b->dma_alignment);
@@ -742,33 +783,7 @@ int blk_stack_limits(struct queue_limits *t, struct queue_limits *b,
 	if (b->chunk_sectors)
 		t->chunk_sectors = gcd(t->chunk_sectors, b->chunk_sectors);
 
-	/* Physical block size a multiple of the logical block size? */
-	if (t->physical_block_size & (t->logical_block_size - 1)) {
-		t->physical_block_size = t->logical_block_size;
-		t->flags |= BLK_FLAG_MISALIGNED;
-		ret = -1;
-	}
-
-	/* Minimum I/O a multiple of the physical block size? */
-	if (t->io_min & (t->physical_block_size - 1)) {
-		t->io_min = t->physical_block_size;
-		t->flags |= BLK_FLAG_MISALIGNED;
-		ret = -1;
-	}
-
-	/* Optimal I/O a multiple of the physical block size? */
-	if (t->io_opt & (t->physical_block_size - 1)) {
-		t->io_opt = 0;
-		t->flags |= BLK_FLAG_MISALIGNED;
-		ret = -1;
-	}
-
-	/* chunk_sectors a multiple of the physical block size? */
-	if ((t->chunk_sectors << 9) & (t->physical_block_size - 1)) {
-		t->chunk_sectors = 0;
-		t->flags |= BLK_FLAG_MISALIGNED;
-		ret = -1;
-	}
+	ret = blk_set_block_size(t, b->logical_block_size, b->physical_block_size);
 
 	/* Find lowest common alignment_offset */
 	t->alignment_offset = lcm_not_zero(t->alignment_offset, alignment)
@@ -780,10 +795,6 @@ int blk_stack_limits(struct queue_limits *t, struct queue_limits *b,
 		ret = -1;
 	}
 
-	t->max_sectors = blk_round_down_sectors(t->max_sectors, t->logical_block_size);
-	t->max_hw_sectors = blk_round_down_sectors(t->max_hw_sectors, t->logical_block_size);
-	t->max_dev_sectors = blk_round_down_sectors(t->max_dev_sectors, t->logical_block_size);
-
 	/* Discard alignment and granularity */
 	if (b->discard_granularity) {
 		alignment = queue_limit_discard_alignment(b, start);
-- 
2.39.2

