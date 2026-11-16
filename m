Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794863083;
	b=srr5kEoKgdn2spUTTpaRFBPSiMd9wDmmCiFXEwxFakcHmflKfbBardmgBkJspaxrPRDu
	 yaTlfrcEwj3NIbKegB519UR+hslw2X5NYrjwQUaIIfAjMPAsOj7Ayn6xo7oaiqviBz836
	 gtYmRfDMylz8Fj9dspqUbGhpOc7ByEvuCJdpmdSTvGp2te3eLlqiqr/jjff7oZN6Q9rFO
	 A9t0p44XqcIHIif0E+OrrY8Rt3YRSAzKfGCfgWOJkGE/ugbIId377zjas0DDREjbKQKx5
	 R89kCyrJukSGs2wFixYGAWA31qO3r68TIO9SLT+XdXTyBPrP9ktDYw0fCMtTrgTOaXg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794863083;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=wZmy53ikJvk4EBmIjL/+thJYFZnTxBAVgmNBHvUBVag=;
	b=EjzF0TwnWdMCyRTp/AO+tD6zKmfPeMEsJ80yljGpQL9urbpGUpiQeqoC6hqecax1SN0B
	 zjz9HcrCiiik68UMf9rZEJaNfLxpM3asnGTlhmNa4d/pDFnQoT1vibexPVgsV2jEZ3g52
	 z0YKK6TYBF066XJBtpiuma8YnaRJ5FmMUL3fDkIFhXPdwNoQk883dfA4OBT17MbSD5ooJ
	 IQTkTRAHEQSTGgtNDBPw0brmWeAhMSTYmNuGeZnWDjpXSwVA65Awd1Q/ifRSFL4cLKynp
	 SihmiLvoL8GpLJ59IxiISb0znmXfUgl+IM2KMB+0C2UDCwl+TzkpZRl48axDk5x0KyQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="nE9NE/Hg";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A84A606A31C;
	Mon, 16 Nov 2026 21:04:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nE9NE/Hg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47AA81F000C4;
	Mon, 16 Nov 2026 21:04:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794863082;
	bh=wZmy53ikJvk4EBmIjL/+thJYFZnTxBAVgmNBHvUBVag=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=nE9NE/HglY0FFZKRyLReRoNzDQxnIPkVMxxn2k5jIZehagz+V5lZI2tSrq6KgrhqJ
	 rryUWK388lEmdHJsL6fTwipbcnm/sZaWo/oUVW6+orUfR35R7uMKEOu+7lUAUSDkKX
	 yMyXwK2S9qTJjUwsPfoA8c/tRunfgrP2Kr9SBS8mWkisYFVdi64JkGQz0qtFTOBT1G
	 cw7YwALbXEDJJLUre81M76k5mACrc/nLMpqpe+705tQ/qPINcg4xlPJ6TS7YVfVh1H
	 ErCaUD+A4NkJmViMoIkGbvrwlm+CDywDFfB14Usi7MwIh7kqpKFhd/i4aKoL6mPm4C
	 jByZPHwtVscgA==
Date: Mon, 16 Nov 2026 21:04:40 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: Miroslav Cimerman <mc@raidlab.org>
Cc: Song Liu <song@kernel.org>, Yu Kuai <yukuai@fygo.io>,
	Andrew Morton <akpm@linux-foundation.org>,
	Li Nan <magiclinan@didiglobal.com>, Xiao Ni <xiao@kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>, linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] raid6: use normal stores in the x86 x4 xor_syndrome
 functions
Message-ID: <20261116210440.GE229817@google.com>
References: <20261109030805.25709-1-mc@raidlab.org>
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Post: <mailto:linux-raid@vger.kernel.org>
List-Help: <mailto:linux-raid+help@vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-raid+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261109030805.25709-1-mc@raidlab.org>

On Mon, Nov 09, 2026 at 03:08:05AM +0000, Miroslav Cimerman wrote:
> - The sfence at the end of the xor_syndrome() functions (x1, x2 versions
>   since 2014, x4 with this patch) is no longer needed, as it no longer
>   orders any non-temporal stores. Removing it made no measurable
>   difference. I am happy to send a follow-up patch that removes it from
>   all xor_syndrome() variants.

Removing the 'asm volatile("sfence" : : : "memory");' too sounds good,
but be careful: a lot of the inline asm statements in
lib/raid/raid6/x86/avx512.c incorrectly list the memory operands as
inputs only.  So, technically they rely on that "memory" clobber.  The
constraints should be fixed accordingly.

Also, ideally the 'prefetchnta' on q in the x4 xor_syndrome() functions
would become 'prefetcht0', to match the temporal stores.

If the scope of this patch is just replacing the store instructions
though, it looks fine.

Reviewed-by: Eric Biggers <ebiggers@kernel.org>

- Eric
