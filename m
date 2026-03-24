Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 381C03A7584;
	Tue, 24 Mar 2026 08:00:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774339239; cv=none; b=DiCSvWp/DfmyFxISHSQVOB7BbR0KTCPlYui2NEaurWwzwXl75JqgJEgqiUKXg8ceD2RpAO/Ld59I0wbmFp2XuWQrDIfmkqyhokRil3ENUjo3vzDuEZixvuvo51gw2mupRI79GERHID2Hs5jmtHBqK70uwbyOpkPxeXEAI8iJvF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774339239; c=relaxed/simple;
	bh=0IzTTVCb8yLcNP/U022Inh+9dxfqa2fPBHcHQm+wgYc=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=fxMCq/wVUaSVoB0Y/8vTyXS9JCND+CeXUfnz89Vfy/Qf6eTrnkmsDO0cbpJI+7eIWkpIbUq8Th6656LvfiJzOQ3By/rBkoasrZsrPutJ4ma0EXEqf0p0hxJHTB6hUyE2E7TZ8GtxOKsqelH1DIu4Sm6C4BgYGaXQ3VM5kOTOQiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dv0USW5K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dv0USW5K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC741C19424;
	Tue, 24 Mar 2026 08:00:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774339238;
	bh=0IzTTVCb8yLcNP/U022Inh+9dxfqa2fPBHcHQm+wgYc=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject:From;
	b=dv0USW5K13hdEsXKwbKp4eCDr7/N050HEdteMC+A33vXV3liyYuzJbBw40RyIk88E
	 gabxJfxgtiQG/zZGG5fENVoTbyjfhU/EaPXfOat5jAVEzXxt1Gtzj+upEJqaOBk9+H
	 NbhzXr1dHmEJp4cXjRzyUgLxQk5TPA4FNfdnFKAQ4etpqCQNfiVJlsfQba9081Vxg7
	 0DX5ziQmNMVrkV9Hg601nctpWlv7T2MAPze+2hO90cUnoJsl7icuCfMlwtIGQmFUke
	 YnuOz9lP9BOZgfp0K+yb+YDWrXzf8nxPOK7oywmOF3t78B+8Bymz6vrz3SU+2PD27R
	 ZUh1k7+kDyqPg==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id D895AF40072;
	Tue, 24 Mar 2026 04:00:36 -0400 (EDT)
Received: from phl-imap-02 ([10.202.2.81])
  by phl-compute-01.internal (MEProxy); Tue, 24 Mar 2026 04:00:36 -0400
X-ME-Sender: <xms:pETCaa3jhuCoR2AX9sknVdomMzRwRgFvS8cuiggV6eNX4qfDO60p0g>
    <xme:pETCaX4yB48IEPlVLXxosnE4C96zBl6Her_hCVjpBCe6nXz8e-DYoFU87PeDLL7mq
    wX5gOqVWFztpizBeR3dgN56ngHD4f9FGfuz-7E88fhj7-bLLxZJ0g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdefvddutdegucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepofggfffhvfevkfgjfhfutgfgsehtjeertdertddtnecuhfhrohhmpedftehrugcu
    uehivghshhgvuhhvvghlfdcuoegrrhgusgeskhgvrhhnvghlrdhorhhgqeenucggtffrrg
    htthgvrhhnpeekvdffkefhgfegveekfedtieffhfelgeetiedvieffhfekfeeikeetueeg
    teetteenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuihiivg
    eptdenucfrrghrrghmpehmrghilhhfrhhomheprghrugdomhgvshhmthhprghuthhhphgv
    rhhsohhnrghlihhthidqudeijedthedttdejledqfeefvdduieegudehqdgrrhgusgeppe
    hkvghrnhgvlhdrohhrghesfihorhhkohhfrghrugdrtghomhdpnhgspghrtghpthhtohep
    udefpdhmohguvgepshhmthhpohhuthdprhgtphhtthhopegtrghtrghlihhnrdhmrghrih
    hnrghssegrrhhmrdgtohhmpdhrtghpthhtohepmhgrrhhkrdhruhhtlhgrnhgusegrrhhm
    rdgtohhmpdhrtghpthhtoheprhhosghinhdrmhhurhhphhihsegrrhhmrdgtohhmpdhrtg
    hpthhtohephihukhhurghisehfnhhnrghsrdgtohhmpdhrtghpthhtohepuggvmhihrghn
    shhhsehgmhgrihhlrdgtohhmpdhrtghpthhtoheplhhinhgrnhduvddvsehhuhgrfigvih
    drtghomhdprhgtphhtthhopegsrhhoohhnihgvsehkvghrnhgvlhdrohhrghdprhgtphht
    thhopehsohhngheskhgvrhhnvghlrdhorhhgpdhrtghpthhtohepfihilhhlsehkvghrnh
    gvlhdrohhrgh
X-ME-Proxy: <xmx:pETCaVGTh9mfVhQ84pUTRT04E1lByF1j5-6UlOquCTp9q00lbsxTBw>
    <xmx:pETCaeByhhe0qkDGXAEPEtWtrdlsnLNFY9utdj1RN-Nm7WdonHSV_Q>
    <xmx:pETCafx2a70TzjUxnp7TiKnwxkTpU-B_gitdV-mwvn7jPbqalaNDTg>
    <xmx:pETCacdYeJz5PrEwgU3D_2kdcXSxM8fc9AlNHxpd0bXvt8qp6dHKaQ>
    <xmx:pETCacse30fAVoCNwWG99607MZ-4Nwvp4IRL_VJRa7kC0q3zOO4W8IAQ>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id A8CAD700065; Tue, 24 Mar 2026 04:00:36 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ThreadId: AB98H5nyYqoB
