Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9BD8329E46;
	Wed, 24 Jun 2026 06:42:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782283369; cv=none; b=mYQOfJkpAfkiTRq+ZrT24MrcmMlxCp4WLOD3JRis9DbQWD4JUwNB6Rf6dxDSZ39B2b7vjxeVOA+EAnsPDvH4WouWDCV8D5yz2M+GD57+MflMS+LBcXlbYJegrT3SeGvl7eK3zXqdqLAX4VERzy0tYpKZuFU/KQeBS9LDKN5K+aE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782283369; c=relaxed/simple;
	bh=KkeGYrMwruPJlKHXbnswp7zd3KHhGiWXpCfLnV+iic4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pHqUjXqHI3J16zGS2A/1f5LSJrYjrW4CgQ3eUUh2RxiIbe/F1MTT7KfjwqzvlIBou5cKuvAgh8IQYIHJVfuFkNtCZSQnK4tbb2pKBiuIEuhIIFnqqQBLH/Jv0EyoLFSvjnasR9pSY7CEYu1JGQeLOfsph+RiFowSXBy2J4OXeEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=c4D7DQ84; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c4D7DQ84"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E3A21F00A3D;
	Wed, 24 Jun 2026 06:42:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782283368;
	bh=7ed7wR19Ikzbf2IjsQpzGxTp0Pz1nUBk/faQlW9rt1c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c4D7DQ84/SFJ9rDwCqDN1Aa2Q4eGe33PSvRwDWMjTbBygPaehXIo0SyTr3yx9uUDK
	 03dqJtiq+9E6bNJU0bLl/2Z5acLmUtNLSQ0QVbnFscIkKwQZJFShs8rpqfpLDowLWv
	 wZ4aqZTRG1T1rJpZ9gZtIeRXMS4bXLxA5f4qs/HQ9eNFZI32GzFNtA9s7Ygfd2wocu
	 f12JXALGCQ2qVb/+225LOukl/1N6Fu69Z92mnduByHuU8HRxtrxKQvBJPqFUe/Pbc9
	 QftdP7YnBprXEUJqB2pMug1pz8+XLkV4Y7CkiAD0Aw8qSMqvASI2QzFC8IF8cdfO+g
	 mivy123OhzviA==
From: Yu Kuai <yukuai@kernel.org>
To: Song Liu <song@kernel.org>,
	Yu Kuai <yukuai@fygo.io>
Cc: Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	Su Yue <glass.su@suse.com>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 10/20] md/md-llbitmap: add reshape range mapping helpers
Date: Wed, 24 Jun 2026 14:42:07 +0800
Message-ID: <8a47becf3100a3998e003afcdabce6c17c149194.1782282042.git.yukuai@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1782282042.git.yukuai@kernel.org>
References: <20260605091527.2463539-1-yukuai@kernel.org> <cover.1782282042.git.yukuai@kernel.org>
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
index 11fede1fc79f..d27993cfb13d 100644
--- a/drivers/md/md-llbitmap.c
+++ b/drivers/md/md-llbitmap.c
@@ -9,6 +9,7 @@
 #include <linux/sched.h>
 #include <linux/list.h>
 #include <linux/file.h>
+#include <linux/math64.h>
 #include <linux/seq_file.h>
 #include <trace/events/block.h>
 
@@ -449,6 +450,16 @@ static sector_t llbitmap_personality_sync_size(struct llbitmap *llbitmap,
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
@@ -466,6 +477,52 @@ static void llbitmap_refresh_reshape(struct llbitmap *llbitmap)
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
@@ -1376,11 +1433,32 @@ static void llbitmap_destroy(struct mddev *mddev)
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
@@ -1549,7 +1627,11 @@ static bool llbitmap_blocks_synced(struct mddev *mddev, sector_t offset)
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
@@ -1559,7 +1641,11 @@ static sector_t llbitmap_skip_sync_blocks(struct mddev *mddev, sector_t offset)
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
@@ -1604,6 +1690,8 @@ static bool llbitmap_start_sync(struct mddev *mddev, sector_t offset,
 	 * if md_do_sync() loop more times.
 	 */
 	*blocks = llbitmap->chunksize - (offset & (llbitmap->chunksize - 1));
+	if (p >= llbitmap->chunks)
+		return false;
 	state = llbitmap_state_machine(llbitmap, p, p, BitmapActionStartsync);
 	return state == BitSyncing || state == BitSyncingUnwritten;
 }
-- 
2.51.0

