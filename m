Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20F4A1459FC;
	Sat, 10 Aug 2024 02:13:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723255986; cv=none; b=IKHoliUvkllVx8dctAlx4/FatPz668Ug7vxBGPGaKEOJE9V59mb66BEhBWl6ZpSYkiRISQezAdFt+/iTNpMra3X4W5R5Nj7f5JxCKU/1DTfEtBSl9e0rL/NQNEJFeXAwEo7DPj1KKp5sQjNaa1y0LDt42ogULbozs7loRu5MzYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723255986; c=relaxed/simple;
	bh=C22l+sN+EahvZitAw6Nos0NBz1atzmQNuIhYxDl+K3U=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=PYRcKDU4OhPYZjGa3EzZZYxLgxxCmev5YH25xImhZ9p4+L4RvlWjAQzEUeBEYUYHwPeDQcJMfBE1HxmPR/Rfr/8gBl3ClXnhh99nAhS67CwrwwjBL/2L/If16GFSRDiEZKPqH9CoI9/ai/LHMjEPz6bEci4leY2vK28HJAqgwT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4Wgknw1cM8z4f3jk0;
	Sat, 10 Aug 2024 10:12:52 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 5A32B1A15A6;
	Sat, 10 Aug 2024 10:13:01 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgAHL4WizLZmErwLBQ--.1937S30;
	Sat, 10 Aug 2024 10:13:01 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: song@kernel.org
Cc: linux-kernel@vger.kernel.org,
	linux-raid@vger.kernel.org,
	yukuai3@huawei.com,
	yukuai1@huaweicloud.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com
Subject: [PATCH RFC -next 26/26] md/md-bitmap: merge bitmap_unplug() into bitmap_operations
Date: Sat, 10 Aug 2024 10:08:54 +0800
Message-Id: <20240810020854.797814-27-yukuai1@huaweicloud.com>
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
X-CM-TRANSID:gCh0CgAHL4WizLZmErwLBQ--.1937S30
X-Coremail-Antispam: 1UD129KBjvJXoW3Gr18tr1rur1fGryxWFyUZFb_yoW3Jw4Up3
	yUta45CF45JFW3Xw1DArZruF1Fq3WktF9rtryfCwn5uF17Xr9xGF4rGFyUtw1DAr13JFs8
	Aw45trykGF1UXF7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/md-bitmap.c | 16 ++++++++--------
 drivers/md/md-bitmap.h | 11 +++++++++--
 drivers/md/md.c        |  2 +-
 drivers/md/raid1-10.c  |  4 ++--
 drivers/md/raid1.c     |  2 +-
 drivers/md/raid10.c    |  4 ++--
 drivers/md/raid5.c     |  2 +-
 7 files changed, 24 insertions(+), 17 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index b08476746350..449556124d0e 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -1030,7 +1030,7 @@ static int md_bitmap_file_test_bit(struct bitmap *bitmap, sector_t block)
 /* this gets called when the md device is ready to unplug its underlying
  * (slave) device queues -- before we let any writes go down, we need to
  * sync the dirty pages of the bitmap file to disk */
-static void bitmap_unplug(struct bitmap *bitmap)
+static void __bitmap_unplug(struct bitmap *bitmap)
 {
 	unsigned long i;
 	int dirty, need_write;
@@ -1074,7 +1074,7 @@ static void md_bitmap_unplug_fn(struct work_struct *work)
 	struct bitmap_unplug_work *unplug_work =
 		container_of(work, struct bitmap_unplug_work, work);
 
-	bitmap_unplug(unplug_work->bitmap);
+	__bitmap_unplug(unplug_work->bitmap);
 	complete(unplug_work->done);
 }
 
@@ -1091,14 +1091,13 @@ static void bitmap_unplug_async(struct bitmap *bitmap)
 	wait_for_completion(&done);
 }
 
-void md_bitmap_unplug(struct bitmap *bitmap, bool sync)
+static void bitmap_unplug(struct bitmap *bitmap, bool sync)
 {
 	if (sync)
-		bitmap_unplug(bitmap);
+		__bitmap_unplug(bitmap);
 	else
 		bitmap_unplug_async(bitmap);
 }
-EXPORT_SYMBOL(md_bitmap_unplug);
 
 static void md_bitmap_set_memory_bits(struct bitmap *bitmap, sector_t offset, int needed);
 
@@ -2067,9 +2066,9 @@ static int bitmap_copy_from_slot(struct mddev *mddev, int slot, sector_t *low,
 		for (i = 0; i < bitmap->storage.file_pages; i++)
 			if (test_page_attr(bitmap, i, BITMAP_PAGE_PENDING))
 				set_page_attr(bitmap, i, BITMAP_PAGE_NEEDWRITE);
-		bitmap_unplug(bitmap);
+		__bitmap_unplug(bitmap);
 	}
-	bitmap_unplug(mddev->bitmap);
+	__bitmap_unplug(mddev->bitmap);
 	*low = lo;
 	*high = hi;
 	__bitmap_free(bitmap);
