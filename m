Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6532926A0B9;
	Sun,  2 Aug 2026 19:50:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785700248; cv=none; b=aKqMAjf0XCuHxt5CoH3YExdk3PG687MIcjsjLnQ6mfmOxbYSGblw2lcb9amF3WhFh/4F/Pvj/bIw66sqdMBuRefrJbsM0+6PMVLXnNxdzZCOAwNIT5gmK0AxjiSxew1Jfm/+c9Kn32DS1a+Ag5lDLFORi66p8jhCO4ZJVQu3LSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785700248; c=relaxed/simple;
	bh=fyb5S3stjz0/Gjp/8Vwk+l8FFlnHDha/ZzfYaCSfd8s=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ja1Sd10p7FV/IYbMem/KjHLRc+0s/0ATdfEiO4ZfMAV78Ngdn2QRZ0fYqvWQvpwZnyOj1KvQVbvKzDxeRWXsdt2mDSki2fpXfr1vfh6WznNvaZCf6EklWj5XYZif1hKUKyki2B34hVZem3A+C211h0I0RDqikYoNbJDIG4XLt8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JN8JDO24; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JN8JDO24"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D816A1F000E9;
	Sun,  2 Aug 2026 19:50:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785700246;
	bh=FjIthU/gDMGzW4cTD3mOrRhwKW5jjfzmhyHX5fv6dqo=;
	h=From:To:Cc:Subject:Date;
	b=JN8JDO24aHQKttLuFoeSmHfsZ7wU8xHR9LMg/uTcKdZb3nYLrAsPS372UJsu49Bts
	 4kj0V5+jwiEATJUZcLROLL2aAez3+xUgXxBW+vgB/3ryVAKZzZtDymiHvuEPcOMipL
	 bPij1T2H1xnoUA7IQK3uwCBfyMDRw2X8F5AA8Y3hG4sfDGVBtADwoBz725TxiZmAFb
	 ohh+FQGXZmb+hq007ABQ8uuzwqbQl/L2iVBp3u8V7hVfz9JVbzUVg+23k8pWv34qys
	 naCGSTxDexQ0J6HPCeDtt/PDztzENWkpNIz0tOEFo90K2Ba9pRWeQm+oSM8GuWl5zy
	 sG+C3hWAHG0JQ==
From: Yu Kuai <yukuai@kernel.org>
To: Song Liu <song@kernel.org>,
	Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>
Cc: Yu Kuai <yukuai@fygo.io>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Mykola Marzhan <mykola@meshstor.io>,
	Su Yue <glass.su@suse.com>
Subject: [PATCH v5 00/29] md: improve lockless bitmap reshape support
Date: Mon,  3 Aug 2026 03:50:09 +0800
Message-ID: <20260802195038.164272-1-yukuai@kernel.org>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Yu Kuai <yukuai@fygo.io>

This series fixes several md/llbitmap and RAID5 bitmap-accounting
correctness issues, and adds the missing lockless bitmap support for
online reshape in RAID10 and RAID5.

llbitmap has different constraints from the existing bitmap code: there is
one live bitmap instance, each bit state has richer semantics, and reshape
can change the mapping from logical array ranges to bitmap ranges. Without
exact old/new geometry tracking, reshape-boundary splitting, and correct
teardown ordering, write accounting can use the wrong bitmap mapping, merge
state across ranges that should be checkpointed separately, or race with
freed llbitmap storage.

The first five patches fix standalone llbitmap and RAID5 correctness issues
that are independent of reshape. Patches 6-11 fix md core and llbitmap
lifetime/accounting prerequisites: behind-write teardown ordering, clone I/O
timestamp initialization, create-failure pointer lifetime, shutdown timer
rearm, empty bitmap ranges, and reshape-boundary bio splitting. Patch 12 adds
the common exact bitmap mapping and reshape hooks. The remaining patches
track and validate llbitmap geometry, grow the page cache for reshape, remap
checkpointed state as reshape advances, and wire RAID10 and RAID5 to split
reshape-crossing bios before bitmap accounting and to mark llbitmap reshape
checkpoints.

