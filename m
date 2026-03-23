Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E7391D7E5C
	for <linux-raid@vger.kernel.org>; Mon, 23 Mar 2026 05:47:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774244821; cv=none; b=qxyUU/+pw9QN3yjQSMlinfvsHQysfLDwsMdNAWSEcRg32Ym2WgBgoI3CVahj0y+C26xrERIEx+6toCaHy4wX9UunLg+CazgR1jMy42uJADgojyMteogbQWXRFI2mPeeozj8WD6GEXgJYXmcDdGq8vB+9Jm6XdVjLZXfy933cE7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774244821; c=relaxed/simple;
	bh=l+5Z+fUw7PUoFP9D8MLGsf2ZbZjSR8dp0rosX/92RcY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t3SwfSh8SA3bwViINWCuYbIOFVWvKQq8eiOsH4fpqixJEOZcC1Kv+dJVY1C7DusbJ8ZrEwifdHK5lQZ3iMjwQav8HbRy6jZGbBHn2mHZ/J4rkSfv5Rsy1XcGbf7882fyCvTcGRITNbOHBG4xDqWBMkldnU+sxbjO/2Rg72t+wdQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB001C4CEF7;
	Mon, 23 Mar 2026 05:46:58 +0000 (UTC)
From: Yu Kuai <yukuai@fnnas.com>
To: linux-raid@vger.kernel.org,
	song@kernel.org
Cc: linan122@huawei.com,
	xni@redhat.com
Subject: [PATCH v3 2/3] md/md-llbitmap: add CleanUnwritten state for RAID-5 proactive parity building
Date: Mon, 23 Mar 2026 13:46:43 +0800
Message-ID: <20260323054644.3351791-3-yukuai@fnnas.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260323054644.3351791-1-yukuai@fnnas.com>
References: <20260323054644.3351791-1-yukuai@fnnas.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add new states to the llbitmap state machine to support proactive XOR
parity building for RAID-5 arrays. This allows users to pre-build parity
data for unwritten regions before any user data is written.

New states added:
- BitNeedSyncUnwritten: Transitional state when proactive sync is triggered
  via sysfs on Unwritten regions.
- BitSyncingUnwritten: Proactive sync in progress for unwritten region.
- BitCleanUnwritten: XOR parity has been pre-built, but no user data
  written yet. When user writes to this region, it transitions to BitDirty.

New actions added:
- BitmapActionProactiveSync: Trigger for proactive XOR parity building.
- BitmapActionClearUnwritten: Convert CleanUnwritten/NeedSyncUnwritten/
  SyncingUnwritten states back to Unwritten before recovery starts.

State flows:
- Current (lazy): Unwritten -> (write) -> NeedSync -> (sync) -> Dirty -> Clean
- New (proactive): Unwritten -> (sysfs) -> NeedSyncUnwritten -> (sync) -> CleanUnwritten
- On write to CleanUnwritten: CleanUnwritten -> (write) -> Dirty -> Clean
- On disk replacement: CleanUnwritten regions are converted to Unwritten
  before recovery starts, so recovery only rebuilds regions with user data

A new sysfs interface is added at /sys/block/mdX/md/llbitmap/proactive_sync
(write-only) to trigger proactive sync. This only works for RAID-456 arrays.

Signed-off-by: Yu Kuai <yukuai@fnnas.com>
---
 drivers/md/md-llbitmap.c | 140 +++++++++++++++++++++++++++++++++++----
 1 file changed, 128 insertions(+), 12 deletions(-)

diff --git a/drivers/md/md-llbitmap.c b/drivers/md/md-llbitmap.c
index cdfecaca216b..f10374242c9a 100644
--- a/drivers/md/md-llbitmap.c
+++ b/drivers/md/md-llbitmap.c
@@ -208,6 +208,20 @@ enum llbitmap_state {
 	BitNeedSync,
 	/* data is synchronizing */
 	BitSyncing,
+	/*
+	 * Proactive sync requested for unwritten region (raid456 only).
+	 * Triggered via sysfs when user wants to pre-build XOR parity
+	 * for regions that have never been written.
+	 */
+	BitNeedSyncUnwritten,
+	/* Proactive sync in progress for unwritten region */
+	BitSyncingUnwritten,
+	/*
+	 * XOR parity has been pre-built for a region that has never had
+	 * user data written. When user writes to this region, it transitions
+	 * to BitDirty.
+	 */
+	BitCleanUnwritten,
 	BitStateCount,
 	BitNone = 0xff,
 };
