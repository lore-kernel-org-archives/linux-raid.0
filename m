Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA229253F13;
	Fri,  5 Jun 2026 09:15:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780650932; cv=none; b=JaOC4p2Rt6b2T5WBIsmRRvBA1Dkswbd0yV0+b2rnrykGCRJAyKJZGbpfntTdHW9PjoewNHiusMgOSMyWnbzpYhY31s3bNsn3Ky2try6agtmtOMIij/8KjWUebWO3Bxy/rhAr/kInp9tOpGMgEGiYCMT3J2uxReOJmYUbUyeBUo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780650932; c=relaxed/simple;
	bh=kKYnh1KTfzKKVVYk4xKBk4AFMuOaqxOlClU8fj/GTN8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=onM9p0RvhfcnXQZxu7waAkfAp0a2wjaiwLjuj0RZ+VkIXTOuBjUhMwD3tjnYynbRt5CjuAPsU60+NdZLb9+/vkvhAl/bUC6nd3Uynqj6rLc8gUVBSNCaXEi4Z+Y7/voPuLLNWfc+VfhbXBx1h4VrzGN/nGFSB+rJc6pKWzvtjpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=b7ao523N; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b7ao523N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2A331F00893;
	Fri,  5 Jun 2026 09:15:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780650931;
	bh=ZLOMwTOaiORIb7yIrkAsJ0xVILItBha8esl3l9FqfOE=;
	h=From:To:Cc:Subject:Date;
	b=b7ao523Nm2ZTOLkb67ScPFwqyrxp4rEXsExGtpO2XDB3SH5iI8JnZCsSEyUxU0UxA
	 PNjqEQf4x23R3V9CuuxxeL1nrnZNHJEe13nN2jal3NvdB+Rgt02+Hjj80plF2WzbMR
	 qEOT7LdKPL8go5ISlFsPlju9i1W+KTWVN4CHvn51DgGQM1f5SkwV9aBmP7l2qs5USL
	 tdduVYe7IMybQQ2T8KvRCWBcaV6jI8u0SrZubDk575b7ZdEEbLiW8FE4AdeQ4FMiAW
	 WFuMbZuWercP8O1m2ciIgzIpYxEK3uEURvgp+j02t6F1BdokMr+bHckxKpuLRCOwAi
	 DRT9D4Em2ooSQ==
From: Yu Kuai <yukuai@kernel.org>
To: Song Liu <song@kernel.org>,
	Yu Kuai <yukuai@fygo.io>
Cc: Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 00/20] md/md-llbitmap: support reshape for RAID10 and RAID5
Date: Fri,  5 Jun 2026 17:15:07 +0800
Message-ID: <20260605091527.2463539-1-yukuai@kernel.org>
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

The first group of patches prepares generic bitmap and llbitmap
infrastructure.  The second group wires RAID10.  The last group wires
RAID5, including exact old/new stripe mapping.

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
 drivers/md/md-llbitmap.c | 616 +++++++++++++++++++++++++++++++++++----
 drivers/md/md.c          |  60 +++-
 drivers/md/md.h          |   8 +
 drivers/md/raid10.c      |  50 +++-
 drivers/md/raid5.c       | 118 ++++++--
 7 files changed, 793 insertions(+), 75 deletions(-)

-- 
2.51.0
