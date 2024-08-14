Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFDE51494D9;
	Wed, 14 Aug 2024 07:15:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723619738; cv=none; b=IfCqhXT6WTAFNHGKj5XmFdLcW7uSymLd5NAgQCbGaVoMjPPiTG8Kkp0PXHRsE/go70b2GmpGkex+Aope0hjJV1OB1Lmxf48Ji5Bh+7RDjKhzShCGMvcjA1kICLuveXBzl65wxe1lJBwjHWi7nzbSJeiyHPnUDfjTHNNYT5+/Dso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723619738; c=relaxed/simple;
	bh=DEkKsXcjSB/TgOL3r7dLdl/Yjlrd4s1TuHq8au1PzFE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=lzfcXZ6IDhu2vGGV6fvHZIxM+YAiIrHnf1h4rK6NcBZDgI9vf/z2LQpu7FZ1Szj7In6pqvTR1O+oIzg7J3tX3h15upy+iSknLADauc69MkWWXtV+fGZpVtOUJurEGCmbB6xTkFX82VFCtvu4K8MN3vztFpE4bt1X3S729MnzivE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4WkKK21By0z4f3kv7;
	Wed, 14 Aug 2024 15:15:18 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id DAFBF1A15CE;
	Wed, 14 Aug 2024 15:15:32 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgBHboSLWbxmIxKbBg--.47745S21;
	Wed, 14 Aug 2024 15:15:32 +0800 (CST)
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
Subject: [PATCH RFC -next v2 17/41] md/md-bitmap: merge md_bitmap_update_sb() into bitmap_operations
Date: Wed, 14 Aug 2024 15:10:49 +0800
Message-Id: <20240814071113.346781-18-yukuai1@huaweicloud.com>
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
X-CM-TRANSID:gCh0CgBHboSLWbxmIxKbBg--.47745S21
X-Coremail-Antispam: 1UD129KBjvJXoWxXFykKFW8Kr4rWr4rJF1fJFb_yoW7Gr4UpF
	WUt3W5Gr45JFW5Xr1UJFyv9Fy5Zw4ktrZrKFWxCayruF9IqFn3GF48GF4Dtwn8Gry3JFsx
	Zw45Jr4UWF4xXF7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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
 drivers/md/md-bitmap.c  | 15 ++++++++-------
 drivers/md/md-bitmap.h  |  3 ++-
 drivers/md/md-cluster.c |  2 +-
 drivers/md/md.c         |  4 ++--
 4 files changed, 13 insertions(+), 11 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index 9d4bbcebb7b7..9692acb8cb04 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -472,7 +472,7 @@ static void md_bitmap_wait_writes(struct bitmap *bitmap)
 
 
 /* update the event counter and sync the superblock to disk */
-void md_bitmap_update_sb(struct bitmap *bitmap)
+static void bitmap_update_sb(struct bitmap *bitmap)
 {
 	bitmap_super_t *sb;
 
@@ -510,7 +510,6 @@ void md_bitmap_update_sb(struct bitmap *bitmap)
 		write_sb_page(bitmap, bitmap->storage.sb_index,
 			      bitmap->storage.sb_page, 1);
 }
