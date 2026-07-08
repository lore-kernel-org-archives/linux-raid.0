Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEC9A40586A
	for <linux-raid@vger.kernel.org>; Wed,  8 Jul 2026 09:20:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783502461; cv=none; b=SxdzrhxsBnFUm6IXkG1/VQMRF/sW9i8CbkTPfGemD9svZhmN5KGZT1AsWTNm2GVRJZUqts7aiLTosj+OK7xTCN9AVpjLcO050UUlhUbULrnLeMipYDewj7YVrWcS28JmjLKdkV39eddoLsSawho6vKn5WqEVQYsgxA0lARekzSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783502461; c=relaxed/simple;
	bh=ukfmqyjhBhPKy+Y+NI9/RSCA+Ld689SG3657Z5/OAxg=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=lg+TkHEwXfQqYyTi7pmNEss7P0LX3pwIm5sPyPblNNuQfy0brFWjnlcv2FiiC4bXSM/i8toHsEF1SFOk6ql3K5+VUyAgqtN5ktPxxnI8Ycn8OFa9VNhTALzULzaTzFctg41JVFnkh+R7dDPxSQ16BqTmJhpNldzijh0S0z8+9yU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Rbmcnp1v; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Rbmcnp1v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47BAB1F000E9;
	Wed,  8 Jul 2026 09:20:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783502459;
	bh=umBYyQ2COKqWkebWBmcxn6PPFj9S/zrLS9oCuRZnjms=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Rbmcnp1vEL9mNH3vBcpemnnzwa3rMd1DT9Sx0fq6Yo47VEixkpjKRQoETOPoE1z8q
	 Xwd/t1cUA4oP52i406lopG68DLPMPTbDs3JktnpMdBSabgfk4w/VC7pdpMlc+gqf/k
	 3DN/U7sYLnUX/ki0bQHrusCWV8kD/MsDXxDzlLeKeAFyT6fJFia8IQxGK/VaaMlJz4
	 rBF9sFhAG0mwUAZiiOhGVfbqpUtTcnb/awhgpggSrsodNnbcFefILjbAuNxQw4R1NR
	 +TXYD9JY5igPpOpRVdyodkXMOy2OkXQnvqltiHDbi0k5wc5/vXHp5jj9dzpl8Ju9+g
	 n5yTAVgdS2ueQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 8/8] raid6/kunit: add a benchmark
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christoph Hellwig" <hch@lst.de>
Cc: yukuai@fygo.io, linux-raid@vger.kernel.org
In-Reply-To: <20260708090740.1433685-9-hch@lst.de>
References: <20260708090740.1433685-1-hch@lst.de>
 <20260708090740.1433685-9-hch@lst.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 08 Jul 2026 09:20:58 +0000
Message-Id: <20260708092059.47BAB1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 4 potential issue(=
s) to consider:
- [Medium] Potential division by zero in benchmark speed calculation if ela=
psed time `t` evaluates to zero.
- [Medium] Unbounded atomic section (preemption disabled) can cause soft lo=
ckups or RCU stalls on slower architectures.
- [Low] Duplicate `RAID6_PQ` Kconfig symbol declaration.
- [Low] Inaccurate commit message referencing XOR functions instead of RAID=
6 PQ functions.
--

--- Patch [8]: [PATCH 8/8] raid6/kunit: add a benchmark ---
commit 63d135afc471564206ce7921d64339a16ff1484f
Author: Christoph Hellwig <hch@lst.de>

raid6/kunit: add a benchmark
   =20
This commit adds a benchmark to the RAID6 KUnit test suite to evaluate P/Q
generation speeds across different disk counts and block sizes. It splits
the max alloc size from the kunit max size and reports the performance in
GB/s.

> Add a benchmark to test the XOR functions for more representative block
> sizes and numbers of disks.  This splits the maximum alloc size used for

[Severity: Low]
This isn't a bug, but the commit message states it adds a benchmark for the
"XOR functions", while the patch actually adds a benchmark for the RAID6 P/Q
generation algorithm.

[ ... ]
> diff --git a/lib/raid/Kconfig b/lib/raid/Kconfig
> index c4eeb7c716c89..c52d5c2052946 100644
> --- a/lib/raid/Kconfig
> +++ b/lib/raid/Kconfig
> @@ -60,6 +60,15 @@ config RAID6_PQ_KUNIT_TEST
>  	  This is intended to help people writing architecture-specific
>  	  optimized versions.  If unsure, say N.
> =20
> +config RAID6_PQ_KUNIT_BENCHMARK
> +	bool "Benchmark for RAID6 PQ"
> +	depends on RAID6_PQ_KUNIT_TEST
> +	help
> +	  Include benchmarks in the KUnit test suite for raid P/Q generation.
> +
> +config RAID6_PQ
> +	tristate
> +

[Severity: Low]
Is this duplicate declaration of config RAID6_PQ intentional? It appears to
be defined earlier in this same file.

>  config RAID6_PQ_BENCHMARK
>  	bool "Automatically choose fastest RAID6 PQ functions"
>  	depends on RAID6_PQ
> diff --git a/lib/raid/raid6/tests/raid6_kunit.c b/lib/raid/raid6/tests/ra=
id6_kunit.c
> index 9f3e671a12241..f927e3456d175 100644
> --- a/lib/raid/raid6/tests/raid6_kunit.c
> +++ b/lib/raid/raid6/tests/raid6_kunit.c
[ ... ]
> @@ -229,6 +230,68 @@ static void raid6_test(struct kunit *test)
>  		raid6_test_one(test);
>  }
> =20
> +static void raid6_benchmark(struct kunit *test)
> +{
[ ... ]
> +		for (j =3D 0; j < ARRAY_SIZE(len_to_test); j++) {
> +			unsigned int len =3D len_to_test[j];
> +			const unsigned long num_iters =3D 1000;
> +
> +			KUNIT_ASSERT_GT(test, len, 0);
> +			KUNIT_ASSERT_LE(test, len, RAID6_KUNIT_ALLOC_BYTES);
> +
> +			preempt_disable();
> +			t =3D ktime_get_ns();
> +			for (l =3D 0; l < num_iters; l++)
> +				raid6_gen_syndrome(nr_to_test[i],
> +						len_to_test[j], test_buffers);
> +			t =3D ktime_get_ns() - t;
> +			preempt_enable();

[Severity: Medium]
Could this unbounded atomic section cause soft lockups or RCU stalls on
slower architectures or emulators?=20

The loop executes 1,000 iterations of raid6_gen_syndrome() with preemption
disabled. On slow hardware or CI emulators, processing this much data might
take multiple seconds and prevent the scheduler from running.

> +
> +			speed[j] =3D div64_u64((u64)len * num_iters * nr, t);

[Severity: Medium]
Is there a risk of a division by zero panic here?

If the KUnit test runs on a system with a coarse-resolution clock (such as
with CONFIG_HIGH_RES_TIMERS disabled) and a sufficiently fast CPU, the
1,000 iterations might complete in less time than a single clock tick.

In this scenario, ktime_get_ns() could return the same value before and
after the loop, causing the elapsed time t to evaluate to exactly 0 before
being passed as the divisor.

> +		}
> +
> +		static_assert(ARRAY_SIZE(len_to_test) =3D=3D 2);
> +		kunit_info(test, "%3u disks:\t%5llu  GB/s\t%5llu  GB/s\n",
> +				nr, speed[0], speed[1]);
> +	}
> +}
[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260708090740.1433=
685-1-hch@lst.de?part=3D8
