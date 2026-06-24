Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17B683905E7
	for <linux-raid@vger.kernel.org>; Wed, 24 Jun 2026 07:16:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782285389; cv=none; b=cC3UG5u4Zp38NnVq+foqyTRlWYu3J+jbID628t72bhhLuwFGV+jrYW+LT1STVBrEMIVxIalhgOToZivVQI+khq71wy60CwQUr+v81xXuxAzty7+GRWEddBHmy70RP9LvyslKdJXMwhJiqKEIrsLrHIHANeiRRXfZvYH6BMmkg3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782285389; c=relaxed/simple;
	bh=PcylBQQHxj6JglNFV4Ad77Al9bsZeBa9khlXpwWuZOs=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=hSCuHDlTTObJcke1K0yS0PpxxYWyvn3dzTXEYABREOoKi44m0WFImnep9ECJfANRvHjjScWUXYSH5zedZd9YrMr0HldoSgVmqKEvtOH5V2365P7p1aV3UXsWK3/Bz8vCGVqTA/Kw3lwgX1bUDkDeGPzOHrSaBZwtMpMawgWwLNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bkdA0ijj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bkdA0ijj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF1F01F00A3A;
	Wed, 24 Jun 2026 07:16:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782285387;
	bh=gRUavpIBmeBcKPhEDROiX0UR6LfFSrBORfi1W0eHnEk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=bkdA0ijj9+muQg6xe4FlBBWY84kzrX2UBRH/ppEajQ2SKLzF/rh2vFLKzMShaPDnc
	 9j/dHKQ4tcDNppm5Ksev6abJBrkdtv+zmvenuEg+i0cp303wmXP0c0ul5FmhQLdhgr
	 e+UHbvPBv+VkJN6Wj1Qlt8o1EAg2O88w9+9KT3k2xs8dg9/GvTO2S15UfoQJeDa214
	 7e8O8QlCzL3C/FBnXNrR/jBm5qF8w+ZhM2NYVCLloOhkK36UV2bUNk31AmH31cFWSr
	 Tuurwt51YV3YETNBxqmdMmGJsenDeJRvZOi5XfSXIf0eCyvfmbMMN8qJe5UiFm5Xu6
	 DN+Oh4jvOyFkA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 17/20] md/raid5: add exact old and new llbitmap
 mapping helpers
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yu Kuai" <yukuai@kernel.org>
Cc: linux-raid@vger.kernel.org, yukuai@fygo.io
In-Reply-To: <7f4f61a0c06d01b38b0a175ce5df9afe6450d09e.1782282042.git.yukuai@kernel.org>
References: <20260605091527.2463539-1-yukuai@kernel.org>
 <cover.1782282042.git.yukuai@kernel.org>
 <7f4f61a0c06d01b38b0a175ce5df9afe6450d09e.1782282042.git.yukuai@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 24 Jun 2026 07:16:27 +0000
Message-Id: <20260624071627.BF1F01F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 4 potential issue(=
s) to consider:

New issues:
- [High] raid5_bitmap_array_sectors() incorrectly returns the new, smaller =
array size for the previous layout during a shrink reshape, leading to trun=
cated bitmap tracking.

Pre-existing issues:
- [High] Invalid use of round_down() and round_up() with a non-power-of-2 s=
ectors_per_chunk multiplier, causing corrupt bitmap mappings.
- [High] Bounding box calculation for mapping ranges between old and new la=
youts can overflow `unsigned long` on 32-bit systems, truncating dirty regi=
ons.
- [High] raid5_bitmap_sector_map() accesses reshape geometry parameters wit=
hout holding the required sequence lock.
--

commit 7f0559d3994c9371245bbc6a23cf3ce1e8d48872
Author: Yu Kuai <yukuai@fygo.io>

md/raid5: add exact old and new llbitmap mapping helpers

Teach RAID5 to export exact old and new llbitmap mappings and the
corresponding sync and array sizes for reshape-aware bitmap users.

> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 0c5c9fb0606ee..1613a42cc25dc 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
[ ... ]
> @@ -5942,25 +5942,43 @@ static enum reshape_loc get_reshape_loc(struct md=
dev *mddev,
[ ... ]
> -static void raid5_bitmap_sector(struct mddev *mddev, sector_t *offset,
> -				unsigned long *sectors)
> +static void raid5_bitmap_sector_map(struct mddev *mddev, sector_t *offse=
t,
> +				    unsigned long *sectors,
> +				    bool previous)
>  {
>  	struct r5conf *conf =3D mddev->private;
>  	sector_t start =3D *offset;
>  	sector_t end =3D start + *sectors;
> -	sector_t prev_start =3D start;
> -	sector_t prev_end =3D end;
>  	int sectors_per_chunk;
> -	enum reshape_loc loc;
>  	int dd_idx;
> =20
> -	sectors_per_chunk =3D conf->chunk_sectors *
> -		(conf->raid_disks - conf->max_degraded);
> +	if (previous)
> +		sectors_per_chunk =3D conf->prev_chunk_sectors *
> +			(conf->previous_raid_disks - conf->max_degraded);
> +	else
> +		sectors_per_chunk =3D conf->chunk_sectors *
> +			(conf->raid_disks - conf->max_degraded);

[Severity: High]
This is a pre-existing issue, but does raid5_bitmap_sector_map() access
these reshape geometry parameters safely?

During a concurrent reshape operation (e.g., raid5_start_reshape()), these
configuration fields can be updated in-place. Without being protected by
read_seqcount_begin(&conf->gen_lock), could a concurrent I/O observe torn
state or a mismatch between chunk size and raid disks, leading to an
incorrect bitmap mapping?

>  	start =3D round_down(start, sectors_per_chunk);
>  	end =3D round_up(end, sectors_per_chunk);

[Severity: High]
This is a pre-existing issue, but do round_down() and round_up() work corre=
ctly
here when sectors_per_chunk is not a power of 2?

The round_down() and round_up() macros perform a bitwise masking operation
which strictly requires the multiplier to be a power of 2. Because the
number of data disks (raid_disks - max_degraded) is often not a power of 2
(for example, 3 data disks in a 4-disk RAID5), sectors_per_chunk is frequen=
tly
not a power of 2.

Will this bitwise mask silently corrupt the logical offsets instead of roun=
ding
to stripe boundaries, leading to incorrect physical regions being tracked in
the bitmap?

> -	start =3D raid5_compute_sector(conf, start, 0, &dd_idx, NULL);
> -	end =3D raid5_compute_sector(conf, end, 0, &dd_idx, NULL);
> +	start =3D raid5_compute_sector(conf, start, previous, &dd_idx, NULL);
> +	end =3D raid5_compute_sector(conf, end, previous, &dd_idx, NULL);
> +	*offset =3D start;
> +	*sectors =3D end - start;
> +}
> +
> +static void raid5_bitmap_sector(struct mddev *mddev, sector_t *offset,
> +				unsigned long *sectors)
> +{
> +	struct r5conf *conf =3D mddev->private;
> +	sector_t start =3D *offset;
> +	sector_t end =3D start + *sectors;
> +	sector_t prev_start =3D start;
> +	unsigned long prev_sectors =3D end - start;
> +	enum reshape_loc loc;
> +
> +	raid5_bitmap_sector_map(mddev, &start, sectors, false);
> +	end =3D start + *sectors;
[ ... ]
> @@ -5987,7 +5998,7 @@ static void raid5_bitmap_sector(struct mddev *mddev=
, sector_t *offset,
>  	 * we set bits for both.
>  	 */
>  	*offset =3D min(start, prev_start);
> -	*sectors =3D max(end, prev_end) - *offset;
> +	*sectors =3D max(end, prev_start + prev_sectors) - *offset;

[Severity: High]
This isn't a bug introduced by this patch, but can this bounding box
calculation overflow on 32-bit systems?

When calculating the bounding box spanning the old and new physical layout
mappings for an I/O ahead of a reshape, the physical sector offsets diverge
linearly due to differing data disk counts.

For large arrays (e.g., >40TB), the gap between the mapped sectors can
exceed 2TB (4,294,967,295 sectors). Because *sectors is a pointer to
unsigned long (which is 32-bit on 32-bit architectures), could this
subtraction silently overflow, truncating the dirty region and potentially
missing necessary bits?

>  }
> =20
>  static enum stripe_result make_stripe_request(struct mddev *mddev,
[ ... ]
> @@ -9049,6 +9060,20 @@ static void raid5_prepare_suspend(struct mddev *md=
dev)
>  	wake_up(&conf->wait_for_reshape);
>  }
> =20
> +static sector_t raid5_bitmap_sync_size(struct mddev *mddev, bool previou=
s)
> +{
> +	return mddev->dev_sectors;
> +}
> +
> +static sector_t raid5_bitmap_array_sectors(struct mddev *mddev, bool pre=
vious)
> +{
> +	struct r5conf *conf =3D mddev->private;
> +
> +	if (previous)
> +		return raid5_size(mddev, 0, 0);

[Severity: High]
Does passing 0 for raid_disks in raid5_size() incorrectly truncate the array
size for the previous layout?

During an array shrink reshape (e.g., from 5 disks to 4), passing 0 forces
raid5_size() to use the minimum disk count between the old and new layouts.
This would return the new, smaller array size instead of the exact previous
layout's size.

Since reshape-aware bitmap users rely on this limit to clip logical I/O
offsets, could I/Os mapping to the old unreshaped region beyond the new
limit be erroneously discarded, leading to dropped dirty bits?

> +	return raid5_size(mddev, mddev->dev_sectors, conf->raid_disks);
> +}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1782282042.gi=
t.yukuai@kernel.org?part=3D17
