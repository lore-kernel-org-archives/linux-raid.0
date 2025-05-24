Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 612211EEA32;
	Sat, 24 May 2025 06:18:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748067506; cv=none; b=JfMF5jt67Gbwn8KPvhn1LeQvoV9fEL/brntYDbpwYmQKck6BdLr+sg3whrgSbDTwM5ODZY2EwedYZavWGCooyzDf62dx3VvPNjS8fEFl/IklMf1LHxmWTBaHJ96r5d/4IGNTp60gp4og4TCxu+5mkyLYjZ7vPRyu708c52EpGq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748067506; c=relaxed/simple;
	bh=WmXQMAfxyMLUfgvGpc1z8Xs740apUoNKute2R0RfwxU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=JFxrnfgO+Y9mBrG5ie3G7aG4093UQEj5YNZIhDpKXyIIq00tLbRjcNWbgTNi9MZi6JjiWStG/RJmRaQ8G8FKYG0xsHnjyByOJdS1C07p5EAyjxv1RkXCiKYtRCcnVB7lHgHLbQ4sqrhWPFODyCiD13BWP65S4Bpgy+l67d4RVvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4b4BfK3cbXz4f3jt0;
	Sat, 24 May 2025 14:18:01 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 795361A018D;
	Sat, 24 May 2025 14:18:21 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgCnCl+dZDFo3etkNQ--.42979S24;
	Sat, 24 May 2025 14:18:21 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: hch@lst.de,
	xni@redhat.com,
	colyli@kernel.org,
	song@kernel.org,
	yukuai3@huawei.com
Cc: linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-raid@vger.kernel.org,
	yukuai1@huaweicloud.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com,
	johnny.chenyi@huawei.com
Subject: [PATCH 20/23] md/md-llbitmap: implement APIs for sync_thread
Date: Sat, 24 May 2025 14:13:17 +0800
Message-Id: <20250524061320.370630-21-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250524061320.370630-1-yukuai1@huaweicloud.com>
References: <20250524061320.370630-1-yukuai1@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgCnCl+dZDFo3etkNQ--.42979S24
X-Coremail-Antispam: 1UD129KBjvJXoWxWFykXr1UXFWktry5XFWkZwb_yoWrWr1kpr
	47Xr15Gr45X3yfX3y3Jr9rAFyFqw4kJr9FqF93Aa4rGr1YkrsIgFyrGFyUX3WjgFyfG3WD
	X3Z8GrW5Cr18WFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUmS14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
	kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
	z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F
	4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq
	3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7
	IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4U
	M4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2
	kIc2xKxwCY1x0262kKe7AKxVWUtVW8ZwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkE
	bVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67
	AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVW5JVW7JwCI
	42IY6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF
	4lIxAIcVC2z280aVAFwI0_Gr0_Cr1lIxAIcVC2z280aVCY1x0267AKxVW8Jr0_Cr1UYxBI
	daVFxhVjvjDU0xZFpf9x0JUQFxUUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

Include following APIs:
 - llbitmap_blocks_synced
 - llbitmap_skip_sync_blocks
 - llbitmap_start_sync
 - llbitmap_end_sync
 - llbitmap_close_sync
 - llbitmap_cond_end_sync

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/md-llbitmap.c | 104 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 104 insertions(+)

diff --git a/drivers/md/md-llbitmap.c b/drivers/md/md-llbitmap.c
index 37e72885dbdb..1b7625d3e2ed 100644
--- a/drivers/md/md-llbitmap.c
+++ b/drivers/md/md-llbitmap.c
@@ -1173,4 +1173,108 @@ static void llbitmap_flush(struct mddev *mddev)
 	__llbitmap_flush(mddev);
 }
 
