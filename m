From: Mark Hahn <hahn@physics.mcmaster.ca>
Subject: Re: Accelerating Linux software raid
Date: Sat, 10 Sep 2005 00:51:27 -0400 (EDT)
Message-ID: <Pine.LNX.4.44.0509100033570.29141-100000@coffee.psychology.mcmaster.ca>
References: <e9c3a7c2050906112410dc1d16@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <e9c3a7c2050906112410dc1d16@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> I am writing to the list to gauge interest for a modification of the
> md driver that allows it to take advantage of raid acceleration

not that much, I think.

> hardware.  I/O processors like the Intel IOP333
> (http://www.intel.com/design/iio/docs/iop333.htm) contain an xor
> engine for raid5 and raid6 calculations, but currently the md driver
> does not fully utilize these resources.

the worst insult in the linux world is "solution in search of a problem".
that applies here: are you sure that there is a problem?  yes, offload 
can be a lovely thing, but it often falls behind the main driver of the 
industry - host cpu performance.  unless you're specifically targetting
a high-IO device with very little CPU power, I think you'll find a lot 
of skepticism about IO coprocessors.

I have a server that can do the raid5 checksum at 8 GB/s, and have no 
reason to ever want more than ~100 MB/s on that machine.  do I care 
about "wasting" 1/80th of the machine?  not really, even though it's 
a supercomputing cluster node.  for fileservers, I mind even less 
wasting CPU using the host for parity, since the cycles aren't going
to be used for anything else...

> Dave Jiang wrote a driver that re-routed calls to xor_block() to use
> the hardware xor engine.  However, from my understating, he found that
> performance did not improve, due to the fact that md deals in
> PAGE_SIZE (4K) blocks.

well, it calls xor_block with STRIPE_SIZE which is indeed PAGE_SIZE.

> destroys any performance advantage over a software xor.  The goal of
> the modification would be to enable md to understand the capacity of
> the platform's xor resources and allow it to issue optimal block
> sizes.

this argument assumes that the HW xor is actually faster than the host,
though.  is that true?  otherwise, HW xor starts out behind due to the 
setup overhead, and falls further behind for larger stripe sizes!

> The first question is whether a solution along these lines would be
> valued by the community?  The effort is non-trivial.

if you're interested in speeding up MD, then looking at how to make 
STRIPE_SIZE bigger might be worthwhile.  (independent of HW xor.)

regards, mark hahn.

