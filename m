From: "Jon Nelson" <jnelson-linux-raid@jamponi.net>
Subject: Re: Collection of benchmarks on RAID5,6 and 10
Date: Sat, 12 Jul 2008 09:30:07 -0500
Message-ID: <cccedfc60807120730w71845f91m4bb96506e24230fa@mail.gmail.com>
References: <cccedfc60807110722q6d206b29xc46eeff378285bc7@mail.gmail.com>
	 <alpine.DEB.1.10.0807120732190.19733@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.0807120732190.19733@p34.internal.lan>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

>> http://pycurious.blogspot.com/
>
> Nice benchmarks, what did you use to make the graphs?

Thanks! I used flot (a jQuery plugin).
However, I've redone the code that creates the graphs and have
switched to google charts.
You can see a preview here:

http://www.jamponi.net/more_raid/graphs.html

I'll be revising that post to use the new graphs (unless people
holler) and to include a 2048 chunk size as per Neil's suggestion.

A future installment will show the effects of the various schedulers
(you can see the graphs for that in the link above), and yet another
installment may show filesystems over raid (and possibly filesystems
over lvm over raid).

> Also, for all of your RAID configuration/systems, what do you use for your
> servers/stability after benchmarking multiple configurations?

I'm using raid10,f2 right now but I may switch to raid6. I was using
raid5 previously. One big difference between the benchmarks and my
system is that I am using 3 drives and the benchmarks show 4.

-- 
Jon
