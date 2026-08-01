Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BD5D31E833;
	Sat,  1 Aug 2026 17:25:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785605130; cv=none; b=ciqxNXsOafd1CzY+3HBmy1UuOxf11LsjuN75skmnIeWIUivB3GSNgBDka6K68K7xrNvGDQqPiOi8TBPX6DMuKfOV5Q9nU/JMg6RCzWlWBm2ahhb2P/yf1RxJ7p2m0e2Q6MtU4EYDY9QbQwRSa76XH3B5bXW/bthZNRXl4AzF4pc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785605130; c=relaxed/simple;
	bh=ITBCQxO/geIJn05bsLxM3O4+0ky+Im3ifoJVIEb5jEk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=uYsSqn+KjfW49gnoxjclRK1IP65wijv1hmr78M6RTn0F229mEv4NBx44vd3j/HLdVttfrEypkt0GpPtss+dEKqKmCnlxEEE5AzpMFcJXSNhah9imznbnSfftwJ2hSMNEH+E0YJqInsKTxDFqhntReb+Ph2p9guHvTEyNe7R78Wg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jc9Er0+z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jc9Er0+z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97E321F00AC4;
	Sat,  1 Aug 2026 17:25:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785605129;
	bh=8F2hiMrIP8bSmjJbYxaLNcyokI+i3qtiXe6qJSIHWQg=;
	h=From:To:Cc:Subject:Date;
	b=jc9Er0+zxMrquqkoJ1Hj3vofa9RKT+8c6uNXskrswko39LsG7YM9wlRek2SU39eOS
	 en2lP7lhcWybs/1Br/N4DmePhcLnCQFMJ6TM7Mq/pbFXHKvu5pUgDbtqzbwYOyy83i
	 CTqGwRCCaWBO+RW+lEcelZHj3c3NZiUuegmm5cDHtnkWtyodtuUrcuiw36+Y0cHrN1
	 VrwYk4xxJBGBgYDhFEEGTYX2ci18xVlpGwQ8R1J3AVtzl+2F8Tg5i6iN0ekNa+Q58Y
	 J5RgJtBromW+NKIVqvrE6lthnGAIPGu2vRqrRvK1sO8Ww+2QVjI6UXrJyLFwWKvuG5
	 E1rJi1uYayq4A==
From: Yu Kuai <yukuai@kernel.org>
To: Song Liu <song@kernel.org>
Cc: Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	Mykola Marzhan <mykola@meshstor.io>,
	Su Yue <glass.su@suse.com>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v4 00/25] md: improve lockless bitmap reshape support
Date: Sun,  2 Aug 2026 01:24:54 +0800
Message-ID: <20260801172519.2982121-1-yukuai@kernel.org>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Yu Kuai <yukuai@fygo.io>

This series fixes several lockless bitmap accounting issues and adds the
missing llbitmap support for online reshape in RAID10 and RAID5.

llbitmap has different constraints from the existing bitmap code: there is
one live bitmap instance, each bit state has richer semantics, and reshape can
change the mapping from logical array ranges to bitmap ranges. Without exact
old/new geometry tracking and reshape-boundary splitting, write accounting can
use the wrong bitmap mapping or merge state across ranges that should be
checkpointed separately.

The first patches fix independent llbitmap and RAID5 correctness issues that
should be safe before the reshape work. The rest of the series adds exact
bitmap mapping hooks, tracks llbitmap reshape geometry, grows the page cache
for reshape, remaps checkpointed state as reshape advances, and wires RAID10
and RAID5 to split reshape-crossing bios before bitmap accounting and to mark
llbitmap reshape checkpoints.

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
  - Fix patch 15 to use READ_ONCE(mddev->reshape_position) in llbitmap reshape
    range mapping helpers instead of plain lockless reads.
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
  - Fix RAID5 writes past component size being skipped by llbitmap accounting
    in patch 11.
  - Fix stopped reshape reassembly losing target llbitmap geometry in patch 9.
  - Fix the page-cache-grow patch using target-geometry fields before they are
    introduced in patch 7.

Changes since v1:

  - Add Reviewed-by tags from Su Yue.
  - Rename llbitmap_resize_chunks() to llbitmap_calculate_chunks().
  - Use an unsigned index in llbitmap_expand_pages() error cleanup.
  - Rebase on mdraid/md-7.2, including the mddev_bio_split_at_reshape_offset()
    declaration needed by the RAID5 build reported by kernel test robot.

Previous versions:
  v3: https://lore.kernel.org/linux-raid/cover.1785206690.git.yukuai@fygo.io/
  v2: https://lore.kernel.org/linux-raid/cover.1782282042.git.yukuai@kernel.org/
  v1: https://lore.kernel.org/linux-raid/20260605091527.2463539-1-yukuai@kernel.org/

Yu Kuai (25):
  md/md-llbitmap: clear flush state after daemon flush
  md/md-llbitmap: use GFP_NOIO for cache allocations
  md/md-llbitmap: only end fully synced chunks
  md/raid5: reject zero-sector reshape chunks
  md/raid5: round bitmap stripes with sector division
  md: add exact bitmap mapping and reshape hooks
  md: skip bitmap accounting for empty write ranges
  md: add helper to split bios at reshape offset
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
 drivers/md/md-bitmap.h   |   9 +
 drivers/md/md-llbitmap.c | 717 +++++++++++++++++++++++++++++++++++----
 drivers/md/md.c          |  64 +++-
 drivers/md/md.h          |   8 +
 drivers/md/raid10.c      |  53 +++
 drivers/md/raid5.c       | 139 ++++++--
 7 files changed, 912 insertions(+), 86 deletions(-)


base-commit: 55b77337bdd088c77461588e5ec094421b89911b
-- 
2.51.0
