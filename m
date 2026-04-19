Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FD5C29A9FE;
	Sun, 19 Apr 2026 03:10:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776568216; cv=none; b=BNlyQlbyFxC+ph6Jy8R/Va7dLjMdMzBWCiPwWtKa/POtF7tMAYb4K7zCW+7uep4fV7kMXUvLTTpZTSe8YlyxnHQW8wFcy1m13PtL+ltl14SzsldmRfEDhuUDWuCMYhThvKkYOm32Id3kIkb70/p9RXL6RsAC+odXin6UxThIhA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776568216; c=relaxed/simple;
	bh=0UjVWGnn628tJDf6kW1y6qYL6V3bWtc+j+aaxCfas2I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vGdEGLieBm8K4mYvQW07MUNOhwc4plvbZX08mktLC5Jh9oZFzd0FHddHv6u4dbwciIqNPEECJj03OW6c81zUUpJWdVGGSKb2IrRa+k7zhuIoK2gn35gdPVBZb6zB7N7xG5iONI1ELl5J3PU5cmd5/OA3i0MRZtvq42D8KF7YQ6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1255C2BCB0;
	Sun, 19 Apr 2026 03:10:14 +0000 (UTC)
From: Yu Kuai <yukuai@fnnas.com>
To: linux-raid@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Li Nan <linan122@huawei.com>,
	Yu Kuai <yukuai@fnnas.com>,
	Cheng Cheng <chencheng@fnnas.com>
Subject: [PATCH] md/md-llbitmap: remap checkpointed bits as reshape progresses
Date: Sun, 19 Apr 2026 11:09:34 +0800
Message-ID: <20260419030942.824195-12-yukuai@fnnas.com>
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

Merge checkpointed old llbitmap state forward as reshape_position
advances and record the checkpoint remap through reshape_mark().

Signed-off-by: Yu Kuai <yukuai@fnnas.com>
---
 drivers/md/md-llbitmap.c | 172 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 172 insertions(+)

