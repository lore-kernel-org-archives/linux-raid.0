Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8277C23774;
	Thu, 22 Aug 2024 02:52:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724295130; cv=none; b=Eendg5py1PMKIbHlbtAYsbHRDTrMfi02AKCQc0ZpSyNpzIaERLQ0ossHYqDRDxMMRImkmgdRpJ0XJrv8t/auJLXJt/xzPDDJP04RE7q7wPg/+L9UezvS5URwOfJtJkXt7HaWoknIH59SbEMpORULCs2Bm86P2QHm9VjqgEgJ2pY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724295130; c=relaxed/simple;
	bh=35C9Vsk7ciuZEUGmYCoVDbZJRq9mzGiFThjgf16Mrl8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=NuXUpp5bkpepCGnDGOVc7wFtEmFLI/8q2jV0j7VJvE5EGOIlR9G2PifJiRV2HgdU9+VFdWwGXRJYmTjQ45mXhr4vgfpC3SZHXdCCiJ6wi2/qkroGtuY062bvezO7eIUN6TXsn4ELEgUh13IXFbg2Tcsm+hVLZUklCT2lML9qX4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4Wq75M1tBVz4f3jdl;
	Thu, 22 Aug 2024 10:51:51 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 784A01A1873;
	Thu, 22 Aug 2024 10:52:05 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgAXPoTNp8ZmyXl2CQ--.42363S16;
	Thu, 22 Aug 2024 10:52:05 +0800 (CST)
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
Subject: [PATCH md-6.12 12/41] md/md-bitmap: merge md_bitmap_create() into bitmap_operations
Date: Thu, 22 Aug 2024 10:46:49 +0800
Message-Id: <20240822024718.2158259-13-yukuai1@huaweicloud.com>
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
X-CM-TRANSID:gCh0CgAXPoTNp8ZmyXl2CQ--.42363S16
X-Coremail-Antispam: 1UD129KBjvJXoWxCr1xAFyUCryrtrWrZF13Jwb_yoW5AF15pr
	s2qa45GrW3JFW5Ww1UZFyq9a4Fqw1vgrZrtryxCw1ruF9rJFnxCF4FgF1jywn8Ga4fAFsx
	Xw15Gr18uF1xXF7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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

So that the implementation won't be exposed, and it'll be possible
to invent a new bitmap by replacing bitmap_operations.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/md-bitmap.c | 5 +++--
 drivers/md/md-bitmap.h | 2 +-
 drivers/md/md.c        | 6 +++---
 3 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index 1241a10b7308..c0089e787215 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -1966,7 +1966,7 @@ static struct bitmap *__bitmap_create(struct mddev *mddev, int slot)
 	return ERR_PTR(err);
 }
 
-int md_bitmap_create(struct mddev *mddev, int slot)
+static int bitmap_create(struct mddev *mddev, int slot)
 {
 	struct bitmap *bitmap = __bitmap_create(mddev, slot);
 
@@ -2421,7 +2421,7 @@ location_store(struct mddev *mddev, const char *buf, size_t len)
 			}
 
 			mddev->bitmap_info.offset = offset;
-			rv = md_bitmap_create(mddev, -1);
+			rv = bitmap_create(mddev, -1);
 			if (rv)
 				goto out;
 
@@ -2723,6 +2723,7 @@ const struct attribute_group md_bitmap_group = {
 };
 
 static struct bitmap_operations bitmap_ops = {
+	.create			= bitmap_create,
 };
 
 void mddev_set_bitmap_ops(struct mddev *mddev)
diff --git a/drivers/md/md-bitmap.h b/drivers/md/md-bitmap.h
index d66f447f4be6..f4c4925102b6 100644
--- a/drivers/md/md-bitmap.h
+++ b/drivers/md/md-bitmap.h
@@ -247,13 +247,13 @@ struct md_bitmap_stats {
 };
 
 struct bitmap_operations {
+	int (*create)(struct mddev *mddev, int slot);
 };
 
 /* the bitmap API */
 void mddev_set_bitmap_ops(struct mddev *mddev);
 
 /* these are used only by md/bitmap */
-int md_bitmap_create(struct mddev *mddev, int slot);
 int md_bitmap_load(struct mddev *mddev);
 void md_bitmap_flush(struct mddev *mddev);
 void md_bitmap_destroy(struct mddev *mddev);
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 105faffaac54..f766f5b8d2d3 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -6224,7 +6224,7 @@ int md_run(struct mddev *mddev)
 	}
 	if (err == 0 && pers->sync_request &&
 	    (mddev->bitmap_info.file || mddev->bitmap_info.offset)) {
-		err = md_bitmap_create(mddev, -1);
+		err = mddev->bitmap_ops->create(mddev, -1);
 		if (err)
 			pr_warn("%s: failed to create bitmap (%d)\n",
 				mdname(mddev), err);
@@ -7282,7 +7282,7 @@ static int set_bitmap_file(struct mddev *mddev, int fd)
 	err = 0;
 	if (mddev->pers) {
 		if (fd >= 0) {
-			err = md_bitmap_create(mddev, -1);
+			err = mddev->bitmap_ops->create(mddev, -1);
 			if (!err)
 				err = md_bitmap_load(mddev);
 
@@ -7576,7 +7576,7 @@ static int update_array_info(struct mddev *mddev, mdu_array_info_t *info)
 				mddev->bitmap_info.default_offset;
 			mddev->bitmap_info.space =
 				mddev->bitmap_info.default_space;
-			rv = md_bitmap_create(mddev, -1);
+			rv = mddev->bitmap_ops->create(mddev, -1);
 			if (!rv)
 				rv = md_bitmap_load(mddev);
 
-- 
2.39.2

