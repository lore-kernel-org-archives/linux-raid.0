Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FAA22D052;
	Mon, 26 Aug 2024 07:49:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724658594; cv=none; b=OjsOtpTpeJZtsEySbLKEVsuOzo7odgFSNe42ncnHWW/k2UA9gB1miSsnWlRHLnTp/c2F2vymVhzqSaaVGNbKN9SP/RDM5S9cU5ece1q8Xkq7Jsh1UG4sYU1xj0nT/p+L4AuxsiAif++b6KfBhfwl/qzDEuwJmxojePeMtJk9Hp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724658594; c=relaxed/simple;
	bh=71/oi42Z1BkNJ1VooZ+IBAArvzctTcPbGsld3gyIK/c=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=L7ww1Zq5cJr2eEM4GGplQ9bKEPT1tS2UHJi2nlWfcJNj4Hg5Dcgr/pEmbgNLnAG1Vc0I3lajheGP2xMecYqKvHufRlnCQ7FOx9btyOVvREQVDBW+Q8Y3BqHlYZIhcpJJOYw/twG20UC8JsdukajFUhwUqP4Gvt58nXGTxc1Uw84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4WsjW11bx2z4f3l26;
	Mon, 26 Aug 2024 15:49:33 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 902191A1674;
	Mon, 26 Aug 2024 15:49:48 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgAHL4WaM8xmWWIECw--.13849S4;
	Mon, 26 Aug 2024 15:49:48 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: mariusz.tkaczyk@linux.intel.com,
	xni@redhat.com,
	song@kernel.org
Cc: linux-kernel@vger.kernel.org,
	linux-raid@vger.kernel.org,
	yukuai3@huawei.com,
	yukuai1@huaweicloud.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com
Subject: [PATCH md-6.12 v2 00/42] md/md-bitmap: introduce bitmap_operations and make structure internal
Date: Mon, 26 Aug 2024 15:44:10 +0800
Message-Id: <20240826074452.1490072-1-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgAHL4WaM8xmWWIECw--.13849S4
X-Coremail-Antispam: 1UD129KBjvJXoWxWFWfWF1DZrWfJr4ktF4UXFb_yoWruw1xpF
	WDK345Ww43JFs3Ww15CryvyFyrtr1ktwsrKr1fCw4rCFyDAF9xXr48W3WIy34Igry7JFsx
	Xr15tr18Ww17XFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUkC14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc7CjxVAaw2AFwI0_
	Jw0_GFyl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67
	AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIY
	rxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14
	v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8
	JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjfUonmRUU
	UUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

Changes from RFC v1:
 - add patch 1-8 to prevent dereference bitmap directly, and the last
 patch to make bitmap structure internel;
 - use plain function alls "bitmap_ops->xxx()" directly;

Changes from RFC v2:
 - some coding style;

Changes from v1:
 - add patch 5 to fix __le64 conversion;
 - fix a problem in patch 34;

The background is that currently bitmap is using a global spin_lock,
causing lock contention and huge IO performance degradation for all raid
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

Yu Kuai (42):
  md/raid1: use md_bitmap_wait_behind_writes() in raid1_read_request()
  md/md-bitmap: replace md_bitmap_status() with a new helper
    md_bitmap_get_stats()
  md: use new helper md_bitmap_get_stats() in update_array_info()
  md/md-bitmap: add 'events_cleared' into struct md_bitmap_stats
  md/md-cluster: fix spares warnings for __le64
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
 drivers/md/md-bitmap.c   | 568 +++++++++++++++++++++++++++++----------
 drivers/md/md-bitmap.h   | 268 ++++--------------
 drivers/md/md-cluster.c  |  91 ++++---
 drivers/md/md.c          | 155 +++++++----
 drivers/md/md.h          |   3 +-
 drivers/md/raid1-10.c    |   9 +-
 drivers/md/raid1.c       |  78 +++---
 drivers/md/raid10.c      |  73 ++---
 drivers/md/raid5-cache.c |   8 +-
 drivers/md/raid5.c       |  62 ++---
 11 files changed, 760 insertions(+), 562 deletions(-)

-- 
2.39.2

