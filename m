Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 637E0191;
	Sun, 30 Nov 2025 03:06:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764472017; cv=none; b=oadC7Dzr96JAlIBHvruBM3I+f4XvEpyH4WRAQ4RCEWihvXXe+VTcMZd1lobrVFFJBT/fIEw1HTQLU72Ur/PeW/2gIutK9WFg6WlGulS4pikK+IUougfvgd1jaVamp4bdzGl8nYEIx9NboMcydkBybE247lf+mATxeoW8ahYHUWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764472017; c=relaxed/simple;
	bh=EE7/UMxr3NzBHzT7TFHLkj9aPqGRf4g+VIf/iwmPvHE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=lkyAXZXcCCNxTU4VW/LRTv2fxtvX6jEnbQwBzpdQSgdSz7FRVeXLh12iJNKQ7NNxVKs7/LaEuRFCFH6ZsCZKXD7ZygX8/sHb40bJQr0GBvxk611gIZvEquQjpw8xWm4jAUPu6HAZjxrPXgizm7bydKrKsiCt1Zw31dYBNqyGVZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C4AAC113D0;
	Sun, 30 Nov 2025 03:06:55 +0000 (UTC)
From: Yu Kuai <yukuai@fnnas.com>
To: axboe@kernel.dk,
	linux-block@vger.kernel.org,
	linux-raid@vger.kernel.org
Cc: yukuai@fnnas.com,
	tarunsahu@google.com
Subject: [GIT PULL] md-6.19-20251130
Date: Sun, 30 Nov 2025 11:06:53 +0800
Message-ID: <20251130030653.2302439-1-yukuai@fnnas.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi, Jens

Please consider pulling following changes on your for-6.19/block branch,
this pull request contain:

- fix null-ptr-dereference regression for dm-raid0 (Yu Kuai)
- fix IO hang for raid5 when array is broken with IO inflight (Yu Kuai)
- remove legacy 1s delay to speed up system shutdown (Tarun Sahu)

Thanks,
Kuai

The following changes since commit 418de94e7593081c29066555bf9059f1f7dd9d79:

  sbitmap: fix all kernel-doc warnings (2025-11-28 09:21:18 -0700)

are available in the Git repository at:

  git@gitolite.kernel.org:pub/scm/linux/kernel/git/mdraid/linux.git tags/md-6.19-20251130

for you to fetch changes up to fdd0c6a649d24107bbadd249c87feab67b9037c5:

  md: remove legacy 1s delay in md_notify_reboot (2025-11-30 09:42:28 +0800)

----------------------------------------------------------------
Tarun Sahu (1):
      md: remove legacy 1s delay in md_notify_reboot

Yu Kuai (3):
      md/raid0: fix NULL pointer dereference in create_strip_zones() for dm-raid
      md: warn about updating super block failure
      md/raid5: fix IO hang when array is broken with IO inflight

 drivers/md/md.c    | 12 +-----------
 drivers/md/raid0.c |  9 ++++++++-
 drivers/md/raid5.c |  6 ++++--
 3 files changed, 13 insertions(+), 14 deletions(-)


