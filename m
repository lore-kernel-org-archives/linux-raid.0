Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C80C41F35A;
	Tue, 28 Jul 2026 08:50:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785228630; cv=none; b=RDco+EFc9mwJJSxYI1qKEdj8mz96fPwRHOOavtbKIuvilwkGkaFBu+Pf64YzMWhzlmTXHz81cXsjvZ2y8TW5rnxNAAxYABNBDKk6zDsDhbWTGVL4/2OlO7jihXoL+Y+b5JpusF0uRc62M+/HTAFPA4V4x1f2VmwBLKSktKNRl/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785228630; c=relaxed/simple;
	bh=+qpsA6d6YvS2Fl6qE9ePTLawMK60HzHAtdHfRlOe6Zs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KNEtbx37YywrN+FrPHoz0ImbqNy/7+tHKimGB8zUaJ2oRiOwgKTmjkkP9LngIKeKkuCw6hqb+N4BykAEya1NSj9VdNVkvmAF7/RxRoTXwI/7R3qhTVAXOMq0/uGWpHIKynyjVzLYTnRVwJrtYgA7C8OY4P8XgIZKJUQxitgoHBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fWAdxW6f; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fWAdxW6f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5E0D1F00A3A;
	Tue, 28 Jul 2026 08:50:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785228629;
	bh=xvSIwKWeEhG/W0g4DWwcEHdtU6K+qyIh8rbtiAeSqyc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fWAdxW6fevobMdHHVfIOsl9lLKztL3pGlX4ULO4eLBA218wPPlHOghIgATXX+2w9d
	 30E5cl85UkTQXKMd9UBCZszlp7exjdv2thTrpkst+lI8DQU3XO7UhBfMrmzivzXxzd
	 IAMjhGnkyZJJtjkHYDhPIMY24EfvGrxkp3wE5NNvONNsWS2xSAM0uiD2AkPa19r3a5
	 7HFGTfVcUCo96snrYk+ftoMQCCimOS4IqpMFDjMTbxavJakQKnfw1XCt/3TV7xAZtO
	 XHlILWGsRDSfyJn+Xmv82It/4PGfoSlf8TS80nzZ2JdG/RdaQEsQajaLG2keUOeYvK
	 3KFW7gO/9w15A==
From: Yu Kuai <yukuai@kernel.org>
To: Song Liu <song@kernel.org>
Cc: Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	Mykola Marzhan <mykola@meshstor.io>,
	Su Yue <glass.su@suse.com>,
	yukuai@fygo.io,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 13/21] md/md-llbitmap: remap checkpointed bits as reshape progresses
Date: Tue, 28 Jul 2026 16:49:13 +0800
Message-ID: <64484cf5bfa58462d3c21d0a655901eaa7d9b573.1785206690.git.yukuai@fygo.io>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1785206690.git.yukuai@fygo.io>
References: <cover.1785206690.git.yukuai@fygo.io>
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
index bdc6ec8972f0..794ac0eaf437 100644
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
@@ -934,6 +942,33 @@ static int llbitmap_prepare_resize(struct llbitmap *llbitmap,
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
@@ -1839,6 +1874,120 @@ static int llbitmap_reshape_can_start(struct mddev *mddev)
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
@@ -1863,6 +2012,28 @@ static void llbitmap_reshape_finish(struct mddev *mddev)
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
@@ -2162,6 +2333,7 @@ static struct bitmap_operations llbitmap_ops = {
 	.prepare_range		= llbitmap_prepare_range,
 	.reshape_finish		= llbitmap_reshape_finish,
 	.reshape_can_start	= llbitmap_reshape_can_start,
+	.reshape_mark		= llbitmap_reshape_mark,
 	.write_all		= llbitmap_write_all,
 
 	.groups			= md_llbitmap_groups,
-- 
2.51.0

