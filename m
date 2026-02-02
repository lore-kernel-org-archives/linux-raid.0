Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDCEB2DCF71;
	Mon,  2 Feb 2026 12:42:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770036160; cv=none; b=PhcBS/6P2Mz/HOChv6UoLQXDKWCzNpJkc2jGpHgIqORYg3eQbuha8gUT9DSPcemRicJrGGHlyMJ2hW6AMtNMXG8IfFQknTTITvzPjJ7S2Y0EDWQ6uosJSvHjux4Ysl0Xp2ggkF3/a+gkXXvx1RR/J2VbK1RLorUtgZRHr4VbIJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770036160; c=relaxed/simple;
	bh=Q45ks7lHq8hN1/1vPmqsYWplkfFI6zB8EGAC7O68AHY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=AIx/8NJdifbg2b9uhvaN4kGsccmM24hRVXByrmNFm0rOF5VovDaSB1D2awNK+UlfYVW6YUJkV/NkbYzgZZJj5xbyOIEVACf7a12hP1Yex8qdyR+Kpwv65orUEHDB6tvWVW9U9ffa2nkMPhZVrzNQWaFw7lYy7BQsFTWNyHlw4Ho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D07E4C116D0;
	Mon,  2 Feb 2026 12:42:38 +0000 (UTC)
From: Yu Kuai <yukuai@fnnas.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Song Liu <song@kernel.org>,
	linux-raid@vger.kernel.org,
	linux-block@vger.kernel.org,
	Li Nan <linan122@huawei.com>,
	Xiao Ni <xni@redhat.com>,
	Zilin Guan <zilin@seu.edu.cn>
Subject: [GIT PULL] md-7.0-20260202
Date: Mon,  2 Feb 2026 20:42:36 +0800
Message-ID: <20260202124236.4065531-1-yukuai@fnnas.com>
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
- Fix return value of mddev_trylock (Xiao Ni)
- Fix memory leak in raid1_run() (Zilin Guan)

Maintainers:
- Add Li Nan as mdraid reviewer (Li Nan)

Thanks,
Kuai

The following changes since commit 5314d25afbc44d0449fa2519d2c9d7f3c319f74c:

  selftests: ublk: improve I/O ordering test with bpftrace (2026-01-31 14:56:28 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mdraid/linux.git tags/md-7.0-20260202

for you to fetch changes up to b36844f7d11e1f322d1e48a828c5bfb4a0ecabd1:

  MAINTAINERS: Add Li Nan as md/raid reviewer (2026-02-02 20:31:40 +0800)

----------------------------------------------------------------
Li Nan (1):
      MAINTAINERS: Add Li Nan as md/raid reviewer

Xiao Ni (1):
      md: fix return value of mddev_trylock

Zilin Guan (1):
      md/raid1: fix memory leak in raid1_run()

 MAINTAINERS        | 1 +
 drivers/md/md.h    | 4 ++--
 drivers/md/raid1.c | 1 +
 3 files changed, 4 insertions(+), 2 deletions(-)

