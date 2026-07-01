Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F85C126C03;
	Wed,  1 Jul 2026 00:49:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782866966; cv=none; b=Tk+nKMWccqaz4AEgoNrnajEjEUl+Qw1bm+c556MQIgikNNreFi24X8Km3iT/Ad3kgu+/59Oz1fTl14YmINpeojrKz6CvET+z1FrwKICUpA/v8J8d4nIIPVyZOqg83+zENb9T7wfIGwV//TJ6bmnCFb/YkIHO5Y5MH0eXAyzR7I0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782866966; c=relaxed/simple;
	bh=lWVZ7Tul/itbRkqJV4EpvVyTf8+7BsWi8hDgaNWdOyU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qffCy7UK1ZGNLsFjKCzig5ASKNZ36aG9gHpaYsSkITE6EdZVdjEQ3KyY8dTm4eskQ8B6URPR5y1e4eu2LzBscLxisHgILhFv3Xd4cmY+P2APDPgy2SBK87Dt8zDyYox+o5bCx61OhbAQ2OWqIQVMCJO94OXUCPEOfbwiS536a9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=DA9tEczx; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="DA9tEczx"
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 5EC4640E0140;
	Wed,  1 Jul 2026 00:49:23 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id y6TGv14w66I5; Wed,  1 Jul 2026 00:49:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1782866953; bh=SyThy7tS7xMbhdArT/LoJGc0WPj3c7HgQ0ERzvqr1u0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DA9tEczx//ACvseSssAsLo5xdkpuCVtE+oVqM8E5otyjluxK65w8X1aJ+4BpGPAfo
	 aKWTEPuB0/zgADeXo/t6nDXNAuBxBq4zXb2VDl0BJoqHKZzIhk26g4Ssf6/9XHJ2DG
	 eYLVQBP6iSHqzc+8uSdgoOmhQ7/yhcN3D2GX4MRZWdIcl29hVwwoVkYP86e8weHU6P
	 YA1FptQ+z2XSAu9vdO4X4wr1U0nRg0kBKsVv078+BxpWWzxLUvXDZIe0Rpr+oFjtkp
	 xVuZ64ugLMq140NjqwL3hcdLa+5pJSoW72m4DZBa+yhP+lK/0bzggYRcGLFNo6mKua
	 ifeA1TP6bVtqiHbEuaF+PpTnRw9RQRGoDMBy822AStoGYsFvmcf0kDYofhMNYdle9r
	 BOaG/TM/Se288sTJh7k3PrxKOJNR8DWyS9590vsG6VHULiqSCSggmHUoMPmaXUqvTO
	 d4BgmNYXt5ioZPCnFdg7RmrdbLNeEPiWKqsoCZyRk2C3oM/7mJfr4yEgI11sRvcyag
	 Yh3S1vO23oGvGTQpm0tTjCvK0uxXBeKjaZzsWbuZ6pavT6RqIgsRH7EbrDPUOBQXyC
	 VJg6wkTKwV+0BOZpGV5T7g5YIQ1s5ctzyr996308SF0U1m/Mf7/cJhgytsg9xuN4Cn
	 kTA3eG5QYmMUPej/kKc/i7jc=
Received: from stx.tnic (unknown [IPv6:2600:1700:38ca:c00::1a])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id CA69E40E00BA;
	Wed,  1 Jul 2026 00:49:07 +0000 (UTC)
Date: Tue, 30 Jun 2026 17:49:04 -0700
From: Borislav Petkov <bp@alien8.de>
To: sashiko-reviews@lists.linux.dev
Cc: Eric Biggers <ebiggers@kernel.org>, linux-raid@vger.kernel.org,
	yukuai@fygo.io, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/8] x86/fpu: Check for missing AVX and AVX-512 xstate
 bits
Message-ID: <20260701004904.GBakRkAEzs5lGvERSZ@fat_crate.local>
References: <20260626043731.319287-1-ebiggers@kernel.org>
 <20260626043731.319287-2-ebiggers@kernel.org>
 <20260626050038.2AD661F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260626050038.2AD661F000E9@smtp.kernel.org>

On Fri, Jun 26, 2026 at 05:00:37AM +0000, sashiko-bot@kernel.org wrote:
> [Severity: Critical]
> This is a pre-existing issue, but Memory Protection Keys (PKU) isolation
> can be bypassed because we don't verify X86_FEATURE_PKU against the
> presence of XFEATURE_PKRU in xstate here.
> 
> If a hypervisor reports X86_FEATURE_PKU in CPUID but masks out the
> XFEATURE_PKRU xstate component, the kernel's setup_pku() enables CR4.PKE
> and forces X86_FEATURE_OSPKE.  Because X86_FEATURE_OSPKE is artificially
> forced, the feature is not cleared.
> 
> CR4.PKE=1 permits userspace to use WRPKRU, but because XCR0.PKRU=0,
> xsaves/xrstors silently ignore the PKRU register during task context
> switches, leading to state leakage across tasks.
> 
> Should we also validate PKU against missing xstate components in this
> function to prevent isolation bypass?

I *think* Sashiko means here our preexisting fpu__init_system_xstate() here
but I'm not sure...

> [Severity: High]
> Does this logic get bypassed if XSAVE or FPU support is missing?
> 
> Earlier in fpu__init_system_xstate(), there are early returns if
> X86_FEATURE_FPU or X86_FEATURE_XSAVE are missing:
> 
> 	if (!boot_cpu_has(X86_FEATURE_XSAVE)) {
> 		pr_info("x86/fpu: x87 FPU will use %s\n",
> 			boot_cpu_has(X86_FEATURE_FXSR) ? "FXSAVE" : "FSAVE");
> 		return;
> 	}
> 
> If a hypervisor natively enumerates AVX=1 but XSAVE=0 (such as QEMU
> with -cpu host,-xsave), check_cpufeature_deps() only warns about unmet

Yah, we don't care. We won't support non-sensical guest configs.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
