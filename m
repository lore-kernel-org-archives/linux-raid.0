Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7756A313E02;
	Wed, 31 Dec 2025 09:17:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767172672; cv=none; b=IM8MaSxPMqUeCaasXylZIr4qt+N3Hp1CO4PmOZ3niCvOZPvW8bq1TT+NHeUuXgaRtdAN+BL1P99WWWtnpq4/pR+FjEH7+bnvcCK2YOLcZ63L1JJ/y9EBdtYuLTptJTsOy40ZdJMNSBP+y0WMD7UHTLyfYkTfOmSnMTQd28iN2fw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767172672; c=relaxed/simple;
	bh=sn53wnRDIoRLiVO8Hgj0kAJ4KRwFIuZQ+RD3TGk3cN0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Z7CLU+DgIULq6KymQVh4CpIHhYzGCPR7RrIlXOUIucBIvkFzM5JMtUM/MeroovgB18LYxBu3biVeyLSxlU73jhs4cyzGNyjJ7Geh9gMvYJUYbRdr63PoWvOnr9JrJXkjCZIKHIejr2rrLL5dombPZn8PG8UHXvZRRLGIooZqaeA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0BE9C113D0;
	Wed, 31 Dec 2025 09:17:50 +0000 (UTC)
From: Yu Kuai <yukuai@fnnas.com>
To: axboe@kernel.dk,
	linux-block@vger.kernel.org,
	linux-raid@vger.kernel.org
Cc: yukuai@fnnas.com,
	linan122@huawei.com,
	dannyshih@synology.com,
	islituo@gmail.com
Subject: [GIT PULL] md-6.19-20251230
Date: Wed, 31 Dec 2025 17:17:40 +0800
Message-ID: <20251231091740.217388-1-yukuai@fnnas.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Jens,

Please consider pulling the following changes into your block-6.19 branch.

This pull request contains:

- Fix null-pointer dereference in raid5 sysfs group_thread_cnt store
  (Tuo Li)
- Fix possible mempool corruption during raid1 raid_disks update via
  sysfs (FengWei Shih)
- Fix logical_block_size configuration being overwritten during
  super_1_validate() (Li Nan)
- Fix forward incompatibility with configurable logical block size:
  arrays assembled on new kernels could not be assembled on kernels
  <=6.18 due to non-zero reserved pad rejection (Li Nan)
- Fix static checker warning about iterator not incremented (Li Nan)

Thanks,
Kuai

The following changes since commit 1ddb815fdfd45613c32e9bd1f7137428f298e541:

  block: rnbd-clt: Fix signedness bug in init_dev() (2025-12-20 12:56:48 -0700)

are available in the Git repository at:

  git@gitolite.kernel.org:pub/scm/linux/kernel/git/mdraid/linux.git tags/md-6.19-20251231

for you to fetch changes up to a4166f1c4893a9a620507255b9d1ccab44fab189:

  md: Fix forward incompatibility from configurable logical block size (2025-12-27 10:14:07 +0800)

----------------------------------------------------------------
FengWei Shih (1):
      md: suspend array while updating raid_disks via sysfs

Li Nan (3):
      md: Fix static checker warning in analyze_sbs
      md: Fix logical_block_size configuration being overwritten
      md: Fix forward incompatibility from configurable logical block size

Tuo Li (1):
      md/raid5: fix possible null-pointer dereferences in raid5_store_group_thread_cnt()

 drivers/md/md.c    | 61 ++++++++++++++++++++++++++++++++++++++++++++++++++-----------
 drivers/md/raid5.c | 10 ++++++----
 2 files changed, 56 insertions(+), 15 deletions(-)

