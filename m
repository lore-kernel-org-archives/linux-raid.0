Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3A043F8238;
	Fri,  5 Jun 2026 09:15:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780650955; cv=none; b=riVJ1fGnuAd9Si1foGuQg4SfjEwjwjPQUx9IWkpuA/uNvtQMlg9ZE43qk8tfNkft5ZlvmueOEgsTsncRFqK8uzkEGgmZltOU6bNhb2XsS94+UJMOrel3FacFT7FPpCvz9iCKLfnYD6ujh0OupFRCVdS4Pc9hQw3dtL9CUH+Gicc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780650955; c=relaxed/simple;
	bh=iKDMcX6WczuPUmfEKwVjoCnOtrImChZ+U0Yh/L6l1gw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ChSt3gJitd6M1px2345sWavXGSzQhGSUeaG8b5qdDk+tQYhlGvo3NUPkiJtf68KUXND2PAWiMSBEQJrrJwL47aKCc79QdoU6GS3YGt6uy8Q3rVWaC5WEZaX4M3TrnR7uHXzoYAlDzGs08+DUYDfheZWCLY+AqPIzbxzjC0RAqDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PJgn7Zt9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PJgn7Zt9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F3371F00898;
	Fri,  5 Jun 2026 09:15:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780650953;
	bh=yzs4iug/vUse0xrYawxnVKe3/CnkCWHnLazhjExk4Pw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PJgn7Zt9xre119OvSrzWpDiH0JKflPaxqhD0hjsxZRQv1NjL+hmu0E27o6zc5O+4y
	 rFqYsLooKOzaVUsOyFm38aaveEIs5ZibeTLivBLe2ROYifVVb4seDsguA/l6bSj7Hx
	 wC0YPKyCvnHKDBxhuGwcJt0GE6Z569AFWRdHBzvg43R7FSCKAB1ZOsl5VGuoON4TdZ
	 2x8zxT/S6M3dWY4gBQ7X1FxXQLUZdUEFKgb1104YdKwAsDuRtJuN58qyo2WA1ov6N7
	 GhzaMDFWnZ0WE+s+pBbiBH/NxkoYohkGo6fUe+AiJcdTvMtvyCCN0asSLJqDGpqM75
	 W8662BMYwILxA==
From: Yu Kuai <yukuai@kernel.org>
To: Song Liu <song@kernel.org>,
	Yu Kuai <yukuai@fygo.io>
Cc: Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] md/md-llbitmap: add reshape range mapping helpers
Date: Fri,  5 Jun 2026 17:15:17 +0800
Message-ID: <20260605091527.2463539-11-yukuai@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260605091527.2463539-1-yukuai@kernel.org>
References: <20260605091527.2463539-1-yukuai@kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Yu Kuai <yukuai@fygo.io>

Teach llbitmap to choose old versus new geometry during reshape and to
encode exact bitmap ranges for the active geometry.

This is the mapping groundwork for checkpoint remapping.

Signed-off-by: Yu Kuai <yukuai@fygo.io>
---
 drivers/md/md-llbitmap.c | 96 ++++++++++++++++++++++++++++++++++++++--
 1 file changed, 92 insertions(+), 4 deletions(-)

diff --git a/drivers/md/md-llbitmap.c b/drivers/md/md-llbitmap.c
index f45daf3be4d5..76621a9fd645 100644
--- a/drivers/md/md-llbitmap.c
+++ b/drivers/md/md-llbitmap.c
@@ -7,10 +7,11 @@
 #include <linux/init.h>
 #include <linux/timer.h>
 #include <linux/sched.h>
 #include <linux/list.h>
 #include <linux/file.h>
+#include <linux/math64.h>
 #include <linux/seq_file.h>
 #include <trace/events/block.h>
 
 #include "md.h"
 #include "md-bitmap.h"
@@ -447,10 +448,20 @@ static sector_t llbitmap_personality_sync_size(struct llbitmap *llbitmap,
 	    !mddev->pers->bitmap_sync_size)
 		return llbitmap->sync_size;
 	return mddev->pers->bitmap_sync_size(mddev, previous);
 }
 
+static sector_t llbitmap_logical_size(struct llbitmap *llbitmap, bool previous)
+{
+	struct mddev *mddev = llbitmap->mddev;
+
+	if (!llbitmap_reshaping(llbitmap) || !mddev->private || !mddev->pers ||
+	    !mddev->pers->bitmap_array_sectors)
+		return llbitmap_personality_sync_size(llbitmap, previous);
+	return mddev->pers->bitmap_array_sectors(mddev, previous);
+}
+
 static void llbitmap_refresh_reshape(struct llbitmap *llbitmap)
 {
 	unsigned long old_chunks = DIV_ROUND_UP_SECTOR_T(llbitmap->sync_size,
 						 llbitmap->chunksize);
 	sector_t blocks = llbitmap_personality_sync_size(llbitmap, false);
@@ -463,10 +474,56 @@ static void llbitmap_refresh_reshape(struct llbitmap *llbitmap)
 	llbitmap_resize_chunks(llbitmap->mddev, blocks, &llbitmap->reshape_chunksize,
 			       &llbitmap->reshape_chunks);
 	llbitmap->chunks = max(old_chunks, llbitmap->reshape_chunks);
 }
 
