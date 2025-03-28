Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF2DF18BB8E;
	Fri, 28 Mar 2025 06:14:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743142492; cv=none; b=nJoQdtU7dV2Pu0Jb/eSwszjj3L0CVtKejTqj4wHipn2BS3mq6iy18U+DQnzXkbAV7Imm3mTO6fjUBZF7L0E3FDHODMo+yFbBE7drt+yitA5fomWd67RO+dNY/wK2s9mPL1hjDgeAVEDqiTnhZiYpQKnVKNaTLeSg1EWazQAbuis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743142492; c=relaxed/simple;
	bh=yvMAEESoNnbvRo/WhnPSJN0fQteTcSJ7e9or7cAm9nM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=HDRr3DpbbYA7cblw3FkPW5MBhT7Z/tkXtb/XiHbwE0ya48VjP0ckKQ1Fy8svElSQ/0UeWVNcNtcLmrZt4txdE+LqoL7/JT0tn62LUgyTxhl+VUHx87QCf0d380oNBU7yJ6DuvxCsV7RFXRGIcdW+Klmwbds51seive0qTDyzGGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4ZP9GR6PfZz4f3jch;
	Fri, 28 Mar 2025 14:14:23 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id DB4F51A06D7;
	Fri, 28 Mar 2025 14:14:46 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgDHK2BSPuZnfAUtHw--.25875S5;
	Fri, 28 Mar 2025 14:14:46 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: hch@lst.de,
	xni@redhat.com,
	colyli@kernel.org,
	axboe@kernel.dk,
	agk@redhat.com,
	snitzer@kernel.org,
	mpatocka@redhat.com,
	song@kernel.org,
	yukuai3@huawei.com
Cc: linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	dm-devel@lists.linux.dev,
	linux-raid@vger.kernel.org,
	yukuai1@huaweicloud.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com
Subject: [PATCH RFC v2 01/14] block: factor out a helper bdev_file_alloc()
Date: Fri, 28 Mar 2025 14:08:40 +0800
Message-Id: <20250328060853.4124527-2-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250328060853.4124527-1-yukuai1@huaweicloud.com>
References: <20250328060853.4124527-1-yukuai1@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgDHK2BSPuZnfAUtHw--.25875S5
X-Coremail-Antispam: 1UD129KBjvJXoW7Kr4rXFW5WryxXr47Ar1UJrb_yoW5JFWxpF
	Z8Jayrtry8Gr1qqFW2va17JF15twnxGr1UZF9xW343ArZrtr1vkFs5CrW5u34Fy3yktF4D
	XF45WryUWryFkaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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
	kF1VAFwI0_GFv_WrylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY
	6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0x
	vEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVj
	vjDU0xZFpf9x0JU4OJ5UUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

To allocate bdev_file without opening the bdev, mdraid will create hidden
disk to manage internal bitmap in following patches, while the hidden disk
can't be opened by user, and mdraid will initialize this file to manage
bitmap IO.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 block/bdev.c           | 21 ++++++++++++++++-----
 include/linux/blkdev.h |  1 +
 2 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/block/bdev.c b/block/bdev.c
index 9d73a8fbf7f9..6b4ba6cb04c9 100644
--- a/block/bdev.c
+++ b/block/bdev.c
@@ -989,12 +989,26 @@ static unsigned blk_to_file_flags(blk_mode_t mode)
 	return flags;
 }
 
+struct file *bdev_file_alloc(struct block_device *bdev, blk_mode_t mode)
+{
+	unsigned int flags = blk_to_file_flags(mode);
+	struct file *bdev_file;
+
+	bdev_file = alloc_file_pseudo_noaccount(BD_INODE(bdev),
+			blockdev_mnt, "", flags | O_LARGEFILE, &def_blk_fops);
+
+	if (!IS_ERR(bdev_file))
+		ihold(BD_INODE(bdev));
+
+	return bdev_file;
+}
+EXPORT_SYMBOL_GPL(bdev_file_alloc);
+
 struct file *bdev_file_open_by_dev(dev_t dev, blk_mode_t mode, void *holder,
 				   const struct blk_holder_ops *hops)
 {
 	struct file *bdev_file;
 	struct block_device *bdev;
-	unsigned int flags;
 	int ret;
 
 	ret = bdev_permission(dev, mode, holder);
@@ -1005,14 +1019,11 @@ struct file *bdev_file_open_by_dev(dev_t dev, blk_mode_t mode, void *holder,
 	if (!bdev)
 		return ERR_PTR(-ENXIO);
 
-	flags = blk_to_file_flags(mode);
-	bdev_file = alloc_file_pseudo_noaccount(BD_INODE(bdev),
-			blockdev_mnt, "", flags | O_LARGEFILE, &def_blk_fops);
+	bdev_file = bdev_file_alloc(bdev, mode);
 	if (IS_ERR(bdev_file)) {
 		blkdev_put_no_open(bdev);
 		return bdev_file;
 	}
-	ihold(BD_INODE(bdev));
 
 	ret = bdev_open(bdev, mode, holder, hops, bdev_file);
 	if (ret) {
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 248416ecd01c..dede6721374a 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1639,6 +1639,7 @@ extern const struct blk_holder_ops fs_holder_ops;
 	(BLK_OPEN_READ | BLK_OPEN_RESTRICT_WRITES | \
 	 (((flags) & SB_RDONLY) ? 0 : BLK_OPEN_WRITE))
 
+struct file *bdev_file_alloc(struct block_device *bdev, blk_mode_t mode);
 struct file *bdev_file_open_by_dev(dev_t dev, blk_mode_t mode, void *holder,
 		const struct blk_holder_ops *hops);
 struct file *bdev_file_open_by_path(const char *path, blk_mode_t mode,
-- 
2.39.2

