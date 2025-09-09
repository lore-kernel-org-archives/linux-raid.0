Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9ED51D5CD1;
	Tue,  9 Sep 2025 17:13:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757438014; cv=none; b=GCgMLWeOgtlw95SYEnp4hOrtY2RqFhS65wbA1Wi6yzTHUGqcXo/igV/yRr0fnxbQztK3g4a7UgILF/p2cvbj7hnNoZsRTBGP1TSruY17VAuyG4srrTVOE5rFdJWx8UD0hbJCEoBJW9BANkJtbsVxWn0eQ2H1IoWbR4IgjMo9Uk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757438014; c=relaxed/simple;
	bh=F/1KmH6Ih2AiaeEpSd/DqRQpCrUv8zbxcwx5j1/Alf0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=oJiKGnkO6VzAX2IzFpa6ymk8Y2meqDi62WJq7jC9BsvdlREc5PKK1w2ysLBL4eQ9Q0xik9JtAX65MV6TL0aD977WNOL4U8PK1Ir1Kf99UFY4Qg2eXsi0RTlZskDKXXlw+TQJ/k034aWfKG1dM1L9HAtcOshRg7z/NbNnkJOCypU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lWHpsHRr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lWHpsHRr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21A84C4CEF4;
	Tue,  9 Sep 2025 17:13:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757438012;
	bh=F/1KmH6Ih2AiaeEpSd/DqRQpCrUv8zbxcwx5j1/Alf0=;
	h=From:To:Cc:Subject:Date:From;
	b=lWHpsHRrNiCYuwo7o/GaIHoR9MIkRDuM1IVT/I5CSRTlsJT34IIWfujCErIIjy47J
	 uNDLYM7osJIEFLRvkGe4JFKB0G9yuLDdALyrfc+evwAavtaSLylqYO8kUxikDbO7Lz
	 si1vDMxABmCGh9X3PBSynUXPWL3IrDaAJh4YKMlyyWudfElamcpmXbRKAeCHE5alHz
	 pHAKJU2+gdiQatBSgfb52xdGLl6p4/BV7ATlDQc3RgqmxJhtqkhTf9vKNU/+GMFMoD
	 lKAQoqcqhNqWR0wDyGUsW0hm+9XmQP5rtJYWtxX1g1aPVTP+xvv6kwfC4fH7qAj6js
	 xHJKugZe7nOIg==
From: Yu Kuai <yukuai@kernel.org>
To: axboe@kernel.dk,
	linux-block@vger.kernel.org,
	linux-raid@vger.kernel.org
Cc: linan122@huawei.com,
	xni@redhat.com,
	colyli@kernel.org,
	yukuai3@huawei.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com,
	johnny.chenyi@huawei.com
Subject: [GIT PULL v2] md-6.18-20250909
Date: Wed, 10 Sep 2025 01:13:28 +0800
Message-ID: <20250909171328.2691074-1-yukuai@kernel.org>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi, Jens

Redundant data is used to enhance data fault tolerance, and the storage
method for redundant data vary depending on the RAID levels. And it's
important to maintain the consistency of redundant data.

Bitmap is used to record which data blocks have been synchronized and which
ones need to be resynchronized or recovered. Each bit in the bitmap
represents a segment of data in the array. When a bit is set, it indicates
that the multiple redundant copies of that data segment may not be
consistent. Data synchronization can be performed based on the bitmap after
power failure or readding a disk. If there is no bitmap, a full disk
synchronization is required.

Due to known performance issues with md-bitmap and the unreasonable
implementations:

 - self-managed IO submitting like filemap_write_page();
 - global spin_lock
 - ...

I have decided not to continue optimizing based on the current bitmap
implementation, this new bitmap is invented without locking from IO fast
path and can be used with fast disks.

Key features for the new bitmap:
 - IO fastpath is lockless, if user issues lots of write IO to the same
   bitmap bit in a short time, only the first write has additional 
   overhead to update bitmap bit, no additional overhead for the following
   writes;
 - support only resync or recover written data, means in the case creating
   new array or replacing with a new disk, there is no need to do a full
   disk resync/recovery;

Please consider pulling following changes on your for-6.18/block branch,
this pull request contains:

  - add kconfig for internal bitmap, this is for isolation;
  - introduce new experimental feature lockless bitmap(details in [1]);

[1] https://lore.kernel.org/linux-raid/20250829080426.1441678-12-yukuai1@huaweicloud.com/

The following changes since commit ba28afbd9eff2a6370f23ef4e6a036ab0cfda409:

  blk-mq: fix blk_mq_tags double free while nr_requests grown (2025-09-05 13:52:52 -0600)

are available in the Git repository at:

  git@gitolite.kernel.org:pub/scm/linux/kernel/git/mdraid/linux.git tags/md-6.18-20250909

for you to fetch changes up to 5ab829f1971dc99f2aac10846c378e67fc875abc:

  md/md-llbitmap: introduce new lockless bitmap (2025-09-06 17:27:51 +0800)

----------------------------------------------------------------
Yu Kuai (24):
      md/md-bitmap: remove the parameter 'init' for bitmap_ops->resize()
      md/md-bitmap: merge md_bitmap_group into bitmap_operations
      md/md-bitmap: add a new parameter 'flush' to bitmap_ops->enabled
      md/md-bitmap: add md_bitmap_registered/enabled() helper
      md/md-bitmap: handle the case bitmap is not enabled before start_sync()
      md/md-bitmap: handle the case bitmap is not enabled before end_sync()
      md/raid1: check bitmap before behind write
      md/raid1: check before referencing mddev->bitmap_ops
      md/raid10: check before referencing mddev->bitmap_ops
      md/raid5: check before referencing mddev->bitmap_ops
      md/dm-raid: check before referencing mddev->bitmap_ops
      md: check before referencing mddev->bitmap_ops
      md/md-bitmap: introduce CONFIG_MD_BITMAP
      md: add a new parameter 'offset' to md_super_write()
      md: factor out a helper raid_is_456()
      md/md-bitmap: support discard for bitmap ops
      md: add a new mddev field 'bitmap_id'
      md/md-bitmap: add a new sysfs api bitmap_type
      md/md-bitmap: delay registration of bitmap_ops until creating bitmap
      md/md-bitmap: add a new method skip_sync_blocks() in bitmap_operations
      md/md-bitmap: add a new method blocks_synced() in bitmap_operations
      md: add a new recovery_flag MD_RECOVERY_LAZY_RECOVER
      md/md-bitmap: make method bitmap_ops->daemon_work optional
      md/md-llbitmap: introduce new lockless bitmap

 Documentation/admin-guide/md.rst |   86 +++-
 drivers/md/Kconfig               |   29 ++
 drivers/md/Makefile              |    4 +-
 drivers/md/dm-raid.c             |   18 +-
 drivers/md/md-bitmap.c           |   89 ++--
 drivers/md/md-bitmap.h           |  107 ++++-
 drivers/md/md-cluster.c          |    2 +-
 drivers/md/md-llbitmap.c         | 1626 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/md/md.c                  |  378 ++++++++++++---
 drivers/md/md.h                  |   24 +-
 drivers/md/raid1-10.c            |    2 +-
 drivers/md/raid1.c               |   79 ++--
 drivers/md/raid10.c              |   49 +-
 drivers/md/raid5.c               |   64 ++-
 14 files changed, 2313 insertions(+), 244 deletions(-)
 create mode 100644 drivers/md/md-llbitmap.c

