Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0E7878F3A
	for <linux-raid@vger.kernel.org>; Wed, 24 Jun 2026 16:16:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782317786; cv=none; b=uLMlstB1qmURIqREJxDGPJihxgzv5qleva74knVUABLTdXsMMcSEDPVVmqnPL2niIFn3CXHe1N8qfRqUyae1oK8Lid57Oiw8QyHP9AnuZWigy9jlXvq2cXT6Gdpwv/DPvCNqksIswa0i81NpKRc3WVLj/8n+li141aZ0Kk8vbog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782317786; c=relaxed/simple;
	bh=WD6wnnYgqCae7WlU6xTM4gUWCCRAQsxGhm6BpN46kIw=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=e18lkArM/ic8VX7mKW8j5in1P2ukT1zZKNyp9PIJe7P3Vj3QzAuEoWaioYF/jd8NrwWoX91nx1WJddSlqcZFGmSsrzeWtfBi5FsMVaUcaOxDwu+be8/UFWCmHnFfNa+Spi1EUuSLCuppNuSdBr2fwLY+prKu3NLUYvRd1P4NLx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=M2QojuzF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="M2QojuzF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12CC81F000E9;
	Wed, 24 Jun 2026 16:16:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782317784;
	bh=jj2MxSe5ifs17h4FzH9Xt74Kdixw9J8MZL0WeMxCSXs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=M2QojuzFjYW+4x/RW0ozCfnD8ysWlyP2MtERPjvLJxer33bXOOS2bkZKw7mbNRiKH
	 swuuPz9A7rMfHsszEp1NYo4MgBnjPaLfA4oYBeAB04so7oZV/d3gfDIhypc5B2dx+t
	 EzSwwH0mAEuCvL+Fh4FD+lkzZmF3H997ySt44blgu1LAtl1HHZSGqa7P1ZfYtH8lwE
	 yv/1oiBpmtU7MwnC0ygHWI3ukhE5DF0roOMTAW0pryHQKrTDeepF83mcGjBmhK8bvG
	 FlZZv3jfMnzV9DF9OlEYoPBB+tvD6Gwt4cgLziQMvSmkMQvKztdWTSR4OWhm8HBok+
	 ieQwlR9tUveeg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 1/8] md: change chunk_sectors and stripe cache counts to
 unsigned int
Reply-To: sashiko-reviews@lists.linux.dev
To: "Hiroshi Nishida" <nishidafmly@gmail.com>
Cc: linux-raid@vger.kernel.org, yukuai@fygo.io
In-Reply-To: <20260624155452.211646-2-nishidafmly@gmail.com>
References: <20260624155452.211646-1-nishidafmly@gmail.com>
 <20260624155452.211646-2-nishidafmly@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 24 Jun 2026 16:16:23 +0000
Message-Id: <20260624161624.12CC81F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:

New issues:
- [Medium] The commit's core justification is false. Changing the types to =
unsigned does not enable compiler right-shift optimizations for variable di=
visions.
- [Low] Unupdated printf-style format specifiers passing unsigned fields to=
 '%d' cause compiler warnings (-Wformat) and break builds configured with -=
Werror.

Pre-existing issues:
- [Critical] The macro `round_down` is incorrectly used with a non-power-of=
-two divisor, causing silent data corruption in bitmap sector calculations.
--

commit 86528a8b22367a5ee16a7cb19a1d56bf58f6aa67
Author: Hiroshi Nishida <nishidafmly@gmail.com>

md: change chunk_sectors and stripe cache counts to unsigned int

This commit changes several structural fields and local variables like
chunk_sectors and max_nr_stripes from signed to unsigned int. The stated
rationale is to prevent negative values and enable right-shift compiler
optimizations for power-of-two division in the hot I/O path.

>     chunk_sectors, new_chunk_sectors, prev_chunk_sectors, max_nr_stripes,
>     and min_nr_stripes are never negative. Using signed int is semantical=
ly
>     wrong and prevents the compiler from optimizing division/modulo by
>     power-of-two chunk sizes to right shifts in the hot I/O path.

