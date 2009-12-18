From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: RAID5 / 6 Growth
Date: Thu, 17 Dec 2009 19:46:30 -0600
Message-ID: <FE.2C.04641.7FEDA2B4@cdptpa-omtalb.mail.rr.com>
References: <4B2A7005.7030409@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4B2A7005.7030409@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: 'Bill Davidsen' <davidsen@tmr.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> > High enough?  Wouldn't a higher speed limit mean more stress on the
> systems?
> > Its value is 1000.
> >
> >
> >> MB/s) along with /proc/sys/dev/raid/speed_limit_max?
> >>
> >
> > It's 200,000
> >
> >
> What are you actually seeing for rebuild speed? Pushing the min up

	About 5 Mbps read per drive and 3.8 MBps write per drive.  With NCQ
enabled, I was getting about 35MBps reads during the resync.  With NCQ
disabled, I was getting about 25 MBps reads.

> shouldn't matter with the max set high, but if you're not getting
> something like 200MB rebuild there's an issue of some kind. What's the
> stripe cache size?

Linux reports 256 on both systems.

