Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86528312807;
	Wed, 31 Dec 2025 07:18:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767165506; cv=none; b=oN3qdMTrz+v05zMEUyWWiRHucRc9fE/ydM8jNN6dp2bpjuTzxNNjcPLlTG9JNaAKzkLGUvFvOV+whjmq/XyEicNr9BYPqcuuwodyZv90cqcqgBigw0NuBV7hvTeIKsGnWdLV7abuQcqe4xt0bslZ6srbWGaeRwR7GonLNYyUNT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767165506; c=relaxed/simple;
	bh=RUAWtnBh8nx39TM6O3/TvceK6ZrZglGoU3k2WAcnGx4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Lc2q/rVjwxR3rA7EH9bpLaeYg1shH5kkebhBeuGd39P0O0gw0BIRKWp/jS9g4Vs1ymvHKF5bLIj6SSlCGi9/iC5Trcku5cPa2j71bfFzxRJtM7Wv0kfSb5NJXrDIhPcApNnOMFBmN5apeS0gwwF2l+ht583mYCVDN1iP21pXZhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4dh1Vv2R97zYQtlb;
	Wed, 31 Dec 2025 15:17:27 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 642E440591;
	Wed, 31 Dec 2025 15:18:17 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.87.129])
	by APP4 (Coremail) with SMTP id gCh0CgCX+PgvzlRpTtVyCA--.62349S4;
	Wed, 31 Dec 2025 15:18:15 +0800 (CST)
From: Zheng Qixing <zhengqixing@huaweicloud.com>
To: song@kernel.org,
	yukuai@fnnas.com
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	yi.zhang@huawei.com,
	yangerkun@huawei.com,
	houtao1@huawei.com,
	zhengqixing@huawei.com,
	linan122@h-partners.com
Subject: [RFC PATCH 0/5] md/raid1: introduce a new sync action to repair badblocks
Date: Wed, 31 Dec 2025 15:09:47 +0800
Message-Id: <20251231070952.1233903-1-zhengqixing@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgCX+PgvzlRpTtVyCA--.62349S4
X-Coremail-Antispam: 1UD129KBjvJXoW7tFWktF1Utw13Kw15WF1Dtrb_yoW8Gw45p3
	95t343Xr48GryxJF93WryUCryFkw1fJrW7Gr43Jw13ua45Jr10vF4xXw4rXFyUKry3XrW2
	qrn8Kry5WFy8AaUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUkjb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUXVWUAwAv7VC2z280aVAFwI0_Gr1j6F4UJwAm72CE4I
	kC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lc7CjxVAaw2AFwI0_Jw0_GFyl42xK82IY
	c2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s
	026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF
	0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0x
	vE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv
	6xkF7I0E14v26r1j6r4UYxBIdaVFxhVjvjDU0xZFpf9x07ULdbbUUUUU=
X-CM-SenderInfo: x2kh0wptl0x03j6k3tpzhluzxrxghudrp/

From: Zheng Qixing <zhengqixing@huawei.com>

In RAID1, some sectors may be marked as bad blocks due to I/O errors.
In certain scenarios, these bad blocks might not be permanent, and
issuing I/Os again could succeed.

To address this situation, a new sync action ('rectify') introduced
into RAID1 , allowing users to actively trigger the repair of existing
bad blocks and clear it in sys bad_blocks.

When echo rectify into /sys/block/md*/md/sync_action, a healthy disk is
selected from the array to read data and then writes it to the disk where
the bad block is located. If the write request succeeds, the bad block
record can be cleared.

Note:
  This patchset depends on [1] from Li Nan which is currently under review
  and not yet merged into md-6.19.

[1] [PATCH v3 00/13] cleanup and bugfix of sync
  Link: https://lore.kernel.org/all/20251215030444.1318434-1-linan666@huaweicloud.com/

Zheng Qixing (5):
  md: add helpers for requested sync action
  md: clear stale sync flags when frozen before sync starts
  md: simplify sync action print in status_resync
  md: introduce MAX_RAID_DISKS macro to replace magic number
  md/raid1: introduce rectify action to repair badblocks

 drivers/md/md.c    | 184 ++++++++++++++++++++++-----
 drivers/md/md.h    |  17 +++
 drivers/md/raid1.c | 308 ++++++++++++++++++++++++++++++++++++++++++++-
 drivers/md/raid1.h |   1 +
 4 files changed, 472 insertions(+), 38 deletions(-)

-- 
2.39.2

