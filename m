Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EE5C13FD84;
	Mon, 26 Aug 2024 07:49:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724658598; cv=none; b=aICbIJKZoBvIYwBltz9FSezT9kVVodRiZvIwU+dVAHYi2NZbkPO+BMaiERQU2becA7vuwBaVeLbGyBJ6nMqFXnueK4K3mf3+zWdmb6sGu5cZqyL6hdwN30yedhchGBeEHqZJC/hZnO1XMYn+vwBsyZLeKAVGzVSqvpD5DViNSy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724658598; c=relaxed/simple;
	bh=waWdmClVYHUJcwTJ7q/XbihfG6tID3O9954w/+y7HOY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=KPVaaHXFVoIQY9GS+vWW5AYp2od4V6HPaDlXd3Hq+Rb3ImFE+EneXBiC0OUNuyOxPeubLwatQ1rkvq6enTCugBW1HdlGZb2YqlmWgH5lxU6PTj5+77o1rIZRrXpClW+gCBUtclAqcTDwTjmG3e5TfUJovSgCNgnnHaFu7CG2H2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4WsjW70D1jz4f3jR1;
	Mon, 26 Aug 2024 15:49:39 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 7B7B91A0568;
	Mon, 26 Aug 2024 15:49:53 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgAHL4WaM8xmWWIECw--.13849S16;
	Mon, 26 Aug 2024 15:49:53 +0800 (CST)
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
Subject: [PATCH md-6.12 v2 12/42] md/md-bitmap: simplify md_bitmap_create() + md_bitmap_load()
Date: Mon, 26 Aug 2024 15:44:22 +0800
Message-Id: <20240826074452.1490072-13-yukuai1@huaweicloud.com>
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
X-CM-TRANSID:gCh0CgAHL4WaM8xmWWIECw--.13849S16
X-Coremail-Antispam: 1UD129KBjvJXoWxGFWkCF45Zr4xAFykGF1xZrb_yoW7Jr1rpw
	s7t3Z8GrWfJrW3Wr17ZFyq93WYqr1vgr9rtryxGw1ruF13AFnxuF4rWF12y34jkFyrJFsx
	Xw45Kr1UCF47WF7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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
index 69d9c959fe49..2f3ff8e64121 100644
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

