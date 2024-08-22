Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D69851CAA6;
	Thu, 22 Aug 2024 02:52:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724295127; cv=none; b=rjaTFyNPBit72gQVcEH7sfJ7OEjbZJ2oSV1dWrxrly5ykAPurDheNhA3UlFaF4doMY6P3ZYN4iECPsUtSzShzLOMb+vRNFMYfIpcfJETPm00SYEt5HynTRnOINn94fNunvyinmbogvlFk0cVsuBpx72EF9XjSZEJQDw+dkrHe+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724295127; c=relaxed/simple;
	bh=JA6XERccpD+o/FJfLu+KgGrJe3Am2n5/TXceJgsnIB4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=OJ3Aj+VG7Ts/MnJEB/67+z+P8vcOisHLYONzLBMrUvz6KGDiJk2Drz4q4hdiklP0qJk9WdGxzYiGlWAyTu6a+bX6hSHtzqcu71jaevf6f8aAClZ+yo9JbQFYrXGyatAoUgsTnUh2hqeQaCRhpAtGTCwBPqZbxdmyQBs5GPDoJkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4Wq75F60dbz4f3jdl;
	Thu, 22 Aug 2024 10:51:45 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 117411A0359;
	Thu, 22 Aug 2024 10:52:00 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgAXPoTNp8ZmyXl2CQ--.42363S4;
	Thu, 22 Aug 2024 10:51:59 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: song@kernel.org,
	mariusz.tkaczyk@linux.intel.com,
	l@damenly.org,
	xni@redhat.com
Cc: linux-kernel@vger.kernel.org,
	linux-raid@vger.kernel.org,
	yukuai3@huawei.com,
	yukuai1@huaweicloud.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com
Subject: [PATCH md-6.12 00/41] md/md-bitmap: introduce bitmap_operations and make structure internel
Date: Thu, 22 Aug 2024 10:46:37 +0800
Message-Id: <20240822024718.2158259-1-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgAXPoTNp8ZmyXl2CQ--.42363S4
X-Coremail-Antispam: 1UD129KBjvJXoWxWFWfWF1DZrW8Xw1DJw1fJFb_yoWrZFWxpF
	WDK345Ww43JFs3Ww15CryvyFyrtr1ktwsrKr1fCw1rCFyDAF9xXr48W3WIy34Igry7JFsx
	Xr15tr18Ww17XFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9014x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_JrI_JrylYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2
	Y2ka0xkIwI1lc7CjxVAaw2AFwI0_Jw0_GFyl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x
	0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2
	zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF
	4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWU
	CwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r1j6r4UYxBIda
	VFxhVjvjDU0xZFpf9x0JUZYFZUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

Changes from RFC v1:
 - add patch 1-8 to prevent dereference bitmap directly, and the last
 patch to make bitmap structure internel.
 - use plain function alls "bitmap_ops->xxx()" directly;

Changes from RFC v2:
 - some coding style.

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

This version was tested with mdadm tests. There are still few failed
tests in my VM, howerver, it's the test itself need to be fixed and
we're working on it.

Yu Kuai (41):
  md/raid1: use md_bitmap_wait_behind_writes() in raid1_read_request()
  md/md-bitmap: replace md_bitmap_status() with a new helper
    md_bitmap_get_stats()
  md: use new helper md_bitmap_get_stats() in update_array_info()
  md/md-bitmap: add 'events_cleared' into struct md_bitmap_stats
  md/md-bitmap: add 'sync_size' into struct md_bitmap_stats
  md/md-bitmap: add 'file_pages' into struct md_bitmap_stats
  md/md-bitmap: add 'behind_writes' and 'behind_wait' into struct
    md_bitmap_stats
  md/md-cluster: use helper md_bitmap_get_stats() to get pages in
    resize_bitmaps()
  md/md-bitmap: add a new helper md_bitmap_set_pages()
  md/md-bitmap: introduce struct bitmap_operations
  md/md-bitmap: simplify md_bitmap_create() + md_bitmap_load()
  md/md-bitmap: merge md_bitmap_create() into bitmap_operations
  md/md-bitmap: merge md_bitmap_load() into bitmap_operations
  md/md-bitmap: merge md_bitmap_destroy() into bitmap_operations
  md/md-bitmap: merge md_bitmap_flush() into bitmap_operations
  md/md-bitmap: make md_bitmap_print_sb() internal
  md/md-bitmap: merge md_bitmap_update_sb() into bitmap_operations
  md/md-bitmap: merge md_bitmap_status() into bitmap_operations
  md/md-bitmap: remove md_bitmap_setallbits()
  md/md-bitmap: merge bitmap_write_all() into bitmap_operations
  md/md-bitmap: merge md_bitmap_dirty_bits() into bitmap_operations
  md/md-bitmap: merge md_bitmap_startwrite() into bitmap_operations
  md/md-bitmap: merge md_bitmap_endwrite() into bitmap_operations
  md/md-bitmap: merge md_bitmap_start_sync() into bitmap_operations
  md/md-bitmap: remove the parameter 'aborted' for md_bitmap_end_sync()
  md/md-bitmap: merge md_bitmap_end_sync() into bitmap_operations
  md/md-bitmap: merge md_bitmap_close_sync() into bitmap_operations
  md/md-bitmap: mrege md_bitmap_cond_end_sync() into bitmap_operations
  md/md-bitmap: merge md_bitmap_sync_with_cluster() into
    bitmap_operations
  md/md-bitmap: merge md_bitmap_unplug_async() into md_bitmap_unplug()
  md/md-bitmap: merge bitmap_unplug() into bitmap_operations
  md/md-bitmap: merge md_bitmap_daemon_work() into bitmap_operations
  md/md-bitmap: pass in mddev directly for md_bitmap_resize()
  md/md-bitmap: merge md_bitmap_resize() into bitmap_operations
  md/md-bitmap: merge get_bitmap_from_slot() into bitmap_operations
  md/md-bitmap: merge md_bitmap_copy_from_slot() into struct
    bitmap_operation.
  md/md-bitmap: merge md_bitmap_set_pages() into struct
    bitmap_operations
  md/md-bitmap: merge md_bitmap_free() into bitmap_operations
  md/md-bitmap: merge md_bitmap_wait_behind_writes() into
    bitmap_operations
  md/md-bitmap: merge md_bitmap_enabled() into bitmap_operations
  md/md-bitmap: make in memory structure internal

 drivers/md/dm-raid.c     |   7 +-
 drivers/md/md-bitmap.c   | 560 +++++++++++++++++++++++++++++----------
 drivers/md/md-bitmap.h   | 268 ++++---------------
 drivers/md/md-cluster.c  |  91 ++++---
 drivers/md/md.c          | 155 +++++++----
 drivers/md/md.h          |   3 +-
 drivers/md/raid1-10.c    |   9 +-
 drivers/md/raid1.c       |  78 +++---
 drivers/md/raid10.c      |  73 ++---
 drivers/md/raid5-cache.c |   8 +-
 drivers/md/raid5.c       |  62 ++---
 11 files changed, 752 insertions(+), 562 deletions(-)

-- 
2.39.2

