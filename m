Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BC31225D6
	for <linux-raid@vger.kernel.org>; Thu, 13 Mar 2025 02:29:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741832990; cv=none; b=Tv4UbECoY4zNYyUavUN+2hGG/XNfHFMlPlkjci2jWWKxTB5fJ2yak9qhlj2XfHBLjY5DnzygmrSg1hEcyzgVA+UKv6P4NXGO2D4x77edriNJYUWKIwfXpqaR5JLiZWiAoF/BEDwHWiHs4O4cHHnjICxbUqtjCZFjY2dYMEiM2uA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741832990; c=relaxed/simple;
	bh=mRu2wMy2e4P0SiW8VuKs9zmoALuxkTpHfCMfS9HLZtY=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=cPDN7yZ41lVhVimO4Y4u0L1HsvtTMvXFx/ULicD23H9ju52516igGTGji4FqOXv8XqsDHAD7B7pwkgSvCk9kzJJhQmDflGNi+odnI/nJltLjcvg1/8za+kryB8Fc0NHp5sKdkc/OOVIT9g33ZAK89s25lLkQPB4dXT7lRAKvi7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4ZCrzj6hCZz4f3jYH
	for <linux-raid@vger.kernel.org>; Thu, 13 Mar 2025 10:29:21 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 5918E1A06D7
	for <linux-raid@vger.kernel.org>; Thu, 13 Mar 2025 10:29:44 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgB32l4VQ9JnwSBZGQ--.42606S4;
	Thu, 13 Mar 2025 10:29:42 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: axboe@kernel.dk,
	linux-raid@vger.kernel.org,
	song@kernel.org,
	yukuai3@huawei.com
Cc: xni@redhat.com,
	glass.su@suse.com,
	zhengqixing@huawei.com,
	linan122@huawei.com,
	yangerkun@huawei.com,
	yi.zhang@huawei.com
Subject: [GIT PULL] md-6.15-20250312
Date: Thu, 13 Mar 2025 10:24:45 +0800
Message-Id: <20250313022445.2229190-1-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgB32l4VQ9JnwSBZGQ--.42606S4
X-Coremail-Antispam: 1UD129KBjvJXoW7ZrWUtw4kCFyfury3GF4kWFg_yoW8tF4fpF
	y3Gry3Zw15J3s7JFs3ArW09FyrAw18W3y7K343J395GF98uFWDAw4UAa95Gr9rWFyfJr1S
	qryUG3yDW3WrJaUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvYb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Cr0_Gr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I
	0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
	x7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
	0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lFIxGxcIEc7CjxVA2Y2ka0xkIwI1lc7CjxVAa
	w2AFwI0_Jw0_GFyl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxV
	Aqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q
	6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6x
	kF7I0E14v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AK
	xVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r1j6r4UYxBIdaVFxhVjvjDU0xZFpf9x07
	UAwIDUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi Jens,

Please consider pulling the following changes for md-6.15 on your
for-6.15/block branch, this pull request contains:

- fix recovery can preempt resync (Li Nan)
- fix md-bitmap IO limit (Su Yue)
- fix raid10 discard with REQ_NOWAIT (Xiao Ni)
- fix raid1 memory leak (Zheng Qixing)
- fix mddev uaf (Yu Kuai)
- fix raid1,raid10 IO flags (Yu Kuai)
- some refactor and cleanup (Yu Kuai)

Thanks,
Kuai

The following changes since commit a052bfa636bb763786b9dc13a301a59afb03787a:

  block: refactor rq_qos_wait() (2025-02-11 13:04:11 -0700)

are available in the Git repository at:
  https://git.kernel.org/pub/scm/linux/kernel/git/mdraid/linux.git tags/md-6.15-20250312

for you to fetch changes up to 3db4404435397a345431b45f57876a3df133f3b4:

  md/raid10: wait barrier before returning discard request with REQ_NOWAIT (2025-03-06 22:34:20 +0800)

----------------------------------------------------------------
Li Nan (1):
      md: ensure resync is prioritized over recovery

Su Yue (1):
      md/md-bitmap: fix wrong bitmap_limit for clustermd when write sb

Xiao Ni (1):
      md/raid10: wait barrier before returning discard request with REQ_NOWAIT

Yu Kuai (10):
      md: merge common code into find_pers()
      md: only include md-cluster.h if necessary
      md: introduce struct md_submodule_head and APIs
      md: switch personalities to use md_submodule_head
      md/md-cluster: cleanup md_cluster_ops reference
      md: don't export md_cluster_ops
      md: switch md-cluster to use md_submodle_head
      md: fix mddev uaf while iterating all_mddevs list
      md/raid5: merge reshape_progress checking inside get_reshape_loc()
      md/raid1,raid10: don't ignore IO flags

Zheng Qixing (1):
      md/raid1: fix memory leak in raid1_run() if no active rdev

 drivers/md/md-bitmap.c  |  14 ++-
 drivers/md/md-cluster.c |  18 ++-
 drivers/md/md-cluster.h |   6 +
 drivers/md/md-linear.c  |  15 ++-
 drivers/md/md.c         | 295 ++++++++++++++++++++++++------------------------
 drivers/md/md.h         |  48 +++++---
 drivers/md/raid0.c      |  18 +--
 drivers/md/raid1-10.c   |   4 +-
 drivers/md/raid1.c      |  46 ++++----
 drivers/md/raid10.c     |  52 ++++-----
 drivers/md/raid5.c      |  91 ++++++++++-----
 11 files changed, 338 insertions(+), 269 deletions(-)

