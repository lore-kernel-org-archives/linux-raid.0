Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC1112E6CCD;
	Sun,  9 Aug 2026 07:56:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786262177; cv=none; b=KsGJuH4SzDp5bUh/dVI5tiQPkIpuvMAUIm+DoOqUy6UuC+6La3z6vST60E6DTq1PkC25cIfF2zXOBWqwRgLB/CkjAbGAI4cCwbQUGOocbW1RVXYCeELK6Rjo3X/eZhLJSN/Amwoh1nkRhy+HQBMmIr0HR+YqM3QTMemyaz0GSdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786262177; c=relaxed/simple;
	bh=hapr0W5lmg27Xiq/8fWJj6mKLQFem1ZUekmbRKfwmWg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=H9+hfebPA67k5cpYg+ckQpgBSwMy+K20G9tRCNBlHTX97C4+dyGQwN1oW2YlVX48wrFMEvI93go4iEQE/DU2ot8yFq1+emB+PDkQD/zAgqPMrVwAXSbQVlR/SFvm+XW8aeHVyn+pRJY2BXH0CfTsq/1V4dzigCJehqYh3VgVNG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hyl37Ckc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hyl37Ckc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 296401F000E9;
	Sun,  9 Aug 2026 07:56:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786262175;
	bh=TfI/tm/EmNvVDnQiGfcJ05LgMydETpsB65ylHbiSeXE=;
	h=From:To:Cc:Subject:Date;
	b=hyl37CkcA1Vfcdz7omwWdLX4axLAUiItg9LvxUYvZWaf124ZRcT9ztAOFkN5X/zz7
	 /rnXIM1IRl9YZqQSVmP1UJ9TMt63vNp5R/kqiVe5e+ebEHT/t2vgk/j3UY7ey8dEKy
	 2rwrj2Sl2uKhqQhTRoW/GSYfl5BFFBDeXOYnBGj4kfv7mzoFxbFfWwF4S2SY9+rvFD
	 oefJn8i1kJWkgG4xFotfrnO+yfEYm1imlTULRgsPhh8LRSnzYA5L4b0BdfN38Y32/3
	 4zauDmK3HsI8C/8ZISCXRXwXYMAiPgL7RYC5KfLX3lrZ1NqAljLSKKAqc6KHbIOve/
	 1dKCFZ2eBKQYA==
From: Yu Kuai <yukuai@kernel.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Yu Kuai <yukuai@fygo.io>,
	linux-raid@vger.kernel.org,
	linux-block@vger.kernel.org,
	Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>,
	Bruce Johnston <bjohnsto@redhat.com>,
	Chen Cheng <chencheng@fnnas.com>,
	Coly Li <colyli@fygo.io>,
	Genjian Zhang <zhanggenjian@kylinos.cn>,
	Hiroshi Nishida <nishidafmly@gmail.com>,
	Martin Wilck <mwilck@suse.com>,
	Sajal Gupta <sajal2005gupta@gmail.com>,
	Wale Zhang <wale.zhang.ftd@gmail.com>,
	Yunye Zhao <yunye.zhao@linux.alibaba.com>
Subject: [GIT PULL] md-7.3-20260809
Date: Sun,  9 Aug 2026 15:55:55 +0800
Message-ID: <20260809075555.3215963-1-yukuai@kernel.org>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Jens,

Please consider pulling the following changes into your for-7.3/block
branch.

Special Note:
- Remove incomplete REQ_NOWAIT support from RAID1, RAID10, and
  RAID4/5/6. These personalities can block internally, so a write can
  reach one member before another returns -EAGAIN. MD cannot distinguish
  queue pressure from a device failure or safely retry the partially
  completed write, which can leave mirrors with divergent data. Keeping
  REQ_NOWAIT advertised for these personalities is therefore unsafe.

  Returning -EAGAIN after one member rejects the bio still exposes any
  writes already submitted to other members. Retrying the whole write
  without REQ_NOWAIT would violate the caller's non-blocking request and
  cannot undo member writes that already completed. Treating -EAGAIN as
  a device failure would incorrectly fault healthy devices under
  transient queue pressure. Prechecking every member queue is also not
  sufficient because it cannot reserve capacity, so a later submission
  can still block or fail.

  A coordinated all-member submission and retry model would require a
  larger redesign. Until that exists, not advertising REQ_NOWAIT for
  these personalities is the only safe behavior.
  (Abd-Alrhman Masalkhi)

This pull request contains:

Bug Fixes:
- Protect RAID5 bitmap batching, stripe-cache limits, and reshape
  recovery state; avoid failed-device reshape deadlocks, discard hangs,
  and PPL use-after-free. (Chen Cheng, Genjian Zhang, Sajal Gupta)