+static void llbitmap_map_layout(struct llbitmap *llbitmap, sector_t *offset,
+				unsigned long *sectors, bool previous)
+{
+	sector_t limit = llbitmap_logical_size(llbitmap, previous);
+	sector_t start = *offset;
+	sector_t end = start + *sectors;
+
+	if (start >= limit) {
+		*sectors = 0;
+		return;
+	}
+	if (end > limit)
+		end = limit;
+
+	*offset = start;
+	*sectors = end - start;
+	if (!*sectors)
+		return;
+
+	if (llbitmap->mddev->pers->bitmap_sector_map)
+		llbitmap->mddev->pers->bitmap_sector_map(llbitmap->mddev, offset,
+							 sectors, previous);
+	else if (!previous && llbitmap->mddev->pers->bitmap_sector)
+		llbitmap->mddev->pers->bitmap_sector(llbitmap->mddev, offset,
+							 sectors);
+}
+
+static void llbitmap_encode_range(struct llbitmap *llbitmap, sector_t *offset,
+				  unsigned long *sectors, bool previous)
+{
+	unsigned long chunksize = previous ? llbitmap->chunksize :
+				      llbitmap->reshape_chunksize;
+	u64 start;
+	u64 end;
+
+	if (!*sectors) {
+		*offset = 0;
+		return;
+	}
+
+	start = div64_u64(*offset, chunksize);
+	end = div64_u64(*offset + *sectors - 1, chunksize);
+	*offset = (sector_t)start << llbitmap->chunkshift;
+	*sectors = (end - start + 1) << llbitmap->chunkshift;
+}
+
 static enum llbitmap_state llbitmap_read(struct llbitmap *llbitmap, loff_t pos)
 {
 	unsigned int idx;
 	unsigned int offset;
 
@@ -1373,15 +1430,36 @@ static void llbitmap_destroy(struct mddev *mddev)
 	llbitmap_free_pages(llbitmap);
 	kfree(llbitmap);
 	mutex_unlock(&mddev->bitmap_info.mutex);
 }
 
+static bool llbitmap_map_previous(struct llbitmap *llbitmap, sector_t offset,
+				  unsigned long sectors)
+{
+	struct mddev *mddev = llbitmap->mddev;
+	sector_t boundary = mddev->reshape_position;
+
+	if (!llbitmap_reshaping(llbitmap))
+		return false;
+
+	WARN_ON_ONCE(sectors && offset < boundary && offset + sectors > boundary);
+
+	return mddev->reshape_backwards ? offset < boundary : offset >= boundary;
+}
+
 static void llbitmap_prepare_range(struct mddev *mddev, sector_t *offset,
 				   unsigned long *sectors)
 {
-	if (mddev->pers->bitmap_sector)
-		mddev->pers->bitmap_sector(mddev, offset, sectors);
+	struct llbitmap *llbitmap = mddev->bitmap;
+	bool previous;
+
+	if (!llbitmap)
+		return;
+
+	previous = llbitmap_map_previous(llbitmap, *offset, *sectors);
+	llbitmap_map_layout(llbitmap, offset, sectors, previous);
+	llbitmap_encode_range(llbitmap, offset, sectors, previous);
 }
 
 static void llbitmap_start_write(struct mddev *mddev, sector_t offset,
 				 unsigned long sectors)
 {
@@ -1546,21 +1624,29 @@ static void llbitmap_flush(struct mddev *mddev)
 /* This is used for raid5 lazy initial recovery */
 static bool llbitmap_blocks_synced(struct mddev *mddev, sector_t offset)
 {
 	struct llbitmap *llbitmap = mddev->bitmap;
 	unsigned long p = offset >> llbitmap->chunkshift;
-	enum llbitmap_state c = llbitmap_read(llbitmap, p);
+	enum llbitmap_state c;
+
+	if (p >= llbitmap->chunks)
+		return false;
+	c = llbitmap_read(llbitmap, p);
 
 	return c == BitClean || c == BitDirty || c == BitCleanUnwritten;
 }
 
 static sector_t llbitmap_skip_sync_blocks(struct mddev *mddev, sector_t offset)
 {
 	struct llbitmap *llbitmap = mddev->bitmap;
 	unsigned long p = offset >> llbitmap->chunkshift;
 	int blocks = llbitmap->chunksize - (offset & (llbitmap->chunksize - 1));
-	enum llbitmap_state c = llbitmap_read(llbitmap, p);
+	enum llbitmap_state c;
+
+	if (p >= llbitmap->chunks)
+		return 0;
+	c = llbitmap_read(llbitmap, p);
 
 	/* always skip unwritten blocks */
 	if (c == BitUnwritten)
 		return blocks;
 
@@ -1601,10 +1687,12 @@ static bool llbitmap_start_sync(struct mddev *mddev, sector_t offset,
 	/*
 	 * Handle one bit at a time, this is much simpler. And it doesn't matter
 	 * if md_do_sync() loop more times.
 	 */
 	*blocks = llbitmap->chunksize - (offset & (llbitmap->chunksize - 1));
+	if (p >= llbitmap->chunks)
+		return false;
 	state = llbitmap_state_machine(llbitmap, p, p, BitmapActionStartsync);
 	return state == BitSyncing || state == BitSyncingUnwritten;
 }
 
 /* Something is wrong, sync_thread stop at @offset */
-- 
2.51.0

