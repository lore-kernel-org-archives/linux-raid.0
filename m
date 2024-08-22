Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E4044D8DA;
	Thu, 22 Aug 2024 02:52:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724295133; cv=none; b=g8OQhkIjwDlgaJEC7RTphUi3h9VvIsHEL+hOuIe1ejVPTLGdfCbL7EiqNXCLsf0TTDavPY8K6qM0Ecaxc7RpgxDUje3TY/Au51OXgt7iGatmsiCjjgBgZDbNkmIjfg5SSe0ei6/lyEc1rLjXr7SkY9CeyBUqY5QaWyfnXJUbcx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724295133; c=relaxed/simple;
	bh=Ad7Jr3N76oy0/TNh7d1NV151D0i4/9FCI/Wmmw8zTOE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=jklGCwq5uaGzPPb6FvAwt0fBEYk5CH+6twrxqZj+6MwcaFJcQMh041MAM+S1kTZAogBBzX2Y8d1o5eauSDedjxKUFfyEwAoMn9JPYtpkLxPwecCAboatHelbXm51s68jKBqjOzS6XwegAcRHt56IcI7txD6VXZ7GFVsqCAxa8WI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4Wq75P3XD1z4f3jsG;
	Thu, 22 Aug 2024 10:51:53 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id AFF6B1A06DA;
	Thu, 22 Aug 2024 10:52:07 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgAXPoTNp8ZmyXl2CQ--.42363S21;
	Thu, 22 Aug 2024 10:52:07 +0800 (CST)
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
Subject: [PATCH md-6.12 17/41] md/md-bitmap: merge md_bitmap_update_sb() into bitmap_operations
Date: Thu, 22 Aug 2024 10:46:54 +0800
Message-Id: <20240822024718.2158259-18-yukuai1@huaweicloud.com>
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
X-CM-TRANSID:gCh0CgAXPoTNp8ZmyXl2CQ--.42363S21
X-Coremail-Antispam: 1UD129KBjvJXoWxXFykKFW8Kr4rWr4rJF1fJFb_yoW7Gr45pF
	WUt3W5Cr45JFWrXr1UJFyvkFy5Zw4ktrZrKFWxCa1ruF9IqFn3GF48GFWDtw15Gry3JFsx
	Zw45tr4UWF4xXF7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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
 drivers/md/md-bitmap.c  | 15 ++++++++-------
 drivers/md/md-bitmap.h  |  3 ++-
 drivers/md/md-cluster.c |  2 +-
 drivers/md/md.c         |  4 ++--
 4 files changed, 13 insertions(+), 11 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index 20f5fdd7396f..8008a5ab7b6a 100644
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
@@ -2578,7 +2577,7 @@ backlog_store(struct mddev *mddev, const char *buf, size_t len)
 			mddev_create_serial_pool(mddev, rdev);
 	}
 	if (old_mwb != backlog)
-		md_bitmap_update_sb(mddev->bitmap);
+		bitmap_update_sb(mddev->bitmap);
 
 	mddev_unlock_and_resume(mddev);
 	return len;
@@ -2722,6 +2721,8 @@ static struct bitmap_operations bitmap_ops = {
 	.load			= bitmap_load,
 	.destroy		= bitmap_destroy,
 	.flush			= bitmap_flush,
+
+	.update_sb		= bitmap_update_sb,
 };
 
 void mddev_set_bitmap_ops(struct mddev *mddev)
diff --git a/drivers/md/md-bitmap.h b/drivers/md/md-bitmap.h
index 5d5811c89b77..ca0d8696136f 100644
--- a/drivers/md/md-bitmap.h
+++ b/drivers/md/md-bitmap.h
@@ -251,6 +251,8 @@ struct bitmap_operations {
 	int (*load)(struct mddev *mddev);
 	void (*destroy)(struct mddev *mddev);
 	void (*flush)(struct mddev *mddev);
+
+	void (*update_sb)(struct bitmap *bitmap);
 };
 
 /* the bitmap API */
@@ -258,7 +260,6 @@ void mddev_set_bitmap_ops(struct mddev *mddev);
 
 /* these are used only by md/bitmap */
 
-void md_bitmap_update_sb(struct bitmap *bitmap);
 int md_bitmap_get_stats(struct bitmap *bitmap, struct md_bitmap_stats *stats);
 
 int  md_bitmap_setallbits(struct bitmap *bitmap);
diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
index 59f7fbca783b..ca30881556bd 100644
--- a/drivers/md/md-cluster.c
+++ b/drivers/md/md-cluster.c
@@ -1255,7 +1255,7 @@ static int cluster_check_sync_size(struct mddev *mddev)
 		bm_lockres->flags |= DLM_LKF_NOQUEUE;
 		rv = dlm_lock_sync(bm_lockres, DLM_LOCK_PW);
 		if (!rv)
-			md_bitmap_update_sb(bitmap);
+			mddev->bitmap_ops->update_sb(bitmap);
 		lockres_free(bm_lockres);
 
 		rv = md_bitmap_get_stats(bitmap, &stats);
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 46ffba143990..ce92fe943f61 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -2838,7 +2838,7 @@ void md_update_sb(struct mddev *mddev, int force_change)
 
 	mddev_add_trace_msg(mddev, "md md_update_sb");
 rewrite:
-	md_bitmap_update_sb(mddev->bitmap);
+	mddev->bitmap_ops->update_sb(mddev->bitmap);
 	rdev_for_each(rdev, mddev) {
 		if (rdev->sb_loaded != 1)
 			continue; /* no noise on spare devices */
@@ -10003,7 +10003,7 @@ static void check_sb_changes(struct mddev *mddev, struct md_rdev *rdev)
 		if (ret)
 			pr_info("md-cluster: resize failed\n");
 		else
-			md_bitmap_update_sb(mddev->bitmap);
+			mddev->bitmap_ops->update_sb(mddev->bitmap);
 	}
 
 	/* Check for change of roles in the active devices */
-- 
2.39.2

