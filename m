From: "David Lethe" <david@santools.com>
Subject: RE: Out of sync mirrors
Date: Thu, 24 Jul 2008 20:52:49 -0500
Message-ID: <A20315AE59B5C34585629E258D76A97C01310369@34093-C3-EVS3.exchange.rackspace.com>
References: <e6432b760807240903s57815b2aib5547d35b701ca70@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
In-Reply-To: <e6432b760807240903s57815b2aib5547d35b701ca70@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Ana Paula <anapaula@cs.rutgers.edu>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>Hi,
>I am using linux 2.6.8 for my research on raid systems.
>
>I need to have the disks of an array out of sync for a while.
>I want to be able to stop a disk request queue (blk_stop_queue) and
>start it sometime later. Meanwhile its mirrors should be serving r/w
>as if this mirror was up.
>Whenever the stopped mirror comes back it will serve all the requests
>already sent to it.
>
>I am queueing up the requests sent to all others while my mirror queue
>is stopped.
>
>The problem is that the other mirrors stop serving as well. Even if I
>don't stop the queue, only delay its request a little bit, still the
>others also slow down.
>
>Question: how do I get raid to allow mirrors to be out of sync?
>
>Obviously, I am missing something out in the code.
>
>Any clues?
>
>Thanks,
>Ana Paula

Ana:

You are making this way too hard for yourself
If you want to stop the queue but let the RAID system continue
processing the queue, then just sending I/O from whatever program you
are using to generate the load.  This won't let you start up with a
partially unflushed queue, but if for whatever reason you need to
measure effects of pending I/Os and timing, then you can obtain a
reasonably good simulation by increasing the queue depth and repeating
the test.

As for A way to get RAID (I assume software RAID, a la the md driver),
to get out of sync is to "remove" a disk drive.  If you are afraid to
crack the case, then use a cheap USB enclosure for one of the disks and
then turn it off or unplug the USB connector.  You can also "remove" a
disk by sending it a command to go into a self-test, perform a low-level
format, send a mode select to change the block size, there are lots of
ways if you think outside of the box.

All of these "failure" scenarios will interact differently, just turning
a disk drive off creates a real failure, not a quasi-emulated more
graceful failure that may be easier for you to time and measure the
effects.

Good luck.  

David @ santools.com


