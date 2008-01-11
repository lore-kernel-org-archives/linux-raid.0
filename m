From: Neil Brown <neilb@suse.de>
Subject: Re: md rotates RAID5 spare at boot
Date: Fri, 11 Jan 2008 12:12:27 +1100
Message-ID: <18310.49787.951925.456483@notabene.brown>
References: <47852984.5040707@ultralame.com>
	<4786844D.4010104@tmr.com>
	<478685DA.8070701@ultralame.com>
	<18310.38343.339990.718263@notabene.brown>
	<47869D2C.7020805@ultralame.com>
	<18310.46808.422657.207784@notabene.brown>
	<4786BA70.1070205@ultralame.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Jed Davidow on Thursday January 10
Sender: linux-raid-owner@vger.kernel.org
To: Jed Davidow <jed@ultralame.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday January 10, jed@ultralame.com wrote:
> (Sorry- yes it looks like I posted an incorrect dmesg extract)

This still doesn't seem to match your description.
I see:

> [   41.247389] md: bind<sdf1>
> [   41.247584] md: bind<sdb1>
> [   41.247787] md: bind<sda1>
> [   41.247971] md: bind<sdc1>
> [   41.248151] md: bind<sdg1>
> [   41.248325] md: bind<sde1>
> [   41.256718] raid5: device sde1 operational as raid disk 0
> [   41.256771] raid5: device sdc1 operational as raid disk 4
> [   41.256821] raid5: device sda1 operational as raid disk 3
> [   41.256870] raid5: device sdb1 operational as raid disk 2
> [   41.256919] raid5: device sdf1 operational as raid disk 1
> [   41.257426] raid5: allocated 5245kB for md0
> [   41.257476] raid5: raid level 5 set md0 active with 5 out of 5 
> devices, algorithm 2

which looks like 'md0' started with 5 of 5 drives, plus g1 is there as
a spare.  And

> [   41.312250] md: bind<sdf2>
> [   41.312476] md: bind<sdb2>
> [   41.312711] md: bind<sdg2>
> [   41.312922] md: bind<sdc2>
> [   41.313138] md: bind<sda2>
> [   41.313343] md: bind<sde2>
> [   41.313452] md: md1: raid array is not clean -- starting background 
> reconstruction
> [   41.322189] raid5: device sde2 operational as raid disk 0
> [   41.322243] raid5: device sdc2 operational as raid disk 4
> [   41.322292] raid5: device sdg2 operational as raid disk 3
> [   41.322342] raid5: device sdb2 operational as raid disk 2
> [   41.322391] raid5: device sdf2 operational as raid disk 1
> [   41.322823] raid5: allocated 5245kB for md1
> [   41.322872] raid5: raid level 5 set md1 active with 5 out of 5 
> devices, algorithm 2

md1 also assembled with 5/5 drives and sda2 as a spare.  
This one was not shut down cleanly so it started a resync.  But there
is not evidence of anything starting degraded.

????

NeilBrown
