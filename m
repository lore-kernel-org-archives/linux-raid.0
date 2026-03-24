Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF0203E0C7D;
	Tue, 24 Mar 2026 10:05:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774346713; cv=none; b=GbX+cNDf1D5KD+FcgqBkL86UmlPNRexrsaFF6I9CWUE5+i4fgO0E28xeqQgRoSkCaxDRt3pYjEXimp7SJVj6XIG7JZ5UOGEBze3oOsowxmIp6PqjnPcLJzjGWZjtAhPYtZ06ViskXa5qVgT/zdLxnkE3K2tEapVeOC1h2lfzGzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774346713; c=relaxed/simple;
	bh=6S7P4NziI50cPRqM1iC9RvC9/ndqFQiWlg1+O7BTwsI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uS6wuWwX4YQ0BHMJSKYOL0ZIh1oPhMy7+Z5vesxyxDf4B4jsz2rQqJ1dxhdbe+Vse9QrG0vI57aVTuLJNCoAAoi1Th6A6dvZ6ZoA6DkMtLMbA3RDWptBjx8IMJVs8xXA4j6UKRrsaemax6Z5CVWQwn0k5CvcDcidFgLT8G4b5mk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 994BB1476;
	Tue, 24 Mar 2026 03:04:53 -0700 (PDT)
Received: from J2N7QTR9R3 (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3EC6E3F63F;
	Tue, 24 Mar 2026 03:04:55 -0700 (PDT)
Date: Tue, 24 Mar 2026 10:04:22 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Ard Biesheuvel <ardb@kernel.org>, Christoph Hellwig <hch@lst.de>,
	Demian Shulhan <demyansh@gmail.com>
Cc: Song Liu <song@kernel.org>, Yu Kuai <yukuai@fnnas.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>, broonie@kernel.org,
	linux-arm-kernel@lists.infradead.org, robin.murphy@arm.com,
	Li Nan <linan122@huawei.com>, linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] raid6: arm64: add SVE optimized implementation for
 syndrome generation
Message-ID: <acJhCCPfVxjFUZ5R@J2N7QTR9R3>
References: <20260318150245.3080719-1-demyansh@gmail.com>
 <f9bc0534-4b7a-4b14-974b-4d7811ccd899@app.fastmail.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f9bc0534-4b7a-4b14-974b-4d7811ccd899@app.fastmail.com>

On Tue, Mar 24, 2026 at 09:00:16AM +0100, Ard Biesheuvel wrote:
> On Wed, 18 Mar 2026, at 16:02, Demian Shulhan wrote:
> > Implement Scalable Vector Extension (SVE) optimized routines for RAID6
> > syndrome generation and recovery on ARM64.
> >
> > The SVE instruction set allows for variable vector lengths (from 128 to
> > 2048 bits), scaling automatically with the hardware capabilities. This
> > implementation handles arbitrary SVE vector lengths using the `cntb`
> > instruction to determine the runtime vector length.
> >
> > The implementation introduces `svex1`, `svex2`, and `svex4` algorithms.
> > The `svex4` algorithm utilizes loop unrolling by 4 blocks per iteration
> > and manual software pipelining (interleaving memory loads with XORs)
> > to minimize instruction dependency stalls and maximize CPU pipeline
> > utilization and memory bandwidth.
> >
> > Performance was tested on an AWS Graviton3 (Neoverse-V1) instance which
> > features 256-bit SVE vector length. The `svex4` implementation outperforms
> > the existing 128-bit `neonx4` baseline for syndrome generation:
> >
> > raid6: svex4    gen() 19688 MB/s
> ...
> > raid6: neonx4   gen() 19612 MB/s
> 
> You're being very generous characterising a 0.3% speedup as 'outperforms'
> 
> But the real problem here is that the kernel-mode SIMD API only
> supports NEON and not SVE, and preserves/restores only the 128-bit
> view on the NEON/SVE register file. So any context switch or softirq
> that uses kernel-mode SIMD too, and your SVE register values will get
> truncated.

Just to be a bit more explicit, since only the NEON register file is
saved:

* The vector registers will be truncated to 128-bit across
  preemption or softirq.

* The predicates won't be saved/restored and will change arbitrarily
  across preemption.

* The VL won't be saved/restored, and might change arbitrarily across
  preemption.

* The VL to use hasn't been programmed, so performance might vary
  arbitrarily even in the absence of preemption.

... so this isn't even safe on machines with (only) a 128-bit VL, and
there are big open design questions for the infrastructure we'd need.

> Once we encounter a good use case for SVE in the kernel, we might
> reconsider this, but as it stands, this patch should not be applied.

I agree.

Christoph, please do not pick this or any other in-kernel SVE patches.
They cannot function correctly without additional infrastructure.

Demian, for patches that use NEON/SVE/SME/etc, please Cc LAKML
(linux-arm-kernel@lists.infradead.org), so that folk familiar with ARM
see the patches.

Mark

