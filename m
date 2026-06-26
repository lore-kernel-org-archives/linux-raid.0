Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA98C24A076
	for <linux-raid@vger.kernel.org>; Fri, 26 Jun 2026 04:51:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782449512; cv=none; b=cRcsQFdoFsWrNRnQLQFxyX1a8VZ6rqsml/PzClrrO/RX+5H1Oc0KNTVwuKcDbMU3BrCfc/ZmU4Vc17xirn3Q6RFVi2y207kNJMqKzZlfD2faOXPXF/cujY4sVdWv+IpGIBBcPABi6SbMt3ekvJ4av3SdBzuJYXwbw4e43XcLeB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782449512; c=relaxed/simple;
	bh=tHLd/W0U9nCdrYWfT0hM/jqrAwPc5BSdYyauQVWAcXQ=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=DtNpFQRaHIJ1zLqBuLTt4Uht/UeDEcuiTx2OuSCUjxgyrWSyqhole3pEQtm4TpihXM0xYbN4fZj/6mkztK/TbQDXR0HgFDeG0DDcd47NWosL4VlnyAsaJjaYgAOIbnWZleGUAC3UksBXifGiD4wv1+yjt7MQhxRZYX8ByeJjtTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VnGtDo7+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VnGtDo7+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BE3F1F000E9;
	Fri, 26 Jun 2026 04:51:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782449511;
	bh=Hnup//zU+5KFhMfW+MrjDPTeRTzI6TcBeN4R/iUUpcs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=VnGtDo7+hJiTN+LFl3PpNAIv2/2kkBH4Mx8cwXTMe/AzSpx+zp3yHbVCkMhwjkFFa
	 AWYiZZxFqE+AhtbFL1rAitb6sJ4EXhrKvVO9/xGSnzszjtX5GBieI4RFHZAy4MsSCB
	 7XB87OvO036Qz8g5aF73iWvBL1DPYkTBKDKGi4QS++2c5qFZQSU0Dqd5R1w3nBgxb6
	 tspCEFJSzIRel0/E1jevLvFhEY7RVBCZCFWL8yWk77YycIWDUsEdIIVahYGUzJxZyi
	 YqPAd7txPAydCm0mNnhO8jAxgqAqkOYy8P0YES1SkDA4v/xjsOm9XQ3VFLSXvNxZu8
	 IEXyz7kMAd50g==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 7/8] lib/raid/xor: x86: Remove redundant
 X86_FEATURE_OSXSAVE check
Reply-To: sashiko-reviews@lists.linux.dev
To: "Eric Biggers" <ebiggers@kernel.org>
Cc: linux-raid@vger.kernel.org, yukuai@fygo.io
In-Reply-To: <20260626043731.319287-8-ebiggers@kernel.org>
References: <20260626043731.319287-1-ebiggers@kernel.org>
 <20260626043731.319287-8-ebiggers@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 26 Jun 2026 04:51:50 +0000
Message-Id: <20260626045151.3BE3F1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] Removing the X86_FEATURE_OSXSAVE check can cause an Invalid Opcode=
 (#UD) kernel panic during XOR RAID operations if the CPU natively advertis=
es AVX but not XSAVE.
--

commit 6fce8e80966a4c49b0b494779bd6206c6d6bed1f
Author: Eric Biggers <ebiggers@kernel.org>

lib/raid/xor: x86: Remove redundant X86_FEATURE_OSXSAVE check

This commit removes the X86_FEATURE_OSXSAVE check when selecting the AVX
XOR implementation, assuming X86_FEATURE_AVX implies X86_FEATURE_OSXSAVE.

> diff --git a/lib/raid/xor/x86/xor_arch.h b/lib/raid/xor/x86/xor_arch.h
> index 99fe85a213c66..991abe3f4bbda 100644
> --- a/lib/raid/xor/x86/xor_arch.h
> +++ b/lib/raid/xor/x86/xor_arch.h
> @@ -18,8 +18,7 @@ extern struct xor_block_template xor_block_avx;
>   */
>  static __always_inline void __init arch_xor_init(void)
>  {
> -	if (boot_cpu_has(X86_FEATURE_AVX) &&
> -	    boot_cpu_has(X86_FEATURE_OSXSAVE)) {
> +	if (boot_cpu_has(X86_FEATURE_AVX)) {
[Severity: High]
Can this lead to an Invalid Opcode (#UD) kernel panic during XOR RAID
operations if a CPU advertises AVX but not XSAVE?

If a hypervisor exposes AVX but hides XSAVE (for example, using QEMU's
-cpu host,-xsave flag), get_cpu_cap() still sets X86_FEATURE_AVX in
boot_cpu_data.

Although check_cpufeature_deps() detects the missing dependency, it only
issues a pr_warn_once warning without actually clearing X86_FEATURE_AVX.

During boot, fpu__init_system_xstate() evaluates
!boot_cpu_has(X86_FEATURE_XSAVE) as true and executes an early return.
This early return bypasses clear_cpu_caps_with_missing_xfeatures(), meaning
X86_FEATURE_AVX is never cleared by the kernel.

Since the X86_FEATURE_OSXSAVE check was removed here, arch_xor_init()
will forcibly select xor_block_avx based solely on X86_FEATURE_AVX.
When VEX-encoded AVX instructions are later executed, the CPU will throw an
Invalid Opcode (#UD) exception because CR4.OSXSAVE was never set to 1 by
the OS.

Is there another mechanism that guarantees X86_FEATURE_AVX is cleared in
this scenario, or should the X86_FEATURE_OSXSAVE check be retained to safely
ensure the OS has fully initialized and enabled XSAVE?

>  		xor_force(&xor_block_avx);
>  	} else if (IS_ENABLED(CONFIG_X86_64) || boot_cpu_has(X86_FEATURE_XMM)) {
>  		xor_register(&xor_block_sse);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260626043731.3192=
87-1-ebiggers@kernel.org?part=3D7
