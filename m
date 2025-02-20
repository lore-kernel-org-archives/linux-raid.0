Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2D941D5AB9
	for <linux-raid@vger.kernel.org>; Thu, 20 Feb 2025 03:23:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740021812; cv=none; b=V47LowtcCMEORAp3oeXuz9sKyMCHGKO3IO6J0r/uhh6YOfpACrmEf65g6Ur1htbah90DAmQN7YKG8++V6cIrOVr2z6vNkWjmqLQN+RQTnJo9MoYFi8h14IVB90v5x9bCvZ0XkejzocyV1erC2S3qaOXbCpLEUa7HmsRFOCPXu3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740021812; c=relaxed/simple;
	bh=L1eElmFW4csMIoRPgPC8Gq6GByLhfoTjx2xbSLKoTGU=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Wgs7geIVz1BVK4WfgJINzC9//dCGHrk8w5kFsnQoumdr68TAw321lw24v7tOmNurvn64+a/z5ZnH/c4OIWoFxlFTFceJF73vDW8FfTBpovlNx5SJfJNMEQWscP/k35IBe1wXW9KWRqdNTNBtqWR3J1Gbeo+xhmyo4u2UumWd7CA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4Yyz9R5ZlJz4f3jt3
	for <linux-raid@vger.kernel.org>; Thu, 20 Feb 2025 11:23:07 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 1A3A21A1492
	for <linux-raid@vger.kernel.org>; Thu, 20 Feb 2025 11:23:24 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgB3218ooLZnItZpEQ--.54744S4;
	Thu, 20 Feb 2025 11:23:21 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: axboe@kernel.dk,
	linux-raid@vger.kernel.org
Cc: bvanassche@acm.org,
	song@kernel.org,
	yukuai3@huawei.com,
	yukuai1@huaweicloud.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com
Subject: [GIT PULL] md-6.14-20250218
Date: Thu, 20 Feb 2025 11:19:41 +0800
Message-Id: <20250220031941.3274042-1-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgB3218ooLZnItZpEQ--.54744S4
X-Coremail-Antispam: 1UD129KBjvdXoW7Xr4DKr17Kr18CrWxCrWkXrb_yoWDCFc_tF
	ykXa48Kr48Xr17A3W5CF1xZF4jqa48W3WfJr17KrWav343X3WDKrWjqrW8XF1kX3Z5KFZ8
	tF48Was5tr12vjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUb4xFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
	A2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j
	6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
	Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
	I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r
	4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCY1x0262kKe7AKxVWU
	AVWUtwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14
	v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkG
	c2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI
	0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4U
	MIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUBVbkUUU
	UU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi Jens,

Please consider pulling the following fix on top of your block-6.14
branch. This patch, by Bart Van Assche, fixes queue limits error
handling for raid0, raid1 and raid10.

Thanks,
Kuai

The following changes since commit 96b531f9bb0da924299d1850bb9b2911f5c0c50a:

  Merge tag 'md-6.14-20250206' of https://git.kernel.org/pub/scm/linux/kernel/git/mdraid/linux into block-6.14 (2025-02-07 07:23:03 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/mdraid/linux.git tags/md-6.14-20250218

for you to fetch changes up to fbe8f2fa971c537571994a0df532c511c4fb5537:

  md/raid*: Fix the set_queue_limits implementations (2025-02-14 01:29:33 +0800)

----------------------------------------------------------------
Bart Van Assche (1):
      md/raid*: Fix the set_queue_limits implementations

 drivers/md/raid0.c  | 4 +---
 drivers/md/raid1.c  | 4 +---
 drivers/md/raid10.c | 4 +---
 3 files changed, 3 insertions(+), 9 deletions(-)

