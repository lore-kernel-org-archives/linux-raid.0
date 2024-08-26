Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5AB113D886;
	Mon, 26 Aug 2024 07:49:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724658599; cv=none; b=Trnbuah+tckaRWwi+sdxg0VrwKNY1JyAAewwzlmO0iYNXbVYx/pupd8jtry+xB7xMH4hTIh/vyaPvFzOE6Hu5l7Gyh/juqLdsRK3cRf8+LUea85ZMM+k3voXMtebkW4IaNsHXKTajEHx3PjEyi2GrbcAVEJ5p/rpcD3ZEaj5cU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724658599; c=relaxed/simple;
	bh=tGXC3TOM6SNblALdZvhkoKr/4t1eWbOzhsvmAzHTXzE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=nceT6FwdWcZC6NZbWpk/Z5b4CZUSqF5y4quBKzTnRgfe6925gWpm9CmeQKRf1cr6M4JHftncnC6sayOqDYEc6LD1H0sTYPDzh65TKh1G/n9b0TorAKJRE6nILM0i1Di+RpnJJc4iB5EoFmBQ0dYA/eyFIVX2GtB34jPnMLDF8kI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4WsjW64Rbhz4f3jMs;
	Mon, 26 Aug 2024 15:49:38 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 1836F1A06D7;
	Mon, 26 Aug 2024 15:49:53 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgAHL4WaM8xmWWIECw--.13849S15;
	Mon, 26 Aug 2024 15:49:52 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: mariusz.tkaczyk@linux.intel.com,
	xni@redhat.com,
	song@kernel.org
Cc: linux-kernel@vger.kernel.org,
	linux-raid@vger.kernel.org,
	yukuai3@huawei.com,
	yukuai1@huaweicloud.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com
Subject: [PATCH md-6.12 v2 11/42] md/md-bitmap: introduce struct bitmap_operations
Date: Mon, 26 Aug 2024 15:44:21 +0800
Message-Id: <20240826074452.1490072-12-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240826074452.1490072-1-yukuai1@huaweicloud.com>
References: <20240826074452.1490072-1-yukuai1@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgAHL4WaM8xmWWIECw--.13849S15
X-Coremail-Antispam: 1UD129KBjvJXoW7CrW7ZrWkCry8tFWxWFW8Crg_yoW8tr13pF
	ZxX34fZw15Jr47Xw1UWayDuFy5t3Z7KrZrKrWxCws5uFyDZF9xGF4rWayqyw1DWFW3CFnx
	Xw15KryUur18Xr7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUPY14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
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
	Gr1j6F4UJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Gr0_Cr
	1lIxAIcVC2z280aVCY1x0267AKxVW8Jr0_Cr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUQFxUU
	UUUU=
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
index 015997b4b835..69d9c959fe49 100644
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