Date: Tue, 24 Mar 2026 09:00:16 +0100
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Demian Shulhan" <demyansh@gmail.com>, "Song Liu" <song@kernel.org>,
 "Yu Kuai" <yukuai@fnnas.com>, "Will Deacon" <will@kernel.org>,
 "Catalin Marinas" <catalin.marinas@arm.com>,
 "Mark Rutland" <mark.rutland@arm.com>, broonie@kernel.org,
 linux-arm-kernel@lists.infradead.org, robin.murphy@arm.com,
 "Christoph Hellwig" <hch@lst.de>
Cc: "Li Nan" <linan122@huawei.com>, linux-raid@vger.kernel.org,
 linux-kernel@vger.kernel.org
Message-Id: <f9bc0534-4b7a-4b14-974b-4d7811ccd899@app.fastmail.com>
In-Reply-To: <20260318150245.3080719-1-demyansh@gmail.com>
References: <20260318150245.3080719-1-demyansh@gmail.com>
Subject: Re: [PATCH v2] raid6: arm64: add SVE optimized implementation for syndrome
 generation
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hi Damian,

On Wed, 18 Mar 2026, at 16:02, Demian Shulhan wrote:
> Implement Scalable Vector Extension (SVE) optimized routines for RAID6
> syndrome generation and recovery on ARM64.
>
> The SVE instruction set allows for variable vector lengths (from 128 to
> 2048 bits), scaling automatically with the hardware capabilities. This
> implementation handles arbitrary SVE vector lengths using the `cntb`
> instruction to determine the runtime vector length.
>
> The implementation introduces `svex1`, `svex2`, and `svex4` algorithms.
> The `svex4` algorithm utilizes loop unrolling by 4 blocks per iteration
> and manual software pipelining (interleaving memory loads with XORs)
> to minimize instruction dependency stalls and maximize CPU pipeline
> utilization and memory bandwidth.
>
> Performance was tested on an AWS Graviton3 (Neoverse-V1) instance which
> features 256-bit SVE vector length. The `svex4` implementation outperforms
> the existing 128-bit `neonx4` baseline for syndrome generation:
>
> raid6: svex4    gen() 19688 MB/s
...
> raid6: neonx4   gen() 19612 MB/s

You're being very generous characterising a 0.3% speedup as 'outperforms'

But the real problem here is that the kernel-mode SIMD API only supports NEON and not SVE, and preserves/restores only the 128-bit view on the NEON/SVE register file. So any context switch or softirq that uses kernel-mode SIMD too, and your SVE register values will get truncated.

Once we encounter a good use case for SVE in the kernel, we might reconsider this, but as it stands, this patch should not be applied.

