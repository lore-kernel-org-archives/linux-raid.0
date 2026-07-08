Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCD8E405C3B
	for <linux-raid@vger.kernel.org>; Wed,  8 Jul 2026 09:23:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783502596; cv=none; b=XN5nZygHXuVf2EsuIrAYAVYw124RbFi6gE61ETdKFj0VoEASObIFfdvuOKuSbPKTj3Hn1b5uyeDzb7kzn4LXqcjF6NzBth+o8yqFTHkh9EvVET8ccfzbfVBKWjlveIC7Hj1B5A8kRVOZWOTh+wHLV4rtcZnOgCmrfsZBXqJ5Bwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783502596; c=relaxed/simple;
	bh=xGX8DyVMvpKraGjM16TZMhpQfvzs9/7ZnyG1oF6nawc=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=aNhKvuWCII2KG/qA8iR97iiszIgxobQRF4/oVlgWQXuU3vpuQOtmJFW8etxome4ePL/zMR1OzUtqbOjK7poZ7YGQWd3x1XRLXa5C+Idj1s0N6rf1/2OO8Lsxvc8BV4H+n9RAzzFmTPJbbDbWt9foQr0bnx5QwRSK4oUP4kOg/sY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BksWhsUK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BksWhsUK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CFCE1F00A3F;
	Wed,  8 Jul 2026 09:23:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783502595;
	bh=/A8BfLOTiqW6Ph/6EmABUuEypAVdXE2aMJi5IHobAdE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=BksWhsUKJExIsM63F5VhI8UZxPjfbo5Bwp31d2blBqRhvdG50tjGYtW5Dd5UQC/YR
	 wB5d2ShpLUR90nTtYhFQlF29X/dnCin3uFCZJeUoTpPyPlv+OeVwXTDDfShqxeXaSt
	 4eKZs79N1hB8QCBXtmBd27diczHEA/G7RFF1bLtfYGCglrXoiRp7iPuKVvZR9qUT/d
	 h9QHjgJOSIgxEljBQK4nEgvLphopZ+ksEqBcOIqkotCg+047SL0pkX5CSD0tFIS8hG
	 LIN+jkZJpuozht2MPnE9UEIl09T79J2eUaJDZZu++3DylDqOiWHH+uc/Jsmv2KPsAw
	 S9igcJw0kbTIg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 6/8] raid6: defer implementation selection when built-in
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christoph Hellwig" <hch@lst.de>
Cc: linux-raid@vger.kernel.org, yukuai@fygo.io
In-Reply-To: <20260708090740.1433685-7-hch@lst.de>
References: <20260708090740.1433685-1-hch@lst.de>
 <20260708090740.1433685-7-hch@lst.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 08 Jul 2026 09:23:14 +0000
Message-Id: <20260708092315.2CFCE1F00A3F@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] The boot-time RAID6 benchmark runs unconditionally when built-in=
, ignoring the `CONFIG_RAID6_PQ_BENCHMARK` setting and the single-algorithm=
 optimization.
--

--- Patch [6]: [PATCH 6/8] raid6: defer implementation selection when built=
-in ---
commit 2c9ec4f0b44515f49715b67c2e70f8628c5abd61
Author: Christoph Hellwig <hch@lst.de>
Subject: raid6: defer implementation selection when built-in

This commit defers the RAID6 implementation selection to avoid holding up
early boot. It follows the pattern used in the RAID5 XOR code, allowing
full use of the timing subsystem for benchmarking.

> diff --git a/lib/raid/raid6/algos.c b/lib/raid/raid6/algos.c
> index 6f5c89ab2b17b..e7984bde5157f 100644
> --- a/lib/raid/raid6/algos.c
> +++ b/lib/raid/raid6/algos.c
> @@ -236,16 +236,6 @@ static int __init raid6_select_algo(void)
>  	int i, cycle;
>  	int error;
> =20
> -	if (!IS_ENABLED(CONFIG_RAID6_PQ_BENCHMARK) || raid6_nr_algos =3D=3D 1) {
> -		pr_info("raid6: skipped pq benchmark and selected %s\n",
> -			raid6_algos[raid6_nr_algos - 1]->name);
> -		static_call_update(raid6_gen_syndrome_impl,
> -				raid6_algos[raid6_nr_algos - 1]->gen_syndrome);
> -		static_call_update(raid6_xor_syndrome_impl,
> -				raid6_algos[raid6_nr_algos - 1]->xor_syndrome);
> -		return 0;
> -	}
> -
>  	/* prepare the buffer and fill it circularly with gfmul table */
>  	disk_ptr =3D kmalloc(PAGE_SIZE * RAID6_TEST_DISKS, GFP_KERNEL);

[ ... ]

> @@ -329,13 +319,40 @@ static int __init raid6_init(void)
>  	static_call_update(raid6_recov_datap_impl, raid6_recov_algo->datap);
>  	pr_info("raid6: using %s recovery algorithm\n", raid6_recov_algo->name);
> =20
> +	if (!IS_ENABLED(CONFIG_RAID6_PQ_BENCHMARK) || raid6_nr_algos =3D=3D 1) {
> +		pr_info("raid6: skipped pq benchmark and selected %s\n",
> +			raid6_algos[raid6_nr_algos - 1]->name);
> +		goto default_algo;
> +	}
> +
> +#ifdef MODULE
>  	return raid6_select_algo();
> +#else
> +	/*
> +	 * Pick the last registered implementation as the temporary default unt=
il
> +	 * calibration happens.
> +	 */
> +#endif

[ ... ]

> +/*
> + * When built-in we must register the default implementation before md
> + * initializes, but we don't want calibration to run that early as that
> + * would delay the boot process.
> + */
> +#ifndef MODULE
> +device_initcall(raid6_select_algo);
> +#endif

[Severity: Medium]
Will this unconditional device_initcall cause the benchmark to run even when
it is intentionally disabled in the configuration?

While raid6_init() checks CONFIG_RAID6_PQ_BENCHMARK and correctly skips the
early calibration phase, removing that same check from raid6_select_algo()
means this deferred call will unconditionally run the benchmarking loop lat=
er
in the boot process. It looks like this bypasses both the config setting and
the single-algorithm optimization entirely.

>  subsys_initcall(raid6_init);
>  module_exit(raid6_exit);
>  MODULE_LICENSE("GPL");

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260708090740.1433=
685-1-hch@lst.de?part=3D6
