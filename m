Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82ED31DDC3F;
	Wed, 19 Feb 2025 08:38:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739954323; cv=none; b=QfjJwT+ki/Miqixa0zJhbWWQDZ8mV2Hw8w/1nBnMNkVylrqyaZEKOGhlsqw1hIBf7LPtyiu3KSVm6Qg5sqeuBvodbo1TBEuPYHdPN0dJrptkPVBcntIxe/lCilIZDmmYCt2XQGaVwz3f5aDNgWjdyk326xQaiqe9B9vgT98MPII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739954323; c=relaxed/simple;
	bh=UzWEyLS4m1QElei2gvXZLkx0L1q2cpSGuNlBw+FrgzE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=mIauUeMMOx+0608Ugt8jzxN7C9aiFlInzPI/Pl7wGVdx2Qg8HO6zjnWk9B3165da9Pvu60tq1PeJUxf8RRawIElM6R6PCEfjMGgUh12Rvsz0rmYLiZQbr6ceaB0PjsUAYI7x8NJzB3GGezbIf8eY0/yiaPPYVHuebWlW7jPen1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4YyVCc4VbKz4f3jqL;
	Wed, 19 Feb 2025 16:38:20 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id DF7DB1A0F86;
	Wed, 19 Feb 2025 16:38:36 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgBXvGCImLVn4yQeEQ--.36560S4;
	Wed, 19 Feb 2025 16:38:34 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: song@kernel.org,
	yukuai3@huawei.com
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	yukuai1@huaweicloud.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com
Subject: [PATCH md-6.15 v4 00/11] md/md-bitmap: introduce CONFIG_MD_BITMAP
Date: Wed, 19 Feb 2025 16:34:45 +0800
Message-Id: <20250219083456.941760-1-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgBXvGCImLVn4yQeEQ--.36560S4
X-Coremail-Antispam: 1UD129KBjvJXoW7uw15Cr48Ar4xXF1rWF4Durg_yoW8tw13pa
	9xt3y3uw15JFW7XFnxJrW8CFyFqwn7tasFkr97Gw4rWFyUZF98Xr48KF18tryqqryfXa47
	Jr15tF18Gr18Za7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUkG14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc7CjxVAaw2AFwI0_
	JF0_Jw1l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67
	AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIY
	rxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14
	v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8
	JwCI42IY6I8E87Iv6xkF7I0E14v26r1j6r4UYxBIdaVFxhVjvjDU0xZFpf9x0JUBVbkUUU
	UU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

Changes in v4:
 - rebase on the top of other patchset [1].
Changes in v3:
 - update commit message.
Changes in v2:
 - don't export apis, and don't support build md-bitmap as module

Due to known performance issues with md-bitmap and the unreasonable
implementations like following:

 - self-managed pages, bitmap_storage->filemap;
 - self-managed IO submitting like filemap_write_page();
 - global spin_lock
 ...

I have decided not to continue optimizing based on the current bitmap
implementation, and plan to invent a new lock-less bitmap. And a new
kconfig option is a good way for isolation.

However, we still encourage anyone who wants to continue optimizing the
current implementation, the new bitmap will take some time to be ready.
Please refer to the RFC version [2] if interested.

[1] https://lore.kernel.org/all/20250215092225.2427977-1-yukuai1@huaweicloud.com/
[2] https://lore.kernel.org/all/20250126083624.1675849-1-yukuai1@huaweicloud.com/

Yu Kuai (11):
  md/md-bitmap: remove the parameter 'init' for bitmap_ops->resize()
  md/md-bitmap: merge md_bitmap_group into bitmap_operations
  md/md-bitmap: add md_bitmap_registered/enabled() helper
  md/md-bitmap: handle the case bitmap is not enabled before
    start_sync()
  md/md-bitmap: handle the case bitmap is not enabled before end_sync()
  md/raid1: check bitmap before behind write
  md/raid1: check before referencing mddev->bitmap_ops
  md/raid10: check before referencing mddev->bitmap_ops
  md/raid5: check before referencing mddev->bitmap_ops
  md: check before referencing mddev->bitmap_ops
  md/md-bitmap: introduce CONFIG_MD_BITMAP

 drivers/md/Kconfig      |  18 +++++++
 drivers/md/Makefile     |   3 +-
 drivers/md/dm-raid.c    |   2 +-
 drivers/md/md-bitmap.c  |  67 ++++++++++++------------
 drivers/md/md-bitmap.h  |  62 ++++++++++++++++++++--
 drivers/md/md-cluster.c |   2 +-
 drivers/md/md.c         | 112 ++++++++++++++++++++++++++++------------
 drivers/md/md.h         |   4 +-
 drivers/md/raid1-10.c   |   2 +-
 drivers/md/raid1.c      |  79 ++++++++++++++++------------
 drivers/md/raid10.c     |  48 ++++++++---------
 drivers/md/raid5.c      |  30 ++++++-----
 12 files changed, 281 insertions(+), 148 deletions(-)

-- 
2.39.2

