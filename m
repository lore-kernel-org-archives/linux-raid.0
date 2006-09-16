From: Daniel Pittman <daniel@rimspace.net>
Subject: USB disks for RAID storage (was Re: Please help me save my data)
Date: Sun, 17 Sep 2006 09:48:04 +1000
Message-ID: <87odtfe5l7.fsf_-_@rimspace.net>
References: <59430.213.136.43.252.1157976989.squirrel@webmail.adocca.com>
	<b53b67d20609110610v5d4a63a9ube77d918b0406484@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

"Patrick Hoover" <phoover.eml@gmail.com> writes:

> Is anyone else having issues with USB interfaced disks to implement
> RAID? Any thoughts on Pros / Cons for doing this?  

I have done, as a trial.  USB disk support in recent 2.6 based
distributions was quite stable and reliable, and I had no significant
problems with RAID arrays -- including constructing arrays at boot time.

However, USB disk performance was not great; I wouldn't want to run more
than one, or possibly two, disks on a single USB controller.  Anything
more than that and you really see performance drop off.

Also, the USB transaction latency seems a bit greater than IDE or SATA,
so there are longer delays in data getting in or out of the system --
which add up, and make workloads with lots of fsync and small files
painful.


For bulk storage of large data with low performance requirements
chaining a whole bunch of USB disks off a single controller would be
acceptable, but otherwise I wouldn't bother.


I didn't investigate IEEE-1394 connected disks, but I anticipate them to
have similar issues with controller latency and bandwidth.  Tests with
two disks suggest a similar set of issues.[1]

Regards,
        Daniel

Footnotes: 
[1]  Also, Linux optimizes the 1394 bus less well than it could,
     so performance is hurt by that a bit.  

-- 
Digital Infrastructure Solutions -- making IT simple, stable and secure
Phone: 0401 155 707        email: contact@digital-infrastructure.com.au
                 http://digital-infrastructure.com.au/

