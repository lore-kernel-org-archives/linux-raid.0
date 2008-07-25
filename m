From: "Ana Paula" <anapaula@cs.rutgers.edu>
Subject: Re: Out of sync mirrors
Date: Thu, 24 Jul 2008 23:23:26 -0400
Message-ID: <e6432b760807242023wa9f033dpd37c3d6b591449ac@mail.gmail.com>
References: <e6432b760807240903s57815b2aib5547d35b701ca70@mail.gmail.com>
	 <A20315AE59B5C34585629E258D76A97C01310369@34093-C3-EVS3.exchange.rackspace.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <A20315AE59B5C34585629E258D76A97C01310369@34093-C3-EVS3.exchange.rackspace.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: David Lethe <david@santools.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> Ana:
>
> You are making this way too hard for yourself
> If you want to stop the queue but let the RAID system continue
> processing the queue, then just sending I/O from whatever program you
> are using to generate the load.  This won't let you start up with a
> partially unflushed queue, but if for whatever reason you need to
> measure effects of pending I/Os and timing, then you can obtain a
> reasonably good simulation by increasing the queue depth and repeating
> the test.

I didn't quite understood what you are saying. I need to stop the
queue in order to see its growth.

>
> As for A way to get RAID (I assume software RAID, a la the md driver),
> to get out of sync is to "remove" a disk drive.  If you are afraid to
> crack the case, then use a cheap USB enclosure for one of the disks and
> then turn it off or unplug the USB connector.  You can also "remove" a
> disk by sending it a command to go into a self-test, perform a low-level
> format, send a mode select to change the block size, there are lots of
> ways if you think outside of the box.

By doing this I wouldn't see its queue building up, would I?

Basically I need to simulate a raid with disks of different speeds.
Where a faster mirror would process its requests before the slower
ones.
For reads it processes more requests to keep the raid load balanced.
But for writes I can't load balance, all have to write. The problem is
that the faster is slowing down to meet the slower disk throughput.

See the queue build up is key.

Thanks,
AP

>
> All of these "failure" scenarios will interact differently, just turning
> a disk drive off creates a real failure, not a quasi-emulated more
> graceful failure that may be easier for you to time and measure the
> effects.
>
> Good luck.
>
> David @ santools.com
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
