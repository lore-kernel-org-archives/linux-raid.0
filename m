Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6C091EB9F3;
	Sat, 24 May 2025 06:18:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748067506; cv=none; b=UsLsnpAG5fiJvXzDy8TDe4+5KW1r1zr6M7dt7Ro/T9IUh3DhdUjnUn8o5bVkizRu65wvSBfui2Xt7htVHeCGRk6HusG/sJMXy4zv3ztuDOH/TgvnJiFPTEdDxNtLh24AcQH8yxDodDdYRH35tPzzx7I/s/0uIRX2rQzYRW9ZjBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748067506; c=relaxed/simple;
	bh=++g/sKcSP3o2HG7k1VLirDPrYJkkjBOAcO00ejz1BQY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=VffqRsE4r9N2ME58+YpRFMabJQqDCLzOnDPSEbVhhoIXqJ5Wo0kB9vEtG2VEkeTc+sldY9lns1ZE1HeTycwfY/LZgtyH72D1dpuEdgFe8pOJoeEQ3VTuhTa8ImzxfSUVLSYH97yAU9qlEZZlkgqnEKw0YcA4+bua5Qn16YPGrq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4b4Bfl3dRQzKHMbP;
	Sat, 24 May 2025 14:18:23 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 017E61A0359;
	Sat, 24 May 2025 14:18:22 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgCnCl+dZDFo3etkNQ--.42979S25;
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
Subject: [PATCH 21/23] md/md-llbitmap: implement all bitmap operations
Date: Sat, 24 May 2025 14:13:18 +0800
Message-Id: <20250524061320.370630-22-yukuai1@huaweicloud.com>
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
X-CM-TRANSID:gCh0CgCnCl+dZDFo3etkNQ--.42979S25
X-Coremail-Antispam: 1UD129KBjvJXoWxuF15JFyDJFykKrWrZF4fZrb_yoWrWF47pF
	47XFy5Gr45JF1xWw13Jr97ZF1rArs2q3sFqrZ3C34rWr1UArZxKF4rWFyUJw1DXryrJFs8
	Xw45KF45C3yrXFUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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

Include following left APIs
 - llbitmap_enabled
 - llbitmap_dirty_bits
 - llbitmap_update_sb
 - llbitmap_write_all
 - llbitmap_start_behind_write
 - llbitmap_end_behind_write
 - llbitmap_wait_behind_writes

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/md-llbitmap.c | 114 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 114 insertions(+)

diff --git a/drivers/md/md-llbitmap.c b/drivers/md/md-llbitmap.c
index 1b7625d3e2ed..ae664aa110a8 100644
--- a/drivers/md/md-llbitmap.c
+++ b/drivers/md/md-llbitmap.c
@@ -1277,4 +1277,118 @@ static void llbitmap_cond_end_sync(struct mddev *mddev, sector_t sector,
 	sysfs_notify_dirent_safe(mddev->sysfs_completed);
 }
 
+static bool llbitmap_enabled(void *data)
+{
+	struct llbitmap *llbitmap = data;
+
+	return llbitmap && !test_bit(BITMAP_WRITE_ERROR, &llbitmap->flags);
+}
+
+static void llbitmap_dirty_bits(struct mddev *mddev, unsigned long s,
+				unsigned long e)
+{
+	llbitmap_state_machine(mddev->bitmap, s, e, BitmapActionStartwrite);
+}
+
+static void llbitmap_write_sb(struct llbitmap *llbitmap)
+{
+	int nr_bits = DIV_ROUND_UP(BITMAP_SB_SIZE, llbitmap->io_size);
+
+	bitmap_fill(llbitmap->pctl[0]->dirty, nr_bits);
+	llbitmap_write_page(llbitmap, 0);
+	md_super_wait(llbitmap->mddev);
+}
+
+static void llbitmap_update_sb(void *data)
+{
+	struct llbitmap *llbitmap = data;
+	struct mddev *mddev = llbitmap->mddev;
+	struct page *sb_page;
+	bitmap_super_t *sb;
+
+	if (test_bit(BITMAP_WRITE_ERROR, &llbitmap->flags))
+		return;
+
+	sb_page = llbitmap_read_page(llbitmap, 0);
+	if (IS_ERR(sb_page)) {
+		pr_err("%s: %s: read super block failed", __func__,
+		       mdname(mddev));
+		set_bit(BITMAP_WRITE_ERROR, &llbitmap->flags);
+		return;
+	}
+
+	if (mddev->events < llbitmap->events_cleared)
+		llbitmap->events_cleared = mddev->events;
+
+	sb = kmap_local_page(sb_page);
+	sb->events = cpu_to_le64(mddev->events);
+	sb->state = cpu_to_le32(llbitmap->flags);
+	sb->chunksize = cpu_to_le32(llbitmap->chunksize);
+	sb->sync_size = cpu_to_le64(mddev->resync_max_sectors);
+	sb->events_cleared = cpu_to_le64(llbitmap->events_cleared);
+	sb->sectors_reserved = cpu_to_le32(mddev->bitmap_info.space);
+	sb->daemon_sleep = cpu_to_le32(mddev->bitmap_info.daemon_sleep);
+
+	kunmap_local(sb);
+	llbitmap_write_sb(llbitmap);
+}
+
+static int llbitmap_get_stats(void *data, struct md_bitmap_stats *stats)
+{
+	struct llbitmap *llbitmap = data;
+
+	memset(stats, 0, sizeof(*stats));
+
+	stats->missing_pages = 0;
+	stats->pages = llbitmap->nr_pages;
+	stats->file_pages = llbitmap->nr_pages;
+
+	stats->behind_writes = atomic_read(&llbitmap->behind_writes);
+	stats->behind_wait = wq_has_sleeper(&llbitmap->behind_wait);
+	stats->events_cleared = llbitmap->events_cleared;
+
+	return 0;
+}
+
+/* just flag all pages as needing to be written */
+static void llbitmap_write_all(struct mddev *mddev)
+{
+	int i;
+	struct llbitmap *llbitmap = mddev->bitmap;
+
+	for (i = 0; i < llbitmap->nr_pages; i++) {
+		struct llbitmap_page_ctl *pctl = llbitmap->pctl[i];
+
+		set_bit(LLPageDirty, &pctl->flags);
+		bitmap_fill(pctl->dirty, llbitmap->bits_per_page);
+	}
+}
+
+static void llbitmap_start_behind_write(struct mddev *mddev)
+{
+	struct llbitmap *llbitmap = mddev->bitmap;
+
+	atomic_inc(&llbitmap->behind_writes);
+}
+
+static void llbitmap_end_behind_write(struct mddev *mddev)
+{
+	struct llbitmap *llbitmap = mddev->bitmap;
+
+	if (atomic_dec_and_test(&llbitmap->behind_writes))
+		wake_up(&llbitmap->behind_wait);
+}
+
+static void llbitmap_wait_behind_writes(struct mddev *mddev)
+{
+	struct llbitmap *llbitmap = mddev->bitmap;
+
+	if (!llbitmap)
+		return;
+
+	wait_event(llbitmap->behind_wait,
+		   atomic_read(&llbitmap->behind_writes) == 0);
+
+}
+
 #endif /* CONFIG_MD_LLBITMAP */
-- 
2.39.2

