From: Daniel Axtens <dja@axtens.net>
Subject: Re: [PATCH] raid6/altivec: adding vpermxor implementation for raid6 Q syndrome
Date: Mon, 03 Apr 2017 21:37:20 +1000
Message-ID: <877f31n2mn.fsf@possimpible.ozlabs.ibm.com>
References: <20170330051313.31358-1-matthew.brown.dev@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170330051313.31358-1-matthew.brown.dev@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Matt Brown <matthew.brown.dev@gmail.com>, linux-raid@vger.kernel.org
Cc: linuxppc-dev@lists.ozlabs.org
List-Id: linux-raid.ids

Hi Matt,

> The raid6 Q syndrome check has been optimised using the vpermxor
> instruction.  This instruction was made available with POWER8, ISA version
> 2.07. It allows for both vperm and vxor instructions to be done in a single
> instruction. This has been tested for correctness on a ppc64le vm with a
> basic RAID6 setup containing 5 drives.
>
> The performance benchmarks are from the raid6test in the /lib/raid6/test
> directory. These results are from an IBM Firestone machine with ppc64le
> architecture. The benchmark results show a 35% speed increase over the best
> existing algorithm for powerpc (altivec). The raid6test has also been run
> on a big-endian ppc64 vm to ensure it also works for big-endian
> architectures.
>
> Performance benchmarks:
>
> 	raid6: altivecx4 gen() 18773 MB/s
> 	raid6: altivecx8 gen() 19438 MB/s
>
> 	raid6: vpermxor4 gen() 25112 MB/s
> 	raid6: vpermxor8 gen() 26279 MB/s
>
Well done!

> Note: Also fixed a small bug in pq.h regarding a missing and mismatched
> ifdef statement

So this could be slightly better explained:

4f8c55c5ad49 ("lib/raid6: build proper files on corresponding arch")
breaks raid6test on ppc by rearranging the ifdefs incorrectly.

You could possibly split that fix out into its own separate commit, but
that is probably overkill.

You should, however, probably include just before your Signed-off-by:
Fixes: 4f8c55c5ad49 ("lib/raid6: build proper files on corresponding arch")

