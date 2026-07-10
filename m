Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E90A3B2AA
	for <linux-raid@vger.kernel.org>; Fri, 10 Jul 2026 13:34:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783690495; cv=none; b=huFvgq8yOxZSHX7SH1lDAhBvDo/YGfe9JVTmdBqM7vcgQAzlketwzgef/NS02tcmLX0XuBMcojdW7qbzLm4+RIsJ4MgMkbZnq0eX62gCaf942VNVc8X9ErHttYYn5kjWVBRJXRuAXLLtJki0tsnz2AwiH/r5/m0MqDXl2CXPKP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783690495; c=relaxed/simple;
	bh=3EJKsZJS092o6OfwLIVqNhcW7++sA05FjApEN1wsQhM=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=sjKyh+RmCiOnTIfXrR7jm/J4B/ps6k7AcAwY9XSxtG7SR5TsYNZeauUfO6xbuc4g48R5sCzA9/fEu6Tmk2/xhWWYa0eMJW2bTQ49BgTNirWJozVvG6iNxs8ofNDctkghIRbYDtv5NlzUvVMSaUSZS5iUYUcmytrpmtU1Y3YpJqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=D2isC7Vh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="D2isC7Vh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E022F1F000E9;
	Fri, 10 Jul 2026 13:34:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783690494;
	bh=uy4vjuT/RP5KktAJ+MPQOn11NxrHCNFwjIo3qojRdu8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=D2isC7VhiOO4tJK8/pAxKOsqQ3Es3Z222TIBvNAK/A7fA/6/Ijdj7zxeCxGd+u9OI
	 bK2Rm3dX6cduSVhMTC3gElCK3i5L4UGwDO5TuWJce4hhJ1gN1LRvASZimf/+hXnOdI
	 /ebwMtn7wy9yexXzbLuHJgbvxl4YMB65C1MQ0z25WAJLhZgBp2/ClD1v7EMPg122rT
	 ka4nxmOhUylqwlwbtsMth/x2fOp+JTYyDFLP+apMuRQzZfCNe6O0Ag202zGNkqpL88
	 rDV3dz/d4kWwPPLcpGzEQmxshY2sCPjQDw5YQkUyvCELSCZ4/YybiWP1p44L7ojxA1
	 6QMGDV4YpbF8Q==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 3/6] md/raid5: scale the stripe_cache_size limit with
 system memory
Reply-To: sashiko-reviews@lists.linux.dev
To: "Hiroshi Nishida" <nishidafmly@gmail.com>
Cc: linux-raid@vger.kernel.org, yukuai@fygo.io
In-Reply-To: <20260710132346.7295-4-nishidafmly@gmail.com>
References: <20260710132346.7295-1-nishidafmly@gmail.com>
 <20260710132346.7295-4-nishidafmly@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 10 Jul 2026 13:34:53 +0000
Message-Id: <20260710133453.E022F1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] Integer overflow in `raid5_max_cache_size` on 32-bit platforms w=
ith 4GB+ RAM.
--

--- Patch [3]: [PATCH 3/6] md/raid5: scale the stripe_cache_size limit with=
 system memory ---
commit 9086a4a6d9e318381885104d84e3f0ec9bbeec13
Author: Hiroshi Nishida <nishidafmly@gmail.com>

md/raid5: scale the stripe_cache_size limit with system memory

This commit derives the upper bound for the per-array stripe_cache_size from
system memory rather than a fixed limit. It scales the maximum cache size to
1/8 of RAM, allowing large-memory hosts to grow the cache while preventing
small systems from exceeding total RAM.

> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 7f72981121fd5..e41d3fc92dd05 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c

[ ... ]

> @@ -6922,13 +6928,42 @@ raid5_show_stripe_cache_size(struct mddev *mddev,=
 char *page)
>  	return ret;
>  }
> =20
> +/*
> + * Upper bound that the per-array stripe_cache_size may be raised to.  T=
he
> + * stripe cache costs roughly max_nr_stripes * (sizeof(stripe_head) +
> + * pool_size * (sizeof(bio) + PAGE_SIZE)).  The limit was historically a=
 fixed
> + * 32768 stripes, which both under-serves large-memory hosts backing wide
> + * arrays and, on a small box, still permits a cache larger than RAM.  D=
erive
> + * it from memory instead -- at most 1/8 of RAM -- but never below the
> + * historical 32768, so the limit only ever grows relative to today.  A
> + * non-zero stripe_cache_size_max module parameter overrides the heurist=
ic.
> + */
> +#define RAID5_CACHE_SIZE_FLOOR		32768
> +#define RAID5_CACHE_SIZE_RAM_SHIFT	3	/* cap the cache at 1/8 of RAM */
> +
> +static unsigned long raid5_max_cache_size(struct r5conf *conf)
> +{
> +	unsigned long per_stripe, limit;
> +
> +	if (stripe_cache_size_max) {
> +		limit =3D stripe_cache_size_max;
> +	} else {
> +		per_stripe =3D sizeof(struct stripe_head) +
> +			     conf->pool_size * (sizeof(struct bio) + PAGE_SIZE);
> +		limit =3D ((totalram_pages() << PAGE_SHIFT) >>
> +			 RAID5_CACHE_SIZE_RAM_SHIFT) / per_stripe;

[Severity: Medium]
Will this calculation overflow on 32-bit platforms with 4GB or more of RAM?

Since totalram_pages() returns an unsigned long, on a 32-bit system with hi=
gh
memory (e.g., using PAE), totalram_pages() can be 1,048,576 or more.
Left-shifting this by PAGE_SHIFT (12) will overflow the 32-bit integer,
yielding a severely truncated value or 0.

This seems like it would cause the dynamic limit to inappropriately clamp to
the RAID5_CACHE_SIZE_FLOOR on such systems, breaking the intended memory-ba=
sed
scaling.

> +		limit =3D max_t(unsigned long, limit, RAID5_CACHE_SIZE_FLOOR);
> +	}
> +	return min_t(unsigned long, limit, INT_MAX);
> +}
> +

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260710132346.7295=
-1-nishidafmly@gmail.com?part=3D3
