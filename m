Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F85017C95;
	Thu, 22 Aug 2024 02:52:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724295131; cv=none; b=Uitk5lSptLXOXtkPVHsUBHny4wM0wERd77ZqJfct8XKrkFW6AtRxLivPmoo9kePjU1jLLhTUzAlcA8R76tv/GOSgogx4IaTUYlyMqEqKEhPMOAyNcwRu/mlug3Ekmb1oZQ342NQpWCLiflTsX3YfTj9RSCAiWV43PSbyD9m0QKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724295131; c=relaxed/simple;
	bh=1yfc/ptQCendhUglpFeDwNWbDfY88/mK583M0na0U/4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=lxABbhL5sHHtzF0VREwgX0HzsJCL8hBhvfdWwaymd0xW3tG2m5izNWw2z87Aq+Nzqnq/pKMx02cw/rJQyXgy/z3wtcCz9TTiOGV4gjrzhv0JUPD9m4+uOofghGKBilJ0Emd72KKszHUdOgUPD9VxokBhvmcgkG81nPjO+mNGg8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=none smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4Wq75L5kCsz4f3jsM;
	Thu, 22 Aug 2024 10:51:50 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 075591A018D;
	Thu, 22 Aug 2024 10:52:05 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgAXPoTNp8ZmyXl2CQ--.42363S15;
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
Subject: [PATCH md-6.12 11/41] md/md-bitmap: simplify md_bitmap_create() + md_bitmap_load()
Date: Thu, 22 Aug 2024 10:46:48 +0800
Message-Id: <20240822024718.2158259-12-yukuai1@huaweicloud.com>
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
X-CM-TRANSID:gCh0CgAXPoTNp8ZmyXl2CQ--.42363S15
X-Coremail-Antispam: 1UD129KBjvJXoWxGFWkCF45Zr4xAFykGF1xZrb_yoW7Jr1rpw
	s7t3Z8GrWfJrW3Wr17ZFyq93WYqr1vgr9rtryxGw1ruF13AFnxuF4rWF12y34jkFyrJFsx
	Xw45tr1UCF47WF7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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

Other than internal api get_bitmap_from_slot(), all other places will
set returned bitmap to mddev->bitmap. So move the setting of
mddev->bitmap into md_bitmap_create() to simplify code.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/md-bitmap.c | 23 +++++++++++++++--------
 drivers/md/md-bitmap.h |  2 +-
 drivers/md/md.c        | 30 +++++++++---------------------
 3 files changed, 25 insertions(+), 30 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index 2d044e2d2df6..1241a10b7308 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -1879,7 +1879,7 @@ void md_bitmap_destroy(struct mddev *mddev)
  * if this returns an error, bitmap_destroy must be called to do clean up
  * once mddev->bitmap is set
  */
-struct bitmap *md_bitmap_create(struct mddev *mddev, int slot)
+static struct bitmap *__bitmap_create(struct mddev *mddev, int slot)
 {
 	struct bitmap *bitmap;
 	sector_t blocks = mddev->resync_max_sectors;
@@ -1966,6 +1966,17 @@ struct bitmap *md_bitmap_create(struct mddev *mddev, int slot)
 	return ERR_PTR(err);
 }
 
