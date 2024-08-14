Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9294C1442EA;
	Wed, 14 Aug 2024 07:15:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723619738; cv=none; b=nnheWq7H42MhGTSNBd2pN7UKowYKKmcf7xQynwzpglElvGnfMkkjuatayTxmBrEg2QfxGSmpkfGjYImIeUuFwjYm7MHdKYQsXRtTpaLWsGzfhOy2kr9Mdx+ez+Dg0y0xzlsdVJampjiSouUYFhjn2GH520Hzk34ixjlD1fy2K1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723619738; c=relaxed/simple;
	bh=qJ5Ws8gFElh5+O0qOkHmRBc25ywKKEZL54O1PFiEM6k=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Dnn87DTJpNKZ5c28POSTwwhB2Nyb6qcAcCaP6Z/vzsJbgONm0XBPqW2akwnt93uisV14Vvd7ym4dLd3hxbP4m4C6SEZRg3mi0+4wD2aFBzuIVV1ejTrb8C6KTAwkKy2CQR5tdvxVfLrdBgINS1XG/RIrA4JG9oZ7NoKMXRUAnoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4WkKK06x9yz4f3kvl;
	Wed, 14 Aug 2024 15:15:16 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id A8AC11A0359;
	Wed, 14 Aug 2024 15:15:31 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgBHboSLWbxmIxKbBg--.47745S18;
	Wed, 14 Aug 2024 15:15:31 +0800 (CST)
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
Subject: [PATCH RFC -next v2 14/41] md/md-bitmap: merge md_bitmap_destroy() into bitmap_operations
Date: Wed, 14 Aug 2024 15:10:46 +0800
Message-Id: <20240814071113.346781-15-yukuai1@huaweicloud.com>
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
X-CM-TRANSID:gCh0CgBHboSLWbxmIxKbBg--.47745S18
X-Coremail-Antispam: 1UD129KBjvJXoWxXrW5ArW5tw4xur17Kry8Zrb_yoWrArW5pa
	yxt3Z8Kr1YqrW3Wr4UAFWq9a4FqF1ktr9xKryxWw1rCFn3JrnxWF4rWFyUtw1fWa4rAFs0
	qw45tr1rWr1UWFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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

So that the implementation won't be exposed, and it'll be possible
to invent a new bitmap by replacing bitmap_operations.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/md-bitmap.c |  7 ++++---
 drivers/md/md-bitmap.h |  2 +-
 drivers/md/md.c        | 15 ++++++++-------
 3 files changed, 13 insertions(+), 11 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index 0113a972e42d..94cf3c6e96e3 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -1853,7 +1853,7 @@ void md_bitmap_wait_behind_writes(struct mddev *mddev)
 }
 EXPORT_SYMBOL_GPL(md_bitmap_wait_behind_writes);
 
-void md_bitmap_destroy(struct mddev *mddev)
+static void bitmap_destroy(struct mddev *mddev)
 {
 	struct bitmap *bitmap = mddev->bitmap;
 
@@ -2381,7 +2381,7 @@ location_store(struct mddev *mddev, const char *buf, size_t len)
 			goto out;
 		}
 
-		md_bitmap_destroy(mddev);
+		bitmap_destroy(mddev);
 		mddev->bitmap_info.offset = 0;
 		if (mddev->bitmap_info.file) {
 			struct file *f = mddev->bitmap_info.file;
@@ -2424,7 +2424,7 @@ location_store(struct mddev *mddev, const char *buf, size_t len)
 			rv = bitmap_load(mddev);
 			if (rv) {
 				mddev->bitmap_info.offset = 0;
-				md_bitmap_destroy(mddev);
+				bitmap_destroy(mddev);
 				goto out;
 			}
 		}
@@ -2721,6 +2721,7 @@ const struct attribute_group md_bitmap_group = {
 static struct bitmap_operations bitmap_ops = {
 	.create			= bitmap_create,
 	.load			= bitmap_load,
+	.destroy		= bitmap_destroy,
 };
 
 void mddev_set_bitmap_ops(struct mddev *mddev)
diff --git a/drivers/md/md-bitmap.h b/drivers/md/md-bitmap.h
index ba912f5f3450..9376bbeb4698 100644
--- a/drivers/md/md-bitmap.h
+++ b/drivers/md/md-bitmap.h
@@ -248,6 +248,7 @@ struct md_bitmap_stats {
 struct bitmap_operations {
 	int (*create)(struct mddev *mddev, int slot);
 	int (*load)(struct mddev *mddev);
+	void (*destroy)(struct mddev *mddev);
 };
 
 /* the bitmap API */
@@ -255,7 +256,6 @@ void mddev_set_bitmap_ops(struct mddev *mddev);
 
 /* these are used only by md/bitmap */
 void md_bitmap_flush(struct mddev *mddev);
-void md_bitmap_destroy(struct mddev *mddev);
 
 void md_bitmap_print_sb(struct bitmap *bitmap);
 void md_bitmap_update_sb(struct bitmap *bitmap);
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 2fe25a6257e6..7aecd99d50e2 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -6284,7 +6284,7 @@ int md_run(struct mddev *mddev)
 		pers->free(mddev, mddev->private);
 	mddev->private = NULL;
 	module_put(pers->owner);
-	md_bitmap_destroy(mddev);
+	mddev->bitmap_ops->destroy(mddev);
 abort:
 	bioset_exit(&mddev->io_clone_set);
 exit_sync_set:
@@ -6306,7 +6306,7 @@ int do_md_run(struct mddev *mddev)
 
 	err = mddev->bitmap_ops->load(mddev);
 	if (err) {
-		md_bitmap_destroy(mddev);
+		mddev->bitmap_ops->destroy(mddev);
 		goto out;
 	}
 
@@ -6492,7 +6492,8 @@ static void mddev_detach(struct mddev *mddev)
 static void __md_stop(struct mddev *mddev)
 {
 	struct md_personality *pers = mddev->pers;
-	md_bitmap_destroy(mddev);
+
+	mddev->bitmap_ops->destroy(mddev);
 	mddev_detach(mddev);
 	spin_lock(&mddev->lock);
 	mddev->pers = NULL;
@@ -7275,11 +7276,11 @@ static int set_bitmap_file(struct mddev *mddev, int fd)
 				err = mddev->bitmap_ops->load(mddev);
 
 			if (err) {
-				md_bitmap_destroy(mddev);
+				mddev->bitmap_ops->destroy(mddev);
 				fd = -1;
 			}
 		} else if (fd < 0) {
-			md_bitmap_destroy(mddev);
+			mddev->bitmap_ops->destroy(mddev);
 		}
 	}
 
@@ -7569,7 +7570,7 @@ static int update_array_info(struct mddev *mddev, mdu_array_info_t *info)
 				rv = mddev->bitmap_ops->load(mddev);
 
 			if (rv)
-				md_bitmap_destroy(mddev);
+				mddev->bitmap_ops->destroy(mddev);
 		} else {
 			struct md_bitmap_stats stats;
 
@@ -7596,7 +7597,7 @@ static int update_array_info(struct mddev *mddev, mdu_array_info_t *info)
 				module_put(md_cluster_mod);
 				mddev->safemode_delay = DEFAULT_SAFEMODE_DELAY;
 			}
-			md_bitmap_destroy(mddev);
+			mddev->bitmap_ops->destroy(mddev);
 			mddev->bitmap_info.offset = 0;
 		}
 	}
-- 
2.39.2

