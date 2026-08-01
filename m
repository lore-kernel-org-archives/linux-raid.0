Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12F6919DF62
	for <linux-raid@vger.kernel.org>; Sat,  1 Aug 2026 18:03:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785607421; cv=none; b=djoMTIgwn/LJjfwOBCQBO4iIb1cCRiYsRELc9a6/Y+XiYugcUqX65tu6KXe38mUmTd6gp0cmibkqfCcl3ZWoK0MWJ6gFP7RIB1bWyHNwJH+AYMQ2FZT+b1Mdc/HIISIvMKixgUI4nPC70QEPqG06owyA9u3ZvaLAlN5GZaa1ghs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785607421; c=relaxed/simple;
	bh=nqMrDsL4fYUg65l5/7mzwCsAd6Nlc+KNfb2xvn+37ZE=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=WJVUEvCoaDg6ReRrVo8Ofc26CEl+JST9Sg6lFRvqIbO2X0WFl+y+PA3F/IWdS4fLaLrAuPQJDt+m+sFcTOW0g+6K2VUbcwDAnezpPEzaPvuQRcq72z0YtA2s6IY9WmHzQvPKa/WaTzkbjDJS6+HiV36eSI0QaYnvqelc6Ge6AfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mgQh27xv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mgQh27xv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF6551F00AC4;
	Sat,  1 Aug 2026 18:03:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785607419;
	bh=DhDEuO5fMFLrdIr0d6I6Ebtii7/Wufik4yAIlVRjXUQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=mgQh27xv5hgONtwU4cNbvphlGr8LM8kDTNcQx76d8qjAkiGLORyg4Q5oiuBZkauvC
	 k34VQSAOL3Xx0YhQ5gZv+UjplVpb4DdURpsWpd5oYXqYP3FunrRCixLo+iG5Jy/Vg8
	 2zuWI/L8uw6N/o9xjm4PCVzmAAuRKVVjrc2hSjzwOZ/ZHuYsZSRuJYgmGJaUjTn5dm
	 DJmDO83s6WU4Df2C3Vez2G31kgQEQiyYAQyqhb34ylLVZb04JsVWwnHMiWmPgFM1qJ
	 cyOcvnUmV2EEOKcI77/8dfn1be98kmlz/sU0p/H/ewAs6vrBNiDm5fs0ZjJN0ydYfG
	 BJ/57n3OteY8A==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 11/25] md/md-llbitmap: grow the page cache in place
 for reshape
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yu Kuai" <yukuai@kernel.org>
Cc: yukuai@fygo.io, linux-raid@vger.kernel.org
In-Reply-To: <20260801172519.2982121-12-yukuai@kernel.org>
References: <20260801172519.2982121-1-yukuai@kernel.org>
 <20260801172519.2982121-12-yukuai@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 01 Aug 2026 18:03:39 +0000
Message-Id: <20260801180339.AF6551F00AC4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 4 potential issue(=
s) to consider:

New issues:
- [High] Deadlock during memory allocation under quiesced MD array state
- [High] Incomplete reshape logic fails to update chunksize, causing out-of=
-bounds array access
- [High] Non-atomic replacement of `llbitmap->pctl` exposes concurrent lock=
less readers to use-after-free

Pre-existing issues:
- [Critical] Bitmap sizing logic omits superblock offset, causing out-of-bo=
unds on-disk write
--

--- Patch [11]: [PATCH v4 11/25] md/md-llbitmap: grow the page cache in pla=
ce for reshape ---
commit 4834d913bd6249e72f12baf6160c3e9e149b6525
Author: Yu Kuai <yukuai@fygo.io>

md/md-llbitmap: grow the page cache in place for reshape

Use the page-control helpers to grow llbitmap's cached pages in place
for resize and later reshape preparation, instead of rebuilding the
whole cache.

