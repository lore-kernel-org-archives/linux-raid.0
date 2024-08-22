Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4088817545;
	Thu, 22 Aug 2024 02:52:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724295129; cv=none; b=d6Xm6HFV/BAPWPU/1AGoOwsqxsvjO9gNCWwcYVVJaA8CSYkhn2QrMpYKJ23Vsb5jkSo9aNCjoCRYXlBRpr6teN9HReke78C2GplFcpZ2NKkA8YsgN4IgWwrzFG5xf/4RwfhYr2lnTxlbjZoNKrRIx/cGnMQPc/Tia6rHhvc5Xzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724295129; c=relaxed/simple;
	bh=YvQeLhix7uZd92OgBkJoiG5V4s6NkePZnTUcMokNrMA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=dZ9qZaejYoJFjHIWPjRUeabyKShlgPJJaqGblKFJYgM4yJ5FfSDDAxrZtcJMZWmTqKY7WVovGw4QtgK6iPGtZWwHmyNptkI9CeeMdp87Tl8O38uNKr/mYmMnDMXTZ1glk20D5e1cYDFAm7LNj2vW5b5qpJ5X8ei9rB584BO83Go=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4Wq75K35gDz4f3nJq;
	Thu, 22 Aug 2024 10:51:49 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 8D9A11A018D;
	Thu, 22 Aug 2024 10:52:04 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgAXPoTNp8ZmyXl2CQ--.42363S14;
	Thu, 22 Aug 2024 10:52:04 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: song@kernel.org,
	mariusz.tkaczyk@linux.intel.com,
	l@damenly.org,
	xni@redhat.com
Cc: linux-kernel@vger.kernel.org,
	linux-raid@vger.kernel.org,
	yukuai3@huawei.com,
	yukuai1@huaweicloud.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com
Subject: [PATCH md-6.12 10/41] md/md-bitmap: introduce struct bitmap_operations
Date: Thu, 22 Aug 2024 10:46:47 +0800
Message-Id: <20240822024718.2158259-11-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240822024718.2158259-1-yukuai1@huaweicloud.com>
References: <20240822024718.2158259-1-yukuai1@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgAXPoTNp8ZmyXl2CQ--.42363S14
X-Coremail-Antispam: 1UD129KBjvJXoW7CrW7ZrWkCry8Kr48Jw1UKFg_yoW8tr13pF
	ZxX34fuw15Jr47Xw1UWFWDuFyFq3Z7KrZrKrWxC395uFyDZF9xGF4rWayqyw1DWrW3CFsx
	Xw15KryUur18Xr7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUma14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
	kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
	z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Cr1j6r
	xdM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s0D
	M2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjx
	v20xvE14v26r106r15McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1l
	F7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7M4IIrI8v6xkF7I0E8cxan2
	IY04v7MxkF7I0En4kS14v26r1q6r43MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY
	6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17
	CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r4j6ryUMIIF
	0xvE2Ix0cI8IcVCY1x0267AKxVW8Jr0_Cr1UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCw
	CI42IY6I8E87Iv67AKxVW8JVWxJwCI42IY6I8E87Iv6xkF7I0E14v26r4UJVWxJrUvcSsG
	vfC2KfnxnUUI43ZEXa7VU1zpBDUUUUU==
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
index 61132c82add7..2d044e2d2df6 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -2714,3 +2714,11 @@ const struct attribute_group md_bitmap_group = {
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
index c4d64311c0e8..14c21ab42f9e 100644
--- a/drivers/md/md-bitmap.h
+++ b/drivers/md/md-bitmap.h
@@ -246,7 +246,11 @@ struct md_bitmap_stats {
 	struct file	*file;
 };
 
+struct bitmap_operations {
+};
+
 /* the bitmap API */
+void mddev_set_bitmap_ops(struct mddev *mddev);
 
 /* these are used only by md/bitmap */
 struct bitmap *md_bitmap_create(struct mddev *mddev, int slot);
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 53e10dc28f72..de2bc11783c2 100644
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

