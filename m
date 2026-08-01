Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA6523B6BF0;
	Sat,  1 Aug 2026 17:27:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785605227; cv=none; b=Zfk0q67FGbwww4tsAWNbvSXHlaM0bvCKsREplw5aZN92dPFOlmtz8jzQA3NJtooC0n4ZV/EqgCHhRIOX5MTP1fahDLCWgVlxiGUkfLjF9Y5ARfNUwcLHTDUdnzJMmAL+0wBomHDOXs6gH07p8FagOXyuQnQ9qqQU3g/CXK2OQlQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785605227; c=relaxed/simple;
	bh=mfGOIXGvo4zi7djipiv1tFalQ31ZzlIXGCj8rK65u9w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B1axZcY5n3WUfUeJTfpzXO3PB02lxjj3QCgOffGVCv0K/QHf+XK0C0792kK4/Da2vmwjDoHAz/jEnUzQz9zeJIxQQJf2XsLgDwlRCfuwnxWgJdIXynVGXpwazvidimQ6mVdZFMD3+48hpdO2s+bkF9v7j27HL44lCUI52xseX24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WdigaIcO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WdigaIcO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64E431F00AC4;
	Sat,  1 Aug 2026 17:27:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785605225;
	bh=UGxDvHEe20eING+EcorLxYgHB71n3BmVpRGRRbq0hEw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WdigaIcOjMcpCYrQ1zHtpsmfNkqifUczKGzkeKXfxJHvIbxRQHiNsEvGiW3moJDAX
	 JH79YkjoXNmGzZEvl9+l+WRvgxoGDZPQGrOuAogSfyRUf2vROnlc3NFDhKT2NDb+dy
	 PmsYmzMZ352HCpRZcwRmZGLk8OGgo+hHG8rUuKEI9bJfxX2IO1sCB/T/En51uT/I2I
	 qKuQvdgUuPVYTW5cUGjqy9HZ5xTihAp9Sx9Gtl3rH6DDCH77t/gcWq0+KTq6ft8tmV
	 D19fnNlxoqfSk/Tamde/SQYcl5PXe4Hr+hB6F5OOySBMccPRy2vq8toP7ewyEEBrKw
	 CdZYku/FV2Edg==
From: Yu Kuai <yukuai@kernel.org>
To: Song Liu <song@kernel.org>
Cc: Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	Mykola Marzhan <mykola@meshstor.io>,
	Su Yue <glass.su@suse.com>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v4 15/25] md/md-llbitmap: add reshape range mapping helpers
Date: Sun,  2 Aug 2026 01:25:09 +0800
Message-ID: <20260801172519.2982121-16-yukuai@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260801172519.2982121-1-yukuai@kernel.org>
References: <20260801172519.2982121-1-yukuai@kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Yu Kuai <yukuai@fygo.io>

Teach llbitmap to choose old versus new geometry during reshape and to
encode exact bitmap ranges for the active geometry. This is the mapping
groundwork for checkpoint remapping.

Range preparation now distinguishes writes from discards. Normal writes
must cover every touched bitmap chunk, while discards may only mark fully
covered chunks unwritten. Without this distinction, a discard that starts
or ends inside a chunk can make live data look unwritten after the range
has been mapped and floored.

Reproduce that with a RAID1 llbitmap using 128-sector chunks. A discard
starting halfway into chunk 8 with a 128-sector length changed clean bits
from 16352 to 16350 and unwritten bits from 0 to 2, even though no chunk
was fully discarded. With discard-specific range encoding, both counts
stay unchanged for the same test.

Range preparation also clamps the pre-map range in the same coordinate
space as the incoming IO. RAID5 receives array-sector offsets but tracks
llbitmap sync size in component sectors, so steady-state RAID5 must use
bitmap_array_sectors() before mapping and keep the existing sync-size
clamp after mapping.

Reproduce that with a 4-disk RAID5 llbitmap created --assume-clean. A
write below dev_sectors changed dirty bits from 0 to 512, but a write at
seek=2094080 left the count at 512. With the array-sector pre-map limit,
writing at seek=component_size + 65536 increased dirty bits from 512 to
1024.