> diff --git a/drivers/md/md-llbitmap.c b/drivers/md/md-llbitmap.c
> index d12b3dba6ae15..cf522fae78f8a 100644
> --- a/drivers/md/md-llbitmap.c
> +++ b/drivers/md/md-llbitmap.c
[ ... ]
> @@ -416,6 +416,19 @@ static char state_machine[BitStateCount][BitmapActio=
nCount] =3D {
>  };
> =20
>  static void __llbitmap_flush(struct mddev *mddev);
> +static void llbitmap_flush(struct mddev *mddev);
> +static void llbitmap_update_sb(void *data);
> +
> +static void llbitmap_calculate_chunks(struct mddev *mddev, sector_t bloc=
ks,
> +				      unsigned long *chunksize,
> +				      unsigned long *chunks)
> +{
> +	*chunks =3D DIV_ROUND_UP_SECTOR_T(blocks, *chunksize);
> +	while (*chunks > mddev->bitmap_info.space << SECTOR_SHIFT) {

[Severity: Critical]
This isn't a bug introduced by this patch, but does this space validation
check omit the BITMAP_DATA_OFFSET?

Since the bitmap format includes a superblock at the start, it consumes
BITMAP_DATA_OFFSET bytes (typically 1024). If a geometry requires payload
bytes closely fitting the reserved space, the total footprint could exceed
the reserved sectors.

During a flush, could the bitmap write its pages to disk past the end of
the reserved space, potentially overwriting adjacent metadata or user data?

> +		*chunksize =3D *chunksize << 1;
> +		*chunks =3D DIV_ROUND_UP_SECTOR_T(blocks, *chunksize);
> +	}
> +}
[ ... ]
> @@ -655,6 +668,48 @@ static unsigned int llbitmap_reserved_pages(struct l=
lbitmap *llbitmap)
>  			    PAGE_SIZE);
>  }
> =20
> +static int llbitmap_expand_pages(struct llbitmap *llbitmap,
> +				 unsigned long chunks)
> +{
> +	struct llbitmap_page_ctl **pctl;
> +	unsigned int old_nr_pages =3D llbitmap->nr_pages;
> +	unsigned int nr_pages =3D llbitmap_used_pages(llbitmap, chunks);
> +	unsigned int i;
> +	int ret;
> +
> +	if (nr_pages <=3D old_nr_pages)
> +		return 0;
> +
> +	pctl =3D kcalloc(nr_pages, sizeof(*pctl), GFP_KERNEL);

[Severity: High]
Can this allocation cause a deadlock under memory pressure?

The GFP_KERNEL flag permits direct memory reclaim. If the VM attempts to
write dirty filesystem pages back to the block device to free memory, the
writeback could be directed at the MD array.

Since llbitmap_resize() suspends the array using
mddev->pers->quiesce(mddev, 1) before calling this function:

drivers/md/md-llbitmap.c:llbitmap_resize() {
    ...
    if (mddev->pers->quiesce) {
        mddev->pers->quiesce(mddev, 1);
    ...
    ret =3D llbitmap_prepare_resize(...)
}

Will the I/O block indefinitely waiting for the array to unquiesce,
deadlocking the thread that is holding the quiesce state?

> +	if (!pctl)
> +		return -ENOMEM;
> +
> +	if (llbitmap->pctl)
> +		memcpy(pctl, llbitmap->pctl,
> +		       array_size(old_nr_pages, sizeof(*pctl)));
> +
> +	for (i =3D old_nr_pages; i < nr_pages; i++) {
> +		pctl[i] =3D llbitmap_alloc_page_ctl(llbitmap, i);
> +		if (IS_ERR(pctl[i]))
> +			goto err_alloc_ptr;
> +	}
> +
> +	kfree(llbitmap->pctl);
> +	llbitmap->pctl =3D pctl;

[Severity: High]
Does freeing the old pointer array non-atomically without RCU protection
expose concurrent lockless readers to a use-after-free?

Although the array is quiesced here, background tasks such as
llbitmap_unplug_fn() (queued by blk_finish_plug() for tasks that submitted
I/O before the quiesce) might still execute concurrently.

If a lockless reader is iterating over llbitmap->nr_pages and reading from
llbitmap->pctl[i], could it be preempted while holding the old pointer and
dereference freed memory when this code executes?

> +	llbitmap->nr_pages =3D nr_pages;
> +	return 0;
[ ... ]
> @@ -1171,24 +1254,62 @@ static int llbitmap_create(struct mddev *mddev)
>  static int llbitmap_resize(struct mddev *mddev, sector_t blocks, int chu=
nksize)
>  {
[ ... ]
> +	mutex_lock(&mddev->bitmap_info.mutex);
> +	cache_chunks =3D reshape ? max(old_chunks, chunks) : chunks;
> +	ret =3D llbitmap_prepare_resize(llbitmap, old_chunks, chunks, cache_chu=
nks);
> +	if (ret)
> +		goto out;
> +
> +	if (reshape) {
> +		llbitmap->chunks =3D max(old_chunks, chunks);
> +	} else {

[Severity: High]
Is the reshape logic missing updates to the chunksize and chunkshift
variables?

When reshaping an array to a larger size, the required bitmap chunksize
may increase. While llbitmap->chunks is updated here, llbitmap->chunksize
and llbitmap->chunkshift appear to be left unchanged.

When new I/O arrives, llbitmap_start_write() would calculate the chunk
index using the old, smaller chunkshift.

Could this produce a required chunk index that exceeds the newly allocated
llbitmap->chunks limit, leading to an out-of-bounds access when writing the
state in llbitmap_write():

drivers/md/md-llbitmap.c:llbitmap_write() {
    ...
    idx =3D pos >> PAGE_SHIFT;
    bit =3D offset_in_page(pos);
    llbitmap->pctl[idx]->state[bit] =3D state;
    ...
}

> +		if (blocks < old_blocks && chunks < old_chunks)
> +			llbitmap_mark_range(llbitmap, chunks, old_chunks - 1,
> +					    BitUnwritten);
> +		mddev->bitmap_info.chunksize =3D bitmap_chunksize;
> +		llbitmap->chunks =3D chunks;
> +		llbitmap->sync_size =3D blocks;
> +		llbitmap_update_sb(llbitmap);
> +	}
[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260801172519.2982=
121-1-yukuai@kernel.org?part=3D11
