From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: swp - Re: ext3 journal on software raid (was Re: PROBLEM: Kernel 2.6.10 crashing repeatedly and hard)
Date: Wed, 5 Jan 2005 22:32:33 -0500
Message-ID: <200501060332.j063We928711@www.watkins-home.com>
References: <41DC9420.5030701@h3c.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <41DC9420.5030701@h3c.com>
Sender: linux-raid-owner@vger.kernel.org
To: 'Mike Hardy' <mhardy@h3c.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Ok, good answer.  Thanks.  I understand the "spikes" issue.  I really do
plan to have swap space all the time, but good to know it is optional if you
have enough RAM.

Maybe the concept of swapping is becoming obsolete?

In the past, some systems had hardware limits.  Like 64K, 640K, 16M, 64M.
You had no choice but to swap stuff out.  Or use overlays.  I have worked on
systems where the app had to swap chunks of memory to disk and back.  There
was no OS support for virtual memory.  We had fixed head disks to give
better performance.  I even recall hardware that could bank switch sections
of memory to break the 640K limit!  Even IBM mainframes had a 256Meg limit,
but could go beyond that by bank switching.  But now hardware has caught up
to programmers.  Most systems can support more RAM than most programs need.
With PC based systems (and some others I assume), 1 Gig of RAM is very
cheap!  But I did note someone said you had to do something to break the
2Gig boundary in Linux with x68 based systems.  That's too bad.  In a few
years, most people will be in the 64 bit world I guess.  I hope that
corrects the 2Gig boundary.  The next boundary (8,589,934,592 Gig) should be
well beyond anything we would ever need, well, for at least a few more
years!  :)  But then we could go un-signed and double that!  Of course,
disks will be even bigger!  I can't wait!

Of course you can't put 8,589,934,592 Gig of RAM in a 64 bit computer today.

If you consider Moore's Law and RAM.  "transistors on integrated circuits
tend to double every 18 to 24 months"  Assuming we are at a about 36 bits
today (I think 64 Gig is about as much as is reasonable today).  We should
reach the 64 bit limit in 42-56 years.  Maybe it will be a long wait?  :)

Guy

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Mike Hardy
Sent: Wednesday, January 05, 2005 8:28 PM
To: linux-raid@vger.kernel.org
Subject: Re: swp - Re: ext3 journal on software raid (was Re: PROBLEM:
Kernel 2.6.10 crashing repeatedly and hard)


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
> space should be 2 time RAM size.  How crazy, my memory requirements did
not
> change, just the amount of memory.  I used that system for a year or so
like
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
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

