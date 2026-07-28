Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13911412C03
	for <linux-raid@vger.kernel.org>; Tue, 28 Jul 2026 09:12:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785229958; cv=none; b=db9qACH4qMXAfFe37rZ7lBm1LhcFTGJ13/ibiuIBl1SGpQI5TvHHxrWETSqcyMsaAP5HgqkqTfhz6B56Tun/vLYOu/yPocoLUpdj3m+SNvzqT5EM6Pl1E5bwQxr/kTj/rNMs+5S/dIOVYpD+K3qx6jGiW2f85pNwVz/jcfM/MwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785229958; c=relaxed/simple;
	bh=CzTGbPrHTkgR8T8oOxi0OIc2Rgghw/x7cquHUXGTMTc=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=HIsEYnc7NxnIMOlKWODEi3ArEBBd7uHL1+uVEsg37o0q/CRcP5RegnssR1IhXjy+zc7LWowqwpjiGIyEl7iA/7Nhplm1BFLDVdB1ud2bw+SqpztUKA57UEdRF09rwN5JpZK/l47ZYRUma9dS8iIfJGR4sSzYuCJ7J2j6wd8uPz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TjDY/0v3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TjDY/0v3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38A711F000E9;
	Tue, 28 Jul 2026 09:12:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785229956;
	bh=9IfPo4WJ/3wGVf4/zhD97uk7bNBaPP7asJ6bQiL4P2s=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=TjDY/0v3yYpUFqaFaQpHnly4p4R41mTxtl+1T8+F7r8mMCSCb/Dpfr4WfT57os7M+
	 +es/e71TLaWxZHvL2yxgC1Slmpkegd3JqUYbx/VnVrskPAaBSEB9KpsB9UsQATZ6D0
	 g1AJDsohHLkbcG+IGrKgT3I4EBVLLEyVvTzqDtqc8+9OyXDVAKIgE+DYznQ4qLBO7P
	 N5dbT3r5PIdV6d1Ivd1VArRu7ePdV4D37gFDpjfs8pqJpFTKU2Q7u6y6ErEFbFbq98
	 cWss9zkvHabKWjf8Ep4nD6lthXYyQAA1zZAmQv7rok1sBLVArZtDYvdQbs3a1PXnaK
	 DNS/ciR0BemGw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 08/21] md/md-llbitmap: track target reshape geometry
 fields
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yu Kuai" <yukuai@kernel.org>
Cc: yukuai@fygo.io, linux-raid@vger.kernel.org
In-Reply-To: <296e44a8317cd280dbb9c13dadd91b026c4dc561.1785206690.git.yukuai@fygo.io>
References: <cover.1785206690.git.yukuai@fygo.io>
 <296e44a8317cd280dbb9c13dadd91b026c4dc561.1785206690.git.yukuai@fygo.io>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 28 Jul 2026 09:12:35 +0000
Message-Id: <20260728091236.38A711F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [Critical] Mismatch between bitmap memory allocation (scaled by the new d=
oubled chunksize) and IO indexing (which continues to use the old smaller c=
hunkshift), leading to an out-of-bounds read/write on the `llbitmap->pctl` =
array.
- [High] The newly added reshape geometry tracking fields (reshape_sync_siz=
e, reshape_chunksize, reshape_chunks) are written to but never applied, cau=
sing the bitmap to permanently use the old geometry after an array reshape =
completes.
--

--- Patch [8]: [PATCH v3 08/21] md/md-llbitmap: track target reshape geomet=
ry fields ---
commit 63e12bf7c87e70924898a94a3939282826b19c8e
Author: Yu Kuai <yukuai@fygo.io>

md/md-llbitmap: track target reshape geometry fields

This commit adds tracking for target reshape geometry in the llbitmap modul=
e.
It adds the reshape geometry fields to the llbitmap struct and introduces a
refresh helper. It also updates the load and resize paths to keep the target
geometry in sync.

> diff --git a/drivers/md/md-llbitmap.c b/drivers/md/md-llbitmap.c
> index 1ab9b1689fd80..cdced2126e975 100644
> --- a/drivers/md/md-llbitmap.c
> +++ b/drivers/md/md-llbitmap.c

