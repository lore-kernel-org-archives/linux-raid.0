Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8853B3AA4EB
	for <linux-raid@vger.kernel.org>; Tue, 28 Jul 2026 09:06:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785229585; cv=none; b=EZZYZrdtqaAdgCeVP5XJ7nlvv8c0UlPCpYUV7tX7twgDdQzzCSPa4ueh6GOeLd1xjwmXm0kMWl7yss4JsCwiiTkieZgNqrCjsfgwQVyLQ+VRUvMPE9WbMtRK6hi5qOsWYyqKOYkYk7WzS9RTKIHBvUn93WCEvHHWgQok2wqcixs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785229585; c=relaxed/simple;
	bh=99wZc5T9J1ilOsBOLUYsAILicdjOjp3YbV7OUZpViIE=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=NL8Q8bvki+0hc+YP4NlBir5U7p155JTOtX17X1/CI47488uxwnb1OdofffkrjH8/b6Kj4ZL78FZi4VKA3FGg5HHtnB7+klfQ8zVEsW07Ks1tTsSmaL+LAg2dMXaoAufi8/J12l1CkP89CpIYHq98hbLeXC9eCrAjwlqkYZPtakk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TB0V7qEi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TB0V7qEi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42A1D1F000E9;
	Tue, 28 Jul 2026 09:06:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785229584;
	bh=5yvoLmpBNSLxmJzFmwDPm+3VzFi1vLTsk6zJdDMa7bk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=TB0V7qEiavm6Q3bZXXfWYsGnVTLfez3lHAyWYhIxQxeBt1dcCZjRftl4VW6m6+M7L
	 p5101uI04Vw16l1sAf/yz+gU7lI37fVxAQKL/ZE1lQwDlvA8DAymOlIMwUUyoPbwvD
	 Q7rmguIWiD34Hc2pcwzUNfHeo3BKZEnIkyuDzT//YaMhz4sMf+Qm6fJn1TA54/CNU6
	 py51Z0nGSSWuR4ZqP+g9No8MVay//LFdGN7QEGTVXVRN/FmANbDHU7IxfcPPI5lzse
	 pDRrxj7xfx3oXXQgs9BoYgXdajtgtKUz+kgWTiR15PWG1cznIKqDRMdxkMqSPlixj+
	 Hcp5Rxryk/n+w==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 13/21] md/md-llbitmap: remap checkpointed bits as
 reshape progresses
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yu Kuai" <yukuai@kernel.org>
Cc: linux-raid@vger.kernel.org, yukuai@fygo.io
In-Reply-To: <64484cf5bfa58462d3c21d0a655901eaa7d9b573.1785206690.git.yukuai@fygo.io>
References: <cover.1785206690.git.yukuai@fygo.io>
 <64484cf5bfa58462d3c21d0a655901eaa7d9b573.1785206690.git.yukuai@fygo.io>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 28 Jul 2026 09:06:23 +0000
Message-Id: <20260728090624.42A1D1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 6 potential issue(=
s) to consider:
- [High] In-place bitmap array merge corrupts states due to forward iterati=
on overlapping with unread source chunks (equivalent to `memcpy` vs `memmov=
e` bug).
- [High] The reshape state merge function drops proactive sync unwritten st=
ates (`BitNeedSyncUnwritten`, `BitCleanUnwritten`), reverting them to basic=
 states and losing sync status.
- [High] `llbitmap_reshape_map_range` fails to map `old` device sectors to =
array sectors when `bitmap_sector_map` is unavailable, corrupting source ch=
unk calculations.
- [High] Lockless read-modify-write in `llbitmap_reshape_merge` races with =
concurrent I/O (`llbitmap_start_write`), causing lost BitDirty flags and si=
lent data corruption.
- [Medium] Redundant condition in `llbitmap_rmerge_state` forces all RAID l=
evels to treat mixed BitClean/BitUnwritten as BitClean, bypassing the `leve=
l_456` restriction.
- [Medium] Truncation of 64-bit sector counts to 32-bit unsigned long cause=
s incomplete reshape mapping on 32-bit kernels.
--

--- Patch [13]: [PATCH v3 13/21] md/md-llbitmap: remap checkpointed bits as=
 reshape progresses ---
commit 745e2cefd189066340bdf6deca751ae219d34b84
Author: Yu Kuai <yukuai@fygo.io>

md/md-llbitmap: remap checkpointed bits as reshape progresses
   =20
Merge checkpointed old llbitmap state forward as reshape_position
advances and record the checkpoint remap through reshape_mark().

> diff --git a/drivers/md/md-llbitmap.c b/drivers/md/md-llbitmap.c
> --- a/drivers/md/md-llbitmap.c
> +++ b/drivers/md/md-llbitmap.c

[ ... ]

