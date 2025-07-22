Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A70686353
	for <linux-raid@vger.kernel.org>; Tue, 22 Jul 2025 06:16:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753164969; cv=none; b=tcwZ04CrY7Q0utAfYJlnKbu6SzCtOdyvPlqcnA2Q2g5WwmnUKGOw8/cbWfu7S2a88cDPK0nxHMW60cXSDQbDRbuxr3zDwzpopkoe6RoEiDBF4JcFarYltT5I1J2yscgztAjbcf5p20MvtO1QLIg8B3J5K9fXxD5fVCMnydT67AE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753164969; c=relaxed/simple;
	bh=aklzPUZ0j4zc78dp9F84zZreaaELHGsjukLSlxWxIvE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=OozzabnvZS5DdilXm4Q2iOWgf0/l3YBerRLiFpzCv2RQcq7r9dXWGKzd1Rva53dSmLF0SlyfJP9IGBMD/ELeeeIsNhyp91P5lAqvqNvBxRRznHvagx58fimelUqFyCbt8ntDkssCr0nJAMuGe6d98NoCdkx3TFGdd3wKlYANXiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4bmRpp2MRWzKHMlL
	for <linux-raid@vger.kernel.org>; Tue, 22 Jul 2025 14:16:02 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 0CC0B1A1384
	for <linux-raid@vger.kernel.org>; Tue, 22 Jul 2025 14:16:01 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgBHERKdLH9o41tXBA--.39005S4;
	Tue, 22 Jul 2025 14:15:59 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: axboe@kernel.dk,
	linux-raid@vger.kernel.org,
	song@kernel.org
Cc: yukuai3@huawei.com,
	yangerkun@huawei.com,
	yi.zhang@huawei.com,
	johnny.chenyi@huawei.com,
	john.g.garry@oracle.com,
	zhengqixing@huawei.com,
	ryotkkr98@gmail.com,
	xni@redhat.com
Subject: [GIT PULL] md-6.17-20250722
Date: Tue, 22 Jul 2025 14:09:37 +0800
Message-Id: <20250722060937.3547082-1-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgBHERKdLH9o41tXBA--.39005S4
X-Coremail-Antispam: 1UD129KBjvJXoW7uFW8Xw48WFWfKr4xJF1rtFb_yoW8XFyDpr
	W3Wr13Wr1UJwsxAFsxXr1jyryrJa93JrW7JF17Jwn5AF1DAr1DAr1UJryrWryDJFy7XF4U
	tr4Fqr4qgr18KaUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUv2b4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JM4IIrI8v6xkF7I0E8cxan2IY04v7MxkF7I0E
	n4kS14v26r1q6r43MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I
	0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWU
	tVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcV
	CY1x0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAF
	wI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa
	7IU17KsUUUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi Jens,

Please consider pulling following changes from md-6.17 on your for-6.17/block
branch, this pull request contains:

 - call del_gendisk synchronously, from Xiao
 - cleanup unused variable, from John
 - cleanup workqueue flags, from Ryo
 - fix faulty rdev can't be removed during resync, from Qixing

The following changes since commit 7e49538288e523427beedd26993d446afef1a6fb:

  loop: Avoid updating block size under exclusive owner (2025-07-11 20:39:45 -0600)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/mdraid/linux.git tags/md-6.17-20250722

for you to fetch changes up to bc1c2f0ae355f7e30b5baecdfb89d2b148aa0515:

  md/raid10: fix set but not used variable in sync_request_write() (2025-07-17 00:02:05 +0800)

----------------------------------------------------------------
John Garry (1):
      md/raid10: fix set but not used variable in sync_request_write()

Ryo Takakura (1):
      md/raid5: unset WQ_CPU_INTENSIVE for raid5 unbound workqueue

Xiao Ni (3):
      md: call del_gendisk in control path
      md: Don't clear MD_CLOSING until mddev is freed
      md: remove/add redundancy group only in level change

Zheng Qixing (1):
      md: allow removing faulty rdev during resync

 drivers/md/md.c     | 73 +++++++++++++++++++++++++++++++++++++++++++------------------------------
 drivers/md/md.h     | 26 ++++++++++++++++++++++++--
 drivers/md/raid10.c |  3 ---
 drivers/md/raid5.c  |  2 +-
 4 files changed, 68 insertions(+), 36 deletions(-)

