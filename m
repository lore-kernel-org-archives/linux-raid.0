Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AC3A1D47B4
	for <linux-raid@vger.kernel.org>; Tue, 13 May 2025 02:40:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747104021; cv=none; b=ntxtXg5W0FNd928VIuqYxUNMMIrzJok7j7t+B9sKRU7j9v1R1IwvE0AvQLtWqhAqJ+XpNePH/FkX4AlLrlol8yB2Fex1syjzetGZAn6nGno2ivnSWrdoW83xoqPMgu6qc87/r8wVVKoaoA1iRnEHu4LBMDxwCJvFztwFScS0FTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747104021; c=relaxed/simple;
	bh=NBcNwbbWHWVAZ9WyeoJv+J5a6eRJdj3bRa/t37aBANY=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ph9pHX35DLIvzUpkeB/6rTEM61naKC2J4/EUO3SmahLABVTZ3AwQsJdYoPXZIAUn3RBQTq6FYJcDig/KiVXLMj8vpn9FcUdDLbk36UCZbCVGRJZsx+pt/zSU0Cxdn9LRdUMqxPTwvHXS6rlRH8qbv+/pgfVOzooGavt0YwMcfB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4ZxLKk6zcfz4f3jt9
	for <linux-raid@vger.kernel.org>; Tue, 13 May 2025 10:39:54 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 7B93D1A1ADA
	for <linux-raid@vger.kernel.org>; Tue, 13 May 2025 10:40:14 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgB3218KsSJoiyH_MA--.17456S4;
	Tue, 13 May 2025 10:40:12 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: axboe@kernel.dk,
	linux-raid@vger.kernel.org,
	song@kernel.org
Cc: yukuai3@huawei.com,
	yangerkun@huawei.com,
	yi.zhang@huawei.com,
	johnny.chenyi@huawei.com
Subject: [GIT PULL v2] md-6.16-20250513
Date: Tue, 13 May 2025 10:31:36 +0800
Message-Id: <20250513023136.3180079-1-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgB3218KsSJoiyH_MA--.17456S4
X-Coremail-Antispam: 1UD129KBjvJXoW7uFW8Zw4UAr4rKrWrCFyxAFb_yoW8Aw1rpr
	W3GFy3Jr48Jr13ZF43Jw47ZF1rtws5Gry3XF17C34rJFyYvFyjvr48KFZ2gr93XrZ3JF42
	gw1rGFyDKF1UGFDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUyKb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Cr0_Gr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I
	0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
	x7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
	0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lc7CjxVAaw2AFwI0_JF0_Jw1l42xK82IYc2Ij
	64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x
	8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIYrxkI7VAKI48JMIIF0xvE
	2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42
	xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF
	7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxUwxhLUUUUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi Jens,

Please consider pulling following changes for md-6.16 on your for-6.16/block
branch, this pull request contains:

- fix normal IO can be starved by sync IO, found by mkfs on newly created
large raid5, with some clean up patches for bdev inflight counters;

Thanks
Kuai

The following changes since commit 824afb9b04648ea11531fc9047923ec07e7a943d:

  block: move removing elevator after deleting disk->queue_kobj (2025-05-08 09:03:44 -0600)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/mdraid/linux.git tags/md-6.16-20250513

for you to fetch changes up to 752d0464b78a5b28682256ed7a057106119e1d1a:

  md: clean up accounting for issued sync IO (2025-05-10 16:14:22 +0800)

----------------------------------------------------------------
Changes in v2
 - remove the set to add kconfig for md-bitmap, it has build problems if
 md-mod is build as module;

Yu Kuai (9):
      blk-mq: remove blk_mq_in_flight()
      block: reuse part_in_flight_rw for part_in_flight
      block: WARN if bdev inflight counter is negative
      block: clean up blk_mq_in_flight_rw()
      block: export API to get the number of bdev inflight IO
      md: record dm-raid gendisk in mddev
      md: add a new api sync_io_depth
      md: fix is_mddev_idle()
      md: clean up accounting for issued sync IO

 block/blk-core.c          |   2 +-
 block/blk-mq.c            |  22 ++----
 block/blk-mq.h            |   5 +-
 block/blk.h               |   1 -
 block/genhd.c             |  69 ++++++++++-------
 drivers/md/dm-raid.c      |   3 +
 drivers/md/md.c           | 190 ++++++++++++++++++++++++++++++++--------------
 drivers/md/md.h           |  18 ++---
 drivers/md/raid1.c        |   3 -
 drivers/md/raid10.c       |   9 ---
 drivers/md/raid5.c        |   8 --
 include/linux/blkdev.h    |   1 -
 include/linux/part_stat.h |   2 +
 13 files changed, 191 insertions(+), 142 deletions(-)

