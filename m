Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDEDC403B0A;
	Tue, 28 Jul 2026 08:49:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785228572; cv=none; b=bkyBBWbH6L7QrwH7pAHDUzbSbNy/DtaqH0x49xu9iyAkwe9r61IiOPZUsOmplXJFTDIcs4kfwqZ5CNi/aJBszikrLHy7NeyGKUcofbMjrMKuxa8P06iNb8XB0Znt99+Ush0+wNWOkZ34iUwiiyvSHOP2c0K+8LmHqvt49ti0R9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785228572; c=relaxed/simple;
	bh=mQqlBMv9Sp1ern8qT8jah+C+eIRCzBg0b+XcVkbK39w=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=IbW4Sc08s8e8QLnNJSFE8FKWtdRPvuFHlh7XM/RXwxFUtEfwYvu3jFMNAuUG/eLdbXQqxi+cEpo6Ccsnye7Quuo29vaVWu2Y4oQujReJ177gF0EjDaWKC9RGSIQsrvv2tULRSxpEYkPwvs7vh/2VyHmZsbGaZyrkf7ulKh8PGck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YWg+EloO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YWg+EloO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 667D81F000E9;
	Tue, 28 Jul 2026 08:49:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785228571;
	bh=9sHdnRAw9KVeAOhuFwMI5Y2cNs0AQ6r5R0HPoddbmCI=;
	h=From:To:Cc:Subject:Date;
	b=YWg+EloOqoxdkGI+BbaGJ9WKIH00vur89j+TdZ2GCIQd/v2JNBaG6K3vXfWacRXIZ
	 RRGXu+hOL/l9SF9LYbObh7KVGp/fWWopY8H9m7vSK7FeN+pXcrRpyfMow9gNJKTuzf
	 ekBUR9lQ6++obEjFYOQ5xb8wwax84TvuWOYXGQumO9cOXeeQi4EKyQ4OOZRHjUjQo2
	 QbBwzgOJWo/YOTVjv1wErOQTnZOGG4FXAs8Q2Sssn/6v6klxnTj/h+1cY2TAZtzE6i
	 JiWKoiyRUwiitAhVcTXMswyCmXA4MLpi+JE2A9LXHTgkkL8iLIqoLiB18GiqWHv4OP
	 w9sZPZtla1e4Q==
From: Yu Kuai <yukuai@kernel.org>
To: Song Liu <song@kernel.org>
Cc: Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	Mykola Marzhan <mykola@meshstor.io>,
	Su Yue <glass.su@suse.com>,
	yukuai@fygo.io,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 00/21] md/md-llbitmap: support reshape for RAID10 and RAID5
Date: Tue, 28 Jul 2026 16:49:00 +0800
Message-ID: <cover.1785206690.git.yukuai@fygo.io>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Yu Kuai <yukuai@fygo.io>

Hi,

This series adds llbitmap support for online reshape in RAID10 and RAID5.

llbitmap has a different set of constraints from the existing bitmap code:
there is one live bitmap instance, each bit state has richer semantics, and
reshape can change the mapping from logical array ranges to bitmap ranges.
The series therefore adds exact bitmap range mapping hooks, tracks old and
new llbitmap geometry during reshape, remaps checkpointed bits as reshape
progresses, and wires the reshape lifecycle into RAID10 and RAID5.

The main rules are:

1. split bios at the reshape position before bitmap accounting, so one bio
   is never accounted with mixed old/new geometry;
2. do not skip reshape ranges from stale llbitmap state, because reshape
   progress is checkpointed by array metadata;
3. remap llbitmap bits when reshape progress is checkpointed;
4. reject llbitmap reshape if mddev->chunk_sectors shrinks, because the
   effective data range represented by existing bitmap bits can shrink.

The first patch fixes RAID5 bitmap stripe rounding before the exact mapping
hooks are added, so the later RAID5 helper split starts from correct
sector_t division semantics. The rest of the series prepares generic bitmap
and llbitmap infrastructure, wires RAID10, and then wires RAID5 with exact
old/new stripe mapping.

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

Yu Kuai (21):
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
 drivers/md/md-llbitmap.c | 659 ++++++++++++++++++++++++++++++++++++---
 drivers/md/md.c          |  64 +++-
 drivers/md/md.h          |   8 +
 drivers/md/raid10.c      |  49 +++
 drivers/md/raid5.c       | 123 ++++++--
 7 files changed, 842 insertions(+), 78 deletions(-)


base-commit: 55b77337bdd088c77461588e5ec094421b89911b
-- 
2.51.0
