From: Mark Hahn <hahn@mcmaster.ca>
Subject: Re: swap on raid
Date: Thu, 1 Mar 2007 23:45:49 -0500 (EST)
Message-ID: <Pine.LNX.4.64.0703012334350.16780@coffee.psychology.mcmaster.ca>
References: <20070301222739.GA4835@rabbit.us> <45E75CBC.2050003@sauce.co.nz>
 <20070301233420.GA12963@rabbit.us>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20070301233420.GA12963@rabbit.us>
Sender: linux-raid-owner@vger.kernel.org
To: Peter Rabbitson <rabbit@rabbit.us>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>> The fact that you mention you are using partitions on disks that
>> possibly have other partions doing other things, means raw performance
>> will be compromised anyway.

with normal unraided swap (partition or file), swapouts are not a performance
problem, since they're lazy, relatively cheap, cpu-wise, and not likely to be
voluminous.  if you ever have more than a trivial number of swapins, you'll
be crawling; this is merely a crutch until you can fix your memory problem.

swap over raid5 is somewhat opposed to this: the swapouts now start
eating more CPU.  but non-degraded raid5 swapins run like an N-1 disk raid0.

> (mostly reads). In this light it actually might be better to keep the
> swap in a file on my raid10 (-p n3) which occupies most of these 4
> drives, and hope that the md code will be able to distribute the io
> across idle drives. Does this sound about right?

yes.  especially better than the absurd way some installers insist on 
putting swap partitions at the slow/distant tail of the disk...

but if you're planning to actually _use_ swap, you should probably 
start over, planning more memory instead.
