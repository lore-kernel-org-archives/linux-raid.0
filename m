Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30B4B41BA98
	for <linux-raid@vger.kernel.org>; Tue, 28 Jul 2026 09:15:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785230161; cv=none; b=S1bkoeTuCAuaQ3hfyLsKCHlNorybihMeI660uG/bg+5+EGSaKA1Jqen0Aj+6+VajVsFDY8rhg5GhPMYHJc1AA5QmZJ3Fs+mmVd9Kw/3cbVdFz4yJRfjyaflYcubstmJhZHuwTPxmX3dfzmfpoWi4MVeY/AYOPFneoBxANEHnKys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785230161; c=relaxed/simple;
	bh=PhUb0MvXUpldD44/+p+i68rAkX2e/R2kQT2qCkNx3Rs=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=lQXsuLF1F7DhZdDOaKm64u7aMGRpM3E5pdjLdMLirXCouZxeFhWcERXp88YcGRbg6UFAga3sXK8Fks2nozTwshnhYKmjrNR4ujiZoBPNolmkkTGxEhFHWcs1ITwVRKMouQCWB/eZQs5iK1YpO4MhztlWC51ndOGvZn3Tsjx/FTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cq4CuVKZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cq4CuVKZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B27B1F000E9;
	Tue, 28 Jul 2026 09:15:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785230159;
	bh=aQP54hm+Pvx4vqQNUjKcmAzrtKlmgEdcDo8HILxNKzs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=cq4CuVKZDM/1zPjrvaeJ50Sm9aPidfI1YPaKDPN59AP+K1iT7i8kObX5D3RoIia8p
	 G+qs/7ijfcT3COTZ8tghpxoi0Jh1+7YnXYL+AR6MqKy3DxX6C9/ptTKo8cysw9r9KA
	 J1i/gC2vuAafiuiYu3/2PZmdV4DEW7M8jn6gKW+LF1+nVwlBc2/ftj7NDVHeXxw8qf
	 QwBX0QIfFl9TedO5JmgQeY27T9fav5/czWuLDbd1uyLDlG84Aorjc3fwbQreqkzWzI
	 AouHw5TNxfDyEGlKH5BQbDB57hHBemYGcmE6CK3P4sy2GfX5f0iagFTInV54IEHqmH
	 OTbdcjWeDh9sg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 15/21] md/raid10: reject llbitmap reshape when md
 chunk shrinks
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yu Kuai" <yukuai@kernel.org>
Cc: linux-raid@vger.kernel.org, yukuai@fygo.io
In-Reply-To: <afa30cd1979fd4ea579c7db9c684a12cdea1a895.1785206690.git.yukuai@fygo.io>
References: <cover.1785206690.git.yukuai@fygo.io>
 <afa30cd1979fd4ea579c7db9c684a12cdea1a895.1785206690.git.yukuai@fygo.io>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 28 Jul 2026 09:15:59 +0000
Message-Id: <20260728091559.9B27B1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

New issues:
- [High] Missing Validation in Array Assembly Path

Pre-existing issues:
- [High] Logic Error in Resume Path forces reshape start despite check fail=
ure
--

--- Patch [15]: [PATCH v3 15/21] md/raid10: reject llbitmap reshape when md=
 chunk shrinks ---
commit 0f54995b397bafdc9d0ce8dd025c97e68e5b1284
Author: Yu Kuai <yukuai@fygo.io>

md/raid10: reject llbitmap reshape when md chunk shrinks

llbitmap reshape keeps one live bitmap and cannot safely make an
existing bitmap bit cover a smaller data range.

The llbitmap chunksize itself will not shrink when mddev->chunk_sectors
stays the same or grows. However, shrinking mddev->chunk_sectors can
shrink the effective data range covered by each bit for the RAID10
reshape geometry. Reject that reshape while llbitmap is active.

> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index 0a3cfdd3f5df8..1242b8d3bb6bd 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -4284,6 +4284,10 @@ static int raid10_check_reshape(struct mddev *mdde=
v)
> =20
>  	if (conf->geo.far_copies !=3D 1 && !conf->geo.far_offset)
>  		return -EINVAL;
> +	if (mddev->bitmap_id =3D=3D ID_LLBITMAP &&
> +	    mddev->new_chunk_sectors &&
> +	    mddev->new_chunk_sectors < mddev->chunk_sectors)
> +		return -EOPNOTSUPP;

[Severity: High]
This is a pre-existing issue, but does returning an error code here actually
prevent the reshape from starting?

Looking at mddev_start_reshape() in drivers/md/md.c, it seems to treat a
non-zero return value from check_reshape() as a trigger to execute
start_reshape():

    if (mddev->reshape_position =3D=3D MaxSector ||
        mddev->pers->check_reshape =3D=3D NULL ||
        mddev->pers->check_reshape(mddev)) {
            clear_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
            ret =3D mddev->pers->start_reshape(mddev);

Since raid10_check_reshape() returns -EOPNOTSUPP,
mddev->pers->check_reshape(mddev) will evaluate to true. Will this bypass
the rejection and force raid10_start_reshape() to proceed with the invalid
geometry?

[Severity: High]
Does this same llbitmap constraint need to be validated during array
assembly?

If an array with an active llbitmap and a suspended reshape with a shrunk
chunk size is assembled, md_run() invokes raid10_run(), which assigns the
new geometry via setup_conf() without validating the llbitmap constraint:

drivers/md/raid10.c:setup_conf() {
    ...
    if (mddev->reshape_position =3D=3D MaxSector) {
        conf->prev =3D conf->geo;
        conf->reshape_progress =3D MaxSector;
    } else {
        if (setup_geo(&conf->prev, mddev, geo_old) !=3D conf->copies) {
            err =3D -EINVAL;
            goto out;
        }
    ...
}

Could this allow the array to mount and serve I/O using a geometry where
the bitmap bits cover a smaller data range than originally intended, causing
data corruption because the bitmap won't properly track the full range
written?

> =20
>  	if (setup_geo(&geo, mddev, geo_start) !=3D conf->copies)
>  		/* mustn't change number of copies */

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1785206690.gi=
t.yukuai@fygo.io?part=3D15
