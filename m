Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53F154CA298;
	Thu, 23 Jul 2026 13:55:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784814964; cv=none; b=C8zZS23owlcq47NfjscfK7TYj8niSMnq7zyboRP1jxpP/Rjxold95bP4wED2l5/1qEMz1JBZBUnY9rpwjuQ8I93avUJF/xlVd2q/4Ccvut33/ZMjlErwfMM6Za0h/+kNo1aDZIdqVUCHwoqShILaAhyZq/FtNoBIJxlLttwO4LE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784814964; c=relaxed/simple;
	bh=gTrhvfy0oDbzYdmL6jYNJkTvn25z5kMd/4693uGNvr0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=U3BkmKVxPa+W7qUIrjTM1DrRjVxSPBxULkVM7IplkOQ7EFG5JsK5zIWIK+60MrW1v7VlyrRXxcne35dFiSh7SJ1vZmWLpBuQyZaeVhneNJHaWlYDGVu5C9KVIXi4OaJnjpVpSv/BMN4HJjd3xs1/w8mW6pJqfonKNPMb6NInM44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=P6I/0M80; arc=none smtp.client-ip=115.124.30.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="P6I/0M80"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1784814948; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=qKokoOcqtowGURSpXXhr3eJRP2q6VSeGKv/KxkaOO84=;
	b=P6I/0M80N72+A2f8AZH7yompEd6Cjl7H/TkQWNrM/NSgPviMPDUPw1k1s5D8R6R9Bs0yc86gCHv6864zTnnHzk0MpVbKMcf5DT/80Zxgw3ZldIZ7dM1PG0rFNy2RWaP8Q8aVSM69qJGyX6D7LTw+/UJI98jSGW/hQ5C46B5unPs=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=yunye.zhao@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0X7gKXce_1784814946;
