Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B81FB4A2D;
	Fri, 11 Oct 2024 01:18:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728609511; cv=none; b=dktWy/NwolIvgPmbEyRZIEr0uzpJZermr36RPp8DZychhsB6fNMf4v8xmBY2DcEoM/D83kQBWgHZrQWiQkirSHARwkaUvK+09jwWAdunisPKsWzp6jmlWO0F77f7H4UK/X5Q78gAul9Y1U7zMUzqsB7HvHNFCq7dJDvBZNJMwFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728609511; c=relaxed/simple;
	bh=yrc5s+9o+gbztC/j2sh5MbfFaE4EN4fTQfBq1nNR+jo=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=FY4q3m38hh4ZUhkc3vaeYzvNw/dSscjgHzfRDEDAv5dPifee2qiF5h9ZmxlnQKu6f5VvFdG24nOHaNY8QNvvMU+BLMndOG43EoVwuxvyN0YpeFIlU3gjURIsqTtmeqvXfyNmro99bpVwmOtg2umKqMb07WIsujc2ErQ05rO93u8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4XPpf75mD4z4f3jMX;
	Fri, 11 Oct 2024 09:18:07 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id B0D891A0359;
	Fri, 11 Oct 2024 09:18:24 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgDH+sbefAhnm9MFDw--.55490S4;
	Fri, 11 Oct 2024 09:18:24 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: song@kernel.org,
	mariusz.tkaczyk@intel.com
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	yukuai3@huawei.com,
	yukuai1@huaweicloud.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com
Subject: [PATCH v2 0/7] md: enhance faulty checking for blocked handling
Date: Fri, 11 Oct 2024 09:16:23 +0800
Message-Id: <20241011011630.2002803-1-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgDH+sbefAhnm9MFDw--.55490S4
X-Coremail-Antispam: 1UD129KBjvJXoW7CF4xJr1kXr1fur4DJw1xGrg_yoW8GryDpr
	nxta43Zr1UWr13X3Z3ZF1UXryrWw18JFW3Ar47Kw18W34UZryxJw4kt3WrWr90gryavws0
	qr15GrZxWFy5Ca7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUkG14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc7CjxVAaw2AFwI0_
	JF0_Jw1l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67
	AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIY
	rxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14
	v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8
	JwCI42IY6I8E87Iv6xkF7I0E14v26r1j6r4UYxBIdaVFxhVjvjDU0xZFpf9x0JUBVbkUUU
	UU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

Changes in v2:
 - add more comments and commit message in patch 3;
 - fix some typo;

The lifetime of badblocks:

1) IO error, and decide to record badblocks, and record sb_flags;
2) write IO found rdev has badblocks and not yet acknowledged, then this
IO is blocked;
3) daemon found sb_flags is set, update superblock and flush badblocks;
4) write IO continue;

Main idea is that badblocks will be set in memory fist, before badblocks
are acknowledged, new write request must be blocked to prevent reading
old data after power failure, and this behaviour is not necessary if rdev
is faulty in the first place.

Yu Kuai (7):
  md: add a new helper rdev_blocked()
  md: don't wait faulty rdev in md_wait_for_blocked_rdev()
  md: don't record new badblocks for faulty rdev
  md/raid1: factor out helper to handle blocked rdev from
    raid1_write_request()
  md/raid1: don't wait for Faulty rdev in wait_blocked_rdev()
  md/raid10: don't wait for Faulty rdev in wait_blocked_rdev()
  md/raid5: don't set Faulty rdev for blocked_rdev

 drivers/md/md.c     | 15 +++++++--
 drivers/md/md.h     | 24 +++++++++++++++
 drivers/md/raid1.c  | 75 +++++++++++++++++++++++----------------------
 drivers/md/raid10.c | 40 +++++++++++-------------
 drivers/md/raid5.c  | 13 ++++----
 5 files changed, 99 insertions(+), 68 deletions(-)

-- 
2.39.2