diff --git a/drivers/md/md-llbitmap.c b/drivers/md/md-llbitmap.c
index ad1b7a85914b..b3ff67779557 100644
--- a/drivers/md/md-llbitmap.c
+++ b/drivers/md/md-llbitmap.c
@@ -435,6 +435,14 @@ static void llbitmap_map_layout(struct llbitmap *llbitmap, sector_t *offset,
 	else if (!previous && llbitmap->mddev->pers->bitmap_sector)
 		llbitmap->mddev->pers->bitmap_sector(llbitmap->mddev, offset,
 							 sectors);
+
+	limit = llbitmap_personality_sync_size(llbitmap, previous);
+	start = *offset;
+	end = start + *sectors;
+	if (start >= limit)
+		*sectors = 0;
+	else if (end > limit)
+		*sectors = limit - start;
 }
 
 static void llbitmap_encode_range(struct llbitmap *llbitmap, sector_t *offset,
@@ -787,6 +795,33 @@ static int llbitmap_prepare_resize(struct llbitmap *llbitmap,
 	return 0;
 }
 
+static enum llbitmap_state
+llbitmap_rmerge_state(struct llbitmap *llbitmap,
+		      enum llbitmap_state dst,
+		      enum llbitmap_state src)
+{
+	bool level_456 = raid_is_456(llbitmap->mddev);
+
+	if (dst == BitNeedSync || dst == BitSyncing ||
+	    src == BitNeedSync || src == BitSyncing)
+		return BitNeedSync;
+
+	if (dst == BitDirty || src == BitDirty)
+		return BitDirty;
+
+	/*
+	 * Reshape generates valid target parity/data for both already-written
+	 * and not-yet-written regions in the checkpointed range, so a mix of
+	 * clean and unwritten still results in a clean destination bit.
+	 */
+	if (level_456 && ((dst == BitClean && src == BitUnwritten) ||
+			  (src == BitClean && dst == BitUnwritten)))
+		return BitClean;
+	if (dst == BitClean || src == BitClean)
+		return BitClean;
+	return BitUnwritten;
+}
+
 static void llbitmap_init_state(struct llbitmap *llbitmap)
 {
 	enum llbitmap_state state = BitUnwritten;
@@ -1656,6 +1691,120 @@ static int llbitmap_reshape_can_start(struct mddev *mddev)
 	return ret;
 }
 
+struct llbitmap_reshape_range {
+	sector_t offset;
+	unsigned long sectors;
+	sector_t start;
+	sector_t end;
+};
+
+static enum llbitmap_state
+llbitmap_reshape_init_dst(struct llbitmap *llbitmap, unsigned long dst,
+			  const struct llbitmap_reshape_range *new)
+{
+	u64 bit_start = (u64)dst * llbitmap->reshape_chunksize;
+	u64 bit_end = bit_start + llbitmap->reshape_chunksize;
+
+	if (!llbitmap->mddev->reshape_backwards)
+		return bit_start < new->offset ? llbitmap_read(llbitmap, dst) :
+		       BitUnwritten;
+	return bit_end > new->end ? llbitmap_read(llbitmap, dst) : BitUnwritten;
+}
+
+static void llbitmap_reshape_dst_range(struct llbitmap *llbitmap,
+				       unsigned long dst,
+				       const struct llbitmap_reshape_range *new,
+				       struct llbitmap_reshape_range *dst_range)
+{
+	sector_t dst_bit_start = (sector_t)dst * llbitmap->reshape_chunksize;
+
+	dst_range->start = max(dst_bit_start, new->offset);
+	dst_range->end = min(dst_bit_start + llbitmap->reshape_chunksize,
+			     new->end);
+	dst_range->offset = dst_range->start;
+	dst_range->sectors = dst_range->end - dst_range->start;
+}
+
+static void llbitmap_reshape_map_range(struct llbitmap *llbitmap,
+				       sector_t lo, sector_t hi,
+				       bool previous,
+				       struct llbitmap_reshape_range *range)
+{
+	range->offset = lo;
+	range->sectors = hi - lo;
+	llbitmap_map_layout(llbitmap, &range->offset, &range->sectors, previous);
+	range->start = range->offset;
+	range->end = range->offset + range->sectors;
+}
+
+static bool llbitmap_reshape_src_range(const struct llbitmap_reshape_range *old,
+				       const struct llbitmap_reshape_range *new,
+				       const struct llbitmap_reshape_range *dst,
+				       struct llbitmap_reshape_range *src)
+{
+	if (!old->sectors)
+		return false;
+
+	src->start = old->offset +
+		mul_u64_u64_div_u64(dst->start - new->offset,
+				    old->sectors, new->sectors);
+	src->end = old->offset +
+		mul_u64_u64_div_u64_roundup(dst->end - new->offset,
+					    old->sectors, new->sectors);
+	if (src->end > old->end)
+		src->end = old->end;
+	src->offset = src->start;
+	src->sectors = src->end - src->start;
+
+	return src->sectors;
+}
+
+static enum llbitmap_state llbitmap_rmerge_src(struct llbitmap *llbitmap,
+					       enum llbitmap_state state,
+					       const struct llbitmap_reshape_range *src)
+{
+	unsigned long bit = div64_u64(src->start, llbitmap->chunksize);
+	unsigned long end = div64_u64(src->end - 1, llbitmap->chunksize);
+
+	while (bit <= end) {
+		enum llbitmap_state src_state = llbitmap_read(llbitmap, bit);
+
+		state = llbitmap_rmerge_state(llbitmap, state, src_state);
+		bit++;
+	}
+
+	return state;
+}
+
+static void llbitmap_reshape_merge(struct llbitmap *llbitmap,
+				   const struct llbitmap_reshape_range *old,
+				   const struct llbitmap_reshape_range *new)
+{
+	unsigned long dst_start;
+	unsigned long dst_end;
+	unsigned long dst;
+
+	if (!new->sectors)
+		return;
+
+	dst_start = div64_u64(new->offset, llbitmap->reshape_chunksize);
+	dst_end = div64_u64(new->end - 1, llbitmap->reshape_chunksize);
+
+	for (dst = dst_start; dst <= dst_end; dst++) {
+		struct llbitmap_reshape_range dst_range;
+		struct llbitmap_reshape_range src;
+		enum llbitmap_state state;
+
+		llbitmap_reshape_dst_range(llbitmap, dst, new, &dst_range);
+		state = llbitmap_reshape_init_dst(llbitmap, dst, new);
+		if (llbitmap_reshape_src_range(old, new, &dst_range, &src))
+			state = llbitmap_rmerge_src(llbitmap, state, &src);
+		else
+			state = llbitmap_rmerge_state(llbitmap, state, BitUnwritten);
+		llbitmap_write(llbitmap, state, dst);
+	}
+}
+
 static void llbitmap_reshape_finish(struct mddev *mddev)
 {
 	struct llbitmap *llbitmap = mddev->bitmap;
@@ -1680,6 +1829,28 @@ static void llbitmap_reshape_finish(struct mddev *mddev)
 		mddev->pers->quiesce(mddev, 0);
 }
 
+static void llbitmap_reshape_mark(struct mddev *mddev, sector_t old_pos,
+				  sector_t new_pos)
+{
+	struct llbitmap *llbitmap = mddev->bitmap;
+	sector_t lo;
+	sector_t hi;
+	struct llbitmap_reshape_range old;
+	struct llbitmap_reshape_range new;
+
+	if (!llbitmap || old_pos == new_pos)
+		return;
+
+	lo = min(old_pos, new_pos);
+	hi = max(old_pos, new_pos);
+	if (!hi)
+		return;
+
+	llbitmap_reshape_map_range(llbitmap, lo, hi, true, &old);
+	llbitmap_reshape_map_range(llbitmap, lo, hi, false, &new);
+	llbitmap_reshape_merge(llbitmap, &old, &new);
+}
+
 static void llbitmap_write_sb(struct llbitmap *llbitmap)
 {
 	int nr_blocks = DIV_ROUND_UP(BITMAP_DATA_OFFSET, llbitmap->io_size);
@@ -1937,6 +2108,7 @@ static struct bitmap_operations llbitmap_ops = {
 	.prepare_range		= llbitmap_prepare_range,
 	.reshape_finish		= llbitmap_reshape_finish,
 	.reshape_can_start	= llbitmap_reshape_can_start,
+	.reshape_mark		= llbitmap_reshape_mark,
 	.write_all		= llbitmap_write_all,
 
 	.group			= &md_llbitmap_group,
-- 
2.51.0

