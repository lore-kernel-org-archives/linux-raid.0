Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89D8641B36C
	for <linux-raid@vger.kernel.org>; Tue, 28 Jul 2026 09:06:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785229574; cv=none; b=kvHTzGA2WcPfY8QgUGPWdNhKigtL3dsv2Lj8Nl4cpTwi8BH1C5+wkfQRAK6moLIQkP7LF/zehsIyiL/Spfg+w9ZKHXG9jS783pRc4GIMTbnFNOT7vmIKXz4HHv5ZxJwZxeub3SXyvYOAn1+bLIjG/zbaOfhBHxntPZXEZE18+iE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785229574; c=relaxed/simple;
	bh=WxwN3K9h9oJPAG6vWRbvVqVMzv0ZQiTuIVHjdKEP034=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=CszyyoOWHEN+9mTpPvnwENIvUru74pdzgVCXCyYHIfPby4/qYMuzcDT6ocPOYOoCRQKH7+kWkfRbIWfVjdKcXOR7DBe7aIqDt8uqxMfqPMdTE7Gx0rR6Ix7GcFVpElBYGowAHbvoGoRYTduLeF+ij06WNJYxsOaVokVHlLuMGd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f6hXIk5M; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f6hXIk5M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11BCD1F000E9;
	Tue, 28 Jul 2026 09:06:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785229573;
	bh=9mzaXtHamLVscLJYWczKE5nlZBuxOIL1seGFzdCczcE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=f6hXIk5MKQoPNjPL++LkGD64mzsZ5ar5UDDENptyP+RDyMqK3K5vREdkYqMD6q6Jb
	 jyJIH08Up+WUgapTcQDxlvzi4ISIapBzzkSHYj+p17AW7NWKSiMsIOTdznQzAAOvQn
	 8lymie1ad3ayIAJQoA2X49WK8cwGkbDOJZtkebkUKQbRNNz27k3jCsJkRJxAIbz4AN
	 onU7GGveHf9l4FMiEZUwzukW3JXXzrwMIyyI4NZ90VyULAfOIBeF3qRwq25bEeK8rd
	 uEwFsWkPtxA2U4k6/ewewdznYF/ARupMEkrKjYAKOgYfeDWEQ4oGJ4B30b1t0nMWj9
	 TQozzlA8k2+9w==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 06/21] md/md-llbitmap: allocate page controls
 independently
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yu Kuai" <yukuai@kernel.org>
Cc: linux-raid@vger.kernel.org, yukuai@fygo.io
In-Reply-To: <db5200f0479562a1ec16ff65eb5e0c69aae21fbc.1785206690.git.yukuai@fygo.io>
References: <cover.1785206690.git.yukuai@fygo.io>
 <db5200f0479562a1ec16ff65eb5e0c69aae21fbc.1785206690.git.yukuai@fygo.io>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 28 Jul 2026 09:06:12 +0000
Message-Id: <20260728090613.11BCD1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] Out-of-bounds array access in `llbitmap_write()` during bitmap res=
ize due to omitted `BITMAP_DATA_OFFSET` in `llbitmap_reserved_pages()`.
--

--- Patch [6]: [PATCH v3 06/21] md/md-llbitmap: allocate page controls inde=
pendently ---
commit f9c192fc9c795037298b0412c1ab2a50e3c88637
Author: Yu Kuai <yukuai@fygo.io>

md/md-llbitmap: allocate page controls independently

This commit modifies the allocation of llbitmap page controls to
allocate and free them individually. It also updates llbitmap_read_page()
to return a zeroed page when the index is beyond the current size,
preparing the code for in-place growth.

> diff --git a/drivers/md/md-llbitmap.c b/drivers/md/md-llbitmap.c
> index e3500a1a52c07..4c3fc4b35aff0 100644
> --- a/drivers/md/md-llbitmap.c
> +++ b/drivers/md/md-llbitmap.c

[ ... ]

> +static unsigned int llbitmap_reserved_pages(struct llbitmap *llbitmap)
> +{
> +	return DIV_ROUND_UP(llbitmap->mddev->bitmap_info.space << SECTOR_SHIFT,
> +			    PAGE_SIZE);
> +}

[Severity: High]
Does this calculation underestimate the maximum number of pages needed
for in-place growth by omitting BITMAP_DATA_OFFSET?

If an array is configured with a small initial capacity and a bitmap space
that is a multiple of PAGE_SIZE, llbitmap_alloc_pages() might allocate
the pctl array with too few pages because this function omits the offset.

If the array is later resized up to the maximum capacity allowed by the spa=
ce,
would this cause an out-of-bounds access in llbitmap_write()?

llbitmap_write() calculates the page index as:

    pos +=3D BITMAP_DATA_OFFSET;
    idx =3D pos >> PAGE_SHIFT;

    llbitmap->pctl[idx]->state[bit] =3D state;

If pos pushes idx beyond the under-allocated nr_pages, it looks like this
will result in an out-of-bounds array access.

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1785206690.gi=
t.yukuai@fygo.io?part=3D6
