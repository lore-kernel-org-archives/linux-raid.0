Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9BF519CC28;
	Sat, 24 May 2025 06:18:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748067498; cv=none; b=kKSA+TXoRQli4jQlZ+PVTqE4yxLr3r6a7W4ez/rf+0W1POR8fW8Oso1YquJYtbmC+U8ppDHGQOqaF3R2nOvfFYCSrY9IzjTRFuWOTgfzQklfMcAu4dMS9nJl9KFY5ZjqOyij6+6TYKxe61NOQBdGr+MUTSTXFpxdTWg7G3+A5eU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748067498; c=relaxed/simple;
	bh=Y0SFO+Ih8sAgmgLXIIkCaXyXJMFLWW6tGyo1EI2sVfM=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=MjJrfsnBjBviy9HC+N3c/kranyMc+1rZTnqVpi7b/EdIjkSL3DdgQP9n7cBwSd0TQcvXgCxf4Fmo7QkPSxqvnJRQyHw4AcSw88sLnVVHFWpJiD7hexGTVY0RQBvJf74EXRcNVvAhCtCltm7u2CJyHGJGmDMQ/d673RLUGUB0wc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4b4BfX70X6zKHMYZ;
	Sat, 24 May 2025 14:18:12 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 754001A07BB;
	Sat, 24 May 2025 14:18:11 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgCnCl+dZDFo3etkNQ--.42979S4;
	Sat, 24 May 2025 14:18:07 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: hch@lst.de,
	xni@redhat.com,
	colyli@kernel.org,
	song@kernel.org,
	yukuai3@huawei.com
Cc: linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-raid@vger.kernel.org,
	yukuai1@huaweicloud.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com,
	johnny.chenyi@huawei.com
Subject: [PATCH 00/23] md/llbitmap: md/md-llbitmap: introduce a new lockless bitmap
Date: Sat, 24 May 2025 14:12:57 +0800
Message-Id: <20250524061320.370630-1-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgCnCl+dZDFo3etkNQ--.42979S4
X-Coremail-Antispam: 1UD129KBjvJXoWxKw17uFWUtw1xZw1fZF18Zrb_yoW3ur4Dp3
	9Ivrn3Jrs8Jr40gw17A34IqFySqw4kJrnrtr1rA3yF9rn8Cr9Ivr48Way0q39rGry7JF1q
	qF45tr9xGF1qgFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9014x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4j
	6r4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
	Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
	I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r
	4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628v
	n2kIc2xKxwCY1x0262kKe7AKxVWUtVW8ZwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7x
	kEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E
	67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCw
	CI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1x
	MIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIda
	VFxhVjvjDU0xZFpf9x0JUd-B_UUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

This is the formal version after previous RFC version:

https://lore.kernel.org/all/20250512011927.2809400-1-yukuai1@huaweicloud.com/

#### Background

Redundant data is used to enhance data fault tolerance, and the storage
method for redundant data vary depending on the RAID levels. And it's
important to maintain the consistency of redundant data.

Bitmap is used to record which data blocks have been synchronized and which
ones need to be resynchronized or recovered. Each bit in the bitmap
represents a segment of data in the array. When a bit is set, it indicates
that the multiple redundant copies of that data segment may not be
consistent. Data synchronization can be performed based on the bitmap after
power failure or readding a disk. If there is no bitmap, a full disk
synchronization is required.

#### Key Features

 - IO fastpath is lockless, if user issues lots of write IO to the same
 bitmap bit in a short time, only the first write have additional overhead
 to update bitmap bit, no additional overhead for the following writes;
 - support only resync or recover written data, means in the case creating
 new array or replacing with a new disk, there is no need to do a full disk
 resync/recovery;

#### Key Concept

##### State Machine

Each bit is one byte, contain 6 difference state, see llbitmap_state. And
there are total 8 differenct actions, see llbitmap_action, can change state:

