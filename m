From: Mark Hahn <hahn@physics.mcmaster.ca>
Subject: Re: swp - Re: ext3 journal on software raid (was Re: PROBLEM: Kernel
 2.6.10 crashing repeatedly and hard)
Date: Sun, 9 Jan 2005 16:21:23 -0500 (EST)
Message-ID: <Pine.LNX.4.44.0501091609040.13461-100000@coffee.psychology.mcmaster.ca>
References: <Pine.LNX.3.96.1050105210224.11158B-100000@Maggie.Linux-Consulting.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.3.96.1050105210224.11158B-100000@Maggie.Linux-Consulting.com>
Sender: linux-raid-owner@vger.kernel.org
To: Alvin Oga <aoga@ns.Linux-Consulting.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> the silly rule of 2x size of RAM == swap space came from the old days
> when memory was 10x the costs of disks or some silly cost performance
> that it made sense when grandpa was floating around

ram is currently about $.1/MB, and disk is about $.0004/MB,
so there is still a good reason to put idle pages onto swap disks.

> by todays ram and disk pricing ... and cpu speeds ...2x memory sorta
> goes out the door

no.  the cpu-speed argument is based on the fact that disk latencies 
are improving quite slowly, compared to ram latency (which is itself
falling drastically behind cpu speeds.)  this assumes that the argument
for swap depends on swap latency, which it doesn't: swap pages are,
ideally, *NEVER*READ*!  the whole point is to choose anonymous pages
which are so idle that they won't practically ever be touched.

you *could* argue that the fraction of pages which can be profitably swapped
is decreasing because "hot" items in memory are larger.  it would be
interesting to find out if that's true.  certainly if only a few percent 
of ram is being used by idle anonymous pages, swapping has become irrelevant.

