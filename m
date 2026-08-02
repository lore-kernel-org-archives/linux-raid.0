Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2740633B97B
	for <linux-raid@vger.kernel.org>; Sun,  2 Aug 2026 20:40:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785703207; cv=none; b=U3c1xxHJeFiYncZZEQR2OtktUR8MLrjLbb/qTNN9cvurWI+9VFXh5SuMjcwCzg8W3L0oGSkG5QkDbu4ijGvtieKuutNhbFCEZ3nasBzA6jMlxMn9HKmAe+o/uN711OQ7A4ZqvUii4ukLQxFPaxJ8d/d53iGCVVV+kW+FoLzLDm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785703207; c=relaxed/simple;
	bh=l7sIKtln/B/uO63QCalpi0tC91kOb2sqXQfvfX3MtYw=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=mksWufSVu5C0LgBOW4TnQFvfeHyF2uYwWvkRNm7pbDHKw0usA/clIgkUM0eNzez2wrl31IptgQv5uj3Sb+wBkGx5GRG4m6od1G8PVK0Y+sHRp4DkzOQbQOUs9kvN/kcUBD9ve8sdEAPA74okGd35OO+jHx0IuTw7NpVuLG2X8kY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OBu8IJHF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OBu8IJHF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 224761F000E9;
	Sun,  2 Aug 2026 20:40:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785703205;
	bh=VgAFZaFKT4z1UvDE3aISFBP6SLsOcowSsCJjK42e2Zo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=OBu8IJHFo6Aq4sI1Xp16SV4VPImPGDRMO9vXW8hhFZJKuG2ELSTLlBg2/1LEyFZV9
	 u/9szdh9pldFrwEEyXtYiRPwBHKS0eSkzFGyHdZ0cvk/NhSSDK+XB1e9kYPgut/XdW
	 cjCXXbOMDq+g7R7oK57wpBzjruiCnoiBgtYEYP8DjSwi1KdCUC/m8WM04EezJE4K9O
	 7uJjwmlT0sE+n7HFGXVthWBkj91nlrfwZHN/iRulRHfHsQ3aduwpMWC4fyxp+jD6BR
	 FHObnxVfLjiTFWbbbnuQW+iLcFQ8Q0cHQHvhIKA78gYOQ65H10nkQAtVsxjubox0kd
	 Hvd3rnPb6ALkw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 23/29] md/raid10: reject llbitmap reshape when md
 chunk shrinks
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yu Kuai" <yukuai@kernel.org>
Cc: yukuai@fygo.io, linux-raid@vger.kernel.org
In-Reply-To: <20260802195038.164272-24-yukuai@kernel.org>
References: <20260802195038.164272-1-yukuai@kernel.org>
 <20260802195038.164272-24-yukuai@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 02 Aug 2026 20:40:03 +0000
Message-Id: <20260802204005.224761F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [Critical] The patch intends to reject shrinking reshapes when `ID_LLBITM=
AP` is active by returning `-EOPNOTSUPP` from `raid10_check_reshape()`. How=
ever, a severe pre-existing logic flaw in `mddev_start_reshape()` causes it=
 to evaluate any non-zero return (including negative error codes) as a trut=
hy condition. This bypasses the patch's protection entirely and triggers a =
destructive array corruption if the reshape is interrupted.
--

--- Patch [23]: [PATCH v5 23/29] md/raid10: reject llbitmap reshape when md=
 chunk shrinks ---
commit f65520f6e55cf9e2cea49909a73ee06aeb4f57b1
Author: Yu Kuai <yukuai@fygo.io>

md/raid10: reject llbitmap reshape when md chunk shrinks

llbitmap reshape keeps one live bitmap and cannot safely make an
existing bitmap bit cover a smaller data range. Shrinking mddev->chunk_sect=
ors
can shrink the effective data range covered by each bit for the RAID10
reshape geometry.

> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index ed3c6fbe65f78..1c3393467667b 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -4245,6 +4245,10 @@ static int raid10_check_reshape(struct mddev *mdde=
v)
> =20
>  	if (conf->geo.far_copies !=3D 1 && !conf->geo.far_offset)
>  		return -EINVAL;
> +	if (mddev->bitmap_id =3D=3D ID_LLBITMAP &&
> +	    mddev->new_chunk_sectors &&
> +	    mddev->new_chunk_sectors < mddev->chunk_sectors)
> +		return -EOPNOTSUPP;

[Severity: Critical]
This is a pre-existing issue, but returning an error code here doesn't seem
to prevent the reshape from starting if it was already interrupted.

Looking at mddev_start_reshape() in drivers/md/md.c, it evaluates the negat=
ive
error code as a truthy condition:

	if (mddev->reshape_position =3D=3D MaxSector ||
	    mddev->pers->check_reshape =3D=3D NULL ||
	    mddev->pers->check_reshape(mddev)) {
		clear_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
		ret =3D mddev->pers->start_reshape(mddev);

Since -EOPNOTSUPP evaluates to true, will this erroneously call
mddev->pers->start_reshape() instead of aborting the operation?

If so, does this cause raid10_start_reshape() to destructively reset the
reshape progress back to 0 for an interrupted reshape?

	} else
		conf->reshape_progress =3D 0;
	conf->reshape_safe =3D conf->reshape_progress;

> =20
>  	if (setup_geo(&geo, mddev, geo_start) !=3D conf->copies)
>  		/* mustn't change number of copies */

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260802195038.1642=
72-1-yukuai@kernel.org?part=3D23
