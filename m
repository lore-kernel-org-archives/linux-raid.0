From: Bill Davidsen <tmrbill@tmr.com>
Subject: Re: Problems with software RAID + iSCSI or GNBD
Date: Wed, 29 Jun 2005 11:59:29 -0400 (EDT)
Message-ID: <Pine.LNX.4.44.0506291143030.27322-100000@firewall2.tmr.com>
References: <Pine.LNX.4.58.0506290918380.799@lewis.et.byu.edu>
Reply-To: davidsen@tmr.com
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.58.0506290918380.799@lewis.et.byu.edu>
Sender: linux-raid-owner@vger.kernel.org
To: David Dougall <davidd@et.byu.edu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 29 Jun 2005, David Dougall wrote:

> This discussion intrigues me.  I think there is a lot of merit to running
> a raid in this manner.  However, if I understand correctly, under normal
> circumstances reads from a Raid1 md device will always round-robin between
> the devices to increase performance.  Is there a way or what would need to
> be done to set a single component in the device to be the primary.  ie.
> don't read from the other device unless the first one fails.
> I think there was some discussion about this a month or so ago concerning
> ramdisk(which I don't know would be quite as useful), but the theory can
> apply to any block devices with significantly different speed/latencies,
> etc.
> Please advise.
> --David Dougall

It would be useful to prioritize device selection in mirrored arrays, such
that for reads one device would be used until the i/o queue had N entries,
then start using the next. It would even seem that the prioritization
could be set by the kernel, "by observation of seek and transfer times."
In the case of a connection via GigE I doubt the network time is an issue
compared to the physical processes. If the link is T1 between continents
it's an issue for big data, and if one end is connected via PPP over
dialup (looking at the worst case) you probably don't want to read over
the net unless the local device has flames coming out.

Other common cases like slow disk on a fast bus and a fast disk on a
slower bus might really mess up any auto tuning. The common case is a
laptop with a 5400 rpm PATA drive internal and a 7200 rpm fast seek drive
plugged into USB2.

I don't see a huge benefit unless there is a really slow network involved.  
Perhaps some developer could speak to the possibility of preferential
reads in general. I peeked at the code, and while it looks actually fairly
simple, it also feels as if it might have a lot of "unintended
consequences," and violations of Plauger's "Law of Least Astonishment."

-- 
bill davidsen <davidsen@tmr.com>

