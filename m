From: "3tcdgwg3" <3tcdgwg3@prodigy.net>
Subject: Re: Software RAID level 1 issue
Date: Mon, 2 Jun 2003 11:10:31 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <011501c32932$41f191c0$7b07a8c0@pluto>
References: <C587FF391BCAD411B8120008C7864670057DA5B8@mtvxch07.veritas.com> <1054403067.14818.280.camel@testlin.hades> <3ED7B898.4409555F@SteelEye.com> <01f101c326e7$c9084890$7b07a8c0@pluto> <3ED7BF97.BAB11B12@SteelEye.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: Paul Clements <Paul.Clements@SteelEye.com>
Cc: Stef Telford <stef@chronozon.artofdns.com>, 'Greg Rasberry' <rgreg-r@pacbell.net>, 'Linux raid mailing list' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

This feature works only for raid1, or both raid1 and raid5?

Thanls.
W
----- Original Message -----
From: "Paul Clements" <Paul.Clements@SteelEye.com>
To: "3tcdgwg3" <3tcdgwg3@prodigy.net>
Cc: "Stef Telford" <stef@chronozon.artofdns.com>; "'Greg Rasberry'"
<rgreg-r@pacbell.net>; "'Linux raid mailing list'"
<linux-raid@vger.kernel.org>
Sent: Friday, May 30, 2003 1:31 PM
Subject: Re: Software RAID level 1 issue


> 3tcdgwg3 wrote:
>
> > If there is a plan to do a "intelligent resync", like some of the raid
> > controller
> > vendors offer?  The resync process will be hold on, if there are IO
requests
> > from upper level, and resumed when there is no IO.  By doing that, the
> > system
> > performance always be on the top.  I am very interested in  having
something
> > like that.
>
> This wasn't exactly what I meant by intelligent resync, but...I think
> what you're asking about is something that the md driver already does to
> some extent. It will slow down a resync if there is active I/O on the
> device. This can even be tuned by the user by manipulating a couple of
> kernel sysctls:
>
> apache:~# cat /proc/sys/dev/raid/speed_limit_min
> 100
>
> apache:~# cat /proc/sys/dev/raid/speed_limit_max
> 10000
>
> apache:~# echo 1000000 > /proc/sys/dev/raid/speed_limit_max
>
> apache:~# cat /proc/sys/dev/raid/speed_limit_max
> 1000000
>
>
> These are in KB/s.
>
> The "min" refers to the maximum I/O bandwidth that will be consumed by
> resyncs before the resyncs get throttled, when there is other I/O
> activity on the device.
>
> The "max" refers to the maximum I/O bandwidth that will be consumed by
> resyncs before the resyncs get throttled, even if there is no other I/O
> activity on the device.
>
> --
> Paul

