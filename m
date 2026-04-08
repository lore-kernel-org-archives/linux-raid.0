Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4ED51F30BB;
	Wed,  8 Apr 2026 05:05:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775624731; cv=none; b=EgYFygcGyJiTxjo0XL3DPGQoXR1bdsza2y/Ea+ZOz7FZAn725KQ+c63FXjsEisLJ+suXn36I1+DlZq1haDvIQABD3Y9Y8dn3/ANnHVjXEKZtOjirPGoXbAHKbpMZ8lihB/zJVfZz93qiz/JEpmICW56zbq7zLatif7HM/taSuQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775624731; c=relaxed/simple;
	bh=aOq3weOCjYOBcfMYYLZ4HWs33PSYb3j7H62F9mMVHLo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Rdf15onEJSOoZ0Dqbq79hOx8n5C7TsBLDTc78S4UKxatS6GDG7KO1B/zOmLlqcrLxxax96o79RRP+aEP08mM/kyD+QGOxoAvbQmTbMRX/WO3XsDE5mZU/lQ4bfL0prIlFs0x/+ylvyEodacnPiWKylhGGYS/KgnCJAIjVPGV5V8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D90CC19424;
	Wed,  8 Apr 2026 05:05:27 +0000 (UTC)
From: Yu Kuai <yukuai@fnnas.com>
To: axboe@kernel.dk,
	linux-block@vger.kernel.org,
	linux-raid@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	song@kernel.org,
	linan122@huawei.com,
	abd.masalkhi@gmail.com,
	chiamingc@synology.com,
	gourry@gourry.net,
	moonafterrain@outlook.com,
	xni@redhat.com,
	yukuai@fnnas.com
Subject: [GIT PULL] md-7.1-20260407
Date: Wed,  8 Apr 2026 13:05:17 +0800
Message-ID: <20260408050517.2109269-1-yukuai@fnnas.com>
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
- avoid a sysfs deadlock when clearing array state (Yu Kuai)
- validate raid5 journal payloads before reading metadata (Junrui Luo)
- fall back to the correct bitmap operations after version mismatches (Yu Kuai)
- serialize overlapping writes on writemostly raid1 disks (Xiao Ni)
- wake raid456 reshape waiters before suspend (Yu Kuai)
- prevent retry_aligned_read() from triggering soft lockups (Chia-Ming Chang)

Improvements:
- switch raid0 strip zone and devlist allocations to kvmalloc helpers (Gregory Price)
- track clean unwritten stripes for proactive RAID5 parity building (Yu Kuai)
- speed up initial llbitmap sync with write_zeroes_unmap support (Yu Kuai)

Cleanups:
- remove the unused static md workqueue definition (Abd-Alrhman Masalkhi)

Thanks,
Kuai

---

The following changes since commit 8b155f2e4a91f3507951e6ace4b413688ac28b96:

  block: remove unused BVEC_ITER_ALL_INIT (2026-04-04 08:10:37 -0600)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mdraid/linux.git tags/md-7.1-20260407

for you to fetch changes up to 7f9f7c697474268d9ef9479df3ddfe7cdcfbbffc:

  md/raid5: fix soft lockup in retry_aligned_read() (2026-04-07 15:13:52 +0800)

----------------------------------------------------------------
Abd-Alrhman Masalkhi (1):
      md: remove unused static md_wq workqueue

Chia-Ming Chang (1):
      md/raid5: fix soft lockup in retry_aligned_read()

Gregory Price (1):
      md/raid0: use kvzalloc/kvfree for strip_zone and devlist allocations

Junrui Luo (1):
      md/raid5: validate payload size before accessing journal metadata

Xiao Ni (1):
      md/raid1: serialize overlap io for writemostly disk

Yu Kuai (5):
      md: fix array_state=clear sysfs deadlock
      md: add fallback to correct bitmap_ops on version mismatch
      md/md-llbitmap: add CleanUnwritten state for RAID-5 proactive parity building
      md/md-llbitmap: optimize initial sync with write_zeroes_unmap support
      md: wake raid456 reshape waiters before suspend

 drivers/md/md-llbitmap.c | 202 ++++++++++++++++++++++++++++++++++++++++++++---
 drivers/md/md.c          | 139 +++++++++++++++++++++++++++++---
 drivers/md/md.h          |   5 +-
 drivers/md/raid0.c       |  18 ++---
 drivers/md/raid1.c       |  47 ++++++++---
 drivers/md/raid5-cache.c |  48 +++++++----
 drivers/md/raid5.c       |   8 +-
 7 files changed, 405 insertions(+), 62 deletions(-)