+/* This is used for raid5 lazy initial recovery */
+static bool llbitmap_blocks_synced(struct mddev *mddev, sector_t offset)
+{
+	struct llbitmap *llbitmap = mddev->bitmap;
+	unsigned long p = offset >> llbitmap->chunkshift;
+	enum llbitmap_state c = llbitmap_read(llbitmap, p);
+
+	return c == BitClean || c == BitDirty;
+}
+
+static sector_t llbitmap_skip_sync_blocks(struct mddev *mddev, sector_t offset)
+{
+	struct llbitmap *llbitmap = mddev->bitmap;
+	unsigned long p = offset >> llbitmap->chunkshift;
+	int blocks = llbitmap->chunksize - (offset & (llbitmap->chunksize - 1));
+	enum llbitmap_state c = llbitmap_read(llbitmap, p);
+
+	/* always skip unwritten blocks */
+	if (c == BitUnwritten)
+		return blocks;
+
+	/* For resync also skip clean/dirty blocks */
+	if ((c == BitClean || c == BitDirty) &&
+	    test_bit(MD_RECOVERY_SYNC, &mddev->recovery) &&
+	    !test_bit(MD_RECOVERY_REQUESTED, &mddev->recovery))
+		return blocks;
+
+	return 0;
+}
+
+static bool llbitmap_start_sync(struct mddev *mddev, sector_t offset,
+				sector_t *blocks, bool degraded)
+{
+	struct llbitmap *llbitmap = mddev->bitmap;
+	unsigned long p = offset >> llbitmap->chunkshift;
+
+	/*
+	 * Handle one bit at a time, this is much simpler. And it doesn't matter
+	 * if md_do_sync() loop more times.
+	 */
+	*blocks = llbitmap->chunksize - (offset & (llbitmap->chunksize - 1));
+	return llbitmap_state_machine(llbitmap, p, p,
+				      BitmapActionStartsync) == BitSyncing;
+}
+
+/* Something is wrong, sync_thread stop at @offset */
+static void llbitmap_end_sync(struct mddev *mddev, sector_t offset,
+			      sector_t *blocks)
+{
+	struct llbitmap *llbitmap = mddev->bitmap;
+	unsigned long p = offset >> llbitmap->chunkshift;
+
+	*blocks = llbitmap->chunksize - (offset & (llbitmap->chunksize - 1));
+	llbitmap_state_machine(llbitmap, p, llbitmap->chunks - 1,
+			       BitmapActionAbortsync);
+}
+
+/* A full sync_thread is finished */
+static void llbitmap_close_sync(struct mddev *mddev)
+{
+	struct llbitmap *llbitmap = mddev->bitmap;
+	int i;
+
+	for (i = 0; i < llbitmap->nr_pages; i++) {
+		struct llbitmap_page_ctl *pctl = llbitmap->pctl[i];
+
+		/* let daemon_fn clear dirty bits immediately */
+		WRITE_ONCE(pctl->expire, jiffies);
+	}
+
+	llbitmap_state_machine(llbitmap, 0, llbitmap->chunks - 1,
+			       BitmapActionEndsync);
+}
+
+/*
+ * sync_thread have reached @sector, update metadata every daemon_sleep seconds,
+ * just in case sync_thread have to restart after power failure.
+ */
+static void llbitmap_cond_end_sync(struct mddev *mddev, sector_t sector,
+				   bool force)
+{
+	struct llbitmap *llbitmap = mddev->bitmap;
+
+	if (sector == 0) {
+		llbitmap->last_end_sync = jiffies;
+		return;
+	}
+
+	if (time_before(jiffies, llbitmap->last_end_sync +
+				 HZ * mddev->bitmap_info.daemon_sleep))
+		return;
+
+	wait_event(mddev->recovery_wait, !atomic_read(&mddev->recovery_active));
+
+	mddev->curr_resync_completed = sector;
+	set_bit(MD_SB_CHANGE_CLEAN, &mddev->sb_flags);
+	llbitmap_state_machine(llbitmap, 0, sector >> llbitmap->chunkshift,
+			       BitmapActionEndsync);
+	__llbitmap_flush(mddev);
+
+	llbitmap->last_end_sync = jiffies;
+	sysfs_notify_dirent_safe(mddev->sysfs_completed);
+}
+
 #endif /* CONFIG_MD_LLBITMAP */
-- 
2.39.2

