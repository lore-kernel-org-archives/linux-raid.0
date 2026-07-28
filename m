Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D40541D119
	for <linux-raid@vger.kernel.org>; Tue, 28 Jul 2026 09:11:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785229901; cv=none; b=oRaZqK69m4CAo5auMXu1fT3FB48JEm5BnRUJIBK5TDRp4oQYq0zbbv9pNDFd3zT8IL8dNvIBHcJih61r4pIdZ583lopUydj1YKkWcMfivxDCW9Ea/q8fDB/reodVs9SkfJEPSzzmlQPtPzqrLs1UevxL5ZD4MEDtgSk2QVUNcxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785229901; c=relaxed/simple;
	bh=FaJHGwf9uYma4UO5Rpagn+dZVKjLI6jXSGpCYLlIH7Q=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=ACRLNDsapsjbX/NjAp1vF0dIe/2my66kMQtEX/35SoqrD4GqsMN9S5YuWMAmWTxiiQo4jwgN3B/rV54YXYdXUf/uhH7zwBbFENgFaILCKXu0SpD7tVLky0/FMDOpWXccj8fc3S3KlNroHqtZ0ZQsAmObnrgIY4AE87VsadMTw9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CnxBr/nC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CnxBr/nC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4EDF1F00A3E;
	Tue, 28 Jul 2026 09:11:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785229899;
	bh=pos7QueY9joV4ocXP+67zTpKG9o5e4apuso44+F15Ek=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=CnxBr/nChy3V3BKb9hyu9isatVp7RBnoC8fcYntVado2g51SNKeNgYlJLgfU4qwlE
	 evkDxW44BGlVlm9B444vHgb0r40uCbQoNnPjD5tkGAojLEnme60v3Dche+fnuU2Isd
	 m/DEimy9I72TQsWGyJfcnGj+f/KeTtW+MT5L2Jsi1EYzq7SlSc/MtlJ7WHcEBqbeP0
	 8P2fA8NCAYE5wXCEqubYvEt+pLluj7pudA+NhY9Xy+/a8jMtiIKMAqYVg7GolF1zt2
	 sUdpFX2/Ejx6mkMnvhhcOyePx0NPVSURN+VG/J2CxeWT724uIbS36MxuUNMzSd9VZ0
	 1V6ILoGFCss2A==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 11/21] md/md-llbitmap: add reshape range mapping
 helpers
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yu Kuai" <yukuai@kernel.org>
Cc: yukuai@fygo.io, linux-raid@vger.kernel.org
In-Reply-To: <2964489adb127bd678251deeb9ece095fa39495c.1785206690.git.yukuai@fygo.io>
References: <cover.1785206690.git.yukuai@fygo.io>
 <2964489adb127bd678251deeb9ece095fa39495c.1785206690.git.yukuai@fygo.io>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 28 Jul 2026 09:11:38 +0000
Message-Id: <20260728091138.D4EDF1F00A3E@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 4 potential issue(=
s) to consider:
- [Critical] Missing post-map sync-size clamp in llbitmap_map_layout() allo=
ws mapped physical sectors to exceed the bitmap capacity, causing OOB array=
 accesses.
- [Critical] The `bitmap_array_sectors` callback is not implemented for any=
 personality (e.g. RAID5), causing the pre-map clamp to incorrectly use com=
ponent coordinates against array-sector IOs.
- [Critical] Coordinate mapping is completely skipped for the old geometry =
during reshape, leading to array coordinates being treated as component coo=
rdinates.
- [Critical] Bios crossing the reshape boundary are not split before bitmap=
 accounting, causing `llbitmap` to encode the entire range with a single ge=
ometry.
--

--- Patch [11]: [PATCH v3 11/21] md/md-llbitmap: add reshape range mapping =
helpers ---
commit b480f867a40652c2963e56247233a10fff0a56b8
Author: Yu Kuai <yukuai@fygo.io>

md/md-llbitmap: add reshape range mapping helpers

This commit adds reshape range mapping helpers to llbitmap to differentiate
between old and new geometry during a reshape. It also introduces
discard-specific range encoding and clamps pre-map ranges in the same
coordinate space as incoming IO.

Link: https://lore.kernel.org/all/20260726185916.2223460-1-mykola@meshstor.=
io/

> steady-state RAID5 must use bitmap_array_sectors() before mapping and keep
> the existing sync-size clamp after mapping.

Does the implementation match this commit message description? Looking at
llbitmap_map_layout(), it appears the post-map sync-size clamp was omitted.

