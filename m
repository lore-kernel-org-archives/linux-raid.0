Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2771A3839B9;
	Sun, 31 May 2026 11:26:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780226785; cv=none; b=JDpBfkhjC+U99omb8u+UloIYz4SnyhqnvD/reBn4SJiM8q5YMyHDU9piNwlZv5p/kfCg9r+4wZ4XS+zz66AliAb/36OHJkUcCfB4ugEPCZYmkZEEiothQM4/Tmm8F8N6oAQ+h8zPK0f/HsBKiwGC8tfvJoNjF0KpM83odp5QZ+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780226785; c=relaxed/simple;
	bh=eMyRc/aw/p8wxBZg+wmpGwUO+CcmFGmKiWvnYQpYR+0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=aBWFsT2/FytJo3x3NDcR7VWNcfhAZOAP/dLmRy8fPVWPBaupZ3eT0pIASoT4stjRdh5kkQ0l0aYwUkcPhIId3xziuvsDHg9pHv0k/OJBq9Mw/NAxzAv8Dp0AVUDYGjTaj32GAedbGgWyTBTLaxN2buEmoOmw5qKt1fWojUqfi+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6ABBB1F00893;
	Sun, 31 May 2026 11:26:21 +0000 (UTC)
From: Yu Kuai <yukuai@fygo.io>
To: Jens Axboe <axboe@kernel.dk>
Cc: Yu Kuai <yukuai@fygo.io>,
	linux-raid@vger.kernel.org,
	linux-block@vger.kernel.org,
	Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Chen Cheng <chencheng@fnnas.com>,
	Christoph Hellwig <hch@lst.de>,
	Li Nan <magiclinan@didiglobal.com>,
	Thorsten Blum <thorsten.blum@linux.dev>
Subject: [GIT PULL] md-7.2-20260531
Date: Sun, 31 May 2026 19:26:18 +0800
Message-ID: <20260531112618.160409-1-yukuai@fygo.io>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Jens,

Please consider pulling the following changes into your for-7.2/block
branch.

This pull request contains:

Bug Fixes:
- Only requeue dm-raid bios when dm is suspending. (Benjamin Marzinski)
- Reset raid10 read_slot when reusing r10bio for discard. (Chen Cheng)
- Fix raid1/raid10 deadlock in read error recovery path. (Abd-Alrhman Masalkhi)
- Fix raid1/raid10 error-path detection with md_cloned_bio(). (Abd-Alrhman Masalkhi)
- Fix raid1/raid10 bio accounting for split md cloned bios. (Abd-Alrhman Masalkhi)
- Fix raid1 nr_pending leak in REQ_ATOMIC bad-block path. (Abd-Alrhman Masalkhi)

Improvements:
- Skip redundant raid_disks updates when the value is unchanged. (Abd-Alrhman Masalkhi)

Cleanups:
- Update MAINTAINERS email addresses. (Yu Kuai, Li Nan)
- Clean up raid1 read error handling. (Christoph Hellwig)
- Move the exceed_read_errors condition out of fix_read_error(). (Christoph Hellwig)
- Use str_plural() in raid0 dump_zones(). (Thorsten Blum)

Thanks,
Kuai

---

The following changes since commit be34ec59ef061a1cc435a3e066ad71ca675c7fcd:

  block: unexport bio_{set,check}_pages_dirty (2026-05-15 08:46:45 -0600)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/mdraid/linux.git tags/md-7.2-20260531

for you to fetch changes up to 717359a168bb66ac95f6161715d17e491ee86ca7:

  md/raid0: use str_plural helper in dump_zones (2026-05-31 19:09:20 +0800)

----------------------------------------------------------------
Abd-Alrhman Masalkhi (5):
      md: skip redundant raid_disks update when value is unchanged
      md/raid1,raid10: fix deadlock in read error recovery path
      md/raid1,raid10: fix error-path detection with md_cloned_bio()
      md/raid1,raid10: fix bio accounting for split md cloned bios
      raid1: fix nr_pending leak in REQ_ATOMIC bad-block error path

Benjamin Marzinski (1):
      dm-raid: only requeue bios when dm is suspending

Chen Cheng (1):
      md/raid10: reset read_slot when reusing r10bio for discard

Christoph Hellwig (2):
      md/raid1: cleanup handle_read_error
      md/raid1: move the exceed_read_errors condition out of fix_read_error

Li Nan (1):
      MAINTAINERS: Update Li Nan's E-mail address

Thorsten Blum (1):
      md/raid0: use str_plural helper in dump_zones

Yu Kuai (1):
      MAINTAINERS: update Yu Kuai's email address

 MAINTAINERS          |  6 ++---
 drivers/md/dm-raid.c |  6 +++++
 drivers/md/md.c      | 32 ++++++++++++++++----------
 drivers/md/md.h      |  7 ++++++
 drivers/md/raid0.c   |  3 ++-
 drivers/md/raid1.c   | 63 ++++++++++++++++++++++++++++------------------------
 drivers/md/raid10.c  | 29 +++++++++++++++---------
 drivers/md/raid5.c   |  7 ++++--
 8 files changed, 96 insertions(+), 57 deletions(-)