[ ... ]

> @@ -430,6 +433,39 @@ static void llbitmap_calculate_chunks(struct mddev *=
mddev, sector_t blocks,
>  	}
>  }
> =20
> +static bool llbitmap_reshaping(struct llbitmap *llbitmap)
> +{
> +	return llbitmap->mddev->reshape_position !=3D MaxSector;
> +}
> +
> +static sector_t llbitmap_personality_sync_size(struct llbitmap *llbitmap,
> +					       bool previous)
> +{
> +	struct mddev *mddev =3D llbitmap->mddev;
> +
> +	if (!llbitmap_reshaping(llbitmap) || !mddev->private || !mddev->pers ||
> +	    !mddev->pers->bitmap_sync_size)
> +		return llbitmap->sync_size;
> +	return mddev->pers->bitmap_sync_size(mddev, previous);
> +}
> +
> +static void llbitmap_refresh_reshape(struct llbitmap *llbitmap)
> +{
> +	unsigned long old_chunks =3D DIV_ROUND_UP_SECTOR_T(llbitmap->sync_size,
> +						 llbitmap->chunksize);
> +	sector_t blocks =3D llbitmap_personality_sync_size(llbitmap, false);
> +	unsigned long chunksize =3D llbitmap->chunksize;
> +	unsigned long chunks =3D DIV_ROUND_UP_SECTOR_T(blocks, chunksize);
> +
> +	llbitmap->reshape_sync_size =3D blocks;
> +	llbitmap->reshape_chunksize =3D chunksize;
> +	llbitmap->reshape_chunks =3D chunks;
> +	llbitmap_calculate_chunks(llbitmap->mddev, blocks,
> +				  &llbitmap->reshape_chunksize,
> +				  &llbitmap->reshape_chunks);
> +	llbitmap->chunks =3D max(old_chunks, llbitmap->reshape_chunks);

[Severity: Critical]
Can this mismatch between allocation and IO indexing cause an out-of-bounds
access on the pctl array?

When an array is grown significantly, chunksize doubles, and the memory
allocation here scales based on the new larger chunksize. However, IO
indexing in llbitmap_start_write() computes the start using the older,
smaller chunkshift:

drivers/md/md-llbitmap.c:llbitmap_start_write() {
    ...
    unsigned long start =3D offset >> llbitmap->chunkshift;
    unsigned long end =3D (offset + sectors - 1) >> llbitmap->chunkshift;
    int page_start =3D (start + BITMAP_DATA_OFFSET) >> PAGE_SHIFT;
    int page_end =3D (end + BITMAP_DATA_OFFSET) >> PAGE_SHIFT;

    while (page_start <=3D page_end) {
        llbitmap_raise_barrier(llbitmap, page_start);
        page_start++;
    }
}

If writes hit the newly expanded region, won't page_start vastly exceed
llbitmap->nr_pages and crash before any bounds-checking can occur?

> +}

[ ... ]

> @@ -1284,6 +1322,9 @@ static int llbitmap_resize(struct mddev *mddev, sec=
tor_t blocks, int chunksize)
>  		goto out;
> =20
>  	if (reshape) {
> +		llbitmap->reshape_sync_size =3D blocks;
> +		llbitmap->reshape_chunksize =3D bitmap_chunksize;
> +		llbitmap->reshape_chunks =3D chunks;

[Severity: High]
Does this code ever apply these new geometry tracking fields to the active
state after a reshape completes?

The resize path populates reshape_sync_size, reshape_chunksize, and
reshape_chunks, but there doesn't appear to be any transition logic or
a reshape finish hook to apply them to the active geometry.=20

Will array writes to newly grown regions fall outside the bitmap's tracked
chunks and be silently ignored, resulting in a loss of redundancy?

>  		llbitmap->chunks =3D max(old_chunks, chunks);
>  	} else {
>  		if (blocks < old_blocks && chunks < old_chunks)

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1785206690.gi=
t.yukuai@fygo.io?part=3D8
