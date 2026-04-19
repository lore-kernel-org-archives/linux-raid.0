Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DECA284662;
	Sun, 19 Apr 2026 03:10:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776568208; cv=none; b=QiMCwcvDEtUfIGii2PvcvdQ5xbfG71kbD9yTny+AiYhUrSw69GEoifv5Xw6ct8e1dbxSpkRsU6pfwiTeQgDZwuy4NLC8QgjLV7vLcEm9A9zE4PS+V6f2dKB5oHPj+EQeI/i2hCF+pnfodoa2k6t9OQwM4UjMPoATTHsBFrGOiyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776568208; c=relaxed/simple;
	bh=SXP9f9O4gLR//d2unBRWqanggB5I621j+Wc0KmsLPGA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D4BDTVK+xlY+f53YrOPUor57fIembJrPkFcU6pVNIED9r2dkQyxVqP32rwdlU9Sh0QR202W3/XBYI35gP6vnk/MOsguihnqQxL983no88TBJW6zYk4yHEF5Pq8kg79c6fmdQro9BkrwxpV48qdF+0y7mLwrV+I5FfpwDaYN4UD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC8FEC2BCB4;
	Sun, 19 Apr 2026 03:10:06 +0000 (UTC)
From: Yu Kuai <yukuai@fnnas.com>
To: linux-raid@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Li Nan <linan122@huawei.com>,
	Yu Kuai <yukuai@fnnas.com>,
	Cheng Cheng <chencheng@fnnas.com>
Subject: [PATCH] md/md-llbitmap: finish reshape geometry
Date: Sun, 19 Apr 2026 11:09:30 +0800
Message-ID: <20260419030942.824195-8-yukuai@fnnas.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260419030942.824195-1-yukuai@fnnas.com>
References: <20260419030942.824195-1-yukuai@fnnas.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Commit the staged llbitmap geometry when reshape finishes.\n\nThe reshape staging itself is handled through llbitmap_resize(), so only\nthe finish step remains in this patch.\n\nSigned-off-by: Yu Kuai <yukuai@fnnas.com>
---
 drivers/md/md-llbitmap.c | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/drivers/md/md-llbitmap.c b/drivers/md/md-llbitmap.c
index cfd97022b283..17a505ec65d6 100644
--- a/drivers/md/md-llbitmap.c
+++ b/drivers/md/md-llbitmap.c
@@ -1537,6 +1537,30 @@ static void llbitmap_dirty_bits(struct mddev *mddev, unsigned long s,
 	llbitmap_state_machine(mddev->bitmap, s, e, BitmapActionStartwrite);
 }
 
+static void llbitmap_reshape_finish(struct mddev *mddev)
+{
+	struct llbitmap *llbitmap = mddev->bitmap;
+
+	if (mddev->pers->quiesce)
+		mddev->pers->quiesce(mddev, 1);
+
+	mutex_lock(&mddev->bitmap_info.mutex);
+	llbitmap_flush(mddev);
+
+	llbitmap->chunksize = llbitmap->reshape_chunksize;
+	llbitmap->chunkshift = ffz(~llbitmap->chunksize);
+	llbitmap->chunks = llbitmap->reshape_chunks;
+	llbitmap->sync_size = llbitmap->reshape_sync_size;
+	llbitmap_refresh_reshape(llbitmap);
+	mddev->bitmap_info.chunksize = llbitmap->chunksize;
+	llbitmap_update_sb(llbitmap);
+	__llbitmap_flush(mddev);
+	mutex_unlock(&mddev->bitmap_info.mutex);
+
+	if (mddev->pers->quiesce)
+		mddev->pers->quiesce(mddev, 0);
+}
+
 static void llbitmap_write_sb(struct llbitmap *llbitmap)
 {
 	int nr_blocks = DIV_ROUND_UP(BITMAP_DATA_OFFSET, llbitmap->io_size);
@@ -1792,6 +1816,7 @@ static struct bitmap_operations llbitmap_ops = {
 	.get_stats		= llbitmap_get_stats,
 	.dirty_bits		= llbitmap_dirty_bits,
 	.prepare_range		= llbitmap_prepare_range,
+	.reshape_finish		= llbitmap_reshape_finish,
 	.write_all		= llbitmap_write_all,
 
 	.group			= &md_llbitmap_group,
-- 
2.51.0

