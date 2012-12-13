From: Yuanhan Liu <yuanhan.liu@linux.intel.com>
Subject: Re: [PATCH 1/2] lib/raid6: Add AVX2 optimized gen_syndrome functions
Date: Thu, 13 Dec 2012 16:35:09 +0800
Message-ID: <20121213083509.GZ2095@yliu-dev.sh.intel.com>
References: <1354309840-9360-1-git-send-email-james.t.kukunas@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1354309840-9360-1-git-send-email-james.t.kukunas@linux.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jim Kukunas <james.t.kukunas@linux.intel.com>
Cc: Neil Brown <neilb@suse.de>, Linux Raid <linux-raid@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
List-Id: linux-raid.ids

On Fri, Nov 30, 2012 at 01:10:39PM -0800, Jim Kukunas wrote:
> From: Yuanhan Liu <yuanhan.liu@linux.intel.com>
> 
> Add AVX2 optimized gen_syndrom functions, which is simply based on
> sse2.c written by hpa.
> 
> Signed-off-by: Yuanhan Liu <yuanhan.liu@linux.intel.com>
> Reviewed-by: H. Peter Anvin <hpa@zytor.com>
> Signed-off-by: Jim Kukunas <james.t.kukunas@linux.intel.com>
> ---
>  include/linux/raid/pq.h |   3 +
>  lib/raid6/Makefile      |   2 +-
>  lib/raid6/algos.c       |   9 ++
>  lib/raid6/avx2.c        | 251 ++++++++++++++++++++++++++++++++++++++++++++++++
>  lib/raid6/test/Makefile |  12 ++-
>  5 files changed, 275 insertions(+), 2 deletions(-)
>  create mode 100644 lib/raid6/avx2.c

Hi Neil,

Ping...

Thanks.

	--yliu
