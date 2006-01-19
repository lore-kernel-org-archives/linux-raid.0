From: Mike Hardy <mhardy@h3c.com>
Subject: Re: raid reconstruction speed
Date: Thu, 19 Jan 2006 14:10:02 -0800
Message-ID: <43D00E3A.5090102@h3c.com>
References: <op.s3mjqms2i22er4@xray.bmc.uu.se> <op.s3m7n1pucigqcu@apollo13> <op.s3m9znsqcigqcu@apollo13>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <op.s3m9znsqcigqcu@apollo13>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


PFC wrote:

>     When rebuilding md1, it does not realize accesses to md0 wait for
> the  same disks. Thus reconstruction of md1 runs happily at full speed,
> and the  machine is dog slow, because the OS and everything is on md0.
>     (I cat /dev/zero to a file on md1 to slow the rebuild so it would
> let me  start a web browser so I don't get bored to death)

echo "10000" > /proc/sys/dev/raid/speed-limit-max (or similar?)

You can do that in /etc/rc.local or something to make sure it sticks,
then you'll be able to use your machine while any array rebuilds.

I guess the feature you're asking for is for md to guess that accessing
any partition component on a disk that has a partition being rebuilt
should throttle the rebuild, right?

Can that heuristic be successful at all times? I think it might.

Does md have enough information to do that? I don't know...

-Mike
