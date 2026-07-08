Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F244F408627
	for <linux-raid@vger.kernel.org>; Wed,  8 Jul 2026 09:18:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783502285; cv=none; b=cRhYl3pYvVXPRIj1Q3Q4c4ooQqPIZBSWtIE9iYHlvfpuCJfHOCv4+/Ai2sCtEXzdmQ8dYLazmNOYOnviIPXGBnsQ6pGwdoo28HlkmtT3FT3hdMKUziQIGaO0DF96SuJsPDA7+cGiMA5IKmoaPyhF+g/2hX7X4C7gTt/ejLujVOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783502285; c=relaxed/simple;
	bh=yxUAW1qCZ0bt6ls+ljxUx54SxaiE7M5C0xEBzL1+SnU=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=cSkm/KxgnAASKhqh+zJFdBOnyVB2Emw9k9QkcLy6JSSEc+F8EkI08wY98yMIZN1GYjONAcYZnXm5vjCKekfvmR9VA1fK2czPNstenTHhXpgfeLkNSZOOKohpcANVOhzPfoEpHlT/Yh4h/SmqlNbtxvUXQHzg7WmDACzu5SAnjYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aamtzjTO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aamtzjTO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68BF41F000E9;
	Wed,  8 Jul 2026 09:18:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783502283;
	bh=9kRe3njuXfZYGLoXx7dbHVZOS2H4aAOvVH7m/MzpjKA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=aamtzjTOaodmBjZ4kXMxvLvb4ZlqWxNbO8aISNiJf6DAnzbCDe3HLSvBzmsa9Wzbk
	 KUmoWwu0RQ3hkPDvHdnSsLi8ugs5ubFWF0KE9yua1ntXggQ347oxH4sw56XGDq0EqC
	 eL553iDoN/UxA6Blmamd/kU2tFjr5or7vb4t4AbGHTB8qYj/QgaxHwXx3ctgODKt6+
	 VYO4+ui6r5xIPUx1jLxrJgseYGrG38jE7pcimZxHMtncGT73q8zqgVXw10rGnseAFG
	 6G7JaANkwggaqBrvyK67JBWqqjx/3aqu9gG/4UIlOjKQwk2XSFpWPhhp/lC3Cr1kmW
	 9jfL+0ZDWzHSw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 2/8] xor: improve the runtime selection benchmark
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christoph Hellwig" <hch@lst.de>
Cc: linux-raid@vger.kernel.org, yukuai@fygo.io
In-Reply-To: <20260708090740.1433685-3-hch@lst.de>
References: <20260708090740.1433685-1-hch@lst.de>
 <20260708090740.1433685-3-hch@lst.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 08 Jul 2026 09:18:02 +0000
Message-Id: <20260708091803.68BF41F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] A division by zero kernel panic will occur during boot on systems =
using a coarse clocksource when calculating the benchmark speed.
--

--- Patch [2]: [PATCH 2/8] xor: improve the runtime selection benchmark ---
commit 69c8bf90e6d6fa234ebb61b5b5b7c4dfd2d8e9c1
Author: Christoph Hellwig <hch@lst.de>

xor: improve the runtime selection benchmark

This commit updates the XOR benchmark to use ktime_get_ns() for timing,
increases the workload to 4 source disks, and calculates throughput based
on the data disks.

> diff --git a/lib/raid/xor/xor-core.c b/lib/raid/xor/xor-core.c
> --- a/lib/raid/xor/xor-core.c
> +++ b/lib/raid/xor/xor-core.c
[ ... ]
> @@ -73,59 +72,56 @@ void __init xor_force(struct xor_block_template *tmpl)
[ ... ]
> -static void __init
> -do_xor_speed(struct xor_block_template *tmpl, void *b1, void *b2)
> +static void __init do_xor_speed(struct xor_block_template *tmpl, void *d=
est,
> +		void *srcs[NR_SRCS])
>  {
[ ... ]
> +	t =3D ktime_get_ns();
> +	for (i =3D 0; i < REPS; i++) {
>  		mb(); /* prevent loop optimization */
> -		tmpl->xor_gen(b1, srcs, 1, BENCH_SIZE);
> +		tmpl->xor_gen(dest, srcs, NR_SRCS, BENCH_SIZE);
>  		mb();
> -	} while (reps++ < REPS || (t0 =3D ktime_get()) =3D=3D start);
> -	min =3D ktime_sub(t0, start);
> -
> +	}
> +	t =3D ktime_get_ns() - t;
>  	preempt_enable();
> =20
> -	// bytes/ns =3D=3D GB/s, multiply by 1000 to get MB/s [not MiB/s]
> -	speed =3D (1000 * reps * BENCH_SIZE) / (unsigned int)ktime_to_ns(min);
> -	tmpl->speed =3D speed;
> +	/* bytes/ns =3D=3D GB/s, multiply by 1000 to get MB/s [not MiB/s] */
> +	tmpl->speed =3D div64_u64((u64)BENCH_SIZE * REPS * NR_SRCS * 1000, t);

[Severity: High]
Could this cause a division by zero panic during boot on systems with a
coarse clocksource?

If the 800 loop iterations execute very quickly (within the same clock tick)
on a platform without high-resolution timers, or during early boot phases
where jiffies are used as the clocksource, the elapsed time t will evaluate
to 0.

The previous code avoided this by looping until the clock advanced before
and after the benchmark:

    while ((start =3D ktime_get()) =3D=3D t0)

Since t is now used directly as the divisor in div64_u64(), a 0 value will
trigger an unhandled divide-by-zero hardware exception.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260708090740.1433=
685-1-hch@lst.de?part=3D2
