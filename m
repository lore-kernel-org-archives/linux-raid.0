From: Alvin Oga <aoga@ns.Linux-Consulting.com>
Subject: Re: swp - Re: ext3 journal on software raid (was Re: PROBLEM: Kernel 2.6.10 crashing repeatedly and hard)
Date: Sun, 9 Jan 2005 14:20:27 -0800 (PST)
Message-ID: <Pine.LNX.3.96.1050109141649.22499A-100000@Maggie.Linux-Consulting.com>
References: <Pine.LNX.4.44.0501091609040.13461-100000@coffee.psychology.mcmaster.ca>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44.0501091609040.13461-100000@coffee.psychology.mcmaster.ca>
Sender: linux-raid-owner@vger.kernel.org
To: Mark Hahn <hahn@physics.mcmaster.ca>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


hi ya mark

On Sun, 9 Jan 2005, Mark Hahn wrote:

> > the silly rule of 2x size of RAM == swap space came from the old days
> > when memory was 10x the costs of disks or some silly cost performance
> > that it made sense when grandpa was floating around
> 
> ram is currently about $.1/MB, and disk is about $.0004/MB,
> so there is still a good reason to put idle pages onto swap disks.

yes.. as long as "swap(aka system thruput) speed" is not an issue
and the alternative is to crash once memory options is used up :-)

> > by todays ram and disk pricing ... and cpu speeds ...2x memory sorta
> > goes out the door
> 
> no.  the cpu-speed argument is based on the fact that disk latencies 
> are improving quite slowly, compared to ram latency (which is itself
> falling drastically behind cpu speeds.) 

the 2x memory capacity "old rule of thumb" i was referring to was
if a system has 500MB of real memory, the old rule of thumb says
create ( 2x 500 ) 1GB of disk swap
	- whether that 1GB of swap should be one partition
	or many spread out across the disk is another PhD paper

c ya
alvin

