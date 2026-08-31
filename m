Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70AAE37C0E6
	for <linux-raid@vger.kernel.org>; Mon, 31 Aug 2026 22:06:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788214020; cv=none; b=YAiTlk3CVoEnGa8BZ0jNu48p48lDtoe0dAdMxY/I2gSsKrILDDhjVbMocf2XW5V5+bs+yQB1t1wMO5JJ6c0tgF51jGxf6CY25kpWuUADAdulVv94XKSGnSiWVTPtXrFG+kNsXLRwQqNEPbh8RbTw/QcA+GKovclz5NLwkis6IbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788214020; c=relaxed/simple;
	bh=2wlUa5vMtevM/Cjtyr2tJ25R+4E+Hyw9nRjWtSsPfw4=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=mJ8SzUuloybS2zPtn3OZmven66YbyWZ+xn3mDLiTatkZvU9yIUktbpGaPyNoU8IOFtILhEP+lQtMKlr0xjEaiw/tR/BO3kQ28WKWP5E2lgaKczw7gmwHsadXjDsBA67zW8xyTi/uKYYq6gBM5JG5CS4pDRGEOeHBv1XsSK2LyHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Rre4FsE+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Rre4FsE+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADAE91F00A3D;
	Mon, 31 Aug 2026 22:06:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788214018;
	bh=xpRo+SPjEFmQQnNj+bm6lPblw0qC5h6RDvbrx4NB7Ss=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Rre4FsE+3URC4KJ9/DrIEgd8fvyCJLNPf9NdHJI+YwstixVHV/LX95h49PnBA09IE
	 nUbJ2tt4mE8o9wgnhUEsVj04riscBlz1QI2TLj+TZboF+/+wF2yrVrjvfFHdHebAwX
	 w+4V/S1RfI89ZyaJcpBJp1LoJvDpqZ8zm9CW4IgvUrcF+uZe74ePjEhhkcfx1M0aob
	 vOFgpfj8OmjcqTizsFOroiAvV5fJyADdYMt1foO8z5svuBySe5eNKIZj+Bppg5+sf8
	 0+LGOFeJ8j1rBeY0f16Z6YH7hgTChIB1STGpmIAjUK63Ac20kXq0nnphVpPtM15BZ4
	 I7QZqTRcF7VhQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RESEND] xor: add missing vzeroupper to AVX code
Reply-To: sashiko-reviews@lists.linux.dev
To: "Eric Biggers" <ebiggers@kernel.org>
Cc: linux-raid@vger.kernel.org, yukuai@fygo.io
In-Reply-To: <20260831212248.213805-1-ebiggers@kernel.org>
References: <20260831212248.213805-1-ebiggers@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 31 Aug 2026 22:06:58 +0000
Message-Id: <20260831220658.ADAE91F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Incomplete fix: Missing `vzeroupper` in parallel AVX2/AVX-512 RAID=
6 and crypto implementations causes severe AVX-to-SSE transition penalties.
--

commit 0dc8e5aa3bec5867a6cc446b05765378e42b49c6
Author: Eric Biggers <ebiggers@kernel.org>

xor: add missing vzeroupper to AVX code

This commit adds a missing vzeroupper instruction to the AVX optimized XOR
code. This clears the upper bits of the YMM registers before returning,
preventing severe performance degradation when later SSE code is executed.

> diff --git a/lib/raid/xor/x86/xor-avx.c b/lib/raid/xor/x86/xor-avx.c
> index f7777d7aa269b..95b21e7225e8d 100644
> --- a/lib/raid/xor/x86/xor-avx.c
> +++ b/lib/raid/xor/x86/xor-avx.c
> @@ -147,6 +147,7 @@ static void xor_gen_avx(void *dest, void **srcs, unsi=
gned int src_cnt,
>  {
>  	kernel_fpu_begin();
>  	xor_gen_avx_inner(dest, srcs, src_cnt, bytes);
> +	asm volatile("vzeroupper");
>  	kernel_fpu_end();

[Severity: High]
This is a pre-existing issue, but this fix appears incomplete. While this
solves the missing vzeroupper in xor_gen_avx(), are there other parallel
AVX2/AVX-512 RAID6 and crypto implementations that suffer from this same
AVX-to-SSE transition penalty?

For instance, raid6_avx21_gen_syndrome() in lib/raid/raid6/x86/avx2.c and
raid6_avx5121_gen_syndrome() in lib/raid/raid6/x86/avx512.c both heavily use
YMM/ZMM registers but call kernel_fpu_end() without clearing the upper
halves:

lib/raid/raid6/x86/avx2.c:raid6_avx21_gen_syndrome() {
	...
	asm volatile("sfence" : : : "memory");
	kernel_fpu_end();
}

Similarly, raid6_2data_recov_avx2() in lib/raid/raid6/x86/recov_avx2.c
returns without executing vzeroupper:

lib/raid/raid6/x86/recov_avx2.c:raid6_2data_recov_avx2() {
	...
	kernel_fpu_end();
}

Also outside the RAID subsystem, routines like __aria_aesni_avx2_crypt_32wa=
y()
in arch/x86/crypto/aria-aesni-avx2-asm_64.S seem to have the exact same
omission:

arch/x86/crypto/aria-aesni-avx2-asm_64.S:__aria_aesni_avx2_crypt_32way() {
	...
	FRAME_END
	RET;
}

Could these functions also leave the CPU in a dirty AVX state and cause
severe performance regressions for subsequent legacy SSE instructions?

>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260831212248.2138=
05-1-ebiggers@kernel.org?part=3D1
