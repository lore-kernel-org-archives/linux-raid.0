Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE68124A076
	for <linux-raid@vger.kernel.org>; Fri, 26 Jun 2026 04:53:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782449603; cv=none; b=BfaFw7iyOUTSA3ZqNCFuGH7JDRPq1lC4tnXk4IQqr0CgF3k8kIkJrfggJTt5QuFX4UO8yTejqhaSGAOSFfARoNW1Gzr1S+7QXK0YiFUiwE2WcZmHY35mtEd7Mfslr4Z7wXwmUJWsxVMcnj5eGRo6hx3CVzk8V4S3qJZP6BToPCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782449603; c=relaxed/simple;
	bh=k/Q9NgUwobuBtsJ7/gm2cChjV/k9E6fK6C38KIPRkPE=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=tWCiYAPiFzsDEZWjo3lk/MwyILf+3+qLYE0A+SPcxcoiG+tHl0FrkzBhIXHsllZ0BcxLlrYwlo9nTbggsLsYhJ0sZo2GfSg4w1ySGDIy+mlfgIf5KTtT2burHNSQ99oTfxmdt+TKnhSAxl2e+dks+UmVyM1k+shIVsC0hwyjv6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=m6r22cmi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="m6r22cmi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 591EE1F000E9;
	Fri, 26 Jun 2026 04:53:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782449602;
	bh=lk7/ai3NbhOIYFoj7nakggerMAXgndzARsRMYeeiPKM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=m6r22cmikRv3ZA+b2S/N8KRtUgqGRG3LMpyducqZyRYaqEIeQQ97gAa1VyVMWQI7y
	 DyQAxh7oDvQyYUB3AIhh/iTYDHLYHuFWdbyvXlT2cPB4hjUFjfm5lx2BP52YeSAVWz
	 7fX08PWyYAa7Mtxv9NXhnDYGymE3HX8a64oVnDJh2zXgQBjDHOzmiZbhlhZlAMjZfV
	 znM/hn0Pfia2oiNRocDKBaIS0ZHIy6oetNQsLVz8C9s+vimKoNjDvB+kdYm8NUowHw
	 IpxVpU83NwcwHCkFZeHBEZiINcbMl5f6RRQ2Z+/Tz5npjhmFzoqCHkmb6OP+/z6Cbm
	 5XjjVRaj8nFLg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 4/8] lib/crypto: x86: Stop using cpu_has_xfeatures()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Eric Biggers" <ebiggers@kernel.org>
Cc: linux-raid@vger.kernel.org, yukuai@fygo.io
In-Reply-To: <20260626043731.319287-5-ebiggers@kernel.org>
References: <20260626043731.319287-1-ebiggers@kernel.org>
 <20260626043731.319287-5-ebiggers@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 26 Jun 2026 04:53:21 +0000
Message-Id: <20260626045322.591EE1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] Removing `cpu_has_xfeatures()` causes a kernel #UD panic on system=
s advertising AVX without XSAVE.
--

commit c4725d088a9c170c27e417f42ccdfa48f567b845
Author: Eric Biggers <ebiggers@kernel.org>

lib/crypto: x86: Stop using cpu_has_xfeatures()

This commit removes calls to cpu_has_xfeatures() across the x86 crypto=20
library, relying entirely on boot_cpu_has() to check for features. The=20
assumption is that x86 explicitly clears AVX and AVX-512 flags if their=20
xfeatures are missing.

> diff --git a/lib/crypto/x86/poly1305.h b/lib/crypto/x86/poly1305.h
> index ee92e3740a787..b061b9926fa5d 100644
> --- a/lib/crypto/x86/poly1305.h
> +++ b/lib/crypto/x86/poly1305.h
> @@ -143,15 +143,12 @@ static void poly1305_emit(const struct poly1305_sta=
te *ctx,
>  #define poly1305_mod_init_arch poly1305_mod_init_arch
>  static void poly1305_mod_init_arch(void)
>  {
> -	if (boot_cpu_has(X86_FEATURE_AVX) &&
> -	    cpu_has_xfeatures(XFEATURE_MASK_SSE | XFEATURE_MASK_YMM, NULL))
> +	if (boot_cpu_has(X86_FEATURE_AVX))
>  		static_branch_enable(&poly1305_use_avx);

[Severity: High]
Will this cause a invalid opcode panic on systems advertising AVX without X=
SAVE
such as virtualized environments using a missing xsave cpu flag?

If XSAVE is missing natively, fpu__init_system_xstate() in
arch/x86/kernel/fpu/xstate.c returns early without clearing features:

arch/x86/kernel/fpu/xstate.c:fpu__init_system_xstate() {
        ...
        if (!boot_cpu_has(X86_FEATURE_XSAVE)) {
                pr_info("x86/fpu: x87 FPU will use %s\n",
                        boot_cpu_has(X86_FEATURE_FXSR) ? "FXSAVE" : "FSAVE"=
);
                return;
        }
        ...
}

This early return bypasses clear_cpu_caps_with_missing_xfeatures(). Since
the CPUID dependency enforcement is only triggered when a feature is explic=
itly
cleared, X86_FEATURE_AVX is never cleared in this specific situation.

Without the cpu_has_xfeatures() check here, the crypto subsystems will see
boot_cpu_has(X86_FEATURE_AVX) as true and enable AVX instructions. Because
XSAVE is disabled, the OS never sets CR4.OSXSAVE=3D1, which can lead to a p=
anic
when AVX instructions subsequently execute.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260626043731.3192=
87-1-ebiggers@kernel.org?part=3D4
