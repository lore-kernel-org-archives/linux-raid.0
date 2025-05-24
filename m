Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6B221EBFFF;
	Sat, 24 May 2025 06:18:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748067506; cv=none; b=aho98tbVeWT4BP8jWKpmPLTJdFVPLNbacp/Btm93n+mWRFXyIgvHjQFOdslVGjMe2n43fTjh1dLpnHda4n545jrqtXnmb5OfiFD+dq3YUSQ6DMeIjcRjUHXFhdaBnpfMLnzvLIuyZhvZBm60lJCawZPVq+TDtGds3DQkjH/tT/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748067506; c=relaxed/simple;
	bh=MyWhWTcxnRGi1PbvP79UXlEvSyp3oQ83ku+Es7Y1HtA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=s0uzlreGFEMLcsNCIrWQONXOv8mMn/uB+e2k1vm7vSVTZOa1V9xauaAwOaEeVXYMQjVOrnWFmBvn+43+WLZ4TSQMfUPlxOfbmeW+fMneY10lE8BFXhTNMcPLpafWtfBm7ITViO0lONJ98GodQjGQBsLxurVLcQilWTXILt1tV2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4b4BfC5xFjz4f3jJ8;
	Sat, 24 May 2025 14:17:55 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id F2A7E1A14E3;
	Sat, 24 May 2025 14:18:20 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgCnCl+dZDFo3etkNQ--.42979S23;
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
Subject: [PATCH 19/23] md/md-llbitmap: implement APIs to dirty bits and clear bits
Date: Sat, 24 May 2025 14:13:16 +0800
Message-Id: <20250524061320.370630-20-yukuai1@huaweicloud.com>
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
X-CM-TRANSID:gCh0CgCnCl+dZDFo3etkNQ--.42979S23
X-Coremail-Antispam: 1UD129KBjvJXoW3JF1DtFWkCFW8Gw4UCr17KFg_yoW7ZFyrpF
	43Xw15Kr45J34Fg347J3srZF1rtr4kJwnFqF93A34rGw15Ars0gF48GFykZw1Uur93WF1D
	Aw45Kry5Cw4fWrDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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
 - llbitmap_startwrite
 - llbitmap_endwrite
 - llbitmap_start_discard
 - llbitmap_end_discard
 - llbitmap_unplug
 - llbitmap_flush

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/md-llbitmap.c | 162 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 162 insertions(+)

diff --git a/drivers/md/md-llbitmap.c b/drivers/md/md-llbitmap.c
index 23283c4f7263..37e72885dbdb 100644
--- a/drivers/md/md-llbitmap.c
+++ b/drivers/md/md-llbitmap.c
@@ -1011,4 +1011,166 @@ static void llbitmap_destroy(struct mddev *mddev)
 	mutex_unlock(&mddev->bitmap_info.mutex);
 }
 
