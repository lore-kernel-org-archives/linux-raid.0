Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AFCC3B14C0
	for <linux-raid@vger.kernel.org>; Mon, 31 Aug 2026 22:07:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788214076; cv=none; b=U01SqmODJIuEGKDRfYQ27UgPU8SXzUyBtAn1TPs3Dtf6FJR0pzafdQ5RW0l/7qS+IOY8mwEWPXwDiNBmxIIX7Hpe1GlsunZzjXh+D01zBm/Ki8LVyzTXirKVFEom6qQ6oNauiHPFaOFgmI3IBPx0lwJtWN78PeVdcSPL4UKWwq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788214076; c=relaxed/simple;
	bh=1RZSSU9vGw6hvspEaQGrTaS4FuPpUeRzgnRLtq8T5wc=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=OrTiZ7GqufFUq4ntQ4+Bmmi5bOoK4eq74tBpNVPIaSq+w4kgNk/4t9zi1UdZFOW0ZVMmg2p6D2iMLXtYiEdcp6tPk6cwWeM6DGiyaNoBxzQ1fBBDnGBHuLgSnFMd0Q9OYeAw9d6jsr16fR9b52SEcxosjVeiFumxyG7G0shOMC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JWOXivX+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JWOXivX+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CD601F000E9;
	Mon, 31 Aug 2026 22:07:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788214074;
	bh=sWh9hHpUzijjA37ZlXlU3UvabC5+bAVVosmk780+7sw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=JWOXivX+zDWLwsJarm6OfcaoJGALYc6NMjbLIZ5vIxaXtgsN5ycx+jIfmNwACIEdz
	 O0kXqAiJsJ0CnwXq2V2JqrofoHYedSDjWeGabPKf/g0lpYHM/V0DCYLZWPkRtyTRTQ
	 Fl5T+i7GC6Bq69N+F1yc5SzF7efbGYa9b8moBegbpge22Kj9VCf/7KpK3ey25j5eCo
	 MF3Y4j8Lx2/6JecV0/NKUTrl4xL7g8krZtvfbXoYYrCIxURNyNgvzln3Y9beZAuzGv
	 hhY+9cSDYJhu8CWH4r95iam5RJ3k3SltoaZq3pa3RUD9VpxJZFF0cQvjaxok8H4cEI
	 CP7jQZEbWzfFw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RESEND] raid6: add missing vzeroupper to AVX-512 code
Reply-To: sashiko-reviews@lists.linux.dev
To: "Eric Biggers" <ebiggers@kernel.org>
Cc: yukuai@fygo.io, linux-raid@vger.kernel.org
In-Reply-To: <20260831212316.213896-1-ebiggers@kernel.org>
References: <20260831212316.213896-1-ebiggers@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 31 Aug 2026 22:07:54 +0000
Message-Id: <20260831220754.8CD601F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Missing `vzeroupper` in AVX and AVX2 RAID6 and XOR implementations
- [High] Missing `vzeroupper` in ARIA GFNI AVX512 crypto routines
--

commit c86f8a80ee519a29f4ac71611d625cca2868db38
Author: Eric Biggers <ebiggers@kernel.org>
raid6: add missing vzeroupper to AVX-512 code

This commit adds vzeroupper to the AVX-512 optimized RAID6 routines before
returning, preventing performance degradation of subsequent SSE code.

> diff --git a/lib/raid/raid6/x86/avx512.c b/lib/raid/raid6/x86/avx512.c
> --- a/lib/raid/raid6/x86/avx512.c
> +++ b/lib/raid/raid6/x86/avx512.c
> @@ -78,6 +78,7 @@ static void raid6_avx5121_gen_syndrome(int disks, size_=
t bytes, void **ptrs)
>  	}
> =20
>  	asm volatile("sfence" : : : "memory");
> +	asm volatile("vzeroupper");
>  	kernel_fpu_end();
>  }

[Severity: High]
This is a pre-existing issue, but does this incomplete fix also need to
address the conceptually identical AVX/AVX2 implementations?

For example, in lib/raid/raid6/x86/avx2.c:raid6_avx21_gen_syndrome():

	asm volatile("sfence" : : : "memory");
	kernel_fpu_end();

And similarly in lib/raid/raid6/x86/recov_avx2.c:raid6_2data_recov_avx2()
and lib/raid/xor/x86/xor-avx.c:xor_gen_avx(). These routines use YMM
registers but return to other kernel paths without clearing the upper state.

[Severity: High]
This isn't a bug introduced by this patch, but are there other areas in the
kernel that need a similar fix? For example, in the crypto subsystem, the
ARIA GFNI AVX512 routines dirty ZMM registers but omit the vzeroupper.

arch/x86/crypto/aria_gfni_avx512_glue.c:aria_avx512_ctr_encrypt():

			kernel_fpu_begin();
			aria_ops.aria_ctr_crypt_64way(ctx, dst, src,
						      &req_ctx->keystream[0],
						      walk.iv);
			kernel_fpu_end();

And in arch/x86/crypto/aria-gfni-avx512-asm_64.S:aria_gfni_avx512_encrypt_6=
4way(),
the assembly implementation returns without issuing a vzeroupper to clear
the upper state of the ZMM registers.

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260831212316.2138=
96-1-ebiggers@kernel.org?part=3D1
