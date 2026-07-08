Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3C8840913B
	for <linux-raid@vger.kernel.org>; Wed,  8 Jul 2026 09:20:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783502415; cv=none; b=eumu5GtR4gNbHB3JQNG8ZikYfuHldhJVtVqaHHIiacqkNoOEWjwva7JFM4/rgzWveNgApFapzEMeyLxn1DEF7eClNY1SioDMoGES83P8aZ0QFaIZiWKcBMYiIwASeS7xfP5qy7dWQPY1OMx/+TH9m4EIKuJUSaQc59A6ftU0A5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783502415; c=relaxed/simple;
	bh=X34NbWO0MbT1CjQ1A6W0xWCzABH/E1eUj7LdBNpBWsY=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=NqIeh0vej+zs3ZIKcVzwfupAPs7BbW+8/oAwWlxQfYbn+6SYncmHiHyC2TcUsj/MDl01fdPk4pfX+luq/9blb7UFjZ2GkQiUMLH8kB05nosjK817XdDNVg1iDGH7cvfaCe/Gr8X9L4GUbwF3QCRgWrvk6PFcj7NImFz5TFfE48U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MzkpBqP8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MzkpBqP8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 170F61F00A3A;
	Wed,  8 Jul 2026 09:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783502413;
	bh=KiXmsuXa0AOHnNq+noE+0pGLmRR62xKhlmGT6gvRPTU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=MzkpBqP80ytrM6R9JqPpObBGMFFhPzxc+WLXrLTcSV3NzMJbJJI2Ej66vECIy0ojc
	 te+nXAWLBwotc5qHA/84b4iVZf8za6JnM6PLmKssQWVb5LRMazgmOEHcVFha6FVHNB
	 X2wxK1kAPegJ9SjCdgEiiTXx0zbHrYtJ5HdhuhqQku08aNgdzJJIYFN/Jl/aZ6PLpM
	 t+6XJstXXCTtySpX0ne2Z+kJUxf1oBh9D9ULPB7N++pS6GLOicdGhYMCazdmbLmXjB
	 Cbb94UQmz7Mq9Td1ya0wvNQf58n/IFCF/IG+E1q/nd+1RQxR/QC/3tbpUmmVbap/p+
	 /yEIBNJYXlp6w==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 7/8] raid6: improve the runtime selection benchmark
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christoph Hellwig" <hch@lst.de>
Cc: linux-raid@vger.kernel.org, yukuai@fygo.io
In-Reply-To: <20260708090740.1433685-8-hch@lst.de>
References: <20260708090740.1433685-1-hch@lst.de>
 <20260708090740.1433685-8-hch@lst.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 08 Jul 2026 09:20:12 +0000
Message-Id: <20260708092013.170F61F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [High] Potential division by zero kernel panic when calculating benchmark=
 throughput if the elapsed time `t` evaluates to 0.
- [Medium] The reported throughput for the XOR algorithm is artificially in=
flated by a factor of 2.
- [Low] The benchmark inner loop variable `int i` redundantly shadows the o=
uter function-scoped variable `unsigned int i`.
--

--- Patch [7]: [PATCH 7/8] raid6: improve the runtime selection benchmark -=
--
commit ae782577f509b50023ef73d6d96f6fe2f366a500
Author: Christoph Hellwig <hch@lst.de>

raid6: improve the runtime selection benchmark
   =20
Use plain ktime_get_ns for the timing, use 8 + 2 disks for a realistic
load, and report the throughput on the data disks as that is what
storage systems are measured on.

> diff --git a/lib/raid/raid6/algos.c b/lib/raid/raid6/algos.c
> index e7984bde5157f..c44b986e319e3 100644
> --- a/lib/raid/raid6/algos.c
> +++ b/lib/raid/raid6/algos.c
[ ... ]
> @@ -152,40 +152,39 @@ void raid6_recov_datap(int disks, size_t bytes, int=
 faila, void **ptrs)
