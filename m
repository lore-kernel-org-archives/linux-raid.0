Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E537638C406;
	Wed, 24 Jun 2026 06:42:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782283375; cv=none; b=KObsmzLs6OocKNv0R/jkk3ph8FwgHSswiOaG/994Ll/n+h1oSB2bpIrkFfivbVxvzHyuaPFr5JgZ7cIJ+CP1wWn4N0FwW4runse7uL9rCwwSH04c1qI6GsRfUuMW8m9d+9ceilFlVZL1L7sDKcRmRDiZfn4TEvQJLWIvEmGAweY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782283375; c=relaxed/simple;
	bh=jQcMGZcUKShFl6h8WbIweyrIvwWOH1bpMCVHRr0juD8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ITPxfMbYwa3WFf7WcxfCdeFcU4j0Xql8R6ScYwh5BD2f8Rd5+wtSuee00xAG0O3YRUbBTcK/9TSYLUZhA5Hk0n8CuGQiLyqkd2UhIJyKqPr2jsa9CucWHVhjaT4Vopttjp1Zb9ssL+SJbp20x03h7+OcgAwNmhxQ9rbwS+HgTgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=htNIc6hv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="htNIc6hv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89ABE1F000E9;
	Wed, 24 Jun 2026 06:42:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782283373;
	bh=DvO86YJtkbNJPuU6My4qT5Z5uvZEhi+jioXn7PJ5GyQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=htNIc6hvgpDYJFDyz010BQc51+05s25yLiG1Z4uH/zd9Z5G2j4jCcEdNDjtNhbQpj
	 vdE1uaR78CwULvT4y7E7HU9giOcGQE+yGWy74dOyXmxAOZb1RyWXhnUD1SVmqs+xz8
	 MLYRfirnQHcmUuwQwHj7elPv9STBhE7fMijNSc878v/SCOf2A+XtoqizgOGHYaZ5sk
	 7dFKBWrrt/KPkMB2oTVfZ+/88ZH90Aqx4LkvEwGXHbXSxpn5+ZzW+P3dWrgRlz8Npr
	 lLw1FYeoxluG9MIyB3+M4dSyQfOWT5uecu+T9aNwEwsnOZRFX8ytZTdkRUm2YCyhDI
	 DMkfQxeXSIDgg==
From: Yu Kuai <yukuai@kernel.org>
To: Song Liu <song@kernel.org>,
	Yu Kuai <yukuai@fygo.io>
Cc: Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	Su Yue <glass.su@suse.com>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 12/20] md/md-llbitmap: remap checkpointed bits as reshape progresses
Date: Wed, 24 Jun 2026 14:42:09 +0800
Message-ID: <8700112d660a7f9fa48d174ee9b395fbe309e7c9.1782282042.git.yukuai@kernel.org>
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

Merge checkpointed old llbitmap state forward as reshape_position
advances and record the checkpoint remap through reshape_mark().

Signed-off-by: Yu Kuai <yukuai@fygo.io>
---
 drivers/md/md-llbitmap.c | 172 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 172 insertions(+)

diff --git a/drivers/md/md-llbitmap.c b/drivers/md/md-llbitmap.c
index c62397743d9a..00b77ecd600b 100644
--- a/drivers/md/md-llbitmap.c
+++ b/drivers/md/md-llbitmap.c
@@ -502,6 +502,14 @@ static void llbitmap_map_layout(struct llbitmap *llbitmap, sector_t *offset,
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
@@ -906,6 +914,33 @@ static int llbitmap_prepare_resize(struct llbitmap *llbitmap,
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
 	struct mddev *mddev = llbitmap->mddev;
@@ -1799,6 +1834,120 @@ static int llbitmap_reshape_can_start(struct mddev *mddev)
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
@@ -1823,6 +1972,28 @@ static void llbitmap_reshape_finish(struct mddev *mddev)
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
@@ -2122,6 +2293,7 @@ static struct bitmap_operations llbitmap_ops = {
 	.prepare_range		= llbitmap_prepare_range,
 	.reshape_finish		= llbitmap_reshape_finish,
 	.reshape_can_start	= llbitmap_reshape_can_start,
+	.reshape_mark		= llbitmap_reshape_mark,
 	.write_all		= llbitmap_write_all,
 
 	.groups			= md_llbitmap_groups,
-- 
2.51.0

