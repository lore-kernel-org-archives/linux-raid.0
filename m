Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9D10299943;
	Mon, 25 Aug 2025 08:07:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756109277; cv=none; b=EhuZu3IZyOoj/B7dWDfHL0enp3zHAoqJuPqWKHVI4z5UUF+EpTeUMvAFApBaxVyFuolPibASa8qTb4NCZN2tUugGC+Wp/VGqH8XqYTRXm6lzD/Kzt3dZziZMDw8s3tWy1PaBnk0JB50vJ0fvNKo577x703VDIQpsQqdsIrfEo/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756109277; c=relaxed/simple;
	bh=N+jRalDtiGA+NO7A9NDMPwm+Cjsc99KngkTzxTTvExw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=GwJ43ASjHmnu2delc40ElXYwsmMH9GdTSV2pAz4PIAuKbWBCPbLg4YZqel4hEr0Sv4BD7z8UVFv6n11SVgt7nHhQraDSqgXKxI0qvmES3yy2OiGIt3wjo6rLtdBhQKXJXU0YpzZB4uO77n0Ze3yUQs4JH7aVLTle3XIgYXWsDGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4c9Nh84BQ6zKHNkr;
	Mon, 25 Aug 2025 16:07:52 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 303191A127A;
	Mon, 25 Aug 2025 16:07:52 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgAncIzVGaxosLjpAA--.42805S5;
	Mon, 25 Aug 2025 16:07:51 +0800 (CST)
From: linan666@huaweicloud.com
To: song@kernel.org,
	yukuai3@huawei.com
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	martin.petersen@oracle.com,
	bvanassche@acm.org,
	hch@infradead.org,
	filipe.c.maia@gmail.com,
	linan666@huaweicloud.com,
	yangerkun@huawei.com,
	yi.zhang@huawei.com
Subject: [PATCH v3 1/2] md: prevent adding disks with larger logical_block_size to active arrays
Date: Mon, 25 Aug 2025 15:59:23 +0800
Message-Id: <20250825075924.2696723-2-linan666@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250825075924.2696723-1-linan666@huaweicloud.com>
References: <20250825075924.2696723-1-linan666@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgAncIzVGaxosLjpAA--.42805S5
X-Coremail-Antispam: 1UD129KBjvdXoWrKFyDGFyDXFW5tFW8WF45Wrg_yoWkuFXE9a
	1Yvr92qr47GF9I9F1UZrWxZFyfKa18Wa1kXFnFgw13ua4UJF1kCF97u345J3yq9ay7AFyY
	kr1kKw4fAr4UAjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbd8FF20E14v26ryj6rWUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI8067AKxVWUGwA2048vs2IY02
	0Ec7CjxVAFwI0_Gr0_Xr1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xv
	wVC0I7IYx2IY67AKxVWDJVCq3wA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVW8Jr0_Cr1UM2
	8EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s0DM2vY
	z4IE04k24VAvwVAKI4IrM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c
	02F40Ex7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE
	4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7M4
	IIrI8v6xkF7I0E8cxan2IY04v7M4kE6xkIj40Ew7xC0wCY1x0262kKe7AKxVWUtVW8ZwCF
	04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r
	18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vI
	r41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr
	1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvE
	x4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUrhL5UUUUU=
X-CM-SenderInfo: polqt0awwwqx5xdzvxpfor3voofrz/

From: Li Nan <linan122@huawei.com>

When adding a disk to a md array, avoid updating the array's
logical_block_size to match the new disk. This prevents accidental
partition table loss that renders the array unusable.

The later patch will introduce a way to configure the array's
logical_block_size.

Signed-off-by: Li Nan <linan122@huawei.com>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 drivers/md/md.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index cea8fc96abd3..206434591b97 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -6064,6 +6064,13 @@ int mddev_stack_new_rdev(struct mddev *mddev, struct md_rdev *rdev)
 	if (mddev_is_dm(mddev))
 		return 0;
 
+	if (queue_logical_block_size(rdev->bdev->bd_disk->queue) >
+	    queue_logical_block_size(mddev->gendisk->queue)) {
+		pr_err("%s: incompatible logical_block_size, can not add\n",
+		       mdname(mddev));
+		return -EINVAL;
+	}
+
 	lim = queue_limits_start_update(mddev->gendisk->queue);
 	queue_limits_stack_bdev(&lim, rdev->bdev, rdev->data_offset,
 				mddev->gendisk->disk_name);
-- 
2.39.2

