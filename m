Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6308184
	for <linux-raid@vger.kernel.org>; Thu, 13 Aug 2026 02:39:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786588791; cv=none; b=WU3Np84TskHl3KevBzsf9vzQzKvFgy0Voo5TAWf2+S6UyGqaifreg9XdjdSLLieoy45nXLwus2IS1UZ9yq26+hgDAOSlmKZmyPUmyxa+ddgllpT06LzXIkPUD+wrHbtUbDaQO5G4w+Og9Wkhhu0YkGqbdBFU6z2fMju4cw6rEN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786588791; c=relaxed/simple;
	bh=y9gWj/1axNj+moIDqty//A5KHcgCsK3Y/kRJC8+1lDw=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=FL7cVs2ls7AmMg35xkWhzYcB/vmsfR8rkaZVeBrgoQGTIZBv1BpMKkNJ1Ht0COtxsuu+4JdzqsAIcfcyoNGviwdvaWGHVA5Rs/hqqFmAeOg4jOiNVQNpSqcmMkjp4E13o8GmoyuO/dWzQyEtvLn0esO3dLSXIGFDFwBSv5iynOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PqbN+4/8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PqbN+4/8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A1311F000E9;
	Thu, 13 Aug 2026 02:39:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786588790;
	bh=F7iix624OzM9s9Eq5DbOBam72mRXCzwEaIEj07un5Nw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=PqbN+4/81iAB+OfJIs2aso8kG4AKka7Cr3sBn6TwkNdtY9Q++IEvHyvtVa408aVDm
	 TXsulTkA1qCy9A51wh3JmE5/cuyCF4KAm2ZMvTlud7MIiF9tj9AXHliYs9JBcbAvtp
	 TqfDqkxkMN7d4ZaKVm+zZnSmqr+XXO95KXsYJoWxH5NFAhkCEuc8MjLY1jv3m+epCh
	 081H0cbZe7tGkXoWo9XV/mUaSgCS10b0ZSXZdlYkubaMIb+z4tdpd0lIDo1zMGLdxS
	 oo1j8T6C6RsZWUwZxeiJiWbpj0co571mtnHYXxMxVZVllI0vv400VVbx8ZeaUs4E0x
	 Nz/y7cnr+fUWA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 8/8] xor: Add AVX-512 optimized xor_gen()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Eric Biggers" <ebiggers@kernel.org>
Cc: linux-raid@vger.kernel.org, yukuai@fygo.io
In-Reply-To: <20260813021506.55129-9-ebiggers@kernel.org>
References: <20260813021506.55129-1-ebiggers@kernel.org>
 <20260813021506.55129-9-ebiggers@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 13 Aug 2026 02:39:49 +0000
Message-Id: <20260813023950.4A1311F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] Missing `vzeroupper` instruction after using AVX-512 (ZMM) regis=
ters, leading to severe AVX-to-SSE transition penalties in kernel threads.
--

--- Patch [8]: [PATCH v3 8/8] xor: Add AVX-512 optimized xor_gen() ---
commit 0074b2adffd00d86b2a03e4d30495b21794ecb20
Author: Eric Biggers <ebiggers@kernel.org>

xor: Add AVX-512 optimized xor_gen()

This commit introduces an AVX-512 optimized implementation of xor_gen()
using 512-bit ZMM registers and the vpternlogq instruction. It is enabled
on x86_64 CPUs with AVX512F that do not have the PREFER_YMM feature set.

> diff --git a/lib/raid/xor/x86/xor-avx512.c b/lib/raid/xor/x86/xor-avx512.c
> new file mode 100644
> index 0000000000000..17f57900d8274
> --- /dev/null
> +++ b/lib/raid/xor/x86/xor-avx512.c
[ ... ]
> +static void xor_gen_avx512(void *dest, void **srcs, unsigned int src_cnt,
> +			   unsigned int bytes)
> +{
> +	kernel_fpu_begin();
> +	xor_gen_avx512_inner(dest, srcs, src_cnt, bytes);

[Severity: Medium]
Does this code need a vzeroupper instruction before releasing the FPU to av=
oid
AVX-to-SSE transition penalties? If a kernel thread modifies the ZMM regist=
ers
here and subsequently executes legacy SSE instructions (for example, in kcr=
yptd)
without an intervening user-space context switch to clear the state, the CPU
could incur a severe transition penalty on affected architectures.

While this problem already existed in the xor-avx.c implementation using YMM
registers, the newly introduced xor-avx512.c appears to repeat the defect.

> +	kernel_fpu_end();
> +}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260813021506.5512=
9-1-ebiggers@kernel.org?part=3D8
