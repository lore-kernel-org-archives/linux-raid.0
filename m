Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A2342BEFEF
	for <linux-raid@vger.kernel.org>; Fri, 26 Jun 2026 05:00:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782450039; cv=none; b=pFt5rAYPaeVcNJBJ6j1xbCbEqiPM8+NYCiFnc/ZJdVO6rzKyc+fFWmQSRSw/lGDX9XhBYqVxXhIbqN+LclZpj7uSZpdaZf4J/G06xsU5gkVVzrz65kkqBD4q9YV3m0ZJ6E+WAl4heVulkB9OpY5O3Xi1Th5noHDY3LncFDASGKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782450039; c=relaxed/simple;
	bh=Mk6zwM+9bdj+iINoUihDFCk4JI8t5RvPLP9qMYR7yE0=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=SjGiaeOgDKcnFuqj3HJ7pnmuBuzvTjmBV2rvXMabOx1oyiSCOy9iswGHa1WQ5UBTDUMDmn0enuNCODVmOd3SWL0TNSFomxXjltxv7aWbLGNGwnD01nzNCPGahJPkND3VTL7kOyi5MGgbFRUbTV14a4xUw1NjiiU5isG8/3o+pVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TWtizlQJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TWtizlQJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AD661F000E9;
	Fri, 26 Jun 2026 05:00:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782450038;
	bh=MLcUrY342tfSLteUWN70pi9iu5jwV5R0VlQpGYWCHd0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=TWtizlQJqPGjetv0c9FKsRB9GMgPdPfudUgcV5XoYuj95k4MKSJA9AWclGElDek9a
	 1XUDkrgqxs1GR1P9taQFkJV23MbDOyiivXW7NyZYLS4VeMthOWcnpFHydbewlnkfKo
	 8smyXbiVNrvW4MD7UAVmdjUPRSmH8eAr6YXmuqNFnlSdMeXRPMZYC5fgnaE8eWl8Qf
	 IW3G273oCtFAlTjLCuLD88wezc9wMEzEQSJv+lIs8xU7JIIdxltRikNwTW017m/JWe
	 lnqTe2r98mwfTZyla5jh2blkj9v0Y88Y7dGYGLm754YS6+2OjUbnHxofHvtyRLGHdV
	 URldoqZfSywBQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 1/8] x86/fpu: Check for missing AVX and AVX-512 xstate
 bits
Reply-To: sashiko-reviews@lists.linux.dev
To: "Eric Biggers" <ebiggers@kernel.org>
Cc: linux-raid@vger.kernel.org, yukuai@fygo.io
In-Reply-To: <20260626043731.319287-2-ebiggers@kernel.org>
References: <20260626043731.319287-1-ebiggers@kernel.org>
 <20260626043731.319287-2-ebiggers@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 26 Jun 2026 05:00:37 +0000
Message-Id: <20260626050038.2AD661F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

New issues:
- [High] The patch fails to clear AVX and AVX-512 CPU capabilities when the=
 CPU natively enumerates AVX but omits XSAVE or FPU support, bypassing the =
new sanitization logic and leading to #UD panics.

Pre-existing issues:
- [Critical] Memory Protection Keys (PKU) isolation can be bypassed because=
 the kernel enables X86_FEATURE_PKU without verifying the presence of XFEAT=
URE_PKRU in xstate.
--

commit 0cd2494a6ed30cd9eb21bc480a6d7d789ab47e00
Author: Eric Biggers <ebiggers@kernel.org>

x86/fpu: Check for missing AVX and AVX-512 xstate bits

If the CPU declares AVX or AVX-512 support, verify that the
corresponding xstate bits are also set.  If not, warn and clear them.
This eliminates the perceived need for AVX and AVX-512 optimized code in
the kernel to call cpu_has_xfeatures().

