Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 568AC2F8E9C
	for <linux-raid@vger.kernel.org>; Wed, 24 Jun 2026 07:03:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782284634; cv=none; b=aIhwpII9IZlQkSvuTQLq5Axt0j33Pj6h9HUjL7J5sBazFv9mfnO3ZB/QXIlMQLpUGzYiaYTLbHcA5O/hAyGqQrJtRqVbvo8KLwuZ+UEhYIDcacg4XVhrg94y5Y3p2VUohsYiB5xA482DBOKHOrevF+AKYK9fU3nhI6+T1FC4zLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782284634; c=relaxed/simple;
	bh=FQDCM9A06PkpUOOqII6IAGt5TGjSFwpegJdNuTFSnf4=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Gkys0UhXbB3vEaa5Fr0fHHARvt1p9EV66OofjTZF9LPhdS6XzQUn6Gd0sOD++dzhCMaJh753Lpjr0nHJxTDXOLuIIv6BpNZbdVo+XG3DjvLhZfcOZonEJIKAK1+HDMQKt89vVwIJEV7sGgrOhW6Xm4AwtG4qJvx7cbpE8ND4iOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nWmt+RIw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nWmt+RIw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD0E21F000E9;
	Wed, 24 Jun 2026 07:03:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782284633;
	bh=qnVQ0BoWOT5UT6ARDD7kuPFtTicZMqpQx243fG007a8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=nWmt+RIwt52Sn1JIkPDP1x7Ne1UDp47FhFEHQrDRv6R4JoAZ2DD8/0qazq2P1h5N3
	 trXAtKEiSM7yGnZyKsmItQlshfSQRNih09pbRj2hHqenfcTIWMXuXWM6Ftw9nDfIrF
	 QsmzDRli/FELg0gHJ0P3U8Zt6r1MuCpQkpearJK5P4ardBLjcAsMvHHihC60dRAXvo
	 pjF2JAmQXLr1WjF6ccPcqbzj3uw9gGrKZHLvbtChNmXkX75uEsqqfqJ63UWfrjIcNf
	 rKL8OWGGBPoOoNnRvfgSKSK/EWq1fAyOq8N5sogaMb5dyFb+Nr4n9FRKbRPwvP2QDD
	 9wBtdM2zmyeoA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 06/20] md/md-llbitmap: grow the page cache in place
 for reshape
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yu Kuai" <yukuai@kernel.org>
Cc: linux-raid@vger.kernel.org, yukuai@fygo.io
In-Reply-To: <27639f9aceb3cb6d6d021df79f9f6839d916bb58.1782282042.git.yukuai@kernel.org>
References: <20260605091527.2463539-1-yukuai@kernel.org>
 <cover.1782282042.git.yukuai@kernel.org>
 <27639f9aceb3cb6d6d021df79f9f6839d916bb58.1782282042.git.yukuai@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 24 Jun 2026 07:03:52 +0000
Message-Id: <20260624070352.CD0E21F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:

New issues:
- [High] The `LLPageFlush` bit on existing cached pages is set during `llbi=
tmap_flush()` but never cleared, permanently bypassing the barrier idle exp=
iration timer and causing severe metadata write amplification.
- [High] Reallocating `llbitmap->pctl` locklessly in place causes a Use-Aft=
er-Free for concurrent I/O paths and the background daemon.

Pre-existing issues:
- [High] An integer overflow in chunk size calculation on 32-bit systems ca=
uses a fatal divide-by-zero for extremely large arrays.
--

commit 06efa66cdd24523c6bea3b2de073842d179f3506
Author: Yu Kuai <yukuai@fygo.io>

md/md-llbitmap: grow the page cache in place for reshape

Use the page-control helpers to grow llbitmap's cached pages in place
for resize and later reshape preparation, instead of rebuilding the
whole cache.

> diff --git a/drivers/md/md-llbitmap.c b/drivers/md/md-llbitmap.c
> index 4c3fc4b35aff0..98e7824c7362e 100644
> --- a/drivers/md/md-llbitmap.c
> +++ b/drivers/md/md-llbitmap.c
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
> +		*chunksize =3D *chunksize << 1;
> +		*chunks =3D DIV_ROUND_UP_SECTOR_T(blocks, *chunksize);

[Severity: High]
This isn't a bug introduced by this patch, but since `chunksize` is an
`unsigned long` (32 bits on 32-bit architectures) and `blocks` is a 64-bit
`sector_t`, could the left shift push `*chunksize` past 31 bits and overflow
it to 0 for extremely large arrays?

If `*chunksize` becomes 0, does this cause a divide-by-zero panic in the
`DIV_ROUND_UP_SECTOR_T()` macro?

> +	}
> +}

[ ... ]

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
> +	llbitmap->nr_pages =3D nr_pages;

[Severity: High]
Is it safe to reallocate and update `llbitmap->pctl` and `nr_pages` lockles=
sly
in place like this while the array is processing I/O?

`llbitmap_resize()` holds only `mddev->bitmap_info.mutex`, but concurrent
lockless readers like `md_llbitmap_daemon_fn()` and the I/O fastpath
`llbitmap_start_write()` dereference `llbitmap->pctl[idx]`.

Could this lead to a Use-After-Free if a concurrent reader accesses the old
`llbitmap->pctl` array just as it gets freed?

> +	return 0;
> +
> +err_alloc_ptr:
> +	ret =3D PTR_ERR(pctl[i]);

[ ... ]

> +static int llbitmap_prepare_resize(struct llbitmap *llbitmap,
> +				   unsigned long old_chunks,
> +				   unsigned long new_chunks,
> +				   unsigned long cache_chunks)
> +{
> +	int ret;
> +
> +	llbitmap_flush(llbitmap->mddev);
> +	ret =3D llbitmap_expand_pages(llbitmap, cache_chunks);

[Severity: High]
Does this sequence cause the daemon thread to bypass the barrier idle timer=
 and
create severe metadata write amplification?

`llbitmap_flush()` sets the `LLPageFlush` bit on all existing pages. Since
`llbitmap_expand_pages()` reuses the existing `pctl` structures, the active
pages are retained with the `LLPageFlush` bit still set.

Since this bit is never cleared, the check in `md_llbitmap_daemon_fn()`:

	if (!test_bit(LLPageFlush, &pctl->flags) &&
	    time_before(jiffies, pctl->expire)) {
		restart =3D true;
		continue;
	}

will permanently fail for these pages, forcing the daemon to immediately fl=
ush
them and skip re-arming the pending timer.

> +	if (ret)
> +		return ret;
> +	if (new_chunks > old_chunks)
> +		llbitmap_mark_range(llbitmap, old_chunks, new_chunks - 1,
> +				    BitUnwritten);
> +	return 0;
> +}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1782282042.gi=
t.yukuai@kernel.org?part=3D6
