Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5FAB262A6;
	Fri, 18 Apr 2025 01:16:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744939013; cv=none; b=ce3b1QKx0TQqMKQAWF6KTD4TiyluZ3yw2bQspr3DiLrMoAu2e9tvvcayhvBG4VQQSVOqeGBQiOML3hVLAeveb2ZvEJrJvQ3jNYMk28gzBD6RMXOfwUfcVw+6Zp31siHKp4H6ex3e9MRdSrFbHpj8k8s4Pe89145X4k7Tbs04vJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744939013; c=relaxed/simple;
	bh=hPc6DBVAgHf3AAvxQmsrwxhdgE3m6XoH1iucbIr/omo=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=aEvpRe+zRUcPRZP5CLHaEDVQ39mJ2XESarSzgRWRreoA03EvkTmXLSLpmZHZOII3FtMfHz2cXLBUh1BD2o1Gmgl32uwaCQECd7CTAC7mSiFmEagTSgZbzKyAZPHtvy9giQjQgfJ/OZDDZ4wofg/2jnpug89ufsHkC5F37CE2+io=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4Zdxfv2zyhz4f3kFM;
	Fri, 18 Apr 2025 09:16:23 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 2CFD71A06D7;
	Fri, 18 Apr 2025 09:16:47 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgDHK2D8pwFoK5w2Jw--.18201S4;
	Fri, 18 Apr 2025 09:16:46 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: axboe@kernel.dk,
	xni@redhat.com,
	agk@redhat.com,
	snitzer@kernel.org,
	mpatocka@redhat.com,
	song@kernel.org,
	yukuai3@huawei.com,
	viro@zeniv.linux.org.uk,
	akpm@linux-foundation.org,
	nadav.amit@gmail.com,
	ubizjak@gmail.com,
	cl@linux.com
Cc: linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	dm-devel@lists.linux.dev,
	linux-raid@vger.kernel.org,
	yukuai1@huaweicloud.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com,
	johnny.chenyi@huawei.com
Subject: [PATCH v2 0/5] md: fix is_mddev_idle()
Date: Fri, 18 Apr 2025 09:09:36 +0800
Message-Id: <20250418010941.667138-1-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgDHK2D8pwFoK5w2Jw--.18201S4
X-Coremail-Antispam: 1UD129KBjvdXoW7XrW8ZFWkGryxuF1rtw17trb_yoW3Krg_ua
	ykZFy3tF4xX3W3Aa43tF13ZrWjkrWxW3ykuFyUtrZIva4fXF1UK3y5Cw4Yq3W5WFZrua15
	Jry8XrW8Ar4xXjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUb3kFF20E14v26ryj6rWUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
	A2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j
	6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
	Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
	I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r
	4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628v
	n2kIc2xKxwCY1x0262kKe7AKxVW8ZVWrXwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7x
	kEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E
	67AF67kF1VAFwI0_GFv_WrylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCw
	CI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1x
	MIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIda
	VFxhVjvjDU0xZFpf9x0pRHUDLUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

Changes in v2:
 - more cleanps in patch 1;
 - add patch 2, to record dm-raid gendisk, and also handle dm-raid in
 patch 4;
 - keep the old commnts in patch 3;

Yu Kuai (5):
  block: cleanup and export bdev IO inflight APIs
  md: record dm-raid gendisk in mddev
  md: add a new api sync_io_depth
  md: fix is_mddev_idle()
  md: cleanup accounting for issued sync IO

 block/blk-core.c          |   2 +-
 block/blk-mq.c            |  15 +--
 block/blk-mq.h            |   7 +-
 block/blk.h               |   1 -
 block/genhd.c             |  48 +++++-----
 drivers/md/dm-raid.c      |   3 +
 drivers/md/md.c           | 193 +++++++++++++++++++++++++++-----------
 drivers/md/md.h           |  18 +---
 drivers/md/raid1.c        |   3 -
 drivers/md/raid10.c       |   9 --
 drivers/md/raid5.c        |   8 --
 include/linux/blkdev.h    |   1 -
 include/linux/part_stat.h |  10 ++
 13 files changed, 184 insertions(+), 134 deletions(-)

-- 
2.39.2

