From: Daniel Axtens <dja@axtens.net>
Subject: Re: [v2] raid6/altivec: Add vpermxor implementation for raid6 Q syndrome
Date: Thu, 06 Apr 2017 16:13:25 +1000
Message-ID: <87r316hxmi.fsf@possimpible.ozlabs.ibm.com>
References: <20170406053816.5239-1-matthew.brown.dev@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170406053816.5239-1-matthew.brown.dev@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Matt Brown <matthew.brown.dev@gmail.com>, linuxppc-dev@lists.ozlabs.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Matt,

Thanks for answering my questions and doing those fixes.


> Bugs fixed:
> 	- A small bug in pq.h regarding a missing and mismatched
> 	  ifdef statement
> 	- Fixed test/Makefile to correctly build test on ppc
>

I think this commit should be labelled:
Fixes: 4f8c55c5ad49 ("lib/raid6: build proper files on corresponding arch")

mpe can probably add that when he merges - no need to do a new version :)

>  else
> -        HAS_ALTIVEC := $(shell printf '\#include <altivec.h>\nvector int a;\n' |\
> -                         gcc -c -x c - >&/dev/null && \
> -                         rm ./-.o && echo yes)
> -        ifeq ($(HAS_ALTIVEC),yes)
> -                OBJS += altivec1.o altivec2.o altivec4.o altivec8.o
> +	 HAS_ALTIVEC := $(shell printf '\#include <altivec.h>\nvector int a;\n' |\
> +			 gcc -c -x c - >/dev/null && rm ./-.o && echo yes)
> +	 ifeq ($(HAS_ALTIVEC),yes)
> +		CFLAGS += -I../../../arch/powerpc/include
> +		CFLAGS += -DCONFIG_ALTIVEC
> +		OBJS += altivec1.o altivec2.o altivec4.o altivec8.o \
> +			vpermxor1.o vpermxor2.o vpermxor4.o vpermxor8.o
>          endif
>  endif
Looks like vim has replaced spaces with tabs here. Not sure how much we
care...

>  ifeq ($(ARCH),tilegx)
> @@ -97,6 +99,18 @@ altivec4.c: altivec.uc ../unroll.awk
>  altivec8.c: altivec.uc ../unroll.awk
>  	$(AWK) ../unroll.awk -vN=8 < altivec.uc > $@
>
... especially seeing as tabs are already used in the file here!

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
> +			/*Q syndrome */
> +	/* Check if CPU has both altivec and the vpermxor instruction*/
Very trivial nit: for future patches please make sure you have spaces
between the beginning/end of a comment and the comment.

> +# ifdef __KERNEL__
> +	return (cpu_has_feature(CONFIG_ALTIVEC) &&
> +		cpu_has_feature(CPU_FTR_ARCH_207S));
I think CPU_FTR_ARCH_207S implies Altivec? Again, not a real problem,
I don't think it's really worth doing a respin for any of these, so:

Reviewed-by: Daniel Axtens <dja@axtens.net>

Thanks for making Power faster!

Regards,
Daniel

