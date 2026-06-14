Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ED2C30D41E
	for <linux-raid@vger.kernel.org>; Sun, 14 Jun 2026 10:16:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781432194; cv=none; b=NsbIQ52xv1V/nmUU0u4QUMOJrpdHJiv6LqQF9R7Om6CjIwLieIniFw5pwFFPWVIAw033+0IGlqYHSp6kky9ph4npE6DDcO3SfO1hFEnSFE2iuL21D5rBEr89IwYoNq6Niza3f4MkhHruylh6sl0/ozPVDRqRSMt04PLpQa5LAs4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781432194; c=relaxed/simple;
	bh=Wjgb3xN0AeqkcZrny9i7Ij8300A3VXQkPpGDV7zWSFk=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FEYyLVv30nrVLocVt0MvKRiaZIdTRDna/C5hWrTC3dhaAXxnEIIbl27j8f7Ln0Hx/81cWRcLCJc+kBhu+UfaLMZzzLNQY7sN1bH1vYs6aR7/3A+20/EiEcZasAVqzDG+h6ovHz4h6XEEQA+Kmnqx3R2kNLVjt6SCkwpFg1Bsksk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LmSyJQvW; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LmSyJQvW"
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-45ef6565cfdso1060779f8f.0
        for <linux-raid@vger.kernel.org>; Sun, 14 Jun 2026 03:16:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781432191; x=1782036991; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=r14ZT8wnQjOVhqheY40FWIlmuDlAvi74D7it6/5078M=;
        b=LmSyJQvW5DPnZ/Pgx+gC0I3K4Zj0/4BKBen/GvnWSqkhlXHzi7JKiRD0vOM55MYxMo
         fRfoSODtNz64RfjQmrRVb4N/yI+DoDpr8I8WH1PvalSrOo9qS2AYtI3t8KhXfNM1Lmqb
         FuzcUNafwaEG/KK6+1bn2BS2+WEqQ7n0AJVKqjCo50idohL6h1Ii26JP3GgSmr4TU4mj
         JOsxiV1juaRhc8wPSsiBPKxvDshNloHl4IV/jwZu7N5dWKGDY+kriS1Bauq5LDH8XSlH
         RuEy5e0tBJ2gb+0gNGngwp39BdfdNRAEKhzuygdV8rG3G9hCxzy1DPX9kmkJ327YOL7C
         P1UA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781432191; x=1782036991;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=r14ZT8wnQjOVhqheY40FWIlmuDlAvi74D7it6/5078M=;
        b=qLM4C8MypU1JdlFh0sZrEAPQTuOWbsy0/Np/2MNCTyWePToP6+YEZiysIaKmhnDI14
         LPzibuSek4lVqie4KTOLBSrNh60ty+U304+0/BfJYDku73kakQhQWq85c8veNPu8W3lS
         uTPsDWJhDbB5T34BzUIpxxHK5f2AZ8Bc+AarTQhI6GWeQMgg9YxBmVNrYdVTgzO+hVjs
         zWPUUmbcBngqyBbbsO1otHHzU7xg2bkSYnSl+GZakF5baKHY1qGmyx63oMHUaKn4Fh9N
         8Z0JuhFC4k7C+QnjxZNYvL7diDiUXTNcLpam3HZ5yVWag05U8rJ3krJDyuf403ycrZqC
         LrJw==
X-Forwarded-Encrypted: i=1; AFNElJ+lnVw9XTp5F/IrCZ0qf1nLIcjLfSVlolR41387tunV/ihBN/nC6WZljis80y6Ip305jMY0Ux9iI1x5@vger.kernel.org
X-Gm-Message-State: AOJu0YwjekHbwMZDCA+ZjN3O/6h08i8Ryshf/gJyFphub3C5j1jpwH5m
	BZpSTq5SRn2jU23IrFs5Aym5TOVqsRE/UseKqyS57B6cY4G/EH9CpG7v
