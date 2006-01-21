From: Mark Hahn <hahn@physics.mcmaster.ca>
Subject: Re: Save to use spindown?
Date: Sat, 21 Jan 2006 16:32:58 -0500 (EST)
Message-ID: <Pine.LNX.4.44.0601211616510.24057-100000@coffee.psychology.mcmaster.ca>
References: <Pine.LNX.4.56.0601212009570.20336@lion.drogon.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.56.0601212009570.20336@lion.drogon.net>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> > accessed for days, so I wonder if I can extend the life of the disks
> > by spinning them down, eg by setting the spindown timeout for the

you seem to be assuming that the drives have a lifespan measured 
in hours-spinning.  that's not at all clear.  for instance, drives
are typically rated 40-50K start-stop cycles, which is ~40/day
over a 3-year service life.

you clearly do not want to auto-spindown unless you are sure that 
they'll spun-down for a fairly long time.  even ignoring delay in 
spinup...


> that good. Too many things running on your server will keep them going -
> eg. ext3 likes to peek at the drives every 5 seconds (and it's probable
> that other journaling FS's to some extent or other).

I don't believe ext3 will generate journal forces unless you do something
that generates data or journal IO.  for instance, atime updates are often
overlooked here.  I generally turn atime stuff off anyway.

> Then there's
> log-files - you'll need to go through syslog.conf and "-" every file to
> suppress the fflush.

often a good idea anyway, especially if your server generates lots of logs.
or how about logging to some other machine (which has additional advantages...)

> And then the kernel just wants to flush its buffers
> from time to time because it's in a good mood.

for some reason I don't tend to anthropomorphize the kernel ;)
but really, I can't think of any random, spontaneous flushes.
things like dirty pagecache stuff will get pdflushed on a clear 
schedule (/proc/sys/vm/*centiseconds).

