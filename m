Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DB9C1E49E;
	Tue, 11 Jun 2024 13:23:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718112202; cv=none; b=FMdIHpVa80BSo/0ypqUHJytJs6uLNMvOU96v3Y/6r0dkQYXrjafG+HjhwS3IdtUWr5xg7rOgvolCf9FuxYYKErWeXgW3AwfKRu2szc5IGc5rd0+gfvzEf+gV/NWhLxXpA2hE4YSjjcbrgEXgSZI5JDo5pK2HE6NQUVXUyHic+TY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718112202; c=relaxed/simple;
	bh=QszMwBmjRoho4tsxbi7o9TGOf22DvNyBwy7XSjb8iZw=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=QeGCCoHbX+Z5zS7e+1KTLOnEAJ2sjvcQZNwJmj/5AO4/Yxah7gRaZvSj1424hvBz+L0xGRBlAUp5ce9OOphd37L68yOzclYM3WgH3B8Nop0vD3vAL0O05q1muvmiSdu8ISHD4PUiY56EzOjzU6vbXJww+ZVWJredARv52jrZ9FI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4Vz8Vx6Dd5z4f3jXn;
	Tue, 11 Jun 2024 21:23:05 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id D66CB1A0C0E;
	Tue, 11 Jun 2024 21:23:15 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP1 (Coremail) with SMTP id cCh0CgDHlxDBT2hmsVPEPA--.1557S4;
	Tue, 11 Jun 2024 21:23:15 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: agk@redhat.com,
	snitzer@kernel.org,
	mpatocka@redhat.com,
	song@kernel.org,
	xni@redhat.com,
	mariusz.tkaczyk@linux.intel.com
Cc: dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-raid@vger.kernel.org,
	yukuai3@huawei.com,
	yukuai1@huaweicloud.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com
Subject: [PATCH v2 md-6.11 00/12] md: refacotor and some fixes related to sync_thread
Date: Tue, 11 Jun 2024 21:22:39 +0800
Message-Id: <20240611132251.1967786-1-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgDHlxDBT2hmsVPEPA--.1557S4
X-Coremail-Antispam: 1UD129KBjvdXoW7Wr1DuFWDJFWUJFy5Wr15urg_yoWkCwbEga
	48XFy3Jw4rWa15WFy5Arna9rZ2yF4YgFZ7GFy5KrWayrn7WrnxCr1q9w1fZw1xZry7uFn0
	yryUC3yxAwsrWjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbx8FF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
	A2z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr0_
	Cr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_GcCE3s
	1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0
	cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8Jw
	ACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2Y2ka
	0xkIwI1l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67
	AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIY
	rxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14
	v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWrZr1j6s0DMIIF0xvEx4A2jsIE14v26r1j
	6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUdHU
	DUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

Changes from v1:
 - respin on the top of md-6.11 branch

Changes from RFC:
 - fix some typos;
 - add patch 7 to prevent some mdadm tests failure;
 - add patch 12 to fix BUG_ON() panic by mdadm test 07revert-grow;

Yu Kuai (12):
  md: rearrange recovery_flags
  md: add a new enum type sync_action
  md: add new helpers for sync_action
  md: factor out helper to start reshape from action_store()
  md: replace sysfs api sync_action with new helpers
  md: remove parameter check_seq for stop_sync_thread()
  md: don't fail action_store() if sync_thread is not registered
  md: use new helers in md_do_sync()
  md: replace last_sync_action with new enum type
  md: factor out helpers for different sync_action in md_do_sync()
  md: pass in max_sectors for pers->sync_request()
  md/raid5: avoid BUG_ON() while continue reshape after reassembling

 drivers/md/dm-raid.c |   2 +-
 drivers/md/md.c      | 437 ++++++++++++++++++++++++++-----------------
 drivers/md/md.h      | 124 +++++++++---
 drivers/md/raid1.c   |   5 +-
 drivers/md/raid10.c  |   8 +-
 drivers/md/raid5.c   |  23 ++-
 6 files changed, 388 insertions(+), 211 deletions(-)

-- 
2.39.2