+static void llbitmap_start_write(struct mddev *mddev, sector_t offset,
+				 unsigned long sectors)
+{
+	struct llbitmap *llbitmap = mddev->bitmap;
+	unsigned long start = offset >> llbitmap->chunkshift;
+	unsigned long end = (offset + sectors - 1) >> llbitmap->chunkshift;
+	int page_start = (start + BITMAP_SB_SIZE) >> PAGE_SHIFT;
+	int page_end = (end + BITMAP_SB_SIZE) >> PAGE_SHIFT;
+
+	llbitmap_state_machine(llbitmap, start, end, BitmapActionStartwrite);
+
+
+	while (page_start <= page_end) {
+		llbitmap_raise_barrier(llbitmap, page_start);
+		page_start++;
+	}
+}
+
+static void llbitmap_end_write(struct mddev *mddev, sector_t offset,
+			       unsigned long sectors)
+{
+	struct llbitmap *llbitmap = mddev->bitmap;
+	unsigned long start = offset >> llbitmap->chunkshift;
+	unsigned long end = (offset + sectors - 1) >> llbitmap->chunkshift;
+	int page_start = (start + BITMAP_SB_SIZE) >> PAGE_SHIFT;
+	int page_end = (end + BITMAP_SB_SIZE) >> PAGE_SHIFT;
+
+	while (page_start <= page_end) {
+		llbitmap_release_barrier(llbitmap, page_start);
+		page_start++;
+	}
+}
+
+static void llbitmap_start_discard(struct mddev *mddev, sector_t offset,
+				   unsigned long sectors)
+{
+	struct llbitmap *llbitmap = mddev->bitmap;
+	unsigned long start = DIV_ROUND_UP(offset, llbitmap->chunksize);
+	unsigned long end = (offset + sectors - 1) >> llbitmap->chunkshift;
+	int page_start = (start + BITMAP_SB_SIZE) >> PAGE_SHIFT;
+	int page_end = (end + BITMAP_SB_SIZE) >> PAGE_SHIFT;
+
+	llbitmap_state_machine(llbitmap, start, end, BitmapActionDiscard);
+
+	while (page_start <= page_end) {
+		llbitmap_raise_barrier(llbitmap, page_start);
+		page_start++;
+	}
+}
+
+static void llbitmap_end_discard(struct mddev *mddev, sector_t offset,
+				 unsigned long sectors)
+{
+	struct llbitmap *llbitmap = mddev->bitmap;
+	unsigned long start = DIV_ROUND_UP(offset, llbitmap->chunksize);
+	unsigned long end = (offset + sectors - 1) >> llbitmap->chunkshift;
+	int page_start = (start + BITMAP_SB_SIZE) >> PAGE_SHIFT;
+	int page_end = (end + BITMAP_SB_SIZE) >> PAGE_SHIFT;
+
+	while (page_start <= page_end) {
+		llbitmap_release_barrier(llbitmap, page_start);
+		page_start++;
+	}
+}
+
+static void llbitmap_unplug_fn(struct work_struct *work)
+{
+	struct llbitmap_unplug_work *unplug_work =
+		container_of(work, struct llbitmap_unplug_work, work);
+	struct llbitmap *llbitmap = unplug_work->llbitmap;
+	struct blk_plug plug;
+	int i;
+
+	blk_start_plug(&plug);
+
+	for (i = 0; i < llbitmap->nr_pages; i++) {
+		if (!test_bit(LLPageDirty, &llbitmap->pctl[i]->flags) ||
+		    !test_and_clear_bit(LLPageDirty, &llbitmap->pctl[i]->flags))
+			continue;
+
+		llbitmap_write_page(llbitmap, i);
+	}
+
+	blk_finish_plug(&plug);
+	md_super_wait(llbitmap->mddev);
+	complete(unplug_work->done);
+}
+
+static bool llbitmap_dirty(struct llbitmap *llbitmap)
+{
+	int i;
+
+	for (i = 0; i < llbitmap->nr_pages; i++)
+		if (test_bit(LLPageDirty, &llbitmap->pctl[i]->flags))
+			return true;
+
+	return false;
+}
+
+static void llbitmap_unplug(struct mddev *mddev, bool sync)
+{
+	DECLARE_COMPLETION_ONSTACK(done);
+	struct llbitmap *llbitmap = mddev->bitmap;
+	struct llbitmap_unplug_work unplug_work = {
+		.llbitmap = llbitmap,
+		.done = &done,
+	};
+
+	if (!llbitmap_dirty(llbitmap))
+		return;
+
+	/*
+	 * Issue new bitmap IO under submit_bio() context will deadlock:
+	 *  - the bio will wait for bitmap bio to be done, before it can be
+	 *  issued;
+	 *  - bitmap bio will be added to current->bio_list and wait for this
+	 *  bio to be issued;
+	 */
+	INIT_WORK_ONSTACK(&unplug_work.work, llbitmap_unplug_fn);
+	queue_work(md_llbitmap_unplug_wq, &unplug_work.work);
+	wait_for_completion(&done);
+	destroy_work_on_stack(&unplug_work.work);
+}
+
+/*
+ * Force to write all bitmap pages to disk, called when stopping the array, or
+ * every daemon_sleep seconds when sync_thread is running.
+ */
+static void __llbitmap_flush(struct mddev *mddev)
+{
+	struct llbitmap *llbitmap = mddev->bitmap;
+	struct blk_plug plug;
+	int i;
+
+	blk_start_plug(&plug);
+	for (i = 0; i < llbitmap->nr_pages; i++) {
+		struct llbitmap_page_ctl *pctl = llbitmap->pctl[i];
+
+		/* mark all bits as dirty */
+		set_bit(LLPageDirty, &pctl->flags);
+		bitmap_fill(pctl->dirty, llbitmap->bits_per_page);
+		llbitmap_write_page(llbitmap, i);
+	}
+	blk_finish_plug(&plug);
+	md_super_wait(llbitmap->mddev);
+}
+
+static void llbitmap_flush(struct mddev *mddev)
+{
+	struct llbitmap *llbitmap = mddev->bitmap;
+	int i;
+
+	for (i = 0; i < llbitmap->nr_pages; i++)
+		set_bit(LLPageFlush, &llbitmap->pctl[i]->flags);
+
+	timer_delete_sync(&llbitmap->pending_timer);
+	queue_work(md_llbitmap_io_wq, &llbitmap->daemon_work);
+	flush_work(&llbitmap->daemon_work);
+
+	__llbitmap_flush(mddev);
+}
+
 #endif /* CONFIG_MD_LLBITMAP */
-- 
2.39.2

