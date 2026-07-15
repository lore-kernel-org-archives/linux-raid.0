Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88F27449EB8
	for <linux-raid@vger.kernel.org>; Wed, 15 Jul 2026 15:05:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784127910; cv=none; b=AxXWNTDDldlmoIvdEpD/Mx+IrAXtcFfGFtMLgPkFhZagIZUfdYtHB1ipfd3heJ7w38mZn4C+ov2e2EOEK+ViWptlIhMXNc9PdCOpVPcsd65C9X6RG0WeHZgAtI55DTd6UsxrIpCD3zy1Nw+R0izdrQ7/IR91pT07nr0fUQiMxF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784127910; c=relaxed/simple;
	bh=/FBM024vtcGMg1Cfik6sMJ8XqGfmnx8DPtrEgoRnPGE=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=XYC1Y5WXC9B6eKTUpMS92v1czyu2w0dCJ07y6zkKImi+JVS9aMdhPnEsTVB6XUdMVWBuvmT1zEeK0HeTfedQeN1qEBEMGbyCC0DCJDbQYYDXsvuIWG5CUoGRR+RT6MtbrxYcCtOaRg2wQoPLfGQWYNp3oz2Uv4M2bv7BKN8I5Tk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Dz1IJr7E; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Dz1IJr7E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F03D41F000E9;
	Wed, 15 Jul 2026 15:05:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784127909;
	bh=YPeroB/0mtYBuoiYRx2aD+o2CLcR3ehin90NRk4mrPo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Dz1IJr7ENZ2HahsWiaBAtSEu1K078WLKAeWY2gL/L4LwxwchGb4JJfs7hNLQd56rg
	 E9sxS3p87RRZ6Z5rXa7DBBD9TB0e10x8cEt589q3La3o3AjOAdLiyDlz79TAaRyskH
	 X6VUT8v87c3S2tXTEvFKb++NyaUDWOqZo7ppJgNJW1xzMNsBHCmiW7MOMmg+1KUgQS
	 Z1/iiIkb+i9IYpNN3JGIbPfmVywkDGTgY1V/rUco5eaJkFAg4gNSmwT3YXm2H9u/tn
	 3cbMFvKzHOLw+v7VSrJCvRNlbIRlkRLyG/1rbTXs0VVO10+QCpwZHGXV/d12wky707
	 7tb3FJ4s/VrDg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 4/8] xor/kunit: add a benchmark
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christoph Hellwig" <hch@lst.de>
Cc: yukuai@fygo.io, linux-raid@vger.kernel.org
In-Reply-To: <20260715144825.95432-5-hch@lst.de>
References: <20260715144825.95432-1-hch@lst.de>
 <20260715144825.95432-5-hch@lst.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 15 Jul 2026 15:05:08 +0000
Message-Id: <20260715150508.F03D41F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] Unbounded preemption-disabled region in `xor_benchmark` causes sof=
tlockup panics and RCU stall warnings on slower architectures.
--

--- Patch [4]: [PATCH 4/8] xor/kunit: add a benchmark ---
commit f403ad2f80a6eb7a690f9b948152ad30281caf15
Author: Christoph Hellwig <hch@lst.de>
xor/kunit: add a benchmark

This commit adds a benchmark to the XOR KUnit test suite to evaluate
performance across varying block sizes and numbers of disks. The benchmark
reports runtime speeds in GB/s.

> diff --git a/lib/raid/xor/tests/xor_kunit.c b/lib/raid/xor/tests/xor_kuni=
t.c
> --- a/lib/raid/xor/tests/xor_kunit.c
> +++ b/lib/raid/xor/tests/xor_kunit.c
[ ... ]
> +static void xor_benchmark(struct kunit *test)
> +{
[ ... ]
> +		for (j =3D 0; j < ARRAY_SIZE(len_to_test); j++) {
> +			unsigned int len =3D len_to_test[j];
> +			const unsigned long num_iters =3D 1000;
> +
> +			KUNIT_ASSERT_GT(test, len, 0);
> +			KUNIT_ASSERT_LE(test, len, XOR_KUNIT_MAX_BYTES);
> +
> +			preempt_disable();
> +			t =3D ktime_get_ns();
> +			for (l =3D 0; l < num_iters; l++)
> +				xor_gen(test_dest, test_buffers, nr, len);
> +			t =3D max(ktime_get_ns() - t, 1);
> +			preempt_enable();

[Severity: High]
Will this preemption-disabled region cause softlockup panics or RCU stalls
on slower architectures?

In xor_benchmark(), preempt_disable() is called before processing 1,000
iterations of up to 32 blocks of 16KB each. On a slow emulated architecture
without hardware acceleration, this loop will synchronously process over
500 MB of memory.

If the memory bandwidth is low enough, could this tight loop exceed the
default 20-second softlockup and 21-second RCU stall timeouts, resulting
in a kernel panic during CI testing?

Would it be safer to place the preemption-disabled block inside the
iteration loop and accumulate the time, or dynamically scale the number
of iterations based on a time threshold so the scheduler has a chance to ru=
n?

> +
> +			speed[j] =3D div64_u64((u64)len * num_iters * nr, t);
> +		}
[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260715144825.9543=
2-1-hch@lst.de?part=3D4
