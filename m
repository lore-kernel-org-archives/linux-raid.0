From: Mark Hahn <hahn@physics.mcmaster.ca>
Subject: RE: Good news / bad news - The joys of RAID
Date: Sat, 20 Nov 2004 18:30:07 -0500 (EST)
Message-ID: <Pine.LNX.4.44.0411201741300.19120-100000@coffee.psychology.mcmaster.ca>
References: <200411201937.iAKJbwN17977@www.watkins-home.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200411201937.iAKJbwN17977@www.watkins-home.com>
Sender: linux-raid-owner@vger.kernel.org
To: Guy <bugzilla@watkins-home.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> Can you explain how the disks have a MTBF of 1,000,000 hours?  But fail more
> often than that?  Maybe I just don't understand some aspect of MTBF.

simple: the MTBF applies to very large sets of disks.  if you had 
millions of disks, you'd expect to average mtbf/ndisks between failures.
with statistically trivial sample sizes (10 disks), you can't 
really say much.  of course, a proper model of the failure rate 
would have a lot more than 1 parameter...

for instance, my organization will be buying about .5 PB
of storage soon.  here are some options:

disk		n	mtbf	hours	$/disk	$K total

250GB SATA	1920	1e6	500	399	766
600GB SATA	800	1e6	1250	600?	480

73GB SCSI/FC	6575	1.3e6	198	389	2558
146GB SCSI/FC	3288	1.3e6	395	600	1973
300GB SCSI/FC	1600	1.3e6	813	1200	1920

these mtbf's are basically made up, since disk vendors aren't really
very helpful in publishing their true reliability distributions.
these disk counts are starting to be big enough to give some meaning
to the hours=mtbf/n calculation - I'd WAG that "hours" is within
a factor of two.  (I looked at only three lines of SCSI disks to 
get 1.3e6 - two quoted 1.2 and the newer was 1.4.)  vendors seem 
to be switching to quoting "annualized failure rates", which are 
probably easier to understand - 1.2e6 MTBF or 0.73% AFR, for instance.
the latter makes it more clear that we're talking about gambling ;)

but the message is clear: for a fixed, large capacity, your main 
concern should be bigger disks.  since our money is also fixed,
you can see that SCSI/FC prices are a big problem (these are 
real list prices from a tier-1 vendor who marks up their SATA
by an embarassing amount...)  further, there's absolutely no chance
we could ever keep .5 PB of disks busy at 100% duty cycle, so that's
not a reason to buy SCSI/FC either...

regards, mark hahn.

