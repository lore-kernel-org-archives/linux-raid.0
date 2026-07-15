Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D5C8383C83
	for <linux-raid@vger.kernel.org>; Wed, 15 Jul 2026 14:59:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784127548; cv=none; b=B2hjlv9Q8wNqYhN3jPD5AxfrkRB+7F4Q5yPSZ9gOYeDwtsyP7P6YrixgScyRBaswudwLOtojOtf2DsowQmhwH/0Lk/H5AxSx8R3J3GjogmCLNw+jagRg715rvv3uhvj0fsUoJqAr9Z6e8jPiwuL35lW/62DYXlL6+pBrDttJcq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784127548; c=relaxed/simple;
	bh=elN0V+F/Xp/5K+V2Km0z6qbADpPcCHIKNS72OxHuaRE=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=smyjN1ZIF/WmkhtR7wUBnY68KVFhak4hcqF+7Zu9nynJb/+f/WiW72VBHBk7qXGwDn6ON389rG5qwywp3IoNk8cg3z0qf6eGbl4rikcbXnYZ/8M606smxWHFEUJ9L0yPe/msOissVV2kMgEYRWOkhZXK/P2a0+BBgPZBHajjwnw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PJrahs/j; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PJrahs/j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E86D11F000E9;
	Wed, 15 Jul 2026 14:59:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784127547;
	bh=R+D9S2M1bJn7/V5XTLG7iZEzkhBqPcJTgWcLYMIcIjc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=PJrahs/j1aG9SFwFGOiHAUPw1aJ+CYt1eu29VdxdwNBriLsgo8FVtgtYGDLpWYcL/
	 9I7szDtNYe9FysN+PLNmPrTvJX8Ugb3T3nK/QrC6ctbbGL8wh8sfXugP6CcCJcww2/
	 LK3ZoM/dFd5OcBVm9MI423UIAcGJfe/tuVi/85I1zdJ+eWPcnPSujl2W/stRRaTeYd
	 T5TErirzM3rv6ircOG4TB1dRinC+sCPfrSMqng2gi8ZvgyAKkpzPDAc8Ykrcfhz6Za
	 qaDEee23UL65eITnWXayzLFAzZZ+wPotpbKYC4p9SDrm2a5YjAqKxP1c4B2WE6ij/L
	 TPOuXU00k7lfA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 7/8] raid6: improve the runtime selection benchmark
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christoph Hellwig" <hch@lst.de>
Cc: yukuai@fygo.io, linux-raid@vger.kernel.org
In-Reply-To: <20260715144825.95432-8-hch@lst.de>
References: <20260715144825.95432-1-hch@lst.de>
 <20260715144825.95432-8-hch@lst.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 15 Jul 2026 14:59:06 +0000
Message-Id: <20260715145906.E86D11F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] The loop variable `i` is shadowed inside `raid6_choose_gen()`.
--

--- Patch [7]: [PATCH 7/8] raid6: improve the runtime selection benchmark -=
--
commit eff19093e5be2add0169cc2d5063db139e6f9d0c
Author: Christoph Hellwig <hch@lst.de>

raid6: improve the runtime selection benchmark

This commit modifies the RAID6 runtime selection benchmark to use plain
ktime_get_ns for timing. It also updates the benchmark to use 8 + 2 disks
for a more realistic load and reports throughput specifically on the data
disks.

> diff --git a/lib/raid/raid6/algos.c b/lib/raid/raid6/algos.c
> index 702e167a543af..011aa9d0eb3c5 100644
> --- a/lib/raid/raid6/algos.c
> +++ b/lib/raid/raid6/algos.c
[ ... ]
> -static int raid6_choose_gen(void *(*const dptrs)[RAID6_TEST_DISKS],
> -		const int disks)
> +static int raid6_choose_gen(void *dptrs[NR_DISKS], const int disks)
>  {
> -	/* work on the second half of the disks */
> -	int start =3D (disks >> 1) - 1, stop =3D disks - 3;
>  	const struct raid6_calls *best =3D NULL;
>  	unsigned long bestgenperf =3D 0;
>  	unsigned int i;
> =20
>  	for (i =3D 0; i < raid6_nr_algos; i++) {
>  		const struct raid6_calls *algo =3D raid6_algos[i];
> -		unsigned long perf =3D 0, j0, j1;
> +		unsigned long perf =3D 0;
> +		u64 t;
> +		int i;

[Severity: Low]
This isn't a bug, but does this inner declaration of int i shadow the
outer loop variable unsigned int i declared at the beginning of the
function?

This can trigger -Wshadow compiler warnings and might cause confusion when
reading the outer loop over raid6_nr_algos.

> =20
>  		preempt_disable();
> -		j0 =3D jiffies;
> -		while ((j1 =3D jiffies) =3D=3D j0)
> -			cpu_relax();
> -		while (time_before(jiffies,
> -				    j1 + (1<<RAID6_TIME_JIFFIES_LG2))) {
> -			algo->gen_syndrome(disks, PAGE_SIZE, *dptrs);
> -			perf++;
> -		}
> +		t =3D ktime_get_ns();
> +		for (i =3D 0; i < REPS; i++)
> +			algo->gen_syndrome(disks, BENCH_SIZE, dptrs);
> +		t =3D max(ktime_get_ns() - t, 1);
>  		preempt_enable();

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260715144825.9543=
2-1-hch@lst.de?part=3D7
