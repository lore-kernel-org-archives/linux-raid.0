Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFCEB2147F9
	for <linux-raid@vger.kernel.org>; Sun, 26 Jul 2026 18:59:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785092364; cv=none; b=crdiNVuf+UrtKZEXHSY2vj61wLscScnbB4nUH/1yk6ihhHg3EsJhBL3mu1Bqi2fs5FBJmssAoLuPpdRr1F918NezcxjqJVFAb5Orwg9P+spEWQtlrhPBW0ie/UvyNu2yXRAvFSISW1X+ZzUYtxwaf/U2OAmsdQW8umLp/cnrxHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785092364; c=relaxed/simple;
	bh=IdjpfmR5JrmcfJN6pLq8EHZxu9rUxZQHKTSLzTdStNY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iquix3IGxE0EKz6tOvoVLtvLnwW6QD0bHaouRhQhMV5BZduh5BMwoYJmMdDYnFX5SIkd+qCycyyUbTQLWJlT+DL0Rl7J0HEb9/NwE+3ntQM3irVCK8O7qpRqsaGJLotTG5b/kLL49a7waHTJuppRdukwGIjS6ozSzQQl5BMhbp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meshstor.io; spf=pass smtp.mailfrom=meshstor.io; dkim=pass (2048-bit key) header.d=meshstor.io header.i=@meshstor.io header.b=NvCxudN4; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meshstor.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meshstor.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meshstor.io header.i=@meshstor.io header.b="NvCxudN4"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-495635a85d2so17030345e9.0
        for <linux-raid@vger.kernel.org>; Sun, 26 Jul 2026 11:59:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=meshstor.io; s=google; t=1785092361; x=1785697161; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=R9UhRTiLDX3Km2ingdoARXXNg0MRKcE3RT1dwBwlR8k=;
        b=NvCxudN4/zZG7ty0YE5kwOSd9N2yHFPTCQ/XQBrMI6vLZoa50WvceqPSbH0ZSwP9+L
         FTf3dkU/d8gscADmivCuRnlBILVva1+vhEHZRVGs9GI65GhklwuoOm/UfdJQiKGZxbKl
         g8LOQQ4KBS3kwiJuxLq398RPRiVDkS/iAEMwK0JdwJjcw72hpyjaD8Ooh/cMb9MeE2UZ
         IWKVp/+uVLNbaAmsOVQbROtuAsqovwJygfiXLLxzgu37p+bDDaVZjwJcRFf2IHgot6a1
         wuI+eCizVkE4LFD1LurpF0HyWTVDKIL9Vk4opHMozpJ7ZJc8aRbY4nBxG1g8/BJ8ugYM
         vfHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785092361; x=1785697161;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=R9UhRTiLDX3Km2ingdoARXXNg0MRKcE3RT1dwBwlR8k=;
        b=l0IuqoMPiceiG7+pLhWjnMIfRc4F6jFHdO5BP2e7A96YZHo59DRIASYObimhLzRsmf
         eHt5+BMWOnf9faG2YX0VX6+dNjZE+/3vv8jojMZd+CrqqyvMz/719UmFfDDlncBC1pd4
         4Nzt84p1LedHvA0Zk692wwOn7fIcx+apWW8a9GTIaksbmKAbrpFnxg5AkHjnFaJ61xfX
         YLEe1Kfn+tjiSAXBsF+b3YNo6mQ6lbPhX47lruJU7FhkNWTYTMWVRZv0Q6kJ5/tFbmK7
         adaXnW6BTL7x1LySNDlH3+slI5DEMWtdsdlEOKnGcNn5wAqg8x5HUPF1/V9Bm0PgFKLs
         +Ceg==
X-Forwarded-Encrypted: i=1; AHgh+RrN6hnZ6K8ZOqYXw2qN3cZijwlRLTtnuOd7DWcmfkAoc6At8r1s/DvHAeRy2SsvxEseHxK3874YO6fi@vger.kernel.org
X-Gm-Message-State: AOJu0YzSap+jwo6QMPfAF5CT6T9l01zqXzIpjOJzvwDzCtrSrv6U0oX5
	H0ZUQkzFu5OoyI0ekfa2NCa2Tju6PH5nvACDv7EdI/DTwej7j9M5TwzvX+cG4A2xdo5sPP6aS/m
	DmH9Nswe+8EA=
