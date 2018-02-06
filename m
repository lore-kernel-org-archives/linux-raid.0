From: Reindl Harald <h.reindl@thelounge.net>
Subject: Re: force remapping a pending sector in sw raid5 array
Date: Tue, 6 Feb 2018 19:59:32 +0100
Message-ID: <c8be73cb-7dce-0b37-c498-19bf350a6c91@thelounge.net>
References: <20180206181416.amo6geclrvc6ylrf@merlins.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20180206181416.amo6geclrvc6ylrf@merlins.org>
Content-Language: de-CH
Sender: linux-raid-owner@vger.kernel.org
To: Marc MERLIN <marc@merlins.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



Am 06.02.2018 um 19:14 schrieb Marc MERLIN:
> So, I have 2 drives on a 5x6TB array that have respectively 1 and 8
> pending sectors in smart.
> 
> Currently, I have a check running, but it will take a while...
> 
> echo check > /sys/block/md7/md/sync_action
> md7 : active raid5 sdf1[0] sdg1[5] sdd1[3] sdh1[2] sde1[1]
>        23441561600 blocks super 1.2 level 5, 512k chunk, algorithm 2 [5/5] [UUUUU]
>        [==>..................]  check = 10.5% (615972996/5860390400) finish=4822.1min speed=18125K/sec
>        bitmap: 3/44 pages [12KB], 65536KB chunk
> 
> My understanding is that eventually it will find the bad sectors that can't be read
> and rewrite new ones (block remapping) after reading the remaining 4 drives.
> 
> But that may take up to 3 days, just due to how long the check will take and size of the drives
> (they are on a SATA port multiplier, so I don't get a lot of speed)

but 18125K/sec is a joke given that you should run a scrub every week

did you try to play around with sysctl.conf?

adjusting teh vars below and run "sysctl -p" should amke a difference 
after a view seconds if the hardware is capable of more performance than 
that

dev.raid.speed_limit_min = 25000
dev.raid.speed_limit_max = 1000000
