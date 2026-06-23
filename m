Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D91DA222580;
	Tue, 23 Jun 2026 09:03:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782205412; cv=none; b=GAFbg+1nzUbH0tgxe7x0AW3yesJLYNRHHj6RAGZFODZM3KVqBk0S3aQkddwm5eEMS9uJ37En/9Q89UII7MYeqe7970fmxl3Yx30+C6+zJB0IiMY+DC91vowllbdXfaBv5DQ10e43GOLpBgmOfVSm0PRNXRrT7hZNfFg6zckLSgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782205412; c=relaxed/simple;
	bh=CD26xizmKcdIxeMeep19nxu9JTUKjv9EiCnzxyrJkQk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=UiGdl2wTF0S9PGksQaIYeHgob69TBKl0UnwNS3HtlcTiNtcGoPuDHmHIp/ZT1CxgE2ofe7aZ0/X4yhnQ+SCmaOw13XfHUGDnzN00PT1W8SXrH/Xj6oPDV4apni5KqJBX4ZSrPaiT99h2cRYK/LFM806zom59dfu+tStgQfxHHCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WaBIsQ1P; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WaBIsQ1P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D8C31F000E9;
	Tue, 23 Jun 2026 09:03:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782205411;
	bh=nQNT8d4pR2+cAXpyy9kHB2S/PqSTmNI1erpru5gaJSc=;
	h=From:To:Cc:Subject:Date;
	b=WaBIsQ1PoC0kq7aLXCe2Dt/WcHXinB6Z2x9UBxYcfdWmnPfFUJ5iPduhyT7NCGnF4
	 ofID0HE8KqW+gWMT3jfxf5LAFSlLKttHrs5zWTgPL7MOJ954BZtmKiehXyWajuabOE
	 dyZTKl7Frj9kPF1LC66pmNndqv94qDiTl1zC1YDxmXNBVIrqwFKxws/DrGujH5wULX
	 BGqo26Dr1pUTT2HK0eeLbwnVkfAYdO1ckwANq9lBXamq24JDY8jwYPhwO1Tr6Ll8Bq
	 onz3dQPrNwun0mM5udoN3a0NkWUx2jjxFgMz3L5ltVF82sT3t1fAjL0AI0OjXvGBfF
	 RK7gdzkXFUQSw==
From: Yu Kuai <yukuai@kernel.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-raid@vger.kernel.org,
	linux-block@vger.kernel.org,
	Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>,
	Chen Cheng <chencheng@fnnas.com>
Subject: [GIT PULL] md-7.2-20260623
Date: Tue, 23 Jun 2026 17:03:27 +0800
Message-ID: <20260623090327.1097428-1-yukuai@kernel.org>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Jens,

Please consider pulling the following changes into your block-7.2
branch.

This pull request contains:

Bug Fixes:
- Fix raid1 writes_pending and barrier reference leaks on write failures.
  (Abd-Alrhman Masalkhi)
- Fix raid10 writes_pending leak on write request failures.
  (Abd-Alrhman Masalkhi)
- Fix raid10 writes_pending and barrier reference leaks on discard failures.
  (Abd-Alrhman Masalkhi)
- Fix raid1 REQ_NOWAIT handling while waiting for behind writes.
  (Abd-Alrhman Masalkhi)
- Fix raid1 r1_bio leak when a REQ_NOWAIT retry would block.
  (Abd-Alrhman Masalkhi)
- Fix raid1 read-balance head_position data race. (Chen Cheng)
- Fix raid5 stripe batch bm_seq wraparound comparison. (Chen Cheng)
- Fix raid5 stripe batch state snapshot KCSAN noise. (Chen Cheng)
- Fix raid5 R5_Overlap races while breaking stripe batches. (Chen Cheng)

Improvements:
- Add raid5 discard IO accounting. (Yu Kuai)
- Always convert raid5 llbitmap bits for discard. (Yu Kuai)

Cleanups:
- Simplify raid1_write_request() error handling. (Abd-Alrhman Masalkhi)

Thanks,
Kuai

---

The following changes since commit d5b58fbb2fd7ac25fcd7e1c14730f998a90b0322:

  block: respect iov_iter::nofault flag in bio_iov_iter_bounce_write() (2026-06-16 14:48:35 -0600)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/mdraid/linux.git md-7.2

for you to fetch changes up to 55b77337bdd088c77461588e5ec094421b89911b:

  md/raid5: avoid R5_Overlap races while breaking stripe batches (2026-06-23 09:44:11 +0800)

----------------------------------------------------------------
Abd-Alrhman Masalkhi (6):
      md/raid1: fix writes_pending and barrier reference leaks on write failures
      md/raid10: fix writes_pending leak on write request failures
      md/raid10: fix writes_pending and barrier reference leaks on discard failures
      md/raid1: simplify raid1_write_request() error handling
      md/raid1: honor REQ_NOWAIT when waiting for behind writes
      md/raid1: free r1_bio when REQ_NOWAIT is set and read would block on retry

Chen Cheng (4):
      md/raid1: protect head_position for read balance
      md/raid5: let stripe batch bm_seq comparison wrap-safe
      md/raid5: use stripe state snapshot in break_stripe_batch_list()
      md/raid5: avoid R5_Overlap races while breaking stripe batches

Yu Kuai (3):
      md/raid5: account discard IO
      md/raid5: validate discard support at request time
      md/raid5: always convert llbitmap bits for discard

 drivers/md/md-bitmap.c   |   9 +++-
 drivers/md/md-bitmap.h   |   2 +-
 drivers/md/md-llbitmap.c |  13 +++--
 drivers/md/md.c          |   2 +-
 drivers/md/raid1.c       |  99 ++++++++++++++++++++---------------
 drivers/md/raid10.c      |  28 +++++++---
 drivers/md/raid5.c       | 131 +++++++++++++++++++++++++++++------------------
 drivers/md/raid5.h       |   1 +
 8 files changed, 178 insertions(+), 107 deletions(-)
