Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87BD12185A6
	for <linux-raid@vger.kernel.org>; Fri, 30 May 2025 08:35:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748594160; cv=none; b=Qnjxn6Y2LNZNlD22aizcm3tubyuN2zOi9nXsYjpTkN7/CzwLGC5xFZKO3T+yRCYts0zEgA2eKr68kyWkuHGcig8Gi1czrrK6WZ8ArilJBeVQoBa1G0N5WXJsGY/z9GGVguGIqoF/CMnEc+VLrV7zBLd0X+6p74FvAFQQlggqlJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748594160; c=relaxed/simple;
	bh=vrbfrcClHRwqnmMNxJUCG4SVwGWO4fc/9q789YdeQjE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=CWSZQ1CUpBt7nVRvs1l+AsdYApOl/gZoSqVgs0ohaLEtKUjCVyhfeJDpNAbXoomuRg+F3eGgmsycLOTCNlS32OmLihMSo/l2ZRYBmwByGRerNx3BsaPJHiIdw6mmgMBnVuCwJc8iTcF9Tl92zP8wcgYTFIvLXMHE7ntPjWtJkcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4b7xQg4dF1zYQv6W
	for <linux-raid@vger.kernel.org>; Fri, 30 May 2025 16:35:55 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id B9AEA1A14CA
	for <linux-raid@vger.kernel.org>; Fri, 30 May 2025 16:35:54 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP1 (Coremail) with SMTP id cCh0CgD3XH3nbTloXoDyNg--.38682S4;
	Fri, 30 May 2025 16:35:53 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: axboe@kernel.dk,
	linux-raid@vger.kernel.org,
	song@kernel.org
Cc: yukuai3@huawei.com,
	yangerkun@huawei.com,
	yi.zhang@huawei.com,
	johnny.chenyi@huawei.com
Subject: [GIT PULL] md-6.16-20250530
Date: Fri, 30 May 2025 16:30:43 +0800
Message-Id: <20250530083043.1381901-1-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgD3XH3nbTloXoDyNg--.38682S4
X-Coremail-Antispam: 1UD129KBjvJXoW7uFW8tr1fKr4ftrWxur4fGrg_yoW8XF4rpr
	9xGry3Zw1rJr13XFnxAryUuFy5JrykJry7try7u34rAFyUZF12kr18GFy8Cr9rXFyxJF1Y
	qF45Jw1DWr18tFDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUyEb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
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
	1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7IU1veHDUUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi Jens,

Please consider pulling following changes for md-6.16 on your block-6.16
branch, this pull request contains:

- fix REQ_RAHEAD and REQ_NOWAIT IO err handling for raid1/10;
- fix max_write_behind setting for dm-raid;
- some minor cleanups;

Thanks
Kuai

The following changes since commit 39d86db34e41b96bd86f1955cd0ce6cd9c5fca4c:

  loop: add file_start_write() and file_end_write() (2025-05-27 10:14:26 -0600)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/mdraid/linux.git tags/md-6.16-20250530

for you to fetch changes up to 01bf468c4e086b2f52a0c9dfa677c6016fc915ae:

  md/md-bitmap: remove parameter slot from bitmap_create() (2025-05-30 15:47:23 +0800)

----------------------------------------------------------------
Yu Kuai (5):
      md/raid1,raid10: don't handle IO error for REQ_RAHEAD and REQ_NOWAIT
      md/md-bitmap: fix dm-raid max_write_behind setting
      md/dm-raid: remove max_write_behind setting limit
      md/md-bitmap: cleanup bitmap_ops->startwrite()
      md/md-bitmap: remove parameter slot from bitmap_create()

 drivers/md/dm-raid.c   |  6 +-----
 drivers/md/md-bitmap.c | 35 ++++++++++++++++++++++-------------
 drivers/md/md-bitmap.h | 17 ++++-------------
 drivers/md/md.c        | 14 +++++++-------
 drivers/md/raid1-10.c  | 10 ++++++++++
 drivers/md/raid1.c     | 19 ++++++++++---------
 drivers/md/raid10.c    | 11 ++++++-----
 7 files changed, 60 insertions(+), 52 deletions(-)

