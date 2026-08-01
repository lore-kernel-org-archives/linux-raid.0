Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B51148987E
	for <linux-raid@vger.kernel.org>; Sat,  1 Aug 2026 17:44:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785606254; cv=none; b=DlBy8OZ9tQsYZIPigpgqaJnwUCHAnRjPM7Qr3c3Mw/KtLO1zkl4gni+VS/r9ATcgldfKpDldQhLJOweTWyd05wIlBCL7jFf9F8iyPSFYmgFdXo749BKTkrzbfpsGZTyAOV/hGUYHlQM4CFtJd+5bRRh7DjD3e261itpHILsn3Gg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785606254; c=relaxed/simple;
	bh=+UHU/64Ig7iCTrDxYAkXH8+XOoA/VS18dj8JN2riIu8=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=GxI24t5xpO1eAQc+6cyW1YLKTs8HyfsAy1GJnyINBUeqecI6UzjAYHagsiWyzv9Fd2uVxUaZoxDk2XjZaHXdnVs/auF7tPIQv1vrCX3WOgPRDCUfUZs6F/iMYHSs5YB+3FFl8tuxW/PiNgGqH8A2vpmdOJ+EsNmb+0W32RWz9ps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aaHCuwZ7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aaHCuwZ7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE1FC1F00AC4;
	Sat,  1 Aug 2026 17:44:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785606253;
	bh=IooC2qko3RgYxk+ntcEEU8MntcIdZRFeHM3SfXsIXbE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=aaHCuwZ7YW8x3mKdAV4rAY4NdMrb2xZTzZPTNUYF1FNwpGJQ07OquQHBXvizytzXi
	 C9JHscrEyMtMiDnEw2am3KYbxXoe+da51fKOxSNZCLPMlAjgBGILtsjXumNDDD3+Ux
	 8H+ql5YYHp9BIMaHHDeGBtH/y2X+bTrpLIK5JMaMkK17kHNk7F/6b08sUq+O1p8EQ3
	 o1kA8vqUktwhtxpIb5z5gI1rkrUBVHBASCDTr7UQFucrixV0JVdyKuu5yiK0f/0HGz
	 yM+CTNUu45TRZ00gBq7ZhqeACXdSw+ouBHAPg/Lru4KNKhWc2lurIZ8yqYpvHGt12m
	 NftsHFU9rKz8Q==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 09/25] md/md-llbitmap: track bitmap sync_size
 explicitly
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yu Kuai" <yukuai@kernel.org>
Cc: yukuai@fygo.io, linux-raid@vger.kernel.org
In-Reply-To: <20260801172519.2982121-10-yukuai@kernel.org>
References: <20260801172519.2982121-1-yukuai@kernel.org>
 <20260801172519.2982121-10-yukuai@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 01 Aug 2026 17:44:12 +0000
Message-Id: <20260801174412.DE1FC1F00AC4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] Missing bounds check on `sync_size` causes out-of-bounds memory ac=
cesses and disk overwrites.
--

--- Patch [9]: [PATCH v4 09/25] md/md-llbitmap: track bitmap sync_size expl=
icitly ---
commit b06a020ec2776bd2bc0418543c90f7ea1a1e754b
Author: Yu Kuai <yukuai@fygo.io>

md/md-llbitmap: track bitmap sync_size explicitly

Track llbitmap's own sync_size instead of always using
mddev->resync_max_sectors directly. This is the minimal bookkeeping needed
before llbitmap can track old and new reshape geometry independently.

> diff --git a/drivers/md/md-llbitmap.c b/drivers/md/md-llbitmap.c
> index 1fa2adf0ada1c..3417da288e994 100644
> --- a/drivers/md/md-llbitmap.c
> +++ b/drivers/md/md-llbitmap.c

[ ... ]

> @@ -987,6 +991,9 @@ static int llbitmap_read_sb(struct llbitmap *llbitmap)
>  		goto out_put_page;
>  	}
> =20
> +	sync_size =3D le64_to_cpu(sb->sync_size);
> +	if (!sync_size)
> +		sync_size =3D mddev->resync_max_sectors;

[Severity: High]
Does this code bypass capacity validation if the superblock is corrupted or
tampered?

If an array is assembled with a bitmap superblock where sb->sync_size is
artificially large or small, this untrusted sync_size is read here.

However, it appears the bounds check later in llbitmap_read_sb() still
validates against mddev->resync_max_sectors instead of the new sync_size:

	if (chunksize < DIV_ROUND_UP_SECTOR_T(mddev->resync_max_sectors,
					      mddev->bitmap_info.space << SECTOR_SHIFT)) {

Could this allow maliciously large or small chunk requirements to bypass
capacity validation?

>  	chunksize =3D le32_to_cpu(sb->chunksize);
>  	if (!is_power_of_2(chunksize)) {
>  		pr_err("md/llbitmap: %s: chunksize not a power of 2",

[ ... ]

> @@ -1022,8 +1029,9 @@ static int llbitmap_read_sb(struct llbitmap *llbitm=
ap)
> =20
>  	llbitmap->barrier_idle =3D DEFAULT_BARRIER_IDLE;
>  	llbitmap->chunksize =3D chunksize;
> -	llbitmap->chunks =3D DIV_ROUND_UP_SECTOR_T(mddev->resync_max_sectors, c=
hunksize);
> +	llbitmap->chunks =3D DIV_ROUND_UP_SECTOR_T(sync_size, chunksize);

[Severity: High]
Is it safe to compute llbitmap->chunks using the unvalidated sync_size here?

Since the validation check above still uses mddev->resync_max_sectors, an
artificially large sync_size will cause llbitmap->chunks to exceed the
allocated metadata space. This breaks the capacity validation invariant.

Could this cause __llbitmap_flush() and llbitmap_write_page() to write bitm=
ap
data out-of-bounds on the underlying disk, overwriting adjacent partitions?

Additionally, if sync_size is artificially small, the llbitmap->pctl array
allocation (nr_pages) will be undersized. When IO arrives at valid offsets
bounded by the block layer capacity, fast paths like llbitmap_start_write()
could calculate a page_start index that exceeds nr_pages:

drivers/md/md-llbitmap.c:llbitmap_start_write() {
    ...
	int page_start =3D (start + BITMAP_DATA_OFFSET) >> PAGE_SHIFT;
	int page_end =3D (end + BITMAP_DATA_OFFSET) >> PAGE_SHIFT;

	while (page_start <=3D page_end) {
		llbitmap_raise_barrier(llbitmap, page_start);
		page_start++;
	}
    ...
}

Could this lead to an out-of-bounds memory access on the pctl array when
calling llbitmap_raise_barrier()?

>  	llbitmap->chunkshift =3D ffz(~chunksize);
> +	llbitmap->sync_size =3D sync_size;
>  	ret =3D llbitmap_cache_pages(llbitmap);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260801172519.2982=
121-1-yukuai@kernel.org?part=3D9
