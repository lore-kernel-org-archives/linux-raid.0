Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B18681CAA79
	for <linux-raid@vger.kernel.org>; Wed, 14 Jan 2026 17:12:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768410769; cv=none; b=dF6e5q2N78l7Ekj8Iue/z+Kk4sPJB5FoTar/zR6hKaBd8gT1+2Ef4Dfq6DvxhfaK8Cl1ZFhpUWiw3Sc0nrMo7ltkSJb+C928GAAUIoQo9jh37kDZPIoOIvOWLRAs8He2XD469jZZyNFIl6b0fVNcl8lwgnn6MZxMzxt+WDsY8dA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768410769; c=relaxed/simple;
	bh=leiDzXYIdpKiilqd6GYhNnD0eywavaATAevoU+upL6g=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=rurAwPwJm1JwqkU4kSKr8WoECZUVfkXaY5+3msypYz9XE8Jp9RnrG5iOhH2+ocXFFFNFc2OAfcrRzUAmIrwg3E94cRn1SXPMxCSrq7OhTo/cvQVc6MPpmFNo5fd1dEcE0ojaZMdZYyKRWCmri1fMAsK4SxTIMeUN1S4024WyQMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 972D0C19424;
	Wed, 14 Jan 2026 17:12:46 +0000 (UTC)
From: Yu Kuai <yukuai@fnnas.com>
To: linux-raid@vger.kernel.org
Cc: yukuai@fnnas.com,
	linan122@huawei.com,
	xni@redhat.com,
	dan.carpenter@linaro.org
Subject: [PATCH v5 00/12] md: align bio to io_opt for better performance
Date: Thu, 15 Jan 2026 01:12:28 +0800
Message-ID: <20260114171241.3043364-1-yukuai@fnnas.com>
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

Patch 1: Fix a bug in raid5_run() error handling
Patches 2-4: Cleanup - merge boolean fields into mddev_flags
Patches 5-6: Preparation - use mempool for stripe_request_ctx and
             ensure max_sectors >= io_opt
Patches 7-8: Core - add bio alignment infrastructure
Patches 9-11: Enable bio alignment for raid5, raid10, and raid0
Patch 12: Fix abnormal io_opt from member disks

Performance improvement on 32-disk raid5 with 64kb chunk:
  dd if=/dev/zero of=/dev/md0 bs=100M oflag=direct
  Before: 782 MB/s
  After:  1.1 GB/s

Changes in v5:
- Add patch 1 to fix raid5_run() returning success when log_init() fails
- Patch 12: Fix stale commit message (remove mention of MD_STACK_IO_OPT flag)

Changes in v4:
- Patch 12: Simplify by checking rdev_is_mddev() first, remove
  MD_STACK_IO_OPT flag

Changes in v3:
- Patch 5: Remove unnecessary NULL check before mempool_destroy()
- Patch 7: Use sector_div() instead of roundup()/rounddown() to fix
  64-bit division issue on 32-bit platforms

Changes in v2:
- Fix mempool in patch 5
- Add prep cleanup patches, 2-4
- Add patch 12 to fix abnormal io_opt
- Add Link tags to patches

Yu Kuai (12):
  md/raid5: fix raid5_run() to return error when log_init() fails
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
 drivers/md/raid5.c     |  95 +++++++++++++++++++++++----------
 drivers/md/raid5.h     |   3 ++
 9 files changed, 217 insertions(+), 67 deletions(-)

-- 
2.51.0