Received: from j66c13357.sqa.eu95.tbsite.net(mailfrom:yunye.zhao@linux.alibaba.com fp:SMTPD_---0X7gKXce_1784814946 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 23 Jul 2026 21:55:47 +0800
From: Yunye Zhao <yunye.zhao@linux.alibaba.com>
To: Song Liu <song@kernel.org>,
	Yu Kuai <yukuai@fygo.io>
Cc: Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yunye Zhao <yunye.zhao@linux.alibaba.com>
Subject: [PATCH v2 3/3] md/raid10: skip clean regions in bulk during recovery
Date: Thu, 23 Jul 2026 21:55:35 +0800
Message-Id: <20260723135535.101995-4-yunye.zhao@linux.alibaba.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20260723135535.101995-1-yunye.zhao@linux.alibaba.com>
References: <20260717062743.128189-1-yunye.zhao@linux.alibaba.com>
 <20260723135535.101995-1-yunye.zhao@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

During recovery of a degraded RAID10 with a mostly-clean bitmap, the
"everything skipped" path (biolist == NULL) returns max_sync == 128
sectors, even though md_bitmap_start_sync() already reported a much
larger clean range (an unallocated bitmap page spans 2^31 sectors with
a 512M bitmap chunk).  On the reported 2^40-sector array md_do_sync()
then crawls through 2^33 no-op iterations, burning a CPU for the whole
sweep; the cond_resched() in md_do_sync()'s skip path only stops the
watchdog firing.

The skip path cannot simply return sync_blocks: sync_blocks is measured
in array sectors while the return value advances the per-device recovery
cursor, and the two spaces differ by the raid10 layout.  For a near
layout (far_copies == 1 && !far_offset) the mapping is linear with slope
raid_disks / near_copies; when near_copies evenly divides raid_disks the
conversion is exact.  Track the minimum clean span across the skipped
devices, convert it to device sectors and skip it in one step.
far/offset layouts are not a linear scale and keep the previous
behaviour.

Only devices skipped as clean feed that minimum, and the skip is
suppressed when a device needed rebuilding but had no readable source
(missing_source), so the cursor never jumps past sectors that still
need recovery.

The generic bitmap skip_sync_blocks() path cannot be used here: it does
not see mrdev/mreplace (the recovery target and its replacement), and
replacement targets must rebuild even bitmap-clean chunks.

On a mostly-clean array with 8T per device (near=2, 4 disks) the
recovery sweep drops from 37.2s of CPU spinning to about 10ms.

Signed-off-by: Yunye Zhao <yunye.zhao@linux.alibaba.com>
---
 drivers/md/raid10.c | 46 ++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 43 insertions(+), 3 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 54cddb3a98cd..8acbd5ef618b 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -3176,6 +3176,9 @@ static sector_t raid10_sync_request(struct mddev *mddev, sector_t sector_nr,
 	int i;
 	int max_sync;
 	sector_t sync_blocks;
+	sector_t min_sync_blocks = MaxSector;
+	sector_t sync_end;
+	bool missing_source = false;
 	sector_t chunk_mask = conf->geo.chunk_mask;
 	int page_idx = 0;
 
@@ -3258,6 +3261,14 @@ static sector_t raid10_sync_request(struct mddev *mddev, sector_t sector_nr,
 	if (max_sector > mddev->resync_max)
 		max_sector = mddev->resync_max; /* Don't do IO beyond here */
 
+	/*
+	 * The chunk clamp below caps a single sync I/O to at most one chunk.
+	 * The bitmap-clean recovery skip issues no I/O, so remember the real
+	 * end here to bound the skip against it rather than the chunk
+	 * boundary.
+	 */
+	sync_end = max_sector;
+
 	/* make sure whole request will fit in a chunk - if chunks
 	 * are meaningful
 	 */
@@ -3334,9 +3345,13 @@ static sector_t raid10_sync_request(struct mddev *mddev, sector_t sector_nr,
 			if (!must_sync &&
 			    mreplace == NULL &&
 			    !conf->fullsync) {
-				/* yep, skip the sync_blocks here, but don't assume
-				 * that there will never be anything to do here
+				/* Skip the clean sync_blocks here; don't
+				 * assume there will never be anything to
+				 * do.  Only a genuinely skipped clean span
+				 * may widen the bulk skip below.
 				 */
+				if (sync_blocks < min_sync_blocks)
+					min_sync_blocks = sync_blocks;
 				continue;
 			}
 			if (mrdev)
@@ -3459,6 +3474,7 @@ static sector_t raid10_sync_request(struct mddev *mddev, sector_t sector_nr,
 			if (j == conf->copies) {
 				/* Cannot recover, so abort the recovery or
 				 * record a bad block */
+				missing_source = true;
 				if (any_working) {
 					/* problem is that there are bad blocks
 					 * on other device(s)
@@ -3514,6 +3530,8 @@ static sector_t raid10_sync_request(struct mddev *mddev, sector_t sector_nr,
 			}
 		}
 		if (biolist == NULL) {
+			sector_t skip_sectors = max_sync;
+
 			while (r10_bio) {
 				struct r10bio *rb2 = r10_bio;
 				r10_bio = (struct r10bio*) rb2->master_bio;
@@ -3521,7 +3539,29 @@ static sector_t raid10_sync_request(struct mddev *mddev, sector_t sector_nr,
 				put_buf(rb2);
 			}
 			*skipped = 1;
-			return max_sync;
+
+			/*
+			 * min_sync_blocks is in array sectors, but the return
+			 * value advances the per-device cursor; for a near
+			 * layout the two spaces differ by the factor
+			 * raid_disks / near_copies.
+			 */
+			if (!missing_source &&
+			    conf->geo.far_copies == 1 && !conf->geo.far_offset &&
+			    conf->geo.raid_disks % conf->geo.near_copies == 0 &&
+			    min_sync_blocks != MaxSector) {
+				sector_t clean_sectors = min_sync_blocks;
+
+				clean_sectors *= conf->geo.near_copies;
+				sector_div(clean_sectors, conf->geo.raid_disks);
+				clean_sectors &= ~chunk_mask;
+				if (clean_sectors > sync_end - sector_nr)
+					clean_sectors = sync_end - sector_nr;
+				if (clean_sectors > skip_sectors)
+					skip_sectors = clean_sectors;
+			}
+
+			return skip_sectors;
 		}
 	} else {
 		/* resync. Schedule a read for every block at this virt offset */
-- 
2.19.1.6.gb485710b

