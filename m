From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH] mdadm 2.5 (Was: ANNOUNCE: mdadm 2.5 - A tool for managing Soft RAID under Linux)
Date: Mon, 29 May 2006 12:08:25 +1000
Message-ID: <17530.22425.736084.41226@cse.unsw.edu.au>
References: <17526.41252.855793.479011@cse.unsw.edu.au>
	<20060528133203.GC8203@percy.comedia.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Luca Berra on Sunday May 28
Sender: linux-raid-owner@vger.kernel.org
To: Luca Berra <bluca@comedia.it>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sunday May 28, bluca@comedia.it wrote:
> On Fri, May 26, 2006 at 04:33:08PM +1000, Neil Brown wrote:
> >
> >
> >I am pleased to announce the availability of
> >   mdadm version 2.5
> >
> 
> hello,
> i tried rebuilding mdadm 2.5 on current mandriva cooker, which uses
> gcc-4.1.1, glibc-2.4 and dietlibc 0.29 and found the following issues
> addressed by patches attacched to this message
> I would be glad if you could review these patches and include them in
> upcoming mdadm releases.

Thanks for the patches.  They are greatly appreciated.

> 
> - mdadm-2.3.1-kernel-byteswap-include-fix.patch
> reverts a change introduced with mdadm 2.3.1 for redhat compatibility
> asm/byteorder.h is an architecture dependent file and does more
> stuff than a call to the linux/byteorder/XXX_endian.h
> the fact that not calling asm/byteorder.h does not define
> __BYTEORDER_HAS_U64__ is just an example of issues that might arise.
> if redhat is broken it should be worked around differently than breaking
> mdadm.

I don't understand the problem here.  What exactly breaks with the
code currently in 2.5?  mdadm doesn't need __BYTEORDER_HAS_U64__, so
why does not having id defined break anything?
The coomment from the patch says:
 > not including asm/byteorder.h will not define __BYTEORDER_HAS_U64__
 > causing __fswab64 to be undefined and failure compiling mdadm on
 > big_endian architectures like PPC

But again, mdadm doesn't use __fswab64 ....
More details please.

> 
> - mdadm-2.4-snprintf.patch
> this is self commenting, just an error in the snprintf call

I wonder how that snuck in...
There was an odd extra tab in the patch, but no-matter.
I changed it to use 'sizeof(buf)' to be consistent with other uses
of snprint.  Thanks.

> 
> - mdadm-2.4-strict-aliasing.patch
> fix for another srict-aliasing problem, you can typecast a reference to a
> void pointer to anything, you cannot typecast a reference to a
> struct.

Why can't I typecast a reference to a struct??? It seems very
unfair...
However I have no problem with the patch.  Applied.  Thanks.
I should really change it to use 'list.h' type lists from the linux
kernel.

> 
> - mdadm-2.5-mdassemble.patch
> pass CFLAGS to mdassemble build, enabling -Wall -Werror showed some
> issues also fixed by the patch.

yep, thanks.

> 
> - mdadm-2.5-rand.patch
> Posix dictates rand() versus bsd random() function, and dietlibc
> deprecated random(), so switch to srand()/rand() and make everybody
> happy.

Everybody?
'man 3 rand' tells me:

       Do not use this function in applications  intended  to  be
       portable when good randomness is needed.

Admittedly mdadm doesn't need to be portable - it only needs to run on
Linux.  But this line in the man page bothers me.

I guess
    -Drandom=rand -Dsrandom=srand
might work.... no.  stdlib.h doesn't like that.
'random' returns 'long int' while rand returns 'int'.
Interestingly 'random_r' returns 'int' as does 'rand_r'.

#ifdef __dietlibc__
#include	<strings.h>
/* dietlibc has deprecated random and srandom!! */
#define random rand
#define srandom srand
#endif

in mdadm.h.  Will that do you?


> 
> - mdadm-2.5-unused.patch
> glibc 2.4 is pedantic on ignoring return values from fprintf, fwrite and
> write, so now we check the rval and actually do something with it.
> in the Grow.c case i only print a warning, since i don't think we can do
> anithing in case we fail invalidating those superblocks (is should never
> happen, but then...)

Ok, thanks.


You can see these patches at
   http://neil.brown.name/cgi-bin/gitweb.cgi?p=mdadm

more welcome :-)

Thanks again,
NeilBrown