X-Gm-Gg: Acq92OFcPA7gNhF4k0QRq1Q/+oeuCuIMeZr9SElVYOv//6xp3KQ/zLeH2oNKGMfgHCE
	lMOnDqxlwqt6wGmEogPIk0hgnpOP8eaV4BYTofAJ1/Me81uNJVXTQpEoyXgWtG3NjetBUROTKSJ
	cBW3RN1K+6Q5fshl+HoKC6Jg15xkD6L8xesRzQ7tYDjFLSv/fzko/MoiLQtTYBO0cWd8H1SYL+B
	PBdf1LlF9d3HxxrWG3H/8ITgv6ofObsVotDhIRkkG8m5dcjuy/p/NW3qM1yUgQZmTBGwrdD2yNC
	AclDtj+y3n2OSAasrnYLu5SFFgVDBqHAPbnI4sU5sV96eaT5XG69w+cwM3Sz3Lf0HbFQ0yS9GZq
	aD6hfpcxDsUIQzcY2M0hYCPfB/HtjS58QOQxzew43Kb75r8fTEWcoyzMBpK//hcZLfoQv5tKaKD
	vbrctPQ5fZdrxNbphQC7j5ndVtn7SQ5vvqZMqr05taWs+51wCrMqSi8yBfYu1C
X-Received: by 2002:a05:6000:41f6:b0:45e:ed7f:1dd with SMTP id ffacd0b85a97d-4606db96b8dmr14159582f8f.25.1781432190422;
        Sun, 14 Jun 2026 03:16:30 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4606f26f3basm22328834f8f.12.2026.06.14.03.16.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Jun 2026 03:16:30 -0700 (PDT)
Date: Sun, 14 Jun 2026 11:16:28 +0100
From: David Laight <david.laight.linux@gmail.com>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
 Christoph Hellwig <hch@lst.de>, linux-crypto@vger.kernel.org,
 x86@kernel.org, linux-raid@vger.kernel.org
Subject: Re: [PATCH v2] lib/raid/xor: x86: Add AVX-512 optimized xor_gen()
Message-ID: <20260614111628.00af46b9@pumpkin>
In-Reply-To: <20260614010357.69416-1-ebiggers@kernel.org>
References: <20260614010357.69416-1-ebiggers@kernel.org>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sat, 13 Jun 2026 18:03:57 -0700
Eric Biggers <ebiggers@kernel.org> wrote:

> Add an implementation of xor_gen() using AVX-512.
> 
> It uses 512-bit vectors, i.e. ZMM registers.  It also uses the
> vpternlogq instruction to do three-input XORs when applicable.
> 
> It's enabled on x86_64 CPUs that have AVX512F && !PREFER_YMM.  In
> practice that means:
> 
>     - AMD Zen 4 and later (client and server)

Doesn't zen4 only have a 256bit bus between the cpu and cache?
So avx512 reads take two clocks.
Since this is memory limited it is unlikely to run faster than the
avx256 version.
OTOH if it doesn't cause down-clocking as well then it won't be slower.

>     - Intel Sapphire Rapids and later (server)
>     - Intel Rocket Lake (client)
>     - Intel Nova Lake and later (client)
> 
> The !PREFER_YMM condition excludes the older AVX-512 implementations in
> Intel Skylake Server and Intel Ice Lake.  They could run this code, but
> they're known to have overly-eager downclocking when ZMM registers are
> used.  This is the same policy that the crypto and CRC code uses.
> 
> Benchmark on AMD Ryzen 9 9950X (Zen 5):
> 
>     src_cnt    avx          avx512       Improvement
>     =======    ==========   ==========   ===========
>     1          56353 MB/s   75388 MB/s   33%
>     2          54274 MB/s   68409 MB/s   26%
>     3          44649 MB/s   64042 MB/s   43%
>     4          41315 MB/s   55002 MB/s   33%
> 
> Note: for now I omitted the cpu_has_xfeatures() check that the AVX-512
> optimized crypto and CRC code does, since it's not implemented on
> User-Mode Linux and it's never been present in the RAID6 code either.
> 
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>

Since I suggested it :-)

