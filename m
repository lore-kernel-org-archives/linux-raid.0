From: Mark Hahn <hahn@physics.mcmaster.ca>
Subject: Re: swp - Re: ext3 journal on software raid (was Re: PROBLEM: Kernel
 2.6.10 crashing repeatedly and hard)
Date: Sun, 9 Jan 2005 16:07:40 -0500 (EST)
Message-ID: <Pine.LNX.4.44.0501091540100.13461-100000@coffee.psychology.mcmaster.ca>
References: <41DCC33E.6080101@h3c.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <41DCC33E.6080101@h3c.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> > Maybe the concept of swapping is becoming obsolete?
> 
> I think its definitely headed that way, if not already there for most 
> new systems

take a deep breath.  this is manifestly untrue.

in the current era, swap is a way to optimize the use of memory.
please don't even think of its original meaning as a place to 
write out a process's complete VM in order to switch to another 
process's VM.

swap is where the kernel puts less-used pages.  having lots of memory
does NOT magically mean that all pages are equally well-used.  if you
do actually have so much physical memory that the kernel never has 
any shortage of memory, well, bully for you, you've wasted big bucks.

and it is waste.  consider the page of my Firefox browser that contains 
code for interpreting devanagari unicode glyphs.  it doesn't get much 
use, and so it should get swapped out.  writing out a swap page is basically
free, and it means I have one more page available for something more useful.
since my frequency of reading devanagari pages is sort of low, that page 
can be used to cache, say, http://images.slashdot.org/title.gif.

swapping is how the kernel optimizes space used by idle anonymous pages.

if you understand that, it says absolutely everything you need to know:
that swapping will always have some value, that it depends on high variance
in the "temperature" of pages (and thus the concept of kernel memory
"pressure"), that it doesn't apply to a system with no dirty anonymous pages.

you can refuse to do this optimization, and your system will run poorer.
the kernel can do this optimization poorly, and thus slow down, not speed up.
you can waste your money on so much ram that the kernel never experiences 
memory pressure (but you'd be surprised how much ram that would require!)

swapping is nearly free, since doing an async write doesn't slow anything 
else down (assuming good page choice, otherwise lightly loaded disks,
nothing misconfigured like PIO.)  swapping is a recognition that disk is 
drastically cheaper than ram.  swapping does mean that idle anonymous pages
could be corrupted by a flakey storage subsystem - but if that happens,
you have other serious issues - what does it say about the pages comprising
the text of your applications?  remember that a big, hard-pressed system 
might have, say, a gigabyte of swap in use, but even a small desktop will
have 50x that much in files exposed to the same hypothetical corruption.

yes, I configure my systems with un-raided swap, because if disks are *that*
flakey, I want to know about it.

finally, ram prices (per GB) have been mostly stable for a couple years now.
it's true that ram is faster, and systems are slowly increasing in ram size,
but nothing dramatic is on the horizon.  I run a supercomputer center that is 
buying a large amount of new hardware now.  the old systems are almost 4
years old and have 1GB/cpu (4-way alphas).  new systems will average about 
4GB/cpu, and only a few of our users (HPC stuff way beyond desktops) would
like more than 8GB/cpu.  all of the ~6K cpus we buy will be in systems that 
have swap.

regards, mark hahn.

