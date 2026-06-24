Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69729358367
	for <linux-raid@vger.kernel.org>; Wed, 24 Jun 2026 07:24:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782285896; cv=none; b=gmfCavoLRBTTW5NX7yAhGH/OX8B5ojRvWe0wFYL669DIYplhLuScclEB4yoEkL+KqxJQIFPMpB9uF9Ok1CSsCd3XO1/U/RrIVh8qMP1UsYokGGeGi0oIsjBrn0ImPU2zq1qTuLLi7U3F/MoGIEuSjj+Z0PvPPRyyPp4JCW4gPnc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782285896; c=relaxed/simple;
	bh=FzyGfplLkDeUsMlhIW+FcHad0Wi3Gcm1HmNpwFByhdg=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=lXHh7R0owPO1hyRYH11XVfHoReeXyR95B1heBEdplds564V0D9j88t2JFSB056XRI0SFsKmiG6FokPSK/VxFiL4iBN0IYL/F1uOSxq3YyyoWvW0coeXgcTnGNuEuTOjQV6BUkZ9ZOoNGXFd76zbAv4AB+nripcJ8tT647aXaU9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FqKpUVqB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FqKpUVqB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDE1F1F000E9;
	Wed, 24 Jun 2026 07:24:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782285895;
	bh=ZHMGdhlrBq8N/8OTtJq2B4iT4WKQ/eYYmiuGO1SYfFk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=FqKpUVqBcx5QGe/e4IDi0h4YZiDcZXN5LfE7bRW4PoBjh7ULXJOUMABdLflhAoYvo
	 sVxvsmiRADOeL9khZ/IrHLe+DTBFW2DxCL4O9fk7dJ4xWUJK9LYwd0g9ArUhrY6a1s
	 e1SB0I2Hfs+IFtszdqmVImlmIrptAS4rvfGWgLuL9Ezyh7OxEoy7XcClmBe0m7MYji
	 PKppXyT3C2e87jZoBVMk5FjRi4Vm/6XPLvrEHks15lUSq28vSLuKMgsYszBGAxBH89
	 6vgwb1yieQsqZJLGLP8ZaiW9DMGOdPWlLetmXwknW4dr3tBL2iBg4/JYFGup/+nmGe
	 /idd1BBTzuiDw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 18/20] md/raid5: reject llbitmap reshape when md
 chunk shrinks
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yu Kuai" <yukuai@kernel.org>
Cc: linux-raid@vger.kernel.org, yukuai@fygo.io
In-Reply-To: <9b06d3a655f709b35ab10995a872b30d2026f7c3.1782282042.git.yukuai@kernel.org>
References: <20260605091527.2463539-1-yukuai@kernel.org>
 <cover.1782282042.git.yukuai@kernel.org>
 <9b06d3a655f709b35ab10995a872b30d2026f7c3.1782282042.git.yukuai@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 24 Jun 2026 07:24:54 +0000
Message-Id: <20260624072454.CDE1F1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:

New issues:
- [High] The validation in `check_reshape` fails to reject reshapes that de=
crease the number of data disks (`mddev->delta_disks < 0`) for llbitmap, le=
aving an identical bitmap coverage truncation vulnerability to the one the =
patch attempts to fix.

Pre-existing issues:
- [High] Writing 0 or a very small/overflowing value to the `chunk_size` sy=
sfs attribute bypasses chunk size validation, leading to a divide-by-zero k=
ernel panic during reshape.
- [High] Pre-existing memory leak of `stripe_head` pages in `resize_stripes=
()` if array reshape initialization fails.
--

commit cd96767f06f730181f5e43d1d52815ff0535ad82
Author: Yu Kuai <yukuai@fygo.io>

md/raid5: reject llbitmap reshape when md chunk shrinks
   =20
llbitmap reshape keeps one live bitmap and cannot safely make an
existing bitmap bit cover a smaller data range.

The llbitmap chunksize itself will not shrink when mddev->chunk_sectors
stays the same or grows. However, shrinking mddev->chunk_sectors shrinks
sectors_per_chunk used by raid5_bitmap_sector_map(). That can shrink the
effective data range covered by each bit across the old and new RAID5
geometry. Reject that reshape while llbitmap is active.

> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 1613a42cc25dc..9de648f75dd04 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -8506,6 +8506,9 @@ static int check_reshape(struct mddev *mddev)
>  	if (!check_stripe_cache(mddev))
>  		return -ENOSPC;
> =20
> +	if (mddev->bitmap_id =3D=3D ID_LLBITMAP &&
> +	    mddev->new_chunk_sectors < mddev->chunk_sectors)
> +		return -EOPNOTSUPP;

[Severity: High]
Does this validation fully address the logical coverage truncation?

The commit message correctly notes that shrinking mddev->chunk_sectors shri=
nks
sectors_per_chunk, which is unsafe for llbitmap because it shrinks the
effective data range covered by each bit.

However, sectors_per_chunk is also reduced if mddev->delta_disks < 0:

sectors_per_chunk =3D chunk_sectors * (raid_disks - max_degraded);

Since the validation here only checks if the new chunk sectors are smaller,
a reshape that reduces the number of data disks could bypass this check,
resulting in the exact same logical coverage truncation vulnerability.

Could this be updated to also check mddev->delta_disks < 0, or compute the
product to verify sectors_per_chunk does not shrink?

>  	if (mddev->new_chunk_sectors > mddev->chunk_sectors ||
>  	    mddev->delta_disks > 0)

[Severity: High]
This is a pre-existing issue, but writing 0 or a very small value to the
chunk_size sysfs attribute appears to bypass chunk size validation entirely,
leading to a divide-by-zero panic during reshape.

In drivers/md/md.c:chunk_size_store(), user input is right-shifted by 9
to compute mddev->new_chunk_sectors. If the user writes 0, it becomes 0.

When raid5_check_reshape() is called:

drivers/md/raid5.c:raid5_check_reshape() {
    ...
	if (new_chunk > 0) {
		if (!is_power_of_2(new_chunk))
			return -EINVAL;
    ...
}

Because the checks are inside if (new_chunk > 0), a value of 0 skips the
sanity bounds. check_reshape() then accepts it.

Later, in raid5_compute_sector(), this chunk size causes a kernel panic:

drivers/md/raid5.c:raid5_compute_sector() {
    ...
	chunk_offset =3D sector_div(r_sector, sectors_per_chunk);
    ...
}

Should chunk_size_store() or raid5_check_reshape() explicitly prevent a
chunk size of 0?

>  		if (resize_chunks(conf,
>  				  conf->previous_raid_disks
>  				  + max(0, mddev->delta_disks),
>  				  max(mddev->new_chunk_sectors,
>  				      mddev->chunk_sectors)
>  			    ) < 0)
>  			return -ENOMEM;
>=20
>  	if (conf->previous_raid_disks + mddev->delta_disks <=3D conf->pool_size)
>  		return 0; /* never bother to shrink */
>  	return resize_stripes(conf, (conf->previous_raid_disks
>  				     + mddev->delta_disks));
>  }

[Severity: High]
This isn't a bug introduced by this patch, but is it possible for
resize_stripes() to leak the stripe_head pages if the array reshape
initialization fails?

If the array reshape fails under memory pressure during step 3 of
resize_stripes() (for example, the ndisks allocation fails), the function
structurally proceeds to step 4 without aborting:

drivers/md/raid5.c:resize_stripes() {
    ...
		for (i=3Dconf->raid_disks; i < newsize; i++)
			if (nsh->dev[i].page =3D=3D NULL) {
				struct page *p =3D alloc_page(GFP_NOIO);
				nsh->dev[i].page =3D p;
    ...
}

It loops up to newsize and allocates physical pages for the expanded stripe
slots. At the end of the function, because err is set, it skips updating
conf->pool_size:

drivers/md/raid5.c:resize_stripes() {
    ...
	if (!err)
		conf->pool_size =3D newsize;
    ...
}

Since conf->pool_size is unchanged, any future teardown via shrink_buffers()
will intentionally ignore the newly allocated pages at indices >=3D pool_si=
ze.
When free_stripe() subsequently destroys the slab object without freeing th=
ese
pages, they appear to be permanently leaked.

Is there a mechanism that cleans up these orphaned pages if conf->pool_size
is not updated?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1782282042.gi=
t.yukuai@kernel.org?part=3D18
