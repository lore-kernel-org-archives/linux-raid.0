Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE81438AC90
	for <linux-raid@vger.kernel.org>; Wed, 24 Jun 2026 07:08:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782284933; cv=none; b=Q/fD3MWWkXcu0R5DUiMkBFU3yvAOWQVL6disa+1Vaaubv22x+wD1A+nemr6uMmHJM/uYSKDd+PHYiCovQyaJMG5uiBnOIDIREbYtAomE5c4uvd5/rkSz16GjG54wal0UFHT9UTCMiMD4mmaYjMkOIfVwHcwYctmtV+xjf9WOqL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782284933; c=relaxed/simple;
	bh=gCTRkuSmcBQArAQF1dP7JNM5JrSNaEQyCpKIieRIZrI=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=LZq2luqIh/ItcP3p+qWzgJYoqsY2RWuYHeDxgMBXLhsyqIa0UqqRilPENB83qZQ2HRAUloBtcKtbI5E+YvDb31k7aktx8irKkxsMP6qBP8Ye1m5DdrSM9J6xS4VzqsIQ+hDkGzyNvbojR5Bwx6CKS+4k5vCsKNty317VHN9WlQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Qub56dtF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Qub56dtF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27D8E1F000E9;
	Wed, 24 Jun 2026 07:08:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782284932;
	bh=/NJatGW4TOec4xJMTsnID/PoPOKHyB7PQFqRKLKTN2A=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Qub56dtFKZ26rhjaF7kuebXpTRdfQ7Lug3j5LxV/YVyHoqYa2uQkuhdOPFo1GNU/a
	 LuUGhb2u82t3IpC0N8L2Stpu8i/lDUq98/m4MLF3MHFosO6y5EJVh+F/UN/wfmPSEg
	 cFrO6dexGo8pJDOMQycvYh+FX0ZXE9SZ71g9KV/I2LaBF/jX9yWcc5uC42IPsqtAq0
	 U3JsSldbrNXT4YHepx8H+29frlYLChoo7VvGdCOzlSqqzH/yi1G2Ntiorxj1goDnkC
	 CM9t7cfnaS/Tz72F24OlIhjUCm+yBeJZdEog1SIDIiHm/lnGj+HQj+XfnXVjKZ8Brt
	 lAVO+8eBQHQiA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 10/20] md/md-llbitmap: add reshape range mapping
 helpers
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yu Kuai" <yukuai@kernel.org>
Cc: linux-raid@vger.kernel.org, yukuai@fygo.io
In-Reply-To: <8a47becf3100a3998e003afcdabce6c17c149194.1782282042.git.yukuai@kernel.org>
References: <20260605091527.2463539-1-yukuai@kernel.org>
 <cover.1782282042.git.yukuai@kernel.org>
 <8a47becf3100a3998e003afcdabce6c17c149194.1782282042.git.yukuai@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 24 Jun 2026 07:08:51 +0000
Message-Id: <20260624070852.27D8E1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] TOCTOU race on mddev->reshape_position causes bios to be mapped to=
 the wrong geometry.
- [High] The resync threads use raw array sectors and blindly compute the b=
itmap bit index using the old geometry's chunkshift, completely ignoring re=
shape_chunksize for sectors residing in the new geometry.
--

commit a481d24ff8d12695efeabb7f320e930174126333
Author: Yu Kuai <yukuai@fygo.io>

md/md-llbitmap: add reshape range mapping helpers
   =20
Teach llbitmap to choose old versus new geometry during reshape and to
encode exact bitmap ranges for the active geometry.

This is the mapping groundwork for checkpoint remapping.

> diff --git a/drivers/md/md-llbitmap.c b/drivers/md/md-llbitmap.c
> index 11fede1fc79fd..d27993cfb13da 100644
> --- a/drivers/md/md-llbitmap.c
> +++ b/drivers/md/md-llbitmap.c

[ ... ]

> @@ -1376,11 +1433,32 @@ static void llbitmap_destroy(struct mddev *mddev)
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

[Severity: High]
Can a concurrent reshape thread update mddev->reshape_position from MaxSect=
or to
0 between reading it into boundary and the call to llbitmap_reshaping()?

If that happens, boundary holds MaxSector but llbitmap_reshaping() evaluate=
s to
true. This would cause offset < MaxSector to evaluate to true, mapping the =
IO
to the new geometry before the array has actually reshaped the sector. Could
this race lead to data corruption?

> +
> +	WARN_ON_ONCE(sectors && offset < boundary && offset + sectors > boundar=
y);
> +
> +	return mddev->reshape_backwards ? offset < boundary : offset >=3D bound=
ary;
> +}

[ ... ]

> @@ -1549,7 +1627,11 @@ static bool llbitmap_blocks_synced(struct mddev *m=
ddev, sector_t offset)
>  {
>  	struct llbitmap *llbitmap =3D mddev->bitmap;
>  	unsigned long p =3D offset >> llbitmap->chunkshift;

[Severity: High]
Does this unconditionally use the old chunkshift to compute the bit index f=
rom
the raw sync offset?

During an interrupted reshape recovery, active IO computes the correct bit =
index
using llbitmap_encode_range() for the new geometry. However, functions like
llbitmap_blocks_synced(), llbitmap_skip_sync_blocks(), and llbitmap_start_s=
ync()
receive raw physical sectors from md_do_sync() and completely bypass
llbitmap_prepare_range().

If reshape_chunksize differs from chunksize, will the sync thread calculate=
 the
wrong bit index, read a clean bit instead of the dirty bit marked by active=
 IO,
and silently skip synchronizing the dirty sectors?

> -	enum llbitmap_state c =3D llbitmap_read(llbitmap, p);
> +	enum llbitmap_state c;
> +
> +	if (p >=3D llbitmap->chunks)
> +		return false;
> +	c =3D llbitmap_read(llbitmap, p);
> =20
>  	return c =3D=3D BitClean || c =3D=3D BitDirty || c =3D=3D BitCleanUnwri=
tten;
>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1782282042.gi=
t.yukuai@kernel.org?part=3D10
