Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE0D42914;
	Thu, 23 Jan 2025 02:13:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737598403; cv=none; b=YXg/sTi+VN0Ga+JCQvduKTM1VDEI4oSz7/B4gkUR4Xrg8OlKKjlLNkbDLZMc5cJwKBivdCQrBjbHgkgQr/h4z7GKnXrzb8MwFA0qB9w7csgao9dusa+BAAkdAesWmHehDVDgPq2fdQxtaSqFfQK3VEmlaTRboXCZ7PtaYVuGJaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737598403; c=relaxed/simple;
	bh=KyOBfOupSyBvtsJrPdTalMfEoJ+GPlWtGQBkeawHOJQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=REzrIwQkdfHYV6Z/zMSqGQs6Pr1u3E+fQilsidovwzKkTqElKkC5SWGXk6PicInThs5hi/JUyNKK5r2J0K+z6vwvetKGMC/04iDHR2anCMIRNNuxuG8ATNo8PVR6gdgFYy+Nl9AjdDEUUdlfXWBZkxRvbzn5c525LhKHEoL6Mos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4YdkxT4kRZz4f3jks;
	Thu, 23 Jan 2025 10:13:01 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 21E951A1567;
	Thu, 23 Jan 2025 10:13:17 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgA3m1+7pZFno+znBg--.59488S4;
	Thu, 23 Jan 2025 10:13:16 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: song@kernel.org,
	yukuai3@huawei.com,
	agk@redhat.com,
	snitzer@kernel.org,
	mpatocka@redhat.com
Cc: linux-raid@vger.kernel.org,
	dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	yukuai1@huaweicloud.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com
Subject: [PATCH v3 md-6.15 00/11] md/md-bitmap: introduce CONFIG_MD_BITMAP
Date: Thu, 23 Jan 2025 10:07:19 +0800
Message-Id: <20250123020730.2003602-1-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgA3m1+7pZFno+znBg--.59488S4
X-Coremail-Antispam: 1UD129KBjvJXoW7Ww1ftF4xXF1UGw1UAF47Arb_yoW8Cw13pa
	9xt343uw15JFWavFnxJrykCFyrX3s7Ja9Fkrn7Cw4rWFyDZF9xXr48GFW0y34qgryfX3Zr
	Jr15tF1xGr18Xa7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9Y14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2
	Y2ka0xkIwI1lc7CjxVAaw2AFwI0_Jw0_GFyl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x
	0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2
	zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF
	4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWU
	CwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCT
	nIWIevJa73UjIFyTuYvjfUonmRUUUUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

Changes in v2:
 - don't export apis, and don't support build md-bitmap as module
Changes in v3:
 - update commit message.

Due to known performance issues with md-bitmap and the unreasonable
implementations like following:

 - self-managed pages, bitmap_storage->filemap;
 - self-managed IO submitting like filemap_write_page();
 - global spin_lock
 ...

I have decided not to continue optimizing based on the current bitmap
implementation, and plan to invent a new lock-less bitmap. And a new
kconfig option is a good way for isolation. However, we still
encourage anyone who wants to continue optimizing the current
implementation, the new bitmap will take some time to be ready.

Yu Kuai (11):
  md/md-bitmap: remove the parameter 'init' for bitmap_ops->resize()
  md/md-bitmap: merge md_bitmap_group into bitmap_operations
  md/md-bitmap: add md_bitmap_registered/enabled() helper
  md/md-bitmap: handle the case bitmap is not enabled before
    start_sync()
  md/md-bitmap: handle the case bitmap is not enabled before end_sync()
  md/raid1: check bitmap before behind write
  md/raid1: check before deferencing mddev->bitmap_ops
  md/raid10: check before deferencing mddev->bitmap_ops
  md/raid5: check before deferencing mddev->bitmap_ops
  md: check before deferencing mddev->bitmap_ops
  md/md-bitmap: introduce CONFIG_MD_BITMAP

 drivers/md/Kconfig      |  18 +++++
 drivers/md/dm-raid.c    |   2 +-
 drivers/md/md-bitmap.c  |  65 ++++++++---------
 drivers/md/md-bitmap.h  |  66 +++++++++++++++--
 drivers/md/md-cluster.c |   2 +-
 drivers/md/md.c         | 154 +++++++++++++++++++++++++++++++---------
 drivers/md/md.h         |   2 -
 drivers/md/raid1-10.c   |   2 +-
 drivers/md/raid1.c      |  79 ++++++++++++---------
 drivers/md/raid10.c     |  48 ++++++-------
 drivers/md/raid5.c      |  30 ++++----
 11 files changed, 322 insertions(+), 146 deletions(-)

-- 
2.39.2

