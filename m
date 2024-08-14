Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BB2213D503;
	Wed, 14 Aug 2024 07:15:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723619734; cv=none; b=Pu79A4Ps1nolOUQLGmcNCRDwOS0wM4CdpoW2ZWkQiwvapnG6Rb6k3ChiqryD4l7/J18xiAAseGk1cHXzMRnOZiZnabbpb1Lh96TWvRXA08bIwUJDmIrXMPhXMyaCaldhd8Sd6u39nQ8rOc2jQfCONicDVvy+CvuSJ9IMRC/lYwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723619734; c=relaxed/simple;
	bh=772NXbP9RG9a/cA3xYoBLxJp0Jv2SLlilJnw1dsX/NQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=CG19tWx6ML7MG2AhA1FdprO85pATjEiVFuWr26YRY/e5LtNBPu2/vBsOfPYgwUPbqil9DAblo2ZpQsp6WwmgM/u2qU9o6LU+5z1pryBcgSDsm0K8lsjq/ARV+ZbCDYeNqj0psMShwUEl/iH/Ej8Cc7DAEBmXXzsaPBNrmoyWgeY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4WkKJz69Hrz4f3jXK;
	Wed, 14 Aug 2024 15:15:15 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 99DD11A018D;
	Wed, 14 Aug 2024 15:15:29 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgBHboSLWbxmIxKbBg--.47745S13;
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
Subject: [PATCH RFC -next v2 09/41] md/md-bitmap: add a new helper md_bitmap_set_pages()
Date: Wed, 14 Aug 2024 15:10:41 +0800
Message-Id: <20240814071113.346781-10-yukuai1@huaweicloud.com>
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
X-CM-TRANSID:gCh0CgBHboSLWbxmIxKbBg--.47745S13
X-Coremail-Antispam: 1UD129KBjvJXoWxJw48tF45tr4xtw1rWF48JFb_yoW5WF1DpF
	4jq343Cw45JrW3X3WUXrykCFy5tw1DtrZrtryfC3s5uFy2qF9IgF48GFyjyw17GF13JFsI
	q3W5Kr1Uur18XrJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUPj14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
	kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
	z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F
	4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq
	3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7
	IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4U
	M4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCY1x0262kKe7AKxVWUtV
	W8ZwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v2
	6r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2
	Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUCVW8JwCI42IY6xIIjxv20xvEc7CjxVAFwI0_
	Cr0_Gr1UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVW8JVWxJw
	CI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjfUOyIUUUUU
	U
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

Currently md-cluster will set bitmap->counts.pages directly, add a
helper to do this to avoid dereferencing bitmap directly.

Noted that after this patch bitmap is not dereferenced directly anymore
and following patches will move the structure inside md-bitmap.c.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/md-bitmap.c  | 6 ++++++
 drivers/md/md-bitmap.h  | 1 +
 drivers/md/md-cluster.c | 4 +---
 3 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index 7dcb025207b8..ee3ed1e3daf9 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -2094,6 +2094,12 @@ int md_bitmap_copy_from_slot(struct mddev *mddev, int slot,
 }
 EXPORT_SYMBOL_GPL(md_bitmap_copy_from_slot);
 
+void md_bitmap_set_pages(struct bitmap *bitmap, unsigned long pages)
+{
+	bitmap->counts.pages = pages;
+}
+EXPORT_SYMBOL_GPL(md_bitmap_set_pages);
+
 int md_bitmap_get_stats(struct bitmap *bitmap, struct md_bitmap_stats *stats)
 {
 	bitmap_super_t *sb;
diff --git a/drivers/md/md-bitmap.h b/drivers/md/md-bitmap.h
index 119644907f89..cad1de79775f 100644
--- a/drivers/md/md-bitmap.h
+++ b/drivers/md/md-bitmap.h
@@ -284,6 +284,7 @@ int md_bitmap_resize(struct bitmap *bitmap, sector_t blocks,
 struct bitmap *get_bitmap_from_slot(struct mddev *mddev, int slot);
 int md_bitmap_copy_from_slot(struct mddev *mddev, int slot,
 			     sector_t *lo, sector_t *hi, bool clear_bits);
+void md_bitmap_set_pages(struct bitmap *bitmap, unsigned long pages);
 void md_bitmap_free(struct bitmap *bitmap);
 void md_bitmap_wait_behind_writes(struct mddev *mddev);
 
diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
index e4ad8efdc63b..1938eadb379b 100644
--- a/drivers/md/md-cluster.c
+++ b/drivers/md/md-cluster.c
@@ -1143,7 +1143,6 @@ static int update_bitmap_size(struct mddev *mddev, sector_t size)
 
 static int resize_bitmaps(struct mddev *mddev, sector_t newsize, sector_t oldsize)
 {
-	struct bitmap_counts *counts;
 	struct dlm_lock_resource *bm_lockres;
 	struct bitmap *bitmap = mddev->bitmap;
 	struct md_bitmap_stats stats;
@@ -1174,7 +1173,6 @@ static int resize_bitmaps(struct mddev *mddev, sector_t newsize, sector_t oldsiz
 			bitmap = NULL;
 			goto out;
 		}
-		counts = &bitmap->counts;
 
 		rv = md_bitmap_get_stats(bitmap, &stats);
 		if (rv)
@@ -1192,7 +1190,7 @@ static int resize_bitmaps(struct mddev *mddev, sector_t newsize, sector_t oldsiz
 		bm_lockres->flags |= DLM_LKF_NOQUEUE;
 		rv = dlm_lock_sync(bm_lockres, DLM_LOCK_PW);
 		if (!rv)
-			counts->pages = my_pages;
+			md_bitmap_set_pages(bitmap, my_pages);
 		lockres_free(bm_lockres);
 
 		if (my_pages != stats.pages)
-- 
2.39.2

