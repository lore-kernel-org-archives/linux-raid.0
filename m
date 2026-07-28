Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E04473E0C67
	for <linux-raid@vger.kernel.org>; Tue, 28 Jul 2026 09:03:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785229390; cv=none; b=Ec3oSt/8Oi5m/h+IXLN3s1+6VulIQdjicsmTMgr27HM0jwQ2cS1e/2mRFj8cCKOZImPTtrlgIn6cibGyzPTASUj93jfJz53gFHA8NyEAHpWZq+aj3g3dWUSzqgCJdXw9BG2Pc2ZgcfyVWhJgadmuDS0vh6VJGJvGIpKNI9HeyPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785229390; c=relaxed/simple;
	bh=iDPc4OEtV4GfV5Pm47BQ8czmzjhZtThDH02rbnXocgY=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=tzac5ZI4RxzwGN3AaaLzktOsHXumrJF+9nFfJ8ECnStCWjoyq2JJ+TC3PqKY7HR7SCcDxcD51zzXer3QJujVE/L/lNy2orCagxHYvD94Sql1nhpFfLVotFv0sT57oztCcRExyHrn5bC4vzLpkjDmSNhStU7jKSvSjezkNReWc80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fsY3sjKX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fsY3sjKX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42BE31F000E9;
	Tue, 28 Jul 2026 09:03:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785229388;
	bh=7/+9h6XwMlTNm8P+tklZhTJ3cj0b0tyCdZ00vp+tl5I=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=fsY3sjKXNpE6Vu4YlFYjIUcF2CR1srZw45mOwKpdsH5Xofk2admxF9FFdxxYSnOo7
	 HQYu4gx2HKncugYb/d2OIGgX4IOCwR6+DsTGuFt2GopeGgU+rBPYBdMk1oOFfppcRE
	 mpimWfDIUc6MJu6239o/a+UHcbodtJNxo7Oknk0Nx/FL0NVDiTMxxIeUWtx+mju0LM
	 czQfQs9zMT6wYHExeEyXvsGDp9mV63zXOq/SkUMKhPcXQP9g9I53dyT9PDC6+fw+xW
	 FZ1jDv+FWxiRMuw9d2CIXGwyjenK5e0xcNYpP9cD8Ki+dtt1nCEO3mhOe83BKWSads
	 c+3OEocIVZCGg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 01/21] md/raid5: round bitmap stripes with sector
 division
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yu Kuai" <yukuai@kernel.org>
Cc: yukuai@fygo.io, linux-raid@vger.kernel.org
In-Reply-To: <3d25eb6065f71c2ca81f3b03db549b38a8dc1f96.1785206690.git.yukuai@fygo.io>
References: <cover.1785206690.git.yukuai@fygo.io>
 <3d25eb6065f71c2ca81f3b03db549b38a8dc1f96.1785206690.git.yukuai@fygo.io>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 28 Jul 2026 09:03:07 +0000
Message-Id: <20260728090308.42BE31F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

New issues:
- [Medium] The commit message references a non-existent function `raid5_bit=
map_sector_map()`.

Pre-existing issues:
- [High] This problem wasn't introduced by this patch, but the logic for ca=
lculating the previous array layout's upper bound `prev_end` incorrectly ro=
unds down instead of rounding up, truncating the bitmap update range during=
 an array reshape.
--

--- Patch [1]: [PATCH v3 01/21] md/raid5: round bitmap stripes with sector =
division ---
commit a735680352819f937150899bfef4b4a4111690e0
Author: Yu Kuai <yukuai@fygo.io>

md/raid5: round bitmap stripes with sector division

This commit fixes rounding logic when aligning the array range to full RAID5
stripe widths. It replaces the mask-based round_down() and round_up() logic
with sector_div() based arithmetic to correctly handle stripe widths that a=
re
not powers of two.

Link: https://lore.kernel.org/all/20260726185916.2223460-1-mykola@meshstor.=
io/

> md/raid5: round bitmap stripes with sector division
>=20
> raid5_bitmap_sector_map() aligns the array range to full RAID5 stripe
> widths before converting it to component sectors. That width is

[Severity: Medium]
Does the commit message reference a function that isn't included in this
patch? The modifications appear to be applied directly inline within
raid5_bitmap_sector(), rather than a new raid5_bitmap_sector_map() helper.

> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 0c5c9fb0606ee..35910bc6683bf 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -5956,8 +5956,11 @@ static void raid5_bitmap_sector(struct mddev *mdde=
v, sector_t *offset,
> =20
>  	sectors_per_chunk =3D conf->chunk_sectors *
>  		(conf->raid_disks - conf->max_degraded);
> -	start =3D round_down(start, sectors_per_chunk);
> -	end =3D round_up(end, sectors_per_chunk);
> +	sector_div(start, sectors_per_chunk);
> +	start *=3D sectors_per_chunk;
> +	if (sector_div(end, sectors_per_chunk))
> +		end++;
> +	end *=3D sectors_per_chunk;
> =20
>  	start =3D raid5_compute_sector(conf, start, 0, &dd_idx, NULL);
>  	end =3D raid5_compute_sector(conf, end, 0, &dd_idx, NULL);

[ ... ]

> @@ -5975,8 +5978,10 @@ static void raid5_bitmap_sector(struct mddev *mdde=
v, sector_t *offset,
> =20
>  	sectors_per_chunk =3D conf->prev_chunk_sectors *
>  		(conf->previous_raid_disks - conf->max_degraded);
> -	prev_start =3D round_down(prev_start, sectors_per_chunk);
> -	prev_end =3D round_down(prev_end, sectors_per_chunk);
> +	sector_div(prev_start, sectors_per_chunk);
> +	prev_start *=3D sectors_per_chunk;
> +	sector_div(prev_end, sectors_per_chunk);
> +	prev_end *=3D sectors_per_chunk;

[Severity: High]
This isn't a bug introduced by this patch, but does the division logic for
prev_end truncate the tracked bitmap range during an array reshape?

Because prev_end serves as an exclusive upper bound, mathematically rounding
it down (which the previous round_down() logic also did) means that if an I=
/O
write crosses a chunk boundary, it gets a remainder when divided by
sectors_per_chunk.=20

Since the remainder doesn't trigger an increment (like it now does for end),
dirty sectors at the end of the I/O are not marked in the bitmap for the
previous layout. If a crash occurs, these unmarked sectors wouldn't be
resynced, which could lead to stale parity and silent data corruption.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1785206690.gi=
t.yukuai@fygo.io?part=3D1
