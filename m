Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0140156F41;
	Wed, 14 Aug 2024 07:15:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723619743; cv=none; b=P65voeJWhDg1bgFXHT8nPBqasjokjLKNjDiM2Y61+QZZ3ztQhXxNeDowUqDz6eZvIiNCY1EjQgGUoSX2aQC/TdeaOSloKoiOQicOMHdC5Dc0YsUMTx7ZIxaRrCc4czCXbLjeEQCh9mwWI9i6AcDDnrhrbffZo0g1kOXbbf52G08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723619743; c=relaxed/simple;
	bh=uvVXPxW2NQJRNUGUIK2/HnnamDct5OI8A+gDLVN9dhQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=TH3FYIMMIRCd+dtsZ+15UfoHHEMM2U1nNmwb76Q9VPKOSjIBMlYQ4zYgyyzbDooEOFiZry66AgQkv1Urt/LHkbMbQ2/eC7AlWjR0XeIieBre+Ynu3T0M/aM8UGCpSo6iMJZoM89Ct2KXQ1OT6e4oU7lWESDHBbaVMAc3UJwo7ak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=none smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4WkKK73fFsz4f3kvm;
	Wed, 14 Aug 2024 15:15:23 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 38CF61A18D2;
	Wed, 14 Aug 2024 15:15:38 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgBHboSLWbxmIxKbBg--.47745S34;
	Wed, 14 Aug 2024 15:15:38 +0800 (CST)
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
Subject: [PATCH RFC -next v2 30/41] md/md-bitmap: merge md_bitmap_unplug_async() into md_bitmap_unplug()
Date: Wed, 14 Aug 2024 15:11:02 +0800
Message-Id: <20240814071113.346781-31-yukuai1@huaweicloud.com>
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
X-CM-TRANSID:gCh0CgBHboSLWbxmIxKbBg--.47745S34
X-Coremail-Antispam: 1UD129KBjvJXoW3JF4DZF4DZF4DJr1kCryUZFb_yoWxtrykp3
	y5t345Gr45JFW5Xw1UArW2kF1Fq3WvqF9rtryfCwn5uFy3XF9xGF4rGFyUtw1DArnxGFs8
	Zw15tryDGF15WF7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUPY14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
	kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
	z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F
	4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq
	3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7
	IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4U
	M4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCY1x0262kKe7AKxVWUtV
	W8ZwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v2
	6r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2
	Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVW5JVW7JwCI42IY6xIIjxv20xvEc7CjxVAFwI0_
	Gr1j6F4UJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Gr0_Cr
	1lIxAIcVC2z280aVCY1x0267AKxVW8Jr0_Cr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUQFxUU
	UUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

Add a parameter 'bool sync' to distinguish them, and
md_bitmap_unplug_async() won't be exported anymore, hence
bitmap_operations only need one op to cover them.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/md-bitmap.c | 28 ++++++++++++++++++++--------
 drivers/md/md-bitmap.h |  3 +--
 drivers/md/md.c        |  2 +-
 drivers/md/raid1-10.c  |  7 ++-----
 drivers/md/raid1.c     |  2 +-
 drivers/md/raid10.c    |  4 ++--
 drivers/md/raid5.c     |  2 +-
 7 files changed, 28 insertions(+), 20 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index a9bf9ad71ba6..13aafe7e3ba8 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -1026,7 +1026,7 @@ static int md_bitmap_file_test_bit(struct bitmap *bitmap, sector_t block)
 /* this gets called when the md device is ready to unplug its underlying
  * (slave) device queues -- before we let any writes go down, we need to
  * sync the dirty pages of the bitmap file to disk */
-void md_bitmap_unplug(struct bitmap *bitmap)
+static void __bitmap_unplug(struct bitmap *bitmap)
 {
 	unsigned long i;
 	int dirty, need_write;
@@ -1058,7 +1058,6 @@ void md_bitmap_unplug(struct bitmap *bitmap)
 	if (test_bit(BITMAP_WRITE_ERROR, &bitmap->flags))
 		md_bitmap_file_kick(bitmap);
 }
-EXPORT_SYMBOL(md_bitmap_unplug);
 
 struct bitmap_unplug_work {
 	struct work_struct work;
@@ -1071,11 +1070,11 @@ static void md_bitmap_unplug_fn(struct work_struct *work)
 	struct bitmap_unplug_work *unplug_work =
 		container_of(work, struct bitmap_unplug_work, work);
 
-	md_bitmap_unplug(unplug_work->bitmap);
+	__bitmap_unplug(unplug_work->bitmap);
 	complete(unplug_work->done);
 }
 
-void md_bitmap_unplug_async(struct bitmap *bitmap)
+static void bitmap_unplug_async(struct bitmap *bitmap)
 {
 	DECLARE_COMPLETION_ONSTACK(done);
 	struct bitmap_unplug_work unplug_work;
@@ -1087,7 +1086,20 @@ void md_bitmap_unplug_async(struct bitmap *bitmap)
 	queue_work(md_bitmap_wq, &unplug_work.work);
 	wait_for_completion(&done);
 }
-EXPORT_SYMBOL(md_bitmap_unplug_async);
+
+void md_bitmap_unplug(struct mddev *mddev, bool sync)
+{
+	struct bitmap *bitmap = mddev->bitmap;
+
+	if (!bitmap)
+		return;
+
+	if (sync)
+		__bitmap_unplug(bitmap);
+	else
+		bitmap_unplug_async(bitmap);
+}
+EXPORT_SYMBOL_GPL(md_bitmap_unplug);
 
 static void md_bitmap_set_memory_bits(struct bitmap *bitmap, sector_t offset, int needed);
 
