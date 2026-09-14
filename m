Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18FC736197F
	for <linux-raid@vger.kernel.org>; Mon, 14 Sep 2026 04:27:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789360069; cv=none; b=BmwCzl6Rh0cF3PfYvXei6JuiZEoeMxG2Xtu1VJD26fLxcBFQnSnrDtals9PatZ4w1PcuoMmukclUZhN+41JO/HRBXhgVNM+8PHs6oj83IzXg6gmfJbmx1XsR6cX5+2oqZMHaLe8OGCnrlWREWIv+ULLP5co9MLjOxTAg6d8IYzE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789360069; c=relaxed/simple;
	bh=lhEPcF9b8emZWkw2EnSI+8KaaTd2KRfPQjSlWjmrPP8=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=toV+Dn5lW/KYmAcS4McgpK9i0kTFdS5qSwvo3KW8pWmDcQ2/uYRIOgU38WmVZC9AOIZgq3YDhcCJPwYSnvV2pEzkLHc3OVOMso8ncxcQBRTsAbWjgZT9/YWmT7fUW1lAJzgljDuSZuwhrHbo1RU49HV5NYyCpezTO0DRZNs2exU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AGkC5TkR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AGkC5TkR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 712831F000FF;
	Mon, 14 Sep 2026 04:27:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789360067;
	bh=NPLC0jCb6UjAXkfgTl8axVcjPdTxPiXmsZvOCvpchzw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=AGkC5TkRlKAAUhPukGKTAPeMgqMj1iu2q8Tl699drPTOpHQj0/laNmWxRernHPXJU
	 vhnyWZWxOskgLcG89pXftQs3nSWYzWa8IBOu/Ek055z55DtWg++5sJVDIASa4e3Mym
	 iHR+HDMmLh2toZk2M0dKiRAVKBbhz78gEW8V12+DF/fKDBTDChsfQ6HTCJ+6h8qMSh
	 ZwH5IZz4ezHRiI6cMTSlKdknMwE1fjPji1ZHi3cQzGjcrTeoainaQNY26gEmWHerr7
	 P1Dlp4xK3KB63FI/KDdqlF+68Kovq5NOomjYoSQGq7hulXusDHoFCGqvAIR+S2FI7G
	 srjXrXs64ZTHg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 1/3] md: Use folio_alloc_buffers()
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TWF0dGhldyBXaWxjb3ggKE9yYWNsZSk=?= <willy@infradead.org>
Cc: yukuai@fygo.io, linux-raid@vger.kernel.org
In-Reply-To: <20260914041830.2072626-1-willy@infradead.org>
References: <20260913-remove-pg_private-v4-0-848550f7574e@nvidia.com>
 <20260914041830.2072626-1-willy@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 14 Sep 2026 04:27:46 +0000
Message-Id: <20260914042747.712831F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Severe memory leak of bitmap pages in free_buffers() when PagePriv=
ate is not set.
--

commit 9822ba9b718b51ce47732b5412e326f063b30c60
Author: Matthew Wilcox (Oracle) <willy@infradead.org>

md: Use folio_alloc_buffers()

This commit removes the last user of alloc_page_buffers(), replacing it
with folio_alloc_buffers() to prevent new callers from existing.

> diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
> index b8325cb09a371..5f1637f974c15 100644
> --- a/drivers/md/md-bitmap.c
> +++ b/drivers/md/md-bitmap.c
> @@ -560,6 +560,7 @@ static int read_file_page(struct file *file, unsigned=
 long index,
>  {
>  	int ret =3D 0;
>  	struct inode *inode =3D file_inode(file);
> +	struct folio *folio =3D page_folio(page);
>  	struct buffer_head *bh;
>  	sector_t block, blk_cur;
>  	unsigned long blocksize =3D i_blocksize(inode);
> @@ -567,12 +568,12 @@ static int read_file_page(struct file *file, unsign=
ed long index,
>  	pr_debug("read bitmap file (%dB @ %llu)\n", (int)PAGE_SIZE,
>  		 (unsigned long long)index << PAGE_SHIFT);
> =20
> -	bh =3D alloc_page_buffers(page, blocksize);
> +	bh =3D folio_alloc_buffers(folio, blocksize, GFP_NOFS | __GFP_ACCOUNT);
>  	if (!bh) {
>  		ret =3D -ENOMEM;
>  		goto out;
>  	}
> -	attach_page_private(page, bh);
> +	folio_attach_private(folio, bh);

[Severity: High]
This isn't a bug introduced by this patch, but it is a severe pre-existing
resource leak in the cleanup path for these pages.

md_bitmap_storage_alloc() allocates pages via alloc_page() for
store->filemap. On teardown, md_bitmap_file_unmap() iterates over these
pages and calls free_buffers() to clean them up.

For internal bitmaps, read_sb_page() uses raw bios and never attaches
buffer heads, so the pages never have the PagePrivate flag set.=20
When this happens, free_buffers() returns early:

static void free_buffers(struct page *page)
{
	struct buffer_head *bh;

	if (!PagePrivate(page))
		return;
...
	detach_page_private(page);
	put_page(page);
}

Does this early return mistakenly skip the final put_page() call,
permanently leaking the page when no buffer heads are attached?

This leaks memory pages allocated for the MD bitmap every time an array
with an internal bitmap is stopped, potentially leading to memory
exhaustion.

I verified that the follow-up patches in this series (which migrate this
function to the folio API) faithfully reproduce the exact same leak by
returning early when bh is NULL before calling folio_put(folio).

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260913-remove-pg_=
private-v4-0-848550f7574e@nvidia.com?part=3D1