> diff --git a/arch/x86/kernel/fpu/xstate.c b/arch/x86/kernel/fpu/xstate.c
> index a7b6524a9dea2..7f7e62e4ebc5b 100644
> --- a/arch/x86/kernel/fpu/xstate.c
> +++ b/arch/x86/kernel/fpu/xstate.c
> @@ -799,6 +799,23 @@ static u64 __init guest_default_mask(void)
>  	return ~(u64)XFEATURE_MASK_USER_DYNAMIC;
>  }
> =20
> +/* Clear any X86_FEATURE_* used by the kernel whose xfeatures are missin=
g. */
> +static void __init clear_cpu_caps_with_missing_xfeatures(u64 xfeatures)
> +{
> +	u64 mask;
> +
> +	mask =3D XFEATURE_MASK_FPSSE | XFEATURE_MASK_YMM;
> +	if (boot_cpu_has(X86_FEATURE_AVX) && (xfeatures & mask) !=3D mask) {
> +		pr_err("x86/fpu: Disabling AVX support due to missing xstate features\=
n");
> +		setup_clear_cpu_cap(X86_FEATURE_AVX);
> +	}
> +	mask =3D XFEATURE_MASK_FPSSE | XFEATURE_MASK_YMM | XFEATURE_MASK_AVX512;
> +	if (boot_cpu_has(X86_FEATURE_AVX512F) && (xfeatures & mask) !=3D mask) {
> +		pr_err("x86/fpu: Disabling AVX-512 support due to missing xstate featu=
res\n");
> +		setup_clear_cpu_cap(X86_FEATURE_AVX512F);
> +	}
> +}
> +

[Severity: Critical]
This is a pre-existing issue, but Memory Protection Keys (PKU) isolation
can be bypassed because we don't verify X86_FEATURE_PKU against the
presence of XFEATURE_PKRU in xstate here.

If a hypervisor reports X86_FEATURE_PKU in CPUID but masks out the
XFEATURE_PKRU xstate component, the kernel's setup_pku() enables CR4.PKE
and forces X86_FEATURE_OSPKE.  Because X86_FEATURE_OSPKE is artificially
forced, the feature is not cleared.

CR4.PKE=3D1 permits userspace to use WRPKRU, but because XCR0.PKRU=3D0,
xsaves/xrstors silently ignore the PKRU register during task context
switches, leading to state leakage across tasks.

Should we also validate PKU against missing xstate components in this
function to prevent isolation bypass?

>  /*
>   * Enable and initialize the xsave feature.
>   * Called once per system bootup.

[ ... ]

> @@ -855,6 +872,8 @@ void __init fpu__init_system_xstate(unsigned int lega=
cy_size)
>  		goto out_disable;
>  	}
> =20
> +	clear_cpu_caps_with_missing_xfeatures(fpu_kernel_cfg.max_features);
> +

[Severity: High]
Does this logic get bypassed if XSAVE or FPU support is missing?

Earlier in fpu__init_system_xstate(), there are early returns if
X86_FEATURE_FPU or X86_FEATURE_XSAVE are missing:

	if (!boot_cpu_has(X86_FEATURE_XSAVE)) {
		pr_info("x86/fpu: x87 FPU will use %s\n",
			boot_cpu_has(X86_FEATURE_FXSR) ? "FXSAVE" : "FSAVE");
		return;
	}

If a hypervisor natively enumerates AVX=3D1 but XSAVE=3D0 (such as QEMU
with -cpu host,-xsave), check_cpufeature_deps() only warns about unmet
dependencies without clearing them.  The lack of X86_FEATURE_XSAVE triggers
the early return, completely bypassing this new capability cleanup logic.

Since the kernel will then attempt to execute VEX-encoded AVX instructions
while CR4.OSXSAVE=3D0, will this result in an invalid opcode (#UD) panic?

>  	fpu_kernel_cfg.independent_features =3D fpu_kernel_cfg.max_features &
>  					      XFEATURE_MASK_INDEPENDENT;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260626043731.3192=
87-1-ebiggers@kernel.org?part=3D1
