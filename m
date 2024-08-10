Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42F6714D714;
	Sat, 10 Aug 2024 02:13:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723255989; cv=none; b=oWLAd32326qw7ha+NtFnGHuf5cpcKhHPAEUWkbzYFV71g4dv/qil5f5VBxii0/hThk5i37/z9ecsCfxSZYVxdTO2QaNTEnTKdj7pPaNj8kBGNk40Wq6nwSUqDv/yCVqN0Ng3YQQun5vs4xpCYH+kooHGTAHAMTSpyiI4JBwMFic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723255989; c=relaxed/simple;
	bh=l5Bz3tr9NCdwvggLxieDHElxo/QNBgZqBT4V6Jg3sfg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=fG9Q4IJOx5AcpoFyxaz4B4kQZXB+OQSc/ucN2vCFAitbUg1VsFamWUvzpSiv5Q8ErWYXwrGTH3GHrWtmP+13J/C4oeWNDsdoB7drqMteiaZ+IGCBG+/Zz36UheCLjBTNl3L8gKnJu96s16tBmLEGR2wLahPjCha4OsxcMny8D+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4Wgknq44JDz4f3jrq;
	Sat, 10 Aug 2024 10:12:47 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 14DA51A0568;
	Sat, 10 Aug 2024 10:13:01 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgAHL4WizLZmErwLBQ--.1937S29;
	Sat, 10 Aug 2024 10:13:00 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: song@kernel.org
Cc: linux-kernel@vger.kernel.org,
	linux-raid@vger.kernel.org,
	yukuai3@huawei.com,
	yukuai1@huaweicloud.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com
Subject: [PATCH RFC -next 25/26] md/md-bitmap: merge md_bitmap_unplug() and md_bitmap_unplug_async()
Date: Sat, 10 Aug 2024 10:08:53 +0800
Message-Id: <20240810020854.797814-26-yukuai1@huaweicloud.com>
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
X-CM-TRANSID:gCh0CgAHL4WizLZmErwLBQ--.1937S29
X-Coremail-Antispam: 1UD129KBjvJXoW3JFy7Xw1DGF4fCryUJr15CFg_yoW7WFWUpr
	90q3s8CF45JFW3Xw1jyry2vF1Fv3Wvqr9rtry8Cw4ruFy3XF9xGF48GFWUtw1DCrnxCFs8
	Zw15tr95GF4rWF7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUPY14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
	kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
	z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F
	4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq
	3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7
	IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4U
	M4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCY1x0262kKe7AKxVWUAV
	WUtwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v2
	6r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1lIxkGc2
	Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVW5JVW7JwCI42IY6xIIjxv20xvEc7CjxVAFwI0_
	Gr1j6F4UJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Gr0_Cr
	1lIxAIcVC2z280aVCY1x0267AKxVW8Jr0_Cr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUvYLPU
	UUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

Add a new paramater "bool sync" for md_bitmap_unplug(), and remove the
exported md_bitmap_unplug_async(). Hence bitmap_operations only need one
op to cover them.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/md-bitmap.c | 23 +++++++++++++++--------
 drivers/md/md-bitmap.h |  3 +--
 drivers/md/md.c        |  2 +-
 drivers/md/raid1-10.c  |  5 +----
 drivers/md/raid5.c     |  2 +-
 5 files changed, 19 insertions(+), 16 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index 4f3ea6e51572..b08476746350 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -1030,7 +1030,7 @@ static int md_bitmap_file_test_bit(struct bitmap *bitmap, sector_t block)
 /* this gets called when the md device is ready to unplug its underlying
  * (slave) device queues -- before we let any writes go down, we need to
  * sync the dirty pages of the bitmap file to disk */
-void md_bitmap_unplug(struct bitmap *bitmap)
+static void bitmap_unplug(struct bitmap *bitmap)
 {
 	unsigned long i;
 	int dirty, need_write;
@@ -1062,7 +1062,6 @@ void md_bitmap_unplug(struct bitmap *bitmap)
 	if (test_bit(BITMAP_WRITE_ERROR, &bitmap->flags))
 		md_bitmap_file_kick(bitmap);
 }
-EXPORT_SYMBOL(md_bitmap_unplug);
 
 struct bitmap_unplug_work {
 	struct work_struct work;
@@ -1075,11 +1074,11 @@ static void md_bitmap_unplug_fn(struct work_struct *work)
 	struct bitmap_unplug_work *unplug_work =
 		container_of(work, struct bitmap_unplug_work, work);
 
-	md_bitmap_unplug(unplug_work->bitmap);
+	bitmap_unplug(unplug_work->bitmap);
 	complete(unplug_work->done);
 }
 
