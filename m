Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88E8A2609EE;
	Wed, 24 Jun 2026 06:42:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782283344; cv=none; b=m2oyUgdN3mE+r7NmksSajOKolrvgIsmYW603TD11IA0QQeZYfxb7ZFBDIPkAtEEQtkydF180xTWU7uAgrRNvx8KrkRQGHFw7O45pv19t7mxh+6R/T6jIy+qb4nbtz1pNpd7HbmvwwZhBZ8S0jqjQU2OTo2WTPhoXEBM2fwM/fZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782283344; c=relaxed/simple;
	bh=PWTLzAcj34dXuiMcl3AUrEn4Tei1VLDvGg1ssu5R+Qg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dbyHHOeXaPBZkQNJg9rZT5z2aBnKYZZVp1O6xNvCcOtxr5EfOnhazfmKNAoWC7pc2ev3R/F4pBQeXSCyZf/Z1C2V4H4cOPWXzwcusdx+/s1Qowd7x7T/lATHzz+7RDNQK5o/hPhq5CvY0o5k37cbj0+nD+2FWHugaB7NQt2EhqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HSdH1mHs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HSdH1mHs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5309C1F000E9;
	Wed, 24 Jun 2026 06:42:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782283343;
	bh=uJBYcadendJz9KXTZcVxbu9g1/HwAB+oqCOZ0IxxxtE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HSdH1mHsZV6meT9V5aKmZfhRiH5eJtvtpCVEG4pDpSDyUInJzFa83quZVizMgyoIL
	 uZms+Jn+UCOuiO2Iis9Qgy4FzZH26tRRCDRq+D5qYvDFT9zpunroTkyrEd4RDdLOP0
	 njSuax02SyOn4DsQtwyEY0W3y10zPCbTns10vgwOss1ZHHvvj/vgvIBOWBNZ6HG6hO
	 8CalLaT9k+MfRoluE5Qar6TYFzsMOKCeDxfjvVw9+KQrVqrxAY9bdTg8MmKEkblYv1
	 kV3RsOaquZJmL3o4K1g7XPRzjp407F+J9denh9X610l8y1hHGCHwD/KseFakAay/P/
	 LW+WMwgSgZpEA==
From: Yu Kuai <yukuai@kernel.org>
To: Song Liu <song@kernel.org>,
	Yu Kuai <yukuai@fygo.io>
Cc: Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	Su Yue <glass.su@suse.com>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 00/20] md/md-llbitmap: support reshape for RAID10 and RAID5
Date: Wed, 24 Jun 2026 14:41:57 +0800
Message-ID: <cover.1782282042.git.yukuai@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260605091527.2463539-1-yukuai@kernel.org>
References: <20260605091527.2463539-1-yukuai@kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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

The first group of patches prepares generic bitmap and llbitmap
infrastructure. The second group wires RAID10. The last group wires RAID5,
including exact old/new stripe mapping.

Changes since v1:
- Add Reviewed-by tags from Su Yue.
- Rename llbitmap_resize_chunks() to llbitmap_calculate_chunks().
- Use an unsigned index in llbitmap_expand_pages() error cleanup.
- Rebase on mdraid/md-7.2, including the mddev_bio_split_at_reshape_offset()
  declaration needed by the RAID5 build reported by kernel test robot.

Validation:
* RAID5 llbitmap test:
  - created 3-disk RAID5 with --bitmap=lockless
  - wrote 96 MiB of random data
  - reshaped to 4 disks
  - llbitmap bits changed from clean=1024 dirty=1024 to
    unwritten=448 clean=1600 dirty=0
  - all sync-related llbitmap counters were zero after reshape
  - data hash was unchanged after reshape
  - replaced one disk, waited for recovery, hash was unchanged
  - failed another old disk and verified degraded reads still matched
* RAID10 llbitmap test:
  - created 4-disk RAID10 n2 with --bitmap=lockless
  - wrote 128 MiB of random data
  - reshaped to 6 disks
  - llbitmap bits changed from clean=2048 dirty=2048 to
    unwritten=2048 clean=4096 dirty=0
  - all sync-related llbitmap counters were zero after reshape
  - data hash was unchanged after reshape
  - replaced one disk, waited for recovery, hash was unchanged
  - failed the rebuilt disk's mirror mate and verified degraded reads still
    matched

Yu Kuai (20):
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
 drivers/md/md-bitmap.h   |   8 +
 drivers/md/md-llbitmap.c | 619 +++++++++++++++++++++++++++++++++++----
 drivers/md/md.c          |  60 +++-
 drivers/md/md.h          |   8 +
 drivers/md/raid10.c      |  49 ++++
 drivers/md/raid5.c       | 118 ++++++--
 7 files changed, 795 insertions(+), 75 deletions(-)


base-commit: 55b77337bdd088c77461588e5ec094421b89911b
-- 
2.51.0
