From: Matt Garman <matthew.garman@gmail.com>
Subject: Re: Use of WD20EARS with MDADM
Date: Fri, 26 Mar 2010 16:45:43 -0500
Message-ID: <20100326214543.GA29503@septictank.raw-sewage.fake>
References: <4BAB8D41.4010801@gmail.com> <4BAD18A5.1080905@kieser.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4BAD18A5.1080905@kieser.ca>
Sender: linux-raid-owner@vger.kernel.org
To: Peter Kieser <peter@kieser.ca>
Cc: Andrew Dunn <andrew.g.dunn@gmail.com>, Mdadm <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Fri, Mar 26, 2010 at 01:27:17PM -0700, Peter Kieser wrote:
> The 4096-byte sector drives work fine with mdadm. The main problem
> you are going to run into with the WDC Green drives is their 8
> second "idle" setting. After 8 seconds, by default, the drive
> parks its heads. This can lead to an amazingly high Load Cycle
> Count (LLC) after just a month of operation due to the fact that
> most disk access happens around that time causing the drive to
> park and unpark in repeated cycles.

For what it's worth... that head parking feature actually saves a
measurable amount of power.  On my system, with four drives, there
is about a 10 watt (AC) difference between all four heads parked and
all four heads non-parked.  This finding is consistent with the
power numbers suggested by SilentPCReview's reviews of these drives.

> To fix this, find a utility called wdidle3 (I have it, if you are
> unable to locate it) and set the idle timeout on the drives to 300
> seconds.  These drives do not support TLER, there is no ability to
> set it via firmware anymore - WDC removed this ability sometime
> last year.

This will prevent the rapidly increasing Load Cycle Count SMART
counter.  However, in my opinion, it also removes a useful
power-saving feature of these drives.  In other words, my system is
mostly idle; I want the heads to be parked the majority of the time.
Instead, without the wdidle3 hack, they constantly park/unpark
despite an otherwise idle system.

Here's the problem I've been unable to solve: if my system is truly
idle for, say 10 minutes, then why don't my heads stay parked for 10
minutes?  It appears that the heads will park, then five minutes
later, *something mysterious* will cause them to unpark.

I did some experimenting with this several months ago.  See the
list archives for August 20, 2009, subject "linux disk access when
idle"[1].

As far as I can tell, I disabled every single daemon on my system,
but still could not get the heads to park for more than five
minutes.

My point in all this is: I'd rather tune my software (Linux) to work
better with my hardware, rather than remove what I consider to be a
useful power-saving feature.  I haven't re-visisted this in a while,
but last time I tried, I couldn't find the guilty daemon or kernel
setting responsible for the constant head un-parking.

[1] http://marc.info/?l=linux-raid&m=125078611926294&w=2

-Matt

