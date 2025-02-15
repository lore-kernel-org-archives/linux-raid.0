Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6853319D8A2;
	Sat, 15 Feb 2025 09:25:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739611560; cv=none; b=VidqKqumXpWhqjPgCJ2d0qAWWBk3MUqN019VGro7q8CMUwnPiJkKFl8i6mF4SkdzMwXXWO1rllr+8U2lAK2llDA3WthuW9NHC3JHczRwzol1jmAwMwZC4tdx8yQPBjhFslLKVLuZU8Hx7cfBkoXCyrKwoazC+EoI+tECxjFSVX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739611560; c=relaxed/simple;
	bh=DjWLiNorl5ume31k8GQXKZ1BFIOrFPSqhdTJ3sEpNYY=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ARHyo2QE0JZ1fl90cPv0VD9mZGgVBBqBSqgf3+cu+ts50u/zv0+IDmX7q8QM9KC0XemVHJl7pEG89KeD8gGjZlFklmcQgpCCInDkJp4XgUVQoBz7JkiTDMJfU2hE+pA5VJDYE8MsKzFI2qsG1KVEeVwwDMLKEqFwrYg5hWxFSew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4Yw3Rq752Mz4f3jY2;
	Sat, 15 Feb 2025 17:25:27 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 6F3581A1405;
	Sat, 15 Feb 2025 17:25:49 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgAni1+bXbBn+Q+iDw--.49525S4;
	Sat, 15 Feb 2025 17:25:49 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: song@kernel.org,
	yukuai3@huawei.com
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	yukuai1@huaweicloud.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com
Subject: [PATCH 0/7 md-6.15] md: introduce md_submodle_head
Date: Sat, 15 Feb 2025 17:22:18 +0800
Message-Id: <20250215092225.2427977-1-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgAni1+bXbBn+Q+iDw--.49525S4
X-Coremail-Antispam: 1UD129KBjvdXoWrZw4kuF1DXFW3JFW8KFy3urg_yoWDZwc_ZF
	yYqFy3JryUXF17Ga4fXrsxZrWkAr4vvr1vqF9Fg3yrZw13Ww47Gr109w47Xw18uFyjvan8
	Xr18Gw1Fy340qjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUb48FF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
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
	MIIF0xvEx4A2jsIEc7CjxVAFwI0_Jr0_GrUvcSsGvfC2KfnxnUUI43ZEXa7VUbSfO7UUUU
	U==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

This set introduce md_submodle_head and related API to replace
personality and md-cluter registration, and remove lots of exported
helpers and global variables.

Also prepare to add kconfig for md-bitmap.

Yu Kuai (7):
  md: merge common code into find_pers()
  md: only include md-cluster.h if necessary
  md: introduce struct md_submodule_head and APIs
  md: switch personalities to use md_submodule_head
  md/md-cluster: cleanup md_cluster_ops reference
  md: don't export md_cluster_ops
  md: switch md-cluster to use md_submodle_head

 drivers/md/md-bitmap.c  |   8 +-
 drivers/md/md-cluster.c |  18 ++-
 drivers/md/md-cluster.h |   6 +
 drivers/md/md-linear.c  |  15 ++-
 drivers/md/md.c         | 259 +++++++++++++++++++---------------------
 drivers/md/md.h         |  48 +++++---
 drivers/md/raid0.c      |  18 +--
 drivers/md/raid1-10.c   |   4 +-
 drivers/md/raid1.c      |  33 ++---
 drivers/md/raid10.c     |  41 ++++---
 drivers/md/raid5.c      |  70 +++++++----
 11 files changed, 297 insertions(+), 223 deletions(-)

-- 
2.39.2

