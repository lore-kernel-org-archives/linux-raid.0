From: Andrew Beresford <beezly@beezly.org.uk>
Subject: Re: raid1 oops in raid1_read_balance on Sparc64
Date: Thu, 25 Apr 2002 14:01:39 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20020425130139.GA28135@monkey.beezly.org.uk>
References: <20020424231406.GD8249@monkey.beezly.org.uk> <15559.57163.613685.697556@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <15559.57163.613685.697556@notabene.cse.unsw.edu.au>
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: Antti Siipola <ansi@iki.fi>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Neil,

On Thu, Apr 25, 2002 at 08:49:47PM +1000, Neil Brown wrote:
> On Thursday April 25, beezly@beezly.org.uk wrote:
> That's two reports of this.  It looks to me very much like a compiler
> bug.   I'm not an export on Sparc assembler, but I've just been
> reading through the disassembly listing of read1_read_balance,
> and at least two things look wrong:
> 
> 0xc30 <raid1_read_balance+208>: sllx  %o2, 3, %g2 
> 0xc34 <raid1_read_balance+212>: add  %i1, 0x20, %g3
> 0xc38 <raid1_read_balance+216>: clr  [ %i5 + 0x3f0 ]
> 0xc3c <raid1_read_balance+220>: add  %g2, %o2, %g2
> 
> This is the only place that %o2 is used, and it is never
> initialised.
> 
> 0xbac <raid1_read_balance+76>:  add  %i5, 0x18, %o7
> 0xbb0 <raid1_read_balance+80>:  sllx  %o7, 3, %g2
> 
> %i5 is holding "conf". adding 0x18 gives the address of
>  conf->mirrors[0]->head_position in %o7.
> But then we shift %o7 left 3 places, multiplying by 8.
> Multiplying an address by 8 is very unlikely to be correct.
> 
> Could you both please tell us what compiler version you are using, and
> see if you can try a different one.

andy@lemur:~$ sparc64-linux-gcc -dumpversion
egcs-2.92.11

I'm trying a build with gcc-3 right now, I have a gcc-2.95 compiler
also, but it doesn't support building 64 bit binaries.

Cheers,

Beezly
