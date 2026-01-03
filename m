Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CDCD17BB35
	for <linux-raid@vger.kernel.org>; Sat,  3 Jan 2026 15:45:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767455157; cv=none; b=n8NlOhJ6RWD/kMtRiRurUcsxKkDUl4Q50kkzd+8LSNerIfN3F91ioj33gJcdly5Jc7BPRJOyYhzAhhrWMThMR+dlxuJUhGwuVDKHv73jOxASLSA1b6TlxTpXd7A+cl6aJg43+c/KZfeA5UEX+zYzsO+1dRzmISXlLD7e93FNG1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767455157; c=relaxed/simple;
	bh=gYDNOvDFnrmNOQk3qJ9d5HHN8ghwoiIKMFUfYp2e4CU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=RkCdXhbddAetLjiGnKxlcnZPxr8h18yG5GwhpJWAbiZ+CW7rAAnywm34AqWu9Xf72Xlv6qgca0ElhFhojMECp9nLeNWsy2e3+3Iyz0uoa0Qs/VElzUlSSvSDWSMGa/X4bVtdAE17bIV045lcE+2sxI/jLj5cZgLvd3RMM/EEeis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBF87C113D0;
	Sat,  3 Jan 2026 15:45:53 +0000 (UTC)
From: Yu Kuai <yukuai@fnnas.com>
To: linux-raid@vger.kernel.org
Cc: yukuai@fnnas.com,
	colyli@fnnas.com,
	linan122@huawei.com
Subject: [PATCH v2 00/11] md: align bio to io_opt and fix abnormal io_opt
Date: Sat,  3 Jan 2026 23:45:32 +0800
Message-ID: <20260103154543.832844-1-yukuai@fnnas.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

changes in v3:
 - fix mempool in patch 4;
changes in v2:
 - add prep cleanup patches, 1-3;
 - and patch 11 to fix abormal io_opt;

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
 drivers/md/md.c        | 117 +++++++++++++++++++++++++++++++++++------
 drivers/md/md.h        |  32 +++++++++--
 drivers/md/raid0.c     |   6 ++-
 drivers/md/raid1-10.c  |   5 --
 drivers/md/raid1.c     |  13 ++---
 drivers/md/raid10.c    |  10 ++--
 drivers/md/raid5.c     |  93 ++++++++++++++++++++++----------
 drivers/md/raid5.h     |   3 ++
 9 files changed, 217 insertions(+), 66 deletions(-)

-- 
2.51.0