Reported-by: Mykola Marzhan <mykola@meshstor.io>
Link: https://lore.kernel.org/all/20260726185916.2223460-1-mykola@meshstor.io/
Signed-off-by: Yu Kuai <yukuai@fygo.io>
---
 drivers/md/md-bitmap.c   |   2 +-
 drivers/md/md-bitmap.h   |   3 +-
 drivers/md/md-llbitmap.c | 137 +++++++++++++++++++++++++++++++++++----
 drivers/md/md.c          |  10 +--
 4 files changed, 134 insertions(+), 18 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index 4c31807e6bcc..52dfbca28b64 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -1731,7 +1731,7 @@ static void bitmap_start_write(struct mddev *mddev, sector_t offset,
 }
 
 static void bitmap_prepare_range(struct mddev *mddev, sector_t *offset,
-				 unsigned long *sectors)
+				 unsigned long *sectors, bool discard)
 {
 	if (mddev->pers->bitmap_sector)
 		mddev->pers->bitmap_sector(mddev, offset, sectors);
diff --git a/drivers/md/md-bitmap.h b/drivers/md/md-bitmap.h
index 26cd07737aab..97cdd7cea5dd 100644
--- a/drivers/md/md-bitmap.h
+++ b/drivers/md/md-bitmap.h
@@ -96,7 +96,8 @@ struct bitmap_operations {
 	/* Prepare a range for this bitmap implementation. */
 	void (*prepare_range)(struct mddev *mddev,
 			      sector_t *offset,
-			      unsigned long *sectors);
+			      unsigned long *sectors,
+			      bool discard);
 	void (*reshape_finish)(struct mddev *mddev);
 	int (*reshape_can_start)(struct mddev *mddev);
 	void (*reshape_mark)(struct mddev *mddev, sector_t old_pos,
diff --git a/drivers/md/md-llbitmap.c b/drivers/md/md-llbitmap.c
index 3b121b372cd8..eed3e248b730 100644
--- a/drivers/md/md-llbitmap.c
+++ b/drivers/md/md-llbitmap.c
@@ -9,6 +9,7 @@
 #include <linux/sched.h>
 #include <linux/list.h>
 #include <linux/file.h>
+#include <linux/math64.h>
 #include <linux/seq_file.h>
 #include <trace/events/block.h>
 
@@ -433,22 +434,28 @@ static void llbitmap_calculate_chunks(struct mddev *mddev, sector_t blocks,
 	}
 }
 
-static bool llbitmap_reshaping(struct llbitmap *llbitmap)
-{
-	return llbitmap->mddev->reshape_position != MaxSector;
-}
-
 static sector_t llbitmap_personality_sync_size(struct llbitmap *llbitmap,
 					       bool previous)
 {
 	struct mddev *mddev = llbitmap->mddev;
 
-	if (!llbitmap_reshaping(llbitmap) || !mddev->private || !mddev->pers ||
+	if (READ_ONCE(mddev->reshape_position) == MaxSector ||
+	    !mddev->private || !mddev->pers ||
 	    !mddev->pers->bitmap_sync_size)
 		return llbitmap->sync_size;
 	return mddev->pers->bitmap_sync_size(mddev, previous);
 }
 
+static sector_t llbitmap_logical_size(struct llbitmap *llbitmap, bool previous)
+{
+	struct mddev *mddev = llbitmap->mddev;
+
+	if (!mddev->private || !mddev->pers ||
+	    !mddev->pers->bitmap_array_sectors)
+		return llbitmap_personality_sync_size(llbitmap, previous);
+	return mddev->pers->bitmap_array_sectors(mddev, previous);
+}
+
 static void llbitmap_refresh_reshape(struct llbitmap *llbitmap)
 {
 	unsigned long old_chunks = DIV_ROUND_UP_SECTOR_T(llbitmap->sync_size,
@@ -466,6 +473,80 @@ static void llbitmap_refresh_reshape(struct llbitmap *llbitmap)
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
+static void llbitmap_encode_discard_range(struct llbitmap *llbitmap,
+					  sector_t *offset,
+					  unsigned long *sectors,
+					  bool previous)
+{
+	unsigned long chunksize = previous ? llbitmap->chunksize :
+					      llbitmap->reshape_chunksize;
+	sector_t end = *offset + *sectors;
+	u64 start;
+	u64 last;
+
+	if (!*sectors) {
+		*offset = 0;
+		return;
+	}
+
+	start = DIV_ROUND_UP_SECTOR_T(*offset, chunksize);
+	last = div64_u64(end, chunksize);
+	if (start >= last) {
+		*offset = 0;
+		*sectors = 0;
+		return;
+	}
+
+	*offset = (sector_t)start << llbitmap->chunkshift;
+	*sectors = (last - start) << llbitmap->chunkshift;
+}
+
 static enum llbitmap_state llbitmap_read(struct llbitmap *llbitmap, loff_t pos)
 {
 	unsigned int idx;
@@ -1394,11 +1475,35 @@ static void llbitmap_destroy(struct mddev *mddev)
 	mutex_unlock(&mddev->bitmap_info.mutex);
 }
 
+static bool llbitmap_map_previous(struct llbitmap *llbitmap, sector_t offset,
+				  unsigned long sectors)
+{
+	struct mddev *mddev = llbitmap->mddev;
+	sector_t boundary = READ_ONCE(mddev->reshape_position);
+
+	if (boundary == MaxSector)
+		return false;
+
+	WARN_ON_ONCE(sectors && offset < boundary && offset + sectors > boundary);
+
+	return mddev->reshape_backwards ? offset < boundary : offset >= boundary;
+}
+
 static void llbitmap_prepare_range(struct mddev *mddev, sector_t *offset,
-				   unsigned long *sectors)
+				   unsigned long *sectors, bool discard)
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
+	if (discard)
+		llbitmap_encode_discard_range(llbitmap, offset, sectors, previous);
+	else
+		llbitmap_encode_range(llbitmap, offset, sectors, previous);
 }
 
 static void llbitmap_start_write(struct mddev *mddev, sector_t offset,
@@ -1567,7 +1672,11 @@ static bool llbitmap_blocks_synced(struct mddev *mddev, sector_t offset)
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
@@ -1577,7 +1686,11 @@ static sector_t llbitmap_skip_sync_blocks(struct mddev *mddev, sector_t offset)
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
@@ -1622,6 +1735,8 @@ static bool llbitmap_start_sync(struct mddev *mddev, sector_t offset,
 	 * if md_do_sync() loop more times.
 	 */
 	*blocks = llbitmap->chunksize - (offset & (llbitmap->chunksize - 1));
+	if (p >= llbitmap->chunks)
+		return false;
 	state = llbitmap_state_machine(llbitmap, p, p, BitmapActionStartsync);
 	return state == BitSyncing || state == BitSyncingUnwritten;
 }
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 34e95ef9f2d4..30d9f9c02e73 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -9401,20 +9401,20 @@ struct bio *mddev_bio_split_at_reshape_offset(struct mddev *mddev,
 EXPORT_SYMBOL_GPL(mddev_bio_split_at_reshape_offset);
 
 static void md_bitmap_prepare_range(struct mddev *mddev, sector_t *offset,
-				    unsigned long *sectors)
+				    unsigned long *sectors, bool discard)
 {
-	mddev->bitmap_ops->prepare_range(mddev, offset, sectors);
+	mddev->bitmap_ops->prepare_range(mddev, offset, sectors, discard);
 }
 
 static void md_bitmap_start(struct mddev *mddev,
 			    struct md_io_clone *md_io_clone)
 {
-	md_bitmap_fn *fn = unlikely(md_io_clone->rw == STAT_DISCARD) ?
-			   mddev->bitmap_ops->start_discard :
+	bool discard = md_io_clone->rw == STAT_DISCARD;
+	md_bitmap_fn *fn = discard ? mddev->bitmap_ops->start_discard :
 			   mddev->bitmap_ops->start_write;
 
 	md_bitmap_prepare_range(mddev, &md_io_clone->offset,
-				&md_io_clone->sectors);
+				&md_io_clone->sectors, discard);
 	if (!md_io_clone->sectors)
 		return;
 	fn(mddev, md_io_clone->offset, md_io_clone->sectors);
-- 
2.51.0

