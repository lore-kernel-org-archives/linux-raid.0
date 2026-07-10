Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5FFE374E5A
	for <linux-raid@vger.kernel.org>; Fri, 10 Jul 2026 13:37:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783690645; cv=none; b=e/qWGrVWWqtDSGL0SuOVoH/2w5AM0lEmzQLFijGN5BZGLcUbALI7qA27qpeKMP6D59eYHIAMv2PV79Dm/liqWwW5Fe/OJqk9kQ+Mm87//v1YL11KRHb6+OqjN6HncYU3iIDFp4b6uhfBunWbnxS3ACW4dKnnXSYwT7Nscu3vxZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783690645; c=relaxed/simple;
	bh=haEAvAiP0AFZbRw9SbYTabta81gPYZ9A0Q74+nTjq68=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=CGbeF5k2xcHn9+hQZMpd1GaP2jP7PP0iH/9zkRmWwz2hDphipeQ6FTnPzbbmwTav5JgYLNeP6plkvqAx0FtPFWGnlSDn6K9+zcXwXyYEqmOagnGSEXGjhDxn5K4aW8D7aIc0mqg340H9Ze5cP2GKwVioe0PxFmxw50Lu7Gt9E6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ilC54HaX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ilC54HaX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D8671F000E9;
	Fri, 10 Jul 2026 13:37:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783690644;
	bh=3zvkiBBWqWV8mLaUxw/ZMRvJiQ8+X3RCpyFEkr0hApY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ilC54HaX/XPe+Bb7eG0DrFpV/kKtUjT6cFDRWe1BsNigA/b4gsyoNZXWNQPlozSQl
	 pgDLiHtBUnTcoUy1/W/KniZ06WQ0ONpujpSMMnNl6Xe/+X/GF4cdLn/RhFR7fOum1P
	 /9VfZFaXiZ/MIRaF+dnjsibbsuMFNE8QbSAFOCAzdSZdLuNbDp2kWU19kbZrr/Hjyx
	 KnR+5jaiOcWDS7jI848H4yAACgoC1rocpHnx4n3eKS/7YzzTfvx6sRqvy5xt8jkjkg
	 FTRD7+/GN+2YRPibTQiBd8DM04F6zPaoUzz7jkCQsPr7lmsLzKfTi0IhtOAlXKzZlw
	 9/1etciZyp/Qg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 5/6] md/raid5: scale the default stripe cache size with
 system memory
Reply-To: sashiko-reviews@lists.linux.dev
To: "Hiroshi Nishida" <nishidafmly@gmail.com>
Cc: linux-raid@vger.kernel.org, yukuai@fygo.io
In-Reply-To: <20260710132346.7295-6-nishidafmly@gmail.com>
References: <20260710132346.7295-1-nishidafmly@gmail.com>
 <20260710132346.7295-6-nishidafmly@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 10 Jul 2026 13:37:23 +0000
Message-Id: <20260710133724.0D8671F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [High] 32-bit arithmetic overflow in `setup_conf` causes incorrect auto-s=
izing of the RAID5 stripe cache on 32-bit systems.
- [Medium] TOCTOU race condition when reading the module parameter `stripe_=
cache_size_default` allows bypassing intended bounds.
- [Medium] The commit message incorrectly claims that 'existing arrays are =
unaffected' by the new auto-sizing default.
--

--- Patch [5]: [PATCH 5/6] md/raid5: scale the default stripe cache size wi=
th system memory ---
commit 879380beda117fd029123c90fae16a214ae91020
Author: Hiroshi Nishida <nishidafmly@gmail.com>

md/raid5: scale the default stripe cache size with system memory

setup_conf() starts every array with min_nr_stripes =3D NR_STRIPES (256),
about 12MB of stripe cache on a 12-disk array. That fixed default was
chosen for small systems and is never revisited. Auto-size the initial
count from memory when the new stripe_cache_size_default module parameter
is 0.

> Auto-size the initial count from memory when the new
> stripe_cache_size_default module parameter is 0 (the default): keep the
> historical NR_STRIPES up to RAID5_CACHE_DEFAULT_BASE_GB (8GB) of RAM, then
> grow the count using about 1/512 of the RAM above that baseline, capped at
> RAID5_CACHE_DEFAULT_MAX (4096).  A system with 8GB or less is therefore
> unchanged -- same count, same footprint -- while larger ones scale up
> smoothly (no jump at the baseline) to a bounded maximum.  A non-zero
> stripe_cache_size_default sets a fixed initial size for administrators who
> want one; existing arrays are unaffected, and a reshape still forces at
> least its window's worth of stripes.

[Severity: Medium]
Is the claim that existing arrays are unaffected accurate?

Because setup_conf() is invoked during array assembly and the
stripe_cache_size is not persisted in the superblock, it appears an
existing array will boot with the dynamically scaled cache size instead
of the historical 256 stripes.

> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 5f0825c5effec..8e1c2eba42417 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c

[ ... ]

> @@ -7801,15 +7817,37 @@ static struct r5conf *setup_conf(struct mddev *md=
dev)

[ ... ]

> +	if (stripe_cache_size_default) {
> +		conf->min_nr_stripes =3D clamp_t(unsigned long,
> +					stripe_cache_size_default, 16, INT_MAX);

[Severity: Medium]
Could this read of stripe_cache_size_default race with a concurrent sysfs
modification?

If stripe_cache_size_default is changed to 0 exactly between the if
condition and the clamp_t evaluation, conf->min_nr_stripes would be clamped
to 16 rather than the historical 256.

Would it be safer to read this module parameter once into a local variable?

> +	} else {
> +		unsigned long per_stripe =3D sizeof(struct stripe_head) +
> +			max_disks * (sizeof(struct bio) + PAGE_SIZE);
> +		unsigned long ram =3D totalram_pages() << PAGE_SHIFT;
> +		unsigned long base =3D (unsigned long)RAID5_CACHE_DEFAULT_BASE_GB << 3=
0;

[Severity: High]
Do these calculations overflow on 32-bit systems?

Since unsigned long is 32 bits on those platforms, calculating base as
8 << 30 will wrap to 0.=20

Similarly, calculating ram by shifting totalram_pages() by PAGE_SHIFT will
wrap for systems with 4GB or more of memory, potentially breaking the
scaling logic for higher memory systems.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260710132346.7295=
-1-nishidafmly@gmail.com?part=3D5
