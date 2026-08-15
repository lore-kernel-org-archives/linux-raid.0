Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7DC929DB6E
	for <linux-raid@vger.kernel.org>; Sat, 15 Aug 2026 21:06:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786827982; cv=none; b=PJH3BgYrcAxq5FrD8DHZB6eYZnHLfR30JcZ0kR3Sb1TcVs4e2YWpm6/XyK/kOXi8DoZ5NPdg88gBG20qoYtUTuNhqTZYs4OBh/yOBn9dD3jbEkrpou6szeufolp2NR6kYS8wy5YQ1JUyEg8zzG6nd8DdpgJeiRufrL5Q9lz1+vk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786827982; c=relaxed/simple;
	bh=A4rL68+V3g7jZ4xm8dlxQIVJXnqbGHOoMpThStQzz34=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=AdFx6AiHgtVdvNLlAfonG1WlQdc5JXZD1z86t6vLKVYTyP2ujWMJayey45AVc6Xl1Zd2YIYRugrZRkxMWi21suSMePce4iOpr0byCMLGHyXqHpg7p58Vit8zBgm66k/omwbPHVAH9a5F5eaNYSv96hR7XqczOLs3BzAG/W668SY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PgAqDVi7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PgAqDVi7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08B211F000E9;
	Sat, 15 Aug 2026 21:06:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786827981;
	bh=iW68YSafU5JvdjrVoWIIAkv0JYtr6iGGLWu5iHZZBpU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=PgAqDVi7+wXFhJraGb9j86/8UO/fHBwvE1dVhxhRPz5Il1CNX/SMpM2vBeCI9oNVt
	 rDkYmYyctB7YrZTEM7znf66gq0xJps/nKI95RJWe1rs0/pvo5G4vqrd/IGx36JZpNH
	 oZvWs4guaAABHRVb+neECjuD16LR9q2a1e1eXYP2cp/5X8Lal/TGizCJ/4VJTFwHCg
	 Ayu4l93IuKxjPWzw6Z8jIUnsadXWYS17UjNZiXBURIGPtwAwkC50tTU/87mwasiRm/
	 8hsVnU5CmKDLMUaV+d2Ki6Rre0vyMn//RPEXrepZjsme+X/7UXZY04O+3J9Shl+66Q
	 08wlrKebaiQWw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 3/6] raid6: add missing vzeroupper to AVX-512 code
Reply-To: sashiko-reviews@lists.linux.dev
To: "Eric Biggers" <ebiggers@kernel.org>
Cc: linux-raid@vger.kernel.org, yukuai@fygo.io
In-Reply-To: <20260815205750.169336-4-ebiggers@kernel.org>
References: <20260815205750.169336-1-ebiggers@kernel.org>
 <20260815205750.169336-4-ebiggers@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 15 Aug 2026 21:06:20 +0000
Message-Id: <20260815210621.08B211F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Undefined behavior in inline assembly due to writing to input oper=
ands.
--

--- Patch [3]: [PATCH 3/6] raid6: add missing vzeroupper to AVX-512 code ---
commit c5b5d02d83bf2abe1380d3036a95bcf38db79ff8
Author: Eric Biggers <ebiggers@kernel.org>

raid6: add missing vzeroupper to AVX-512 code

Since the AVX-512 optimized RAID6 code uses ZMM registers, execute
vzeroupper before returning from it. This is needed to avoid degrading
the performance of any later SSE code that may happen to be executed.

Fixes: e0a491c12968 ("lib/raid6: Add AVX512 optimized gen_syndrome function=
s")
Fixes: 13c520b2993c ("lib/raid6: Add AVX512 optimized recovery functions")
Cc: stable@vger.kernel.org

> diff --git a/lib/raid/raid6/x86/recov_avx512.c b/lib/raid/raid6/x86/recov=
_avx512.c
> index ec72d5a30c01e..299a3f044d616 100644
> --- a/lib/raid/raid6/x86/recov_avx512.c
> +++ b/lib/raid/raid6/x86/recov_avx512.c
> @@ -211,6 +211,7 @@ static void raid6_2data_recov_avx512(int disks, size_=
t bytes, int faila,

[Severity: High]
This is a pre-existing issue, but while reviewing this code, I noticed that
earlier in this function and in raid6_datap_recov_avx512(), the inline
assembly writes to memory operands that are listed only in the input
constraints list.

For example, in raid6_2data_recov_avx512():

		asm volatile("vmovdqa64 %%zmm1, %0\n\t"
			     "vmovdqa64 %%zmm13,%1\n\t"
			     "vpxorq %%zmm1, %%zmm0, %%zmm0\n\t"
			     "vpxorq %%zmm13, %%zmm8, %%zmm8"
			     :
			     : "m" (dq[0]), "m" (dq[64]));

And in raid6_datap_recov_avx512():

		asm volatile("vmovdqa64 %%zmm1, %0\n\t"
			     "vmovdqa64 %%zmm14, %1\n\t"
			     "vmovdqa64 %%zmm2, %2\n\t"
			     "vmovdqa64 %%zmm12,%3"
			     :
			     : "m" (dq[0]), "m" (dq[64]), "m" (p[0]),
			       "m" (p[64]));

Could this cause data corruption or miscompilation?

GCC documentation forbids writing to input operands. If GCC assumes input
operands are unmodified, might it optimize away the writes, cache stale
values, or reorder accesses during RAID6 recovery?

>  #endif
>  	}
> =20
> +	asm volatile("vzeroupper");
>  	kernel_fpu_end();
>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260815205750.1693=
36-1-ebiggers@kernel.org?part=3D3