llbitmap state machine: transitions between states

|           | Startwrite | Startsync | Endsync | Abortsync|
| --------- | ---------- | --------- | ------- | -------  |
| Unwritten | Dirty      | x         | x       | x        |
| Clean     | Dirty      | x         | x       | x        |
| Dirty     | x          | x         | x       | x        |
| NeedSync  | x          | Syncing   | x       | x        |
| Syncing   | x          | Syncing   | Dirty   | NeedSync |

|           | Reload   | Daemon | Discard   | Stale     |
| --------- | -------- | ------ | --------- | --------- |
| Unwritten | x        | x      | x         | x         |
| Clean     | x        | x      | Unwritten | NeedSync  |
| Dirty     | NeedSync | Clean  | Unwritten | NeedSync  |
| NeedSync  | x        | x      | Unwritten | x         |
| Syncing   | NeedSync | x      | Unwritten | NeedSync  |

Typical scenarios:

1) Create new array
All bits will be set to Unwritten by default, if --assume-clean is set,
all bits will be set to Clean instead.

2) write data, raid1/raid10 have full copy of data, while raid456 doesn't and
rely on xor data

2.1) write new data to raid1/raid10:
Unwritten --StartWrite--> Dirty

2.2) write new data to raid456:
Unwritten --StartWrite--> NeedSync

Because the initial recover for raid456 is skipped, the xor data is not build
yet, the bit must set to NeedSync first and after lazy initial recover is
finished, the bit will finially set to Dirty(see 5.1 and 5.4);

2.3) cover write
Clean --StartWrite--> Dirty

3) daemon, if the array is not degraded:
Dirty --Daemon--> Clean

For degraded array, the Dirty bit will never be cleared, prevent full disk
recovery while readding a removed disk.

4) discard
{Clean, Dirty, NeedSync, Syncing} --Discard--> Unwritten

5) resync and recover

5.1) common process
NeedSync --Startsync--> Syncing --Endsync--> Dirty --Daemon--> Clean

5.2) resync after power failure
Dirty --Reload--> NeedSync

5.3) recover while replacing with a new disk
By default, the old bitmap framework will recover all data, and llbitmap
implement this by a new helper, see llbitmap_skip_sync_blocks:

skip recover for bits other than dirty or clean;

5.4) lazy initial recover for raid5:
By default, the old bitmap framework will only allow new recover when there
are spares(new disk), a new recovery flag MD_RECOVERY_LAZY_RECOVER is add
to perform raid456 lazy recover for set bits(from 2.2).

##### Bitmap IO

##### Chunksize

The default bitmap size is 128k, incluing 1k bitmap super block, and
the default size of segment of data in the array each bit(chunksize) is 64k,
and chunksize will adjust to twice the old size each time if the total number
bits is not less than 127k.(see llbitmap_init)

##### READ

While creating bitmap, all pages will be allocated and read for llbitmap,
there won't be read afterwards

##### WRITE

WRITE IO is divided into logical_block_size of the array, the dirty state
of each block is tracked independently, for example:

each page is 4k, contain 8 blocks; each block is 512 bytes contain 512 bit;

| page0 | page1 | ... | page 31 |
|       |
|        \-----------------------\
|                                |
| block0 | block1 | ... | block 8|
|        |
|         \-----------------\
|                            |
| bit0 | bit1 | ... | bit511 |

From IO path, if one bit is changed to Dirty or NeedSync, the corresponding
subpage will be marked dirty, such block must write first before the IO is
issued. This behaviour will affect IO performance, to reduce the impact, if
multiple bits are changed in the same block in a short time, all bits in this
block will be changed to Dirty/NeedSync, so that there won't be any overhead
until daemon clears dirty bits.

##### Dirty Bits syncronization

IO fast path will set bits to dirty, and those dirty bits will be cleared
by daemon after IO is done. llbitmap_page_ctl is used to synchronize between
IO path and daemon;

