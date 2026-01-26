Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 607CA3EBF3A;
	Mon, 26 Jan 2026 17:20:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769448017; cv=none; b=JnojzzhdSPQMDsSW+0YlW0lWcPKk8Nj1lbRLyh9Od59ggcAlnNbhGSTfwQpP0b4K7j1bFeOf5RlnBgqxQdqOvVRoSCCX3g6/YIpyg+pOrXJXzfW9VIWENBy+dxULBuziBvKyJOE/prlU0tZF272U4rg+XtA0UG6MhwLYOkoCoYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769448017; c=relaxed/simple;
	bh=1+vf/wEJCfdsaxeTEOnRwFVvVbwoyOpB6oOR+N+aw2w=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=PWnG0Y6XxSDFPyUab0HCbJ37I8r+XCz8rmy7pUDUOTx/TRv8KHuR7+WhjrEwL9SCvwWNmnHyJozZsT31GONNJyEl9Ig1Z9wfuN52R6PWlj1MgpTADrQuLluT5sYhph3EO5ytALNZPld8jSe0+KKiPXddX8JdCgjRRDAK5vbBLo4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A41FEC116C6;
	Mon, 26 Jan 2026 17:20:11 +0000 (UTC)
From: Yu Kuai <yukuai@fnnas.com>
To: axboe@kernel.dk,
	linux-block@vger.kernel.org,
	linux-raid@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	yukuai@fnnas.com,
	heinzm@redhat.com,
	jiashengjiangcool@gmail.com,
	jinpu.wang@ionos.com,
	linan122@huawei.com
Subject: [GIT PULL] md-7.0-20260127
Date: Tue, 27 Jan 2026 01:20:08 +0800
Message-ID: <20260126172008.343807-1-yukuai@fnnas.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Jens,

Please consider pulling the following changes into your for-7.0/block
branch.

This pull request contains:

Bug Fixes:
- Fix raid5_run() to return error when log_init() fails (Yu Kuai)
- Fix IO hang with degraded array with llbitmap (Yu Kuai)
- Fix percpu_ref not resurrected on suspend timeout in llbitmap (Yu Kuai)
- Fix GPF in write_page caused by resize race (Jack Wang)
- Fix NULL pointer dereference in process_metadata_update (Jiasheng Jiang)
- Fix hang when stopping arrays with metadata through dm-raid
  (Heinz Mauelshagen)
- Fix any_working flag handling in raid10_sync_request (Li Nan)

Cleanups & Refactoring:
- Refactor sync/recovery code path, improve error handling for badblocks,
  and remove unused recovery_disabled field (Li Nan)
- Consolidate mddev boolean fields into mddev_flags (Yu Kuai)

Improvements:
- Use mempool to allocate stripe_request_ctx and make sure max_sectors is
  not less than io_opt in raid5 (Yu Kuai)

Thanks,
Kuai

The following changes since commit 8e5bcc3a955a2cc4460b391f55d3b49905eb248e:

  selftests: ublk: add missing gitignore for metadata_size binary (2026-01-25 10:11:32 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mdraid/linux.git tags/md-7.0-20260127

for you to fetch changes up to cefcb9297fbdb6d94b61787b4f8d84f55b741470:

  md raid: fix hang when stopping arrays with metadata through dm-raid (2026-01-26 13:46:40 +0800)

----------------------------------------------------------------
Heinz Mauelshagen (1):
      md raid: fix hang when stopping arrays with metadata through dm-raid

Jack Wang (1):
      md/bitmap: fix GPF in write_page caused by resize race

Jiasheng Jiang (1):
      md-cluster: fix NULL pointer dereference in process_metadata_update

Li Nan (12):
      md/raid1: simplify uptodate handling in end_sync_write
      md: factor error handling out of md_done_sync into helper
      md/raid1,raid10: support narrow_write_error when badblocks is disabled
      md: break remaining operations on badblocks set failure in narrow_write_error
      md: mark rdev Faulty when badblocks setting fails
      md: update curr_resync_completed even when MD_RECOVERY_INTR is set
      md: remove MD_RECOVERY_ERROR handling and simplify resync_offset update
      md: factor out sync completion update into helper
      md: move finish_reshape to md_finish_sync()
      md/raid10: fix any_working flag handling in raid10_sync_request
      md/raid10: cleanup skip handling in raid10_sync_request
      md: remove recovery_disabled

Yu Kuai (8):
      md/raid5: fix raid5_run() to return error when log_init() fails
      md: merge mddev has_superblock into mddev_flags
      md: merge mddev faillast_dev into mddev_flags
      md: merge mddev serialize_policy into mddev_flags
      md/raid5: use mempool to allocate stripe_request_ctx
      md/raid5: make sure max_sectors is not less than io_opt
      md/raid5: fix IO hang with degraded array with llbitmap
      md/md-llbitmap: fix percpu_ref not resurrected on suspend timeout

 drivers/md/md-bitmap.c   |   7 +-
 drivers/md/md-cluster.c  |   7 +-
 drivers/md/md-llbitmap.c |   4 +-
 drivers/md/md.c          | 188 +++++++++++++++++++++++++----------------------
 drivers/md/md.h          |  25 +++----
 drivers/md/raid0.c       |   4 +-
 drivers/md/raid1-10.c    |   5 --
 drivers/md/raid1.c       |  88 +++++++++-------------
 drivers/md/raid1.h       |   5 --
 drivers/md/raid10.c      | 178 ++++++++++++++------------------------------
 drivers/md/raid10.h      |   5 --
 drivers/md/raid5.c       | 143 +++++++++++++++++++++--------------
 drivers/md/raid5.h       |   4 +-
 13 files changed, 310 insertions(+), 353 deletions(-)

