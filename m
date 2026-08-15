Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C026964AA4
	for <linux-raid@vger.kernel.org>; Sat, 15 Aug 2026 21:08:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786828119; cv=none; b=ewydsQRHbSKZRegfisCKOdEjPUFbPCpXkd1xd976LdzG547njRkraVif4Rf61R8mUfr2RTNk+CHuVUB/xIlusStkanB8PJYb1Nbija3ZkE8XUJK9XtrEMkv++4sMdrhXiNz46ixXhGO5Byv47/b6ut1JwbdO0/jlLOtBN/XKuwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786828119; c=relaxed/simple;
	bh=96OxcIjjnaT87pMVvb7fSLNizfymqQDlvbjtKgu4NaQ=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=dmoREEkCl3+yN+d8T5yaxFOcYm4tQypr8ltMV6LTJgwVx9sPp8yDLVEV3vcCYDPkJhpViKoMtuz2uoG49bSIsAKZbKcZsguzlg+/44ts+7eArjNY//t9QJaL9snJKGVwZbnPEzXkUp9cGiwRZpudJMTVH9FWFmSgb0TwK6Xy6HY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Rlt+6RAG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Rlt+6RAG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C58041F000E9;
	Sat, 15 Aug 2026 21:08:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786828118;
	bh=rWS+yDyK4OhhrqtQJTw4XTJIMuOO7AJNSPrQeT4vC/4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Rlt+6RAGMjaDKlOGfIHtKTLooFMnVWcOVTHGvxZPB2xYaNzD4cMfP0BwfcnE0D5hr
	 eujw47Wgm/gY6z0qaT95PIKbjHNquJbmh7Si3+80ySxAdggtc6YhKpIywmJIpfPUYv
	 LbPh35Z0w3aWsWUjqPyYu6QIcTov7Ae6I9RMP9SYVIFeZ+laP9gRcGlEex4MEsoZbp
	 tmZizuaevxa0DO1ypkz6wDguY7zDLOYJrTqhEKq7QLWsxJ2NQZS9OUI5ygb2wUBnNk
	 bzRkg7LJqTP1nvwImtZ1z2NwP4qgpGvvSkZCGNFH12GPrwBWaG9qcZqPdSzeoVVxsk
	 1+bqibkSTBkWQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 4/6] crypto: x86/aria - add missing vzeroupper in AVX2
 code
Reply-To: sashiko-reviews@lists.linux.dev
To: "Eric Biggers" <ebiggers@kernel.org>
Cc: linux-raid@vger.kernel.org, yukuai@fygo.io
In-Reply-To: <20260815205750.169336-5-ebiggers@kernel.org>
References: <20260815205750.169336-1-ebiggers@kernel.org>
 <20260815205750.169336-5-ebiggers@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 15 Aug 2026 21:08:37 +0000
Message-Id: <20260815210837.C58041F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Missing `vzeroupper` in the AVX-512 optimized ARIA code (`aria-gfn=
i-avx512-asm_64.S`), causing a significant performance regression due to AV=
X-SSE transition penalties. This problem wasn't introduced by this patch, b=
ut the patch fixes the exact same issue in the AVX2 implementation while mi=
ssing the AVX-512 code.
--

--- Patch [4]: [PATCH 4/6] crypto: x86/aria - add missing vzeroupper in AVX=
2 code ---
commit 92a2e79950d33a63291c62ee57a893ce808d68d2
Author: Eric Biggers <ebiggers@kernel.org>

crypto: x86/aria - add missing vzeroupper in AVX2 code

This commit adds missing vzeroupper instructions to the AVX2 ARIA assembly
code. This prevents performance degradation for any later SSE code that mig=
ht
be executed by avoiding transition penalties from the YMM registers being l=
eft
in a dirty state.

> diff --git a/arch/x86/crypto/aria-aesni-avx2-asm_64.S b/arch/x86/crypto/a=
ria-aesni-avx2-asm_64.S
> index ed53d4f46bd7c..fda8cb8a99a8a 100644
> --- a/arch/x86/crypto/aria-aesni-avx2-asm_64.S
> +++ b/arch/x86/crypto/aria-aesni-avx2-asm_64.S
[ ... ]
> @@ -1428,6 +1433,7 @@ SYM_TYPED_FUNC_START(aria_aesni_avx2_gfni_ctr_crypt=
_32way)
>  		     %ymm8, %ymm9, %ymm10, %ymm11, %ymm12, %ymm13, %ymm14,
>  		     %ymm15, %r10);
> =20
> +	vzeroupper;
>  	FRAME_END
>  	RET;
>  SYM_FUNC_END(aria_aesni_avx2_gfni_ctr_crypt_32way)

[Severity: High]
This is a pre-existing issue, but does the AVX-512 ARIA code also need the
same fix?

Looking at arch/x86/crypto/aria-gfni-avx512-asm_64.S, the AVX-512 optimized
functions like aria_gfni_avx512_encrypt_64way(),
aria_gfni_avx512_decrypt_64way(), and aria_gfni_avx512_ctr_crypt_64way()
return without executing vzeroupper:

arch/x86/crypto/aria-gfni-avx512-asm_64.S:aria_gfni_avx512_encrypt_64way() {
    ...
	FRAME_END
	RET;
SYM_FUNC_END(aria_gfni_avx512_encrypt_64way)
}

Since zmm registers are used, wouldn't returning without clearing the EVEX
dirty state cause the same performance transition penalties for subsequent
legacy SSE code?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260815205750.1693=
36-1-ebiggers@kernel.org?part=3D4