@@ -232,6 +246,12 @@ enum llbitmap_action {
 	 * BitNeedSync.
 	 */
 	BitmapActionStale,
+	/*
+	 * Proactive sync trigger for raid456 - builds XOR parity for
+	 * Unwritten regions without requiring user data write first.
+	 */
+	BitmapActionProactiveSync,
+	BitmapActionClearUnwritten,
 	BitmapActionCount,
 	/* Init state is BitUnwritten */
 	BitmapActionInit,
@@ -304,6 +324,8 @@ static char state_machine[BitStateCount][BitmapActionCount] = {
 		[BitmapActionDaemon]		= BitNone,
 		[BitmapActionDiscard]		= BitNone,
 		[BitmapActionStale]		= BitNone,
+		[BitmapActionProactiveSync]	= BitNeedSyncUnwritten,
+		[BitmapActionClearUnwritten]	= BitNone,
 	},
 	[BitClean] = {
 		[BitmapActionStartwrite]	= BitDirty,
@@ -314,6 +336,8 @@ static char state_machine[BitStateCount][BitmapActionCount] = {
 		[BitmapActionDaemon]		= BitNone,
 		[BitmapActionDiscard]		= BitUnwritten,
 		[BitmapActionStale]		= BitNeedSync,
+		[BitmapActionProactiveSync]	= BitNone,
+		[BitmapActionClearUnwritten]	= BitNone,
 	},
 	[BitDirty] = {
 		[BitmapActionStartwrite]	= BitNone,
@@ -324,6 +348,8 @@ static char state_machine[BitStateCount][BitmapActionCount] = {
 		[BitmapActionDaemon]		= BitClean,
 		[BitmapActionDiscard]		= BitUnwritten,
 		[BitmapActionStale]		= BitNeedSync,
+		[BitmapActionProactiveSync]	= BitNone,
+		[BitmapActionClearUnwritten]	= BitNone,
 	},
 	[BitNeedSync] = {
 		[BitmapActionStartwrite]	= BitNone,
@@ -334,6 +360,8 @@ static char state_machine[BitStateCount][BitmapActionCount] = {
 		[BitmapActionDaemon]		= BitNone,
 		[BitmapActionDiscard]		= BitUnwritten,
 		[BitmapActionStale]		= BitNone,
+		[BitmapActionProactiveSync]	= BitNone,
+		[BitmapActionClearUnwritten]	= BitNone,
 	},
 	[BitSyncing] = {
 		[BitmapActionStartwrite]	= BitNone,
@@ -344,6 +372,44 @@ static char state_machine[BitStateCount][BitmapActionCount] = {
 		[BitmapActionDaemon]		= BitNone,
 		[BitmapActionDiscard]		= BitUnwritten,
 		[BitmapActionStale]		= BitNeedSync,
+		[BitmapActionProactiveSync]	= BitNone,
+		[BitmapActionClearUnwritten]	= BitNone,
+	},
+	[BitNeedSyncUnwritten] = {
+		[BitmapActionStartwrite]	= BitNeedSync,
+		[BitmapActionStartsync]		= BitSyncingUnwritten,
+		[BitmapActionEndsync]		= BitNone,
+		[BitmapActionAbortsync]		= BitUnwritten,
+		[BitmapActionReload]		= BitUnwritten,
+		[BitmapActionDaemon]		= BitNone,
+		[BitmapActionDiscard]		= BitUnwritten,
+		[BitmapActionStale]		= BitUnwritten,
+		[BitmapActionProactiveSync]	= BitNone,
+		[BitmapActionClearUnwritten]	= BitUnwritten,
+	},
+	[BitSyncingUnwritten] = {
+		[BitmapActionStartwrite]	= BitSyncing,
+		[BitmapActionStartsync]		= BitSyncingUnwritten,
+		[BitmapActionEndsync]		= BitCleanUnwritten,
+		[BitmapActionAbortsync]		= BitUnwritten,
+		[BitmapActionReload]		= BitUnwritten,
+		[BitmapActionDaemon]		= BitNone,
+		[BitmapActionDiscard]		= BitUnwritten,
+		[BitmapActionStale]		= BitUnwritten,
+		[BitmapActionProactiveSync]	= BitNone,
+		[BitmapActionClearUnwritten]	= BitUnwritten,
+	},
+	[BitCleanUnwritten] = {
+		[BitmapActionStartwrite]	= BitDirty,
+		[BitmapActionStartsync]		= BitNone,
+		[BitmapActionEndsync]		= BitNone,
+		[BitmapActionAbortsync]		= BitNone,
+		[BitmapActionReload]		= BitNone,
+		[BitmapActionDaemon]		= BitNone,
+		[BitmapActionDiscard]		= BitUnwritten,
+		[BitmapActionStale]		= BitUnwritten,
+		[BitmapActionProactiveSync]	= BitNone,
+		[BitmapActionClearUnwritten]	= BitUnwritten,
 	},
 };
 
@@ -376,6 +442,7 @@ static void llbitmap_infect_dirty_bits(struct llbitmap *llbitmap,
 			pctl->state[pos] = level_456 ? BitNeedSync : BitDirty;
 			break;
 		case BitClean:
+		case BitCleanUnwritten:
 			pctl->state[pos] = BitDirty;
 			break;
 		}
@@ -383,7 +450,7 @@ static void llbitmap_infect_dirty_bits(struct llbitmap *llbitmap,
 }
 
 static void llbitmap_set_page_dirty(struct llbitmap *llbitmap, int idx,
-				    int offset)
+				    int offset, bool infect)
 {
 	struct llbitmap_page_ctl *pctl = llbitmap->pctl[idx];
 	unsigned int io_size = llbitmap->io_size;
@@ -398,7 +465,7 @@ static void llbitmap_set_page_dirty(struct llbitmap *llbitmap, int idx,
 	 * resync all the dirty bits, hence skip infect new dirty bits to
 	 * prevent resync unnecessary data.
 	 */
-	if (llbitmap->mddev->degraded) {
+	if (llbitmap->mddev->degraded || !infect) {
 		set_bit(block, pctl->dirty);
 		return;
 	}
@@ -438,7 +505,9 @@ static void llbitmap_write(struct llbitmap *llbitmap, enum llbitmap_state state,
 
 	llbitmap->pctl[idx]->state[bit] = state;
 	if (state == BitDirty || state == BitNeedSync)
-		llbitmap_set_page_dirty(llbitmap, idx, bit);
+		llbitmap_set_page_dirty(llbitmap, idx, bit, true);
+	else if (state == BitNeedSyncUnwritten)
+		llbitmap_set_page_dirty(llbitmap, idx, bit, false);
 }
 
 static struct page *llbitmap_read_page(struct llbitmap *llbitmap, int idx)
@@ -627,11 +696,10 @@ static enum llbitmap_state llbitmap_state_machine(struct llbitmap *llbitmap,
 			goto write_bitmap;
 		}
 
-		if (c == BitNeedSync)
+		if (c == BitNeedSync || c == BitNeedSyncUnwritten)
 			need_resync = !mddev->degraded;
 
 		state = state_machine[c][action];
-
 write_bitmap:
 		if (unlikely(mddev->degraded)) {
 			/* For degraded array, mark new data as need sync. */
@@ -658,8 +726,7 @@ static enum llbitmap_state llbitmap_state_machine(struct llbitmap *llbitmap,
 		}
 
 		llbitmap_write(llbitmap, state, start);
-
-		if (state == BitNeedSync)
+		if (state == BitNeedSync || state == BitNeedSyncUnwritten)
 			need_resync = !mddev->degraded;
 		else if (state == BitDirty &&
 			 !timer_pending(&llbitmap->pending_timer))
@@ -1229,7 +1296,7 @@ static bool llbitmap_blocks_synced(struct mddev *mddev, sector_t offset)
 	unsigned long p = offset >> llbitmap->chunkshift;
 	enum llbitmap_state c = llbitmap_read(llbitmap, p);
 
-	return c == BitClean || c == BitDirty;
+	return c == BitClean || c == BitDirty || c == BitCleanUnwritten;
 }
 
 static sector_t llbitmap_skip_sync_blocks(struct mddev *mddev, sector_t offset)
@@ -1243,6 +1310,10 @@ static sector_t llbitmap_skip_sync_blocks(struct mddev *mddev, sector_t offset)
 	if (c == BitUnwritten)
 		return blocks;
 
+	/* Skip CleanUnwritten - no user data, will be reset after recovery */
+	if (c == BitCleanUnwritten)
+		return blocks;
+
 	/* For degraded array, don't skip */
 	if (mddev->degraded)
 		return 0;
@@ -1261,14 +1332,25 @@ static bool llbitmap_start_sync(struct mddev *mddev, sector_t offset,
 {
 	struct llbitmap *llbitmap = mddev->bitmap;
 	unsigned long p = offset >> llbitmap->chunkshift;
+	enum llbitmap_state state;
+
+	/*
+	 * Before recovery starts, convert CleanUnwritten to Unwritten.
+	 * This ensures the new disk won't have stale parity data.
+	 */
+	if (offset == 0 && test_bit(MD_RECOVERY_RECOVER, &mddev->recovery) &&
+	    !test_bit(MD_RECOVERY_LAZY_RECOVER, &mddev->recovery))
+		llbitmap_state_machine(llbitmap, 0, llbitmap->chunks - 1,
+				       BitmapActionClearUnwritten);
+
 
 	/*
 	 * Handle one bit at a time, this is much simpler. And it doesn't matter
 	 * if md_do_sync() loop more times.
 	 */
 	*blocks = llbitmap->chunksize - (offset & (llbitmap->chunksize - 1));
-	return llbitmap_state_machine(llbitmap, p, p,
-				      BitmapActionStartsync) == BitSyncing;
+	state = llbitmap_state_machine(llbitmap, p, p, BitmapActionStartsync);
+	return state == BitSyncing || state == BitSyncingUnwritten;
 }
 
 /* Something is wrong, sync_thread stop at @offset */
@@ -1474,9 +1556,15 @@ static ssize_t bits_show(struct mddev *mddev, char *page)
 	}
 
 	mutex_unlock(&mddev->bitmap_info.mutex);
-	return sprintf(page, "unwritten %d\nclean %d\ndirty %d\nneed sync %d\nsyncing %d\n",
+	return sprintf(page,
+		       "unwritten %d\nclean %d\ndirty %d\n"
+		       "need sync %d\nsyncing %d\n"
+		       "need sync unwritten %d\nsyncing unwritten %d\n"
+		       "clean unwritten %d\n",
 		       bits[BitUnwritten], bits[BitClean], bits[BitDirty],
-		       bits[BitNeedSync], bits[BitSyncing]);
+		       bits[BitNeedSync], bits[BitSyncing],
+		       bits[BitNeedSyncUnwritten], bits[BitSyncingUnwritten],
+		       bits[BitCleanUnwritten]);
 }
 
 static struct md_sysfs_entry llbitmap_bits = __ATTR_RO(bits);
@@ -1549,11 +1637,39 @@ barrier_idle_store(struct mddev *mddev, const char *buf, size_t len)
 
 static struct md_sysfs_entry llbitmap_barrier_idle = __ATTR_RW(barrier_idle);
 
+static ssize_t
+proactive_sync_store(struct mddev *mddev, const char *buf, size_t len)
+{
+	struct llbitmap *llbitmap;
+
+	/* Only for RAID-456 */
+	if (!raid_is_456(mddev))
+		return -EINVAL;
+
+	mutex_lock(&mddev->bitmap_info.mutex);
+	llbitmap = mddev->bitmap;
+	if (!llbitmap || !llbitmap->pctl) {
+		mutex_unlock(&mddev->bitmap_info.mutex);
+		return -ENODEV;
+	}
+
+	/* Trigger proactive sync on all Unwritten regions */
+	llbitmap_state_machine(llbitmap, 0, llbitmap->chunks - 1,
+			       BitmapActionProactiveSync);
+
+	mutex_unlock(&mddev->bitmap_info.mutex);
+	return len;
+}
+
+static struct md_sysfs_entry llbitmap_proactive_sync =
+	__ATTR(proactive_sync, 0200, NULL, proactive_sync_store);
+
 static struct attribute *md_llbitmap_attrs[] = {
 	&llbitmap_bits.attr,
 	&llbitmap_metadata.attr,
 	&llbitmap_daemon_sleep.attr,
 	&llbitmap_barrier_idle.attr,
+	&llbitmap_proactive_sync.attr,
 	NULL
 };
 
-- 
2.51.0

