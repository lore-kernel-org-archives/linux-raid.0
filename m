From: Neil Brown <neilb@suse.de>
Subject: Re: RAID resync stalled at 99.7% ?
Date: Fri, 2 Sep 2005 19:48:52 +1000
Message-ID: <17176.8196.976676.73727@cse.unsw.edu.au>
References: <1125652202.3454.10.camel@chris.syd.nighthawkrad.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Christopher Smith on Friday September 2
Sender: linux-raid-owner@vger.kernel.org
To: Christopher Smith <csmith@nighthawkrad.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday September 2, csmith@nighthawkrad.net wrote:
> In doing some benchmarking, I've found a curious problem - after
> creating an array the resync has stalled at 99.7%:
> 
> [root@justinstalled ~]# cat /proc/mdstat
> Personalities : [raid6]
> md0 : active raid6 sdm1[11] sdl1[10] sdk1[9] sdj1[8] sdi1[7] sdh1[6]
> sdg1[5] sdf1[4] sde1[3] sdd1[2] sdc1[1] sdb1[0]
>       4963200 blocks level 6, 32k chunk, algorithm 2 [12/12]
> [UUUUUUUUUUUU]
>       [===================>.]  resync = 99.7% (496320/496349)
> finish=0.0min speed=628K/sec
> unused devices: <none>

$ bc -l 
bc 1.06
Copyright 1991-1994, 1997, 1998, 2000 Free Software Foundation, Inc.
This is free software with ABSOLUTELY NO WARRANTY.
For details type `warranty'. 
496349/32
15510.90625000000000000000
15510*32
496320


Get the picture?

I suspect you are using mdadm-2.0 - yes?  This is a bug triggered by
they way mdadm 2.0 creates arrays (differently to 1.x).  It is fixed
in 2.6.13.

> The command used to create the aray was:
> 
> mdadm -C /dev/md0 -l6 -n12 -c 32 -z 496349 /dev/sd[b-m]1
> 

If you replace 496349 with 496320, it should work fine.

NeilBrown
