Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5433A62809
	for <linux-raid@vger.kernel.org>; Mon, 14 Sep 2026 04:31:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789360291; cv=none; b=DK69sy4G13C+6Y+CXjGcUKur24JO5dofe7A/wafhYJAMtkSINUVMNc0ro7ZKJvedn6i/4Ix9C0gDA9LdkKLn3YmoXX/6ygKw2oUlxyrz6UrsCwn83/ccWzVOvTasqprzsDHDb5z5YohaUJmdkBx96RZ3NDJGhryCbBIq3CW1lK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789360291; c=relaxed/simple;
	bh=QAbW15X0NC7VrSLt0A8Elsz3tjy6zX3xhoFkqlyoBL0=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=M4xQhEP1yJ6HAPlHum+4JnZdjRQbcwhssgRlYVnQi2qgH8YxDJ3vbD2xa6sgf2RBJlX0aq2uqz9EwzXnvSkCJyd5uThSQdx/4djiAKMZ1PNuWUL2JVO9mmaAFFpT74UA0/D67cAieXxyMF5813TYtcVHM4wYvk5dmcXWlk5OpbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bw0iZ57M; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bw0iZ57M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6F8D1F000FF;
	Mon, 14 Sep 2026 04:31:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789360290;
	bh=L1l43vfQG7FIJ6WMH5GJ6U37bSaRz6yhDk1o83+mhXA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=bw0iZ57Mw0nrD8fv1LfViJeTDvW4wdft7H9aAvIX1lXkWrOsRLkZywEbmdFzbsbf/
	 HeGKlCjoZ2tVVvox2+lIIxKVJ+twXJU1xw3RLdEYLx9zMF1ucqSuEjqPxiXk3dxVhO
	 ZHOTK2ALmwU+HpR0t5T1ojGG8aRuxDzkz/mboK3FeQxGwZ4SfWaOGDxMgx3EzWM+XN
	 /Q+5DkA2c631+SYYnby7rI5N4eAm3z9XyxfyOrbhNXhcxfAJqLnvpWiitKlcFK+5ei
	 VuLOtXZhAUMmhyK40Ox/PssECPl3NQXlCJP8wPMh4k4arylqQLQznsFQoA+1bDwF4n
	 uL9EF60IkewOQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 2/3] md: Use folio APIs in free_page()
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TWF0dGhldyBXaWxjb3ggKE9yYWNsZSk=?= <willy@infradead.org>
Cc: yukuai@fygo.io, linux-raid@vger.kernel.org
In-Reply-To: <20260914041830.2072626-2-willy@infradead.org>
References: <20260913-remove-pg_private-v4-0-848550f7574e@nvidia.com>
 <20260914041830.2072626-2-willy@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 14 Sep 2026 04:31:29 +0000
Message-Id: <20260914043129.C6F8D1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Memory leak of internal bitmap pages and uninitialized file bitmap=
 pages during teardown or error handling due to an early return in free_buf=
fers().
--

commit d68f524234e61e6567e52a27e09b9d2546ab54af
Author: Matthew Wilcox (Oracle) <willy@infradead.org>

md: Use folio APIs in free_page()

This commit converts the page to a folio, removing some of the last uses of
a few page APIs and replacing two calls to compound_head() with one.

> diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
> index 5f1637f974c15..7b42db87d536d 100644
> --- a/drivers/md/md-bitmap.c
> +++ b/drivers/md/md-bitmap.c
> @@ -533,19 +533,18 @@ static void write_file_page(struct bitmap *bitmap, =
struct page *page, int wait)
> =20
>  static void free_buffers(struct page *page)
>  {
> -	struct buffer_head *bh;
> +	struct folio *folio =3D page_folio(page);
> +	struct buffer_head *bh =3D folio_detach_private(folio);
> =20
> -	if (!PagePrivate(page))
> +	if (!bh)
>  		return;

[Severity: High]
This is a pre-existing issue, but this early return skips the folio_put()
required to drop the base allocation reference for pages that do not have
buffers attached.

For internal bitmaps, pages are allocated via alloc_page() with a refcount
of 1 in md_bitmap_storage_alloc():

drivers/md/md-bitmap.c:md_bitmap_storage_alloc() {
	...
	store->filemap[pnum] =3D alloc_page(GFP_KERNEL|__GFP_ZERO);
	...
}

During MD array teardown or failure, md_bitmap_file_unmap() calls
free_buffers() on these pages:

drivers/md/md-bitmap.c:md_bitmap_file_unmap() {
	...
	free_buffers(map[pages]);
	...
}

Because internal bitmap pages don't have buffers attached, (!bh) evaluates
to true, triggering the early return and completely bypassing the folio_put=
()
at the end of the function.

This permanently leaks the pages allocated for the internal bitmap's filemap
and superblock.

Does this early return need to be updated so that folio_put() is still
called for folios without buffers?

> -	bh =3D page_buffers(page);
>  	while (bh) {
>  		struct buffer_head *next =3D bh->b_this_page;
>  		free_buffer_head(bh);
>  		bh =3D next;
>  	}
> -	detach_page_private(page);
> -	put_page(page);
> +	folio_put(folio);
>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260913-remove-pg_=
private-v4-0-848550f7574e@nvidia.com?part=3D2
