Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22844301493;
	Sun,  2 Aug 2026 19:52:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785700325; cv=none; b=rqaZEDhe+u4Y3DKnwMrm6EMWUSJMfWUiIynmBw9kDy2k0wccTOctSTgnciwOZpdsCLesDqYQ+C+dBD7GhgzLQ3jFnGZKXFk57mNc74PZ9yS/sNnEqZSh0XowhNsziDpg5PEteX4zEjVIOnajFlh836BGFnqwANT1tcKXZc4xtQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785700325; c=relaxed/simple;
	bh=2r3nJFQqp61u7xrm4tG9zf7L0VoSb1TmaUnmejqzt5g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RLfakgDpMeYKm0hygXWCxeubaOb/vkr02PcJIRtvU+dMSYm7/zp69qSAYRpMpmCj222xI8HXL3T097szUyJF4MT4jQuqh4x7PBap+zrqBBq9GWuYtM6iblPkjSKU0ZGpIm0mnp/e+Kv58+r1g85ATQO2bumEu8RT18pFht16ZCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SLkeUvzr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SLkeUvzr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42DBB1F00A3A;
	Sun,  2 Aug 2026 19:51:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785700323;
	bh=MVKxX6QpcQmdufbJ1KcquOMcnU3H13Kg9e7iQIi+aMw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SLkeUvzr776Qdv/+HoJS+jC5MN1NmMB1Uf6SrYMC1Ei9BeekZpGT8mvNkwVliFpGy
	 oN3lB2DhiC83qSsKTrjzCwbzSK3p9Zll1+0k4P9YiJPf9DpBCtXaN3Ie2Rtuq6CXdp
	 9N3vqkptpe0jWHi2uQzqgwnseQXkn/ZHwFLotbzvuSeH2ItzJwlcPgiX65eXnSqW4y
	 9kRZ95ABqpvyR6Buux/yzgpfczygbwFuCf6TVO9a4UmwmyhR5EIGjUceoZ43KHisrM
	 hL3Akd7T4HA+orlAHv56ZhADm/kNoWQzYsurSeyXlsBdfQUvjqPkYFql4ZAN58Ru8m
	 337MhgUIPeKaA==
From: Yu Kuai <yukuai@kernel.org>
To: Song Liu <song@kernel.org>,
	Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>
Cc: Yu Kuai <yukuai@fygo.io>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Mykola Marzhan <mykola@meshstor.io>,
	Su Yue <glass.su@suse.com>
Subject: [PATCH v5 21/29] md/md-llbitmap: remap checkpointed bits as reshape progresses
Date: Mon,  3 Aug 2026 03:50:30 +0800
Message-ID: <20260802195038.164272-22-yukuai@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260802195038.164272-1-yukuai@kernel.org>
References: <20260802195038.164272-1-yukuai@kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Yu Kuai <yukuai@fygo.io>

Merge checkpointed old llbitmap state forward as reshape_position advances
and record the checkpoint remap through reshape_mark().

Normal write accounting can run while the reshape thread checkpoints a new
reshape position. llbitmap_reshape_mark() reads old state bytes, merges them
into destination bits, and writes the result back. If llbitmap_start_write()
or llbitmap_start_discard() updates the same state bytes at the same time,
the two read/modify/write paths can overwrite each other and lose the state
from one side.

Serialize only this state-byte race with a rwlock. Normal I/O takes the read
side around llbitmap_state_machine(), after page active references are raised,
so concurrent normal I/O updates still run in parallel. Reshape checkpointing
takes the write side only while merging the checkpointed range, avoiding page
suspension and avoiding a sleeping mutex in the I/O accounting path.

Tested-by: Mykola Marzhan <mykola@meshstor.io>
Signed-off-by: Yu Kuai <yukuai@fygo.io>
---
 drivers/md/md-llbitmap.c | 204 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 204 insertions(+)

