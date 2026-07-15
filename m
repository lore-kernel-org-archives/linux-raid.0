Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AE4339A064
	for <linux-raid@vger.kernel.org>; Wed, 15 Jul 2026 15:04:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784127844; cv=none; b=J71IZCO82G5SPLET6RSsi7eUBLyU+hmIMYpvQi9l/E9M9ogdAUhlyfsmwzjtLzUShykzLjHGPdAzaEZcIAeFJh/RqUy7WRhEO0ZUKAGXzuCpJXlIH7jKPxOI1+isB93/xwxL+pvALO8q4EtmKaTgI/m3grNQnhKEk9rqi9lXq9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784127844; c=relaxed/simple;
	bh=iox8xOPtfyJJwD38BV7bgsC8/C9Bk9jHETQnbkqtpxo=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=jD2HGhsNnpjX/Qb+mzSNOwr2Z91Dig83rlmssEDiZC8DSEqbY8gDBbvI6q31xtmItbvR5Ff/4acZ30nn9J9dm9W2WVBpoFsG5QSOWZ1F4Mg4I2z2dZCg4U5fy/sAzuhVhyMHqh5+kSNhIEhgS8QyXmB8ETRzQCDijGvACGPcuvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HbvYQ0UC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HbvYQ0UC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93DE21F000E9;
	Wed, 15 Jul 2026 15:04:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784127842;
	bh=a/21DwchbsZq/7zBAiD30Ve1LcOb/ppNnFz1SW8Bte0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=HbvYQ0UCeEY4/Kw2DuBx1MiqPaX4udPmxrUxDAGjm4WOX8A+as4zRDKQcwU0i7BHo
	 mp9u+L8x3rgRR+d/kVULN1LMWPz1QafPiecUwSR6ncGPfOjbOGKF3NdKXyZ74XMDKP
	 1u9D/YVevZj37Q+Z/N4SAj4+DmQmY3nlsfRhFZx2JuajGfzdIj3tC00CEvmOYSQ2qJ
	 K7BQ496Fi1bnc6Z99VxJRBoeoJ2OjOBC/3LBBufegqUKonLHqSe98uI7fP0g3I+cfJ
	 FI6TeJ396ZbNRRzDapCBd12QY7iuupvkiMUKmppOMPe/A9DiX+xPlCOhOpJKJI2ERj
	 echfPf2jG42rQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 2/8] xor: improve the runtime selection benchmark
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christoph Hellwig" <hch@lst.de>
Cc: linux-raid@vger.kernel.org, yukuai@fygo.io
In-Reply-To: <20260715144825.95432-3-hch@lst.de>
References: <20260715144825.95432-1-hch@lst.de>
 <20260715144825.95432-3-hch@lst.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 15 Jul 2026 15:04:02 +0000
Message-Id: <20260715150402.93DE21F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] Replacing clock-tick synchronization with a fixed number of loop i=
terations causes zero-duration time deltas on coarse clocks, leading to art=
ificial throughput inflation, integer overflow, and random algorithm select=
ion.
--

--- Patch [2]: [PATCH 2/8] xor: improve the runtime selection benchmark ---
commit 2205984bf337f5c013e14971e819bb6346e19853
Author: Christoph Hellwig <hch@lst.de>

xor: improve the runtime selection benchmark

This commit modifies the XOR block benchmark to use ktime_get_ns for timing
and switches to 4 + 1 disks for a more realistic load. It also reports the
throughput on the data disks instead of the parity disk.

> diff --git a/lib/raid/xor/xor-core.c b/lib/raid/xor/xor-core.c
> index 50931fbf0324e..f9d61b096b117 100644
> --- a/lib/raid/xor/xor-core.c
> +++ b/lib/raid/xor/xor-core.c

[ ... ]

> -#define BENCH_SIZE	4096
> +#define BENCH_SIZE	SZ_4K
> +#define NR_SRCS		4
>  #define REPS		800U
> =20
> -static void __init
> -do_xor_speed(struct xor_block_template *tmpl, void *b1, void *b2)
> +static void __init do_xor_speed(struct xor_block_template *tmpl, void *d=
est,
> +		void *srcs[NR_SRCS])
>  {
> -	int speed;
> -	unsigned long reps;
> -	ktime_t min, start, t0;
> -	void *srcs[1] =3D { b2 };
> +	u64 t;
> +	int i;
> =20
>  	preempt_disable();
> -
> -	reps =3D 0;
> -	t0 =3D ktime_get();
> -	/* delay start until time has advanced */
> -	while ((start =3D ktime_get()) =3D=3D t0)
> -		cpu_relax();
> -	do {
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
> +	t =3D max(ktime_get_ns() - t, 1);

[Severity: High]
Does removing the clock-tick synchronization create an issue with low
resolution clocks?

If a high-resolution clocksource is not yet available during early boot,
the 800 loop iterations might complete within a single clock tick. If that
happens, the elapsed time t evaluates to 0 and gets clamped to 1.

>  	preempt_enable();
> =20
> -	// bytes/ns =3D=3D GB/s, multiply by 1000 to get MB/s [not MiB/s]
> -	speed =3D (1000 * reps * BENCH_SIZE) / (unsigned int)ktime_to_ns(min);
> -	tmpl->speed =3D speed;
> +	/* bytes/ns =3D=3D GB/s, multiply by 1000 to get MB/s [not MiB/s] */
> +	tmpl->speed =3D div64_u64((u64)BENCH_SIZE * REPS * NR_SRCS * 1000, t);

[Severity: High]
Can this division silently overflow the 32-bit signed integer tmpl->speed?

If t is clamped to 1 ns, it yields a quotient of approximately 13.1 billion.
This overflows the 32-bit integer and could result in negative or
astronomically high throughput values.=20

This might break the calibration logic and cause the kernel to select a
suboptimal XOR algorithm.

> =20
> -	pr_info("   %-16s: %5d MB/sec\n", tmpl->name, speed);
> +	pr_info("   %-16s: %5d MB/sec\n", tmpl->name, tmpl->speed);
>  }

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260715144825.9543=
2-1-hch@lst.de?part=3D2
