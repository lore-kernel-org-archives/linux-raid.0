Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B909216DEB1
	for <linux-raid@vger.kernel.org>; Sat, 15 Aug 2026 18:28:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786818516; cv=none; b=VtoLCT/UynuZiLAl+FybIUuybHh3FSpfGwkbsaD9lmsu+uSjYyMMY9e3hFkdef2rfjJLoJqcYzffWUiC/wCKOV+x9auqRn0v0BWgPlRTvSMNkV/jYSFqEBCLZLWKcarHVzUMzHD+oaTTNMfEKLWaLx1xEeJx2KejpKrD4OtJ3Hc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786818516; c=relaxed/simple;
	bh=yUm7PiQyAkKCi6Zh8xpvNrq+pT7FuycxApC3A8RhryA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=A5+ZdmXvYy+V15WL40+izSXhKYMUHg1O1DNnEbRYLHQHgNOvi9PZem2MeOnZX3Gb5cUGW4FIFA++HM2aAnS3rwTdZ8chYHH/W41qEsp60jQN0zYWS536ayEgZqcRy1UJqVrVMChoYdYmy3CND66NCC3NUOizKlbBbK4Fg8wZQhI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=loa+4KMB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="loa+4KMB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F41941F000E9;
	Sat, 15 Aug 2026 18:28:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786818514;
	bh=ertrkGr19xaN3vWe0pcw7Fbc+u+Fc9V14L9ipReuYYE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=loa+4KMBBA3b/8CS1JNq9m2c7oy+wckOAUZ2FMe048CMth9h5mJ5iEtyp9LG9mRuW
	 9Y2iTc0NGqMlfWffjbS0XhkHAOAMYc/mSxSUuQ6AuGhT+Xj+d8KoorkPKr9QVIw4bF
	 /+CZHIuxDQ3XlSE7q71A+74tAQZlq7iYwkq3oO1vuplhKpyta+8sxLOSiWBLS4tUMz
	 p6Rn9homUYJMf87EaBBnwxWVRcLKYOxOuiIn0qO4MEU5G8Xh1xQcEZwv4brYKcDBj/
	 hiSvvt4Bz58q73U4lQ3zxKqe2kmqxwGzxltQtU8vAsI5fFZtaSW1/8ZgLVs1RxsF2j
	 h+tnA35bdtvhA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 1/8] x86/fpu: Check for missing AVX and AVX-512
 xstate bits
Reply-To: sashiko-reviews@lists.linux.dev
To: "Eric Biggers" <ebiggers@kernel.org>
Cc: linux-raid@vger.kernel.org, yukuai@fygo.io
In-Reply-To: <20260815181024.28924-2-ebiggers@kernel.org>
References: <20260815181024.28924-1-ebiggers@kernel.org>
 <20260815181024.28924-2-ebiggers@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 15 Aug 2026 18:28:33 +0000
Message-Id: <20260815182833.F41941F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] A malformed CPUID reporting AVX512F=3D1 but AVX=3D0 will cause a #=
GP exception during xsetbv.
--

--- Patch [1]: [PATCH v4 1/8] x86/fpu: Check for missing AVX and AVX-512 xs=
tate bits ---
commit 7ad6682a0d9e6a99cd138d1dc9dfbd430c1da651
Author: Eric Biggers <ebiggers@kernel.org>

x86/fpu: Check for missing AVX and AVX-512 xstate bits

This patch checks if the CPU declares AVX or AVX-512 support, and verifies
that the corresponding xstate bits are also set. If not, it warns and clears
the CPU capabilities.

> diff --git a/arch/x86/kernel/fpu/xstate.c b/arch/x86/kernel/fpu/xstate.c
> index a7b6524a9dea2..97cfd4fb6cc00 100644
> --- a/arch/x86/kernel/fpu/xstate.c
> +++ b/arch/x86/kernel/fpu/xstate.c
[ ... ]
> @@ -844,6 +847,24 @@ void __init fpu__init_system_xstate(unsigned int leg=
acy_size)
>  		goto out_disable;
>  	}
> =20
> +	mask |=3D XFEATURE_MASK_YMM;
> +	if (boot_cpu_has(X86_FEATURE_AVX)) {
> +		if ((fpu_kernel_cfg.max_features & mask) !=3D mask) {
> +			pr_err(FW_BUG
> +			       "x86/fpu: Disabling AVX support due to missing xstate features=
\n");
> +			setup_clear_cpu_cap(X86_FEATURE_AVX);
> +		}
> +	}
> +
> +	mask |=3D XFEATURE_MASK_AVX512;
> +	if (boot_cpu_has(X86_FEATURE_AVX512F)) {
> +		if ((fpu_kernel_cfg.max_features & mask) !=3D mask) {

[Severity: High]
This is a pre-existing issue, but does this logic handle a malformed CPUID
reporting AVX512F=3D1 but AVX=3D0 correctly?

If the xstate leaf reports both YMM and AVX512 support, the AVX validation
block above is skipped because AVX=3D0. Since mask accumulates both YMM and
AVX512, the check here passes, so X86_FEATURE_AVX512F is not cleared.

Later in fpu__init_system_xstate(), the xsave_cpuid_features loop:

	for (i =3D 0; i < ARRAY_SIZE(xsave_cpuid_features); i++) {
		unsigned short cid =3D xsave_cpuid_features[i];

		/* Careful: X86_FEATURE_FPU is 0! */
		if ((i !=3D XFEATURE_FP && !cid) || !boot_cpu_has(cid))
			fpu_kernel_cfg.max_features &=3D ~BIT_ULL(i);
	}

will clear the YMM bit from max_features because AVX=3D0, but will retain t=
he
AVX512 bits because AVX512F=3D1.

Could this result in passing an invalid xstate combination (AVX512 without
YMM) to xsetbv, triggering a #GP exception during boot?

> +			pr_err(FW_BUG
> +			       "x86/fpu: Disabling AVX-512 support due to missing xstate feat=
ures\n");
> +			setup_clear_cpu_cap(X86_FEATURE_AVX512F);
> +		}
> +	}
> +

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260815181024.2892=
4-1-ebiggers@kernel.org?part=3D1