@@ -2108,9 +2120,9 @@ int md_bitmap_copy_from_slot(struct mddev *mddev, int slot,
 		for (i = 0; i < bitmap->storage.file_pages; i++)
 			if (test_page_attr(bitmap, i, BITMAP_PAGE_PENDING))
 				set_page_attr(bitmap, i, BITMAP_PAGE_NEEDWRITE);
-		md_bitmap_unplug(bitmap);
+		__bitmap_unplug(bitmap);
 	}
-	md_bitmap_unplug(mddev->bitmap);
+	__bitmap_unplug(mddev->bitmap);
 	*low = lo;
 	*high = hi;
 	md_bitmap_free(bitmap);
@@ -2348,7 +2360,7 @@ int md_bitmap_resize(struct bitmap *bitmap, sector_t blocks,
 	spin_unlock_irq(&bitmap->counts.lock);
 
 	if (!init) {
-		md_bitmap_unplug(bitmap);
+		__bitmap_unplug(bitmap);
 		bitmap->mddev->pers->quiesce(bitmap->mddev, 0);
 	}
 	ret = 0;
diff --git a/drivers/md/md-bitmap.h b/drivers/md/md-bitmap.h
index d933b603fce9..ae6ba558e48a 100644
--- a/drivers/md/md-bitmap.h
+++ b/drivers/md/md-bitmap.h
@@ -276,8 +276,7 @@ struct bitmap_operations {
 void mddev_set_bitmap_ops(struct mddev *mddev);
 
 /* these are exported */
-void md_bitmap_unplug(struct bitmap *bitmap);
-void md_bitmap_unplug_async(struct bitmap *bitmap);
+void md_bitmap_unplug(struct mddev *mddev, bool sync);
 void md_bitmap_daemon_work(struct mddev *mddev);
 
 int md_bitmap_resize(struct bitmap *bitmap, sector_t blocks,
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 1e1d3db56bb9..f15784b31b98 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -4701,7 +4701,7 @@ bitmap_store(struct mddev *mddev, const char *buf, size_t len)
 		mddev->bitmap_ops->dirty_bits(mddev, chunk, end_chunk);
 		buf = skip_spaces(end);
 	}
-	md_bitmap_unplug(mddev->bitmap); /* flush the bits to disk */
+	md_bitmap_unplug(mddev, true); /* flush the bits to disk */
 out:
 	mddev_unlock(mddev);
 	return len;
diff --git a/drivers/md/raid1-10.c b/drivers/md/raid1-10.c
index 2ea1710a3b70..45b30f08f3a5 100644
--- a/drivers/md/raid1-10.c
+++ b/drivers/md/raid1-10.c
@@ -166,12 +166,9 @@ static inline bool raid1_add_bio_to_plug(struct mddev *mddev, struct bio *bio,
  * while current io submission must wait for bitmap io to be done. In order to
  * avoid such deadlock, submit bitmap io asynchronously.
  */
-static inline void raid1_prepare_flush_writes(struct bitmap *bitmap)
+static inline void raid1_prepare_flush_writes(struct mddev *mddev)
 {
-	if (current->bio_list)
-		md_bitmap_unplug_async(bitmap);
-	else
-		md_bitmap_unplug(bitmap);
+	md_bitmap_unplug(mddev, current->bio_list == NULL);
 }
 
 /*
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 869226752a63..3dedb7fd74c4 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -896,7 +896,7 @@ static void wake_up_barrier(struct r1conf *conf)
 static void flush_bio_list(struct r1conf *conf, struct bio *bio)
 {
 	/* flush any pending bitmap writes to disk before proceeding w/ I/O */
-	raid1_prepare_flush_writes(conf->mddev->bitmap);
+	raid1_prepare_flush_writes(conf->mddev);
 	wake_up_barrier(conf);
 
 	while (bio) { /* submit pending writes */
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 45bcda686def..085a85945a42 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -885,7 +885,7 @@ static void flush_pending_writes(struct r10conf *conf)
 		__set_current_state(TASK_RUNNING);
 
 		blk_start_plug(&plug);
-		raid1_prepare_flush_writes(conf->mddev->bitmap);
+		raid1_prepare_flush_writes(conf->mddev);
 		wake_up(&conf->wait_barrier);
 
 		while (bio) { /* submit pending writes */
@@ -1101,7 +1101,7 @@ static void raid10_unplug(struct blk_plug_cb *cb, bool from_schedule)
 
 	/* we aren't scheduling, so we can do the write-out directly. */
 	bio = bio_list_get(&plug->pending);
-	raid1_prepare_flush_writes(mddev->bitmap);
+	raid1_prepare_flush_writes(mddev);
 	wake_up_barrier(conf);
 
 	while (bio) { /* submit pending writes */
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 87b8d19ab601..e98061c01b44 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -6768,7 +6768,7 @@ static void raid5d(struct md_thread *thread)
 			/* Now is a good time to flush some bitmap updates */
 			conf->seq_flush++;
 			spin_unlock_irq(&conf->device_lock);
-			md_bitmap_unplug(mddev->bitmap);
+			md_bitmap_unplug(mddev, true);
 			spin_lock_irq(&conf->device_lock);
 			conf->seq_write = conf->seq_flush;
 			activate_bit_delay(conf, conf->temp_inactive_list);
-- 
2.39.2

