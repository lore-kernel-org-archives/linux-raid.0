From: Alvin Oga <aoga@ns.Linux-Consulting.com>
Subject: swp - Re: ext3 journal on software raid (was Re: PROBLEM: Kernel 2.6.10 crashing repeatedly and hard)
Date: Wed, 5 Jan 2005 09:04:57 -0800 (PST)
Message-ID: <Pine.LNX.3.96.1050105090049.9654A-100000@Maggie.Linux-Consulting.com>
References: <20050105162337.GL99565@caffreys.strugglers.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20050105162337.GL99565@caffreys.strugglers.net>
Sender: linux-raid-owner@vger.kernel.org
To: Andy Smith <andy@strugglers.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On Wed, 5 Jan 2005, Andy Smith wrote:

> On Wed, Jan 05, 2005 at 07:33:55AM -0800, Alvin Oga wrote:
> > 
> > if one is using swap space ... i'd add more memory .. before i'd use raid
> > 	- swap is too slow and as you folks point out, it could die
> > 	due to (unlikely) bad disk sectors in swap area
...
 
> Your recommendations

that'd be your comment ... that is not whati said above

and all i said, was use memory before you use swap on disks

and if you are at the 2GB lmit of your mb ... you obviously don't
have a choice
	- if you are using 128MB of memory and using 2GB of swap
	and bitching about a slow box or system crashing due to swap...
	- that was the point ... add more memory

	- and i don't think anybody is idiotic enough to add
	more memory for the "spikes" in the workload

> so far have been "don't run processes which
> might swap" and "don't let swap be used".  If you yourself are able
> to keep to both of these 100% of the time may I ask why you yourself
> have any swap at all?

you're twisting things again... but no problem.. have fun doing that
 
> ometimes) or those of us in the real world where swap is desirable
> and may (sometimes) be used, a swap device failure *will* *take*
> *the* *machine* *down*.

my real world is obviously better .... since we do NOT suffer
from these mysterious disks crashes

we go to fix peoples problems

c ya
alvin