-void md_bitmap_unplug_async(struct bitmap *bitmap)
+static void bitmap_unplug_async(struct bitmap *bitmap)
 {
 	DECLARE_COMPLETION_ONSTACK(done);
 	struct bitmap_unplug_work unplug_work;
@@ -1091,7 +1090,15 @@ void md_bitmap_unplug_async(struct bitmap *bitmap)
 	queue_work(md_bitmap_wq, &unplug_work.work);
 	wait_for_completion(&done);
 }
-EXPORT_SYMBOL(md_bitmap_unplug_async);
+
+void md_bitmap_unplug(struct bitmap *bitmap, bool sync)
+{
+	if (sync)
+		bitmap_unplug(bitmap);
+	else
+		bitmap_unplug_async(bitmap);
+}
+EXPORT_SYMBOL(md_bitmap_unplug);
 
 static void md_bitmap_set_memory_bits(struct bitmap *bitmap, sector_t offset, int needed);
 
@@ -2060,9 +2067,9 @@ static int bitmap_copy_from_slot(struct mddev *mddev, int slot, sector_t *low,
 		for (i = 0; i < bitmap->storage.file_pages; i++)
 			if (test_page_attr(bitmap, i, BITMAP_PAGE_PENDING))
 				set_page_attr(bitmap, i, BITMAP_PAGE_NEEDWRITE);
-		md_bitmap_unplug(bitmap);
+		bitmap_unplug(bitmap);
 	}
-	md_bitmap_unplug(mddev->bitmap);
+	bitmap_unplug(mddev->bitmap);
 	*low = lo;
 	*high = hi;
 	__bitmap_free(bitmap);
@@ -2296,7 +2303,7 @@ static int bitmap_resize(struct bitmap *bitmap, sector_t blocks,
 	spin_unlock_irq(&bitmap->counts.lock);
 
 	if (!init) {
-		md_bitmap_unplug(bitmap);
+		bitmap_unplug(bitmap);
 		bitmap->mddev->pers->quiesce(bitmap->mddev, 0);
 	}
 	ret = 0;
diff --git a/drivers/md/md-bitmap.h b/drivers/md/md-bitmap.h
index f67e030139cd..054e85c4a704 100644
--- a/drivers/md/md-bitmap.h
+++ b/drivers/md/md-bitmap.h
@@ -460,8 +460,7 @@ static inline void md_bitmap_free(struct mddev *mddev, struct bitmap *bitmap)
 	return mddev->bitmap_ops->free(bitmap);
 }
 
-void md_bitmap_unplug(struct bitmap *bitmap);
-void md_bitmap_unplug_async(struct bitmap *bitmap);
+void md_bitmap_unplug(struct bitmap *bitmap, bool sync);
 
 static inline bool md_bitmap_enabled(struct bitmap *bitmap)
 {
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 841539a0be1b..2e6270c47317 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -4691,7 +4691,7 @@ bitmap_store(struct mddev *mddev, const char *buf, size_t len)
 		md_bitmap_dirty_bits(mddev, chunk, end_chunk);
 		buf = skip_spaces(end);
 	}
-	md_bitmap_unplug(mddev->bitmap); /* flush the bits to disk */
+	md_bitmap_unplug(mddev->bitmap, true); /* flush the bits to disk */
 out:
 	mddev_unlock(mddev);
 	return len;
diff --git a/drivers/md/raid1-10.c b/drivers/md/raid1-10.c
index 2ea1710a3b70..e8410d0cc96f 100644
--- a/drivers/md/raid1-10.c
+++ b/drivers/md/raid1-10.c
@@ -168,10 +168,7 @@ static inline bool raid1_add_bio_to_plug(struct mddev *mddev, struct bio *bio,
  */
 static inline void raid1_prepare_flush_writes(struct bitmap *bitmap)
 {
-	if (current->bio_list)
-		md_bitmap_unplug_async(bitmap);
-	else
-		md_bitmap_unplug(bitmap);
+	md_bitmap_unplug(bitmap, current->bio_list == NULL);
 }
 
 /*
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 8b1e2157a798..99332649bac3 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -6766,7 +6766,7 @@ static void raid5d(struct md_thread *thread)
 			/* Now is a good time to flush some bitmap updates */
 			conf->seq_flush++;
 			spin_unlock_irq(&conf->device_lock);
-			md_bitmap_unplug(mddev->bitmap);
+			md_bitmap_unplug(mddev->bitmap, true);
 			spin_lock_irq(&conf->device_lock);
 			conf->seq_write = conf->seq_flush;
 			activate_bit_delay(conf, conf->temp_inactive_list);
-- 
2.39.2

