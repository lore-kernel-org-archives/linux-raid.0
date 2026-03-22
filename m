Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A656E1D516C;
	Sun, 22 Mar 2026 18:39:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774204761; cv=none; b=gBMzdf9EySfefNyX2QseezzbNBFrmQNqP0zlcd0rJkWvfbMJZR+KWyd/DrU+2Qo1wYV4x2LtvceWYnjr4XuefknUEkRBK7B/8qrH7KSVqQFNkZ82STq3dKRC5FXBAnIPcyj0AAR27bAhgUNuttevnaWyLXzIeBefmhGcjNaMYNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774204761; c=relaxed/simple;
	bh=FqW2Hq1uyyoWiBy5hYlULmbXLmLwckiisPJv31ZpQYw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=QS3Ua357IvFYbBGyVgCrAlixXRJqvsBC5+GhgiVRJfc1DzT9INqJxtUCuXgpulZeds1EAuBQqWSXI9eUTLDmA9OkFQauDCgccyZLjbo6IcJfuBCPamfJN4Jz5gwcMa6/Q7pzjv74i1G1GaVz5FKet1WXBVnXGSb3yd6+4wqydtw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53BC5C19424;
	Sun, 22 Mar 2026 18:39:19 +0000 (UTC)
From: Yu Kuai <yukuai@fnnas.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-raid@vger.kernel.org,
	linux-block@vger.kernel.org,
	Chen Cheng <chencheng@fnnas.com>,
	FengWei Shih <dannyshih@synology.com>,
	Josh Hunt <johunt@akamai.com>,
	Xiao Ni <xni@redhat.com>,
	Yu Kuai <yukuai@fnnas.com>
Subject: [GIT PULL] md-7.1-20260323
Date: Mon, 23 Mar 2026 02:39:11 +0800
Message-ID: <20260322183911.2732398-1-yukuai@fnnas.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Jens,

Please consider pulling the following changes into your for-7.1/block branch.

This pull request contains:

Bug Fixes:
- md: suppress spurious superblock update error message for dm-raid (Chen Cheng)
- md/raid1: fix the comparing region of interval tree (Xiao Ni)
- md/raid10: fix deadlock with check operation and nowait requests (Josh Hunt)
- md/raid5: skip 2-failure compute when other disk is R5_LOCKED (FengWei Shih)
- md/md-llbitmap: raise barrier before state machine transition (Yu Kuai)
- md/md-llbitmap: skip reading rdevs that are not in_sync (Yu Kuai)

Improvements:
- md/raid5: set chunk_sectors to enable full stripe I/O splitting (Yu Kuai)

Cleanups:
- md: remove unused mddev argument from export_rdev (Chen Cheng)
- md/raid5: remove stale md_raid5_kick_device() declaration (Chen Cheng)
- md/raid5: move handle_stripe() comment to correct location (Chen Cheng)

Thanks,
Kuai

---

The following changes since commit 5d540162059598c3f79e12f96064825cc91f0f9c:

  ublk: report BLK_SPLIT_INTERVAL_CAPABLE (2026-03-14 07:44:30 -0600)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mdraid/linux.git tags/md-7.1-20260323

for you to fetch changes up to 6f507eb2bb5491327fe634dc23558d4ca5d710b8:

  md: remove unused mddev argument from export_rdev (2026-03-23 02:15:11 +0800)

----------------------------------------------------------------
Chen Cheng (4):
      md: suppress spurious superblock update error message for dm-raid
      md/raid5: remove stale md_raid5_kick_device() declaration
      md/raid5: move handle_stripe() comment to correct location
      md: remove unused mddev argument from export_rdev

FengWei Shih (1):
      md/raid5: skip 2-failure compute when other disk is R5_LOCKED

Josh Hunt (1):
      md/raid10: fix deadlock with check operation and nowait requests

Xiao Ni (1):
      md/raid1: fix the comparing region of interval tree

Yu Kuai (3):
      md/raid5: set chunk_sectors to enable full stripe I/O splitting
      md/md-llbitmap: skip reading rdevs that are not in_sync
      md/md-llbitmap: raise barrier before state machine transition

 drivers/md/md-llbitmap.c | 11 ++++++-----
 drivers/md/md.c          | 32 +++++++++++++++++---------------
 drivers/md/raid1.c       |  4 ++--
 drivers/md/raid10.c      |  4 ++--
 drivers/md/raid5.c       | 29 +++++++++++++++--------------
 drivers/md/raid5.h       |  1 -
 6 files changed, 42 insertions(+), 39 deletions(-)
