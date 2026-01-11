Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C0FB34DCFE
	for <linux-raid@vger.kernel.org>; Sun, 11 Jan 2026 18:27:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768156023; cv=none; b=JsLa0ypDKtl700nSa2Mf1tupfV4mhPD61yvbsWdwvUAsdJQmV/C9MnV3LaFEMlfw52rRCRSGMiZ2tXDo4W+L9BmIhG7fUiFY0WeN0+SMMinos8qhQ4jPCFhTJrqRg6Dg4Ibx9bnTnUpn4LnivwRCezbRlgMcX3u277mpgXvdSU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768156023; c=relaxed/simple;
	bh=x+peeevbJH+iDtkpTqvFt6BYSWHoJkEglWqdHvVLw3o=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=R3kbL5qpvABI77q+Ti9rBAjEgW+uz5dFm4eXi+FQx8k/fc4dlYiQ3pCPN8cjZeiDDLrGXES7qGYO3M+Gqj7XewtOiIHFLDhSuse+8dJ5p8kV/f2X1wOgWT36o3uKTVxTT6e486lOw+VWqWbQHEFM5OLeyUMirW0TgFadqa8mFQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7F56C4CEF7;
	Sun, 11 Jan 2026 18:27:01 +0000 (UTC)
From: Yu Kuai <yukuai@fnnas.com>
To: linux-raid@vger.kernel.org,
	linan122@huawei.com
Cc: yukuai@fnnas.com
Subject: [PATCH v3 00/11] md: align bio to io_opt for better performance
Date: Mon, 12 Jan 2026 02:26:40 +0800
Message-ID: <20260111182651.2097070-1-yukuai@fnnas.com>
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

Changes in v3:
- Patch 4: Remove unnecessary NULL check before mempool_destroy()
- Patch 6: Use sector_div() instead of roundup()/rounddown() to fix
  64-bit division issue on 32-bit platforms
changes in v2:
 - fix mempool in patch 4;
 - add prep cleanup patches, 1-3;
 - and patch 11 to fix abormal io_opt;

Changes in v2:
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
 drivers/md/md.c        | 125 +++++++++++++++++++++++++++++++++++------
 drivers/md/md.h        |  32 +++++++++--
 drivers/md/raid0.c     |   6 +-
 drivers/md/raid1-10.c  |   5 --
 drivers/md/raid1.c     |  13 +++--
 drivers/md/raid10.c    |  10 ++--
 drivers/md/raid5.c     |  92 +++++++++++++++++++++---------
 drivers/md/raid5.h     |   3 +
 9 files changed, 224 insertions(+), 66 deletions(-)

-- 
2.51.0