> 
> diff --git a/include/linux/raid/pq.h b/include/linux/raid/pq.h
> index 3156347..8dfaa2c 100644
> --- a/include/linux/raid/pq.h
> +++ b/include/linux/raid/pq.h
> @@ -98,6 +98,9 @@ extern const struct raid6_calls raid6_altivec1;
>  extern const struct raid6_calls raid6_altivec2;
>  extern const struct raid6_calls raid6_altivec4;
>  extern const struct raid6_calls raid6_altivec8;
> +extern const struct raid6_calls raid6_avx2x1;
> +extern const struct raid6_calls raid6_avx2x2;
> +extern const struct raid6_calls raid6_avx2x4;
>  
>  struct raid6_recov_calls {
>  	void (*data2)(int, size_t, int, int, void **);
> diff --git a/lib/raid6/Makefile b/lib/raid6/Makefile
> index 8c2e22b..3430711 100644
> --- a/lib/raid6/Makefile
> +++ b/lib/raid6/Makefile
> @@ -2,7 +2,7 @@ obj-$(CONFIG_RAID6_PQ)	+= raid6_pq.o
>  
>  raid6_pq-y	+= algos.o recov.o recov_ssse3.o recov_avx2.o tables.o int1.o int2.o int4.o \
>  		   int8.o int16.o int32.o altivec1.o altivec2.o altivec4.o \
> -		   altivec8.o mmx.o sse1.o sse2.o
> +		   altivec8.o mmx.o sse1.o sse2.o avx2.o
>  hostprogs-y	+= mktables
>  
>  quiet_cmd_unroll = UNROLL  $@
> diff --git a/lib/raid6/algos.c b/lib/raid6/algos.c
> index 8b7f55c..6d7316f 100644
> --- a/lib/raid6/algos.c
> +++ b/lib/raid6/algos.c
> @@ -45,11 +45,20 @@ const struct raid6_calls * const raid6_algos[] = {
>  	&raid6_sse1x2,
>  	&raid6_sse2x1,
>  	&raid6_sse2x2,
> +#ifdef CONFIG_AS_AVX2
> +	&raid6_avx2x1,
> +	&raid6_avx2x2,
> +#endif
>  #endif
>  #if defined(__x86_64__) && !defined(__arch_um__)
>  	&raid6_sse2x1,
>  	&raid6_sse2x2,
>  	&raid6_sse2x4,
> +#ifdef CONFIG_AS_AVX2
> +	&raid6_avx2x1,
> +	&raid6_avx2x2,
> +	&raid6_avx2x4,
> +#endif
>  #endif
>  #ifdef CONFIG_ALTIVEC
>  	&raid6_altivec1,
> diff --git a/lib/raid6/avx2.c b/lib/raid6/avx2.c
> new file mode 100644
> index 0000000..bc3b1dd
> --- /dev/null
> +++ b/lib/raid6/avx2.c
> @@ -0,0 +1,251 @@
> +/* -*- linux-c -*- ------------------------------------------------------- *
> + *
> + *   Copyright (C) 2012 Intel Corporation
> + *   Author: Yuanhan Liu <yuanhan.liu@linux.intel.com>
> + *
> + *   Based on sse2.c: Copyright 2002 H. Peter Anvin - All Rights Reserved
> + *
> + *
> + *   This program is free software; you can redistribute it and/or modify
> + *   it under the terms of the GNU General Public License as published by
> + *   the Free Software Foundation, Inc., 53 Temple Place Ste 330,
> + *   Boston MA 02111-1307, USA; either version 2 of the License, or
> + *   (at your option) any later version; incorporated herein by reference.
> + *
> + * ----------------------------------------------------------------------- */
> +
> +/*
> + * AVX2 implementation of RAID-6 syndrome functions
> + *
> + */
> +
> +#ifdef CONFIG_AS_AVX2
> +
> +#include <linux/raid/pq.h>
> +#include "x86.h"
> +
> +static const struct raid6_avx2_constants {
> +	u64 x1d[4];
> +} raid6_avx2_constants __aligned(32) = {
> +	{ 0x1d1d1d1d1d1d1d1dULL, 0x1d1d1d1d1d1d1d1dULL,
> +	  0x1d1d1d1d1d1d1d1dULL, 0x1d1d1d1d1d1d1d1dULL,},
> +};
> +
> +static int raid6_have_avx2(void)
> +{
> +	return boot_cpu_has(X86_FEATURE_AVX2) && boot_cpu_has(X86_FEATURE_AVX);
> +}
> +
> +/*
> + * Plain AVX2 implementation
> + */
> +static void raid6_avx21_gen_syndrome(int disks, size_t bytes, void **ptrs)
> +{
> +	u8 **dptr = (u8 **)ptrs;
> +	u8 *p, *q;
> +	int d, z, z0;
> +
> +	z0 = disks - 3;		/* Highest data disk */
> +	p = dptr[z0+1];		/* XOR parity */
> +	q = dptr[z0+2];		/* RS syndrome */
> +
> +	kernel_fpu_begin();
> +
> +	asm volatile("vmovdqa %0,%%ymm0" : : "m" (raid6_avx2_constants.x1d[0]));
> +	asm volatile("vpxor %ymm3,%ymm3,%ymm3");	/* Zero temp */
> +
> +	for (d = 0; d < bytes; d += 32) {
> +		asm volatile("prefetchnta %0" : : "m" (dptr[z0][d]));
> +		asm volatile("vmovdqa %0,%%ymm2" : : "m" (dptr[z0][d]));/* P[0] */
> +		asm volatile("prefetchnta %0" : : "m" (dptr[z0-1][d]));
> +		asm volatile("vmovdqa %ymm2,%ymm4");/* Q[0] */
> +		asm volatile("vmovdqa %0,%%ymm6" : : "m" (dptr[z0-1][d]));
> +		for (z = z0-2; z >= 0; z--) {
> +			asm volatile("prefetchnta %0" : : "m" (dptr[z][d]));
> +			asm volatile("vpcmpgtb %ymm4,%ymm3,%ymm5");
> +			asm volatile("vpaddb %ymm4,%ymm4,%ymm4");
> +			asm volatile("vpand %ymm0,%ymm5,%ymm5");
> +			asm volatile("vpxor %ymm5,%ymm4,%ymm4");
> +			asm volatile("vpxor %ymm6,%ymm2,%ymm2");
> +			asm volatile("vpxor %ymm6,%ymm4,%ymm4");
> +			asm volatile("vmovdqa %0,%%ymm6" : : "m" (dptr[z][d]));
> +		}
> +		asm volatile("vpcmpgtb %ymm4,%ymm3,%ymm5");
> +		asm volatile("vpaddb %ymm4,%ymm4,%ymm4");
> +		asm volatile("vpand %ymm0,%ymm5,%ymm5");
> +		asm volatile("vpxor %ymm5,%ymm4,%ymm4");
> +		asm volatile("vpxor %ymm6,%ymm2,%ymm2");
> +		asm volatile("vpxor %ymm6,%ymm4,%ymm4");
> +
> +		asm volatile("vmovntdq %%ymm2,%0" : "=m" (p[d]));
> +		asm volatile("vpxor %ymm2,%ymm2,%ymm2");
> +		asm volatile("vmovntdq %%ymm4,%0" : "=m" (q[d]));
> +		asm volatile("vpxor %ymm4,%ymm4,%ymm4");
> +	}
> +
> +	asm volatile("sfence" : : : "memory");
> +	kernel_fpu_end();
> +}
> +
> +const struct raid6_calls raid6_avx2x1 = {
> +	raid6_avx21_gen_syndrome,
> +	raid6_have_avx2,
> +	"avx2x1",
> +	1			/* Has cache hints */
> +};
> +
> +/*
> + * Unrolled-by-2 AVX2 implementation
> + */
> +static void raid6_avx22_gen_syndrome(int disks, size_t bytes, void **ptrs)
> +{
> +	u8 **dptr = (u8 **)ptrs;
> +	u8 *p, *q;
> +	int d, z, z0;
> +
> +	z0 = disks - 3;		/* Highest data disk */
> +	p = dptr[z0+1];		/* XOR parity */
> +	q = dptr[z0+2];		/* RS syndrome */
> +
> +	kernel_fpu_begin();
> +
> +	asm volatile("vmovdqa %0,%%ymm0" : : "m" (raid6_avx2_constants.x1d[0]));
> +	asm volatile("vpxor %ymm1,%ymm1,%ymm1"); /* Zero temp */
> +
> +	/* We uniformly assume a single prefetch covers at least 32 bytes */
> +	for (d = 0; d < bytes; d += 64) {
> +		asm volatile("prefetchnta %0" : : "m" (dptr[z0][d]));
> +		asm volatile("prefetchnta %0" : : "m" (dptr[z0][d+32]));
> +		asm volatile("vmovdqa %0,%%ymm2" : : "m" (dptr[z0][d]));/* P[0] */
> +		asm volatile("vmovdqa %0,%%ymm3" : : "m" (dptr[z0][d+32]));/* P[1] */
> +		asm volatile("vmovdqa %ymm2,%ymm4"); /* Q[0] */
> +		asm volatile("vmovdqa %ymm3,%ymm6"); /* Q[1] */
> +		for (z = z0-1; z >= 0; z--) {
> +			asm volatile("prefetchnta %0" : : "m" (dptr[z][d]));
> +			asm volatile("prefetchnta %0" : : "m" (dptr[z][d+32]));
> +			asm volatile("vpcmpgtb %ymm4,%ymm1,%ymm5");
> +			asm volatile("vpcmpgtb %ymm6,%ymm1,%ymm7");
> +			asm volatile("vpaddb %ymm4,%ymm4,%ymm4");
> +			asm volatile("vpaddb %ymm6,%ymm6,%ymm6");
> +			asm volatile("vpand %ymm0,%ymm5,%ymm5");
> +			asm volatile("vpand %ymm0,%ymm7,%ymm7");
> +			asm volatile("vpxor %ymm5,%ymm4,%ymm4");
> +			asm volatile("vpxor %ymm7,%ymm6,%ymm6");
> +			asm volatile("vmovdqa %0,%%ymm5" : : "m" (dptr[z][d]));
> +			asm volatile("vmovdqa %0,%%ymm7" : : "m" (dptr[z][d+32]));
> +			asm volatile("vpxor %ymm5,%ymm2,%ymm2");
> +			asm volatile("vpxor %ymm7,%ymm3,%ymm3");
> +			asm volatile("vpxor %ymm5,%ymm4,%ymm4");
> +			asm volatile("vpxor %ymm7,%ymm6,%ymm6");
> +		}
> +		asm volatile("vmovntdq %%ymm2,%0" : "=m" (p[d]));
> +		asm volatile("vmovntdq %%ymm3,%0" : "=m" (p[d+32]));
> +		asm volatile("vmovntdq %%ymm4,%0" : "=m" (q[d]));
> +		asm volatile("vmovntdq %%ymm6,%0" : "=m" (q[d+32]));
> +	}
> +
> +	asm volatile("sfence" : : : "memory");
> +	kernel_fpu_end();
> +}
> +
> +const struct raid6_calls raid6_avx2x2 = {
> +	raid6_avx22_gen_syndrome,
> +	raid6_have_avx2,
> +	"avx2x2",
> +	1			/* Has cache hints */
> +};
> +
> +#ifdef CONFIG_X86_64
> +
> +/*
> + * Unrolled-by-4 AVX2 implementation
> + */
> +static void raid6_avx24_gen_syndrome(int disks, size_t bytes, void **ptrs)
> +{
> +	u8 **dptr = (u8 **)ptrs;
> +	u8 *p, *q;
> +	int d, z, z0;
> +
> +	z0 = disks - 3;		/* Highest data disk */
> +	p = dptr[z0+1];		/* XOR parity */
> +	q = dptr[z0+2];		/* RS syndrome */
> +
> +	kernel_fpu_begin();
> +
> +	asm volatile("vmovdqa %0,%%ymm0" : : "m" (raid6_avx2_constants.x1d[0]));
> +	asm volatile("vpxor %ymm1,%ymm1,%ymm1");	/* Zero temp */
> +	asm volatile("vpxor %ymm2,%ymm2,%ymm2");	/* P[0] */
> +	asm volatile("vpxor %ymm3,%ymm3,%ymm3");	/* P[1] */
> +	asm volatile("vpxor %ymm4,%ymm4,%ymm4");	/* Q[0] */
> +	asm volatile("vpxor %ymm6,%ymm6,%ymm6");	/* Q[1] */
> +	asm volatile("vpxor %ymm10,%ymm10,%ymm10");	/* P[2] */
> +	asm volatile("vpxor %ymm11,%ymm11,%ymm11");	/* P[3] */
> +	asm volatile("vpxor %ymm12,%ymm12,%ymm12");	/* Q[2] */
> +	asm volatile("vpxor %ymm14,%ymm14,%ymm14");	/* Q[3] */
> +
> +	for (d = 0; d < bytes; d += 128) {
> +		for (z = z0; z >= 0; z--) {
> +			asm volatile("prefetchnta %0" : : "m" (dptr[z][d]));
> +			asm volatile("prefetchnta %0" : : "m" (dptr[z][d+32]));
> +			asm volatile("prefetchnta %0" : : "m" (dptr[z][d+64]));
> +			asm volatile("prefetchnta %0" : : "m" (dptr[z][d+96]));
> +			asm volatile("vpcmpgtb %ymm4,%ymm1,%ymm5");
> +			asm volatile("vpcmpgtb %ymm6,%ymm1,%ymm7");
> +			asm volatile("vpcmpgtb %ymm12,%ymm1,%ymm13");
> +			asm volatile("vpcmpgtb %ymm14,%ymm1,%ymm15");
> +			asm volatile("vpaddb %ymm4,%ymm4,%ymm4");
> +			asm volatile("vpaddb %ymm6,%ymm6,%ymm6");
> +			asm volatile("vpaddb %ymm12,%ymm12,%ymm12");
> +			asm volatile("vpaddb %ymm14,%ymm14,%ymm14");
> +			asm volatile("vpand %ymm0,%ymm5,%ymm5");
> +			asm volatile("vpand %ymm0,%ymm7,%ymm7");
> +			asm volatile("vpand %ymm0,%ymm13,%ymm13");
> +			asm volatile("vpand %ymm0,%ymm15,%ymm15");
> +			asm volatile("vpxor %ymm5,%ymm4,%ymm4");
> +			asm volatile("vpxor %ymm7,%ymm6,%ymm6");
> +			asm volatile("vpxor %ymm13,%ymm12,%ymm12");
> +			asm volatile("vpxor %ymm15,%ymm14,%ymm14");
> +			asm volatile("vmovdqa %0,%%ymm5" : : "m" (dptr[z][d]));
> +			asm volatile("vmovdqa %0,%%ymm7" : : "m" (dptr[z][d+32]));
> +			asm volatile("vmovdqa %0,%%ymm13" : : "m" (dptr[z][d+64]));
> +			asm volatile("vmovdqa %0,%%ymm15" : : "m" (dptr[z][d+96]));
> +			asm volatile("vpxor %ymm5,%ymm2,%ymm2");
> +			asm volatile("vpxor %ymm7,%ymm3,%ymm3");
> +			asm volatile("vpxor %ymm13,%ymm10,%ymm10");
> +			asm volatile("vpxor %ymm15,%ymm11,%ymm11");
> +			asm volatile("vpxor %ymm5,%ymm4,%ymm4");
> +			asm volatile("vpxor %ymm7,%ymm6,%ymm6");
> +			asm volatile("vpxor %ymm13,%ymm12,%ymm12");
> +			asm volatile("vpxor %ymm15,%ymm14,%ymm14");
> +		}
> +		asm volatile("vmovntdq %%ymm2,%0" : "=m" (p[d]));
> +		asm volatile("vpxor %ymm2,%ymm2,%ymm2");
> +		asm volatile("vmovntdq %%ymm3,%0" : "=m" (p[d+32]));
> +		asm volatile("vpxor %ymm3,%ymm3,%ymm3");
> +		asm volatile("vmovntdq %%ymm10,%0" : "=m" (p[d+64]));
> +		asm volatile("vpxor %ymm10,%ymm10,%ymm10");
> +		asm volatile("vmovntdq %%ymm11,%0" : "=m" (p[d+96]));
> +		asm volatile("vpxor %ymm11,%ymm11,%ymm11");
> +		asm volatile("vmovntdq %%ymm4,%0" : "=m" (q[d]));
> +		asm volatile("vpxor %ymm4,%ymm4,%ymm4");
> +		asm volatile("vmovntdq %%ymm6,%0" : "=m" (q[d+32]));
> +		asm volatile("vpxor %ymm6,%ymm6,%ymm6");
> +		asm volatile("vmovntdq %%ymm12,%0" : "=m" (q[d+64]));
> +		asm volatile("vpxor %ymm12,%ymm12,%ymm12");
> +		asm volatile("vmovntdq %%ymm14,%0" : "=m" (q[d+96]));
> +		asm volatile("vpxor %ymm14,%ymm14,%ymm14");
> +	}
> +
> +	asm volatile("sfence" : : : "memory");
> +	kernel_fpu_end();
> +}
> +
> +const struct raid6_calls raid6_avx2x4 = {
> +	raid6_avx24_gen_syndrome,
> +	raid6_have_avx2,
> +	"avx2x4",
> +	1			/* Has cache hints */
> +};
> +#endif
> +
> +#endif /* CONFIG_AS_AVX2 */
> diff --git a/lib/raid6/test/Makefile b/lib/raid6/test/Makefile
> index d919c98..754cbac 100644
> --- a/lib/raid6/test/Makefile
> +++ b/lib/raid6/test/Makefile
> @@ -11,6 +11,16 @@ AWK	 = awk -f
>  AR	 = ar
>  RANLIB	 = ranlib
>  
> +ARCH := $(shell uname -m 2>/dev/null | sed -e /s/i.86/i386/)
> +ifeq ($(ARCH),i386)
> +        CFLAGS += -DCONFIG_X86_32
> +endif
> +ifeq ($(ARCH),x86_64)
> +        CFLAGS += -DCONFIG_X86_64
> +endif
> +CFLAGS += $(shell echo "vpbroadcastb %xmm0, %ymm1"| gcc -c -x assembler - &&\
> +	     rm ./-.o && echo -DCONFIG_AS_AVX2=1)
> +
>  .c.o:
>  	$(CC) $(CFLAGS) -c -o $@ $<
>  
> @@ -22,7 +32,7 @@ RANLIB	 = ranlib
>  
>  all:	raid6.a raid6test
>  
> -raid6.a: int1.o int2.o int4.o int8.o int16.o int32.o mmx.o sse1.o sse2.o \
> +raid6.a: int1.o int2.o int4.o int8.o int16.o int32.o mmx.o sse1.o sse2.o avx2.o \
>  	 altivec1.o altivec2.o altivec4.o altivec8.o recov.o recov_ssse3.o recov_avx2.o algos.o \
>  	 tables.o
>  	 rm -f $@
> -- 
> 1.8.0