> Signed-off-by: Matt Brown <matthew.brown.dev@gmail.com>
> ---
>  include/linux/raid/pq.h |   4 ++
>  lib/raid6/Makefile      |  27 ++++++++++++-
>  lib/raid6/algos.c       |   4 ++
>  lib/raid6/altivec.uc    |   3 ++
>  lib/raid6/test/Makefile |  28 ++++++++++++-
>  lib/raid6/vpermxor.uc   | 102 ++++++++++++++++++++++++++++++++++++++++++++++++
>  6 files changed, 165 insertions(+), 3 deletions(-)
>  create mode 100644 lib/raid6/vpermxor.uc
>
> diff --git a/include/linux/raid/pq.h b/include/linux/raid/pq.h
> index 4d57bba..3df9aa6 100644
> --- a/include/linux/raid/pq.h
> +++ b/include/linux/raid/pq.h
> @@ -107,6 +107,10 @@ extern const struct raid6_calls raid6_avx512x2;
>  extern const struct raid6_calls raid6_avx512x4;
>  extern const struct raid6_calls raid6_tilegx8;
>  extern const struct raid6_calls raid6_s390vx8;
> +extern const struct raid6_calls raid6_vpermxor1;
> +extern const struct raid6_calls raid6_vpermxor2;
> +extern const struct raid6_calls raid6_vpermxor4;
> +extern const struct raid6_calls raid6_vpermxor8;
>  
>  struct raid6_recov_calls {
>  	void (*data2)(int, size_t, int, int, void **);
> diff --git a/lib/raid6/Makefile b/lib/raid6/Makefile
> index 3057011..7775aad 100644
> --- a/lib/raid6/Makefile
> +++ b/lib/raid6/Makefile
> @@ -4,7 +4,8 @@ raid6_pq-y	+= algos.o recov.o tables.o int1.o int2.o int4.o \
>  		   int8.o int16.o int32.o
>  
>  raid6_pq-$(CONFIG_X86) += recov_ssse3.o recov_avx2.o mmx.o sse1.o sse2.o avx2.o avx512.o recov_avx512.o
> -raid6_pq-$(CONFIG_ALTIVEC) += altivec1.o altivec2.o altivec4.o altivec8.o
> +raid6_pq-$(CONFIG_ALTIVEC) += altivec1.o altivec2.o altivec4.o altivec8.o \
> +				vpermxor1.o vpermxor2.o vpermxor4.o vpermxor8.o
>  raid6_pq-$(CONFIG_KERNEL_MODE_NEON) += neon.o neon1.o neon2.o neon4.o neon8.o
>  raid6_pq-$(CONFIG_TILEGX) += tilegx8.o
>  raid6_pq-$(CONFIG_S390) += s390vx8.o recov_s390xc.o
> @@ -88,6 +89,30 @@ $(obj)/altivec8.c:   UNROLL := 8
>  $(obj)/altivec8.c:   $(src)/altivec.uc $(src)/unroll.awk FORCE
>  	$(call if_changed,unroll)
>  
> +CFLAGS_vpermxor1.o += $(altivec_flags)
> +targets += vpermxor1.c
> +$(obj)/vpermxor1.c: UNROLL := 1
> +$(obj)/vpermxor1.c: $(src)/vpermxor.uc $(src)/unroll.awk FORCE
> +	$(call if_changed,unroll)
> +
> +CFLAGS_vpermxor2.o += $(altivec_flags)
> +targets += vpermxor2.c
> +$(obj)/vpermxor2.c: UNROLL := 2
> +$(obj)/vpermxor2.c: $(src)/vpermxor.uc $(src)/unroll.awk FORCE
> +	$(call if_changed,unroll)
> +
> +CFLAGS_vpermxor4.o += $(altivec_flags)
> +targets += vpermxor4.c
> +$(obj)/vpermxor4.c: UNROLL := 4
> +$(obj)/vpermxor4.c: $(src)/vpermxor.uc $(src)/unroll.awk FORCE
> +	$(call if_changed,unroll)
> +
> +CFLAGS_vpermxor8.o += $(altivec_flags)
> +targets += vpermxor8.c
> +$(obj)/vpermxor8.c: UNROLL := 8
> +$(obj)/vpermxor8.c: $(src)/vpermxor.uc $(src)/unroll.awk FORCE
> +	$(call if_changed,unroll)
> +
>  CFLAGS_neon1.o += $(NEON_FLAGS)
>  targets += neon1.c
>  $(obj)/neon1.c:   UNROLL := 1
> diff --git a/lib/raid6/algos.c b/lib/raid6/algos.c
> index 7857049..edd4f69 100644
> --- a/lib/raid6/algos.c
> +++ b/lib/raid6/algos.c
> @@ -74,6 +74,10 @@ const struct raid6_calls * const raid6_algos[] = {
>  	&raid6_altivec2,
>  	&raid6_altivec4,
>  	&raid6_altivec8,
> +	&raid6_vpermxor1,
> +	&raid6_vpermxor2,
> +	&raid6_vpermxor4,
> +	&raid6_vpermxor8,
>  #endif
>  #if defined(CONFIG_TILEGX)
>  	&raid6_tilegx8,
> diff --git a/lib/raid6/altivec.uc b/lib/raid6/altivec.uc
> index 682aae8..d20ed0d 100644
> --- a/lib/raid6/altivec.uc
> +++ b/lib/raid6/altivec.uc
> @@ -24,10 +24,13 @@
>  
>  #include <linux/raid/pq.h>
>  
> +#ifdef CONFIG_ALTIVEC
> +
>  #include <altivec.h>
>  #ifdef __KERNEL__
>  # include <asm/cputable.h>
>  # include <asm/switch_to.h>
> +#endif /* __KERNEL__ */
>  
>  /*
>   * This is the C data type to use.  We use a vector of
> diff --git a/lib/raid6/test/Makefile b/lib/raid6/test/Makefile
> index 2c7b60e..29ebb39 100644
> --- a/lib/raid6/test/Makefile
> +++ b/lib/raid6/test/Makefile
> @@ -47,13 +47,25 @@ else
>                           gcc -c -x c - >&/dev/null && \
>                           rm ./-.o && echo yes)
>          ifeq ($(HAS_ALTIVEC),yes)
> -                OBJS += altivec1.o altivec2.o altivec4.o altivec8.o
> +		OBJS += altivec1.o altivec2.o altivec4.o altivec8.o
Your editor seems to have replaced the spaces with tabs here - you could
drop this hunk entirely.

>          endif
>  endif
>  ifeq ($(ARCH),tilegx)
>  OBJS += tilegx8.o
>  endif
>  
> +ifeq ($(ARCH),ppc64le)
> +	CFLAGS += -I../../../arch/powerpc/include
> +	CFLAGS += -DCONFIG_ALTIVEC
> +	OBJS += altivec1.o altivec2.o altivec4.o altivec8.o \
> +		vpermxor1.o vpermxor2.o vpermxor4.o vpermxor8.o
> +else ifeq ($(ARCH),ppc64)
> +	CFLAGS += -I../../../arch/powerpc/include
> +	CFLAGS += -DCONFIG_ALTIVEC
> +	OBJS += altivec1.o altivec2.o altivec4.o altivec8.o \
> +		vpermxor1.o vpermxor2.o vpermxor4.o vpermxor8.o
> +endif

These two test bodies are the same, right? Could you replace this all
with a test for HAS_ALTIVEC?

> +
>  .c.o:
>  	$(CC) $(CFLAGS) -c -o $@ $<
>  
> @@ -97,6 +109,18 @@ altivec4.c: altivec.uc ../unroll.awk
>  altivec8.c: altivec.uc ../unroll.awk
>  	$(AWK) ../unroll.awk -vN=8 < altivec.uc > $@
>  
> +vpermxor1.c: vpermxor.uc ../unroll.awk
> +	$(AWK) ../unroll.awk -vN=1 < vpermxor.uc > $@
> +
> +vpermxor2.c: vpermxor.uc ../unroll.awk
> +	$(AWK) ../unroll.awk -vN=2 < vpermxor.uc > $@
> +
> +vpermxor4.c: vpermxor.uc ../unroll.awk
> +	$(AWK) ../unroll.awk -vN=4 < vpermxor.uc > $@
> +
> +vpermxor8.c: vpermxor.uc ../unroll.awk
> +	$(AWK) ../unroll.awk -vN=8 < vpermxor.uc > $@
> +
>  int1.c: int.uc ../unroll.awk
>  	$(AWK) ../unroll.awk -vN=1 < int.uc > $@
>  
> @@ -122,7 +146,7 @@ tables.c: mktables
>  	./mktables > tables.c
>  
>  clean:
> -	rm -f *.o *.a mktables mktables.c *.uc int*.c altivec*.c neon*.c tables.c raid6test
> +	rm -f *.o *.a mktables mktables.c *.uc int*.c altivec*.c vpermxor*.c neon*.c tables.c raid6test
>  	rm -f tilegx*.c
>  
>  spotless: clean
> diff --git a/lib/raid6/vpermxor.uc b/lib/raid6/vpermxor.uc
> new file mode 100644
> index 0000000..96f48e3
> --- /dev/null
> +++ b/lib/raid6/vpermxor.uc
> @@ -0,0 +1,102 @@
> +/*
> + * Copyright 2017, Matt Brown, IBM Corp.
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License
> + * as published by the Free Software Foundation; either version
> + * 2 of the License, or (at your option) any later version.
> + *
> + * vpermxor$#.c
> + *
> + * $#-way unrolled portable integer math RAID-6 instruction set
> + * This file is postprocessed using unroll.awk
> + *
> + * vpermxor$#.c makes use of the vpermxor opcode to optimise the RAID6 Q
> + * syndrome calculations.
> + * This can be run on systems which have both Altivec and the vpermxor opcode.
> + *
> + * This instruction was introduced in POWER8 - ISA v2.07.
> + */
> +
> +#include <linux/raid/pq.h>
> +#ifdef CONFIG_ALTIVEC
> +
> +#include <altivec.h>
> +#ifdef __KERNEL__
> +#include <asm/cputable.h>
> +#include <asm/switch_to.h>
> +#endif
> +
> +typedef vector unsigned char unative_t;
> +#define NSIZE sizeof(unative_t)
> +

A comment about how these are generated wouldn't go astray. Even if it's
just a link to H. Peter Anvin's paper :)

> +static const vector unsigned char gf_low = {0x1e, 0x1c, 0x1a, 0x18, 0x16, 0x14,
> +					    0x12, 0x10, 0x0e, 0x0c, 0x0a, 0x08,
> +					    0x06, 0x04, 0x02,0x00};
> +static const vector unsigned char gf_high = {0xfd, 0xdd, 0xbd, 0x9d, 0x7d, 0x5d,
> +					     0x3d, 0x1d, 0xe0, 0xc0, 0xa0, 0x80,
> +					     0x60, 0x40, 0x20, 0x00};
> +
> +static void noinline raid6_vpermxor$#_gen_syndrome_real(int disks, size_t bytes,
> +							void **ptrs)
> +{
> +	u8 **dptr = (u8 **)ptrs;
> +	u8 *p, *q;
> +	int d, z, z0;
> +	unative_t wp$$, wq$$, wd$$;
> +
> +	z0 = disks - 3;		/* Highest data disk */
> +	p = dptr[z0+1];		/* XOR parity */
> +	q = dptr[z0+2];		/* RS syndrome */
> +
> +	for (d = 0; d < bytes; d += NSIZE*$#) {
> +		wp$$ = wq$$ = *(unative_t *)&dptr[z0][d+$$*NSIZE];
> +
> +		for (z = z0-1; z>=0; z--) {
> +			wd$$ = *(unative_t *)&dptr[z][d+$$*NSIZE];
> +			/* P syndrome */
> +			wp$$ = vec_xor(wp$$, wd$$);
> +
> +			/*Q syndrome */
> +			__asm__ __volatile__("vpermxor %0,%1,%2,%3\n\t":"=v"(wq$$):"v"(gf_high), "v"(gf_low), "v"(wq$$));

A couple of things:
 - does this need to be marked volatile?

 - I don't think this needs a \n\t at the end of the line

 - It's a very long line

 - I think there should be spaces around the colons but I'm not 100%
   clear on the coding style here.

> +			wq$$ = vec_xor(wq$$, wd$$);
> +		}
> +		*(unative_t *)&p[d+NSIZE*$$] = wp$$;
> +		*(unative_t *)&q[d+NSIZE*$$] = wq$$;
> +	}
> +}
> +
> +static void raid6_vpermxor$#_gen_syndrome(int disks, size_t bytes, void **ptrs)
> +{
> +	preempt_disable();
> +	enable_kernel_altivec();
> +
> +	raid6_vpermxor$#_gen_syndrome_real(disks, bytes, ptrs);
> +
> +	disable_kernel_altivec();
> +	preempt_enable();
> +}

So there's a similar sort of function in
arch/powerpc/crypto/crc32c-vpmsum_glue.c - see around line 35.

In that function, the flow is:
 pagefault_disable();
 enable_kernel_altivec();
 <vectorised function>
 pagefault_enable();

There are a few things that it would be nice (but by no means essential)
to find out:
 - what is the difference between pagefault and prempt enable/disable
 - is it required to disable altivec after the end of the function or
   can we leave that enabled?

> +
> +int raid6_have_altivec_vpermxor(void);
> +#if $# == 1
> +int raid6_have_altivec_vpermxor(void)
> +{
> +	/* Check if CPU has both altivec and the vpermxor instruction*/
Please add a space: s|ion*/|ion */|
> +# ifdef __KERNEL__
> +	return (cpu_has_feature(CONFIG_ALTIVEC) &&
> +		cpu_has_feature(CPU_FTR_ARCH_207S));
I assume this is future-proof - an ISA 3.00 cpu will advertise 2.07S
compat?

> +# else
> +	return 1;
> +#endif
> +
> +}
> +#endif
> +
> +const struct raid6_calls raid6_vpermxor$# = {
> +	raid6_vpermxor$#_gen_syndrome,
> +	NULL,
> +	raid6_have_altivec_vpermxor,
> +	"vpermxor$#",
> +	0
> +};
> +#endif
> -- 
> 2.9.3

Apart from that this patch looks good and I expect I will be able to
formally Review v2.

Regards,
Daniel
