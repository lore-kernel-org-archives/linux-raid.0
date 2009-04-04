From: "Lelsie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: RAID halting
Date: Sat, 4 Apr 2009 09:39:15 -0500
Message-ID: <20090404143918.VANQ19140.cdptpa-omta03.mail.rr.com@Leslie>
References: <1238850066.16200.51.camel@cichlid.com>
Reply-To: <lrhorer@satx.rr.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1238850066.16200.51.camel@cichlid.com>
Sender: linux-raid-owner@vger.kernel.org
To: 'Linux RAID' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> I think that's the filesystem buffering and then writing all at once.
> It's normal if it's periodic; they go briefly to ~100% and then back to
> ~0%?

Yes.

> > I don't know if this is ordinary
> > behavior for atop, but all the drives also periodically disappear from
> the
> > status display.
> 
> That's a config option (and I find the default annoying).

Yeah, me, too.

> sorts the drives by utilization every second which can be a little hard
> to watch. But if you have the problem I had then that one drive stays at
> the top of the list when the problem occurs.

No.

> I used:
> 
>   iostat -t -k -x 1 | egrep -v 'sd.[0-9]'
> 
> to get percent utilization and not show each partition but just whole
> drives.

Since there are no partitions, it shouldn't make a difference.
 
> For atop you want the -f option to 'fixate' the number of lines so
> drives with zero utilization don't disappear.

Well, diagnostically, I think the situation is clear.  All ten drives stop
writing completely.  Five of the ten stop reading, and the other five slow
their reads to a dribble - always the same five drives.

> Does the sata multiplier have it's own driver and if so, is it the
> latest? Any other complaints on the net about it? I would think a
> problem there would show up as 100% utilization though...

Multipliers - three of them, and no, they require no driver.  The SI
controller's drivers are included in the distro.

> And I think you already said the cpu usage is low when the event occurs?
> No one core at near 100%? (atop would show this too...)

Nowhere near.  Typically both cores are running below 25%, depending upon
what processes are running, of course.  I have the Gnome system monitor up,
and the graphs don't spike when the event occurs.  Of course, if there is a
local drive access process which uses lots of CPU horsepower, such as
ffmpeg, then when the array halt occurs, the CPU utilization falls right
off.

