Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA8802848A1;
	Sun, 19 Apr 2026 03:10:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776568212; cv=none; b=M8BECC2VsznadCL/LUafAjQZMYX8rwYsRLJASwzEo3x/11Il0w3XDqT8VLR5uBZG35Vqvog440NmQ2GR1WBw6VlNXk9wXOzPJ0BAor/Ufsi1OaZZgz20HRtHbl5R55o3R607Y115fxImjIRqIphtM+SSVCKjbcMlLcbS7FRGVp0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776568212; c=relaxed/simple;
	bh=eFZtbZyKATU7rxviH+w6yWaIugUGFX8rBUHfrCpmhkY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cixw779Uv6Ee+Z6s07VeeBxe35XJmkYDR2hFGDnLmhBH+xBrGaVqQ+1KZDteXxRqgsbV2uuo42355Kqur3c+YbI0UsC+zQsbr0gZQu7P8KGOIGxJEs2XS+hGv1x7C3xXsgziPnnWuZEj9TNIwItdPM3kOygiSjsHl8TyqosAVn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09657C2BCB0;
	Sun, 19 Apr 2026 03:10:10 +0000 (UTC)
From: Yu Kuai <yukuai@fnnas.com>
To: linux-raid@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Li Nan <linan122@huawei.com>,
	Yu Kuai <yukuai@fnnas.com>,
	Cheng Cheng <chencheng@fnnas.com>
Subject: [PATCH] md/md-llbitmap: add reshape range mapping helpers
Date: Sun, 19 Apr 2026 11:09:32 +0800
Message-ID: <20260419030942.824195-10-yukuai@fnnas.com>
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

Teach llbitmap to choose old versus new geometry during reshape and to
encode exact bitmap ranges for the active geometry.

This is the mapping groundwork for checkpoint remapping.

Signed-off-by: Yu Kuai <yukuai@fnnas.com>
---
 drivers/md/md-llbitmap.c | 96 ++++++++++++++++++++++++++++++++++++++--
 1 file changed, 92 insertions(+), 4 deletions(-)

diff --git a/drivers/md/md-llbitmap.c b/drivers/md/md-llbitmap.c
index 88169eeda4b5..fd1dc86afc69 100644
--- a/drivers/md/md-llbitmap.c
+++ b/drivers/md/md-llbitmap.c
@@ -9,6 +9,7 @@
 #include <linux/sched.h>
 #include <linux/list.h>
 #include <linux/file.h>
+#include <linux/math64.h>
 #include <linux/seq_file.h>
 #include <trace/events/block.h>
 
@@ -383,6 +384,16 @@ static sector_t llbitmap_personality_sync_size(struct llbitmap *llbitmap,
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
@@ -399,6 +410,52 @@ static void llbitmap_refresh_reshape(struct llbitmap *llbitmap)
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
@@ -1248,11 +1305,32 @@ static void llbitmap_destroy(struct mddev *mddev)
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
@@ -1421,7 +1499,11 @@ static bool llbitmap_blocks_synced(struct mddev *mddev, sector_t offset)
 {
 	struct llbitmap *llbitmap = mddev->bitmap;
 	unsigned long p = offset >> llbitmap->chunkshift;
-	enum llbitmap_state c = llbitmap_read(llbitmap, p);
+	enum llbitmap_state c;
+
+	if (p >= llbitmap->chunks)
+		return false;
+	c = llbitmap_read(llbitmap, p);
 
 	return c == BitClean || c == BitDirty;
 }
@@ -1431,7 +1513,11 @@ static sector_t llbitmap_skip_sync_blocks(struct mddev *mddev, sector_t offset)
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
@@ -1461,6 +1547,8 @@ static bool llbitmap_start_sync(struct mddev *mddev, sector_t offset,
 	 * if md_do_sync() loop more times.
 	 */
 	*blocks = llbitmap->chunksize - (offset & (llbitmap->chunksize - 1));
+	if (p >= llbitmap->chunks)
+		return false;
 	return llbitmap_state_machine(llbitmap, p, p,
 				      BitmapActionStartsync) == BitSyncing;
 }
-- 
2.51.0

