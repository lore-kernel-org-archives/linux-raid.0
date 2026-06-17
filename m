Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 133AB31A807
	for <linux-raid@vger.kernel.org>; Wed, 17 Jun 2026 06:00:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781676045; cv=none; b=W55cn8Y8FsaCymhNvL22l9+F2ENhNA1CZOJ43AP90hgKNmU452aXs/bYzlaLDUrqjtKTI+/jfdh0+IXOFD4I7wR0KXTajTTPLbnVHCA+uZ2pwuw235Kc5tk9Vc5Y9BHg1DXI73bSnV0G4c3hIKFMn9EIyKcGXYhZRo6IV4WNtNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781676045; c=relaxed/simple;
	bh=13icpZYpkiFRVjnUX2LjTONYZCJD6zOKP0lrdq400fg=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=DTV4ZKyw4lNDdkYKSwr22v9IX1nyODAhNzp84UPPxZcev5bQIlhuVcFZcoUqPg9Ih/WW4z6WDyECW65bIhIrMQ2UMbZI6OmrE2lHldQueJsWyswad6vnkrxU0CGxI4oAEgKj3I+9aXMZxIfdV6TfWC1sX3L+CeA1uNusLHYM4ds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=N67QnY+/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="N67QnY+/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CED31F000E9;
	Wed, 17 Jun 2026 06:00:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781676043;
	bh=KTN72B5jtju3dtzhiIYzb86/w8+0t83DtaQkJJHWkdQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=N67QnY+/UBqYAyeBgWyL0Ocde9LNxZlbqYblGNgk5RbVBQCYr0aoyL8YV0U+SPqHB
	 WLew7jqfrgoaCmAlOUusMUVIBg+YIGVgjYdiIrFP/Fppaj+aRMTZkdmCowD1WwRQED
	 X6WFgjlTPTBsZTski+jK8gxFvXu96dgRjpuO0O/Fjqb7oyWs7PCRDrYlJMJ6KHh6QI
	 Q5LHnNlEoV8paG9FtZ/JlemZabVTkONx0lCl2dITk5s+yjmtZwZUvJqisecq2QtNjc
	 ZghAT21dYlaOWdHd/7sbph5vqU9yajNcTqbXO0ma9aPDadVtTZkTWZhpovRznGUEzQ
	 Aulrvo6hQ8Ixw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 2/2] xor/kunit: add a benchmark
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christoph Hellwig" <hch@lst.de>
Cc: linux-raid@vger.kernel.org, yukuai@fygo.io
In-Reply-To: <20260617054416.3841334-3-hch@lst.de>
References: <20260617054416.3841334-1-hch@lst.de>
 <20260617054416.3841334-3-hch@lst.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 17 Jun 2026 06:00:43 +0000
Message-Id: <20260617060043.7CED31F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [High] The elapsed benchmark time `t` (a 64-bit nanosecond value) is pass=
ed as a 32-bit divisor to `div_u64()`, leading to implicit truncation for r=
uns over 4.29 seconds, resulting in totally incorrect throughput metrics or=
 a potential divide-by-zero kernel panic.
- [Medium] Executing a massive 1,000-iteration XOR processing loop synchron=
ously with preemption disabled can cause RCU CPU stall warnings and softloc=
kups on slower test environments.
- [Medium] The throughput computation calculates Gigabytes per second (GB/s=
) using integer division, which unconditionally truncates any throughput sl=
ower than 1 GB/s down to 0 GB/s.
--

commit facfbbbac101882a52a1c7a2e6d86cb1173448ed
Author: Christoph Hellwig <hch@lst.de>

xor/kunit: add a benchmark

This commit adds a benchmark to test the XOR functions for more representat=
ive
block sizes and numbers of disks. It includes 4k and 16k sizes, as increasi=
ng
the test buffer size further would increase the functional kunit test runti=
me
too much.

> diff --git a/lib/raid/xor/tests/xor_kunit.c b/lib/raid/xor/tests/xor_kuni=
t.c
> index 659ae3edbc25b..5939b78b39446 100644
> --- a/lib/raid/xor/tests/xor_kunit.c
> +++ b/lib/raid/xor/tests/xor_kunit.c

[ ... ]

> @@ -125,8 +125,71 @@ static void xor_test(struct kunit *test)
> +		for (j =3D 0; j < ARRAY_SIZE(len_to_test); j++) {
> +			unsigned int len =3D len_to_test[j];
> +			const unsigned long num_iters =3D 1000;
> +
> +			KUNIT_ASSERT_GT(test, len, 0);
> +			KUNIT_ASSERT_LE(test, len, XOR_KUNIT_MAX_BYTES);
> +
> +			preempt_disable();
> +			t =3D ktime_get();
> +			for (l =3D 0; l < num_iters; l++)
> +				xor_gen(test_dest, test_buffers, nr, len);
> +			t =3D ktime_get_ns() - t;
> +			preempt_enable();

[Severity: Medium]
Will this massive 1,000-iteration XOR loop cause RCU CPU stall warnings or
trigger the softlockup watchdog on slower environments?

In the worst-case configuration, this processes 512MB of memory synchronous=
ly
with preemption completely disabled. On unaccelerated CI environments or
low-power CPUs, processing this amount of data can take tens of seconds, wh=
ich
violates latency guarantees.

Should preemption be enabled periodically, or the number of iterations scal=
ed
dynamically?

> +
> +			speed[j] =3D div_u64((u64)len * num_iters * nr, t);

[Severity: High]
Does this code silently truncate the 64-bit elapsed time t when dividing?

div_u64() expects a 32-bit unsigned integer as its divisor. The elapsed time
t is a 64-bit nanosecond value. If the execution takes longer than 4.29
seconds (U32_MAX nanoseconds), the upper 32 bits of t will be implicitly
truncated, corrupting the calculation.

Worse, if the lower 32 bits happen to truncate to exactly 0, this will trig=
ger
a division by zero kernel panic.

Should this use div64_u64() instead?


[Severity: Medium]
Will this integer division unconditionally truncate any throughput slower t=
han
1 GB/s down to 0 GB/s?

Mathematically, computing bytes per nanosecond is directly equivalent to
computing GB/s. Because this uses integer division without scaling the
numerator, any throughput below 1 GB/s will evaluate to exactly 0. On
processors without SIMD acceleration or in VMs, this might falsely log 0 GB=
/s.

Could the numerator be multiplied by 1,000 to output MB/s and preserve usef=
ul
precision?

> +		}
> +
> +		static_assert(ARRAY_SIZE(len_to_test) =3D=3D 2);
> +		kunit_info(test, "%3u disks:\t%5llu  GB/s\t%5llu  GB/s\n",
> +				nr, speed[0], speed[1]);
> +	}
> +}
> +#endif /* CONFIG_XOR_BENCHMARK */

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260617054416.3841=
334-1-hch@lst.de?part=3D2