> @@ -934,6 +942,33 @@ static int llbitmap_prepare_resize(struct llbitmap *=
llbitmap,

[ ... ]

> +	if (level_456 && ((dst =3D=3D BitClean && src =3D=3D BitUnwritten) ||
> +			  (src =3D=3D BitClean && dst =3D=3D BitUnwritten)))
> +		return BitClean;
> +	if (dst =3D=3D BitClean || src =3D=3D BitClean)
> +		return BitClean;

[Severity: Medium]
Does this unconditional check override the preceding level_456 restriction?

It looks like mixed clean and unwritten states will evaluate to clean on all
array types, including non-parity arrays like RAID 1 or RAID 10. This
effectively renders the level_456 restriction above it dead code.

> +	return BitUnwritten;
> +}

[Severity: High]
Are we unintentionally dropping proactive sync unwritten states here?

When reshaping an array with states like BitNeedSyncUnwritten,
BitSyncingUnwritten, or BitCleanUnwritten, they appear to fall through the
basic checks and downgrade to BitUnwritten. This silently loses sync status
for proactive parity builds on RAID 4/5/6.

[ ... ]

> @@ -1839,6 +1874,120 @@ static int llbitmap_reshape_can_start(struct mdde=
v *mddev)

[ ... ]

> +struct llbitmap_reshape_range {
> +	sector_t offset;
> +	unsigned long sectors;

[Severity: Medium]
Will this truncate the 64-bit sector count to 32 bits on 32-bit architectur=
es?

If the reshape process skips a large fully clean region of more than 2TB, it
seems this sector count might silently overflow since sectors is declared as
unsigned long.

> +	sector_t start;
> +	sector_t end;
> +};

[ ... ]

> +static void llbitmap_reshape_map_range(struct llbitmap *llbitmap,
> +				       sector_t lo, sector_t hi,
> +				       bool previous,
> +				       struct llbitmap_reshape_range *range)
> +{
> +	range->offset =3D lo;
> +	range->sectors =3D hi - lo;
> +	llbitmap_map_layout(llbitmap, &range->offset, &range->sectors, previous=
);

[Severity: High]
Does this fail to convert logical array sectors to bitmap device sectors for
the old layout when bitmap_sector_map is NULL?

For example, during a RAID5 reshape where bitmap_sector is implemented but
not bitmap_sector_map, llbitmap_map_layout skips mapping the old layout but
correctly maps the new one.

> +	range->start =3D range->offset;
> +	range->end =3D range->offset + range->sectors;
> +}
> +
> +static bool llbitmap_reshape_src_range(const struct llbitmap_reshape_ran=
ge *old,
> +				       const struct llbitmap_reshape_range *new,
> +				       const struct llbitmap_reshape_range *dst,
> +				       struct llbitmap_reshape_range *src)
> +{
> +	if (!old->sectors)
> +		return false;
> +
> +	src->start =3D old->offset +
> +		mul_u64_u64_div_u64(dst->start - new->offset,
> +				    old->sectors, new->sectors);

[Severity: High]
Could this math incorrectly mix old array sectors with new device sectors?

If the mapping failed in the step above, combining these mismatched units
could lead to corrupted source chunk calculations.

> +	src->end =3D old->offset +

[ ... ]

> +static void llbitmap_reshape_merge(struct llbitmap *llbitmap,
> +				   const struct llbitmap_reshape_range *old,
> +				   const struct llbitmap_reshape_range *new)
> +{
> +	unsigned long dst_start;
> +	unsigned long dst_end;
> +	unsigned long dst;
> +
> +	if (!new->sectors)
> +		return;
> +
> +	dst_start =3D div64_u64(new->offset, llbitmap->reshape_chunksize);
> +	dst_end =3D div64_u64(new->end - 1, llbitmap->reshape_chunksize);
> +
> +	for (dst =3D dst_start; dst <=3D dst_end; dst++) {

[Severity: High]
Could this forward iteration cause in-place state corruption during the mer=
ge?

If the old to new layout mapping causes source chunks to be located at high=
er
indices than destination chunks, writing to dst could overwrite the state t=
hat
a subsequent iteration needs to read as src. This propagates the corrupted
state forward.

> +		struct llbitmap_reshape_range dst_range;
> +		struct llbitmap_reshape_range src;
> +		enum llbitmap_state state;
> +
> +		llbitmap_reshape_dst_range(llbitmap, dst, new, &dst_range);
> +		state =3D llbitmap_reshape_init_dst(llbitmap, dst, new);
> +		if (llbitmap_reshape_src_range(old, new, &dst_range, &src))
> +			state =3D llbitmap_rmerge_src(llbitmap, state, &src);
> +		else
> +			state =3D llbitmap_rmerge_state(llbitmap, state, BitUnwritten);
> +		llbitmap_write(llbitmap, state, dst);

[Severity: High]
Does this lockless read-modify-write race with concurrent I/O updates to the
same chunk?

Because reshape checkpoint boundaries might not be chunk-aligned, these
boundary chunks can cover sectors outside the suspended reshape window. A
concurrent llbitmap_start_write to those unsuspended sectors performs a
lockless read-modify-write on the chunk state.=20

If llbitmap_reshape_merge performs a lockless write on the exact same chunk
index concurrently, one could overwrite the other, losing BitDirty flags and
risking silent data corruption.

> +	}
> +}
> +

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1785206690.gi=
t.yukuai@fygo.io?part=3D13