X-Gm-Gg: AR+sD1208t3dWoBjnOcWJucwwuh4fp7aFXWzhK/aBuR6b3V9zlxvaKcepCB4tSLldDz
	bFlVc+uAP06vKgnew/FIAEnLrjmB23L4+7K/qjz9+mJMJr7iboa6pHeWyMRMnZ2MT575iR4YCId
	DbPFk56eWBByEOHeE/laLximBmoVQaE67A4EDwThyzBKdSeQv7yT2JWSBS8d/G5yyr081AQ56NM
	Z1DZiQ0fJV5pTGdfdDhIqqcVpa0nK4SvM9FdHUWkui5ly4ey2LT8lgoojovHUjvyUXmUJgbhTus
	YtMpLMtHlop7V3qj/hj/m28YyYAqtFotg75hx8ii566tARqA2umZrHIZm5n0CY8N8E/h1DQH+lV
	Tb0IOZoE+WZJDEBArD/Rg3A12vIWZnSyQT11u8Ei4DQNUlSXT/+UyGgj28uhQHnU73KjkP/UPQ3
	BqavetzMjOvxSrLUNVFpcioYZRIy6L/8dGf1eN2lI13MmaPWNf+FTUpg4ujMggKQkjPRBZpE28g
	FswhEFbBLEKFKksOCpS+mbhaGplCl+44/kUg9+hrQ==
X-Received: by 2002:a05:600c:19c9:b0:492:4a50:41fe with SMTP id 5b1f17b1804b1-496b56ff171mr81864325e9.22.1785092359908;
        Sun, 26 Jul 2026 11:59:19 -0700 (PDT)
Received: from meshstor-pc ([185.87.42.56])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-496b4ed6b76sm168041165e9.2.2026.07.26.11.59.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Jul 2026 11:59:19 -0700 (PDT)
From: Mykola Marzhan <mykola@meshstor.io>
To: Yu Kuai <yukuai@kernel.org>
Cc: Song Liu <song@kernel.org>,
	Yu Kuai <yukuai@fygo.io>,
	Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	Su Yue <glass.su@suse.com>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 00/20] md/md-llbitmap: support reshape for RAID10 and RAID5
Date: Sun, 26 Jul 2026 20:59:15 +0200
Message-ID: <20260726185916.2223460-1-mykola@meshstor.io>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1782282042.git.yukuai@kernel.org>
References: <20260605091527.2463539-1-yukuai@kernel.org> <cover.1782282042.git.yukuai@kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Kuai,