(leaving the reply untrimmed for the benefit of the cc'ees I added)

> raid6: neonx2   gen() 16248 MB/s
> raid6: neonx1   gen() 13591 MB/s
> raid6: using algorithm svex4 gen() 19688 MB/s
> raid6: .... xor() 11212 MB/s, rmw enabled
> raid6: using neon recovery algorithm
>
> Note that for the recovery path (`xor_syndrome`), NEON may still be
> selected dynamically by the algorithm benchmark, as the recovery
> workload is heavily memory-bound.
>
> Signed-off-by: Demian Shulhan <demyansh@gmail.com>
> Reported-by: kernel test robot <lkp@intel.com>
> Closes: 
> https://lore.kernel.org/oe-kbuild-all/202603181940.cFwYmYoi-lkp@intel.com/
> ---
>  include/linux/raid/pq.h |   3 +
>  lib/raid6/Makefile      |   5 +
>  lib/raid6/algos.c       |   5 +
>  lib/raid6/sve.c         | 675 ++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 688 insertions(+)
>  create mode 100644 lib/raid6/sve.c
>
> diff --git a/include/linux/raid/pq.h b/include/linux/raid/pq.h
> index 2467b3be15c9..787cc57aea9d 100644
> --- a/include/linux/raid/pq.h
> +++ b/include/linux/raid/pq.h
> @@ -140,6 +140,9 @@ extern const struct raid6_calls raid6_neonx1;
>  extern const struct raid6_calls raid6_neonx2;
>  extern const struct raid6_calls raid6_neonx4;
>  extern const struct raid6_calls raid6_neonx8;
> +extern const struct raid6_calls raid6_svex1;
> +extern const struct raid6_calls raid6_svex2;
> +extern const struct raid6_calls raid6_svex4;
> 
>  /* Algorithm list */
>  extern const struct raid6_calls * const raid6_algos[];
> diff --git a/lib/raid6/Makefile b/lib/raid6/Makefile
> index 5be0a4e60ab1..6cdaa6f206fb 100644
> --- a/lib/raid6/Makefile
> +++ b/lib/raid6/Makefile
> @@ -8,6 +8,7 @@ raid6_pq-$(CONFIG_X86) += recov_ssse3.o recov_avx2.o 
> mmx.o sse1.o sse2.o avx2.o
>  raid6_pq-$(CONFIG_ALTIVEC) += altivec1.o altivec2.o altivec4.o 
> altivec8.o \
>                                vpermxor1.o vpermxor2.o vpermxor4.o 
> vpermxor8.o
>  raid6_pq-$(CONFIG_KERNEL_MODE_NEON) += neon.o neon1.o neon2.o neon4.o 
> neon8.o recov_neon.o recov_neon_inner.o
> +raid6_pq-$(CONFIG_ARM64_SVE) += sve.o
>  raid6_pq-$(CONFIG_S390) += s390vx8.o recov_s390xc.o
>  raid6_pq-$(CONFIG_LOONGARCH) += loongarch_simd.o recov_loongarch_simd.o
>  raid6_pq-$(CONFIG_RISCV_ISA_V) += rvv.o recov_rvv.o
> @@ -67,6 +68,10 @@ CFLAGS_REMOVE_neon2.o += $(CC_FLAGS_NO_FPU)
>  CFLAGS_REMOVE_neon4.o += $(CC_FLAGS_NO_FPU)
>  CFLAGS_REMOVE_neon8.o += $(CC_FLAGS_NO_FPU)
>  CFLAGS_REMOVE_recov_neon_inner.o += $(CC_FLAGS_NO_FPU)
> +
> +CFLAGS_sve.o += $(CC_FLAGS_FPU)
> +CFLAGS_REMOVE_sve.o += $(CC_FLAGS_NO_FPU)
> +
>  targets += neon1.c neon2.c neon4.c neon8.c
>  $(obj)/neon%.c: $(src)/neon.uc $(src)/unroll.awk FORCE
>  	$(call if_changed,unroll)
> diff --git a/lib/raid6/algos.c b/lib/raid6/algos.c
> index 799e0e5eac26..0ae73c3a4be3 100644
> --- a/lib/raid6/algos.c
> +++ b/lib/raid6/algos.c
> @@ -66,6 +66,11 @@ const struct raid6_calls * const raid6_algos[] = {
>  	&raid6_neonx2,
>  	&raid6_neonx1,
>  #endif
> +#ifdef CONFIG_ARM64_SVE
> +	&raid6_svex4,
> +	&raid6_svex2,
> +	&raid6_svex1,
> +#endif
>  #ifdef CONFIG_LOONGARCH
>  #ifdef CONFIG_CPU_HAS_LASX
>  	&raid6_lasx,
> diff --git a/lib/raid6/sve.c b/lib/raid6/sve.c
> new file mode 100644
> index 000000000000..d52937f806d4
> --- /dev/null
> +++ b/lib/raid6/sve.c
> @@ -0,0 +1,675 @@
> +// SPDX-License-Identifier: GPL-2.0-or-later
> +/*
> + * RAID-6 syndrome calculation using ARM SVE instructions
> + */
> +
> +#include <linux/raid/pq.h>
> +
> +#ifdef __KERNEL__
> +#include <asm/simd.h>
> +#include <linux/cpufeature.h>
> +#else
> +#define scoped_ksimd()
> +#define system_supports_sve() (1)
> +#endif
> +
> +static void raid6_sve1_gen_syndrome_real(int disks, unsigned long 
> bytes, void **ptrs)
> +{
> +	u8 **dptr = (u8 **)ptrs;
> +	u8 *p, *q;
> +	long z0 = disks - 3;
> +
> +	p = dptr[z0 + 1];
> +	q = dptr[z0 + 2];
> +
> +	asm volatile(
> +		".arch armv8.2-a+sve\n"
> +		"ptrue p0.b\n"
> +		"cntb x3\n"
> +		"mov w4, #0x1d\n"
> +		"dup z4.b, w4\n"
> +		"mov x5, #0\n"
> +
> +		"0:\n"
> +		"ldr x6, [%[dptr], %[z0], lsl #3]\n"
> +		"ld1b z0.b, p0/z, [x6, x5]\n"
> +		"mov z1.d, z0.d\n"
> +
> +		"mov w7, %w[z0]\n"
> +		"sub w7, w7, #1\n"
> +
> +		"1:\n"
> +		"cmp w7, #0\n"
> +		"blt 2f\n"
> +
> +		"mov z3.d, z1.d\n"
> +		"asr z3.b, p0/m, z3.b, #7\n"
> +		"lsl z1.b, p0/m, z1.b, #1\n"
> +
> +		"and z3.d, z3.d, z4.d\n"
> +		"eor z1.d, z1.d, z3.d\n"
> +
> +		"sxtw x8, w7\n"
> +		"ldr x6, [%[dptr], x8, lsl #3]\n"
> +		"ld1b z2.b, p0/z, [x6, x5]\n"
> +
> +		"eor z1.d, z1.d, z2.d\n"
> +		"eor z0.d, z0.d, z2.d\n"
> +
> +		"sub w7, w7, #1\n"
> +		"b 1b\n"
> +		"2:\n"
> +
> +		"st1b z0.b, p0, [%[p], x5]\n"
> +		"st1b z1.b, p0, [%[q], x5]\n"
> +
> +		"add x5, x5, x3\n"
> +		"cmp x5, %[bytes]\n"
> +		"blt 0b\n"
> +		:
> +		: [dptr] "r" (dptr), [z0] "r" (z0), [bytes] "r" (bytes),
> +		  [p] "r" (p), [q] "r" (q)
> +		: "memory", "p0", "x3", "x4", "x5", "x6", "x7", "x8",
> +		  "z0", "z1", "z2", "z3", "z4"
> +	);
> +}
> +
> +static void raid6_sve1_xor_syndrome_real(int disks, int start, int 
> stop,
> +					 unsigned long bytes, void **ptrs)
> +{
> +	u8 **dptr = (u8 **)ptrs;
> +	u8 *p, *q;
> +	long z0 = stop;
> +
> +	p = dptr[disks - 2];
> +	q = dptr[disks - 1];
> +
> +	asm volatile(
> +		".arch armv8.2-a+sve\n"
> +		"ptrue p0.b\n"
> +		"cntb x3\n"
> +		"mov w4, #0x1d\n"
> +		"dup z4.b, w4\n"
> +		"mov x5, #0\n"
> +
> +		"0:\n"
> +		"ldr x6, [%[dptr], %[z0], lsl #3]\n"
> +		"ld1b z1.b, p0/z, [x6, x5]\n"
> +		"ld1b z0.b, p0/z, [%[p], x5]\n"
> +		"eor z0.d, z0.d, z1.d\n"
> +
> +		"mov w7, %w[z0]\n"
> +		"sub w7, w7, #1\n"
> +
> +		"1:\n"
> +		"cmp w7, %w[start]\n"
> +		"blt 2f\n"
> +
> +		"mov z3.d, z1.d\n"
> +		"asr z3.b, p0/m, z3.b, #7\n"
> +		"lsl z1.b, p0/m, z1.b, #1\n"
> +		"and z3.d, z3.d, z4.d\n"
> +		"eor z1.d, z1.d, z3.d\n"
> +
> +		"sxtw x8, w7\n"
> +		"ldr x6, [%[dptr], x8, lsl #3]\n"
> +		"ld1b z2.b, p0/z, [x6, x5]\n"
> +
> +		"eor z1.d, z1.d, z2.d\n"
> +		"eor z0.d, z0.d, z2.d\n"
> +
> +		"sub w7, w7, #1\n"
> +		"b 1b\n"
> +		"2:\n"
> +
> +		"mov w7, %w[start]\n"
> +		"sub w7, w7, #1\n"
> +		"3:\n"
> +		"cmp w7, #0\n"
> +		"blt 4f\n"
> +
> +		"mov z3.d, z1.d\n"
> +		"asr z3.b, p0/m, z3.b, #7\n"
> +		"lsl z1.b, p0/m, z1.b, #1\n"
> +		"and z3.d, z3.d, z4.d\n"
> +		"eor z1.d, z1.d, z3.d\n"
> +
> +		"sub w7, w7, #1\n"
> +		"b 3b\n"
> +		"4:\n"
> +
> +		"ld1b z2.b, p0/z, [%[q], x5]\n"
> +		"eor z1.d, z1.d, z2.d\n"
> +
> +		"st1b z0.b, p0, [%[p], x5]\n"
> +		"st1b z1.b, p0, [%[q], x5]\n"
> +
> +		"add x5, x5, x3\n"
> +		"cmp x5, %[bytes]\n"
> +		"blt 0b\n"
> +		:
> +		: [dptr] "r" (dptr), [z0] "r" (z0), [bytes] "r" (bytes),
> +		  [p] "r" (p), [q] "r" (q), [start] "r" (start)
> +		: "memory", "p0", "x3", "x4", "x5", "x6", "x7", "x8",
> +		  "z0", "z1", "z2", "z3", "z4"
> +	);
> +}
> +
> +static void raid6_sve2_gen_syndrome_real(int disks, unsigned long 
> bytes, void **ptrs)
> +{
> +	u8 **dptr = (u8 **)ptrs;
> +	u8 *p, *q;
> +	long z0 = disks - 3;
> +
> +	p = dptr[z0 + 1];
> +	q = dptr[z0 + 2];
> +
> +	asm volatile(
> +		".arch armv8.2-a+sve\n"
> +		"ptrue p0.b\n"
> +		"cntb x3\n"
> +		"mov w4, #0x1d\n"
> +		"dup z4.b, w4\n"
> +		"mov x5, #0\n"
> +
> +		"0:\n"
> +		"ldr x6, [%[dptr], %[z0], lsl #3]\n"
> +		"ld1b z0.b, p0/z, [x6, x5]\n"
> +		"add x8, x5, x3\n"
> +		"ld1b z5.b, p0/z, [x6, x8]\n"
> +		"mov z1.d, z0.d\n"
> +		"mov z6.d, z5.d\n"
> +
> +		"mov w7, %w[z0]\n"
> +		"sub w7, w7, #1\n"
> +
> +		"1:\n"
> +		"cmp w7, #0\n"
> +		"blt 2f\n"
> +
> +		"mov z3.d, z1.d\n"
> +		"asr z3.b, p0/m, z3.b, #7\n"
> +		"lsl z1.b, p0/m, z1.b, #1\n"
> +		"and z3.d, z3.d, z4.d\n"
> +		"eor z1.d, z1.d, z3.d\n"
> +
> +		"mov z8.d, z6.d\n"
> +		"asr z8.b, p0/m, z8.b, #7\n"
> +		"lsl z6.b, p0/m, z6.b, #1\n"
> +		"and z8.d, z8.d, z4.d\n"
> +		"eor z6.d, z6.d, z8.d\n"
> +
> +		"sxtw x8, w7\n"
> +		"ldr x6, [%[dptr], x8, lsl #3]\n"
> +		"ld1b z2.b, p0/z, [x6, x5]\n"
> +		"add x8, x5, x3\n"
> +		"ld1b z7.b, p0/z, [x6, x8]\n"
> +
> +		"eor z1.d, z1.d, z2.d\n"
> +		"eor z0.d, z0.d, z2.d\n"
> +
> +		"eor z6.d, z6.d, z7.d\n"
> +		"eor z5.d, z5.d, z7.d\n"
> +
> +		"sub w7, w7, #1\n"
> +		"b 1b\n"
> +		"2:\n"
> +
> +		"st1b z0.b, p0, [%[p], x5]\n"
> +		"st1b z1.b, p0, [%[q], x5]\n"
> +		"add x8, x5, x3\n"
> +		"st1b z5.b, p0, [%[p], x8]\n"
> +		"st1b z6.b, p0, [%[q], x8]\n"
> +
> +		"add x5, x5, x3\n"
> +		"add x5, x5, x3\n"
> +		"cmp x5, %[bytes]\n"
> +		"blt 0b\n"
> +		:
> +		: [dptr] "r" (dptr), [z0] "r" (z0), [bytes] "r" (bytes),
> +		  [p] "r" (p), [q] "r" (q)
> +		: "memory", "p0", "x3", "x4", "x5", "x6", "x7", "x8",
> +		  "z0", "z1", "z2", "z3", "z4",
> +		  "z5", "z6", "z7", "z8"
> +	);
> +}
> +
> +static void raid6_sve2_xor_syndrome_real(int disks, int start, int 
> stop,
> +					 unsigned long bytes, void **ptrs)
> +{
> +	u8 **dptr = (u8 **)ptrs;
> +	u8 *p, *q;
> +	long z0 = stop;
> +
> +	p = dptr[disks - 2];
> +	q = dptr[disks - 1];
> +
> +	asm volatile(
> +		".arch armv8.2-a+sve\n"
> +		"ptrue p0.b\n"
> +		"cntb x3\n"
> +		"mov w4, #0x1d\n"
> +		"dup z4.b, w4\n"
> +		"mov x5, #0\n"
> +
> +		"0:\n"
> +		"ldr x6, [%[dptr], %[z0], lsl #3]\n"
> +		"ld1b z1.b, p0/z, [x6, x5]\n"
> +		"add x8, x5, x3\n"
> +		"ld1b z6.b, p0/z, [x6, x8]\n"
> +
> +		"ld1b z0.b, p0/z, [%[p], x5]\n"
> +		"ld1b z5.b, p0/z, [%[p], x8]\n"
> +
> +		"eor z0.d, z0.d, z1.d\n"
> +		"eor z5.d, z5.d, z6.d\n"
> +
> +		"mov w7, %w[z0]\n"
> +		"sub w7, w7, #1\n"
> +
> +		"1:\n"
> +		"cmp w7, %w[start]\n"
> +		"blt 2f\n"
> +
> +		"mov z3.d, z1.d\n"
> +		"asr z3.b, p0/m, z3.b, #7\n"
> +		"lsl z1.b, p0/m, z1.b, #1\n"
> +		"and z3.d, z3.d, z4.d\n"
> +		"eor z1.d, z1.d, z3.d\n"
> +
> +		"mov z8.d, z6.d\n"
> +		"asr z8.b, p0/m, z8.b, #7\n"
> +		"lsl z6.b, p0/m, z6.b, #1\n"
> +		"and z8.d, z8.d, z4.d\n"
> +		"eor z6.d, z6.d, z8.d\n"
> +
> +		"sxtw x8, w7\n"
> +		"ldr x6, [%[dptr], x8, lsl #3]\n"
> +		"ld1b z2.b, p0/z, [x6, x5]\n"
> +		"add x8, x5, x3\n"
> +		"ld1b z7.b, p0/z, [x6, x8]\n"
> +
> +		"eor z1.d, z1.d, z2.d\n"
> +		"eor z0.d, z0.d, z2.d\n"
> +
> +		"eor z6.d, z6.d, z7.d\n"
> +		"eor z5.d, z5.d, z7.d\n"
> +
> +		"sub w7, w7, #1\n"
> +		"b 1b\n"
> +		"2:\n"
> +
> +		"mov w7, %w[start]\n"
> +		"sub w7, w7, #1\n"
> +		"3:\n"
> +		"cmp w7, #0\n"
> +		"blt 4f\n"
> +
> +		"mov z3.d, z1.d\n"
> +		"asr z3.b, p0/m, z3.b, #7\n"
> +		"lsl z1.b, p0/m, z1.b, #1\n"
> +		"and z3.d, z3.d, z4.d\n"
> +		"eor z1.d, z1.d, z3.d\n"
> +
> +		"mov z8.d, z6.d\n"
> +		"asr z8.b, p0/m, z8.b, #7\n"
> +		"lsl z6.b, p0/m, z6.b, #1\n"
> +		"and z8.d, z8.d, z4.d\n"
> +		"eor z6.d, z6.d, z8.d\n"
> +
> +		"sub w7, w7, #1\n"
> +		"b 3b\n"
> +		"4:\n"
> +
> +		"ld1b z2.b, p0/z, [%[q], x5]\n"
> +		"eor z1.d, z1.d, z2.d\n"
> +		"st1b z0.b, p0, [%[p], x5]\n"
> +		"st1b z1.b, p0, [%[q], x5]\n"
> +
> +		"add x8, x5, x3\n"
> +		"ld1b z7.b, p0/z, [%[q], x8]\n"
> +		"eor z6.d, z6.d, z7.d\n"
> +		"st1b z5.b, p0, [%[p], x8]\n"
> +		"st1b z6.b, p0, [%[q], x8]\n"
> +
> +		"add x5, x5, x3\n"
> +		"add x5, x5, x3\n"
> +		"cmp x5, %[bytes]\n"
> +		"blt 0b\n"
> +		:
> +		: [dptr] "r" (dptr), [z0] "r" (z0), [bytes] "r" (bytes),
> +		  [p] "r" (p), [q] "r" (q), [start] "r" (start)
> +		: "memory", "p0", "x3", "x4", "x5", "x6", "x7", "x8",
> +		  "z0", "z1", "z2", "z3", "z4",
> +		  "z5", "z6", "z7", "z8"
> +	);
> +}
> +
> +static void raid6_sve4_gen_syndrome_real(int disks, unsigned long 
> bytes, void **ptrs)
> +{
> +	u8 **dptr = (u8 **)ptrs;
> +	u8 *p, *q;
> +	long z0 = disks - 3;
> +
> +	p = dptr[z0 + 1];
> +	q = dptr[z0 + 2];
> +
> +	asm volatile(
> +		".arch armv8.2-a+sve\n"
> +		"ptrue p0.b\n"
> +		"cntb x3\n"
> +		"mov w4, #0x1d\n"
> +		"dup z4.b, w4\n"
> +		"mov x5, #0\n"
> +
> +		"0:\n"
> +		"ldr x6, [%[dptr], %[z0], lsl #3]\n"
> +		"ld1b z0.b, p0/z, [x6, x5]\n"
> +		"add x8, x5, x3\n"
> +		"ld1b z5.b, p0/z, [x6, x8]\n"
> +		"add x8, x8, x3\n"
> +		"ld1b z10.b, p0/z, [x6, x8]\n"
> +		"add x8, x8, x3\n"
> +		"ld1b z15.b, p0/z, [x6, x8]\n"
> +
> +		"mov z1.d, z0.d\n"
> +		"mov z6.d, z5.d\n"
> +		"mov z11.d, z10.d\n"
> +		"mov z16.d, z15.d\n"
> +
> +		"mov w7, %w[z0]\n"
> +		"sub w7, w7, #1\n"
> +
> +		"1:\n"
> +		"cmp w7, #0\n"
> +		"blt 2f\n"
> +
> +		// software pipelining: load data early
> +		"sxtw x8, w7\n"
> +		"ldr x6, [%[dptr], x8, lsl #3]\n"
> +		"ld1b z2.b, p0/z, [x6, x5]\n"
> +		"add x8, x5, x3\n"
> +		"ld1b z7.b, p0/z, [x6, x8]\n"
> +		"add x8, x8, x3\n"
> +		"ld1b z12.b, p0/z, [x6, x8]\n"
> +		"add x8, x8, x3\n"
> +		"ld1b z17.b, p0/z, [x6, x8]\n"
> +
> +		// math block 1
> +		"mov z3.d, z1.d\n"
> +		"asr z3.b, p0/m, z3.b, #7\n"
> +		"lsl z1.b, p0/m, z1.b, #1\n"
> +		"and z3.d, z3.d, z4.d\n"
> +		"eor z1.d, z1.d, z3.d\n"
> +		"eor z1.d, z1.d, z2.d\n"
> +		"eor z0.d, z0.d, z2.d\n"
> +
> +		// math block 2
> +		"mov z8.d, z6.d\n"
> +		"asr z8.b, p0/m, z8.b, #7\n"
> +		"lsl z6.b, p0/m, z6.b, #1\n"
> +		"and z8.d, z8.d, z4.d\n"
> +		"eor z6.d, z6.d, z8.d\n"
> +		"eor z6.d, z6.d, z7.d\n"
> +		"eor z5.d, z5.d, z7.d\n"
> +
> +		// math block 3
> +		"mov z13.d, z11.d\n"
> +		"asr z13.b, p0/m, z13.b, #7\n"
> +		"lsl z11.b, p0/m, z11.b, #1\n"
> +		"and z13.d, z13.d, z4.d\n"
> +		"eor z11.d, z11.d, z13.d\n"
> +		"eor z11.d, z11.d, z12.d\n"
> +		"eor z10.d, z10.d, z12.d\n"
> +
> +		// math block 4
> +		"mov z18.d, z16.d\n"
> +		"asr z18.b, p0/m, z18.b, #7\n"
> +		"lsl z16.b, p0/m, z16.b, #1\n"
> +		"and z18.d, z18.d, z4.d\n"
> +		"eor z16.d, z16.d, z18.d\n"
> +		"eor z16.d, z16.d, z17.d\n"
> +		"eor z15.d, z15.d, z17.d\n"
> +
> +		"sub w7, w7, #1\n"
> +		"b 1b\n"
> +		"2:\n"
> +
> +		"st1b z0.b, p0, [%[p], x5]\n"
> +		"st1b z1.b, p0, [%[q], x5]\n"
> +		"add x8, x5, x3\n"
> +		"st1b z5.b, p0, [%[p], x8]\n"
> +		"st1b z6.b, p0, [%[q], x8]\n"
> +		"add x8, x8, x3\n"
> +		"st1b z10.b, p0, [%[p], x8]\n"
> +		"st1b z11.b, p0, [%[q], x8]\n"
> +		"add x8, x8, x3\n"
> +		"st1b z15.b, p0, [%[p], x8]\n"
> +		"st1b z16.b, p0, [%[q], x8]\n"
> +
> +		"add x8, x3, x3\n"
> +		"add x5, x5, x8, lsl #1\n"
> +		"cmp x5, %[bytes]\n"
> +		"blt 0b\n"
> +		:
> +		: [dptr] "r" (dptr), [z0] "r" (z0), [bytes] "r" (bytes),
> +		  [p] "r" (p), [q] "r" (q)
> +		: "memory", "p0", "x3", "x4", "x5", "x6", "x7", "x8",
> +		  "z0", "z1", "z2", "z3", "z4",
> +		  "z5", "z6", "z7", "z8",
> +		  "z10", "z11", "z12", "z13",
> +		  "z15", "z16", "z17", "z18"
> +	);
> +}
> +
> +static void raid6_sve4_xor_syndrome_real(int disks, int start, int 
> stop,
> +					 unsigned long bytes, void **ptrs)
> +{
> +	u8 **dptr = (u8 **)ptrs;
> +	u8 *p, *q;
> +	long z0 = stop;
> +
> +	p = dptr[disks - 2];
> +	q = dptr[disks - 1];
> +
> +	asm volatile(
> +		".arch armv8.2-a+sve\n"
> +		"ptrue p0.b\n"
> +		"cntb x3\n"
> +		"mov w4, #0x1d\n"
> +		"dup z4.b, w4\n"
> +		"mov x5, #0\n"
> +
> +		"0:\n"
> +		"ldr x6, [%[dptr], %[z0], lsl #3]\n"
> +		"ld1b z1.b, p0/z, [x6, x5]\n"
> +		"add x8, x5, x3\n"
> +		"ld1b z6.b, p0/z, [x6, x8]\n"
> +		"add x8, x8, x3\n"
> +		"ld1b z11.b, p0/z, [x6, x8]\n"
> +		"add x8, x8, x3\n"
> +		"ld1b z16.b, p0/z, [x6, x8]\n"
> +
> +		"ld1b z0.b, p0/z, [%[p], x5]\n"
> +		"add x8, x5, x3\n"
> +		"ld1b z5.b, p0/z, [%[p], x8]\n"
> +		"add x8, x8, x3\n"
> +		"ld1b z10.b, p0/z, [%[p], x8]\n"
> +		"add x8, x8, x3\n"
> +		"ld1b z15.b, p0/z, [%[p], x8]\n"
> +
> +		"eor z0.d, z0.d, z1.d\n"
> +		"eor z5.d, z5.d, z6.d\n"
> +		"eor z10.d, z10.d, z11.d\n"
> +		"eor z15.d, z15.d, z16.d\n"
> +
> +		"mov w7, %w[z0]\n"
> +		"sub w7, w7, #1\n"
> +
> +		"1:\n"
> +		"cmp w7, %w[start]\n"
> +		"blt 2f\n"
> +
> +		// software pipelining: load data early
> +		"sxtw x8, w7\n"
> +		"ldr x6, [%[dptr], x8, lsl #3]\n"
> +		"ld1b z2.b, p0/z, [x6, x5]\n"
> +		"add x8, x5, x3\n"
> +		"ld1b z7.b, p0/z, [x6, x8]\n"
> +		"add x8, x8, x3\n"
> +		"ld1b z12.b, p0/z, [x6, x8]\n"
> +		"add x8, x8, x3\n"
> +		"ld1b z17.b, p0/z, [x6, x8]\n"
> +
> +		// math block 1
> +		"mov z3.d, z1.d\n"
> +		"asr z3.b, p0/m, z3.b, #7\n"
> +		"lsl z1.b, p0/m, z1.b, #1\n"
> +		"and z3.d, z3.d, z4.d\n"
> +		"eor z1.d, z1.d, z3.d\n"
> +		"eor z1.d, z1.d, z2.d\n"
> +		"eor z0.d, z0.d, z2.d\n"
> +
> +		// math block 2
> +		"mov z8.d, z6.d\n"
> +		"asr z8.b, p0/m, z8.b, #7\n"
> +		"lsl z6.b, p0/m, z6.b, #1\n"
> +		"and z8.d, z8.d, z4.d\n"
> +		"eor z6.d, z6.d, z8.d\n"
> +		"eor z6.d, z6.d, z7.d\n"
> +		"eor z5.d, z5.d, z7.d\n"
> +
> +		// math block 3
> +		"mov z13.d, z11.d\n"
> +		"asr z13.b, p0/m, z13.b, #7\n"
> +		"lsl z11.b, p0/m, z11.b, #1\n"
> +		"and z13.d, z13.d, z4.d\n"
> +		"eor z11.d, z11.d, z13.d\n"
> +		"eor z11.d, z11.d, z12.d\n"
> +		"eor z10.d, z10.d, z12.d\n"
> +
> +		// math block 4
> +		"mov z18.d, z16.d\n"
> +		"asr z18.b, p0/m, z18.b, #7\n"
> +		"lsl z16.b, p0/m, z16.b, #1\n"
> +		"and z18.d, z18.d, z4.d\n"
> +		"eor z16.d, z16.d, z18.d\n"
> +		"eor z16.d, z16.d, z17.d\n"
> +		"eor z15.d, z15.d, z17.d\n"
> +
> +		"sub w7, w7, #1\n"
> +		"b 1b\n"
> +		"2:\n"
> +
> +		"mov w7, %w[start]\n"
> +		"sub w7, w7, #1\n"
> +		"3:\n"
> +		"cmp w7, #0\n"
> +		"blt 4f\n"
> +
> +		// math block 1
> +		"mov z3.d, z1.d\n"
> +		"asr z3.b, p0/m, z3.b, #7\n"
> +		"lsl z1.b, p0/m, z1.b, #1\n"
> +		"and z3.d, z3.d, z4.d\n"
> +		"eor z1.d, z1.d, z3.d\n"
> +
> +		// math block 2
> +		"mov z8.d, z6.d\n"
> +		"asr z8.b, p0/m, z8.b, #7\n"
> +		"lsl z6.b, p0/m, z6.b, #1\n"
> +		"and z8.d, z8.d, z4.d\n"
> +		"eor z6.d, z6.d, z8.d\n"
> +
> +		// math block 3
> +		"mov z13.d, z11.d\n"
> +		"asr z13.b, p0/m, z13.b, #7\n"
> +		"lsl z11.b, p0/m, z11.b, #1\n"
> +		"and z13.d, z13.d, z4.d\n"
> +		"eor z11.d, z11.d, z13.d\n"
> +
> +		// math block 4
> +		"mov z18.d, z16.d\n"
> +		"asr z18.b, p0/m, z18.b, #7\n"
> +		"lsl z16.b, p0/m, z16.b, #1\n"
> +		"and z18.d, z18.d, z4.d\n"
> +		"eor z16.d, z16.d, z18.d\n"
> +
> +		"sub w7, w7, #1\n"
> +		"b 3b\n"
> +		"4:\n"
> +
> +		// Load q and XOR
> +		"ld1b z2.b, p0/z, [%[q], x5]\n"
> +		"add x8, x5, x3\n"
> +		"ld1b z7.b, p0/z, [%[q], x8]\n"
> +		"add x8, x8, x3\n"
> +		"ld1b z12.b, p0/z, [%[q], x8]\n"
> +		"add x8, x8, x3\n"
> +		"ld1b z17.b, p0/z, [%[q], x8]\n"
> +
> +		"eor z1.d, z1.d, z2.d\n"
> +		"eor z6.d, z6.d, z7.d\n"
> +		"eor z11.d, z11.d, z12.d\n"
> +		"eor z16.d, z16.d, z17.d\n"
> +
> +		// Store results
> +		"st1b z0.b, p0, [%[p], x5]\n"
> +		"st1b z1.b, p0, [%[q], x5]\n"
> +		"add x8, x5, x3\n"
> +		"st1b z5.b, p0, [%[p], x8]\n"
> +		"st1b z6.b, p0, [%[q], x8]\n"
> +		"add x8, x8, x3\n"
> +		"st1b z10.b, p0, [%[p], x8]\n"
> +		"st1b z11.b, p0, [%[q], x8]\n"
> +		"add x8, x8, x3\n"
> +		"st1b z15.b, p0, [%[p], x8]\n"
> +		"st1b z16.b, p0, [%[q], x8]\n"
> +
> +		"add x8, x3, x3\n"
> +		"add x5, x5, x8, lsl #1\n"
> +		"cmp x5, %[bytes]\n"
> +		"blt 0b\n"
> +		:
> +		: [dptr] "r" (dptr), [z0] "r" (z0), [bytes] "r" (bytes),
> +		  [p] "r" (p), [q] "r" (q), [start] "r" (start)
> +		: "memory", "p0", "x3", "x4", "x5", "x6", "x7", "x8",
> +		  "z0", "z1", "z2", "z3", "z4",
> +		  "z5", "z6", "z7", "z8",
> +		  "z10", "z11", "z12", "z13",
> +		  "z15", "z16", "z17", "z18"
> +	);
> +}
> +
> +#define RAID6_SVE_WRAPPER(_n)						\
> +	static void raid6_sve ## _n ## _gen_syndrome(int disks,		\
> +					size_t bytes, void **ptrs)	\
> +	{								\
> +		scoped_ksimd()						\
> +		raid6_sve ## _n ## _gen_syndrome_real(disks,		\
> +					(unsigned long)bytes, ptrs);	\
> +	}								\
> +	static void raid6_sve ## _n ## _xor_syndrome(int disks,		\
> +					int start, int stop,		\
> +					size_t bytes, void **ptrs)	\
> +	{								\
> +		scoped_ksimd()						\
> +		raid6_sve ## _n ## _xor_syndrome_real(disks,		\
> +				start, stop, (unsigned long)bytes, ptrs);\
> +	}								\
> +	struct raid6_calls const raid6_svex ## _n = {			\
> +		raid6_sve ## _n ## _gen_syndrome,			\
> +		raid6_sve ## _n ## _xor_syndrome,			\
> +		raid6_have_sve,						\
> +		"svex" #_n,						\
> +		0							\
> +	}
> +
> +static int raid6_have_sve(void)
> +{
> +	return system_supports_sve();
> +}
> +
> +RAID6_SVE_WRAPPER(1);
> +RAID6_SVE_WRAPPER(2);
> +RAID6_SVE_WRAPPER(4);
> -- 
> 2.43.0