@@ -2303,7 +2302,7 @@ static int bitmap_resize(struct bitmap *bitmap, sector_t blocks,
 	spin_unlock_irq(&bitmap->counts.lock);
 
 	if (!init) {
-		bitmap_unplug(bitmap);
+		__bitmap_unplug(bitmap);
 		bitmap->mddev->pers->quiesce(bitmap->mddev, 0);
 	}
 	ret = 0;
@@ -2706,6 +2705,7 @@ static struct bitmap_operations bitmap_ops = {
 	.close_sync		= bitmap_close_sync,
 	.cond_end_sync		= bitmap_cond_end_sync,
 	.wait_behind_writes	= bitmap_wait_behind_writes,
+	.unplug			= bitmap_unplug,
 
 	.update_sb		= bitmap_update_sb,
 	.resize			= bitmap_resize,
diff --git a/drivers/md/md-bitmap.h b/drivers/md/md-bitmap.h
index 054e85c4a704..9e9e328d675c 100644
--- a/drivers/md/md-bitmap.h
+++ b/drivers/md/md-bitmap.h
@@ -255,6 +255,7 @@ struct bitmap_operations {
 	void (*cond_end_sync)(struct bitmap *bitmap, sector_t sector, bool force);
 	void (*wait_behind_writes)(struct bitmap *bitmap);
 	void (*daemon_work)(struct bitmap *bitmap);
+	void (*unplug)(struct bitmap *bitmap, bool sync);
 
 	void (*update_sb)(struct bitmap *bitmap);
 	int (*resize)(struct bitmap *bitmap, sector_t blocks, int chunksize,
@@ -413,6 +414,14 @@ static inline void md_bitmap_daemon_work(struct mddev *mddev)
 	mddev->bitmap_ops->daemon_work(mddev->bitmap);
 }
 
+static inline void md_bitmap_unplug(struct mddev *mddev, bool sync)
+{
+	if (!mddev->bitmap && !mddev->bitmap_ops->unplug)
+		return;
+
+	mddev->bitmap_ops->unplug(mddev->bitmap, sync);
+}
+
 static inline int md_bitmap_resize(struct mddev *mddev, sector_t blocks,
 				   int chunksize, int init)
 {
@@ -460,8 +469,6 @@ static inline void md_bitmap_free(struct mddev *mddev, struct bitmap *bitmap)
 	return mddev->bitmap_ops->free(bitmap);
 }
 
-void md_bitmap_unplug(struct bitmap *bitmap, bool sync);
-
 static inline bool md_bitmap_enabled(struct bitmap *bitmap)
 {
 	return bitmap && bitmap->storage.filemap &&
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 2e6270c47317..8610b6fec263 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -4691,7 +4691,7 @@ bitmap_store(struct mddev *mddev, const char *buf, size_t len)
 		md_bitmap_dirty_bits(mddev, chunk, end_chunk);
 		buf = skip_spaces(end);
 	}
-	md_bitmap_unplug(mddev->bitmap, true); /* flush the bits to disk */
+	md_bitmap_unplug(mddev, true); /* flush the bits to disk */
 out:
 	mddev_unlock(mddev);
 	return len;
diff --git a/drivers/md/raid1-10.c b/drivers/md/raid1-10.c
index e8410d0cc96f..45b30f08f3a5 100644
--- a/drivers/md/raid1-10.c
+++ b/drivers/md/raid1-10.c
@@ -166,9 +166,9 @@ static inline bool raid1_add_bio_to_plug(struct mddev *mddev, struct bio *bio,
  * while current io submission must wait for bitmap io to be done. In order to
  * avoid such deadlock, submit bitmap io asynchronously.
  */
-static inline void raid1_prepare_flush_writes(struct bitmap *bitmap)
+static inline void raid1_prepare_flush_writes(struct mddev *mddev)
 {
-	md_bitmap_unplug(bitmap, current->bio_list == NULL);
+	md_bitmap_unplug(mddev, current->bio_list == NULL);
 }
 
 /*
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index fef69fce586c..4e8dd032a453 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -893,7 +893,7 @@ static void wake_up_barrier(struct r1conf *conf)
 static void flush_bio_list(struct r1conf *conf, struct bio *bio)
 {
 	/* flush any pending bitmap writes to disk before proceeding w/ I/O */
-	raid1_prepare_flush_writes(conf->mddev->bitmap);
+	raid1_prepare_flush_writes(conf->mddev);
 	wake_up_barrier(conf);
 
 	while (bio) { /* submit pending writes */
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index a8a14cda8446..13f61e07d513 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -883,7 +883,7 @@ static void flush_pending_writes(struct r10conf *conf)
 		__set_current_state(TASK_RUNNING);
 
 		blk_start_plug(&plug);
-		raid1_prepare_flush_writes(conf->mddev->bitmap);
+		raid1_prepare_flush_writes(conf->mddev);
 		wake_up(&conf->wait_barrier);
 
 		while (bio) { /* submit pending writes */
@@ -1099,7 +1099,7 @@ static void raid10_unplug(struct blk_plug_cb *cb, bool from_schedule)
 
 	/* we aren't scheduling, so we can do the write-out directly. */
 	bio = bio_list_get(&plug->pending);
-	raid1_prepare_flush_writes(mddev->bitmap);
+	raid1_prepare_flush_writes(mddev);
 	wake_up_barrier(conf);
 
 	while (bio) { /* submit pending writes */
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 99332649bac3..0bb3608dd3c8 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -6766,7 +6766,7 @@ static void raid5d(struct md_thread *thread)
 			/* Now is a good time to flush some bitmap updates */
 			conf->seq_flush++;
 			spin_unlock_irq(&conf->device_lock);
-			md_bitmap_unplug(mddev->bitmap, true);
+			md_bitmap_unplug(mddev, true);
 			spin_lock_irq(&conf->device_lock);
 			conf->seq_write = conf->seq_flush;
 			activate_bit_delay(conf, conf->temp_inactive_list);
-- 
2.39.2

