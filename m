Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A96E38BF61
	for <linux-raid@vger.kernel.org>; Mon, 15 Jun 2026 19:25:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781551540; cv=none; b=U/7JIAKEPyqjaLrUF4AEQOzXW3DwnTbS0geeLGVhGUUEDYLF2K2Pzi/FPum/FBchXmnZzrDJCt4/dIThPkEN6S4oFx0FgC848eQfWNkYCz3ce3mQcYmbA9v0VzsViAL2b/D0aRiRdZs+KUttAICOx+GNzxLiWjpjgAjqFvfJhgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781551540; c=relaxed/simple;
	bh=j0li/glgwRQ7WN5LcXKjiGDormUOurAJPEA03/45jJI=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=AsTCT1awrhxKArHYkum4ILkZOz6dbPkn0lTo9RKbyJMjy36K8Xatmoi4E6iDCP3XKy4k0HRgsbXrlcoHQi9FxAo17nPoDf/VsYXRXXwCs0pquOry8b3gpmIs7pYb1lY3IT5GWCH2mIfmThTeN8E8Hy40D0RDYRP3hoH5UC/E17k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XwmkyrTw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XwmkyrTw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE0C31F000E9;
	Mon, 15 Jun 2026 19:25:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781551539;
	bh=7wu1e1OwfM3bsuq7VMzcg4jKRv3bj6gxV3dzh4pH+/I=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=XwmkyrTwoZRgycW04seOOvdAVAjuampfOx4YzaT7M2clgr5VlOL9qphnVagWpqKye
	 Rwn/6LmB1Ph+iHuRpihdLlx8jCr362Q8jtjGxLJrzxbyLyk6eqLYFYAvR8Ly6ZO/v+
	 vMeYRoRfBzJraMbVQK4+myunnmpGOOtZOL4eeeExa1L89FQpuPXOZPt9igV92Ttd6H
	 SfM5CPYREuwOFR9IpiTo70M6eKhiDvgx5NWJj4x0Lc6TPRh/Yh+imdOGHPGFKfB6vD
	 wY34o6K28Vyllm1af7tM2ev6Ro6Yupr1WjbntDuZvsWHdTE7NMoPA9BfhT29nYenkz
	 OjajluIRXnprQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3] lib/raid/xor: x86: Add AVX-512 optimized xor_gen()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Eric Biggers" <ebiggers@kernel.org>
Cc: linux-raid@vger.kernel.org, yukuai@fygo.io
In-Reply-To: <20260615190338.26581-1-ebiggers@kernel.org>
References: <20260615190338.26581-1-ebiggers@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 15 Jun 2026 19:25:38 +0000
Message-Id: <20260615192538.EE0C31F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] The AVX-512 XOR implementation is forced based solely on `boot_cpu=
_has(X86_FEATURE_AVX512F)` without checking if the OS actually manages ZMM =
registers via `cpu_has_xfeatures()`. This introduces an Undefined Opcode (#=
UD) kernel panic vulnerability on systems where AVX-512 is supported by the=
 CPU but restricted in XCR0.
--

commit b63aaca8e8b386ef1820d1caac3bce2cb328e8c3
Author: Eric Biggers <ebiggers@kernel.org>

lib/raid/xor: x86: Add AVX-512 optimized xor_gen()

This commit adds an AVX-512 implementation of xor_gen() using 512-bit ZMM
registers and the vpternlogq instruction. It enables this implementation on
x86_64 CPUs that support AVX512F but do not prefer YMM registers, avoiding
known downclocking issues on older architectures. The implementation
explicitly omits the cpu_has_xfeatures() check.

> Note: for now I omitted the cpu_has_xfeatures() check that the AVX-512
> optimized crypto and CRC code does, since it's not implemented on
> User-Mode Linux and it's never been present in the RAID6 code either.

[Severity: High]
Does omitting the cpu_has_xfeatures() check introduce a potential Invalid
Opcode exception in virtualized environments?

If a hypervisor advertises AVX512F in CPUID but omits the AVX-512 FPU
extended state from XSTATE, boot_cpu_has(X86_FEATURE_AVX512F) will evaluate
to true, but the OS will not enable AVX-512 in XCR0. Executing 512-bit
EVEX instructions without XCR0[7:5] enabled causes an Invalid Opcode
exception and kernel panic.

Would it be safer to preserve this check, perhaps providing a stub or
using ifdef for User-Mode Linux compatibility instead?

> diff --git a/lib/raid/xor/x86/xor_arch.h b/lib/raid/xor/x86/xor_arch.h
> index 99fe85a213c66..b5d49376fc974 100644
> --- a/lib/raid/xor/x86/xor_arch.h
> +++ b/lib/raid/xor/x86/xor_arch.h
[ ... ]
> @@ -6,22 +6,26 @@ extern struct xor_block_template xor_block_p5_mmx;
>  extern struct xor_block_template xor_block_sse;
>  extern struct xor_block_template xor_block_sse_pf64;
>  extern struct xor_block_template xor_block_avx;
> +extern struct xor_block_template xor_block_avx512;
> =20
>  static __always_inline void __init arch_xor_init(void)
>  {
> -	if (boot_cpu_has(X86_FEATURE_AVX) &&
> -	    boot_cpu_has(X86_FEATURE_OSXSAVE)) {
> +	if (IS_ENABLED(CONFIG_X86_64) && boot_cpu_has(X86_FEATURE_AVX512F) &&
> +	    boot_cpu_has(X86_FEATURE_OSXSAVE) &&
> +	    !boot_cpu_has(X86_FEATURE_PREFER_YMM)) {
> +		/* AVX-512 will be the best; no need to try others. */
> +		/* !PREFER_YMM excludes CPUs with overly-eager downclocking. */
> +		xor_force(&xor_block_avx512);

[Severity: High]
Can this force the AVX-512 implementation on systems that do not actually
support ZMM registers in the OS?

During boot, fpu__init_system_xstate() limits fpu_kernel_cfg.max_features
based on the XSTATE leaf, but does not clear X86_FEATURE_AVX512F from
boot_cpu_data.x86_capability. As a result, this check passes and forces
xor_block_avx512, which then attempts to execute AVX-512 instructions on
an unsupported FPU context.

Is it necessary to include cpu_has_xfeatures(XFEATURE_MASK_AVX512, NULL)
here to verify the FPU context supports these instructions before forcing
the block?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260615190338.2658=
1-1-ebiggers@kernel.org?part=3D1
