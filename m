Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5487208D0
	for <linux-raid@vger.kernel.org>; Sun, 14 Jun 2026 01:23:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781400222; cv=none; b=G2E0aoxR+1LeZhB/SQIb8RypvaLPLa8ThjbaVIWjdSL/2G8n8rgb+rlpoxkUW+ScqoasbYoK2HIGUQECuvJLYU4niYILYIqtbxSuih1IqD4ZSgSslWOnSoAMhb4fC7DO7zkmn4hqE5d2iETYd0fgUXSCt6VtUHH5TvKL5JoDxaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781400222; c=relaxed/simple;
	bh=ujrhck6xHT7nmTw70tzxbR8RSor2lofE+QkS9XmxWuI=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=hy8rReZmzQPx5rkbZeogB20U+wWFNVbyL3pr+LN4oaVVD6QBWTi1ivhzQfVf9lNhZ2TumcztHuHZbGFzD82J14lteUS8VzsIYmLP/YrDJUcUOPfU2jUthZVgQWu+1/Wjke5nuqtbwPvGH7nZD3Ck0rRpB8BLY14F0nPqWYubCXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jyh2mAsC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jyh2mAsC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57D921F000E9;
	Sun, 14 Jun 2026 01:23:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781400221;
	bh=9pb3AYaOqbvulAKLlPej6gtykgy4AR6B+UUq8TwpVZI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=jyh2mAsC7VsRs5mq/PxOFusLkc41jcqJjOzdqsfDNF0YtoQsd84zDrXvG346Sdv0h
	 B663MRcdTveKNks0bZTWWqeGE5kt/ng45EydJ+oKYcNi92cT1GWlSeZqWx7lEFMxfX
	 5rUBmxjydc7N7uPX13xgm3sEn448pEvR5XOtobnJUfQdfDkb0URrKPxKMnNB9tlq2h
	 +cjqPwqjTAie6K30uP9O4CPKLMQc4MKrhqmeOAvTKiXHeif5lQTBhXb1e2AJFEfNu7
	 i84UfjTfUvkZC38H1jMU21tZa1eGMrvwkTVXtSOYfS3YIwUx7Rzh1hcnLQh08IuYPB
	 V/W7g/z43hiig==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2] lib/raid/xor: x86: Add AVX-512 optimized xor_gen()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Eric Biggers" <ebiggers@kernel.org>
Cc: linux-raid@vger.kernel.org, yukuai@fygo.io
In-Reply-To: <20260614010357.69416-1-ebiggers@kernel.org>
References: <20260614010357.69416-1-ebiggers@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 14 Jun 2026 01:23:40 +0000
Message-Id: <20260614012341.57D921F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] The AVX-512 XOR implementation relies solely on CPUID hardware che=
cks (`boot_cpu_has(X86_FEATURE_AVX512F)`) and skips verifying if the OS act=
ually enabled AVX-512 state management in the XCR0 register, risking a #UD =
exception.
--

commit d9094ea6909535dc1fa7dcdb6976401cdf1f90e8
Author: Eric Biggers <ebiggers@kernel.org>

lib/raid/xor: x86: Add AVX-512 optimized xor_gen()

This commit adds an AVX-512 optimized implementation of xor_gen() using
512-bit vectors and the vpternlogq instruction. The optimization is enabled
on x86_64 CPUs with AVX512F support that do not have overly-eager
downclocking (!PREFER_YMM). The author intentionally omitted the
cpu_has_xfeatures() check to avoid build issues on User-Mode Linux.

> diff --git a/lib/raid/xor/x86/xor_arch.h b/lib/raid/xor/x86/xor_arch.h
> index 99fe85a213c66..b5d49376fc974 100644
> --- a/lib/raid/xor/x86/xor_arch.h
> +++ b/lib/raid/xor/x86/xor_arch.h
[ ... ]
>  static __always_inline void __init arch_xor_init(void)
>  {
> -	if (boot_cpu_has(X86_FEATURE_AVX) &&
> -	    boot_cpu_has(X86_FEATURE_OSXSAVE)) {
> +	if (IS_ENABLED(CONFIG_X86_64) && boot_cpu_has(X86_FEATURE_AVX512F) &&
> +	    boot_cpu_has(X86_FEATURE_OSXSAVE) &&
> +	    !boot_cpu_has(X86_FEATURE_PREFER_YMM)) {

[Severity: High]
Could omitting the cpu_has_xfeatures() check in arch_xor_init() result in a
#UD exception?

While CR4.OSXSAVE indicates that XCR0 is enabled, it does not guarantee that
the OS or hypervisor actually enabled the AVX-512 state components (OPMASK,
ZMM_Hi256, Hi16_ZMM) in XCR0.=20

If a hypervisor advertises AVX-512 CPUID bits but masks out the correspondi=
ng
XCR0 bits, executing EVEX-encoded AVX-512 instructions could trigger an
Invalid Opcode exception and cause a kernel panic.

> +		/* AVX-512 will be the best; no need to try others. */
> +		/* !PREFER_YMM excludes CPUs with overly-eager downclocking. */
> +		xor_force(&xor_block_avx512);
> +	} else if (boot_cpu_has(X86_FEATURE_AVX) &&
> +		   boot_cpu_has(X86_FEATURE_OSXSAVE)) {
> +		/* AVX will be the best; no need to try others. */
>  		xor_force(&xor_block_avx);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260614010357.6941=
6-1-ebiggers@kernel.org?part=3D1
