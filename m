Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B001A30594E;
	Thu, 23 Jul 2026 13:55:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784814959; cv=none; b=E0XTsSzhsDZ6v2Jwj3ci+xgf/Um8iHPA/Axr2SX0/tv7B/bCHqBvzGClADDOzOfzXhk9x+ZE4vfY0rrWyjoWNMVt55idRjoZeetoXTiiYVX/dcC7IduwWOUVyq9Yq9NGgZH/Qar07ZuAx70idp/V1J5MbQyGv1K3miuuOBOzwPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784814959; c=relaxed/simple;
	bh=iEr4BLXvxJd0rgGS/Vh/Ku1MVUyT8DXHkOaQdund36M=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=FdHDMDVTDN/mTMjAsgcX+AvwC4cfG2VN82DLu6hc/ie/mo4/CFEVSSjlqlpydWQlGSMULNKfwUuYOciefAIF0WJNNWm1fjXPM/P0dkfz25QhXsQaMCkOpViEqPOrdsxbyCZpdSCIR5PnLGiJCPYTpW8DBMZr292tC8KMibAixLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=DcjA0Hpa; arc=none smtp.client-ip=115.124.30.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="DcjA0Hpa"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1784814941; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=GgOGexfi/0uFSL+tz1wlapBvJEfgJ323csXiypeaT6A=;
	b=DcjA0HpaK46Mf+mi/FOMvJlCKziERCplwzYqgS2HX4KXLPtiCkiBLC9W14zoG10s8vtcErLluhhk7LXcgUjaXRBOH9Ddf8HnedW62x6Z04IecGyxUINRTKYuERdogJIt02F8gcJyve1++IV5bjbSRh7IQmXxmCUSiAGkU9vrLwQ=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R441e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=yunye.zhao@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0X7gKXaq_1784814940;
Received: from j66c13357.sqa.eu95.tbsite.net(mailfrom:yunye.zhao@linux.alibaba.com fp:SMTPD_---0X7gKXaq_1784814940 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 23 Jul 2026 21:55:40 +0800
From: Yunye Zhao <yunye.zhao@linux.alibaba.com>
To: Song Liu <song@kernel.org>,
	Yu Kuai <yukuai@fygo.io>
Cc: Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yunye Zhao <yunye.zhao@linux.alibaba.com>
Subject: [PATCH v2 0/3] md/raid10: fix recovery corruption and soft lockup on large arrays
Date: Thu, 23 Jul 2026 21:55:32 +0800
Message-Id: <20260723135535.101995-1-yunye.zhao@linux.alibaba.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20260717062743.128189-1-yunye.zhao@linux.alibaba.com>
References: <20260717062743.128189-1-yunye.zhao@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series fixes two independent problems in raid10 recovery, plus a
safety net in md core.

Problem 1: silent data corruption when recovering with more than one
mirror missing.

Commit fe6a19d40ceb ("md/md-bitmap: merge md_bitmap_start_sync() into
bitmap_operations") inverted still_degraded in raid10_sync_request()
(int 1 -> bool false; the raid1 side of the same conversion is correct).
Recovering one disk while another is still missing therefore clears
bitmap bits the missing disk still needs; after its re-add the dirty
regions are skipped and the disk is marked In_sync with stale data.
Patch 1 restores the correct value.

Problem 2: soft lockup / CPU burn on recovery of a large sparse array
(the original report behind v1).

Recovering a degraded RAID10 with a mostly-clean bitmap makes
raid10_sync_request() take the "everything skipped" path, which returns
only 128 sectors per call even though the bitmap already reported a much
larger clean span.  md_do_sync() then crawls across the whole device in
128-sector steps with no reschedule; on a 2^40-sector array that is 2^33
no-op iterations:

  watchdog: BUG: soft lockup - CPU#149 stuck for 313s! [mdX_resync]
   md_bitmap_start_sync+0x6f/0xe0
   raid10_sync_request+0x2c9/0x1530 [raid10]
   md_do_sync+0x810/0x1030
   md_thread+0xa7/0x150

Patch 2 adds a cond_resched() to md_do_sync()'s skip path (safety net,
any personality/layout).  Patch 3 fixes the root cause for near layouts:
convert the bitmap-reported clean span from array to per-device sectors
and skip it in one step.  The conversion cannot be done generically in
the bitmap layer because the recovery cursor is in per-device space
(llbitmap's skip_sync_blocks() likewise returns 0 when degraded), and
resync paths already skip whole clean spans, so the fix lives in raid10.

Tested on QEMU/KVM on the latest mainline (raid10 near=2, 4 disks,
internal bitmap):

 - data consistency: write, fail one disk of each pair, write 256MiB
   while degraded, re-add both, wait for recovery, run "check":
   mismatch_cnt=262272 and changed file hashes before patch 1,
   mismatch_cnt=0 and identical hashes after.
 - recovery of two re-added disks on a sparse 8T-per-disk array: one
   37.2s recovery sweep of 100% CPU spinning before, 6.4 ms and 12.8 ms
   for the two recovery passes after patch 3 (dmesg "recover of RAID
   array" -> "recover done": 44.886958 -> 44.893378 and
   44.923957 -> 44.936716); no soft lockup with softlockup_panic=1.

Changes since v1 (a single cond_resched patch):
 - patch 1 (new): fix the still_degraded inversion, a silent data
   corruption found while testing.
 - patch 2 (was v1): rewrite the changelog and retitle; the v1 claim
   that "io_sectors never increases" was wrong (Yu Kuai).
 - patch 3 (new): fix the 128-sector recovery crawl at the source
   instead of only silencing the watchdog.

v1: https://lore.kernel.org/linux-raid/20260717062743.128189-1-yunye.zhao@linux.alibaba.com/

Yunye Zhao (3):
  md/raid10: fix still_degraded being inverted in raid10_sync_request()
  md: add cond_resched() to md_do_sync()'s skip path
  md/raid10: skip clean regions in bulk during recovery

 drivers/md/md.c     |  4 ++-
 drivers/md/raid10.c | 57 ++++++++++++++++++++++++++++++++++++++++++---
 2 files changed, 56 insertions(+), 5 deletions(-)


base-commit: 4539944e515183668109bdf4d0c3d7d228383d88
-- 
2.19.1.6.gb485710b

