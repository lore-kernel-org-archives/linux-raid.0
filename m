Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F2973D566B
	for <linux-raid@vger.kernel.org>; Thu, 20 Aug 2026 21:24:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787261056; cv=none; b=VlLDLcsRovIsDYTcv5EhHZWhRE9KoNNY5oyu5vO9t1rH7O6pFYICm1YMLmZi8iZeQE1BkIWwQLNBQ4dpnkX11avPH+RqI0d4m8BxeAQZERbFJiciM7DP6d8+WKj4TIvGIBx0aJkSmn7M9gnKN4WT6gDGChAgKg4G3zxtdfYfcbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787261056; c=relaxed/simple;
	bh=/EHFMQmLBBHYK1kqnxSXF+NVlBmf2AiDYLMLCxWe8NM=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=YRmQXjUaN8LxxtrTtZCR8WUQxi0J5INx5xaF5F2jd3OTxDlqFzO6EuU1RuaU0jj+F3uim7tY1XuhWF9Mc9jO5wM1GFB4qH9a1GMZbgQ2FlkZc4xLF5w539ElrVMZo5p2/azN1dD1mJYE8lecPpM+J8jSAoMX1qtaFQ4yw09J2R4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dTcFKxh+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dTcFKxh+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8193A1F000E9;
	Thu, 20 Aug 2026 21:24:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787261054;
	bh=hrfWEzLo3iVBhLhWmwmuW+rQgMzazEMRAymIohFjYFk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=dTcFKxh+PdbSJ0wOsNpAN9m1FjfxcH9yaWjpVYYhBWYFi4NoZqAyWaL+lKNoJ8/Me
	 OkQ0EiJnb4tSwKWHf+nHyYiiKe7Ig6d1Itm3DgluFqto6pb4o52qPCvw5YFIHNVJcT
	 wDCh1gIjd8c1kQkDDkA5xBAbnwzw+POSNNErCNxtalAPrMVHTo4M13yxh2JojtxGYx
	 o47eTfvPfs7fnGB9UK6inUhw/QYG7sS4ryM6qXn5nn3elnJj0T6q+2xafGUoXT9Cvh
	 xzRTIBYMTrT0xrZ47Z0Y1+a2h6Db2T5QzOKo9SH60ZPiUS0OJRs0I4CFpXrDPggzf0
	 Ub/c2UcymOJTQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] md: reject v0.90 arrays with too many devices
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?SsOpcsOpbXkgSmVhbg==?= <Jeremy.Jean@oss.cyber.gouv.fr>
Cc: linux-raid@vger.kernel.org, yukuai@fygo.io
In-Reply-To: <20260820210703.3035608-2-Jeremy.Jean@oss.cyber.gouv.fr>
References: <20260820210703.3035608-2-Jeremy.Jean@oss.cyber.gouv.fr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 20 Aug 2026 21:24:14 +0000
Message-Id: <20260820212414.8193A1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

Pre-existing issues:
- [High] The bounds check on `raid_disks` is incomplete and allows out-of-b=
ounds writes in `super_90_sync()`.
- [High] Missing bounds check on `sb->this_disk.number` allows arbitrary ou=
t-of-bounds memory reads leading to kernel panic.
--

--- Patch [1]: [PATCH] md: reject v0.90 arrays with too many devices ---
commit 29dd6c25e23c9e9c7bcdc332429c7ae58ceccde2
Author: J=C3=A9r=C3=A9my Jean <Jeremy.Jean@oss.cyber.gouv.fr>
Subject: md: reject v0.90 arrays with too many devices

The commit updates super_90_load to reject arrays where the raid_disks
value exceeds MD_SB_DISKS. This prevents out-of-bounds writes during
superblock metadata updates when processing a crafted v0.90 format
superblock.

> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 680b34a63cb3d..154ee5a65cb79 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -1393,7 +1393,7 @@ static int super_90_load(struct md_rdev *rdev, stru=
ct md_rdev *refdev, int minor
>  		goto abort;
>  	}
> =20
> -	if (sb->raid_disks <=3D 0)
> +	if (sb->raid_disks <=3D 0 || sb->raid_disks > MD_SB_DISKS)

[Severity: High]
This isn't a bug introduced by this patch, but does allowing sb->raid_disks
to equal MD_SB_DISKS (which is 27) leave the array vulnerable to an
out-of-bounds write?

If sb->raid_disks is exactly MD_SB_DISKS, and the array has missing active
disks but contains spare or faulty devices, super_90_sync() will initialize
next_spare to mddev->raid_disks (27).

For each spare or faulty device, it unconditionally assigns
desc_nr =3D next_spare++ and writes to sb->disks[desc_nr]:

drivers/md/md.c:super_90_sync() {
    ...
    desc_nr =3D next_spare++;
    ...
    d =3D &sb->disks[rdev2->desc_nr];
    ...
}

Since sb->disks has exactly 27 elements, this means next_spare starts out
of bounds. Successive spare devices could cause writes to sb->disks[28],
sb->disks[29], exceeding the 4KB superblock page. Should this validation
ensure raid_disks is strictly less than MD_SB_DISKS?

[Severity: High]
This is also a pre-existing issue, but further down in super_90_load(),
sb->this_disk.number is extracted into rdev->desc_nr:

drivers/md/md.c:super_90_load() {
    ...
    rdev->desc_nr =3D sb->this_disk.number;
    ...
}

Is it possible for an untrusted value to be extracted here without verifying
it is strictly less than MD_SB_DISKS?

Later, when array assembly calls md_run(), it executes super_90_validate()
which uses this unvalidated value as an array index:

drivers/md/md.c:super_90_validate() {
    ...
    desc =3D sb->disks + rdev->desc_nr;
   =20
    if (desc->state & (1<<MD_DISK_FAULTY))
    ...
}

Since rdev->desc_nr can be arbitrarily large, could this result in reading
memory far beyond the sb_page and trigger a kernel panic if it lands on an
unmapped page?

>  		goto abort;
> =20
>  	if (md_csum_fold(calc_sb_csum(sb)) !=3D md_csum_fold(sb->sb_csum)) {

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260820210703.3035=
608-2-Jeremy.Jean@oss.cyber.gouv.fr?part=3D1
