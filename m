Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C0071EA7EB;
	Sat, 24 May 2025 06:18:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748067505; cv=none; b=Vyl+y84GndQzRTQo+yOUhwNx1Dulld4kKgxMHI+Fhn++U7DZRovzDvSV7HhpwK1P//Snd+wOPBk8oNmwcuTcjjHmct/3UDR4tIuGbYBtbI1G6qeNYetu2UNOTiDz8dBKNIrOBzaOY7nhF7LNTYcGC0V6ZyleXemftuwHaRcBx84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748067505; c=relaxed/simple;
	bh=cKJAmRXbpsq58VM81DIM0wxGxYesDuU7nGfV+QmPaVM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=JLMx8KA+HgZJKUiXgDk2CfI7h5VAAWavsseWvQRTyZ/5e7hu92A/hQ/zPZog6nICsb/XDc9aPj0e8edVVriaXss/z470t5tLhhHGCRzZSe3xkRZDYbmAqARPcEALkC+uRk7oVN+o9CEYIgNHQviiH+rTgyrdDBydpk19UWAMXac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4b4Bf95zNyz4f3jMN;
	Sat, 24 May 2025 14:17:53 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 7A6541A0BBE;
	Sat, 24 May 2025 14:18:20 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgCnCl+dZDFo3etkNQ--.42979S22;
	Sat, 24 May 2025 14:18:20 +0800 (CST)
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
Subject: [PATCH 18/23] md/md-llbitmap: implement APIs to mange bitmap lifetime
Date: Sat, 24 May 2025 14:13:15 +0800
Message-Id: <20250524061320.370630-19-yukuai1@huaweicloud.com>
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
X-CM-TRANSID:gCh0CgCnCl+dZDFo3etkNQ--.42979S22
X-Coremail-Antispam: 1UD129KBjvJXoWxtr17uF4kCF18AFy8GFW3Wrg_yoWfuFW5pF
	4Sq345KrWrJr1rXr47Xr97ZFWFqr4kt3sFqF97AFyrCr1UArsxKryrGFyUJw1kXw1rGFs8
	Ja15KF45CF1UWFDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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
	AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVW8JVW5JwCI
	42IY6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF
	4lIxAIcVC2z280aVAFwI0_Gr0_Cr1lIxAIcVC2z280aVCY1x0267AKxVW8Jr0_Cr1UYxBI
	daVFxhVjvjDU0xZFpf9x0JUQFxUUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

Include following APIs:
 - llbitmap_create
 - llbitmap_resize
 - llbitmap_load
 - llbitmap_destroy

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/md-llbitmap.c | 322 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 322 insertions(+)

diff --git a/drivers/md/md-llbitmap.c b/drivers/md/md-llbitmap.c
index 4d5f9a139a25..23283c4f7263 100644
--- a/drivers/md/md-llbitmap.c
+++ b/drivers/md/md-llbitmap.c
@@ -689,4 +689,326 @@ static void llbitmap_resume(struct llbitmap *llbitmap, int page_idx)
 	wake_up(&pctl->wait);
 }
 
