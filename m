Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BF0C374E7F
	for <linux-raid@vger.kernel.org>; Wed, 24 Jun 2026 07:01:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782284518; cv=none; b=nyDpwTP/jTMp1SIHavGYDET9HLgd8BzI8v4Wws33CxVbi00N1sVPhrS9Zc8XeNJp9H8sui3Y3pGjmWCud/94SEE4U6gVTsHJRWj/xzjPe7r6yAPhCtxrawrBwyTDPNTXjJzYU9zyHsTFe7XhkE7fP6m8Cv9EVccc65wO1/Wl/OY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782284518; c=relaxed/simple;
	bh=aFmS/Y6dywtqaqvMLlAqgFfxmMdF/YRXjB9QzT5e0Uc=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=ec/BIPoI5A7OQ9eN/32AdacKX09nOT44z9FP1PuLqE50idXgZCTf4X8iv6KN72MWWGSnlo0mvSfTfFOM3YE+H3lQt7y9q6J1F24HXCGCYa+MNqBL9nQac0e0R9WdHVg1a/6in+XxxBER1UTsV4M8+nu1uTxitCqloAQfXra/8mE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=W1mllKTb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="W1mllKTb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9013D1F000E9;
	Wed, 24 Jun 2026 07:01:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782284516;
	bh=relsRed38+U1EKK34lCBmRxx7O8lgBiwlUAd7JyUChI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=W1mllKTbCkINaAR+FiT2dKuSXR03aK6a+7toTwNO7DIStN5NgKjVIOfCAmFClgjc0
	 gBga7x3CcKyEKIBycI3sUqa1gBEh4vOZ3j/gl3bjqmIPyrnQdLnCr+KyZe3YXMzCKD
	 uuMrYfhSRxUXlCColTAjWUte2nlpWfWxuDTQmHTaHzLpMpRJDTN04U7VQUEEkeAoPT
	 C7vHC2soev7KNFVLAKRs5LCVLg6QWiD+Ni2i8iunrlUaxBqlwEUFtrltFuEoCKHQCq
	 SvLRNWavaBL9CXJOjz4LMjZFUqF+CBEpPoJ5hm6KWXI3ag6ye6mCEuXtBV3PS8iX6s
	 eVGYE6iVeQMYg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 03/20] md: add helper to split bios at reshape offset
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yu Kuai" <yukuai@kernel.org>
Cc: linux-raid@vger.kernel.org, yukuai@fygo.io
In-Reply-To: <20e701b8355e1efd0d7cff3265189abf2424400b.1782282042.git.yukuai@kernel.org>
References: <20260605091527.2463539-1-yukuai@kernel.org>
 <cover.1782282042.git.yukuai@kernel.org>
 <20e701b8355e1efd0d7cff3265189abf2424400b.1782282042.git.yukuai@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 24 Jun 2026 07:01:56 +0000
Message-Id: <20260624070156.9013D1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Critical] Lockless read of 64-bit `mddev->reshape_position` risks torn r=
eads on 32-bit architectures and TOCTOU races between bio splitting and bit=
map accounting, leading to silent data corruption.
--

commit 4912480eb23a69a6634d083e53f12568752eafb0
Author: Yu Kuai <yukuai@fygo.io>

md: add helper to split bios at reshape offset

This commit adds the mddev_bio_split_at_reshape_offset() helper function.
It allows MD personalities to share the reshape-offset bio splitting logic
instead of open-coding it in multiple places.

> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 0b59c676f7c03..c18a7f3c27e65 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
[ ... ]
> @@ -9361,6 +9361,45 @@ void md_submit_discard_bio(struct mddev *mddev, st=
ruct md_rdev *rdev,
>  }
>  EXPORT_SYMBOL_GPL(md_submit_discard_bio);
> =20
> +struct bio *mddev_bio_split_at_reshape_offset(struct mddev *mddev,
> +					      struct bio *bio,
> +					      unsigned int *max_sectors,
> +					      struct bio_set *bs)
> +{
> +	sector_t boundary;
> +	sector_t start;
> +	sector_t end;
> +	unsigned int split_sectors;
> +
> +	split_sectors =3D bio_sectors(bio);
> +	if (max_sectors && *max_sectors && *max_sectors < split_sectors)
> +		split_sectors =3D *max_sectors;
> +
> +	if (!test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery))
> +		goto split;
> +
> +	boundary =3D mddev->reshape_position;

[Severity: Critical]
Can this lockless read of mddev->reshape_position cause a torn read on
32-bit architectures since it is a 64-bit value?

Additionally, does reading this without locking introduce a time-of-check to
time-of-use race with bitmap accounting? If mddev->reshape_position
is updated by the reshape thread after this split check, but before bitmap
accounting in llbitmap_map_previous(), an unsplit bio could end up crossing
the new boundary.

This could trigger the WARN_ON_ONCE in llbitmap_map_previous():

    sector_t boundary =3D mddev->reshape_position;

    if (!llbitmap_reshaping(llbitmap))
        return false;

    WARN_ON_ONCE(sectors && offset < boundary && offset + sectors > boundar=
y);

Could this race result in a bio being mis-accounted to the wrong array
geometry, potentially causing data corruption if a crash occurs during a
reshape?

> +	start =3D bio->bi_iter.bi_sector;
> +	end =3D bio_end_sector(bio);
> +	if (start >=3D boundary || end <=3D boundary)
> +		goto split;
> +
> +	if (boundary - start < split_sectors)
> +		split_sectors =3D boundary - start;
> +
> +split:
> +	if (max_sectors)
> +		*max_sectors =3D split_sectors;
> +	if (split_sectors < bio_sectors(bio)) {
> +		bio =3D bio_submit_split_bioset(bio, split_sectors, bs);
> +		if (bio)
> +			bio->bi_opf |=3D REQ_NOMERGE;
> +	}
> +
> +	return bio;
> +}
> +EXPORT_SYMBOL_GPL(mddev_bio_split_at_reshape_offset);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1782282042.gi=
t.yukuai@kernel.org?part=3D3
