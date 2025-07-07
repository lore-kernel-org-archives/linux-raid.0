Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52F092356C0
	for <linux-raid@vger.kernel.org>; Mon,  7 Jul 2025 16:52:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751907168; cv=none; b=GHPDbSDY9YOp1EyZoKOahtWMCiTTY/g9zXmAgQnGHpbRPfSGYPxPdTFRJtSFd5GohfZbWbZe2rGdPTzmMHTHSDZ9kEzhc5v5uqluQO6I+n2+aF88b5HF/xJT4Ty/lzvFkLKVWNv5W6UVnOUkAMFAjgbKuWTGAsnJBrH6SGdzJgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751907168; c=relaxed/simple;
	bh=RZUoRsbocc/hsUuabayYTDWRjoBYwnN5piYyqkRG16E=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=fP1vLRpCXsXDeKOAace4xVavSZ4MoovSXzvM0EsAuOiuzRK7c0Jb1Cb42uZRm0kx8wg53wbiYg2n3XU0x07uk/MIidc9/IPA5iHTr6L8Qh4MVjpljxYqi0J4zZGRE5H8UV/uwlk3+A8jTXKDB4UnppVC0UZJiA8uCv/wCrsfAs4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZM9XcC3F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZM9XcC3F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBD11C4CEE3;
	Mon,  7 Jul 2025 16:52:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751907167;
	bh=RZUoRsbocc/hsUuabayYTDWRjoBYwnN5piYyqkRG16E=;
	h=From:To:Cc:Subject:Date:From;
	b=ZM9XcC3FxgOmOxE9Nst2fGr4XmKa6B91QNqftWtY7X1l8W5JQY571aWcc6xbeFui0
	 7BHJ2tTAOGejpRao9lWIHpnyA6AnK2v0BZkC2be4ejIO+Kaw4FZu5KxP2AjtD18sf4
	 42jF3SGbH5YNuAZvcfA9Yj4O8iGVX8H+VTPjohSFuXbqWvf519GJ0oDCQ4X6IKjw0f
	 C5nT3ZFJCUF+4WGtCe+GvqpxnkP0+FLycxZxsV8rfpugpk6ZfXou4oc+m1Kq0aa96E
	 N4STRbmEg54K/r8Q599V7A42lonyA1JOn5DZ/iWl1ACezDZV9nTIEmDSmcmW+RWjgH
	 8G2h/y2L75SAQ==
From: Yu Kuai <yukuai@kernel.org>
To: hch@lst.de,
	hare@suse.de,
	xni@redhat.com,
	axboe@kernel.dk,
	linux-raid@vger.kernel.org,
	song@kernel.org
Cc: yukuai3@huawei.com,
	yangerkun@huawei.com,
	yi.zhang@huawei.com,
	johnny.chenyi@huawei.com
Subject: [PATCH v2 00/11] md/llbitmap: md/md-llbitmap: introduce a new lockless bitmap
Date: Tue,  8 Jul 2025 00:51:51 +0800
Message-ID: <20250707165202.11073-1-yukuai@kernel.org>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Yu Kuai <yukuai3@huawei.com>

Changes from v1:
 - explain md_bitmap_fn in commit message, patch 3;
 - handle the case CONFIG_MD_BITMAP is disabled, patch 4;
 - split patch 7 from v1 into patch 5 + 6;
 - rewrite bitmap_type_store, patch 5;
 - fix dm-raid regerssion that md-bitmap sysfs entries should not be
 created under mddev kobject, patch 6
 - merge llbitmap patches into one patch, with lots of cleanups;
 - add review tag:
  - patch 1,2,7,8,9,10 from Christoph
  - patch 1,2,7,8,10 from Hannes
  - patch 1,2,3,7 from Xiao

v1: https://lore.kernel.org/all/20250524061320.370630-1-yukuai1@huaweicloud.com/
RFC: https://lore.kernel.org/all/20250512011927.2809400-1-yukuai1@huaweicloud.com/

Branch for review:
https://git.kernel.org/pub/scm/linux/kernel/git/yukuai/linux.git/log/?h=yukuai/md-llbitmap-v2

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

Yu Kuai (11):
  md: add a new parameter 'offset' to md_super_write()
  md: factor out a helper raid_is_456()
  md/md-bitmap: support discard for bitmap ops
  md: add a new mddev field 'bitmap_id'
  md/md-bitmap: add a new sysfs api bitmap_type
  md/md-bitmap: delay registration of bitmap_ops until creating bitmap
  md/md-bitmap: add a new method skip_sync_blocks() in bitmap_operations
  md/md-bitmap: add a new method blocks_synced() in bitmap_operations
  md: add a new recovery_flag MD_RECOVERY_LAZY_RECOVER
  md/md-bitmap: make method bitmap_ops->daemon_work optional
  md/md-llbitmap: introduce new lockless bitmap

 Documentation/admin-guide/md.rst |   80 +-
 drivers/md/Kconfig               |   11 +
 drivers/md/Makefile              |    1 +
 drivers/md/md-bitmap.c           |   15 +-
 drivers/md/md-bitmap.h           |   45 +-
 drivers/md/md-llbitmap.c         | 1551 ++++++++++++++++++++++++++++++
 drivers/md/md.c                  |  286 ++++--
 drivers/md/md.h                  |   20 +-
 drivers/md/raid5.c               |    6 +
 9 files changed, 1906 insertions(+), 109 deletions(-)
 create mode 100644 drivers/md/md-llbitmap.c

-- 
2.43.0

