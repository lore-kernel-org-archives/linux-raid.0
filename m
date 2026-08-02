Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E8312FFF8D
	for <linux-raid@vger.kernel.org>; Sun,  2 Aug 2026 20:39:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785703157; cv=none; b=PMVAQ7GiMquDKSkvIChOkH270x0H1z2M3YNDgLhjyckKc0kwWDN3ZfD55qZx+XSfZc8GdiFeOUcqsZC8Lj3nftD4UG/PG2UlW8tQ4NR7Jg1Gz0JUQ1Rq8dOWNBCHb+pMnuzyBk4QwZE+OThJLF3fg4Z7RU0BGnJ57u7DR65sG5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785703157; c=relaxed/simple;
	bh=mORhiXEsxA2ITNTNtuG8o1E0D9HeleyQN9L8xWw9sd0=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=GMU5ipAiDOa1hhpiZKqvUvztq9aS+LmnkYGToTDSpEeVlVQLmBxfJgGJmbhCUa0xJ+MVquyUfG5UGfjsj/LHHnuNXlceMrmj9Uvq65h6W0ygqFk5j0XNwK4GK6+JiEsU93EjgeVIgkh5T73VIxFufIY5SrgELpV9SXH/TglzWBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Y0Lg1Ncr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Y0Lg1Ncr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3BA61F000E9;
	Sun,  2 Aug 2026 20:39:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785703156;
	bh=/ERoqYQj6uVRMOX7IgVBz7BBoyBRz95AWhHWIzHxuOU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Y0Lg1Ncrdnrq3oAXewaxCS9+0fURsnM+UWT6Yv30DyIto+87OuLDtBpG5n3IxF3Nb
	 krSf9HUPCa0QEvVcETb4kmJJlDjfJuFfCjG/jwOxJQIFgJFnEy4DPzPXkOOBy6nI6q
	 hKS5V3J9Fm2+ZNEOO3G4TNOyF6WUAZUQyPgbbrGBKQYANBV+kbhhIvyTT0nKcnyhcw
	 IasLXYwyWQvoM//nRSi4Vc5Ih+ITNQ/YjcLUzOFJevgAiMiCH9ZMXgoTfK7vi53vdY
	 hhp8u3Yv05ev9Y6GckaV3kXOpPwhy4Rou8TvixhU783DyT6eeo2Jnhf3tlurdI99E4
	 KeUvOr6a4Y+nA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 08/29] md/md-llbitmap: prevent create failure bitmap
 UAF
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yu Kuai" <yukuai@kernel.org>
Cc: linux-raid@vger.kernel.org, yukuai@fygo.io
In-Reply-To: <20260802195038.164272-9-yukuai@kernel.org>
References: <20260802195038.164272-1-yukuai@kernel.org>
 <20260802195038.164272-9-yukuai@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 02 Aug 2026 20:39:14 +0000
Message-Id: <20260802203915.D3BA61F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Early publication of `mddev->bitmap` in `llbitmap_create()` races =
with lockless deferred IO (unplug callbacks), leading to UAF or NULL pointe=
r dereference.
- [Medium] Improper cleanup sequence in `llbitmap_read_sb()`: `__free_page(=
)` is called before `kunmap_local()`.
--

--- Patch [8]: [PATCH v5 08/29] md/md-llbitmap: prevent create failure bitm=
ap UAF ---
commit f0da60fcfbc2742e91e414951699e4a59d581559
Author: Yu Kuai <yukuai@fygo.io>

md/md-llbitmap: prevent create failure bitmap UAF

llbitmap_create() publishes mddev->bitmap before reading the bitmap
superblock. If llbitmap_read_sb() fails, the old cleanup dropped
bitmap_info.mutex and freed llbitmap before clearing mddev->bitmap. This
commit clears mddev->bitmap while still holding the mutex.

> diff --git a/drivers/md/md-llbitmap.c b/drivers/md/md-llbitmap.c
> index 948bf64c5ad24..af80a630bd21a 100644
> --- a/drivers/md/md-llbitmap.c
> +++ b/drivers/md/md-llbitmap.c
> @@ -1126,10 +1126,11 @@ static int llbitmap_create(struct mddev *mddev)
>  	mutex_lock(&mddev->bitmap_info.mutex);
>  	mddev->bitmap =3D llbitmap;
>  	ret =3D llbitmap_read_sb(llbitmap);

[Severity: Medium]
This is a pre-existing issue, but is the cleanup sequence in
llbitmap_read_sb() correct when returning an error?

When llbitmap_read_sb() encounters an error, it jumps to out_put_page
and calls __free_page() before kunmap_local():

drivers/md/md-llbitmap.c:llbitmap_read_sb() {
    ...
out_put_page:
    __free_page(sb_page);
    kunmap_local(sb);
    return ret;
}

Does calling __free_page() before kunmap_local() violate the kmap_local API
contract and potentially cause memory debugging warnings?

> +	if (ret)
> +		mddev->bitmap =3D NULL;
>  	mutex_unlock(&mddev->bitmap_info.mutex);

[Severity: High]
This is a pre-existing issue, but does publishing and clearing mddev->bitmap
here still leave a race with lockless deferred IO?

If mddev->bitmap is set to NULL on failure, but mddev->bitmap_ops is still
active, a concurrent unplug callback executing locklessly might trigger a
NULL pointer dereference.

For example, if a user task unplugs and calls raid1_prepare_flush_writes(),
it can execute mddev->bitmap_ops->unplug() locklessly. llbitmap_unplug()
unconditionally reads mddev->bitmap and passes it to llbitmap_dirty():

drivers/md/md-llbitmap.c:llbitmap_unplug() {
    struct llbitmap *llbitmap =3D mddev->bitmap;
    if (!llbitmap_dirty(llbitmap))
        return;
    ...
}

Can llbitmap_unplug() crash if it observes the NULL bitmap?

Also, if llbitmap_unplug() runs during llbitmap_cache_pages(), can it
observe llbitmap->nr_pages being set before the llbitmap->pctl[i]
pointers are initialized, leading to a NULL dereference in
llbitmap_dirty() when it accesses llbitmap->pctl[i]->flags?

drivers/md/md-llbitmap.c:llbitmap_cache_pages() {
    ...
    llbitmap->nr_pages =3D nr_pages;
    for (i =3D 0; i < nr_pages; i++, pctl =3D (void *)pctl + size) {
        struct page *page =3D llbitmap_read_page(llbitmap, i);
        llbitmap->pctl[i] =3D pctl;
        ...
}

>  	if (ret) {
>  		kfree(llbitmap);
> -		mddev->bitmap =3D NULL;
>  	}
> =20
>  	return ret;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260802195038.1642=
72-1-yukuai@kernel.org?part=3D8
