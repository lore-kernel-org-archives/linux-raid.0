From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH] mdadm 2.5 (Was: ANNOUNCE: mdadm 2.5 - A tool for managing Soft RAID under Linux)
Date: Mon, 29 May 2006 16:06:42 +1000
Message-ID: <17530.36722.422744.774785@cse.unsw.edu.au>
References: <17526.41252.855793.479011@cse.unsw.edu.au>
	<20060528133203.GC8203@percy.comedia.it>
	<17530.22425.736084.41226@cse.unsw.edu.au>
	<20060529054431.GN8203@percy.comedia.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Luca Berra on Monday May 29
Sender: linux-raid-owner@vger.kernel.org
To: Luca Berra <bluca@comedia.it>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday May 29, bluca@comedia.it wrote:
> On Mon, May 29, 2006 at 12:08:25PM +1000, Neil Brown wrote:
> >On Sunday May 28, bluca@comedia.it wrote:
> >Thanks for the patches.  They are greatly appreciated.
> You're welcome
> >> 
> >> - mdadm-2.3.1-kernel-byteswap-include-fix.patch
> >> reverts a change introduced with mdadm 2.3.1 for redhat compatibility
> >> asm/byteorder.h is an architecture dependent file and does more
> >> stuff than a call to the linux/byteorder/XXX_endian.h
> >> the fact that not calling asm/byteorder.h does not define
> >> __BYTEORDER_HAS_U64__ is just an example of issues that might arise.
> >> if redhat is broken it should be worked around differently than breaking
> >> mdadm.
> >
> >I don't understand the problem here.  What exactly breaks with the
> >code currently in 2.5?  mdadm doesn't need __BYTEORDER_HAS_U64__, so
> >why does not having id defined break anything?
> >The coomment from the patch says:
> > > not including asm/byteorder.h will not define __BYTEORDER_HAS_U64__
> > > causing __fswab64 to be undefined and failure compiling mdadm on
> > > big_endian architectures like PPC
> >
> >But again, mdadm doesn't use __fswab64 ....
> >More details please.
> you use __cpu_to_le64 (ie in super0.c line 987)
> 
>         bms->sync_size = __cpu_to_le64(size);
> 
> which in byteorder/big_endian.h is defined as
> 
> #define __cpu_to_le64(x) ((__force __le64)__swab64((x)))
> 
> but __swab64 is defined in byteorder/swab.h (included by
> byteorder/big_endian.h) as
> 
> #if defined(__GNUC__) && (__GNUC__ >= 2) && defined(__OPTIMIZE__)
> #  define __swab64(x) \
> (__builtin_constant_p((__u64)(x)) ? \
> ___swab64((x)) : \
> __fswab64((x)))
> #else
> #  define __swab64(x) __fswab64(x)
> #endif /* OPTIMIZE */


Grrr......

Thanks for the details.  I think I'll just give up and do it myself.
e.g.
short swap16(short in)
{
	int i;
	short out=0;
	for (i=0; i<4; i++) {
		out = out<<8 | (in&255);
		in = in >> 8;
	}
	return out;
}

I don't need top performance and at least this should be portable...

NeilBrown
