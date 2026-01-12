Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5120530CDBB
	for <linux-raid@vger.kernel.org>; Mon, 12 Jan 2026 04:29:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768192154; cv=none; b=iEYUQUnvecJEGK1bReVXtRi5v6X21E7kFHaHpTzY3WtoYb8B+qoKObOQuppfvhOXrbGUEnod/1GBGLCr715OQlb6Rehz3FGtHo/EbAsV5xoBodzoSmFt8wJMZl2rkfb/7ej76tG3i4XutaDgHmv8b00zV3Y87ffSLhzX0+CzrDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768192154; c=relaxed/simple;
	bh=QrKqe2wcBENmzP7Cna7ffbaSe3R/758z3hrV40DN3lo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=R6NHx2OdUiDRPBxeXpWWIUZFAloqQ5gIOHJTipx6BlxjhwU/3hJPW5RJEd+JmPO3uIcg57MmsX9sYkOTGDxsQEuIC5a1SUhzJD5TIwuiM9GqkcBPjIBPLPYiTes4TTyTTebm8U/Be9dRjvTs88aVf+zKazlUoAsp8gSq1KttWVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48D07C116D0;
	Mon, 12 Jan 2026 04:29:11 +0000 (UTC)
From: Yu Kuai <yukuai@fnnas.com>
To: linux-raid@vger.kernel.org,
	linan122@huawei.com
Cc: yukuai@fnnas.com
Subject: [PATCH v4 00/11] md: align bio to io_opt for better performance
Date: Mon, 12 Jan 2026 12:28:46 +0800
Message-ID: <20260112042857.2334264-1-yukuai@fnnas.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patchset optimizes MD RAID performance by aligning bios to the
optimal I/O size before splitting. When I/O is aligned to io_opt,
raid5 can perform full stripe writes without needing to read extra
data for parity calculation, significantly improving bandwidth.

Patches 1-3: Cleanup - merge boolean fields into mddev_flags
Patches 4-5: Preparation - use mempool for stripe_request_ctx and
             ensure max_sectors >= io_opt
Patches 6-7: Core - add bio alignment infrastructure
Patches 8-10: Enable bio alignment for raid5, raid10, and raid0
Patch 11: Fix abnormal io_opt from member disks

Performance improvement on 32-disk raid5 with 64kb chunk:
  dd if=/dev/zero of=/dev/md0 bs=100M oflag=direct
  Before: 782 MB/s
  After:  1.1 GB/s

Changes in v4:
- Patch 11: Simplify by checking rdev_is_mddev() first, remove
  MD_STACK_IO_OPT flag

Changes in v3:
- Patch 4: Remove unnecessary NULL check before mempool_destroy()
- Patch 6: Use sector_div() instead of roundup()/rounddown() to fix
  64-bit division issue on 32-bit platforms

Changes in v2:
- Fix mempool in patch 4
- Add prep cleanup patches, 1-3
- Add patch 11 to fix abnormal io_opt
- Add Link tags to patches

Yu Kuai (11):
  md: merge mddev has_superblock into mddev_flags
  md: merge mddev faillast_dev into mddev_flags
  md: merge mddev serialize_policy into mddev_flags
  md/raid5: use mempool to allocate stripe_request_ctx
  md/raid5: make sure max_sectors is not less than io_opt
  md: support to align bio to limits
  md: add a helper md_config_align_limits()
  md/raid5: align bio to io_opt
  md/raid10: align bio to io_opt
  md/raid0: align bio to io_opt
  md: fix abnormal io_opt from member disks

 drivers/md/md-bitmap.c |   4 +-
 drivers/md/md.c        | 118 +++++++++++++++++++++++++++++++++++------
 drivers/md/md.h        |  30 +++++++++--
 drivers/md/raid0.c     |   6 ++-
 drivers/md/raid1-10.c  |   5 --
 drivers/md/raid1.c     |  13 ++---
 drivers/md/raid10.c    |  10 ++--
 drivers/md/raid5.c     |  92 ++++++++++++++++++++++----------
 drivers/md/raid5.h     |   3 ++
 9 files changed, 215 insertions(+), 66 deletions(-)

-- 
2.51.0