[Severity: Medium]
Is this optimization rationale accurate? The hot I/O path uses sector_div(),
which expands to do_div(). The do_div() macro explicitly casts the divisor
to a 32-bit unsigned integer, so the division was already operating on an
unsigned value.

Additionally, because sectors_per_chunk is a runtime variable rather than a
compile-time constant, would the compiler be able to optimize it into a
right shift without a conditional branch?

> diff --git a/drivers/md/md.h b/drivers/md/md.h
> index d8daf0f75cbbe..b9ad26844799d 100644
> --- a/drivers/md/md.h
> +++ b/drivers/md/md.h
[ ... ]
> @@ -437,7 +437,7 @@ struct mddev {
>  	int				external;	/* metadata is
>  							 * managed externally */
>  	char				metadata_type[17]; /* externally set*/
> -	int				chunk_sectors;
> +	unsigned int			chunk_sectors;

[Severity: Low]
Does changing this field to unsigned int cause compiler warnings with
existing format strings?

For example, chunk_size_show() in drivers/md/md.c appears to use %d to
format mddev->chunk_sectors:

chunk_size_show() {
    ...
    return sprintf(page, "%d (%d)\n",
                   mddev->new_chunk_sectors << 9,
                   mddev->chunk_sectors << 9);
}

Will this break builds configured with -Werror?

> diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
> index cb5feae04db27..5cd9d0f36b6e0 100644
> --- a/drivers/md/raid5.h
> +++ b/drivers/md/raid5.h
[ ... ]
> @@ -572,12 +572,12 @@ struct r5conf {
>  	/* only protect corresponding hash list and inactive_list */
>  	spinlock_t		hash_locks[NR_STRIPE_HASH_LOCKS];
>  	struct mddev		*mddev;
> -	int			chunk_sectors;
> +	unsigned int		chunk_sectors;
>  	int			level, algorithm, rmw_level;
>  	int			max_degraded;
>  	int			raid_disks;
> -	int			max_nr_stripes;
> -	int			min_nr_stripes;
> +	unsigned int		max_nr_stripes;
> +	unsigned int		min_nr_stripes;

[Severity: Low]
Will the changes to min_nr_stripes and max_nr_stripes also trigger format
warnings?

Places like raid5_end_read_request() and raid5_set_cache_size() still use
%d to print these fields. For instance, in raid5_set_cache_size():

pr_err("md/raid:%s: Cannot increase cache size, ret=3D%d, new_size=3D%d, mi=
n_nr_stripes=3D%d, max_nr_stripes=3D%d\n",
       ...
       conf->min_nr_stripes,
       conf->max_nr_stripes);

> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 0c5c9fb0606ee..28828e083c2b3 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
[ ... ]
> @@ -2970,7 +2970,7 @@ sector_t raid5_compute_sector(struct r5conf *conf, =
sector_t r_sector,
>  	sector_t new_sector;
>  	int algorithm =3D previous ? conf->prev_algo
>  				 : conf->algorithm;
> -	int sectors_per_chunk =3D previous ? conf->prev_chunk_sectors
> +	unsigned int sectors_per_chunk =3D previous ? conf->prev_chunk_sectors
>  					 : conf->chunk_sectors;

[Severity: Critical]
This is a pre-existing issue, but could the use of sectors_per_chunk
cause problems when passed to rounding macros?

Looking at raid5_bitmap_sector():

raid5_bitmap_sector() {
    ...
    sectors_per_chunk =3D conf->chunk_sectors *
        (conf->raid_disks - conf->max_degraded);
    start =3D round_down(start, sectors_per_chunk);
    end =3D round_up(end, sectors_per_chunk);
    ...
}

The round_down() and round_up() macros are designed specifically for
power-of-two divisors. If the number of data disks is not a power of two,
sectors_per_chunk will not be a power of two, which would yield incorrect
sector boundaries.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260624155452.2116=
46-1-nishidafmly@gmail.com?part=3D1
