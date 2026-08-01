Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C444E33F595
	for <linux-raid@vger.kernel.org>; Sat,  1 Aug 2026 17:47:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785606477; cv=none; b=GODBPeTv7HlguGM/Hv2+ACnGHZ4X0XlanhfXatTr4CaQkzixSS8tQmests5V6wk1Y8ZQRABMY1xl16cEwMwvSuMqJ7K3NSnA/WPJ7ip4KPqeNHw+CZVfMStr/on3Zbux3fYZJtcFNI/wCx1mVKSVSaRbIeDLZ3ugOpLe4Buuzfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785606477; c=relaxed/simple;
	bh=Eazli2WxaH2UReweuRQONzwM1vkwrXI08ms6K8KYk1c=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=qUgOEnsJfKm/TGuvs3f1Bt0yBYCzzLOVGltvrWenVCiDMxnGASk7TI6t0L38p1oetMtvGMHvfb6+LTVXJ5uSfKrzflwXoavRMFPHFvKxtY2Fp8JO4dEJXS3EvNz+XZB8B0GqNBcsgWGfXh2KjsV3+WFFgsKz8iNTMFyBUg7N+s0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jkEm7Jd4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jkEm7Jd4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74F5C1F00ACA;
	Sat,  1 Aug 2026 17:47:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785606476;
	bh=0f13L6dJ/n+YPUSXL5T5lePKNxTdOJgZNzEPhmIIkh8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=jkEm7Jd4LeLl5Ey7oPwR5LbL2e+X45C+H5/J9UoJydT2G7cwtvzR2GCuWcAal4Gft
	 UlKcznlEho/BRCGtzQnP/m4CSsKSrFFdCS3Wwmj2X6Af2n7dljTa0cX5ENknhxaFSx
	 iMAgcu73kBLHl4aGb3MiDppfua0b0ed0DJQAY7p14bYAuZSWcKWUhhjCrUMyGv2h7y
	 GWRi1xxt8eBiAdIKgUKdFGVgZnsNJHQ+QRJB+LfehEJrDgtv1/sfM+dRmCLwDYZoy5
	 z0+dVSvqTIdK0pW88ASdHdBYVwfpKtFe0eYfx5FJ5uwCDuYKJX/TExRuCcaef0KGZ9
	 N4lEgLaz6O69g==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 10/25] md/md-llbitmap: allocate page controls
 independently
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yu Kuai" <yukuai@kernel.org>
Cc: linux-raid@vger.kernel.org, yukuai@fygo.io
In-Reply-To: <20260801172519.2982121-11-yukuai@kernel.org>
References: <20260801172519.2982121-1-yukuai@kernel.org>
 <20260801172519.2982121-11-yukuai@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 01 Aug 2026 17:47:56 +0000
Message-Id: <20260801174756.74F5C1F00ACA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

New issues:
- [Critical] Unflushed zeroed pages create a memory-disk inconsistency, lea=
ding to silent parity corruption on crash/reboot after an array resize.

Pre-existing issues:
- [High] Incomplete fix for out-of-bounds array access on `pctl` during max=
imum in-place array growth.
--

--- Patch [10]: [PATCH v4 10/25] md/md-llbitmap: allocate page controls ind=
ependently ---
commit 325d92bcc68f880073f4c6b96714394c0bafe835
Author: Yu Kuai <yukuai@fygo.io>

md/md-llbitmap: allocate page controls independently

This patch allocates one llbitmap page-control object at a time and frees
each object through the same model. It also updates llbitmap_read_page() to
return a zeroed page without reading from disk when the page index is beyond
the current bitmap size.

> diff --git a/drivers/md/md-llbitmap.c b/drivers/md/md-llbitmap.c
> index 3417da288e994..d12b3dba6ae15 100644
> --- a/drivers/md/md-llbitmap.c
> +++ b/drivers/md/md-llbitmap.c
[ ... ]
> @@ -526,6 +532,8 @@ static struct page *llbitmap_read_page(struct llbitma=
p *llbitmap, int idx)
>  	page =3D alloc_page(GFP_NOIO | __GFP_ZERO);
>  	if (!page)
>  		return ERR_PTR(-ENOMEM);
> +	if (idx >=3D llbitmap_used_pages(llbitmap, llbitmap->chunks))
> +		return page;

[Severity: Critical]
Does this new bypass create a memory-disk inconsistency?

By returning a zeroed page in memory without reading or flushing to disk, t=
he
physical disk is left containing uninitialized garbage. If the array is
reshaped and expands into this pre-allocated region, a crash before the new
region is fully written could expose the disk garbage to the state machine =
on
the subsequent boot. If the garbage matches states like BitClean, resync
might be incorrectly skipped for the new region.

> =20
>  	rdev_for_each(rdev, mddev) {
[ ... ]
> +static unsigned int llbitmap_reserved_pages(struct llbitmap *llbitmap)
> +{
> +	return DIV_ROUND_UP(llbitmap->mddev->bitmap_info.space << SECTOR_SHIFT,
> +			    PAGE_SIZE);
> +}

[Severity: High]
This isn't a bug introduced by this patch, but does this calculation
under-allocate the array by one page for the maximum allowed chunk size?

This calculation omits BITMAP_DATA_OFFSET. Because llbitmap_resize() allows
chunks to grow up to space << SECTOR_SHIFT, the maximum used_pages (which
correctly includes the offset) can exceed reserved_pages by 1.

When pos approaches the maximum allowed chunks in llbitmap_write():

    pos +=3D BITMAP_DATA_OFFSET;
    idx =3D pos >> PAGE_SHIFT;

the offset causes idx to exceed the pre-allocated bounds of the pctl array,
which could lead to out-of-bounds memory corruption.

> +
> +static int llbitmap_alloc_pages(struct llbitmap *llbitmap)
> +{
[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260801172519.2982=
121-1-yukuai@kernel.org?part=3D10