> diff --git a/drivers/md/md-llbitmap.c b/drivers/md/md-llbitmap.c
> --- a/drivers/md/md-llbitmap.c
> +++ b/drivers/md/md-llbitmap.c
[ ... ]
> @@ -449,6 +450,16 @@ static sector_t llbitmap_personality_sync_size(struc=
t llbitmap *llbitmap,
>  	return mddev->pers->bitmap_sync_size(mddev, previous);
>  }
> =20
> +static sector_t llbitmap_logical_size(struct llbitmap *llbitmap, bool pr=
evious)
> +{
> +	struct mddev *mddev =3D llbitmap->mddev;
> +
> +	if (!mddev->private || !mddev->pers ||
> +	    !mddev->pers->bitmap_array_sectors)
> +		return llbitmap_personality_sync_size(llbitmap, previous);

[Severity: Critical]
Is bitmap_array_sectors implemented for the personalities that need it?

If personalities like RAID5 do not wire up bitmap_array_sectors, this falls
back to returning llbitmap_personality_sync_size(), which uses the much
smaller component coordinates.

Because RAID5 receives IOs in array coordinates, and array coordinates are
significantly larger than component coordinates, wouldn't any write targeti=
ng
the upper portion of a RAID5 array evaluate to start >=3D limit inside
llbitmap_map_layout() and be silently dropped? This could lead to silent da=
ta
corruption on an unclean shutdown.

> +	return mddev->pers->bitmap_array_sectors(mddev, previous);
> +}
> +
>  static void llbitmap_refresh_reshape(struct llbitmap *llbitmap)
[ ... ]
> +static void llbitmap_map_layout(struct llbitmap *llbitmap, sector_t *off=
set,
> +				unsigned long *sectors, bool previous)
> +{
> +	sector_t limit =3D llbitmap_logical_size(llbitmap, previous);
> +	sector_t start =3D *offset;
> +	sector_t end =3D start + *sectors;
> +
> +	if (start >=3D limit) {
> +		*sectors =3D 0;
> +		return;
> +	}
> +	if (end > limit)
> +		end =3D limit;
> +
> +	*offset =3D start;
> +	*sectors =3D end - start;
> +	if (!*sectors)
> +		return;
> +
> +	if (llbitmap->mddev->pers->bitmap_sector_map)
> +		llbitmap->mddev->pers->bitmap_sector_map(llbitmap->mddev, offset,
> +							 sectors, previous);
> +	else if (!previous && llbitmap->mddev->pers->bitmap_sector)
> +		llbitmap->mddev->pers->bitmap_sector(llbitmap->mddev, offset,
> +							 sectors);

[Severity: Critical]
Does this logic incorrectly skip coordinate mapping for the old geometry?

During an active reshape, IOs targeting the old geometry evaluate previous =
to
true. Since the !previous condition prevents bitmap_sector() from being cal=
led,
array-sector offsets are passed directly to llbitmap_encode_range().

Because array offsets are much larger than component sectors, this produces
chunk indices that wildly exceed llbitmap->chunks. This can lead to
out-of-bounds memory accesses on the pctl array or corrupt the bitmap by
dirtying the wrong chunks.

[Severity: Critical]
Is a post-map sync-size clamp missing at the end of this function?

When a RAID array's size is not perfectly aligned to a multiple of chunk si=
zes,
bitmap_sector() rounds the end offset up to the next chunk boundary. Without
clamping the result against llbitmap_personality_sync_size(), the mapped
component sector range can exceed the physical capacity.

This un-clamped offset can yield an out-of-bounds page_end when passed into
llbitmap_start_write(), causing an out-of-bounds dereference on the
dynamically allocated llbitmap->pctl array via llbitmap_raise_barrier().

> +}
> +
> +static void llbitmap_encode_range(struct llbitmap *llbitmap, sector_t *o=
ffset,
[ ... ]
> @@ -1385,11 +1470,35 @@ static void llbitmap_destroy(struct mddev *mddev)
>  	mutex_unlock(&mddev->bitmap_info.mutex);
>  }
> =20
> +static bool llbitmap_map_previous(struct llbitmap *llbitmap, sector_t of=
fset,
> +				  unsigned long sectors)
> +{
> +	struct mddev *mddev =3D llbitmap->mddev;
> +	sector_t boundary =3D mddev->reshape_position;
> +
> +	if (!llbitmap_reshaping(llbitmap))
> +		return false;
> +
> +	WARN_ON_ONCE(sectors && offset < boundary && offset + sectors > boundar=
y);

[Severity: Critical]
Will this WARN_ON_ONCE trigger if bios crossing the reshape boundary are not
split beforehand?

The block layer currently accounts the entire contiguous bio as a single ra=
nge
in md_account_bio(). While the helper mddev_bio_split_at_reshape_offset is
exported in this patch series, it appears it is never actually invoked by t=
he
personalities (such as in raid5_make_request) prior to accounting.

Because this function returns a single geometry decision for the entire IO,
llbitmap_encode_range() will map the entire crossing bio using a single
chunksize. This miscalculates chunk indices for the portion of the bio sitt=
ing
in the other geometry, dirtying the wrong chunks and risking data corruptio=
n if
resync skips the correctly-associated chunks after a crash.

> +
> +	return mddev->reshape_backwards ? offset < boundary : offset >=3D bound=
ary;
> +}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1785206690.gi=
t.yukuai@fygo.io?part=3D11
