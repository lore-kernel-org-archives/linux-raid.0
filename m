Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2097F37207D
	for <linux-raid@vger.kernel.org>; Mon, 31 Aug 2026 22:12:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788214358; cv=none; b=Ff3KKjyLCc2M0fIXaAxP7NnflQeztOCZv6goKvoTOmbiVKA1bDWZBIwcrUYn+LnoPefRYpdwn97et8pj5ksIj+NZLK1CnPEJ908izfRfNW+scmLycNft6K+cPPotFxoGusZLONfpUGt5PFQALmWNBz7Qf2u5ZK0O2fpbyCaFIlc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788214358; c=relaxed/simple;
	bh=/X6D3tRcVXC47VkkuIKOpvhuUvOw4npldcZjTFQhBDA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Fp/0a3swDAVT7048+W+5mF5JzqF7WrkbF1X69rUaxKJT+pkGsoiNxUNwTIwXDXqmilyL7Wwf50Tj32U+ISK3by0UdDN1E67nC5nLdluKP+cGxmhlQdmJuSeYXaVh7m8aOOFqJrRlVCNhlFX1OgrfeMNRz3Va+cvc49E13pqnZtM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cR/Q67K/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cR/Q67K/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC9311F000E9;
	Mon, 31 Aug 2026 22:12:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788214357;
	bh=T1lytSezJkIJ7rD01Y4GXFaXY/df/1Ei5OmF2O6jDVI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=cR/Q67K/nN6z7zJIJGO7+ppnaY+NhH56gCwKKl4kC6fjSkGIEx3+k+vECtQNcReJ+
	 mmuTyUVHpv+DWKJW3LO/ynqNcgFxeQM6QqxrVavzQyvhCzlem9Osl/KXfmmOeqki+G
	 Gn6Oqbmg12j1Fujfo2DBZdT37o5YHnuaxrDZUQ565qxhkXNYP/Jgl+gSJZTO/9jB41
	 ceqjaYdf7rjiWdIgTc15WlssTvS3IZeFGi16rTAjfbXZM4bEPS42pICnEGJMBkSjt0
	 5Lanb7b+DBd1EOUxeOyvuBV6pKwmOAi2bRePL4QAWdmnVb3ZmyA1gsNdXVSSwjf29c
	 d6qa3vzb97gRA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RESEND] raid6: add missing vzeroupper to AVX2 code
Reply-To: sashiko-reviews@lists.linux.dev
To: "Eric Biggers" <ebiggers@kernel.org>
Cc: linux-raid@vger.kernel.org, yukuai@fygo.io
In-Reply-To: <20260831212308.213855-1-ebiggers@kernel.org>
References: <20260831212308.213855-1-ebiggers@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 31 Aug 2026 22:12:36 +0000
Message-Id: <20260831221236.DC9311F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] The patch adds `vzeroupper` to AVX2 functions to avoid AVX-to-SSE =
transition penalties, but fails to apply the same necessary fix to the corr=
esponding AVX-512 functions which suffer from the exact same issue.
--

commit 51aca22e4c3be53f90a7f330d0ca103da02290ab
Author: Eric Biggers <ebiggers@kernel.org>

raid6: add missing vzeroupper to AVX2 code

This patch adds the vzeroupper instruction to the AVX2 optimized RAID6
code before returning. This prevents degrading the performance of
subsequent legacy SSE code by avoiding hardware transition penalties.

> diff --git a/lib/raid/raid6/x86/avx2.c b/lib/raid/raid6/x86/avx2.c
> index 7d829c669ea79..3cc2fe7ac42c5 100644
> --- a/lib/raid/raid6/x86/avx2.c
> +++ b/lib/raid/raid6/x86/avx2.c
> @@ -67,6 +67,7 @@ static void raid6_avx21_gen_syndrome(int disks, size_t =
bytes, void **ptrs)
>  	}
> =20
>  	asm volatile("sfence" : : : "memory");
> +	asm volatile("vzeroupper");

[Severity: High]
This isn't a bug introduced by this patch, but do the AVX-512 versions of
this code need the same fix?

In lib/raid/raid6/x86/avx512.c:raid6_avx5121_gen_syndrome():

	asm volatile("sfence" : : : "memory");
	kernel_fpu_end();

And in lib/raid/raid6/x86/recov_avx512.c:raid6_2data_recov_avx512():

	}

	kernel_fpu_end();

The AVX-512 syndrome generation and recovery functions exit leaving ZMM
registers dirty without calling vzeroupper. Without vzeroupper after using
ZMM0-ZMM15 registers, the CPU remains in a dirty upper state. This flaw
appears to be mirrored across all AVX-512 functions in these files.

If subsequent kernel code on the same CPU core executes legacy 128-bit SSE
instructions before the state is cleared, could this cause severe hardware
transition penalties that degrade overall crypto or networking performance
and cause a performance regression?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260831212308.2138=
55-1-ebiggers@kernel.org?part=3D1
