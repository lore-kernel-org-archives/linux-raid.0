Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3068437F014;
	Tue, 28 Apr 2026 14:33:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777386836; cv=none; b=sB98h4nkL+YQP2Fc6Yx59Om++Y5M48IoOkKRnbGAV3ZCD3z6UeMmL1iZyqZIn+IMqzN9TULkELDeF7U+1jG15GEEq5nropISL40Gt/bJxRVzE/eoyfUNLfazY/g2fyhTPKSurhk+v9EQ93+JG5oNeq+Jl9Q9zIWOc4qdqFzUMig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777386836; c=relaxed/simple;
	bh=C0CVLDdqPPtE+OOEDaQyjyHXN6S2kReszvZwsOnztlA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=aS0zD4YT04x/DwPWrzelteSs02qlSJv7wpsYr8EvtCVOPHjDsLPTpWsY3UAcNurl3I9yBdyU61VsoA/W45C8w7Sn8vzWhGn1/knc6qQ5/8bRSY729tCmZ7uR9stzFn/PemiCk05kEr16VlGxgk7YMUE/Em1KN26IXHvfb8uu/Bc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFA63C2BCB7;
	Tue, 28 Apr 2026 14:33:51 +0000 (UTC)
From: Yu Kuai <yukuai@fnnas.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org,
	linux-raid@vger.kernel.org,
	Song Liu <song@kernel.org>,
	Li Nan <linan122@huawei.com>,
	Xiao Ni <xiao@kernel.org>,
	Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Junrui Luo <moonafterrain@outlook.com>,
	Keith Busch <kbusch@kernel.org>
Subject: [GIT PULL] md-7.1-20260428
Date: Tue, 28 Apr 2026 22:33:40 +0800
Message-ID: <20260428143340.1088943-1-yukuai@fnnas.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Jens,

Please consider pulling the following changes into your block-7.1
branch.

This pull request contains:

Bug Fixes:
- Fix a raid5 UAF on IO across the reshape position.
- Avoid failing RAID1/RAID10 devices for invalid IO errors.
- Fix RAID10 divide-by-zero when far_copies is zero.
- Restore bitmap grow through sysfs.

Cleanups:
- Use mddev_is_dm() instead of open-coding gendisk checks.
- Use ATTRIBUTE_GROUPS() for md default sysfs attributes.
- Replace open-coded wait loops with wait_event helpers.

Others:
- Add Xiao Ni as md/raid reviewer.

Thanks,
Kuai

---

The following changes since commit 0898a817621a2f0cddca8122d9b974003fe5036d:

  cdrom, scsi: sr: propagate read-only status to block layer via set_disk_ro() (2026-04-27 15:52:51 -0600)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/mdraid/linux.git tags/md-7.1-20260428

for you to fetch changes up to 3b2f70eab5a2cd15e27b1447e66e45302b28ff2c:

  md: use ATTRIBUTE_GROUPS() for md default sysfs attributes (2026-04-28 20:44:38 +0800)

----------------------------------------------------------------
Abd-Alrhman Masalkhi (5):
      md: replace wait loop with wait_event() in md_handle_request()
      md: use mddev_lock_nointr() in mddev_suspend_and_lock_nointr()
      md/raid1: replace wait loop with wait_event_idle() in raid1_write_request()
      md: use mddev_is_dm() instead of open-coding gendisk checks
      md: use ATTRIBUTE_GROUPS() for md default sysfs attributes

Benjamin Marzinski (1):
      md/raid5: Fix UAF on IO across the reshape position

Junrui Luo (1):
      md/raid10: fix divide-by-zero in setup_geo() with zero far_copies

Keith Busch (1):
      md/raid1,raid10: don't fail devices for invalid IO errors

Xiao Ni (1):
      MAINTAINERS: Add Xiao Ni as md/raid reviewer

Yu Kuai (3):
      md: factor bitmap creation away from sysfs handling
      md/md-bitmap: split bitmap sysfs groups
      md/md-bitmap: add a none backend for bitmap grow

 MAINTAINERS              |   1 +
 drivers/md/md-bitmap.c   | 131 ++++++++++++++++++++++++++++++----
 drivers/md/md-bitmap.h   |   2 +-
 drivers/md/md-llbitmap.c |   7 +-
 drivers/md/md.c          | 182 ++++++++++++++++++++++++++---------------------
 drivers/md/md.h          |   6 +-
 drivers/md/raid1-10.c    |   7 +-
 drivers/md/raid1.c       |  15 ++--
 drivers/md/raid10.c      |   2 +
 drivers/md/raid5.c       |   7 +-
 10 files changed, 251 insertions(+), 109 deletions(-)
