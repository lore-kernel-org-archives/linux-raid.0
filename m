Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB250341ABB
	for <linux-raid@vger.kernel.org>; Mon, 14 Sep 2026 04:29:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789360200; cv=none; b=L5VwgcuY20WW8QChFznWGebiX7YgxXpEC8Y5Nu7AiHxuGf3RXb4Fm5acadRqCoa6N3/QJ6FPvKvWv97bn8yU0s9I+hiwD2297E/PZD6MsRsq1wfY5vqiGMv0dMCX3gTh4wTE5NFNe/NUMhsRdO5oGDSFWnOgGg0t5AN5sRSCbk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789360200; c=relaxed/simple;
	bh=JpRdPCCqdqBIQy5g+OE8ls2w4OMxk/N/h2ERzmSLrEM=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=ZKgHNHhs8Pcd4F5gGhoaUdm9Kz7yx966o9lSFSwGdfQ8iiddgE0sZJtxyF2QVPQm1JdXHjGLke9FMBzGLNUx2SjSC2b4gwioX02Ilfqf5E27wj/DWrboLA2cTc4gJKzDFwGZC99rzoeD+u8x2hAh1gdyxHQWv8gHe/IT+tcV3Zw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LcMDoK3K; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LcMDoK3K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 151B71F000FF;
	Mon, 14 Sep 2026 04:29:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789360199;
	bh=eGS9NpAkmYyuz3wV3HznQ+e5IFKuhYfrkyRfX52LI8w=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=LcMDoK3KfF6JPfkAKpkNGDUo/hHsRLaMO8GgzVH4fxNqR1Z4Vvoub+tE8eWfkUg+1
	 GBNUbrgSTV4Q359k/SKSJxK1ZWT7viOSUC5ylkgsdv1CZobm6tBGpVHyoGcUZHZLNx
	 Cu39LzcZ76duyLw1TeRMGyHcERX65IxdHLugowbF5U+1uZSlJ1JD3JSVJuggtCgFOc
	 HM7bTeBRZOCuwcy9k+GTWC5BKFcB+NTxv3Q2Wj6q2mYe4xMqlo1Xm7vH4BFn7i6lcs
	 B/C668zTeDBl4FIFt4DMj00ouG9gesjNexjss4nkXSx7uPoSBSlt5K1xGGrKYHPfcy
	 mOaDNXEA83r7A==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 3/3] md: Remove the last use of page_buffers()
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TWF0dGhldyBXaWxjb3ggKE9yYWNsZSk=?= <willy@infradead.org>
Cc: yukuai@fygo.io, linux-raid@vger.kernel.org
In-Reply-To: <20260914041830.2072626-3-willy@infradead.org>
References: <20260913-remove-pg_private-v4-0-848550f7574e@nvidia.com>
 <20260914041830.2072626-3-willy@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 14 Sep 2026 04:29:58 +0000
Message-Id: <20260914042959.151B71F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Memory leak of bitmap pages in `free_buffers()` when unmapping an =
internal block-device bitmap or on error paths for file-backed bitmaps.
--

commit 5c27b3beb1da589c8d8b3b4113d43873e56ed7da
Author: Matthew Wilcox (Oracle) <willy@infradead.org>

md: Remove the last use of page_buffers()

This commit converts the page to a folio in write_file_page() and uses
folio_buffers() instead of page_buffers(). This change prepares the
md-bitmap codebase for a later conversion from pages to folios.

> diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
> index 7b42db87d536d..c2528220c406d 100644
> --- a/drivers/md/md-bitmap.c
> +++ b/drivers/md/md-bitmap.c
> @@ -516,7 +516,8 @@ static void end_bitmap_write(struct bio *bio)
> =20
>  static void write_file_page(struct bitmap *bitmap, struct page *page, in=
t wait)
>  {
> -	struct buffer_head *bh =3D page_buffers(page);
> +	struct folio *folio =3D page_folio(page);
> +	struct buffer_head *bh =3D folio_buffers(folio);

[Severity: High]
This is a pre-existing issue, but since this code is being converted to use
folios, does free_buffers() leak the folio when unmapping an internal
block-device bitmap or on error paths for file-backed bitmaps?

In md_bitmap_storage_alloc(), memory for store->filemap is allocated using
alloc_page(), which sets the baseline refcount to 1. For internal
block-device bitmaps, the pages are read using read_sb_page() which does
not attach buffer_head structures or set the folio private flag.

During array teardown, md_bitmap_file_unmap() iterates over store->filemap
and calls free_buffers():

static void free_buffers(struct page *page)
{
	struct folio *folio =3D page_folio(page);
	struct buffer_head *bh =3D folio_detach_private(folio);

	if (!bh)
		return;
...
	folio_put(folio);
}

Since folio_detach_private() returns NULL here, the early return skips the
final folio_put(). Over time, this could accumulate to megabytes of leaked
memory if an administrator repeatedly starts and stops md arrays with
internal bitmaps.

Could this early return be updated to ensure the folio reference is properly
dropped even when there are no buffers attached?

> =20
>  	while (bh && bh->b_blocknr) {
>  		atomic_inc(&bitmap->pending_writes);

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260913-remove-pg_=
private-v4-0-848550f7574e@nvidia.com?part=3D3
