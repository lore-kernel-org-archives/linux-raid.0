From: Luca Berra <bluca@comedia.it>
Subject: Re: [PATCH] mdadm 2.5 (Was: ANNOUNCE: mdadm 2.5 - A tool for managing Soft RAID under Linux)
Date: Mon, 29 May 2006 07:44:31 +0200
Message-ID: <20060529054431.GN8203@percy.comedia.it>
References: <17526.41252.855793.479011@cse.unsw.edu.au> <20060528133203.GC8203@percy.comedia.it> <17530.22425.736084.41226@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <17530.22425.736084.41226@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, May 29, 2006 at 12:08:25PM +1000, Neil Brown wrote:
>On Sunday May 28, bluca@comedia.it wrote:
>Thanks for the patches.  They are greatly appreciated.
You're welcome
>> 
>> - mdadm-2.3.1-kernel-byteswap-include-fix.patch
>> reverts a change introduced with mdadm 2.3.1 for redhat compatibility
>> asm/byteorder.h is an architecture dependent file and does more
>> stuff than a call to the linux/byteorder/XXX_endian.h
>> the fact that not calling asm/byteorder.h does not define
>> __BYTEORDER_HAS_U64__ is just an example of issues that might arise.
>> if redhat is broken it should be worked around differently than breaking
>> mdadm.
>
>I don't understand the problem here.  What exactly breaks with the
>code currently in 2.5?  mdadm doesn't need __BYTEORDER_HAS_U64__, so
>why does not having id defined break anything?
>The coomment from the patch says:
> > not including asm/byteorder.h will not define __BYTEORDER_HAS_U64__
> > causing __fswab64 to be undefined and failure compiling mdadm on
> > big_endian architectures like PPC
>
>But again, mdadm doesn't use __fswab64 ....
>More details please.
you use __cpu_to_le64 (ie in super0.c line 987)

        bms->sync_size = __cpu_to_le64(size);

which in byteorder/big_endian.h is defined as

#define __cpu_to_le64(x) ((__force __le64)__swab64((x)))

but __swab64 is defined in byteorder/swab.h (included by
byteorder/big_endian.h) as

#if defined(__GNUC__) && (__GNUC__ >= 2) && defined(__OPTIMIZE__)
#  define __swab64(x) \
(__builtin_constant_p((__u64)(x)) ? \
___swab64((x)) : \
__fswab64((x)))
#else
#  define __swab64(x) __fswab64(x)
#endif /* OPTIMIZE */

and __fswab64 is defined further into byteorder/swab.h as

#ifdef __BYTEORDER_HAS_U64__
static __inline__ __attribute_const__ __u64 __fswab64(__u64 x)
.....
#endif /* __BYTEORDER_HAS_U64__ */

so building mdadm on a ppc (or i suppose a sparc) will break


now, if you look at /usr/src/linux/asm-*/byteorder.h you will notice
they are very different files, this makes me believe it is not a good
idea bypassing asm/byteorder.h
And no, just defining __BYTEORDER_HAS_U64__ will break on 32bit
big-endian cpus (and if i do not misread it might just compile and give
incorrect results)

>> 
>> - mdadm-2.4-snprintf.patch
>> this is self commenting, just an error in the snprintf call
>
>I wonder how that snuck in...
>There was an odd extra tab in the patch, but no-matter.
>I changed it to use 'sizeof(buf)' to be consistent with other uses
>of snprint.  Thanks.
yes, that would be better.

>> - mdadm-2.4-strict-aliasing.patch
>> fix for another srict-aliasing problem, you can typecast a reference to a
>> void pointer to anything, you cannot typecast a reference to a
>> struct.
>
>Why can't I typecast a reference to a struct??? It seems very
>unfair...
that's strict-aliasing optimization for you, i do agree it _is_ unfair.

>However I have no problem with the patch.  Applied.  Thanks.
>I should really change it to use 'list.h' type lists from the linux
>kernel.
hopefull redhat would not object :)

>> - mdadm-2.5-mdassemble.patch
>> pass CFLAGS to mdassemble build, enabling -Wall -Werror showed some
>> issues also fixed by the patch.
>
>yep, thanks.
>
>> 
>> - mdadm-2.5-rand.patch
>> Posix dictates rand() versus bsd random() function, and dietlibc
>> deprecated random(), so switch to srand()/rand() and make everybody
>> happy.
>
>Everybody?
>'man 3 rand' tells me:
>
>       Do not use this function in applications  intended  to  be
>       portable when good randomness is needed.
>
>Admittedly mdadm doesn't need to be portable - it only needs to run on
>Linux.  But this line in the man page bothers me.
>
>I guess
>    -Drandom=rand -Dsrandom=srand
>might work.... no.  stdlib.h doesn't like that.
>'random' returns 'long int' while rand returns 'int'.
>Interestingly 'random_r' returns 'int' as does 'rand_r'.
>
>#ifdef __dietlibc__
>#include	<strings.h>
>/* dietlibc has deprecated random and srandom!! */
>#define random rand
>#define srandom srand
>#endif
>
>in mdadm.h.  Will that do you?
>

yes, mdassemble will build, so it is ok for me.


>> 
>> - mdadm-2.5-unused.patch
>> glibc 2.4 is pedantic on ignoring return values from fprintf, fwrite and
>> write, so now we check the rval and actually do something with it.
>> in the Grow.c case i only print a warning, since i don't think we can do
>> anithing in case we fail invalidating those superblocks (is should never
>> happen, but then...)
>
>Ok, thanks.
>
>
>You can see these patches at
>   http://neil.brown.name/cgi-bin/gitweb.cgi?p=mdadm

Thanks.


-- 
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \
