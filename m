Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 076F81D9A45;
	Thu, 24 Oct 2024 13:16:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729775784; cv=none; b=jNLQGOCq5P6doy9SqHG6vxvRdljGaQPKqJQdUSCNKO7zi/A1QMtQ0f0ucEAJFhRq8BiAbqhi9YQRvrJk+TQSkL1FgFMtuTdqjZeNyn6cdK1DBjylR+LY7F7XZ560nVax/hRWISMRgsulKIGadwCmYqMAy9APprKpswe0xUMekSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729775784; c=relaxed/simple;
	bh=evmzszi6icGYXHFQFK3hjxRpWK7BsMcnQobZ22/fZiI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=VX3nbDVPQHKWcfwNCTGldJVqMUIxFLqnFCAPBs8/JG7BvKkmsIqzoAvwnFZus87haLhb2/oCMjub/rriDFK7cl3f1X9IiV7En6B3iF6fMMPW5Opx1CB/53Qk5/k5x3J0WGz1O7mhXEI257HZK2QglmrjaM49YRACxLzBP2dsaRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4XZ5yG6Lqfz4f3jLy;
	Thu, 24 Oct 2024 21:15:50 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 5B7D71A018D;
	Thu, 24 Oct 2024 21:16:08 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgCXysaWSBpnPGb6Ew--.10198S4;
	Thu, 24 Oct 2024 21:16:08 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: song@kernel.org
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	yukuai3@huawei.com,
	yukuai1@huaweicloud.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com
Subject: [PATCH RFC 0/4] md/md-bitmap: support to build md-bitmap as kernel module
Date: Thu, 24 Oct 2024 21:13:21 +0800
Message-Id: <20241024131325.2250880-1-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgCXysaWSBpnPGb6Ew--.10198S4
X-Coremail-Antispam: 1UD129KBjvdXoWrKryrKw45ur4fCFWftw17GFg_yoWDKFbE9w
	1vgFyftFyUGFy3AFy3Xr4Ivryjya1Dua4vqa1IgFWfZry3Z347Gr4ku3s2q3WrZFyUAFn8
	JryUtw4xAr4YgjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUb4xFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
	A2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j
	6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
	Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
	I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r
	4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCY1x0262kKe7AKxVWU
	AVWUtwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14
	v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1lIxkG
	c2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI
	0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4U
	MIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUBVbkUUU
	UU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

Now that all implementations are internal, it's sensible to build it as
kernel module now.

Currently, if md-bitmap is build as module and the module is not loaded,
creating new array will try to load the module, regardless that bitmap
is used or not. There are still lots of cleanups to prevent
deferencing "mddev->bitmap_ops" for the array without bitmap.

Yu Kuai (4):
  md/md-bitmap: remove the parameter 'init' for bitmap_ops->resize()
  md/md-bitmap: merge md_bitmap_group into bitmap_operations
  md: export some helpers
  md/md-bitmap: support to build md-bitmap as kernel module

 drivers/md/Kconfig      |  15 +++++
 drivers/md/Makefile     |   4 +-
 drivers/md/dm-raid.c    |   2 +-
 drivers/md/md-bitmap.c  |  38 +++++++++++--
 drivers/md/md-bitmap.h  |  13 +++--
 drivers/md/md-cluster.c |   2 +-
 drivers/md/md.c         | 118 +++++++++++++++++++++++++++++++++-------
 drivers/md/md.h         |  12 +++-
 drivers/md/raid1.c      |   2 +-
 drivers/md/raid10.c     |   8 +--
 drivers/md/raid5.c      |   2 +-
 11 files changed, 172 insertions(+), 44 deletions(-)

-- 
2.39.2

