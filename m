Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 867FC10F2
	for <linux-raid@vger.kernel.org>; Tue, 28 Jul 2026 02:37:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785206255; cv=none; b=urYvu1s37HvtVzRUZfBw5vEcCDoLxAT6YUwoDUAbmsnyHJZYIJmk0RhN6k80q7VaTKB8h+LPGttmeNFt7BuUoPNkbfuGgZj+ju23MqC7xERiXI9AP8q429jdg4wAAS/FYqjzdWSZHjgvf5tUUMZRs9x06NyIoB6kFLgCPh+Y9tQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785206255; c=relaxed/simple;
	bh=4b63MkQ6SmCxwX8TS53+MrHmnYfu1KNlAPNDiPCBVSk=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=AR0nKVdx5cN6mZh7dtAkeTMtIhzyrbMT4MaeQLfh0isZPZJ/cwCDzLPFHnyHQwupOl3AV78eVadfK6QV/cFG4fslXlVfc3Ctvc2ccLusprfyho8wztnGTg5R1VjR2mQD+Lbn91UwjgI5cKnlEJ0nkBTVMOF35TPvpjfPzLsxOpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PhHSqWtV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PhHSqWtV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1EC81F000E9;
	Tue, 28 Jul 2026 02:37:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785206254;
	bh=r73oIS5verClDeb8aA5OabHVz6GiQ40PmCfrch19wYE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=PhHSqWtVQwXqoP4wyrKCi7JaeT4yyU4pplJNhUsUBVaCs3RnYL5UvLMpYTZgEORrG
	 BZ9v3BSt9t7mBkHQLWdI76T9p3VtYpLeuTJBnyZYaWaM5BqZ0xL8P6Fbzg69+J/EN1
	 L28PjX9FzjPu85h5fd+Y9MVA9Taf849CJF1dVGdaB78cThApq5SSvTAW/wsUVK2y7V
	 RsAaYhwoKGB51E3t2V1NnkYzCxDS4Ah8UfQuOSJJBRw9mJW73QgEOlLxEXovvDt97J
	 AM7uhuqndW4UagblWslClx3Wn2ac5VwjS5j9xrEpUV26kfJeApLWQj4c5CR24qrsku
	 3S+xYxkJdoPsg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 2/8] um: Check for missing AVX and AVX-512 xstate
 bits
Reply-To: sashiko-reviews@lists.linux.dev
To: "Eric Biggers" <ebiggers@kernel.org>
Cc: linux-raid@vger.kernel.org, yukuai@fygo.io
In-Reply-To: <20260728021603.79870-3-ebiggers@kernel.org>
References: <20260728021603.79870-1-ebiggers@kernel.org>
 <20260728021603.79870-3-ebiggers@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 28 Jul 2026 02:37:33 +0000
Message-Id: <20260728023733.C1EC81F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

New issues:
- [High] Incomplete XCR0 validation whitelist allows AVX-dependent and AMX =
features to bypass state checks, causing guest application crashes.

Pre-existing issues:
- [High] Substring matching flaw in `parse_host_cpu_flags()` incorrectly en=
ables CPU features, leading to application crashes.
--

--- Patch [2]: [PATCH v2 2/8] um: Check for missing AVX and AVX-512 xstate =
bits ---
commit 14fa8af6eb070800589e8e98d9a0ba3804acb926
Author: Eric Biggers <ebiggers@kernel.org>

um: Check for missing AVX and AVX-512 xstate bits

This patch checks if the CPU declares AVX or AVX-512 support and verifies
that the corresponding bits are set in the XCR0 register. If missing, it
warns and does not set the X86_FEATURE_* flags.

> diff --git a/arch/um/kernel/um_arch.c b/arch/um/kernel/um_arch.c
> index 2141f5f1f5a20..aafbaef2ae82f 100644
> --- a/arch/um/kernel/um_arch.c
> +++ b/arch/um/kernel/um_arch.c
[ ... ]
> @@ -264,12 +264,88 @@ unsigned long brk_start;
[ ... ]
> +static void __init validate_and_set_cpu_cap(int cap, u64 xcr0)
> +{
> +	/*
> +	 * Check for missing xstate features right away, so that there's no
> +	 * perceived need for all optimized code in the kernel to do so.
> +	 */
> +	switch (cap) {
> +	case X86_FEATURE_AVX:
> +	case X86_FEATURE_AVX2:

[Severity: High]
Will this switch statement inadvertently bypass state checks for features l=
ike
X86_FEATURE_AMX_TILE, X86_FEATURE_F16C, X86_FEATURE_XOP, and
X86_FEATURE_FMA4?

If these features are missing from the switch cases, they will fall through
and be unconditionally enabled at the end of the function. If the host CPU
supports AMX, UML will advertise amx_tile. If a guest application attempts
to use it without the UML process calling prctl(ARCH_REQ_XCOMP_PERM), the
host will send SIGILL.

A similar #UD crash could occur for f16c, fma4, or xop if host AVX XCR0
state is disabled but the features are not cleared by the host.

> +	case X86_FEATURE_AVX_VNNI:
> +	case X86_FEATURE_FMA:
[ ... ]
> +		break;
> +	}
> +	set_cpu_cap(&boot_cpu_data, cap);
> +}
> +
>  static void __init parse_host_cpu_flags(char *line)
>  {
> +	u64 xcr0 =3D read_xcr0();
>  	int i;
> +
>  	for (i =3D 0; i < 32*NCAPINTS; i++) {
>  		if ((x86_cap_flags[i] !=3D NULL) && strstr(line, x86_cap_flags[i]))
> -			set_cpu_cap(&boot_cpu_data, i);
> +			validate_and_set_cpu_cap(i, xcr0);

[Severity: High]
This is a pre-existing issue, but does this substring match cause false
positive feature detection?

Using strstr without word boundary checks means that if a host CPU supports
fma4 but not fma (like AMD Bulldozer), the string "fma" will match inside
"fma4".

This causes UML to falsely advertise fma to the guest, and guest
applications probing for fma will reliably crash with a #UD exception when
attempting to execute FMA3 instructions.

>  	}
>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260728021603.7987=
0-1-ebiggers@kernel.org?part=3D2