IO path:
 1) try to grab a reference, if succeed, set expire time after 5s and return;
 2) if failed to grab a reference, wait for daemon to finish clearing dirty
 bits;

Daemon(Daemon will be waken up every daemon_sleep seconds):
For each page:
 1) check if page expired, if not skip this page; for expired page:
 2) suspend the page and wait for inflight write IO to be done;
 3) change dirty page to clean;
 4) resume the page;

Performance Test:
Simple fio randwrite test to build array with 20GB ramdisk in my VM:

|                      | none      | bitmap    | llbitmap  |
| -------------------- | --------- | --------- | --------- |
| raid1                | 13.7MiB/s | 9696KiB/s | 19.5MiB/s |
| raid1(assume clean)  | 19.5MiB/s | 11.9MiB/s | 19.5MiB/s |
| raid10               | 21.9MiB/s | 11.6MiB/s | 27.8MiB/s |
| raid10(assume clean) | 27.8MiB/s | 15.4MiB/s | 27.8MiB/s |
| raid5                | 14.0MiB/s | 11.6MiB/s | 12.9MiB/s |
| raid5(assume clean)  | 17.8MiB/s | 13.4MiB/s | 13.9MiB/s |

For raid1/raid10 llbitmap can be better than none bitmap with background
initial resync, and it's the same as none bitmap without it.

Noted that llbitmap performance improvement for raid5 is not obvious,
this is due to raid5 has many other performance bottleneck, perf
results still shows that bitmap overhead will be much less.

following branch for review or test:
https://git.kernel.org/pub/scm/linux/kernel/git/yukuai/linux.git/log/?h=yukuai/md-llbitmap

Yu Kuai (23):
  md: add a new parameter 'offset' to md_super_write()
  md: factor out a helper raid_is_456()
  md/md-bitmap: cleanup bitmap_ops->startwrite()
  md/md-bitmap: support discard for bitmap ops
  md/md-bitmap: remove parameter slot from bitmap_create()
  md/md-bitmap: add a new sysfs api bitmap_type
  md/md-bitmap: delay registration of bitmap_ops until creating bitmap
  md/md-bitmap: add a new method skip_sync_blocks() in bitmap_operations
  md/md-bitmap: add a new method blocks_synced() in bitmap_operations
  md: add a new recovery_flag MD_RECOVERY_LAZY_RECOVER
  md/md-bitmap: make method bitmap_ops->daemon_work optional
  md/md-bitmap: add macros for lockless bitmap
  md/md-bitmap: fix dm-raid max_write_behind setting
  md/dm-raid: remove max_write_behind setting limit
  md/md-llbitmap: implement llbitmap IO
  md/md-llbitmap: implement bit state machine
  md/md-llbitmap: implement APIs for page level dirty bits
    synchronization
  md/md-llbitmap: implement APIs to mange bitmap lifetime
  md/md-llbitmap: implement APIs to dirty bits and clear bits
  md/md-llbitmap: implement APIs for sync_thread
  md/md-llbitmap: implement all bitmap operations
  md/md-llbitmap: implement sysfs APIs
  md/md-llbitmap: add Kconfig

 Documentation/admin-guide/md.rst |   80 +-
 drivers/md/Kconfig               |   11 +
 drivers/md/Makefile              |    2 +-
 drivers/md/dm-raid.c             |    6 +-
 drivers/md/md-bitmap.c           |   50 +-
 drivers/md/md-bitmap.h           |   55 +-
 drivers/md/md-llbitmap.c         | 1556 ++++++++++++++++++++++++++++++
 drivers/md/md.c                  |  247 +++--
 drivers/md/md.h                  |   20 +-
 drivers/md/raid5.c               |    6 +
 10 files changed, 1901 insertions(+), 132 deletions(-)
 create mode 100644 drivers/md/md-llbitmap.c

-- 
2.39.2

