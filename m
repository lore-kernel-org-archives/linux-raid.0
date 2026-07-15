Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7606472791
	for <linux-raid@vger.kernel.org>; Wed, 15 Jul 2026 15:01:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784127694; cv=none; b=qE4F1BDeRQWoKvHM7FYiBkpmSZtTqcZ0zjVJWR8ALxhuynyqgTLrlXxlMNG8gNDJpJeBzJrcTuqEsqtcrGIQ49z/RJWUVQ++U5ZbVA68gB17Jjehk+wS4MF5NJQP5jrEmbIAppnfh6AUXc24BDayWaWDMxJuD3QDgJiaYxzQwcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784127694; c=relaxed/simple;
	bh=WSHE/uG04B8P6pfsZcAt6RJZM7GXp6KfoBEghpzZXxI=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=fEq/cpynS3W6wUPxCj57zWj36budgwrtR5+fWXP9qNkRd+eo/0BVzmVYmSGZ7FDWtksvZjTwNV97my98LOZFuyyK2Ac7tEfhiA1ot90E72oEiloJ9yo4VGffTtOhMhfgx3g2I+x5iINMzktEbAwIGUqowh5F10e4uuUUCa0r6Ws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=E7jL+Wpf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="E7jL+Wpf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CDC51F00A3A;
	Wed, 15 Jul 2026 15:01:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784127693;
	bh=ngBYdC3G3N7uDmJ4P66CnDxrSSt9FOVjGG7d2XRBpvY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=E7jL+Wpf4W64jl3kPOGjUvv1+uvjtHR9z25L/IHDGgdiX0pRV19CZdafb4BJJzkNI
	 Zv9M7YdB5h3ofaxfu99uwm56D57kphCitZ49b2Ew1Z2eCYyBHKsn/SmLmwfvwZ52RD
	 73AyJyZTGUJPEDCvI01StSVBvZ6TUF05rURXQ5R4AVP0fifgoVcS2Pr2bAnuLJDZsi
	 OV7l6A9r1K9H4kg0CP0SGgLjh9eRxVVngwnjKXkOv2I6vV75uCvr3TXlG2h13J1Cu/
	 9qZzn/O7Gt/sHPRQj1Jooff/y8NSgLkIeoznReEh7u3dwPiT5vs+ravVpQrFueY7hd
	 aksvi5fuPhInw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 8/8] raid6/kunit: add a benchmark
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christoph Hellwig" <hch@lst.de>
Cc: linux-raid@vger.kernel.org, yukuai@fygo.io
In-Reply-To: <20260715144825.95432-9-hch@lst.de>
References: <20260715144825.95432-1-hch@lst.de>
 <20260715144825.95432-9-hch@lst.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 15 Jul 2026 15:01:32 +0000
Message-Id: <20260715150133.3CDC51F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] The benchmark loop disables preemption for an extended period, r=
isking soft lockups and RCU stalls on slower architectures or emulators.
--

--- Patch [8]: [PATCH 8/8] raid6/kunit: add a benchmark ---
commit c8db04a9f21fef60a9c9e7ad0c98848e405330de
Author: Christoph Hellwig <hch@lst.de>

raid6/kunit: add a benchmark

This commit adds a benchmark to test the RAID 6 P/Q functions for more
representative block sizes and numbers of disks. The maximum allocation
size is split to allow benchmarking larger sizes, and results are reported
in GB/s.

> diff --git a/lib/raid/raid6/tests/raid6_kunit.c b/lib/raid/raid6/tests/ra=
id6_kunit.c
> index 9f3e671a12241..7d0a1ec980013 100644
> --- a/lib/raid/raid6/tests/raid6_kunit.c
> +++ b/lib/raid/raid6/tests/raid6_kunit.c
[ ... ]
> @@ -229,6 +230,68 @@ static void raid6_test(struct kunit *test)
[ ... ]
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
> +			t =3D max(ktime_get_ns() - t, 1);
> +			preempt_enable();

[Severity: Medium]
Is it safe to disable preemption across this entire 1000-iteration loop?

For the maximum test configuration of 32 disks and 16KB buffers, this loop
processes roughly 512MB of data in a single uninterruptible block. On slower
environments like emulators or User-Mode Linux (which are commonly used for
KUnit tests), could this exceed standard watchdog thresholds and trigger so=
ft
lockups or RCU stalls?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260715144825.9543=
2-1-hch@lst.de?part=3D8
