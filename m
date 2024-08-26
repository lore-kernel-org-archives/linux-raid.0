Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9D2C1420CC;
	Mon, 26 Aug 2024 07:49:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724658598; cv=none; b=Q9+5ML58dCcat5XyNxhRRhx29pnilAAW/8D4jPybIEcuRlj6aReyyogwsMCmA0BbtPkmy61BxOFwy2dcGIjbvnc0LFr+W0/ZaUGZGmGZZcz6zte6Eg+ShoicGYL0zdj50/KPhbT30rVbhIwts8jHx1KH7i0Nf+unVP/fSP6nr+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724658598; c=relaxed/simple;
	bh=z+tz8xN07Q4gKg3wBMEOi8JFldeSK3zsImOFfbLl3Ao=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=j9Fw3NXtm6xIzW9UinUYyo8fO93BPtLok/vxkOxK4itXbHvWlLmJvK2t/LU+35sqB2RmEAucT55ychSA2UqrFqqR/L3rjFiWkGJDp2R9p77F9JpzVu8btRRR6+AcEiY059fDFdTI/NrTC7ahGbrJG4wS6gTiNcZU/JiDuCuoE8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4WsjW63zzHz4f3l1s;
	Mon, 26 Aug 2024 15:49:38 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id E108F1A018D;
	Mon, 26 Aug 2024 15:49:53 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgAHL4WaM8xmWWIECw--.13849S17;
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
Subject: [PATCH md-6.12 v2 13/42] md/md-bitmap: merge md_bitmap_create() into bitmap_operations
Date: Mon, 26 Aug 2024 15:44:23 +0800
Message-Id: <20240826074452.1490072-14-yukuai1@huaweicloud.com>
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
X-CM-TRANSID:gCh0CgAHL4WaM8xmWWIECw--.13849S17
X-Coremail-Antispam: 1UD129KBjvJXoWxCr1xAFyUCryrtrWrZF13Jwb_yoW5AF15pr
	ZFqa45GrW3JFWrWw1UZFyq9a4Yqw1kKrZrtryxCw1ruF9rJFnxCF4rWF1jyw1DCa4fAFsx
	Xw15Gr18uF1xXF7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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
 drivers/md/md-bitmap.c | 5 +++--
 drivers/md/md-bitmap.h | 2 +-
 drivers/md/md.c        | 6 +++---
 3 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index 2f3ff8e64121..c534382f0b57 100644
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

