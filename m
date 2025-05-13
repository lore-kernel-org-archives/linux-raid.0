Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80780128819
	for <linux-raid@vger.kernel.org>; Tue, 13 May 2025 01:47:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747100843; cv=none; b=JNHviVG7OZeW9LCzYyvNenXx/rQt/Fyju7EbPtTfWKh7jcE0j3gr1C9W1275pe5cFBCEJd8OQ3UDbL3SqH+q/tOHU0+YE8exTm6E0W+a7Kz6o9WlFfOdHdkHPN8wu3uwIQEMb2ntTRarv4hne8+BNxmgeJ7k1tXUaykqpb7/gco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747100843; c=relaxed/simple;
	bh=/QsYIu/rOFscapxFR46TmF4xE2l5Xba9LORvt+UDZxA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=EajhaMZ8iMNCo1w6GT8/s2XDC2nVelSkMk2HKwXb/WwUEWDYhCS+UAt6dk7/6Figf8paHrIX9/f4WHsjp9yxvFvpjUMCg2bniHivt6QJ0gXGULCVQc2H1BuvBJ2YHU2x9+cerGGIZSAk+ztV4s+RihdQh41x2fWthBwR4qlB9EA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4ZxK8S0D18z4f3kvh
	for <linux-raid@vger.kernel.org>; Tue, 13 May 2025 09:46:48 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 3D1F41A18D1
	for <linux-raid@vger.kernel.org>; Tue, 13 May 2025 09:47:14 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgBXu1+fpCJoEVv7MA--.13695S4;
	Tue, 13 May 2025 09:47:12 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: axboe@kernel.dk,
	linux-raid@vger.kernel.org,
	song@kernel.org
Cc: yukuai3@huawei.com,
	yangerkun@huawei.com,
	yi.zhang@huawei.com,
	johnny.chenyi@huawei.com
Subject: [GIT PULL] md-6.16-20250512
Date: Tue, 13 May 2025 09:38:37 +0800
Message-Id: <20250513013837.4067413-1-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgBXu1+fpCJoEVv7MA--.13695S4
X-Coremail-Antispam: 1UD129KBjvJXoWxGrW5Cw4fAFy5Ar43uF4fuFg_yoW5Wr48p3
	9xJa43Zw1rJFW3ZF13J3yUuF1Fqw1kKr9IkryxC3WruFyUZFy3Jr48GFsYv3s2qryxXanF
	qr15GF1DGF1UWaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUyKb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JMxkF7I0En4kS14v26r126r1DMxAIw28IcxkI
	7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxV
	Cjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUAVWUtwCIc40Y0x0EwIxGrwCI42IY
	6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6x
	AIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY
	1x0267AKxVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvjxUwxhLUUUUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi Jens,

Please consider pulling following changes for md-6.6 on your for-6.16/block
branch, this pull request contains:

- fix normal IO can be starved by sync IO, found by mkfs on newly created
large raid5, with some clean up patches for bdev inflight counters;
- add kconfig for md-bitmap, I have decided not to continue optimizing
based on the old bitmap implementation, and plan to invent a new lock-less
bitmap. And a new kconfig option is a good way for isolation;

Thanks
Kuai

The following changes since commit 824afb9b04648ea11531fc9047923ec07e7a943d:

  block: move removing elevator after deleting disk->queue_kobj (2025-05-08 09:03:44 -0600)

are available in the Git repository at:

  https://kernel.googlesource.com/pub/scm/linux/kernel/git/mdraid/linux.git tags/md-6.16-20250512

for you to fetch changes up to 1b7bf4c5c5eb07ae05a3ca9126a1ae27c1905361:

  md/md-bitmap: introduce CONFIG_MD_BITMAP (2025-05-10 17:23:51 +0800)

----------------------------------------------------------------
Yu Kuai (20):
      blk-mq: remove blk_mq_in_flight()
      block: reuse part_in_flight_rw for part_in_flight
      block: WARN if bdev inflight counter is negative
      block: clean up blk_mq_in_flight_rw()
      block: export API to get the number of bdev inflight IO
      md: record dm-raid gendisk in mddev
      md: add a new api sync_io_depth
      md: fix is_mddev_idle()
      md: clean up accounting for issued sync IO
      md/md-bitmap: remove the parameter 'init' for bitmap_ops->resize()
      md/md-bitmap: merge md_bitmap_group into bitmap_operations
      md/md-bitmap: add md_bitmap_registered/enabled() helper
      md/md-bitmap: handle the case bitmap is not enabled before start_sync()
      md/md-bitmap: handle the case bitmap is not enabled before end_sync()
      md/raid1: check bitmap before behind write
      md/raid1: check before referencing mddev->bitmap_ops
      md/raid10: check before referencing mddev->bitmap_ops
      md/raid5: check before referencing mddev->bitmap_ops
      md: check before referencing mddev->bitmap_ops
      md/md-bitmap: introduce CONFIG_MD_BITMAP

 block/blk-core.c          |   2 +-
 block/blk-mq.c            |  22 +---
 block/blk-mq.h            |   5 +-
 block/blk.h               |   1 -
 block/genhd.c             |  69 ++++++-----
 drivers/md/Kconfig        |  18 +++
 drivers/md/Makefile       |   3 +-
 drivers/md/dm-raid.c      |   5 +-
 drivers/md/md-bitmap.c    |  67 +++++-----
 drivers/md/md-bitmap.h    |  62 +++++++++-
 drivers/md/md-cluster.c   |   2 +-
 drivers/md/md.c           | 302 ++++++++++++++++++++++++++++++++--------------
 drivers/md/md.h           |  22 +---
 drivers/md/raid1-10.c     |   2 +-
 drivers/md/raid1.c        |  82 +++++++------
 drivers/md/raid10.c       |  57 ++++-----
 drivers/md/raid5.c        |  38 +++---
 include/linux/blkdev.h    |   1 -
 include/linux/part_stat.h |   2 +
 19 files changed, 472 insertions(+), 290 deletions(-)

