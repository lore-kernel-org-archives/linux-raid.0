Received: from va-2-47.ptr.blmpb.com (va-2-47.ptr.blmpb.com [209.127.231.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B9C23A1CD
	for <linux-raid@vger.kernel.org>; Mon, 27 Jul 2026 06:51:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785135122; cv=none; b=p9dgK8cK0QbDo/4WKvm6rBl9fA6lM0iE5Ru8Jdo6n5lqZ6KxjX9NXRMiTImWasYgnwBq/LJE2ghseDY6Ra6TF7tI5Hg9GW3CPGv5pRUiQvM7e7b8LxT10yd+zKa+eU0l6S7hkJaW09qCeo83JTjBHLaW5i0NaDIovjc6jcWOsyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785135122; c=relaxed/simple;
	bh=GlA6f57qs6mFM2ZDWIh/ACls+MJuQLl1LcmKtF6Hb2k=;
	h=Subject:Date:Message-Id:Mime-Version:Content-Type:From:References:
	 To:Cc:In-Reply-To; b=ekxwegAhY2labOxINoLPc9dM08oyKt9ILMYSQWqsyYgmuKnyQCany6VmD3sFIi3dWDfVdNV09l1Km/3T80h0G8rINcfgG+awSjpnjKyUUvZJUQF1Qfop0LcNKfUhc88Uc87QNicx4CBBzSPFtlkb/oJmUw6tML/yAG+eJQOdTx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=DH1O+9oA; arc=none smtp.client-ip=209.127.231.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="DH1O+9oA"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1785135114;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=H9L2DK0A8zU5mp5UyShNg5LKfKuq1d6rxKl/5avE/4Y=;
 b=DH1O+9oAVWRPV/F+vihRDQ/oylrhuzagE31mLqlWqjuvy1sdZWGoGaW4ldGprLPYAi1psK
 yREmgKyiVnkrR5u8tCBhC6IXT8lXNRjIonWwdpBHF4PxJQJkFWfxpF5muYW0UmMLm3Rqd7
 2FvgK2IZD1sba2dMib7SWJ4WMatrwmQMJSJQXubsuZ3qfsIygCL0Z7SA7C7t4lZci963Hq
 eyhAz5t2EMahPTgY8yamSTpy+OHQrzfGof+tfpda/7KqgdizJcvFuxUiSpr+wRyEUNoA7T
 kmjM/xgeetL+QE5nbOIZRCtMH9gQRTbGP8w2rjCpBcW/Es7P8yvMYuQNoTufbg==
Subject: Re: [PATCH v2 00/20] md/md-llbitmap: support reshape for RAID10 and RAID5
Date: Mon, 27 Jul 2026 14:51:48 +0800
Message-Id: <e6b7cefc-e53d-44b0-a824-47bfc442e73e@fygo.io>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Lms-Return-Path: <lba+26a670009+00e7df+vger.kernel.org+yukuai@fygo.io>
Received: from [192.168.1.104] ([39.182.0.167]) by smtp.larksuite.com with ESMTPS; Mon, 27 Jul 2026 06:51:53 +0000
Content-Type: text/plain; charset=UTF-8
User-Agent: Mozilla Thunderbird
Reply-To: yukuai@fygo.io
From: "yu kuai" <yukuai@fygo.io>
Content-Transfer-Encoding: quoted-printable
References: <20260605091527.2463539-1-yukuai@kernel.org> <cover.1782282042.git.yukuai@kernel.org> <20260726185916.2223460-1-mykola@meshstor.io>
To: "Mykola Marzhan" <mykola@meshstor.io>, "yu kuai" <yukuai@fygo.io>
Cc: "Song Liu" <song@kernel.org>, "Li Nan" <magiclinan@didiglobal.com>, 
	"Xiao Ni" <xiao@kernel.org>, "Su Yue" <glass.su@suse.com>, 
	<linux-raid@vger.kernel.org>, <linux-kernel@vger.kernel.org>
X-Original-From: yu kuai <yukuai@fygo.io>
In-Reply-To: <20260726185916.2223460-1-mykola@meshstor.io>

Hi,

=E5=9C=A8 2026/7/27 2:59, Mykola Marzhan =E5=86=99=E9=81=93:
> Hi Kuai,
>
> We ran v2 through a QEMU test campaign while preparing our own llbitmap
> patches, which we will rebase on top of this series: raid1/raid5/raid10
> over loop devices, base 55b77337bdd0 ("md/raid5: avoid R5_Overlap races
> while breaking stripe batches") with and without the series applied,
> KASAN kernels for the reshape stress, and per-bit bitmap dumps as the
> oracle. Four problems, worst first =E2=80=94 details under each number be=
low:
>
> 1. raid5: writes above dev_sectors stop being tracked (steady state,
>     no reshape involved)                                 [patches 02,12]
> 2. a stopped and re-assembled reshape resumes with the pre-reshape
>     bitmap geometry, and persists it                     [patch 08]
> 3. discard can mark a chunk unwritten while half of it still holds
>     live data (raid1)                                    [patch 10]
> 4. pre-existing: raid5_bitmap_sector() rounds with round_down() on a
>     non-power-of-2 size =E2=80=94 bits land in the wrong stripe; fix offe=
red
>                                                          [base, patch 12]
>
> Happy to rerun the whole campaign on v3 and, if it comes back clean,
> follow up with Tested-by. We'll post the test scripts in-thread if
> useful.

Thanks for the report. I'll look into these problems ASAP. BTW, for-7.3/blo=
ck
branch should be created soon, I'll start applying patches then.

>
> 1. raid5: writes above dev_sectors stop being tracked
>
> llbitmap_map_layout() (patch 12) compares an array sector against
> llbitmap_logical_size(). Outside a reshape llbitmap_reshaping() is
> false, so that falls through llbitmap_personality_sync_size() to
> llbitmap->sync_size =E2=80=94 which raid5_run() set from
> mddev->resync_max_sectors =3D mddev->dev_sectors, a per-device count.
> An array sector compared against a device-sector limit: every write
> above array sector dev_sectors gets *sectors =3D 0, and with patch 02's
> early return the bitmap is never touched.
>
> On a 4-disk raid5 tracking stops after the first third of the array,
> on a 7-disk after the first sixth; a crash would then leave everything
> above that boundary out of the post-crash resync. raid1/raid10 are
> unaffected (their resync_max_sectors is the array size), and *during*
> a reshape the correct bitmap_array_sectors is consulted =E2=80=94 the pro=
blem
> only shows in steady state.
>
> Measured (one 4k write below the limit, one above, count new dirty
> bits): patched 4-disk +1/+0, patched 7-disk +1/+0; base +1/+1 both.
>
> Is llbitmap_logical_size() meant to return array sectors
> unconditionally (i.e. consult patch 17's bitmap_array_sectors outside
> reshape too), or should llbitmap_map_layout() convert before
> comparing? The two helpers currently mix coordinate spaces for
> raid456.
>
> 2. resumed reshape reverts the bitmap geometry
>
> Two things combine:
>
> - md_run() calls md_bitmap_create() before assigning mddev->pers, so
>    llbitmap_refresh_reshape() (patch 08) runs with mddev->pers =3D=3D NUL=
L
>    and llbitmap_personality_sync_size() bails out to the pre-reshape
>    sync_size from the superblock;
> - on a resumed reshape md never calls pers->start_reshape() =E2=80=94 wit=
h
>    reshape_position !=3D MaxSector only check_reshape() runs =E2=80=94 so
>    bitmap_ops->resize() is never re-invoked either.
>
> llbitmap_reshape_finish() then commits the stale geometry and
> llbitmap_update_sb() persists it, so the revert is permanent: pages
> beyond the old used_pages are returned zeroed by llbitmap_read_page()
> instead of read from disk.
>
> Reproduces in ~90s on raid10 4->6: grow, stop mid-reshape,
> re-assemble =E2=80=94 llbitmap/metadata chunks read 8128 -> 12192 -> 8128=
.
> mdadm --grow --continue does not help. raid5 disk-add is immune
> (device-indexed bitmap, the resize is a no-op), which makes it a
> clean control.
>
> Possible directions: re-run llbitmap_refresh_reshape() once
> mddev->pers is set, or have the resume path call
> bitmap_ops->resize(). Moving md_bitmap_create() after the pers
> assignment would also do it, but we did not audit what else depends
> on the current order.
>
> 3. sub-chunk discard marks a live chunk unwritten
>
> llbitmap_start_discard() computes its first bit with
> DIV_ROUND_UP_SECTOR_T(offset, chunksize) precisely so a partially
> discarded head chunk is not touched. Patch 10 makes
> llbitmap_prepare_range() run llbitmap_encode_range() on every op,
> which floors the offset to a chunk boundary first =E2=80=94 the DIV_ROUND=
_UP
> has nothing left to round. raid1/raid10 previously had no
> bitmap_sector hook, so raw offsets reached start_discard and the
> guard worked.
>
> Test, on raid1: write a pattern, then discard [K+0.5 chunks,
> K+1.5 chunks) =E2=80=94 a range that fully contains no chunk, so ideally =
zero
> chunks change state. Base flips 1 (the tail chunk =E2=80=94 pre-existing,
> arguably the same class of problem on the other end), patched flips
> 2. The extra one is chunk K, whose first half still holds the
> pattern.
>
> Maybe encode_range should be skipped for discard, or start_discard
> should take the raw offset.
>
> 4. pre-existing: raid5_bitmap_sector() rounding is wrong for
>     non-power-of-2 data-disk counts
>
> 	sectors_per_chunk =3D conf->chunk_sectors *
> 		(conf->raid_disks - conf->max_degraded);
> 	start =3D round_down(start, sectors_per_chunk);
> 	end =3D round_up(end, sectors_per_chunk);
>
> round_down()/round_up() are mask-based and require power-of-2
> alignment; chunk_sectors is a power of 2, but multiplied by 3, 5, 6
> or 7 data disks the product is not. The rounded sector is then not
> stripe-aligned and raid5_compute_sector() maps it into a different
> stripe: the bits marked and the bits covering the write are disjoint.
> Lost bits, not wide bits.
>
> Per-bit dumps, no reshape running: 3 data disks lose 20/20 targeted
> writes, 6 data disks 17/17, the 4-data (power-of-2) control 0/20.
> Byte-identical on the unpatched base, so not this series' bug =E2=80=94 b=
ut
> patch 12 routes this mapping into the reshape remap path, so it
> matters more afterwards.
>
> The fix needs division-based rounding (sector_div(), these are
> sector_t). We can send a standalone patch, or you can fold it into
> v3 =E2=80=94 whichever is easier.
>
> One gap in our coverage: raid10 grow under sustained IO currently
> floods KASAN with pre-existing slab-out-of-bounds reports from the
> r10bio width mismatch (free_r10bio() / raid10_make_request()) =E2=80=94
> reproduced on the unpatched base too; none of the sites is touched by
> your series. That is what Chen Cheng's "md/raid10: fix r10bio width
> mismatches across reshape" fixes:
>
>    https://lore.kernel.org/linux-raid/20260711100352.425177-1-chencheng@f=
nnas.com/
>
> Our reproduction data is in that thread; we will re-run the
> raid10-grow KASAN leg here once it lands.
>
> Thanks,
> Mykola

--=20
Thanks,
Kuai
