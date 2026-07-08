Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92399407CC7
	for <linux-raid@vger.kernel.org>; Wed,  8 Jul 2026 09:22:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783502565; cv=none; b=cT9+mzgzGYKrRSEVzoWWqUxc/2MfWEW7oGrpEbz3bt20BtMvcFOJzz7ilXNhw5vmmBCcFWfzEXRutJ8hDSnBpW9bjnuuFiuWq3pSJsenApE9n0fvWFbsa2iigeNClTLLfyrM9P1hgVMH2p0C0XySutZyRuYLVp5TSoOB9UpLowo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783502565; c=relaxed/simple;
	bh=bgyM52NICicpOEpRD1fQrVQULB72SfpKtqP9kWrWMSs=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=gxbW3ZFZy50jZgvZiZRYI3p5yVF8sjZnQdDras9zc78MfPnjDyuFNS+53F7HfnzsPVKDipd0OX0NBTpiiIKrk2eVD2WmZhDHdqiT2iMtVveERqiLayBJgGBAMxE3k76MoIH0OG3o1v/gipefa8RsR0sXGO/y61eGIj6X+U2gIh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Fv37H06e; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Fv37H06e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7EF51F000E9;
	Wed,  8 Jul 2026 09:22:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783502564;
	bh=KI8lBb4oFQNL1gAo/NKZt9jE+NNNyT46KQcniwMisVw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Fv37H06ea7MEIzwYsQPYnOUAS3ivxnx7k9ImbBg31XHmhlhLig3UGVaoEwxMCRhrk
	 oyQ9AUWhLoQAChEQO6DqBw1IR8R6YibUBmAj1aBIzXXb1MHCRrig53kzfcptDB95+u
	 xo4dyfTBYSC1MwOUUfaGZU9T7HL64EpXEZxtMPJoRPNutZ4GKjhG7CvDwaaaxBsilT
	 odWFoQdiM10x+PFlC4ufN5jvPG3Iwq3R9vgS6VJdUUqSD9lRLj3qBBZrj1GA1sn4F6
	 TuWQvTOug0HBnLiKlP/Et9e8IWfVqw5CG+YaaCkbzP3AYQuw5N5hEV+dHxyCjILWNK
	 R2YLfAiq5A2Ag==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 4/8] xor/kunit: add a benchmark
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christoph Hellwig" <hch@lst.de>
Cc: yukuai@fygo.io, linux-raid@vger.kernel.org
In-Reply-To: <20260708090740.1433685-5-hch@lst.de>
References: <20260708090740.1433685-1-hch@lst.de>
 <20260708090740.1433685-5-hch@lst.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 08 Jul 2026 09:22:43 +0000
Message-Id: <20260708092243.E7EF51F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] Potential divide-by-zero kernel panic in `xor_benchmark()` when ca=
lculating the benchmark speed if the execution time is 0.
- [Medium] The benchmark holds `preempt_disable()` for the entire duration =
of 1000 XOR iterations, risking soft lockups on slower hardware or emulator=
s.
--

--- Patch [4]: [PATCH 4/8] xor/kunit: add a benchmark ---
commit 4f82691a9522c9ab25bdc94cf0c1ad74dc8c3b7e
Author: Christoph Hellwig <hch@lst.de>

xor/kunit: add a benchmark

This patch adds a benchmark to test the XOR functions for more
representative block sizes and numbers of disks. It measures the execution
time of 1000 iterations of xor_gen() for varying buffer counts and lengths,
reporting the throughput in GB/s.

> diff --git a/lib/raid/xor/tests/xor_kunit.c b/lib/raid/xor/tests/xor_kuni=
t.c
> index 659ae3edbc25b..648c6da9464c4 100644
> --- a/lib/raid/xor/tests/xor_kunit.c
> +++ b/lib/raid/xor/tests/xor_kunit.c

[ ... ]

> @@ -125,8 +125,70 @@ static void xor_test(struct kunit *test)
>  	}
>  }
> =20
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
> +			t =3D ktime_get_ns() - t;
> +			preempt_enable();

[Severity: Medium]
Does this workload risk triggering the kernel's soft lockup detector?

The test executes a hardcoded 1000 iterations of xor_gen() on up to 32 buff=
ers
of 16KB within a single preempt_disable() block. This amounts to processing
over 500MB of data atomically.

In slower environments like QEMU TCG without KVM, this large computational
workload could take tens of seconds, which might exceed the typical 20-seco=
nd
soft lockup threshold.

> +
> +			speed[j] =3D div64_u64((u64)len * num_iters * nr, t);

[Severity: High]
Can this result in a divide-by-zero kernel panic?

If the benchmark runs on a system with coarse timekeeping resolution (e.g.,
using the jiffies clocksource), and the CPU completes the 1000 iterations
within a single timer tick, the elapsed time `t` could evaluate to 0.

Since `t` is used directly as the divisor in div64_u64() without being
checked, this might trigger a hardware exception and panic the kernel.

> +		}
> +
> +		static_assert(ARRAY_SIZE(len_to_test) =3D=3D 2);
> +		kunit_info(test, "%3u disks:\t%5llu  GB/s\t%5llu  GB/s\n",
> +				nr, speed[0], speed[1]);
> +	}
> +}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260708090740.1433=
685-1-hch@lst.de?part=3D4
