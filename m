Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795079738;
	b=PxoEFg8EAsrHVpdhdnIVBPrkvBiRChYmNhEcaCAy7TTdq0WeSum2R/Joon7KiThTzuev
	 g7vnJh0sb7FVXMA6WrN1InJtM5JcDSegYkZ1aBPCGsMUy4XZNixxzOGNlu58gN78MTUvK
	 rLWXAEIFS8wwSdSSELhZsylSQBy7gZ3jrESfNL2vw/HGlaC1UZwQSc3gns4yCtqhMTXuQ
	 0HkOSitQBFOal+GviGZuX1MTIL/QbpMW101wfljBNar6LytpzyoafjwYAFRSktZQGqcsc
	 6YC/R88dIMZbLNqkeodp1ZLM4Vx2SBCQg5re82gN3t+pCzs1P+6RnGjH8aEqeZ9/p0Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795079738;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=G6znvZtUf5b0QfYq7+YBI06glkN5saS5c6eMFysDqVo=;
	b=KH4zP0HgnszFO7zTYoZ15FpOc2PZ7Sgthnx9gSlad4mHN3AvSMaCVrUV42KcK2gNBJ/2
	 iqj7TQYiyMUerjXMjataIexdycSGaX1gyaJJwOAjsgj9sr/RjEfUBKhpUWdeptUYPu7hA
	 AvBQ3ELuod7LSBD9VEpqDnU+RjZfYZr1YajTGHlKHTsAL58uu6+2LPpUnBZKZ5lrDaL9i
	 +EwD9AfGxilKK82zFsijZue1wMbIzK9Z03eNeU/eLJcTCF66hsCsfOgoQSlAKRFghP8N1
	 Qbj9J8wx4fTWMmhUZM0mztl6riDDv7XP6wEwOWXG8yg/kUPKHL9NJVu/yeJxKh23gdA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Mwr+y9+i;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F414606A324
	for <linux-raid@vger.kernel.org>; Thu, 19 Nov 2026 09:15:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Mwr+y9+i
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72A091F000C5;
	Thu, 19 Nov 2026 09:15:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795079737;
	bh=G6znvZtUf5b0QfYq7+YBI06glkN5saS5c6eMFysDqVo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Mwr+y9+iL4YQQm7TVZ2/w/4ADHglcoJDBS5FSBpXIbLCmUs3tqi993Vhbi64GYXjP
	 7y5bkGct4g/sLPLS5maCjAs3RlQmZgc8TGUjMUmBa6WTnQkr+YUiQ6o3hDSbWfqZdU
	 VI16K/SUjWjhozeRcbSAf+fDxi+sKvSaIFKwUgqbCIbAzyRsR+/dHpdjmkrQrAU+t+
	 B9iGBQvxYMbJ/KJH6BLkE+detzxJ/xannRY6sLkZO2UPhIm/jQProJ3bwlXA7Km+u4
	 qWh79m/eBkMxDt5HivEjNaWS35SzbeVfNbrkq0aPaK6irEFeH4dWJwbAfpb2/sLcqQ
	 G3yWAom576hVg==
Message-ID: <sashiko-outbox-222802@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] md: bound raid_disks by max_disks for v0.90 metadata
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yang Luohan" <ylh440104@gmail.com>
Cc: linux-raid@vger.kernel.org, yukuai@fygo.io
In-Reply-To: <179507886219.2370.1301636898303569514@gmail.com>
References: <179507886219.2370.1301636898303569514@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 19 Nov 2026 09:15:37 +0000
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Post: <mailto:linux-raid@vger.kernel.org>
List-Help: <mailto:linux-raid+help@vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-raid+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 5 potential
issues to consider:
- [High] md: out-of-bounds access to sb->disks[] in super_90_sync()
- [Medium] md: missing raid_disks check and max_disks init in
  md_set_array_info()
- [Medium] md: max_disks check bypass and int overflow in
  raid_disks_store()
- [Low] md: incomplete max_disks check and stale max_disks in
  metadata_store()
- [Low] md: 10-char SHA in Fixes trailer and duplicated subject in
  changelog
--

commit 0588d69c6a4d85b9a67f6669d8e19860ad381e67
Author: Yang Luohan <ylh440104@gmail.com>