-EXPORT_SYMBOL(md_bitmap_update_sb);
 
 static void bitmap_print_sb(struct bitmap *bitmap)
 {
@@ -892,7 +891,7 @@ static void md_bitmap_file_unmap(struct bitmap_storage *store)
 static void md_bitmap_file_kick(struct bitmap *bitmap)
 {
 	if (!test_and_set_bit(BITMAP_STALE, &bitmap->flags)) {
-		md_bitmap_update_sb(bitmap);
+		bitmap_update_sb(bitmap);
 
 		if (bitmap->storage.file) {
 			pr_warn("%s: kicking failed bitmap file %pD4 from array!\n",
@@ -1792,7 +1791,7 @@ static void bitmap_flush(struct mddev *mddev)
 	md_bitmap_daemon_work(mddev);
 	if (mddev->bitmap_info.external)
 		md_super_wait(mddev);
-	md_bitmap_update_sb(bitmap);
+	bitmap_update_sb(bitmap);
 }
 
 /*
@@ -2022,7 +2021,7 @@ static int bitmap_load(struct mddev *mddev)
 	mddev_set_timeout(mddev, mddev->bitmap_info.daemon_sleep, true);
 	md_wakeup_thread(mddev->thread);
 
-	md_bitmap_update_sb(bitmap);
+	bitmap_update_sb(bitmap);
 
 	if (test_bit(BITMAP_WRITE_ERROR, &bitmap->flags))
 		err = -EIO;
@@ -2083,7 +2082,7 @@ int md_bitmap_copy_from_slot(struct mddev *mddev, int slot,
 	}
 
 	if (clear_bits) {
-		md_bitmap_update_sb(bitmap);
+		bitmap_update_sb(bitmap);
 		/* BITMAP_PAGE_PENDING is set, but bitmap_unplug needs
 		 * BITMAP_PAGE_DIRTY or _NEEDWRITE to write ... */
 		for (i = 0; i < bitmap->storage.file_pages; i++)
@@ -2575,7 +2574,7 @@ backlog_store(struct mddev *mddev, const char *buf, size_t len)
 			mddev_create_serial_pool(mddev, rdev);
 	}
 	if (old_mwb != backlog)
-		md_bitmap_update_sb(mddev->bitmap);
+		bitmap_update_sb(mddev->bitmap);
 
 	mddev_unlock_and_resume(mddev);
 	return len;
@@ -2719,6 +2718,8 @@ static struct bitmap_operations bitmap_ops = {
 	.load			= bitmap_load,
 	.destroy		= bitmap_destroy,
 	.flush			= bitmap_flush,
+
+	.update_sb		= bitmap_update_sb,
 };
 
 void mddev_set_bitmap_ops(struct mddev *mddev)
diff --git a/drivers/md/md-bitmap.h b/drivers/md/md-bitmap.h
index 76bc90dccacc..b2d4e71a478a 100644
--- a/drivers/md/md-bitmap.h
+++ b/drivers/md/md-bitmap.h
@@ -250,6 +250,8 @@ struct bitmap_operations {
 	int (*load)(struct mddev *mddev);
 	void (*destroy)(struct mddev *mddev);
 	void (*flush)(struct mddev *mddev);
+
+	void (*update_sb)(struct bitmap *bitmap);
 };
 
 /* the bitmap API */
@@ -257,7 +259,6 @@ void mddev_set_bitmap_ops(struct mddev *mddev);
 
 /* these are used only by md/bitmap */
 
-void md_bitmap_update_sb(struct bitmap *bitmap);
 int md_bitmap_get_stats(struct bitmap *bitmap, struct md_bitmap_stats *stats);
 
 int  md_bitmap_setallbits(struct bitmap *bitmap);
diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
index 1938eadb379b..77111968e276 100644
--- a/drivers/md/md-cluster.c
+++ b/drivers/md/md-cluster.c
@@ -1253,7 +1253,7 @@ static int cluster_check_sync_size(struct mddev *mddev)
 		bm_lockres->flags |= DLM_LKF_NOQUEUE;
 		rv = dlm_lock_sync(bm_lockres, DLM_LOCK_PW);
 		if (!rv)
-			md_bitmap_update_sb(bitmap);
+			mddev->bitmap_ops->update_sb(bitmap);
 		lockres_free(bm_lockres);
 
 		rv = md_bitmap_get_stats(bitmap, &stats);
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 69d4b21c441e..ecfe957279e5 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -2825,7 +2825,7 @@ void md_update_sb(struct mddev *mddev, int force_change)
 
 	mddev_add_trace_msg(mddev, "md md_update_sb");
 rewrite:
-	md_bitmap_update_sb(mddev->bitmap);
+	mddev->bitmap_ops->update_sb(mddev->bitmap);
 	rdev_for_each(rdev, mddev) {
 		if (rdev->sb_loaded != 1)
 			continue; /* no noise on spare devices */
@@ -9986,7 +9986,7 @@ static void check_sb_changes(struct mddev *mddev, struct md_rdev *rdev)
 		if (ret)
 			pr_info("md-cluster: resize failed\n");
 		else
-			md_bitmap_update_sb(mddev->bitmap);
+			mddev->bitmap_ops->update_sb(mddev->bitmap);
 	}
 
 	/* Check for change of roles in the active devices */
-- 
2.39.2