diff --git a/drivers/md/md-llbitmap.c b/drivers/md/md-llbitmap.c
index a20e55fdf82b..5d95627ff983 100644
--- a/drivers/md/md-llbitmap.c
+++ b/drivers/md/md-llbitmap.c
@@ -302,6 +302,11 @@ struct llbitmap {
 	/* fires on first BitDirty state */
 	struct timer_list pending_timer;
 	struct work_struct daemon_work;
+	/*
+	 * Serialize reshape checkpoint remapping against normal I/O bitmap
+	 * updates without blocking concurrent I/O updates on each other.
+	 */
+	rwlock_t reshape_lock;
 
 	unsigned long flags;
 	__u64	events_cleared;
@@ -498,6 +503,14 @@ static void llbitmap_map_layout(struct llbitmap *llbitmap, sector_t *offset,
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
@@ -930,6 +943,33 @@ static int llbitmap_prepare_resize(struct llbitmap *llbitmap,
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
@@ -1306,6 +1346,7 @@ static void md_llbitmap_daemon_fn(struct work_struct *work)
 
 	if (llbitmap->mddev->degraded)
 		return;
+
 retry:
 	start = 0;
 	end = min(llbitmap->chunks, PAGE_SIZE - BITMAP_DATA_OFFSET) - 1;
@@ -1367,6 +1408,7 @@ static int llbitmap_create(struct mddev *mddev)
 
 	timer_setup(&llbitmap->pending_timer, llbitmap_pending_timer_fn, 0);
 	INIT_WORK(&llbitmap->daemon_work, md_llbitmap_daemon_fn);
+	rwlock_init(&llbitmap->reshape_lock);
 	atomic_set(&llbitmap->behind_writes, 0);
 	init_waitqueue_head(&llbitmap->behind_wait);
 
@@ -1535,7 +1577,9 @@ static void llbitmap_start_write(struct mddev *mddev, sector_t offset,
 		page_start++;
 	}
 
+	read_lock(&llbitmap->reshape_lock);
 	llbitmap_state_machine(llbitmap, start, end, BitmapActionStartwrite);
+	read_unlock(&llbitmap->reshape_lock);
 }
 
 static void llbitmap_end_write(struct mddev *mddev, sector_t offset,
@@ -1567,7 +1611,9 @@ static void llbitmap_start_discard(struct mddev *mddev, sector_t offset,
 		page_start++;
 	}
 
+	read_lock(&llbitmap->reshape_lock);
 	llbitmap_state_machine(llbitmap, start, end, BitmapActionDiscard);
+	read_unlock(&llbitmap->reshape_lock);
 }
 
 static void llbitmap_end_discard(struct mddev *mddev, sector_t offset,
@@ -1864,6 +1910,136 @@ static int llbitmap_reshape_can_start(struct mddev *mddev)
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
+	bool backwards = false;
+
+	if (!new->sectors)
+		return;
+
+	dst_start = div64_u64(new->offset, llbitmap->reshape_chunksize);
+	dst_end = div64_u64(new->end - 1, llbitmap->reshape_chunksize);
+	if (old->sectors) {
+		unsigned long src_start = div64_u64(old->offset,
+						    llbitmap->chunksize);
+		unsigned long src_end = div64_u64(old->end - 1,
+						  llbitmap->chunksize);
+
+		backwards = src_start < dst_start && src_end >= dst_start;
+	}
+
+	dst = backwards ? dst_end : dst_start;
+	while (true) {
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
+		if (dst == (backwards ? dst_start : dst_end))
+			break;
+		if (backwards)
+			dst--;
+		else
+			dst++;
+	}
+}
+
 static void llbitmap_reshape_finish(struct mddev *mddev)
 {
 	struct llbitmap *llbitmap = mddev->bitmap;
@@ -1888,6 +2064,33 @@ static void llbitmap_reshape_finish(struct mddev *mddev)
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
+	if (!new.sectors)
+		return;
+
+	write_lock(&llbitmap->reshape_lock);
+	llbitmap_reshape_merge(llbitmap, &old, &new);
+	write_unlock(&llbitmap->reshape_lock);
+}
+
 static void llbitmap_write_sb(struct llbitmap *llbitmap)
 {
 	int nr_blocks = DIV_ROUND_UP(BITMAP_DATA_OFFSET, llbitmap->io_size);
@@ -2181,6 +2384,7 @@ static struct bitmap_operations llbitmap_ops = {
 	.prepare_range		= llbitmap_prepare_range,
 	.reshape_finish		= llbitmap_reshape_finish,
 	.reshape_can_start	= llbitmap_reshape_can_start,
+	.reshape_mark		= llbitmap_reshape_mark,
 	.write_all		= llbitmap_write_all,
 
 	.groups			= md_llbitmap_groups,
-- 
2.51.0

