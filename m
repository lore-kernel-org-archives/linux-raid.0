Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55AB41F8723
	for <linux-raid@vger.kernel.org>; Sat,  5 Jul 2025 12:07:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751717278; cv=none; b=oXS8klOX8e7vTwoipGq4cQb8uGbeUdfBr6mI1b/6fWgxmPJih6zz6wiAItNZir0iBn/1uCidTLaZo191fahWyvwyviF4TOZLjxJKggK1/tFwWjhW/jdjdvIhXTO3eLeWRPzBclGFNFtzwqUns6ZYU27mJD9LEBdyPvksUW/bIJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751717278; c=relaxed/simple;
	bh=WMcYVNtamJVmNQPoG4mqRmue0CAW86JHnhI2DAVVyEI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=ifJRdtIHerLwUQU3QZntYgnOFP+Qxah18RdigKs5xU+CVtWCVGlUCqqJtJyA7RHSFLzTK1CKev27hUIAfYo87bnlqyIXByyt2nmH/g9ja1JzAXTXDkP/dM3NAGWpyURWwQk9jZiiU/nX5a9GFWyYS0MSdm0h6JtzDqKzxll8FIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=vJVr1TpY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="vJVr1TpY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D6ACC4CEE7;
	Sat,  5 Jul 2025 12:07:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751717277;
	bh=WMcYVNtamJVmNQPoG4mqRmue0CAW86JHnhI2DAVVyEI=;
	h=From:To:Cc:Subject:Date:From;
	b=vJVr1TpYUFZY6AgBc4M38TaU+wLSsbOnBe1LyehKNi6LasoajfrnTMr+TpfRUGB4P
	 ayUdHUzKXPVkFzDe4KbvT3ANMjSl8mU2pN3QgaaB2f+CZ/b5jOnNCQ7y3yF7+OrQFN
	 AlfNtO6W6auKUmgdau+zmAwiJpu62NHQ7jBFw7v+QX+D16smtdTabbGKvS+YQkhBKb
	 gV1TFjsEmmpXKQaoFiOPlI/Qgsi3oSBobnXuZMvWyVCe/brLTR5lDyaLVbDomD4NpZ
	 a0yJFzSdQZ4BVw9HLH0Sum6xpas9uTUMduV+mIAd3AHdmOOOJwAsRlR3oH09XaCrz0
	 X+3hJL/pAxJ6w==
From: Yu Kuai <yukuai@kernel.org>
To: axboe@kernel.dk,
	linux-raid@vger.kernel.org,
	song@kernel.org
Cc: yukuai3@huawei.com,
	yangerkun@huawei.com,
	yi.zhang@huawei.com,
	johnny.chenyi@huawei.com,
	haakon.bugge@oracle.com,
	zhengqixing@huawei.com,
	ncroxon@redhat.com,
	wangjinchao600@gmail.com
Subject: [GIT PULL] md-6.16-20250705
Date: Sat,  5 Jul 2025 20:07:30 +0800
Message-ID: <20250705120732.6134-1-yukuai@kernel.org>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Jens,

Please consider pulling following bugfixes from md-6.16 on your block-6.16
branch, this pull request contains:

 - fix uaf due to stack memory used for bio mempool, from Jinchao
 - fix raid10/raid1 nowait IO error path, from Nigel and Qixing
 - fix kernel crash from reading bitmap sysfs entry, by Håkon

The following changes since commit 75ef7b8d44c30a76cfbe42dde9413d43055a00a7:

  Merge tag 'nvme-6.16-2025-07-03' of git://git.infradead.org/nvme into block-6.16 (2025-07-03 09:42:07 -0600)

are available in the Git repository at:

  git@gitolite.kernel.org:pub/scm/linux/kernel/git/mdraid/linux.git tags/md-6.16-20250705

for you to fetch changes up to c17fb542dbd1db745c9feac15617056506dd7195:

  md/md-bitmap: fix GPF in bitmap_get_stats() (2025-07-05 19:36:50 +0800)

----------------------------------------------------------------
Håkon Bugge (1):
      md/md-bitmap: fix GPF in bitmap_get_stats()

Nigel Croxon (1):
      raid10: cleanup memleak at raid10_make_request

Wang Jinchao (1):
      md/raid1: Fix stack memory use after return in raid1_reshape

Zheng Qixing (1):
      md/raid1,raid10: strip REQ_NOWAIT from member bios

 drivers/md/md-bitmap.c |  3 +--
 drivers/md/raid1.c     |  4 +++-
 drivers/md/raid10.c    | 12 ++++++++++--
 3 files changed, 14 insertions(+), 5 deletions(-)