+static int llbitmap_check_support(struct mddev *mddev)
+{
+	if (test_bit(MD_HAS_JOURNAL, &mddev->flags)) {
+		pr_notice("md/llbitmap: %s: array with journal cannot have bitmap\n",
+			  mdname(mddev));
+		return -EBUSY;
+	}
+
+	if (mddev->bitmap_info.space == 0) {
+		if (mddev->bitmap_info.default_space == 0) {
+			pr_notice("md/llbitmap: %s: no space for bitmap\n",
+				  mdname(mddev));
+			return -ENOSPC;
+		}
+	}
+
+	if (!mddev->persistent) {
+		pr_notice("md/llbitmap: %s: array must be persistent\n",
+			  mdname(mddev));
+		return -EOPNOTSUPP;
+	}
+
+	if (mddev->bitmap_info.file) {
+		pr_notice("md/llbitmap: %s: doesn't support bitmap file\n",
+			  mdname(mddev));
+		return -EOPNOTSUPP;
+	}
+
+	if (mddev->bitmap_info.external) {
+		pr_notice("md/llbitmap: %s: doesn't support external metadata\n",
+			  mdname(mddev));
+		return -EOPNOTSUPP;
+	}
+
+	if (mddev_is_dm(mddev)) {
+		pr_notice("md/llbitmap: %s: doesn't support dm-raid\n",
+			  mdname(mddev));
+		return -EOPNOTSUPP;
+	}
+
+	return 0;
+}
+
+static int llbitmap_init(struct llbitmap *llbitmap)
+{
+	struct mddev *mddev = llbitmap->mddev;
+	sector_t blocks = mddev->resync_max_sectors;
+	unsigned long chunksize = MIN_CHUNK_SIZE;
+	unsigned long chunks = DIV_ROUND_UP(blocks, chunksize);
+	unsigned long space = mddev->bitmap_info.space << SECTOR_SHIFT;
+	int ret;
+
+	while (chunks > space) {
+		chunksize = chunksize << 1;
+		chunks = DIV_ROUND_UP(blocks, chunksize);
+	}
+
+	llbitmap->chunkshift = ffz(~chunksize);
+	llbitmap->chunksize = chunksize;
+	llbitmap->chunks = chunks;
+	mddev->bitmap_info.daemon_sleep = DEFAULT_DAEMON_SLEEP;
+
+	ret = llbitmap_cache_pages(llbitmap);
+	if (ret)
+		return ret;
+
+	llbitmap_state_machine(llbitmap, 0, llbitmap->chunks - 1, BitmapActionInit);
+	return 0;
+}
+
+static int llbitmap_read_sb(struct llbitmap *llbitmap)
+{
+	struct mddev *mddev = llbitmap->mddev;
+	unsigned long daemon_sleep;
+	unsigned long chunksize;
+	unsigned long events;
+	struct page *sb_page;
+	bitmap_super_t *sb;
+	int ret = -EINVAL;
+
+	if (!mddev->bitmap_info.offset) {
+		pr_err("md/llbitmap: %s: no super block found", mdname(mddev));
+		return -EINVAL;
+	}
+
+	sb_page = llbitmap_read_page(llbitmap, 0);
+	if (IS_ERR(sb_page)) {
+		pr_err("md/llbitmap: %s: read super block failed",
+		       mdname(mddev));
+		ret = -EIO;
+		goto out;
+	}
+
+	sb = kmap_local_page(sb_page);
+	if (sb->magic != cpu_to_le32(BITMAP_MAGIC)) {
+		pr_err("md/llbitmap: %s: invalid super block magic number",
+		       mdname(mddev));
+		goto out_put_page;
+	}
+
+	if (sb->version != cpu_to_le32(BITMAP_MAJOR_LOCKLESS)) {
+		pr_err("md/llbitmap: %s: invalid super block version",
+		       mdname(mddev));
+		goto out_put_page;
+	}
+
+	if (memcmp(sb->uuid, mddev->uuid, 16)) {
+		pr_err("md/llbitmap: %s: bitmap superblock UUID mismatch\n",
+		       mdname(mddev));
+		goto out_put_page;
+	}
+
+	if (mddev->bitmap_info.space == 0) {
+		int room = le32_to_cpu(sb->sectors_reserved);
+
+		if (room)
+			mddev->bitmap_info.space = room;
+		else
+			mddev->bitmap_info.space = mddev->bitmap_info.default_space;
+	}
+	llbitmap->flags = le32_to_cpu(sb->state);
+	if (test_and_clear_bit(BITMAP_FIRST_USE, &llbitmap->flags)) {
+		ret = llbitmap_init(llbitmap);
+		goto out_put_page;
+	}
+
+	chunksize = le32_to_cpu(sb->chunksize);
+	if (!is_power_of_2(chunksize)) {
+		pr_err("md/llbitmap: %s: chunksize not a power of 2",
+		       mdname(mddev));
+		goto out_put_page;
+	}
+
+	if (chunksize < DIV_ROUND_UP(mddev->resync_max_sectors,
+				     mddev->bitmap_info.space << SECTOR_SHIFT)) {
+		pr_err("md/llbitmap: %s: chunksize too small %lu < %llu / %lu",
+		       mdname(mddev), chunksize, mddev->resync_max_sectors,
+		       mddev->bitmap_info.space);
+		goto out_put_page;
+	}
+
+	daemon_sleep = le32_to_cpu(sb->daemon_sleep);
+	if (daemon_sleep < 1 || daemon_sleep > MAX_SCHEDULE_TIMEOUT / HZ) {
+		pr_err("md/llbitmap: %s: daemon sleep %lu period out of range",
+		       mdname(mddev), daemon_sleep);
+		goto out_put_page;
+	}
+
+	events = le64_to_cpu(sb->events);
+	if (events < mddev->events) {
+		pr_warn("md/llbitmap :%s: bitmap file is out of date (%lu < %llu) -- forcing full recovery",
+			mdname(mddev), events, mddev->events);
+		set_bit(BITMAP_STALE, &llbitmap->flags);
+	}
+
+	sb->sync_size = cpu_to_le64(mddev->resync_max_sectors);
+	mddev->bitmap_info.chunksize = chunksize;
+	mddev->bitmap_info.daemon_sleep = daemon_sleep;
+
+	llbitmap->chunksize = chunksize;
+	llbitmap->chunks = DIV_ROUND_UP(mddev->resync_max_sectors, chunksize);
+	llbitmap->chunkshift = ffz(~chunksize);
+	ret = llbitmap_cache_pages(llbitmap);
+
+out_put_page:
+	__free_page(sb_page);
+out:
+	kunmap_local(sb);
+	return ret;
+}
+
+static void llbitmap_pending_timer_fn(struct timer_list *t)
+{
+	struct llbitmap *llbitmap = from_timer(llbitmap, t, pending_timer);
+
+	if (work_busy(&llbitmap->daemon_work)) {
+		pr_warn("daemon_work not finished\n");
+		set_bit(BITMAP_DAEMON_BUSY, &llbitmap->flags);
+		return;
+	}
+
+	queue_work(md_llbitmap_io_wq, &llbitmap->daemon_work);
+}
+
+static void md_llbitmap_daemon_fn(struct work_struct *work)
+{
+	struct llbitmap *llbitmap =
+		container_of(work, struct llbitmap, daemon_work);
+	unsigned long start;
+	unsigned long end;
+	bool restart;
+	int idx;
+
+	if (llbitmap->mddev->degraded)
+		return;
+
+retry:
+	start = 0;
+	end = min(llbitmap->chunks, PAGE_SIZE - BITMAP_SB_SIZE) - 1;
+	restart = false;
+
+	for (idx = 0; idx < llbitmap->nr_pages; idx++) {
+		struct llbitmap_page_ctl *pctl = llbitmap->pctl[idx];
+
+		if (idx > 0) {
+			start = end + 1;
+			end = min(end + PAGE_SIZE, llbitmap->chunks - 1);
+		}
+
+		if (!test_bit(LLPageFlush, &pctl->flags) &&
+		    time_before(jiffies, pctl->expire)) {
+			restart = true;
+			continue;
+		}
+
+		llbitmap_suspend(llbitmap, idx);
+		llbitmap_state_machine(llbitmap, start, end, BitmapActionDaemon);
+		llbitmap_resume(llbitmap, idx);
+	}
+
+	/*
+	 * If the daemon took a long time to finish, retry to prevent missing
+	 * clearing dirty bits.
+	 */
+	if (test_and_clear_bit(BITMAP_DAEMON_BUSY, &llbitmap->flags))
+		goto retry;
+
+	/* If some page is dirty but not expired, setup timer again */
+	if (restart)
+		mod_timer(&llbitmap->pending_timer,
+			  jiffies + llbitmap->mddev->bitmap_info.daemon_sleep * HZ);
+}
+
+static int llbitmap_create(struct mddev *mddev)
+{
+	struct llbitmap *llbitmap;
+	int ret;
+
+	ret = llbitmap_check_support(mddev);
+	if (ret)
+		return ret;
+
+	llbitmap = kzalloc(sizeof(*llbitmap), GFP_KERNEL);
+	if (!llbitmap)
+		return -ENOMEM;
+
+	llbitmap->mddev = mddev;
+	llbitmap->io_size = bdev_logical_block_size(mddev->gendisk->part0);
+	llbitmap->bits_per_page = PAGE_SIZE / llbitmap->io_size;
+
+	timer_setup(&llbitmap->pending_timer, llbitmap_pending_timer_fn, 0);
+	INIT_WORK(&llbitmap->daemon_work, md_llbitmap_daemon_fn);
+	atomic_set(&llbitmap->behind_writes, 0);
+	init_waitqueue_head(&llbitmap->behind_wait);
+
+	mutex_lock(&mddev->bitmap_info.mutex);
+	mddev->bitmap = llbitmap;
+	ret = llbitmap_read_sb(llbitmap);
+	mutex_unlock(&mddev->bitmap_info.mutex);
+	if (ret)
+		goto err_out;
+
+	return 0;
+
+err_out:
+	kfree(llbitmap);
+	return ret;
+}
+
+static int llbitmap_resize(struct mddev *mddev, sector_t blocks, int chunksize)
+{
+	struct llbitmap *llbitmap = mddev->bitmap;
+	unsigned long chunks;
+
+	if (chunksize == 0)
+		chunksize = llbitmap->chunksize;
+
+	/* If there is enough space, leave the chunksize unchanged. */
+	chunks = DIV_ROUND_UP(blocks, chunksize);
+	while (chunks > mddev->bitmap_info.space << SECTOR_SHIFT) {
+		chunksize = chunksize << 1;
+		chunks = DIV_ROUND_UP(blocks, chunksize);
+	}
+
+	llbitmap->chunkshift = ffz(~chunksize);
+	llbitmap->chunksize = chunksize;
+	llbitmap->chunks = chunks;
+
+	return 0;
+}
+
+static int llbitmap_load(struct mddev *mddev)
+{
+	enum llbitmap_action action = BitmapActionReload;
+	struct llbitmap *llbitmap = mddev->bitmap;
+
+	if (test_and_clear_bit(BITMAP_STALE, &llbitmap->flags))
+		action = BitmapActionStale;
+
+	llbitmap_state_machine(llbitmap, 0, llbitmap->chunks - 1, action);
+	return 0;
+}
+
+static void llbitmap_destroy(struct mddev *mddev)
+{
+	struct llbitmap *llbitmap = mddev->bitmap;
+
+	if (!llbitmap)
+		return;
+
+	mutex_lock(&mddev->bitmap_info.mutex);
+
+	timer_delete_sync(&llbitmap->pending_timer);
+	flush_workqueue(md_llbitmap_io_wq);
+	flush_workqueue(md_llbitmap_unplug_wq);
+
+	mddev->bitmap = NULL;
+	llbitmap_free_pages(llbitmap);
+	kfree(llbitmap);
+	mutex_unlock(&mddev->bitmap_info.mutex);
+}
+
 #endif /* CONFIG_MD_LLBITMAP */
-- 
2.39.2

