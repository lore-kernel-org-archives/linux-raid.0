From: Mike Hardy <mhardy@h3c.com>
Subject: Re: swp - Re: ext3 journal on software raid (was Re: PROBLEM: Kernel
 2.6.10 crashing repeatedly and hard)
Date: Wed, 05 Jan 2005 17:28:00 -0800
Message-ID: <41DC9420.5030701@h3c.com>
References: <200501060057.j060vk928131@www.watkins-home.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200501060057.j060vk928131@www.watkins-home.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Guy wrote:

> So, the question is:
> 	Assume I have enough RAM to never need to swap.
> 	Do I need any swap space with Linux?

This has been hashed out at great length on linux-kernel - with a few 
entrenched positions emerging, if I recall correctly.

There are those that think if they size the machine correctly, they 
shouldn't need swap, and they're right.

> I had 8 Meg of swap space.  So 12 meg total available virtual memory.
> One day I added 16 Meg of RAM.  So now I had 20 Meg of RAM.  I deleted my
> swap space.  Everyone told me I needed 20-40 Meg of swap space now!  Swap
> space should be 2 time RAM size.  How crazy, my memory requirements did not
> change, just the amount of memory.  I used that system for a year or so like
> that.  Go figure!

This story pretty much sums up that position, and I've certainly been in 
that position myself.

There are others (notably the maintainer of part of that code - Andrea 
Arcangeli if I recall correctly, though I apologize if that's a 
misattribution) who believe you should always have swap because it will 
allow your system to have higher throughput. If you process a large I/O, 
for instance, the kernel can swap out live processes to devote more RAM 
to VFS caching. That hurts latency though, and the nightly slocate run 
is a pathlogical example of this. You wake up in the morning and your 
machine is crawling while it swaps everything back in.

There's a "swappiness" knob you can twiddle in /proc or /sys to alter 
this, but the general idea is that you can improve throughput on a 
machine by having swap even if there is enough ram for all processes

I've got machines with and without swap, but I typically run all servers 
with swap to handle ram-usage spikes I'm not expecting (you never know) 
while I run my laptop without swap when possible to avoid latency issues 
with swappiness.

As with all things, its policy decisions and tradeoffs :-)

-Mike