- Recheck spare changes under array suspension before sync to avoid
  racing device removal. (Abd-Alrhman Masalkhi)
- Fix RAID1 atomic-write constraints, serialized-device setup, and
  takeover I/O freezes. (Abd-Alrhman Masalkhi, Martin Wilck,
  Bruce Johnston)
- Fix RAID10 atomic-write failure handling and reshape pool/bio lifetime
  bugs. (Abd-Alrhman Masalkhi, Chen Cheng)
- Fix bitmap error recovery, flush/sync accounting, reclaim safety,
  teardown, timer, use-after-free, and empty-range bugs, plus stale
  clone I/O accounting. (Chen Cheng, Yu Kuai)
- Reject zero-sector RAID5 reshape chunks and correctly round bitmap
  ranges for non-power-of-two stripe widths. (Yu Kuai)
- Prevent PF_MEMALLOC_NOIO state from leaking across tasks. (Chen Cheng)
- Validate bad-block-log shift bounds and skip discard on unsupported
  member devices. (Coly Li, Wale Zhang)
- Prevent RAID10 recovery corruption and large-array resync soft
  lockups. (Yunye Zhao)

Improvements:
- Add lockless bitmap reshape support for RAID5 and RAID10, including
  exact old/new mapping, cache growth, geometry lifecycle, checkpoint
  remapping, and bio splitting. (Yu Kuai)

Cleanups:
- Make RAID1 sequential-read hint accesses explicit to suppress false
  KCSAN reports. (Chen Cheng)
- Remove redundant RAID10 barrier handling and align badblock range
  types. (Abd-Alrhman Masalkhi, Hiroshi Nishida)

Thanks,
Kuai

---

The following changes since commit f5098b6bae761e346ebcd9da7f95622c04733cff:

  Linux 7.2-rc5 (2026-07-26 14:45:48 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/mdraid/linux.git tags/md-7.3-20260809

for you to fetch changes up to dc386aa0ac0a3ec06c9a3ea9b064b073fb72a916:

  md/raid1: don't set array_frozen in raid1_takeover() (2026-08-07 16:49:22 +0800)

----------------------------------------------------------------
Abd-Alrhman Masalkhi (5):
      md: remove REQ_NOWAIT support from raid1/10/456
      md: recheck spare changes before starting sync
      md/raid1: restrict atomic write limits and handle runtime constraints
      md/raid10: consistently fail atomic writes that require splitting
      md/raid10: remove unnecessary barrier around bio_submit_split_bioset()

Bruce Johnston (1):
      md/raid1: don't set array_frozen in raid1_takeover()

Chen Cheng (10):
      md/raid5: protect bitmap batch counters aka seq_flush/seq_write consistency
      md/raid1: protect sequential read hints for read balance
      md/raid5: fix lockless max_nr_stripes reads
      md/raid5: fix reshape deadlock while failed devices more than max degraded
      md/raid5: protect lockless recovery_offset accesses during reshape
      md: suspend array when sync_action=reshape
      md/raid10: resize r10bio_pool for reshape
      md/raid10: free r10bio before ending master_bio in raid_end_bio_io() and raid_end_discard_bio()
      md/bitmap: resume array on backlog_store() error path
      md: scope memalloc_noio to allocation critical sections

Coly Li (1):
      md: do overflow check for sb->bblog_shift in super_1_load()

Genjian Zhang (1):
      md/raid5: complete discard bios while reshape is active

Hiroshi Nishida (1):
      md: widen badblock sectors param from int to sector_t

Martin Wilck (1):
      md/raid1: create serial pool adding rdev to array with serialize_policy=1

Sajal Gupta (1):
      md/raid5-ppl: fix use-after-free in ppl_do_flush()

Wale Zhang (1):
      md: skip discard on unsupported member devices

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

Yunye Zhao (2):
      md/raid10: fix still_degraded being inverted in raid10_sync_request()
      md: add cond_resched() to md_do_sync()'s skip path

 drivers/md/md-bitmap.c   |  22 +-
 drivers/md/md-bitmap.h   |  12 +-
 drivers/md/md-linear.c   |   1 +
 drivers/md/md-llbitmap.c | 752 ++++++++++++++++++++++++++++++++++++++++++-----
 drivers/md/md.c          | 178 ++++++++---
 drivers/md/md.h          |  15 +-
 drivers/md/raid0.c       |   1 +
 drivers/md/raid1-10.c    |   8 +-
 drivers/md/raid1.c       | 139 +++------
 drivers/md/raid10.c      | 227 +++++++-------
 drivers/md/raid10.h      |   2 +-
 drivers/md/raid5-ppl.c   |   4 +-
 drivers/md/raid5.c       | 318 +++++++++++++++-----
 13 files changed, 1278 insertions(+), 401 deletions(-)
