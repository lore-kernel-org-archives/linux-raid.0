From: Nix <nix@esperi.org.uk>
Subject: Re: [PATCH] mdadm 2.5
Date: Mon, 05 Jun 2006 20:47:40 +0100
Message-ID: <8764jf8jvn.fsf@hades.wkstn.nix>
References: <17526.41252.855793.479011@cse.unsw.edu.au>
	<20060528133203.GC8203@percy.comedia.it>
	<17530.22425.736084.41226@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17530.22425.736084.41226@cse.unsw.edu.au> (Neil Brown's message of "29 May 2006 03:08:45 +0100")
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Luca Berra <bluca@comedia.it>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 29 May 2006, Neil Brown suggested tentatively:
> On Sunday May 28, bluca@comedia.it wrote:
>> - mdadm-2.4-strict-aliasing.patch
>> fix for another srict-aliasing problem, you can typecast a reference to a
>> void pointer to anything, you cannot typecast a reference to a
>> struct.
> 
> Why can't I typecast a reference to a struct??? It seems very
> unfair...

ISO C forbids it. Pretty much the only time you're allowed to cast a pointer
to A to a pointer to B is if one or the other of them is a pointer to void
or char.

The compiler can (and does) assume that all other pointers-to-T are in
different `aliasing sets', i.e. that a modification through a
pointer-to-T1 cannot affect variables of any other type (so they can
be cached in registers, moved around without reference to each other,
and so on).

It's *very* advantageous, and with the interprocedural optimizations in
GCC 4.1+ is getting more so all the time (the compiler can now move code
between *functions* if it needs to, or propagate constants consistently
used as function arguments down int into the function themselves; pointer
aliasing torpedoes both of these optimizations, and many more.)

(One particularly evil thing is the glibc printf handler extension. As
a result of that, we must assume that any call to printf() or scanf()
can potentially modify any global variable and any local to which a
pointer may have escaped. This is decidedly suboptimal given that
nobody sane ever uses those extensions!)


I think I'll dare to upgrade mdadm soon. I tried upgrading from 2.3.1 to
2.4 (with uClibc from SVN dated 2006-03-28) and it promptly segfaulted
at array assembly time. If it happens with 2.5 I'll get a backtrace
(hard though that is to get when you don't have any accessible storage
to put the core dump on... I upgraded uClibc at the same time so it may
well be an uClibc bug.)

-- 
`Voting for any American political party is fundamentally
 incomprehensible.' --- Vadik
