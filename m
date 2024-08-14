Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 021E214375C;
	Wed, 14 Aug 2024 07:15:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723619736; cv=none; b=rv/qZFukzaXTVH99nR1/HfiQx7QiNj5t2PGdv4EPisnsQgHJMNXLVeiEnj9b53tgI+XG8l5sgla8OO9nTy9Bq0BC8O8z3NPPiqGples5iYBcUiTBedFv5vVRGJZ162wXEJGokcRoiDbmikpY3+JfKwg+z4OVxos3vHBndDkdIU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723619736; c=relaxed/simple;
	bh=vSz0p/d0geOr6OxA2F1D8TNhimdp/55+P21nKi4ogOQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=iw3Kf4BCRRZ8vdb1e2YayRrHnG2y3P9PbnOhhDfxOxoo+pLnkoF8EVBLpuVeXXyRR6rhEHqIseJERJymm6ufOf/ne9oicJbdqjcrGSozHNPhbU89MOhE6ZhUNTwIEHX2Lr8c19Vafd8KMfxwuvh5TMY4Gz1caIibXlfdgPIkWmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4WkKK4538mz4f3jjx;
	Wed, 14 Aug 2024 15:15:20 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 0D4561A0359;
	Wed, 14 Aug 2024 15:15:30 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgBHboSLWbxmIxKbBg--.47745S14;
	Wed, 14 Aug 2024 15:15:29 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: mariusz.tkaczyk@linux.intel.com,
	hch@infradead.org,
	song@kernel.org
Cc: linux-kernel@vger.kernel.org,
	linux-raid@vger.kernel.org,
	yukuai3@huawei.com,
	yukuai1@huaweicloud.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com
Subject: [PATCH RFC -next v2 10/41] md/md-bitmap: introduce struct bitmap_operations
Date: Wed, 14 Aug 2024 15:10:42 +0800
Message-Id: <20240814071113.346781-11-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240814071113.346781-1-yukuai1@huaweicloud.com>
References: <20240814071113.346781-1-yukuai1@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgBHboSLWbxmIxKbBg--.47745S14
X-Coremail-Antispam: 1UD129KBjvJXoW7CrW7ZrWkCry8tr47Wr4UArb_yoW8tr13pF
	Z7X34fCw15JF47Xw1UXFWkuFyrX3WkKrZrKryfCw4ruFyDXF9xGF4rWayqyw1DWFW3AFsx
	Xw15KryUur18Xr7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUP014x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
	kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
	z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F
	4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq
	3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7
	IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4U
	M4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCY1x0262kKe7AKxVWUtV
	W8ZwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v2
	6r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2
	Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVW8JVW5JwCI42IY6xIIjxv20xvEc7CjxVAFwI0_
	Cr0_Gr1UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVW8JVWxJw
	CI42IY6I8E87Iv6xkF7I0E14v26r4UJVWxJrUvcSsGvfC2KfnxnUUI43ZEXa7VUbPC7UUU
	UUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

The structure is empty for now, and will be used in later patches to
merge in bitmap operations, so that bitmap implementation won't be
exposed.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/md-bitmap.c | 8 ++++++++
 drivers/md/md-bitmap.h | 4 ++++
 drivers/md/md.c        | 1 +
 drivers/md/md.h        | 1 +
 4 files changed, 14 insertions(+)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index ee3ed1e3daf9..eed3b930ade4 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -2711,3 +2711,11 @@ const struct attribute_group md_bitmap_group = {
 	.name = "bitmap",
 	.attrs = md_bitmap_attrs,
 };
+
+static struct bitmap_operations bitmap_ops = {
+};
+
+void mddev_set_bitmap_ops(struct mddev *mddev)
+{
+	mddev->bitmap_ops = &bitmap_ops;
+}
diff --git a/drivers/md/md-bitmap.h b/drivers/md/md-bitmap.h
index cad1de79775f..a8a5d4804174 100644
--- a/drivers/md/md-bitmap.h
+++ b/drivers/md/md-bitmap.h
@@ -245,7 +245,11 @@ struct md_bitmap_stats {
 	bool behind_wait;
 };
 
+struct bitmap_operations {
+};
+
 /* the bitmap API */
+void mddev_set_bitmap_ops(struct mddev *mddev);
 
 /* these are used only by md/bitmap */
 struct bitmap *md_bitmap_create(struct mddev *mddev, int slot);
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 628fa49170e1..f67f2540fd6c 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -772,6 +772,7 @@ int mddev_init(struct mddev *mddev)
 	mddev->resync_min = 0;
 	mddev->resync_max = MaxSector;
 	mddev->level = LEVEL_NONE;
+	mddev_set_bitmap_ops(mddev);
 
 	INIT_WORK(&mddev->sync_work, md_start_sync);
 	INIT_WORK(&mddev->del_work, mddev_delayed_delete);
diff --git a/drivers/md/md.h b/drivers/md/md.h
index a0d6827dced9..e56193f71ab4 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -536,6 +536,7 @@ struct mddev {
 	int				sync_checkers;	/* # of threads checking writes_pending */
 
 	struct bitmap			*bitmap; /* the bitmap for the device */
+	struct bitmap_operations	*bitmap_ops;
 	struct {
 		struct file		*file; /* the bitmap file */
 		loff_t			offset; /* offset from superblock of
-- 
2.39.2

