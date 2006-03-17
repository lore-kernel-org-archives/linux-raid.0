From: Neil Brown <neilb@suse.de>
Subject: Re: making raid5 more robust after a crash?
Date: Sat, 18 Mar 2006 08:13:48 +1100
Message-ID: <17435.9868.249413.113639@cse.unsw.edu.au>
References: <20060317130247.GA19878@cjx.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Chris Allen on Friday March 17
Sender: linux-raid-owner@vger.kernel.org
To: Chris Allen <chris@cjx.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday March 17, chris@cjx.com wrote:
> Dear All,
> 
> We have a number of machines running 4TB raid5 arrays.
> Occasionally one of these machines will lock up solid and
> will need power cycling. Often when this happens, the
> array will refuse to restart with 'cannot start dirty
> degraded array'. Usually  mdadm --assemble --force will
> get the thing going again - although it will then do
> a complete resync.
> 
> 
> My question is: Is there any way I can make the array
> more robust? I don't mind it losing a single drive and
> having to resync when we get a lockup - but having to
> do a forced assemble always makes me nervous, and means
> that this sort of crash has to be escalated to a senior
> engineer.

Why is the array degraded?

Having a crash while the array is degraded can cause undetectable data
loss.  That is why md won't assemble the array itself: you need to
know there could be a problem.

But a crash with a degraded array should be fairly unusual.  If it is
happening a lot, then there must be something wrong with your config:
either you are running degraded a lot (which is not safe, don't do
it), or md cannot find all the devices to assemble.
> 
> 
> Typical syslog:
> 
> 
> Mar 17 10:45:24 snap27 kernel: md: Autodetecting RAID arrays.
> Mar 17 10:45:24 snap27 kernel: md: autorun ...
> Mar 17 10:45:24 snap27 kernel: md: considering sdh1 ...
> Mar 17 10:45:24 snap27 kernel: md:  adding sdh1 ...
> Mar 17 10:45:24 snap27 kernel: md:  adding sdg1 ...
> Mar 17 10:45:24 snap27 kernel: md:  adding sdf1 ...
> Mar 17 10:45:24 snap27 kernel: md:  adding sde1 ...
> Mar 17 10:45:24 snap27 kernel: md:  adding sdd1 ...
> Mar 17 10:45:24 snap27 kernel: md:  adding sdc1 ...
> Mar 17 10:45:24 snap27 kernel: md:  adding sda1 ...
> Mar 17 10:45:24 snap27 kernel: md: created md0
> Mar 17 10:45:24 snap27 kernel: md: bind<sda1>
> Mar 17 10:45:24 snap27 kernel: md: bind<sdc1>
> Mar 17 10:45:24 snap27 kernel: md: bind<sdd1>
> Mar 17 10:45:24 snap27 kernel: md: bind<sde1>
> Mar 17 10:45:24 snap27 kernel: md: bind<sdf1>
> Mar 17 10:45:24 snap27 kernel: md: bind<sdg1>
> Mar 17 10:45:24 snap27 kernel: md: bind<sdh1>
> Mar 17 10:45:24 snap27 kernel: md: running: <sdh1><sdg1><sdf1><sde1><sdd1><sdc1><sda1>
> Mar 17 10:45:24 snap27 kernel: md: md0: raid array is not clean -- starting background reconstruction
> Mar 17 10:45:24 snap27 kernel: raid5: device sdh1 operational as raid disk 4
> Mar 17 10:45:24 snap27 kernel: raid5: device sdg1 operational as raid disk 5
> Mar 17 10:45:24 snap27 kernel: raid5: device sdf1 operational as raid disk 6
> Mar 17 10:45:24 snap27 kernel: raid5: device sde1 operational as raid disk 7
> Mar 17 10:45:24 snap27 kernel: raid5: device sdd1 operational as raid disk 3
> Mar 17 10:45:24 snap27 kernel: raid5: device sdc1 operational as raid disk 2
> Mar 17 10:45:24 snap27 kernel: raid5: device sda1 operational as raid disk 0
> Mar 17 10:45:24 snap27 kernel: raid5: cannot start dirty degraded
> array for md0

So where is 'disk 1' ??  Presumably it should be 'sdb1'.  Does that
drive exist?  Is is marked for auto-detect like the others?

NeilBrown