We ran v2 through a QEMU test campaign while preparing our own llbitmap
patches, which we will rebase on top of this series: raid1/raid5/raid10
over loop devices, base 55b77337bdd0 ("md/raid5: avoid R5_Overlap races
while breaking stripe batches") with and without the series applied,
KASAN kernels for the reshape stress, and per-bit bitmap dumps as the
oracle. Four problems, worst first — details under each number below:

1. raid5: writes above dev_sectors stop being tracked (steady state,
   no reshape involved)                                 [patches 02,12]
2. a stopped and re-assembled reshape resumes with the pre-reshape
   bitmap geometry, and persists it                     [patch 08]
3. discard can mark a chunk unwritten while half of it still holds
   live data (raid1)                                    [patch 10]
4. pre-existing: raid5_bitmap_sector() rounds with round_down() on a
   non-power-of-2 size — bits land in the wrong stripe; fix offered
                                                        [base, patch 12]

Happy to rerun the whole campaign on v3 and, if it comes back clean,
follow up with Tested-by. We'll post the test scripts in-thread if
useful.

1. raid5: writes above dev_sectors stop being tracked

llbitmap_map_layout() (patch 12) compares an array sector against
llbitmap_logical_size(). Outside a reshape llbitmap_reshaping() is
false, so that falls through llbitmap_personality_sync_size() to
llbitmap->sync_size — which raid5_run() set from
mddev->resync_max_sectors = mddev->dev_sectors, a per-device count.
An array sector compared against a device-sector limit: every write
above array sector dev_sectors gets *sectors = 0, and with patch 02's
early return the bitmap is never touched.

On a 4-disk raid5 tracking stops after the first third of the array,
on a 7-disk after the first sixth; a crash would then leave everything
above that boundary out of the post-crash resync. raid1/raid10 are
unaffected (their resync_max_sectors is the array size), and *during*
a reshape the correct bitmap_array_sectors is consulted — the problem
only shows in steady state.

Measured (one 4k write below the limit, one above, count new dirty
bits): patched 4-disk +1/+0, patched 7-disk +1/+0; base +1/+1 both.

Is llbitmap_logical_size() meant to return array sectors
unconditionally (i.e. consult patch 17's bitmap_array_sectors outside
reshape too), or should llbitmap_map_layout() convert before
comparing? The two helpers currently mix coordinate spaces for
raid456.

2. resumed reshape reverts the bitmap geometry

Two things combine:

- md_run() calls md_bitmap_create() before assigning mddev->pers, so
  llbitmap_refresh_reshape() (patch 08) runs with mddev->pers == NULL
  and llbitmap_personality_sync_size() bails out to the pre-reshape
  sync_size from the superblock;
- on a resumed reshape md never calls pers->start_reshape() — with
  reshape_position != MaxSector only check_reshape() runs — so
  bitmap_ops->resize() is never re-invoked either.

llbitmap_reshape_finish() then commits the stale geometry and
llbitmap_update_sb() persists it, so the revert is permanent: pages
beyond the old used_pages are returned zeroed by llbitmap_read_page()
instead of read from disk.

Reproduces in ~90s on raid10 4->6: grow, stop mid-reshape,
re-assemble — llbitmap/metadata chunks read 8128 -> 12192 -> 8128.
mdadm --grow --continue does not help. raid5 disk-add is immune
(device-indexed bitmap, the resize is a no-op), which makes it a
clean control.

Possible directions: re-run llbitmap_refresh_reshape() once
mddev->pers is set, or have the resume path call
bitmap_ops->resize(). Moving md_bitmap_create() after the pers
assignment would also do it, but we did not audit what else depends
on the current order.

3. sub-chunk discard marks a live chunk unwritten

llbitmap_start_discard() computes its first bit with
DIV_ROUND_UP_SECTOR_T(offset, chunksize) precisely so a partially
discarded head chunk is not touched. Patch 10 makes
llbitmap_prepare_range() run llbitmap_encode_range() on every op,
which floors the offset to a chunk boundary first — the DIV_ROUND_UP
has nothing left to round. raid1/raid10 previously had no
bitmap_sector hook, so raw offsets reached start_discard and the
guard worked.

Test, on raid1: write a pattern, then discard [K+0.5 chunks,
K+1.5 chunks) — a range that fully contains no chunk, so ideally zero
chunks change state. Base flips 1 (the tail chunk — pre-existing,
arguably the same class of problem on the other end), patched flips
2. The extra one is chunk K, whose first half still holds the
pattern.

Maybe encode_range should be skipped for discard, or start_discard
should take the raw offset.

4. pre-existing: raid5_bitmap_sector() rounding is wrong for
   non-power-of-2 data-disk counts

	sectors_per_chunk = conf->chunk_sectors *
		(conf->raid_disks - conf->max_degraded);
	start = round_down(start, sectors_per_chunk);
	end = round_up(end, sectors_per_chunk);

round_down()/round_up() are mask-based and require power-of-2
alignment; chunk_sectors is a power of 2, but multiplied by 3, 5, 6
or 7 data disks the product is not. The rounded sector is then not
stripe-aligned and raid5_compute_sector() maps it into a different
stripe: the bits marked and the bits covering the write are disjoint.
Lost bits, not wide bits.

Per-bit dumps, no reshape running: 3 data disks lose 20/20 targeted
writes, 6 data disks 17/17, the 4-data (power-of-2) control 0/20.
Byte-identical on the unpatched base, so not this series' bug — but
patch 12 routes this mapping into the reshape remap path, so it
matters more afterwards.

The fix needs division-based rounding (sector_div(), these are
sector_t). We can send a standalone patch, or you can fold it into
v3 — whichever is easier.

One gap in our coverage: raid10 grow under sustained IO currently
floods KASAN with pre-existing slab-out-of-bounds reports from the
r10bio width mismatch (free_r10bio() / raid10_make_request()) —
reproduced on the unpatched base too; none of the sites is touched by
your series. That is what Chen Cheng's "md/raid10: fix r10bio width
mismatches across reshape" fixes:

  https://lore.kernel.org/linux-raid/20260711100352.425177-1-chencheng@fnnas.com/

Our reproduction data is in that thread; we will re-run the
raid10-grow KASAN leg here once it lands.

Thanks,
Mykola