Changes since v4:

  - Rebase on mdraid/md-7.3, base commit 140234b2380f ("md/raid1: create
    serial pool adding rdev to array with serialize_policy=1").
  - Add Mykola Marzhan's Tested-by tag from the v4 cover-thread reply to the
    25 patches already present in v4; leave v5-only patches 6-9 without that
    tag.
  - Add patch 6 to call mddev_detach() before md_bitmap_destroy(), so
    bitmap_ops->wait_behind_writes() can drain behind writes before
    llbitmap storage is freed.
  - Add patch 7 to clear md_io_clone->start_time when queue I/O accounting
    is disabled, avoiding stale accounting timestamps from reused clone
    private data.
  - Add patch 8 to clear mddev->bitmap under bitmap_info.mutex before
    freeing llbitmap after create failure, avoiding a stale pointer for
    mutex-protected readers.
  - Add patch 9 to introduce the runtime-only BITMAP_SHUTDOWN state in
    llbitmap->flags, stop daemon timer/work rearming during llbitmap
    destroy, and mask the state while reading or writing the llbitmap
    superblock.
  - Move the common exact bitmap mapping and reshape hook patch from v4
    patch 6 to v5 patch 12, directly before the sync_size tracking patch, so
    earlier standalone fixes no longer depend on the new hook.
  - Fix patch 10 to keep empty-range handling valid before the exact mapping
    hook is introduced, and update the commit message to describe
    personality bitmap mapping instead of prepare_range().
  - Fix patch 13 to reject an on-disk llbitmap sync_size that exceeds
    mddev->resync_max_sectors when reading the bitmap superblock.
  - Fix patch 15 to use GFP_NOIO when expanding llbitmap page controls.
  - Fix patch 24 for the current raid10 wait_barrier() API after rebasing.
  - Fix patch 26 to compute the previous RAID5 bitmap array size from
    mddev->dev_sectors and conf->previous_raid_disks.

Changes since v3:

  - Add patch 1 to clear the sticky LLPageFlush state after daemon flush.
  - Add patch 2 to use GFP_NOIO for llbitmap cache and control allocations.
  - Add patch 3 to only checkpoint fully completed llbitmap sync chunks.
  - Add patch 4 to reject zero-sector RAID5 reshape chunks.
  - Fix patch 8 to snapshot mddev->reshape_position with READ_ONCE() while
    splitting reshape-crossing bios.
  - Fix patch 10 to keep the independently allocated page controls under the
    GFP_NOIO allocation policy added by patch 2.
  - Fix patch 11 to quiesce the array while llbitmap grows page controls
    during resize or reshape.
  - Fix patch 15 to use READ_ONCE(mddev->reshape_position) in llbitmap
    reshape range mapping helpers instead of plain lockless reads.
  - Fix patch 17 to serialize reshape checkpoint remapping against normal
    write/discard bitmap state updates with a rwlock, and copy overlapping
    remap ranges backwards when needed.
  - Fix patch 21 to end RAID10 write accounting if reshape bio splitting
    fails.
  - Fix patch 25 to resubmit the RAID5 front split bio after waiting for
    reshape instead of retrying the already-submitted remainder.

Changes since v2:

  - Fix RAID5 bitmap stripe rounding for non-power-of-two stripe widths in
    patch 1.
  - Fix partial discard chunks being marked unwritten in patch 11.
  - Fix RAID5 writes past component size being skipped by llbitmap
    accounting in patch 11.
  - Fix stopped reshape reassembly losing target llbitmap geometry in patch
    9.
  - Fix the page-cache-grow patch using target-geometry fields before they
    are introduced in patch 7.

Changes since v1:

  - Add Reviewed-by tags from Su Yue.
  - Rename llbitmap_resize_chunks() to llbitmap_calculate_chunks().
  - Use an unsigned index in llbitmap_expand_pages() error cleanup.
  - Rebase on mdraid/md-7.2, including the
    mddev_bio_split_at_reshape_offset() declaration needed by the RAID5
    build reported by kernel test robot.

Previous versions:
  v4: https://lore.kernel.org/linux-raid/20260801172519.2982121-1-yukuai@kernel.org/
  v3: https://lore.kernel.org/linux-raid/cover.1785206690.git.yukuai@fygo.io/
  v2: https://lore.kernel.org/linux-raid/cover.1782282042.git.yukuai@kernel.org/
  v1: https://lore.kernel.org/linux-raid/20260605091527.2463539-1-yukuai@kernel.org/

Yu Kuai (29):
  md/md-llbitmap: clear flush state after daemon flush
  md/md-llbitmap: use GFP_NOIO for cache allocations
  md/md-llbitmap: only end fully synced chunks
  md/raid5: reject zero-sector reshape chunks
  md/raid5: round bitmap stripes with sector division
  md: wait for behind writes before destroying bitmap
  md: avoid stale clone I/O accounting timestamps
  md/md-llbitmap: prevent create failure bitmap UAF
  md/md-llbitmap: stop daemon timer rearm on destroy
  md: skip bitmap accounting for empty write ranges
  md: add helper to split bios at reshape offset
  md: add exact bitmap mapping and reshape hooks
  md/md-llbitmap: track bitmap sync_size explicitly
  md/md-llbitmap: allocate page controls independently
  md/md-llbitmap: grow the page cache in place for reshape
  md/md-llbitmap: track target reshape geometry fields
  md/md-llbitmap: finish reshape geometry
  md/md-llbitmap: refuse reshape while llbitmap still needs sync
  md/md-llbitmap: add reshape range mapping helpers
  md/md-llbitmap: don't skip reshape ranges from bitmap state
  md/md-llbitmap: remap checkpointed bits as reshape progresses
  md/md-llbitmap: clamp state-machine walks to tracked bits
  md/raid10: reject llbitmap reshape when md chunk shrinks
  md/raid10: wire llbitmap reshape lifecycle
  md/raid10: split reshape bios before bitmap accounting
  md/raid5: add exact old and new llbitmap mapping helpers
  md/raid5: reject llbitmap reshape when md chunk shrinks
  md/raid5: wire llbitmap reshape lifecycle
  md/raid5: split reshape bios before bitmap accounting

 drivers/md/md-bitmap.c   |   8 +
 drivers/md/md-bitmap.h   |  10 +
 drivers/md/md-llbitmap.c | 740 +++++++++++++++++++++++++++++++++++----
 drivers/md/md.c          |  68 +++-
 drivers/md/md.h          |   8 +
 drivers/md/raid10.c      |  53 +++
 drivers/md/raid5.c       | 140 +++++++-
 7 files changed, 936 insertions(+), 91 deletions(-)

base-commit: 140234b2380ffb8ffb0cfc46fee0e822f43adef7
-- 
2.51.0