+int md_bitmap_create(struct mddev *mddev, int slot)
+{
+	struct bitmap *bitmap = __bitmap_create(mddev, slot);
+
+	if (IS_ERR(bitmap))
+		return PTR_ERR(bitmap);
+
+	mddev->bitmap = bitmap;
+	return 0;
+}
+
 int md_bitmap_load(struct mddev *mddev)
 {
 	int err = 0;
@@ -2030,7 +2041,7 @@ struct bitmap *get_bitmap_from_slot(struct mddev *mddev, int slot)
 	int rv = 0;
 	struct bitmap *bitmap;
 
-	bitmap = md_bitmap_create(mddev, slot);
+	bitmap = __bitmap_create(mddev, slot);
 	if (IS_ERR(bitmap)) {
 		rv = PTR_ERR(bitmap);
 		return ERR_PTR(rv);
@@ -2384,7 +2395,6 @@ location_store(struct mddev *mddev, const char *buf, size_t len)
 	} else {
 		/* No bitmap, OK to set a location */
 		long long offset;
-		struct bitmap *bitmap;
 
 		if (strncmp(buf, "none", 4) == 0)
 			/* nothing to be done */;
@@ -2411,13 +2421,10 @@ location_store(struct mddev *mddev, const char *buf, size_t len)
 			}
 
 			mddev->bitmap_info.offset = offset;
-			bitmap = md_bitmap_create(mddev, -1);
-			if (IS_ERR(bitmap)) {
-				rv = PTR_ERR(bitmap);
+			rv = md_bitmap_create(mddev, -1);
+			if (rv)
 				goto out;
-			}
 
-			mddev->bitmap = bitmap;
 			rv = md_bitmap_load(mddev);
 			if (rv) {
 				mddev->bitmap_info.offset = 0;
diff --git a/drivers/md/md-bitmap.h b/drivers/md/md-bitmap.h
index 14c21ab42f9e..d66f447f4be6 100644
--- a/drivers/md/md-bitmap.h
+++ b/drivers/md/md-bitmap.h
@@ -253,7 +253,7 @@ struct bitmap_operations {
 void mddev_set_bitmap_ops(struct mddev *mddev);
 
 /* these are used only by md/bitmap */
-struct bitmap *md_bitmap_create(struct mddev *mddev, int slot);
+int md_bitmap_create(struct mddev *mddev, int slot);
 int md_bitmap_load(struct mddev *mddev);
 void md_bitmap_flush(struct mddev *mddev);
 void md_bitmap_destroy(struct mddev *mddev);
diff --git a/drivers/md/md.c b/drivers/md/md.c
index de2bc11783c2..105faffaac54 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -6224,16 +6224,10 @@ int md_run(struct mddev *mddev)
 	}
 	if (err == 0 && pers->sync_request &&
 	    (mddev->bitmap_info.file || mddev->bitmap_info.offset)) {
-		struct bitmap *bitmap;
-
-		bitmap = md_bitmap_create(mddev, -1);
-		if (IS_ERR(bitmap)) {
-			err = PTR_ERR(bitmap);
+		err = md_bitmap_create(mddev, -1);
+		if (err)
 			pr_warn("%s: failed to create bitmap (%d)\n",
 				mdname(mddev), err);
-		} else
-			mddev->bitmap = bitmap;
-
 	}
 	if (err)
 		goto bitmap_abort;
@@ -7288,14 +7282,10 @@ static int set_bitmap_file(struct mddev *mddev, int fd)
 	err = 0;
 	if (mddev->pers) {
 		if (fd >= 0) {
-			struct bitmap *bitmap;
-
-			bitmap = md_bitmap_create(mddev, -1);
-			if (!IS_ERR(bitmap)) {
-				mddev->bitmap = bitmap;
+			err = md_bitmap_create(mddev, -1);
+			if (!err)
 				err = md_bitmap_load(mddev);
-			} else
-				err = PTR_ERR(bitmap);
+
 			if (err) {
 				md_bitmap_destroy(mddev);
 				fd = -1;
@@ -7304,6 +7294,7 @@ static int set_bitmap_file(struct mddev *mddev, int fd)
 			md_bitmap_destroy(mddev);
 		}
 	}
+
 	if (fd < 0) {
 		struct file *f = mddev->bitmap_info.file;
 		if (f) {
@@ -7572,7 +7563,6 @@ static int update_array_info(struct mddev *mddev, mdu_array_info_t *info)
 			goto err;
 		}
 		if (info->state & (1<<MD_SB_BITMAP_PRESENT)) {
-			struct bitmap *bitmap;
 			/* add the bitmap */
 			if (mddev->bitmap) {
 				rv = -EEXIST;
@@ -7586,12 +7576,10 @@ static int update_array_info(struct mddev *mddev, mdu_array_info_t *info)
 				mddev->bitmap_info.default_offset;
 			mddev->bitmap_info.space =
 				mddev->bitmap_info.default_space;
-			bitmap = md_bitmap_create(mddev, -1);
-			if (!IS_ERR(bitmap)) {
-				mddev->bitmap = bitmap;
+			rv = md_bitmap_create(mddev, -1);
+			if (!rv)
 				rv = md_bitmap_load(mddev);
-			} else
-				rv = PTR_ERR(bitmap);
+
 			if (rv)
 				md_bitmap_destroy(mddev);
 		} else {
-- 
2.39.2

