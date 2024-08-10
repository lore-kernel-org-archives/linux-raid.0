Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 916CE13D89A;
	Sat, 10 Aug 2024 02:13:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723255983; cv=none; b=meaFWgI0JEii/uaQoJUY4xNHaFG4RB8z1YN6zGYsBVuuBmsN3Bom5ayO1HKtuxRA1lWKC7rIV8qnAO8fi1JkIJn1TRZ+R3Qh29e44x/uCb+ZKpMr1IDAmY5cmO1Vt8kVjA8o5C1Wy8QhMRIrz5NN5ajDMHELtMZr3QF3NlFW9zM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723255983; c=relaxed/simple;
	bh=GEqzeXHzBGyJZ6Q6bERULR38QZpobGbOj5ok+GOFjg8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Oc7F4HHGOW2x/+bLJ2plbYsEXhivwQt8EClr6KOcUdik7SgOQ0Laq3SiKwBaHtDMa6TDDDkqzh85cyWzspowytsDdPB0Q0eglrOjMq+zbZu7QdQmfmhthQ4C8MdVxwrHjPJZNSJeK0xso7eoAJeSHYrD0gbSJOaZfMFYfBrLAs0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4Wgkng0XZwz4f3jMD;
	Sat, 10 Aug 2024 10:12:39 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 8F3921A0568;
	Sat, 10 Aug 2024 10:12:52 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgAHL4WizLZmErwLBQ--.1937S4;
	Sat, 10 Aug 2024 10:12:52 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: song@kernel.org
Cc: linux-kernel@vger.kernel.org,
	linux-raid@vger.kernel.org,
	yukuai3@huawei.com,
	yukuai1@huaweicloud.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com
Subject: [PATCH RFC -next 00/26] md/md-bitmap: introduce bitmap_operations
Date: Sat, 10 Aug 2024 10:08:28 +0800
Message-Id: <20240810020854.797814-1-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgAHL4WizLZmErwLBQ--.1937S4
X-Coremail-Antispam: 1UD129KBjvJXoWxXF4DWrWxXr1fAw17tFy8AFb_yoW5Aw4DpF
	WDK34rCw43GFs3Ww1YkryvyFyrtF1ktwsxKr1fCw4rGFyDAF9xJr48W3WIy34xWrZrtFsx
	Xr15tr48Ww17ZFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUkl14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26ryj6F1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4j
	6r4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
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

The background is that currently bitmap is using a global spin_lock,
cauing lock contention and huge IO performance degration for all raid
levels.

However, it's impossible to implement a new lock free bitmap with
current situation that md-bitmap exposes the internal implementation
with lots of exported apis. Hence bitmap_operations is invented, to
describe bitmap core implementation, and a new bitmap can be introduced
with a new bitmap_operations, we only need to switch to the new one
during initialization.

And with this we can build bitmap as kernel module, but that's not
our concern for now.

Noted I just compile this patchset, not tested yet.

Yu Kuai (26):
  md/md-bitmap: introduce struct bitmap_operations
  md/md-bitmap: merge md_bitmap_create() into bitmap_operations
  md/md-bitmap: merge md_bitmap_load() into bitmap_operations
  md/md-bitmap: merge md_bitmap_destroy() into bitmap_operations
  md/md-bitmap: merge md_bitmap_flush() into bitmap_operations
  md/md-bitmap: don't expose md_bitmap_print_sb()
  md/md-bitmap: merge md_bitmap_update_sb() into bitmap_operations
  md/md-bitmap: merge md_bitmap_status() into bitmap_operations
  md/md-bitmap: remove md_bitmap_setallbits()
  md/md-bitmap: merge bitmap_write_all() into bitmap_operations
  md/md-bitmap: merge md_bitmap_dirty_bits() into bitmap_operations
  md/md-bitmap: merge md_bitmap_startwrite() into bitmap_operations
  md/md-bitmap: merge md_bitmap_endwrite() into bitmap_operations
  md/md-bitmap: merge md_bitmap_start_sync() into bitmap_operations
  md/md-bitmap: merge md_bitmap_end_sync() into bitmap_operations
  md/md-bitmap: merge md_bitmap_close_sync() into bitmap_operations
  md/md-bitmap: mrege md_bitmap_cond_end_sync() into bitmap_operations
  md/md-bitmap: merge bitmap_sync_with_cluster() into bitmap_operations
  md/md-bitmap: merge md_bitmap_resize() into bitmap_operations
  md/md-bitmap: merge get_bitmap_from_slot() into bitmap_operations
  md/md-bitmap: merge md_bitmap_copy_from_slot() into bitmap_operations
  md/md-bitmap: merge md_bitmap_free() into bitmap_operations
  md/md-bitmap: merge md_bitmap_wait_behind_writes() into
    bitmap_operations
  md/md-bitmap: merge md_bitmap_daemon_work() into bitmap_operations
  md/md-bitmap: merge md_bitmap_unplug() and md_bitmap_unplug_async()
  md/md-bitmap: merge bitmap_unplug() into bitmap_operations

 drivers/md/dm-raid.c     |   2 +-
 drivers/md/md-bitmap.c   | 216 +++++++++++++++++---------------
 drivers/md/md-bitmap.h   | 259 ++++++++++++++++++++++++++++++++++-----
 drivers/md/md-cluster.c  |  21 ++--
 drivers/md/md.c          |  13 +-
 drivers/md/md.h          |   1 +
 drivers/md/raid1-10.c    |   7 +-
 drivers/md/raid1.c       |  22 ++--
 drivers/md/raid10.c      |  32 +++--
 drivers/md/raid5-cache.c |   2 +-
 drivers/md/raid5.c       |  25 ++--
 11 files changed, 401 insertions(+), 199 deletions(-)

-- 
2.39.2

