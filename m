Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DE0B3C5837
	for <linux-raid@vger.kernel.org>; Tue,  1 Sep 2026 15:11:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788275487; cv=none; b=Buf5hhCtgxZRaCDSqk/xur4+Nn0/2hABbNinFXrkxOwfMlZC2kbNfbwQ3PLffFz0xRNAVu7lCG8xNKam/X+6cUZrDnYlNl/2sNmn4TZfRjQMenYMYVcM4YmsMck+oTg49z9O85byjhC7nkjzn+aVATa+PZGvUIilwlt8LJbgN2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788275487; c=relaxed/simple;
	bh=QVBNfBtN3h2FCXCXqKFPGX+WeO+nzcennWHQ5xMSaWs=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=VQ2Vr7tOoK5wYapRi/QkgKL4QH3qd8uHqFp49lNWlf16iZFrAchHWclPY/kPXCDB2kxk4ts5a9mSPOGNZI3Slr4/pt1rEwDSWHbB3GK2u3LvGtuQMhci+AB27g/9FzQydLCYxqPz1tEVabL5oSZlKHsEGhqWuqQpKGvtzWnFFqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IpIkczJt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IpIkczJt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF42A1F000E9;
	Tue,  1 Sep 2026 15:11:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788275486;
	bh=gD/t6cGy3gvRGrf5vQRF2hXJ3qotJNtg8TEXwErsOuc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=IpIkczJt5P5UWbiEQDMUff0LBDEjD85gKcTlzrMli8tG65HS3jBHoRgO7PJHtCjr4
	 9aH7Co5bPN0jqKyQ0y8DatsIbF3lhOX4ynxQa1SoJBVZS51Yew+TODS8vYvyMys8I0
	 tnN6WcacaHnRYzexWFJZJEHtjPCLKXYZnESQXyIksZy9M/7esjz87wxuufWuEq0v6m
	 5nztEcLjz++pSWGhlVz3ptr3+zfQqNPyxMBQ3ojlxp0plFgiprYvBLGt3cr2UBH1wL
	 i6ZhuIrAeZc9njkSgWZrDsmpST0eu1Ow+yihITrXWrc+gGjIbJmY2dQ2vRIG8znLre
	 LSqC29G2/R/XQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 2/8] um: Check for missing AVX and AVX-512 xstate
 bits
Reply-To: sashiko-reviews@lists.linux.dev
To: "Eric Biggers" <ebiggers@kernel.org>
Cc: linux-raid@vger.kernel.org, yukuai@fygo.io
In-Reply-To: <20260901145740.42337-3-ebiggers@kernel.org>
References: <20260901145740.42337-1-ebiggers@kernel.org>
 <20260901145740.42337-3-ebiggers@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 01 Sep 2026 15:11:25 +0000
Message-Id: <20260901151125.EF42A1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] Incomplete XCR0 validation whitelist allows dependent AVX/AVX-51=
2/AMX features to bypass xstate checks.
--

commit e378386cb877bae1a24be0e8bda74c90d72f4636
Author: Eric Biggers <ebiggers@kernel.org>

um: Check for missing AVX and AVX-512 xstate bits

This commit introduces a check in the UML architecture to verify that all
corresponding bits are set in the XCR0 register for AVX and AVX-512 support.
If any bits are missing, the features are disabled and a warning is issued.
This aligns UML behavior with userspace by ensuring xstate support before u=
sing
advanced CPU features.

> diff --git a/arch/um/kernel/um_arch.c b/arch/um/kernel/um_arch.c
> index e4ee693961e4e..9d53cc6a783d7 100644
> --- a/arch/um/kernel/um_arch.c
> +++ b/arch/um/kernel/um_arch.c

[ ... ]

> +static void __init validate_and_set_cpu_cap(int cap, u64 xcr0)
> +{
> +	/*
> +	 * Check for missing xstate features right away, so that there's no
> +	 * perceived need for all optimized code in the kernel to do so.
> +	 */
> +	switch (cap) {
> +	case X86_FEATURE_AVX:

[ ... ]

> +	case X86_FEATURE_AVX512_VPOPCNTDQ:
> +		if ((xcr0 & 0xe7) !=3D 0xe7) {
> +			static bool warned;
> +
> +			if (!warned) {
> +				os_warn("Disabling AVX-512 support due to missing xstate features\n"=
);
> +				warned =3D true;
> +			}
> +			return;
> +		}
> +		break;
> +	}

[Severity: Medium]
Does this switch statement omit validation for several AVX and AMX dependent
features?

Because this acts as a manual whitelist, features like F16C, FMA4, XOP,
AMX_TILE, and AMX_INT8 appear to fall through the switch statement and bypa=
ss
xstate validation entirely.

If the host disabled AVX/AMX in XCR0 but the hardware supports it (and still
advertises the dependent features in /proc/cpuinfo), they would fall through
and be unconditionally enabled here.

If kernel code or userspace checks these omitted flags, could it attempt to
execute unsupported instructions and trigger a #UD fault?

> +	set_cpu_cap(&boot_cpu_data, cap);
> +}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260901145740.4233=
7-1-ebiggers@kernel.org?part=3D2