> md: bound raid_disks by max_disks for v0.90 metadata
>
> md: bound raid_disks by max_disks for v0.90 metadata
>
> commit 1a33a379e6 ("md: reject v0.90 arrays with too many devices")
> bounded sb->raid_disks in super_90_load(), so a crafted superblock can
> no longer describe more devices than a v0.90 superblock is able to hold.
> mddev->raid_disks however is not only loaded from the superblock.
>
> Both the raid_disks sysfs attribute and MD_SET_ARRAY_INFO write it
> directly while the array has no personality, and neither enforces any
> upper bound.  super_90_sync() then lays out the in-superblock device
> table using mddev->raid_disks and walks past the end of the 4 KiB
> superblock page.
>
> mddev->max_disks already carries the limit that the selected metadata
> format can represent, and update_raid_disks() already enforces it, but
> it is only initialized when a superblock is read from a member device.
> An array that has just been created through sysfs or
> MD_SET_ARRAY_INFO has max_disks cleared, so the check is skipped.
>
> Set max_disks when v0.90 metadata is selected in metadata_store(), and
> reject values the selected format cannot represent in
> raid_disks_store().  Both orderings are then covered: the limit is
> installed either before the value is written or together with the
> metadata choice.  Clamp super_90_sync() as well, so an array which
> already carries a larger value cannot walk past sb->disks[].
>
> v1.x metadata sets max_disks to (4096-256)/2 and is therefore not
> affected by the v0.90 limit.
>
> Fixes: 1a33a379e6 ("md: reject v0.90 arrays with too many devices")
> Signed-off-by: Yang Luohan <ylh440104@gmail.com>

[Severity: Low]
The Fixes: tag uses a 10-character SHA instead of at least 12 characters:

  Fixes: 1a33a379e678 ("md: reject v0.90 arrays with too many devices")

The subject line is also duplicated at the top of the commit message body.

[Severity: Medium]
The commit message notes that MD_SET_ARRAY_INFO writes mddev->raid_disks
directly and leaves max_disks cleared, but md_set_array_info() is not
updated in this patch.

When info->raid_disks !=3D 0, md_set_array_info() assigns mddev->raid_disks
=3D info->raid_disks without checking it against 0 or MD_SB_DISKS.  When
info->raid_disks =3D=3D 0, it sets major_version, minor_version and persist=
ent
while leaving mddev->max_disks =3D=3D 0, so a subsequent sysfs write to
raid_disks_store() still bypasses the max_disks check.

> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 47da9edc1c606..788521a55a13c 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -1630,7 +1630,7 @@ static void super_90_sync(struct mddev *mddev, stru=
ct md_rdev *rdev)
>  {
>  	mdp_super_t *sb;
>  	struct md_rdev *rdev2;
> -	int next_spare =3D mddev->raid_disks;
> +	int next_spare =3D min_t(int, mddev->raid_disks, MD_SB_DISKS);
> =20
>  	/* make rdev->sb match mddev data..
>  	 *
> @@ -1663,7 +1663,7 @@ static void super_90_sync(struct mddev *mddev, stru=
ct md_rdev *rdev)
>  	sb->ctime =3D clamp_t(time64_t, mddev->ctime, 0, U32_MAX);
>  	sb->level =3D mddev->level;
>  	sb->size =3D mddev->dev_sectors / 2;
> -	sb->raid_disks =3D mddev->raid_disks;
> +	sb->raid_disks =3D min_t(int, mddev->raid_disks, MD_SB_DISKS);
>  	sb->md_minor =3D mddev->md_minor;
>  	sb->not_persistent =3D 0;
>  	sb->utime =3D clamp_t(time64_t, mddev->utime, 0, U32_MAX);
> @@ -1747,7 +1747,7 @@ static void super_90_sync(struct mddev *mddev, stru=
ct md_rdev *rdev)
>  			d->state |=3D (1<<MD_DISK_FAILFAST);
>  	}
>  	/* now set the "removed" and "faulty" bits on any missing devices */
> -	for (i=3D0 ; i < mddev->raid_disks ; i++) {
> +	for (i=3D0 ; i < min_t(int, mddev->raid_disks, MD_SB_DISKS) ; i++) {
>  		mdp_disk_t *d =3D &sb->disks[i];
>  		if (d->state =3D=3D 0 && d->number =3D=3D 0) {
>  			d->number =3D i;

[Severity: High]
Can super_90_sync() still access sb->disks[] out of bounds in the
rdev_for_each() loop and at sb->this_disk =3D sb->disks[rdev->desc_nr]?

sb->disks has MD_SB_DISKS (27) entries (indices 0..26), followed by
sb->this_disk at the end of the 4 KiB rdev->sb_page:

drivers/md/md.c:super_90_sync() {
	...
	rdev_for_each(rdev2, mddev) {
		...
		if (is_active)
			desc_nr =3D rdev2->raid_disk;
		else
			desc_nr =3D next_spare++;
		rdev2->desc_nr =3D desc_nr;
		d =3D &sb->disks[rdev2->desc_nr];
	...
	sb->this_disk =3D sb->disks[rdev->desc_nr];
}

When mddev->raid_disks >=3D MD_SB_DISKS (or when mddev->raid_disks plus the
number of spare or faulty devices in mddev->disks exceeds MD_SB_DISKS),
next_spare++ reaches >=3D MD_SB_DISKS, and rdev2->raid_disk for active
devices is not bounded against MD_SB_DISKS either.  Indexing
sb->disks[rdev2->desc_nr] and sb->disks[rdev->desc_nr] then reads and
writes past sb->disks[] and past the 4 KiB superblock page.

> @@ -4473,6 +4473,8 @@ raid_disks_store(struct mddev *mddev, const char *b=
uf, size_t len)
>  		mddev->delta_disks =3D n - olddisks;
>  		mddev->raid_disks =3D n;
>  		mddev->reshape_backwards =3D (mddev->delta_disks < 0);
> +	} else if (mddev->max_disks && n >=3D mddev->max_disks) {
> +		err =3D -EINVAL;
>  	} else
>  		mddev->raid_disks =3D n;
>  out_unlock:

[Severity: Medium]
Can raid_disks_store() bypass the max_disks check or overflow
mddev->raid_disks?

Because the new check is placed after the mddev->reshape_position !=3D
MaxSector branch, writing to raid_disks while mddev->pers =3D=3D NULL and
reshape_position !=3D MaxSector assigns mddev->raid_disks =3D n without
checking mddev->max_disks.

In addition, n is parsed as an unsigned int while mddev->raid_disks is a
signed int.  If n > INT_MAX is written while mddev->max_disks =3D=3D 0,
mddev->raid_disks becomes negative, which then passes the signed
mddev->raid_disks >=3D MD_SB_DISKS check in metadata_store() and causes
min_t(int, mddev->raid_disks, MD_SB_DISKS) in super_90_sync() to evaluate
to a negative number.

> @@ -5067,6 +5069,13 @@ metadata_store(struct mddev *mddev, const char *bu=
f, size_t len)
>  	err =3D -ENOENT;
>  	if (major >=3D ARRAY_SIZE(super_types) || super_types[major].name =3D=
=3D NULL)
>  		goto out_unlock;
> +	err =3D -EINVAL;
> +	if (major =3D=3D 0 && mddev->raid_disks >=3D MD_SB_DISKS)
> +		goto out_unlock;
> +	if (major =3D=3D 0)
> +		mddev->max_disks =3D MD_SB_DISKS;
> +	else
> +		mddev->max_disks =3D (4096 - 256) / 2;
>  	mddev->major_version =3D major;
>  	mddev->minor_version =3D minor;
>  	mddev->persistent =3D 1;

[Severity: Low]
Should metadata_store() also validate mddev->raid_disks against the new
max_disks when major !=3D 0, and reset mddev->max_disks =3D 0 in the "none"
and "external:" branches?

Right now, writing raid_disks >=3D (4096 - 256) / 2 before selecting v1.x
metadata is not rejected here, and switching metadata_version from 0.90 or
1.x to "none" or "external:" leaves the previous max_disks limit set on
the array.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/179507886219.2370.1=
301636898303569514@gmail.com?part=3D1
