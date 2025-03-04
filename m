Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFC5B1FC0ED;
	Tue,  4 Mar 2025 12:23:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741091031; cv=none; b=iLuL6s7Og0A1ReKzaMJzKaL/gSKbGtNSvIVBTIxKQPXtp69zYp7F/vYOF2MMJWptIIvzRKcjVEGN51zZfLVRukQmZtPUJHhyHM9ryp/zwHXfI3JiU7csyzJDnDK9r146z71XVuJ5g9quD9ofB9lMvcQmh7B80UPreaRJTLm8I7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741091031; c=relaxed/simple;
	bh=nwXgjNaeOdMTOkOa3biSPhH/rdEQ0v12ywrk+95jz1M=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=uW0vPt1t9jpOXq707QyFEW18Cmm7sQVr56auWmlkXvPwW+mBc9hzm46CU4PCNNVVURPoPQ8nlSBN2E7hhkazlQioXmYqvxSeTzTxHMD+rsaisXICvwQ5ak+rmGS9Km1SqGGpF0Y2/hNgovfHo6rl4634sYAwkQk/KkbuxWlUFqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4Z6ZbG6svfz4f3jcl;
	Tue,  4 Mar 2025 20:23:22 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 0BDA61A0DEA;
	Tue,  4 Mar 2025 20:23:45 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgB321_O8MZnFO8VFg--.52907S7;
	Tue, 04 Mar 2025 20:23:44 +0800 (CST)
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
Subject: [PATCH 3/4] md: prevent adding disks with larger logical_block_size to active arrays
Date: Tue,  4 Mar 2025 20:19:17 +0800
Message-Id: <20250304121918.3159388-4-linan666@huaweicloud.com>
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
X-CM-TRANSID:gCh0CgB321_O8MZnFO8VFg--.52907S7
X-Coremail-Antispam: 1UD129KBjvdXoWrKFyDGFyDXFW5tFW8WF45Wrg_yoWkXrcE9a
	1YvrZ2qr4UGF9a9F1UZrWxZFyrKa1kua1DXFnFga43ua4UJF1kCFyfu343XrWqvay7GFy5
	Kw1kKw4rAr4DCjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbd8FF20E14v26rWj6s0DM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI8067AKxVWUWwA2048vs2IY02
	0Ec7CjxVAFwI0_Xr0E3s1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xv
	wVC0I7IYx2IY67AKxVW7JVWDJwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVW8Jr0_Cr1UM2
	8EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s0DM2vY
	z4IE04k24VAvwVAKI4IrM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c
	02F40Ex7xfMcIj6xIIjxv20xvE14v26r106r15McIj6I8E87Iv67AKxVWUJVW8JwAm72CE
	4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7M4
	IIrI8v6xkF7I0E8cxan2IY04v7M4kE6xkIj40Ew7xC0wCY1x0262kKe7AKxVWUtVW8ZwCF
	04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r
	18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vI
	r41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr
	1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvE
	x4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUJxhLUUUUU=
X-CM-SenderInfo: polqt0awwwqx5xdzvxpfor3voofrz/

From: Li Nan <linan122@huawei.com>

When adding a disk to a md array, avoid updating the array's
logical_block_size to match the new disk. This prevents accidental
partition table loss that renders the array unusable.

The later patch will introduce a way to configure the array's
logical_block_size.

Signed-off-by: Li Nan <linan122@huawei.com>
---
 drivers/md/md.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index cf3d8ff807a7..48c35b6fb52e 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -5854,6 +5854,13 @@ int mddev_stack_new_rdev(struct mddev *mddev, struct md_rdev *rdev)
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

