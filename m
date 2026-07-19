Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7962835E950
	for <linux-raid@vger.kernel.org>; Sun, 19 Jul 2026 15:05:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784473548; cv=none; b=ibGpQUQJsJiTx29v9pDROZAU/tSWgvRkr5MnPqBWkrVFRdqvWNfM66f2sXRK69FARjP/68zICJaxA2Zica0lPqpgMkd/IHxWk8QeUSJIYqBljlVIQejcimosXgUjCs6DoWdK8yH+agS0ef1VIC1rhAVoCXs8/bDAJuQ4ycBbytk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784473548; c=relaxed/simple;
	bh=+eJvQa4zgqslw/OLnQZWXNlFU2fdPdxmYEY7gP3fEBA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=ApQbS95VsxUBpXUSvkpiwu/oOcJ/p8FPDjhgX/rJY1nxnQ2OdeGKLqGbmyyyHcPE/WrXSmfeSqXf/RbUmhZqWn+uUMCTouIWnCXwA+lwjWDeEqTk967FVq8fH33JJ6738Xar8alHIYyTsyEUt0m8btcEiOZiwMgOego20YSgXO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jZVeCkHM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jZVeCkHM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3F801F000E9;
	Sun, 19 Jul 2026 15:05:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784473547;
	bh=fEQ5oQ8S+1+6Y6NjLicrLG9NVIABH34xlVbkh/6VEAM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=jZVeCkHMgcoilaV0wvbBKB+dSQXnMqqow1tIFGNJa2eCZjFSEAD99O3khiDFdBGJH
	 iEbxmQBttAsljCFdu2ZKlTUtvQ4hYIv5XC+BMl8vG7UzOWLjrpxUV0uBcG6CJH+GDh
	 X9UVCv2FyX8N5ygzmXPnbmI0HltYOxiDPYrjPIJ3+lha9n9m1qeqbEaDs0AhWfpnLe
	 9l3lggmTt9e2frQv3w5ODGV4mNOMSoorclgIIyiWR8I96O/3dYQxWxJKUtCiDjhURo
	 JUyxFtbxukEkQcgGgrzVzTlecOw+vPGBorlvK/7CRj/QK4Vd+LLqC/Cxs2STa1KRsu
	 tfJJ1kwsYGLkg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 3/3] md/md-llbitmap: fail resize that needs more bitmap
 pages
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mykola Marzhan" <mykola@meshstor.io>
Cc: yukuai@fygo.io, linux-raid@vger.kernel.org
In-Reply-To: <20260719144227.940444-4-mykola@meshstor.io>
References: <20260719144227.940444-1-mykola@meshstor.io>
 <20260719144227.940444-4-mykola@meshstor.io>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 19 Jul 2026 15:05:46 +0000
Message-Id: <20260719150546.F3F801F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:

New issues:
- [High] The newly added in-memory bounds check is vulnerable to integer ov=
erflow, allowing out-of-bounds heap access.

Pre-existing issues:
- [Critical] llbitmap_resize() and llbitmap_init() allow the on-disk bitmap=
 size to exceed the allocated space, causing out-of-bounds disk writes.
- [High] Array growth leaves newly added space unsynced due to uninitialize=
d bitmap states.
--

--- Patch [3]: [PATCH 3/3] md/md-llbitmap: fail resize that needs more bitm=
ap pages ---
commit 938426872ff1437636e82451faff612783d42c3f
Author: Mykola Marzhan <mykola@meshstor.io>

md/md-llbitmap: fail resize that needs more bitmap pages

llbitmap_resize() only updates chunkshift/chunksize/chunks.  The
page cache backing the bitmap (pctl[] and nr_pages) is sized at
creation and never grown, so a grow whose chunk count crosses into a
never-allocated page leaves the data path indexing past the end of
pctl[].

> diff --git a/drivers/md/md-llbitmap.c b/drivers/md/md-llbitmap.c
> index 5a4e2abaa7577..e8f853e8461d7 100644
> --- a/drivers/md/md-llbitmap.c
> +++ b/drivers/md/md-llbitmap.c
> @@ -1150,6 +1150,32 @@ static int llbitmap_resize(struct mddev *mddev, se=
ctor_t blocks, int chunksize)
>  		chunks =3D DIV_ROUND_UP_SECTOR_T(blocks, chunksize);
>  	}

[Severity: Critical]
This is a pre-existing issue, but does this loop condition allow the on-disk
bitmap size to exceed the allocated space?

The lockless bitmap requires chunks + BITMAP_DATA_OFFSET bytes of space on =
disk,
but the while loop check ignores BITMAP_DATA_OFFSET:

	while (chunks > mddev->bitmap_info.space << SECTOR_SHIFT) {
		chunksize =3D chunksize << 1;
		chunks =3D DIV_ROUND_UP_SECTOR_T(blocks, chunksize);
	}

If chunks is close to the total space, adding BITMAP_DATA_OFFSET before
dividing by PAGE_SIZE can result in an nr_pages value whose total size exce=
eds
the allocated on-disk space. When __llbitmap_flush() writes these pages to
disk, could it overwrite adjacent data like the md superblock or actual arr=
ay
data?

> =20
> +	/*
> +	 * A changed chunksize would require remapping every on-disk bit:
> +	 * each chunk would cover a different sector range.  Refuse rather
> +	 * than corrupt the existing intent record.
> +	 */
> +	if (chunksize !=3D llbitmap->chunksize) {

[ ... ]

> +	/*
> +	 * pctl[]/nr_pages are sized at creation and not grown here; a
> +	 * grow past the last allocated page would index past pctl[].
> +	 */
> +	if (DIV_ROUND_UP(chunks + BITMAP_DATA_OFFSET, PAGE_SIZE) >
> +	    llbitmap->nr_pages) {

[Severity: High]
Can the chunks + BITMAP_DATA_OFFSET calculation overflow on 32-bit systems?

Since chunks is an unsigned long, if a user requests a huge array size
(e.g., > 2.2 TB with 512-byte chunks), chunks can be close to ULONG_MAX. The
addition of BITMAP_DATA_OFFSET would then wrap around to a small number,
causing this bounds check to evaluate to false and bypassing the safeguard.

Could this allow llbitmap_read() to index the pctl[] array far out of bound=
s?

> +		pr_warn("md/llbitmap: %s: cannot grow to %lu chunks: needs %lu bitmap =
pages, only %u allocated; growing the bitmap is not yet supported\n",
> +			mdname(mddev), chunks,
> +			DIV_ROUND_UP(chunks + BITMAP_DATA_OFFSET, PAGE_SIZE),
> +			llbitmap->nr_pages);
> +		return -ENOSPC;
> +	}
> +
>  	llbitmap->chunkshift =3D ffz(~chunksize);
>  	llbitmap->chunksize =3D chunksize;
>  	llbitmap->chunks =3D chunks;

[Severity: High]
This isn't a bug introduced by this patch, but does updating llbitmap->chun=
ks
without initializing the newly exposed chunks leave the added space unsynce=
d?

When an array is grown, the newly added chunks in the page cache default to
BitUnwritten (0) or stale values instead of BitNeedSync. When
llbitmap_start_sync() evaluates them, it will see them as BitNone and return
false.

Does this cause md_do_sync() to skip syncing the newly added sectors entire=
ly,
leading to silent data inconsistency across mirrors?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260719144227.9404=
44-1-mykola@meshstor.io?part=3D3