Reviewed-By: David Laight <david.laight.linux@gmail.com>

Some 'not very important' comments:

I did wonder whether moving the loop into the asm() would help.
gcc has a nasty habit of pessimising loops when you try to be clever.
It is certainly safer for tight loops like these.
That does have the side effect of making p0 be %1 which doesn't improve
readability. Either used named parameters or possibly just change p0 to p1 (etc)
so they match.

The code should be limited by the memory reads, so the 3-argument xor and
the interleave of the unroll may make no difference.

Some cpu do have constraints on the cache alignment in order to do two
reads per clock, but I've forgotten them and they got better before AVX-512.
If that were affecting this code (on the tested cpu) then I'd expect the
interleaved unroll would improve the _4 and -5 functions.
So it probably doesn't affect this code.

Using the same loop for the avx-256 and sse (and even smaller) functions could
well generate code that runs 'pretty much as fast as possible' on older cpu.
Intel cpu (going back to Sandy bridge) are likely to execute the loop in the
same number of clocks - but clearly copying half or a quarter of the data.
But I've no experience of zen1.

Might be worth doing for avx-256, does any care about anything older :-)

	David


> ---
> 
> Changed in v2:
>     - Fixed build on UML
>     - Reworked the implementation
> 
>  lib/raid/xor/Makefile         |   2 +-
>  lib/raid/xor/x86/xor-avx512.c | 121 ++++++++++++++++++++++++++++++++++
>  lib/raid/xor/x86/xor_arch.h   |  26 ++++----
>  3 files changed, 137 insertions(+), 12 deletions(-)
>  create mode 100644 lib/raid/xor/x86/xor-avx512.c
> 
> diff --git a/lib/raid/xor/Makefile b/lib/raid/xor/Makefile
> index 4d633dfd5b90..4af945861a51 100644
> --- a/lib/raid/xor/Makefile
> +++ b/lib/raid/xor/Makefile
> @@ -26,11 +26,11 @@ xor-$(CONFIG_ALTIVEC)		+= powerpc/xor_vmx.o powerpc/xor_vmx_glue.o
>  xor-$(CONFIG_RISCV_ISA_V)	+= riscv/xor.o riscv/xor-glue.o
>  xor-$(CONFIG_SPARC32)		+= sparc/xor-sparc32.o
>  xor-$(CONFIG_SPARC64)		+= sparc/xor-sparc64.o sparc/xor-sparc64-glue.o
>  xor-$(CONFIG_S390)		+= s390/xor.o
>  xor-$(CONFIG_X86_32)		+= x86/xor-avx.o x86/xor-sse.o x86/xor-mmx.o
> -xor-$(CONFIG_X86_64)		+= x86/xor-avx.o x86/xor-sse.o
> +xor-$(CONFIG_X86_64)		+= x86/xor-avx.o x86/xor-sse.o x86/xor-avx512.o
>  obj-y				+= tests/
>  
>  CFLAGS_arm/xor-neon.o		+= $(CC_FLAGS_FPU)
>  CFLAGS_REMOVE_arm/xor-neon.o	+= $(CC_FLAGS_NO_FPU)
>  
> diff --git a/lib/raid/xor/x86/xor-avx512.c b/lib/raid/xor/x86/xor-avx512.c
> new file mode 100644
> index 000000000000..87b981d74c90
> --- /dev/null
> +++ b/lib/raid/xor/x86/xor-avx512.c
> @@ -0,0 +1,121 @@
> +// SPDX-License-Identifier: GPL-2.0-or-later
> +/*
> + * AVX-512 optimized implementation of xor_gen()
> + *
> + * Copyright 2026 Google LLC
> + */
> +
> +#include <linux/types.h>
> +#include <asm/fpu/api.h>
> +#include "xor_impl.h"
> +#include "xor_arch.h"
> +
> +/*
> + * Implementation notes:
> + *
> + * Unrolling by the number of buffers (2-5) is very important.
> + *
> + * Unrolling by length is less important, especially when using register-indexed
> + * addressing with negative indices from the end of the buffers.  That approach
> + * results in just two loop control instructions being needed per iteration,
> + * regardless of the number of buffers.
> + *
> + * In fact, benchmarks showed that the 2 and 3 buffer cases require only 2x
> + * unrolling by length, while the 4 and 5 buffer cases don't require any
> + * unrolling by length.  Benchmarks also showed that the register-indexed
> + * addressing isn't a bottleneck either; i.e., we can't do any better by
> + * incrementing the pointers as we go along, even with more unrolling.
> + */
> +
> +static void xor_avx512_2(long bytes, u8 *p0, const u8 *p1)
> +{
> +	long i = -bytes;
> +
> +	asm volatile("1: vmovdqa64 (%0,%1), %%zmm0\n"
> +		     "vmovdqa64 64(%0,%1), %%zmm1\n"
> +		     "vpxorq (%0,%2), %%zmm0, %%zmm0\n"
> +		     "vpxorq 64(%0,%2), %%zmm1, %%zmm1\n"
> +		     "vmovdqa64 %%zmm0, (%0,%1)\n"
> +		     "vmovdqa64 %%zmm1, 64(%0,%1)\n"
> +		     "add $128, %0\n"
> +		     "jnz 1b\n"
> +		     : "+&r"(i)
> +		     : "r"(p0 + bytes), "r"(p1 + bytes)
> +		     : "memory", "cc");
> +}
> +
> +static void xor_avx512_3(long bytes, u8 *p0, const u8 *p1, const u8 *p2)
> +{
> +	long i = -bytes;
> +
> +	asm volatile("1: vmovdqa64 (%0,%1), %%zmm0\n"
> +		     "vmovdqa64 64(%0,%1), %%zmm1\n"
> +		     "vmovdqa64 (%0,%2), %%zmm2\n"
> +		     "vmovdqa64 64(%0,%2), %%zmm3\n"
> +		     "vpternlogq $0x96, (%0,%3), %%zmm2, %%zmm0\n"
> +		     "vpternlogq $0x96, 64(%0,%3), %%zmm3, %%zmm1\n"
> +		     "vmovdqa64 %%zmm0, (%0,%1)\n"
> +		     "vmovdqa64 %%zmm1, 64(%0,%1)\n"
> +		     "add $128, %0\n"
> +		     "jnz 1b\n"
> +		     : "+&r"(i)
> +		     : "r"(p0 + bytes), "r"(p1 + bytes), "r"(p2 + bytes)
> +		     : "memory", "cc");
> +}
> +
> +static void xor_avx512_4(long bytes, u8 *p0, const u8 *p1, const u8 *p2,
> +			 const u8 *p3)
> +{
> +	long i = -bytes;
> +
> +	asm volatile("1: vmovdqa64 (%0,%1), %%zmm0\n"
> +		     "vmovdqa64 (%0,%2), %%zmm1\n"
> +		     "vpxorq (%0,%3), %%zmm0, %%zmm0\n"
> +		     "vpternlogq $0x96, (%0,%4), %%zmm1, %%zmm0\n"
> +		     "vmovdqa64 %%zmm0, (%0,%1)\n"
> +		     "add $64, %0\n"
> +		     "jnz 1b\n"
> +		     : "+&r"(i)
> +		     : "r"(p0 + bytes), "r"(p1 + bytes), "r"(p2 + bytes),
> +		       "r"(p3 + bytes)
> +		     : "memory", "cc");
> +}
> +
> +static void xor_avx512_5(long bytes, u8 *p0, const u8 *p1, const u8 *p2,
> +			 const u8 *p3, const u8 *p4)
> +{
> +	long i = -bytes;
> +
> +	asm volatile("1: vmovdqa64 (%0,%1), %%zmm0\n"
> +		     "vmovdqa64 (%0,%2), %%zmm1\n"
> +		     "vpternlogq $0x96, (%0,%3), %%zmm1, %%zmm0\n"
> +		     "vmovdqa64 (%0,%4), %%zmm1\n"
> +		     "vpternlogq $0x96, (%0,%5), %%zmm1, %%zmm0\n"
> +		     "vmovdqa64 %%zmm0, (%0,%1)\n"
> +		     "add $64, %0\n"
> +		     "jnz 1b\n"
> +		     : "+&r"(i)
> +		     : "r"(p0 + bytes), "r"(p1 + bytes), "r"(p2 + bytes),
> +		       "r"(p3 + bytes), "r"(p4 + bytes)
> +		     : "memory", "cc");
> +}
> +
> +DO_XOR_BLOCKS(avx512_inner, xor_avx512_2, xor_avx512_3, xor_avx512_4,
> +	      xor_avx512_5);
> +
> +/*
> + * Preconditions: bytes is a nonzero multiple of 512, and all buffers are
> + * 64-byte aligned.
> + */
> +static void xor_gen_avx512(void *dest, void **srcs, unsigned int src_cnt,
> +			   unsigned int bytes)
> +{
> +	kernel_fpu_begin();
> +	xor_gen_avx512_inner(dest, srcs, src_cnt, bytes);
> +	kernel_fpu_end();
> +}
> +
> +struct xor_block_template xor_block_avx512 = {
> +	.name = "avx512",
> +	.xor_gen = xor_gen_avx512,
> +};
> diff --git a/lib/raid/xor/x86/xor_arch.h b/lib/raid/xor/x86/xor_arch.h
> index 99fe85a213c6..b5d49376fc97 100644
> --- a/lib/raid/xor/x86/xor_arch.h
> +++ b/lib/raid/xor/x86/xor_arch.h
> @@ -4,26 +4,30 @@
>  extern struct xor_block_template xor_block_pII_mmx;
>  extern struct xor_block_template xor_block_p5_mmx;
>  extern struct xor_block_template xor_block_sse;
>  extern struct xor_block_template xor_block_sse_pf64;
>  extern struct xor_block_template xor_block_avx;
> +extern struct xor_block_template xor_block_avx512;
>  
> -/*
> - * When SSE is available, use it as it can write around L2.  We may also be able
> - * to load into the L1 only depending on how the cpu deals with a load to a line
> - * that is being prefetched.
> - *
> - * When AVX2 is available, force using it as it is better by all measures.
> - *
> - * 32-bit without MMX can fall back to the generic routines.
> - */
>  static __always_inline void __init arch_xor_init(void)
>  {
> -	if (boot_cpu_has(X86_FEATURE_AVX) &&
> -	    boot_cpu_has(X86_FEATURE_OSXSAVE)) {
> +	if (IS_ENABLED(CONFIG_X86_64) && boot_cpu_has(X86_FEATURE_AVX512F) &&
> +	    boot_cpu_has(X86_FEATURE_OSXSAVE) &&
> +	    !boot_cpu_has(X86_FEATURE_PREFER_YMM)) {
> +		/* AVX-512 will be the best; no need to try others. */
> +		/* !PREFER_YMM excludes CPUs with overly-eager downclocking. */
> +		xor_force(&xor_block_avx512);
> +	} else if (boot_cpu_has(X86_FEATURE_AVX) &&
> +		   boot_cpu_has(X86_FEATURE_OSXSAVE)) {
> +		/* AVX will be the best; no need to try others. */
>  		xor_force(&xor_block_avx);
>  	} else if (IS_ENABLED(CONFIG_X86_64) || boot_cpu_has(X86_FEATURE_XMM)) {
> +		/*
> +		 * When SSE is available, use it as it can write around L2.  We
> +		 * may also be able to load into the L1 only depending on how
> +		 * the cpu deals with a load to a line that is being prefetched.
> +		 */
>  		xor_register(&xor_block_sse);
>  		xor_register(&xor_block_sse_pf64);
>  	} else if (boot_cpu_has(X86_FEATURE_MMX)) {
>  		xor_register(&xor_block_pII_mmx);
>  		xor_register(&xor_block_p5_mmx);
> 
> base-commit: 2b07ea76fd28989bde5993532d7a943a6f90e246