> (leaving the reply untrimmed for the benefit of the cc'ees I added)
> 
> > raid6: neonx2   gen() 16248 MB/s
> > raid6: neonx1   gen() 13591 MB/s
> > raid6: using algorithm svex4 gen() 19688 MB/s
> > raid6: .... xor() 11212 MB/s, rmw enabled
> > raid6: using neon recovery algorithm
> >
> > Note that for the recovery path (`xor_syndrome`), NEON may still be
> > selected dynamically by the algorithm benchmark, as the recovery
> > workload is heavily memory-bound.
> >
> > Signed-off-by: Demian Shulhan <demyansh@gmail.com>
> > Reported-by: kernel test robot <lkp@intel.com>
> > Closes: 
> > https://lore.kernel.org/oe-kbuild-all/202603181940.cFwYmYoi-lkp@intel.com/
> > ---
> >  include/linux/raid/pq.h |   3 +
> >  lib/raid6/Makefile      |   5 +
> >  lib/raid6/algos.c       |   5 +
> >  lib/raid6/sve.c         | 675 ++++++++++++++++++++++++++++++++++++++++
> >  4 files changed, 688 insertions(+)
> >  create mode 100644 lib/raid6/sve.c
> >
> > diff --git a/include/linux/raid/pq.h b/include/linux/raid/pq.h
> > index 2467b3be15c9..787cc57aea9d 100644
> > --- a/include/linux/raid/pq.h
> > +++ b/include/linux/raid/pq.h
> > @@ -140,6 +140,9 @@ extern const struct raid6_calls raid6_neonx1;
> >  extern const struct raid6_calls raid6_neonx2;
> >  extern const struct raid6_calls raid6_neonx4;
> >  extern const struct raid6_calls raid6_neonx8;
> > +extern const struct raid6_calls raid6_svex1;
> > +extern const struct raid6_calls raid6_svex2;
> > +extern const struct raid6_calls raid6_svex4;
> > 
> >  /* Algorithm list */
> >  extern const struct raid6_calls * const raid6_algos[];
> > diff --git a/lib/raid6/Makefile b/lib/raid6/Makefile
> > index 5be0a4e60ab1..6cdaa6f206fb 100644
> > --- a/lib/raid6/Makefile
> > +++ b/lib/raid6/Makefile
> > @@ -8,6 +8,7 @@ raid6_pq-$(CONFIG_X86) += recov_ssse3.o recov_avx2.o 
> > mmx.o sse1.o sse2.o avx2.o
> >  raid6_pq-$(CONFIG_ALTIVEC) += altivec1.o altivec2.o altivec4.o 
> > altivec8.o \
> >                                vpermxor1.o vpermxor2.o vpermxor4.o 
> > vpermxor8.o
> >  raid6_pq-$(CONFIG_KERNEL_MODE_NEON) += neon.o neon1.o neon2.o neon4.o 
> > neon8.o recov_neon.o recov_neon_inner.o
> > +raid6_pq-$(CONFIG_ARM64_SVE) += sve.o
> >  raid6_pq-$(CONFIG_S390) += s390vx8.o recov_s390xc.o
> >  raid6_pq-$(CONFIG_LOONGARCH) += loongarch_simd.o recov_loongarch_simd.o
> >  raid6_pq-$(CONFIG_RISCV_ISA_V) += rvv.o recov_rvv.o
> > @@ -67,6 +68,10 @@ CFLAGS_REMOVE_neon2.o += $(CC_FLAGS_NO_FPU)
> >  CFLAGS_REMOVE_neon4.o += $(CC_FLAGS_NO_FPU)
> >  CFLAGS_REMOVE_neon8.o += $(CC_FLAGS_NO_FPU)
> >  CFLAGS_REMOVE_recov_neon_inner.o += $(CC_FLAGS_NO_FPU)
> > +
> > +CFLAGS_sve.o += $(CC_FLAGS_FPU)
> > +CFLAGS_REMOVE_sve.o += $(CC_FLAGS_NO_FPU)
> > +
> >  targets += neon1.c neon2.c neon4.c neon8.c
> >  $(obj)/neon%.c: $(src)/neon.uc $(src)/unroll.awk FORCE
> >  	$(call if_changed,unroll)
> > diff --git a/lib/raid6/algos.c b/lib/raid6/algos.c
> > index 799e0e5eac26..0ae73c3a4be3 100644
> > --- a/lib/raid6/algos.c
> > +++ b/lib/raid6/algos.c
> > @@ -66,6 +66,11 @@ const struct raid6_calls * const raid6_algos[] = {
> >  	&raid6_neonx2,
> >  	&raid6_neonx1,
> >  #endif
> > +#ifdef CONFIG_ARM64_SVE
> > +	&raid6_svex4,
> > +	&raid6_svex2,
> > +	&raid6_svex1,
> > +#endif
> >  #ifdef CONFIG_LOONGARCH
> >  #ifdef CONFIG_CPU_HAS_LASX
> >  	&raid6_lasx,
> > diff --git a/lib/raid6/sve.c b/lib/raid6/sve.c
> > new file mode 100644
> > index 000000000000..d52937f806d4
> > --- /dev/null
> > +++ b/lib/raid6/sve.c
> > @@ -0,0 +1,675 @@
> > +// SPDX-License-Identifier: GPL-2.0-or-later
> > +/*
> > + * RAID-6 syndrome calculation using ARM SVE instructions
> > + */
> > +
> > +#include <linux/raid/pq.h>
> > +
> > +#ifdef __KERNEL__
> > +#include <asm/simd.h>
> > +#include <linux/cpufeature.h>
> > +#else
> > +#define scoped_ksimd()
> > +#define system_supports_sve() (1)
> > +#endif
> > +
> > +static void raid6_sve1_gen_syndrome_real(int disks, unsigned long 
> > bytes, void **ptrs)
> > +{
> > +	u8 **dptr = (u8 **)ptrs;
> > +	u8 *p, *q;
> > +	long z0 = disks - 3;
> > +
> > +	p = dptr[z0 + 1];
> > +	q = dptr[z0 + 2];
> > +
> > +	asm volatile(
> > +		".arch armv8.2-a+sve\n"
> > +		"ptrue p0.b\n"
> > +		"cntb x3\n"
> > +		"mov w4, #0x1d\n"
> > +		"dup z4.b, w4\n"
> > +		"mov x5, #0\n"
> > +
> > +		"0:\n"
> > +		"ldr x6, [%[dptr], %[z0], lsl #3]\n"
> > +		"ld1b z0.b, p0/z, [x6, x5]\n"
> > +		"mov z1.d, z0.d\n"
> > +
> > +		"mov w7, %w[z0]\n"
> > +		"sub w7, w7, #1\n"
> > +
> > +		"1:\n"
> > +		"cmp w7, #0\n"
> > +		"blt 2f\n"
> > +
> > +		"mov z3.d, z1.d\n"
> > +		"asr z3.b, p0/m, z3.b, #7\n"
> > +		"lsl z1.b, p0/m, z1.b, #1\n"
> > +
> > +		"and z3.d, z3.d, z4.d\n"
> > +		"eor z1.d, z1.d, z3.d\n"
> > +
> > +		"sxtw x8, w7\n"
> > +		"ldr x6, [%[dptr], x8, lsl #3]\n"
> > +		"ld1b z2.b, p0/z, [x6, x5]\n"
> > +
> > +		"eor z1.d, z1.d, z2.d\n"
> > +		"eor z0.d, z0.d, z2.d\n"
> > +
> > +		"sub w7, w7, #1\n"
> > +		"b 1b\n"
> > +		"2:\n"
> > +
> > +		"st1b z0.b, p0, [%[p], x5]\n"
> > +		"st1b z1.b, p0, [%[q], x5]\n"
> > +
> > +		"add x5, x5, x3\n"
> > +		"cmp x5, %[bytes]\n"
> > +		"blt 0b\n"
> > +		:
> > +		: [dptr] "r" (dptr), [z0] "r" (z0), [bytes] "r" (bytes),
> > +		  [p] "r" (p), [q] "r" (q)
> > +		: "memory", "p0", "x3", "x4", "x5", "x6", "x7", "x8",
> > +		  "z0", "z1", "z2", "z3", "z4"
> > +	);
> > +}
> > +
> > +static void raid6_sve1_xor_syndrome_real(int disks, int start, int 
> > stop,
> > +					 unsigned long bytes, void **ptrs)
> > +{
> > +	u8 **dptr = (u8 **)ptrs;
> > +	u8 *p, *q;
> > +	long z0 = stop;
> > +
> > +	p = dptr[disks - 2];
> > +	q = dptr[disks - 1];
> > +
> > +	asm volatile(
> > +		".arch armv8.2-a+sve\n"
> > +		"ptrue p0.b\n"
> > +		"cntb x3\n"
> > +		"mov w4, #0x1d\n"
> > +		"dup z4.b, w4\n"
> > +		"mov x5, #0\n"
> > +
> > +		"0:\n"
> > +		"ldr x6, [%[dptr], %[z0], lsl #3]\n"
> > +		"ld1b z1.b, p0/z, [x6, x5]\n"
> > +		"ld1b z0.b, p0/z, [%[p], x5]\n"
> > +		"eor z0.d, z0.d, z1.d\n"
> > +
> > +		"mov w7, %w[z0]\n"
> > +		"sub w7, w7, #1\n"
> > +
> > +		"1:\n"
> > +		"cmp w7, %w[start]\n"
> > +		"blt 2f\n"
> > +
> > +		"mov z3.d, z1.d\n"
> > +		"asr z3.b, p0/m, z3.b, #7\n"
> > +		"lsl z1.b, p0/m, z1.b, #1\n"
> > +		"and z3.d, z3.d, z4.d\n"
> > +		"eor z1.d, z1.d, z3.d\n"
> > +
> > +		"sxtw x8, w7\n"
> > +		"ldr x6, [%[dptr], x8, lsl #3]\n"
> > +		"ld1b z2.b, p0/z, [x6, x5]\n"
> > +
> > +		"eor z1.d, z1.d, z2.d\n"
> > +		"eor z0.d, z0.d, z2.d\n"
> > +
> > +		"sub w7, w7, #1\n"
> > +		"b 1b\n"
> > +		"2:\n"
> > +
> > +		"mov w7, %w[start]\n"
> > +		"sub w7, w7, #1\n"
> > +		"3:\n"
> > +		"cmp w7, #0\n"
> > +		"blt 4f\n"
> > +
> > +		"mov z3.d, z1.d\n"
> > +		"asr z3.b, p0/m, z3.b, #7\n"
> > +		"lsl z1.b, p0/m, z1.b, #1\n"
> > +		"and z3.d, z3.d, z4.d\n"
> > +		"eor z1.d, z1.d, z3.d\n"
> > +
> > +		"sub w7, w7, #1\n"
> > +		"b 3b\n"
> > +		"4:\n"
> > +
> > +		"ld1b z2.b, p0/z, [%[q], x5]\n"
> > +		"eor z1.d, z1.d, z2.d\n"
> > +
> > +		"st1b z0.b, p0, [%[p], x5]\n"
> > +		"st1b z1.b, p0, [%[q], x5]\n"
> > +
> > +		"add x5, x5, x3\n"
> > +		"cmp x5, %[bytes]\n"
> > +		"blt 0b\n"
> > +		:
> > +		: [dptr] "r" (dptr), [z0] "r" (z0), [bytes] "r" (bytes),
> > +		  [p] "r" (p), [q] "r" (q), [start] "r" (start)
> > +		: "memory", "p0", "x3", "x4", "x5", "x6", "x7", "x8",
> > +		  "z0", "z1", "z2", "z3", "z4"
> > +	);
> > +}
> > +
> > +static void raid6_sve2_gen_syndrome_real(int disks, unsigned long 
> > bytes, void **ptrs)
> > +{
> > +	u8 **dptr = (u8 **)ptrs;
> > +	u8 *p, *q;
> > +	long z0 = disks - 3;
> > +
> > +	p = dptr[z0 + 1];
> > +	q = dptr[z0 + 2];
> > +
> > +	asm volatile(
> > +		".arch armv8.2-a+sve\n"
> > +		"ptrue p0.b\n"
> > +		"cntb x3\n"
> > +		"mov w4, #0x1d\n"
> > +		"dup z4.b, w4\n"
> > +		"mov x5, #0\n"
> > +
> > +		"0:\n"
> > +		"ldr x6, [%[dptr], %[z0], lsl #3]\n"
> > +		"ld1b z0.b, p0/z, [x6, x5]\n"
> > +		"add x8, x5, x3\n"
> > +		"ld1b z5.b, p0/z, [x6, x8]\n"
> > +		"mov z1.d, z0.d\n"
> > +		"mov z6.d, z5.d\n"
> > +
> > +		"mov w7, %w[z0]\n"
> > +		"sub w7, w7, #1\n"
> > +
> > +		"1:\n"
> > +		"cmp w7, #0\n"
> > +		"blt 2f\n"
> > +
> > +		"mov z3.d, z1.d\n"
> > +		"asr z3.b, p0/m, z3.b, #7\n"
> > +		"lsl z1.b, p0/m, z1.b, #1\n"
> > +		"and z3.d, z3.d, z4.d\n"
> > +		"eor z1.d, z1.d, z3.d\n"
> > +
> > +		"mov z8.d, z6.d\n"
> > +		"asr z8.b, p0/m, z8.b, #7\n"
> > +		"lsl z6.b, p0/m, z6.b, #1\n"
> > +		"and z8.d, z8.d, z4.d\n"
> > +		"eor z6.d, z6.d, z8.d\n"
> > +
> > +		"sxtw x8, w7\n"
> > +		"ldr x6, [%[dptr], x8, lsl #3]\n"
> > +		"ld1b z2.b, p0/z, [x6, x5]\n"
> > +		"add x8, x5, x3\n"
> > +		"ld1b z7.b, p0/z, [x6, x8]\n"
> > +
> > +		"eor z1.d, z1.d, z2.d\n"
> > +		"eor z0.d, z0.d, z2.d\n"
> > +
> > +		"eor z6.d, z6.d, z7.d\n"
> > +		"eor z5.d, z5.d, z7.d\n"
> > +
> > +		"sub w7, w7, #1\n"
> > +		"b 1b\n"
> > +		"2:\n"
> > +
> > +		"st1b z0.b, p0, [%[p], x5]\n"
> > +		"st1b z1.b, p0, [%[q], x5]\n"
> > +		"add x8, x5, x3\n"
> > +		"st1b z5.b, p0, [%[p], x8]\n"
> > +		"st1b z6.b, p0, [%[q], x8]\n"
> > +
> > +		"add x5, x5, x3\n"
> > +		"add x5, x5, x3\n"
> > +		"cmp x5, %[bytes]\n"
> > +		"blt 0b\n"
> > +		:
> > +		: [dptr] "r" (dptr), [z0] "r" (z0), [bytes] "r" (bytes),
> > +		  [p] "r" (p), [q] "r" (q)
> > +		: "memory", "p0", "x3", "x4", "x5", "x6", "x7", "x8",
> > +		  "z0", "z1", "z2", "z3", "z4",
> > +		  "z5", "z6", "z7", "z8"
> > +	);
> > +}
> > +
> > +static void raid6_sve2_xor_syndrome_real(int disks, int start, int 
> > stop,
> > +					 unsigned long bytes, void **ptrs)
> > +{
> > +	u8 **dptr = (u8 **)ptrs;
> > +	u8 *p, *q;
> > +	long z0 = stop;
> > +
> > +	p = dptr[disks - 2];
> > +	q = dptr[disks - 1];
> > +
> > +	asm volatile(
> > +		".arch armv8.2-a+sve\n"
> > +		"ptrue p0.b\n"
> > +		"cntb x3\n"
> > +		"mov w4, #0x1d\n"
> > +		"dup z4.b, w4\n"
> > +		"mov x5, #0\n"
> > +
> > +		"0:\n"
> > +		"ldr x6, [%[dptr], %[z0], lsl #3]\n"
> > +		"ld1b z1.b, p0/z, [x6, x5]\n"
> > +		"add x8, x5, x3\n"
> > +		"ld1b z6.b, p0/z, [x6, x8]\n"
> > +
> > +		"ld1b z0.b, p0/z, [%[p], x5]\n"
> > +		"ld1b z5.b, p0/z, [%[p], x8]\n"
> > +
> > +		"eor z0.d, z0.d, z1.d\n"
> > +		"eor z5.d, z5.d, z6.d\n"
> > +
> > +		"mov w7, %w[z0]\n"
> > +		"sub w7, w7, #1\n"
> > +
> > +		"1:\n"
> > +		"cmp w7, %w[start]\n"
> > +		"blt 2f\n"
> > +
> > +		"mov z3.d, z1.d\n"
> > +		"asr z3.b, p0/m, z3.b, #7\n"
> > +		"lsl z1.b, p0/m, z1.b, #1\n"
> > +		"and z3.d, z3.d, z4.d\n"
> > +		"eor z1.d, z1.d, z3.d\n"
> > +
> > +		"mov z8.d, z6.d\n"
> > +		"asr z8.b, p0/m, z8.b, #7\n"
> > +		"lsl z6.b, p0/m, z6.b, #1\n"
> > +		"and z8.d, z8.d, z4.d\n"
> > +		"eor z6.d, z6.d, z8.d\n"
> > +
> > +		"sxtw x8, w7\n"
> > +		"ldr x6, [%[dptr], x8, lsl #3]\n"
> > +		"ld1b z2.b, p0/z, [x6, x5]\n"
> > +		"add x8, x5, x3\n"
> > +		"ld1b z7.b, p0/z, [x6, x8]\n"
> > +
> > +		"eor z1.d, z1.d, z2.d\n"
> > +		"eor z0.d, z0.d, z2.d\n"
> > +
> > +		"eor z6.d, z6.d, z7.d\n"
> > +		"eor z5.d, z5.d, z7.d\n"
> > +
> > +		"sub w7, w7, #1\n"
> > +		"b 1b\n"
> > +		"2:\n"
> > +
> > +		"mov w7, %w[start]\n"
> > +		"sub w7, w7, #1\n"
> > +		"3:\n"
> > +		"cmp w7, #0\n"
> > +		"blt 4f\n"
> > +
> > +		"mov z3.d, z1.d\n"
> > +		"asr z3.b, p0/m, z3.b, #7\n"
> > +		"lsl z1.b, p0/m, z1.b, #1\n"
> > +		"and z3.d, z3.d, z4.d\n"
> > +		"eor z1.d, z1.d, z3.d\n"
> > +
> > +		"mov z8.d, z6.d\n"
> > +		"asr z8.b, p0/m, z8.b, #7\n"
> > +		"lsl z6.b, p0/m, z6.b, #1\n"
> > +		"and z8.d, z8.d, z4.d\n"
> > +		"eor z6.d, z6.d, z8.d\n"
> > +
> > +		"sub w7, w7, #1\n"
> > +		"b 3b\n"
> > +		"4:\n"
> > +
> > +		"ld1b z2.b, p0/z, [%[q], x5]\n"
> > +		"eor z1.d, z1.d, z2.d\n"
> > +		"st1b z0.b, p0, [%[p], x5]\n"
> > +		"st1b z1.b, p0, [%[q], x5]\n"
> > +
> > +		"add x8, x5, x3\n"
> > +		"ld1b z7.b, p0/z, [%[q], x8]\n"
> > +		"eor z6.d, z6.d, z7.d\n"
> > +		"st1b z5.b, p0, [%[p], x8]\n"
> > +		"st1b z6.b, p0, [%[q], x8]\n"
> > +
> > +		"add x5, x5, x3\n"
> > +		"add x5, x5, x3\n"
> > +		"cmp x5, %[bytes]\n"
> > +		"blt 0b\n"
> > +		:
> > +		: [dptr] "r" (dptr), [z0] "r" (z0), [bytes] "r" (bytes),
> > +		  [p] "r" (p), [q] "r" (q), [start] "r" (start)
> > +		: "memory", "p0", "x3", "x4", "x5", "x6", "x7", "x8",
> > +		  "z0", "z1", "z2", "z3", "z4",
> > +		  "z5", "z6", "z7", "z8"
> > +	);
> > +}
> > +
> > +static void raid6_sve4_gen_syndrome_real(int disks, unsigned long 
> > bytes, void **ptrs)
> > +{
> > +	u8 **dptr = (u8 **)ptrs;
> > +	u8 *p, *q;
> > +	long z0 = disks - 3;
> > +
> > +	p = dptr[z0 + 1];
> > +	q = dptr[z0 + 2];
> > +
> > +	asm volatile(
> > +		".arch armv8.2-a+sve\n"
> > +		"ptrue p0.b\n"
> > +		"cntb x3\n"
> > +		"mov w4, #0x1d\n"
> > +		"dup z4.b, w4\n"
> > +		"mov x5, #0\n"
> > +
> > +		"0:\n"
> > +		"ldr x6, [%[dptr], %[z0], lsl #3]\n"
> > +		"ld1b z0.b, p0/z, [x6, x5]\n"
> > +		"add x8, x5, x3\n"
> > +		"ld1b z5.b, p0/z, [x6, x8]\n"
> > +		"add x8, x8, x3\n"
> > +		"ld1b z10.b, p0/z, [x6, x8]\n"
> > +		"add x8, x8, x3\n"
> > +		"ld1b z15.b, p0/z, [x6, x8]\n"
> > +
> > +		"mov z1.d, z0.d\n"
> > +		"mov z6.d, z5.d\n"
> > +		"mov z11.d, z10.d\n"
> > +		"mov z16.d, z15.d\n"
> > +
> > +		"mov w7, %w[z0]\n"
> > +		"sub w7, w7, #1\n"
> > +
> > +		"1:\n"
> > +		"cmp w7, #0\n"
> > +		"blt 2f\n"
> > +
> > +		// software pipelining: load data early
> > +		"sxtw x8, w7\n"
> > +		"ldr x6, [%[dptr], x8, lsl #3]\n"
> > +		"ld1b z2.b, p0/z, [x6, x5]\n"
> > +		"add x8, x5, x3\n"
> > +		"ld1b z7.b, p0/z, [x6, x8]\n"
> > +		"add x8, x8, x3\n"
> > +		"ld1b z12.b, p0/z, [x6, x8]\n"
> > +		"add x8, x8, x3\n"
> > +		"ld1b z17.b, p0/z, [x6, x8]\n"
> > +
> > +		// math block 1
> > +		"mov z3.d, z1.d\n"
> > +		"asr z3.b, p0/m, z3.b, #7\n"
> > +		"lsl z1.b, p0/m, z1.b, #1\n"
> > +		"and z3.d, z3.d, z4.d\n"
> > +		"eor z1.d, z1.d, z3.d\n"
> > +		"eor z1.d, z1.d, z2.d\n"
> > +		"eor z0.d, z0.d, z2.d\n"
> > +
> > +		// math block 2
> > +		"mov z8.d, z6.d\n"
> > +		"asr z8.b, p0/m, z8.b, #7\n"
> > +		"lsl z6.b, p0/m, z6.b, #1\n"
> > +		"and z8.d, z8.d, z4.d\n"
> > +		"eor z6.d, z6.d, z8.d\n"
> > +		"eor z6.d, z6.d, z7.d\n"
> > +		"eor z5.d, z5.d, z7.d\n"
> > +
> > +		// math block 3
> > +		"mov z13.d, z11.d\n"
> > +		"asr z13.b, p0/m, z13.b, #7\n"
> > +		"lsl z11.b, p0/m, z11.b, #1\n"
> > +		"and z13.d, z13.d, z4.d\n"
> > +		"eor z11.d, z11.d, z13.d\n"
> > +		"eor z11.d, z11.d, z12.d\n"
> > +		"eor z10.d, z10.d, z12.d\n"
> > +
> > +		// math block 4
> > +		"mov z18.d, z16.d\n"
> > +		"asr z18.b, p0/m, z18.b, #7\n"
> > +		"lsl z16.b, p0/m, z16.b, #1\n"
> > +		"and z18.d, z18.d, z4.d\n"
> > +		"eor z16.d, z16.d, z18.d\n"
> > +		"eor z16.d, z16.d, z17.d\n"
> > +		"eor z15.d, z15.d, z17.d\n"
> > +
> > +		"sub w7, w7, #1\n"
> > +		"b 1b\n"
> > +		"2:\n"
> > +
> > +		"st1b z0.b, p0, [%[p], x5]\n"
> > +		"st1b z1.b, p0, [%[q], x5]\n"
> > +		"add x8, x5, x3\n"
> > +		"st1b z5.b, p0, [%[p], x8]\n"
> > +		"st1b z6.b, p0, [%[q], x8]\n"
> > +		"add x8, x8, x3\n"
> > +		"st1b z10.b, p0, [%[p], x8]\n"
> > +		"st1b z11.b, p0, [%[q], x8]\n"
> > +		"add x8, x8, x3\n"
> > +		"st1b z15.b, p0, [%[p], x8]\n"
> > +		"st1b z16.b, p0, [%[q], x8]\n"
> > +
> > +		"add x8, x3, x3\n"
> > +		"add x5, x5, x8, lsl #1\n"
> > +		"cmp x5, %[bytes]\n"
> > +		"blt 0b\n"
> > +		:
> > +		: [dptr] "r" (dptr), [z0] "r" (z0), [bytes] "r" (bytes),
> > +		  [p] "r" (p), [q] "r" (q)
> > +		: "memory", "p0", "x3", "x4", "x5", "x6", "x7", "x8",
> > +		  "z0", "z1", "z2", "z3", "z4",
> > +		  "z5", "z6", "z7", "z8",
> > +		  "z10", "z11", "z12", "z13",
> > +		  "z15", "z16", "z17", "z18"
> > +	);
> > +}
> > +
> > +static void raid6_sve4_xor_syndrome_real(int disks, int start, int 
> > stop,
> > +					 unsigned long bytes, void **ptrs)
> > +{
> > +	u8 **dptr = (u8 **)ptrs;
> > +	u8 *p, *q;
> > +	long z0 = stop;
> > +
> > +	p = dptr[disks - 2];
> > +	q = dptr[disks - 1];
> > +
> > +	asm volatile(
> > +		".arch armv8.2-a+sve\n"
> > +		"ptrue p0.b\n"
> > +		"cntb x3\n"
> > +		"mov w4, #0x1d\n"
> > +		"dup z4.b, w4\n"
> > +		"mov x5, #0\n"
> > +
> > +		"0:\n"
> > +		"ldr x6, [%[dptr], %[z0], lsl #3]\n"
> > +		"ld1b z1.b, p0/z, [x6, x5]\n"
> > +		"add x8, x5, x3\n"
> > +		"ld1b z6.b, p0/z, [x6, x8]\n"
> > +		"add x8, x8, x3\n"
> > +		"ld1b z11.b, p0/z, [x6, x8]\n"
> > +		"add x8, x8, x3\n"
> > +		"ld1b z16.b, p0/z, [x6, x8]\n"
> > +
> > +		"ld1b z0.b, p0/z, [%[p], x5]\n"
> > +		"add x8, x5, x3\n"
> > +		"ld1b z5.b, p0/z, [%[p], x8]\n"
> > +		"add x8, x8, x3\n"
> > +		"ld1b z10.b, p0/z, [%[p], x8]\n"
> > +		"add x8, x8, x3\n"
> > +		"ld1b z15.b, p0/z, [%[p], x8]\n"
> > +
> > +		"eor z0.d, z0.d, z1.d\n"
> > +		"eor z5.d, z5.d, z6.d\n"
> > +		"eor z10.d, z10.d, z11.d\n"
> > +		"eor z15.d, z15.d, z16.d\n"
> > +
> > +		"mov w7, %w[z0]\n"
> > +		"sub w7, w7, #1\n"
> > +
> > +		"1:\n"
> > +		"cmp w7, %w[start]\n"
> > +		"blt 2f\n"
> > +
> > +		// software pipelining: load data early
> > +		"sxtw x8, w7\n"
> > +		"ldr x6, [%[dptr], x8, lsl #3]\n"
> > +		"ld1b z2.b, p0/z, [x6, x5]\n"
> > +		"add x8, x5, x3\n"
> > +		"ld1b z7.b, p0/z, [x6, x8]\n"
> > +		"add x8, x8, x3\n"
> > +		"ld1b z12.b, p0/z, [x6, x8]\n"
> > +		"add x8, x8, x3\n"
> > +		"ld1b z17.b, p0/z, [x6, x8]\n"
> > +
> > +		// math block 1
> > +		"mov z3.d, z1.d\n"
> > +		"asr z3.b, p0/m, z3.b, #7\n"
> > +		"lsl z1.b, p0/m, z1.b, #1\n"
> > +		"and z3.d, z3.d, z4.d\n"
> > +		"eor z1.d, z1.d, z3.d\n"
> > +		"eor z1.d, z1.d, z2.d\n"
> > +		"eor z0.d, z0.d, z2.d\n"
> > +
> > +		// math block 2
> > +		"mov z8.d, z6.d\n"
> > +		"asr z8.b, p0/m, z8.b, #7\n"
> > +		"lsl z6.b, p0/m, z6.b, #1\n"
> > +		"and z8.d, z8.d, z4.d\n"
> > +		"eor z6.d, z6.d, z8.d\n"
> > +		"eor z6.d, z6.d, z7.d\n"
> > +		"eor z5.d, z5.d, z7.d\n"
> > +
> > +		// math block 3
> > +		"mov z13.d, z11.d\n"
> > +		"asr z13.b, p0/m, z13.b, #7\n"
> > +		"lsl z11.b, p0/m, z11.b, #1\n"
> > +		"and z13.d, z13.d, z4.d\n"
> > +		"eor z11.d, z11.d, z13.d\n"
> > +		"eor z11.d, z11.d, z12.d\n"
> > +		"eor z10.d, z10.d, z12.d\n"
> > +
> > +		// math block 4
> > +		"mov z18.d, z16.d\n"
> > +		"asr z18.b, p0/m, z18.b, #7\n"
> > +		"lsl z16.b, p0/m, z16.b, #1\n"
> > +		"and z18.d, z18.d, z4.d\n"
> > +		"eor z16.d, z16.d, z18.d\n"
> > +		"eor z16.d, z16.d, z17.d\n"
> > +		"eor z15.d, z15.d, z17.d\n"
> > +
> > +		"sub w7, w7, #1\n"
> > +		"b 1b\n"
> > +		"2:\n"
> > +
> > +		"mov w7, %w[start]\n"
> > +		"sub w7, w7, #1\n"
> > +		"3:\n"
> > +		"cmp w7, #0\n"
> > +		"blt 4f\n"
> > +
> > +		// math block 1
> > +		"mov z3.d, z1.d\n"
> > +		"asr z3.b, p0/m, z3.b, #7\n"
> > +		"lsl z1.b, p0/m, z1.b, #1\n"
> > +		"and z3.d, z3.d, z4.d\n"
> > +		"eor z1.d, z1.d, z3.d\n"
> > +
> > +		// math block 2
> > +		"mov z8.d, z6.d\n"
> > +		"asr z8.b, p0/m, z8.b, #7\n"
> > +		"lsl z6.b, p0/m, z6.b, #1\n"
> > +		"and z8.d, z8.d, z4.d\n"
> > +		"eor z6.d, z6.d, z8.d\n"
> > +
> > +		// math block 3
> > +		"mov z13.d, z11.d\n"
> > +		"asr z13.b, p0/m, z13.b, #7\n"
> > +		"lsl z11.b, p0/m, z11.b, #1\n"
> > +		"and z13.d, z13.d, z4.d\n"
> > +		"eor z11.d, z11.d, z13.d\n"
> > +
> > +		// math block 4
> > +		"mov z18.d, z16.d\n"
> > +		"asr z18.b, p0/m, z18.b, #7\n"
> > +		"lsl z16.b, p0/m, z16.b, #1\n"
> > +		"and z18.d, z18.d, z4.d\n"
> > +		"eor z16.d, z16.d, z18.d\n"
> > +
> > +		"sub w7, w7, #1\n"
> > +		"b 3b\n"
> > +		"4:\n"
> > +
> > +		// Load q and XOR
> > +		"ld1b z2.b, p0/z, [%[q], x5]\n"
> > +		"add x8, x5, x3\n"
> > +		"ld1b z7.b, p0/z, [%[q], x8]\n"
> > +		"add x8, x8, x3\n"
> > +		"ld1b z12.b, p0/z, [%[q], x8]\n"
> > +		"add x8, x8, x3\n"
> > +		"ld1b z17.b, p0/z, [%[q], x8]\n"
> > +
> > +		"eor z1.d, z1.d, z2.d\n"
> > +		"eor z6.d, z6.d, z7.d\n"
> > +		"eor z11.d, z11.d, z12.d\n"
> > +		"eor z16.d, z16.d, z17.d\n"
> > +
> > +		// Store results
> > +		"st1b z0.b, p0, [%[p], x5]\n"
> > +		"st1b z1.b, p0, [%[q], x5]\n"
> > +		"add x8, x5, x3\n"
> > +		"st1b z5.b, p0, [%[p], x8]\n"
> > +		"st1b z6.b, p0, [%[q], x8]\n"
> > +		"add x8, x8, x3\n"
> > +		"st1b z10.b, p0, [%[p], x8]\n"
> > +		"st1b z11.b, p0, [%[q], x8]\n"
> > +		"add x8, x8, x3\n"
> > +		"st1b z15.b, p0, [%[p], x8]\n"
> > +		"st1b z16.b, p0, [%[q], x8]\n"
> > +
> > +		"add x8, x3, x3\n"
> > +		"add x5, x5, x8, lsl #1\n"
> > +		"cmp x5, %[bytes]\n"
> > +		"blt 0b\n"
> > +		:
> > +		: [dptr] "r" (dptr), [z0] "r" (z0), [bytes] "r" (bytes),
> > +		  [p] "r" (p), [q] "r" (q), [start] "r" (start)
> > +		: "memory", "p0", "x3", "x4", "x5", "x6", "x7", "x8",
> > +		  "z0", "z1", "z2", "z3", "z4",
> > +		  "z5", "z6", "z7", "z8",
> > +		  "z10", "z11", "z12", "z13",
> > +		  "z15", "z16", "z17", "z18"
> > +	);
> > +}
> > +
> > +#define RAID6_SVE_WRAPPER(_n)						\
> > +	static void raid6_sve ## _n ## _gen_syndrome(int disks,		\
> > +					size_t bytes, void **ptrs)	\
> > +	{								\
> > +		scoped_ksimd()						\
> > +		raid6_sve ## _n ## _gen_syndrome_real(disks,		\
> > +					(unsigned long)bytes, ptrs);	\
> > +	}								\
> > +	static void raid6_sve ## _n ## _xor_syndrome(int disks,		\
> > +					int start, int stop,		\
> > +					size_t bytes, void **ptrs)	\
> > +	{								\
> > +		scoped_ksimd()						\
> > +		raid6_sve ## _n ## _xor_syndrome_real(disks,		\
> > +				start, stop, (unsigned long)bytes, ptrs);\
> > +	}								\
> > +	struct raid6_calls const raid6_svex ## _n = {			\
> > +		raid6_sve ## _n ## _gen_syndrome,			\
> > +		raid6_sve ## _n ## _xor_syndrome,			\
> > +		raid6_have_sve,						\
> > +		"svex" #_n,						\
> > +		0							\
> > +	}
> > +
> > +static int raid6_have_sve(void)
> > +{
> > +	return system_supports_sve();
> > +}
> > +
> > +RAID6_SVE_WRAPPER(1);
> > +RAID6_SVE_WRAPPER(2);
> > +RAID6_SVE_WRAPPER(4);
> > -- 
> > 2.43.0
