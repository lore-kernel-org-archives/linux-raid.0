Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EF9E1A5B9D
	for <linux-raid@vger.kernel.org>; Sat,  1 Aug 2026 17:39:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785605968; cv=none; b=kL3+Bm4ClLhHCkcKXujSROdhuMXBUNuC4M9dbprAcfzd/uaaI9mslv0tEOmLGLs+VsL9EuIP8GN4X4VGphvjhg788KjhjrPFhKTSPykhHVXTiHL6aor9/Jb+0c/NR9+mqrqJrqMLOSu9D8hqhgRQDJ5uMK/trvBqste9+3LGIKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785605968; c=relaxed/simple;
	bh=iGie+yUU6MSP9HR4s6nLfCb9GGAf9K0+ZFqKnKk90oc=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=tAt0A1QRzOKLxmy9X8S4NORQZNMP6yeYcZsRoOT8akhCO0tCM7zDbyQqJtV+/enV0jDNh0CPr76tGDiF5Qum/5TMB2PR5LujEsy/0izgdWIM+6sGiZHZU6ubAylkHIJtJHZld2VDka92kN7Gtr8kKc2Uk1qej61UMoivf+tAHXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AeWcj9Cn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AeWcj9Cn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E42E1F00AC4;
	Sat,  1 Aug 2026 17:39:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785605966;
	bh=tdgTmpwHFWLY/t6meC3+I/E0kO7sxcWiS9jwzPx1A2c=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=AeWcj9CnKjn8IGihKjT9AsSwB19a/AeFz0QMn+yXi836QNVkAjCbdKA31XKBoQmSq
	 PlC7BpKJDb2HKCJ+v8avHCUn4TLg4MuBrYYfFsbP6ImYg9eLAjLwjpJKkSnYRgvR5+
	 YT8NZMbOzFpICBxEX1FBvFp6cRlW4LPjQ8AUo3QoAYiaNBLtBAjPubGBidRPoPJbsa
	 xwZziukkRQLcmm7IN087nDymNtyK0dG2PEXKHYElddYm8jJdx07EwoYS+ULTwqQtG1
	 OM5greWJj0nGL89v00T7ZzSzCiUfR8IrafuW7r8KGUUth80CNqhOOggRTPVZXxqcNs
	 Y/+z6FTBGuOiw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 05/25] md/raid5: round bitmap stripes with sector
 division
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yu Kuai" <yukuai@kernel.org>
Cc: yukuai@fygo.io, linux-raid@vger.kernel.org
In-Reply-To: <20260801172519.2982121-6-yukuai@kernel.org>
References: <20260801172519.2982121-1-yukuai@kernel.org>
 <20260801172519.2982121-6-yukuai@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 01 Aug 2026 17:39:26 +0000
Message-Id: <20260801173926.8E42E1F00AC4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] The IO boundary `prev_end` is incorrectly rounded down instead of =
up to the nearest stripe boundary, causing bitmap bits for the last chunk o=
f an IO to be missed during reshape.
--

--- Patch [5]: [PATCH v4 05/25] md/raid5: round bitmap stripes with sector =
division ---
commit 804a4bf19f3825714694494e86aceb7594f387a3
Author: Yu Kuai <yukuai@fygo.io>

md/raid5: round bitmap stripes with sector division

This commit fixes alignment of array ranges to full RAID5 stripe widths when
the width is not a power of two. It replaces the old mask-based round_down()
and round_up() logic with sector_div() arithmetic.

Link: https://lore.kernel.org/all/20260726185916.2223460-1-mykola@meshstor.=
io/

> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 4276b125f94cb..8b3483674398d 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c

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
This is a pre-existing issue, but does prev_end need to be rounded up here
instead of rounded down?

The original code incorrectly used round_down(prev_end, ...) for the exclus=
ive
end boundary. By preserving that logic here with sector_div() and
multiplication, we truncate the boundary instead of rounding it up.

If a write occurs ahead of the reshape position (LOC_AHEAD_OF_RESHAPE) and
ends inside a partial stripe, could shrinking the exclusive prev_end bounda=
ry
cause us to miss bitmap bits for the trailing sectors?

If a crash happens during reshape, would the subsequent resync silently skip
these trailing sectors because they were omitted from the bitmap?

Should this include the same remainder check that was applied to the end
variable earlier in the file to properly round up?

	if (sector_div(prev_end, sectors_per_chunk))
		prev_end++;

> =20
>  	prev_start =3D raid5_compute_sector(conf, prev_start, 1, &dd_idx, NULL);
>  	prev_end =3D raid5_compute_sector(conf, prev_end, 1, &dd_idx, NULL);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260801172519.2982=
121-1-yukuai@kernel.org?part=3D5