>  }
>  EXPORT_SYMBOL_GPL(raid6_recov_datap);
> =20
> -#define RAID6_TIME_JIFFIES_LG2	4
> -#define RAID6_TEST_DISKS	8
> +#define BENCH_SIZE	SZ_4K
> +#define NR_SRCS		8
> +#define NR_DISKS	(NR_SRCS + 2)
> +#define REPS		800U
> =20
> -static int raid6_choose_gen(void *(*const dptrs)[RAID6_TEST_DISKS],
> -		const int disks)
> +static int raid6_choose_gen(void *dptrs[NR_DISKS], const int disks)
>  {
>  	/* work on the second half of the disks */
> -	int start =3D (disks >> 1) - 1, stop =3D disks - 3;
> +	int start =3D (disks / 2) - 1, stop =3D disks - 3;
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
This isn't a bug, but `int i` declared here shadows the function-scoped
`unsigned int i` used for the outer loop.

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
> +		t =3D ktime_get_ns() - t;
>  		preempt_enable();
> =20
> +		/* bytes/ns =3D=3D GB/s, multiply by 1000 to get MB/s [not MiB/s] */
> +		perf =3D div64_u64((u64)BENCH_SIZE * REPS * NR_SRCS * 1000, t);

[Severity: High]
Is it possible for `t` to be 0 here, leading to a division by zero panic?

If the system uses a coarse clock source (like jiffies during early boot be=
fore
high-resolution timers are initialized) and the benchmark iterations comple=
te
within the same timer tick, `t` might evaluate to 0.

[ ... ]
> @@ -197,28 +196,22 @@ static int raid6_choose_gen(void *(*const dptrs)[RA=
ID6_TEST_DISKS],
>  	static_call_update(raid6_xor_syndrome_impl, best->xor_syndrome);
> =20
>  	pr_info("raid6: using algorithm %s gen() %ld MB/s\n",
> -		best->name,
> -		(bestgenperf * HZ * (disks - 2)) >>
> -		(20 - PAGE_SHIFT + RAID6_TIME_JIFFIES_LG2));
> +		best->name, bestgenperf);
> =20
>  	if (best->xor_syndrome) {
> -		unsigned long perf =3D 0, j0, j1;
> +		u64 t;
> +		int i;

[Severity: Low]
This isn't a bug, but `int i` declared here also shadows the function-scoped
`unsigned int i`.

> =20
>  		preempt_disable();
> -		j0 =3D jiffies;
> -		while ((j1 =3D jiffies) =3D=3D j0)
> -			cpu_relax();
> -		while (time_before(jiffies,
> -				   j1 + (1 << RAID6_TIME_JIFFIES_LG2))) {
> -			best->xor_syndrome(disks, start, stop,
> -					   PAGE_SIZE, *dptrs);
> -			perf++;
> -		}
> +		t =3D ktime_get_ns();
> +		for (i =3D 0; i < REPS; i++)
> +			best->xor_syndrome(disks, start, stop, BENCH_SIZE,
> +				dptrs);
> +		t =3D ktime_get_ns() - t;
>  		preempt_enable();
> =20
> -		pr_info("raid6: .... xor() %ld MB/s, rmw enabled\n",
> -			(perf * HZ * (disks - 2)) >>
> -			(20 - PAGE_SHIFT + RAID6_TIME_JIFFIES_LG2 + 1));
> +		pr_info("raid6: .... xor() %llu MB/s, rmw enabled\n",
> +			div64_u64((u64)BENCH_SIZE * REPS * NR_SRCS * 1000, t));

[Severity: Medium]
Does this calculation artificially inflate the reported throughput for the =
XOR
algorithm by a factor of 2?

The `xor_syndrome` benchmark operates on a subset of disks from `start` to
`stop` (which is `(disks / 2) - 1` through `disks - 3`). For the default
`NR_DISKS` (10), this processes 4 data disks. However, the throughput
calculation multiplies by `NR_SRCS` (8) instead of the actual number of dis=
ks
processed. The previous implementation correctly adjusted for this using an
extra bit shift (`+ 1`), which was dropped in this patch.

[Severity: High]
Like the calculation above, could `t` be 0 here leading to a division by ze=
ro
panic?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260708090740.1433=
685-1-hch@lst.de?part=3D7
