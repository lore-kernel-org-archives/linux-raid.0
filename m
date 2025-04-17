Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA59217A2EB
	for <linux-raid@vger.kernel.org>; Thu, 17 Apr 2025 02:21:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744856512; cv=none; b=bNqHb9hOPIyp4TEqe/9w2Any4Y+SjcJa72oABoMfJ7seUb6OTKgMmANID4WkFzbnN2m+uvjEihqTIdSYQVkAfiWXgdlcrg04v61RSZNDcBJ9IHeuvvDobeluMMPGUyfKYBHvepExbEXHKiic+Uwer0VNuhJzlSR5YcMjdUwmRxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744856512; c=relaxed/simple;
	bh=cqgA3NXq3G01c87GeM0fzYvgHIPXrlkaVjQKhZXkGQU=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=HUOqdG4B59Jq4PgQ8vrexjpvVLU/pRvLcLNVqdxoWPeuS+47IqvNva6LMbDdt5FRfyKV5wXBtXRhM2TM4+GLJ/IFyRdgvZp9Qw4UMJhkPnP1yCmCBps2W2UH/FOAE4wZUUSNOZaytgGp/nmlLo6+VD+RrT1nE7mrboBniTcDtrU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4ZdM8R3X7Wz4f3jtW
	for <linux-raid@vger.kernel.org>; Thu, 17 Apr 2025 10:21:27 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id D594A1A1435
	for <linux-raid@vger.kernel.org>; Thu, 17 Apr 2025 10:21:45 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgDnSl+2ZQBojwjYJg--.511S4;
	Thu, 17 Apr 2025 10:21:43 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: axboe@kernel.dk,
	linux-raid@vger.kernel.org,
	song@kernel.org,
	yukuai3@huawei.com,
	meir.elisha@volumez.com,
	zhengqixing@huawei.com
Cc: yangerkun@huawei.com,
	yi.zhang@huawei.com,
	johnny.chenyi@huawei.com
Subject: [GIT PULL] md-6.15-20250416
Date: Thu, 17 Apr 2025 10:14:42 +0800
Message-Id: <20250417021442.1670701-1-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgDnSl+2ZQBojwjYJg--.511S4
X-Coremail-Antispam: 1UD129KBjvJXoW7Xr43Zw1rZw1DGr4ruFWkXrb_yoW8JF1kpF
	ZxGw13uw18G347JFZIqrW2kF1rJFZ5Gr47Xry3GayFvFyDZF15tw15Ga4rWr9rGry2y3Wa
	qF1rGrs8Wa48AFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUyEb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JMxkF7I0En4kS14v26r1q6r43MxAIw28IcxkI
	7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxV
	Cjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY
	6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6x
	AIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY
	1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7IU17KsUUUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi Jens,

Please consider pulling the following changes for md-6.15 on your
block-6.15 branch, this pull request contains:

- fix raid10 missing discard IO accounting (Yu Kuai)
- fix bitmap stats for bitmap file (Zheng Qixing)
- fix oops while reading all member disks failed during check/repair (Meir Elisha)

Thanks,
Kuai

The following changes since commit 72070e57b0a518ec8e562a2b68fdfc796ef5c040:

  selftests: ublk: fix test_stripe_04 (2025-04-03 20:13:38 -0600)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/mdraid/linux.git tags/md-6.15-20250416

for you to fetch changes up to b7c178d9e57c8fd4238ff77263b877f6f16182ba:

  md/raid1: Add check for missing source disk in process_checks() (2025-04-16 18:06:37 +0800)

----------------------------------------------------------------
Meir Elisha (1):
      md/raid1: Add check for missing source disk in process_checks()

Yu Kuai (1):
      md/raid10: fix missing discard IO accounting

Zheng Qixing (1):
      md/md-bitmap: fix stats collection for external bitmaps

 drivers/md/md-bitmap.c |  5 ++---
 drivers/md/raid1.c     | 26 ++++++++++++++++----------
 drivers/md/raid10.c    |  1 +
 3 files changed, 19 insertions(+), 13 deletions(-)

