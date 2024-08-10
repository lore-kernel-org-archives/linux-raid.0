Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EBA627452;
	Sat, 10 Aug 2024 02:12:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723255978; cv=none; b=KP/Hd+DcMVv97mTyAxBKHuIcBPPr7Wfg/C5AtVIIfHe7ufPYzsuEJ6UwnLmoZh4xsolXea0Dwj84FdW38uPIQsq1m804goxZxHRoGTFr7eUx/+v9c/OcB2vEtMmzcGnr8Zze4fEyuvUb+cILviZeQHJ67DmyRqLnlHjH+FHIcAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723255978; c=relaxed/simple;
	bh=SR5ipG1SbKiZvkaVsKyWLmS9oRY42Cz5uykzVSnlZl4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=V92s0jvI45a07lXwcwwaKTsXiCNKGqG0UR/AJ8/VI1M7WQRmPwl/iz6cmvdGBcQ8c9rVAeTa60d0+QJ968YT55OPxRKvpHbrb+fhh8+foyvyUn31ma82nk2PVcm0f/pU105VyhOhF+jKMqmGb/qiyLjZfxyuz2da9RMItGyU9OM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=none smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4Wgknl5Zpkz4f3jk1;
	Sat, 10 Aug 2024 10:12:43 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id E361B1A07B6;
	Sat, 10 Aug 2024 10:12:52 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgAHL4WizLZmErwLBQ--.1937S5;
	Sat, 10 Aug 2024 10:12:52 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: song@kernel.org
Cc: linux-kernel@vger.kernel.org,
	linux-raid@vger.kernel.org,
	yukuai3@huawei.com,
	yukuai1@huaweicloud.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com
Subject: [PATCH RFC -next 01/26] md/md-bitmap: introduce struct bitmap_operations
Date: Sat, 10 Aug 2024 10:08:29 +0800
Message-Id: <20240810020854.797814-2-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240810020854.797814-1-yukuai1@huaweicloud.com>
References: <20240810020854.797814-1-yukuai1@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgAHL4WizLZmErwLBQ--.1937S5
X-Coremail-Antispam: 1UD129KBjvJXoW7CFW5CF4kAF4UuFyUAr17Awb_yoW8trW7pF
	Z3X34fAw15Jr4UXw1UXayDuFyrX3Z7trZrKrWxCw4ruFyDXF9xGF4rGFWqyw1DWF43AFnx
	Xw15KryUur18Xr7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUBl14x267AKxVW5JVWrJwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_Jr4l82xGYIkIc2
	x26xkF7I0E14v26r1I6r4UM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0
	Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Cr0_Gr1UM2
	8EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s0DM2AI
	xVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20x
	vE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xv
	r2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7MxkF7I0En4kS14v26r126r1DMx
	AIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_
	Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUAVWUtwCIc40Y0x0EwI
	xGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWx
	JwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcV
	C2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7VUjX18JUUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

The structure is empty for now, and will be used in later patches to
merge in bitmap operations, prepare to implement a new lock free
bitmap in the fulture.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/md-bitmap.c | 8 ++++++++
 drivers/md/md-bitmap.h | 4 ++++
 drivers/md/md.c        | 1 +
 drivers/md/md.h        | 1 +
 4 files changed, 14 insertions(+)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index 08232d8dc815..d9838fbcc9d7 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -2707,3 +2707,11 @@ const struct attribute_group md_bitmap_group = {
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
index bb9eb418780a..992feaf66d47 100644
--- a/drivers/md/md-bitmap.h
+++ b/drivers/md/md-bitmap.h
@@ -234,7 +234,11 @@ struct bitmap {
 	int cluster_slot;		/* Slot offset for clustered env */
 };
 
+struct bitmap_operations {
+};
+
 /* the bitmap API */
+void mddev_set_bitmap_ops(struct mddev *mddev);
 
 /* these are used only by md/bitmap */
 struct bitmap *md_bitmap_create(struct mddev *mddev, int slot);
diff --git a/drivers/md/md.c b/drivers/md/md.c
index d3a837506a36..f23138dd96a7 100644
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

