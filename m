Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72FB7202989;
	Tue,  4 Mar 2025 12:23:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741091029; cv=none; b=p6g/Sx0ibzJHSp2aum0tSdKE7UYJ0f3bq/lvUfMFE5frcOiy9zHMiczztFlQcpL4QoOA1mxhz4fFPY2wrQZEO3+EodUE87WevoAqvQm7j0jj0hw+04ns394y9gjNMvvD1IZ/VWtTycbpQs+gLM9+9SxBH22wrhmvDxS6bryi4b0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741091029; c=relaxed/simple;
	bh=pWshvVmBkQMHMkEWSSjIe2vFXhFvF8yhVtksQUs+I9I=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=WGgwECAUowkr+38EAawweeV+HHvqXf3hZmk5hF0vKa+bHp2E26fi7E0/seko/q7bvoK29EaWa/dbsrSvjPlZy04aCTRgLpLcDfZQ0dJDU1O9XEtAIJrmO/ipCtPLkjejfyvMnzGOqN4cw/ppnXn7NQ99eVI5hQf45/+4J0yMIfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4Z6ZbF34q3z4f3jch;
	Tue,  4 Mar 2025 20:23:21 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 7DD7C1A0DEB;
	Tue,  4 Mar 2025 20:23:43 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgB321_O8MZnFO8VFg--.52907S4;
	Tue, 04 Mar 2025 20:23:43 +0800 (CST)
From: linan666@huaweicloud.com
To: axboe@kernel.dk,
	song@kernel.org,
	yukuai3@huawei.com,
	hare@suse.de,
	martin.petersen@oracle.com
Cc: linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-raid@vger.kernel.org,
	linan666@huaweicloud.com,
	yangerkun@huawei.com,
	zhangxiaoxu5@huawei.com,
	wanghai38@huawei.com
Subject: [PATCH 0/4] bugfix of logical_block_size and make it configurable
Date: Tue,  4 Mar 2025 20:19:14 +0800
Message-Id: <20250304121918.3159388-1-linan666@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgB321_O8MZnFO8VFg--.52907S4
X-Coremail-Antispam: 1UD129KBjvdXoW7GrWftr4ktFyrWFy7tw18Krg_yoWxtwb_Ja
	yxXFWftrn7WF17ZFy5Wr4fZry2kF4kurykZFnxKrWavr13Zr1UG3WjvrWUXw1DWFyjqF15
	Jr18J34rAr4DWjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbDxFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
	A2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j
	6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
	Cq3wAac4AC62xK8xCEY4vEwIxC4wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC
	0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUGVWUXwAv7VC2z280aVAFwI0_Jr0_Gr
	1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IE
	rcIFxwACI402YVCY1x02628vn2kIc2xKxwAKzVCY07xG64k0F24lc7CjxVAaw2AFwI0_Jw
	0_GFyl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AK
	xVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrx
	kI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v2
	6r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8Jw
	CI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjfUrwZ2DUUU
	U
X-CM-SenderInfo: polqt0awwwqx5xdzvxpfor3voofrz/

From: Li Nan <linan122@huawei.com>

Li Nan (4):
  block: factor out a helper to set logical/physical block size
  md: make raid logical_block_size configurable
  md: prevent adding disks with larger logical_block_size to active
    arrays
  md: Fix the return value of mddev_stack_new_rdev

 drivers/md/md.h                |  1 +
 include/linux/blkdev.h         |  2 +
 include/uapi/linux/raid/md_p.h |  6 ++-
 block/blk-settings.c           | 85 +++++++++++++++++++---------------
 drivers/md/md-linear.c         |  1 +
 drivers/md/md.c                | 83 ++++++++++++++++++++++++++++++++-
 drivers/md/raid0.c             |  1 +
 drivers/md/raid1.c             |  1 +
 drivers/md/raid10.c            |  1 +
 drivers/md/raid5.c             |  1 +
 10 files changed, 142 insertions(+), 40 deletions(-)

-- 
2.39.2

